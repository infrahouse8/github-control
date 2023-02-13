Managing Secrets for GitHub
===========================

CI/CD workflows in GitHub repositories sometimes need access to third-party services.
For example, a Python application repository needs a PyPI token to publish packages.

This document explains how `GitHub Control repository <https://github.com/infrahouse8/github-control>`_ organizes secrets storage and distribution.

.. _secrets_workflow:
.. figure:: docs/_static/secrets-workflow.png
    :alt: Secrets flow

    Secrets flow.

Secrets Storage
---------------

Even though there are many solutions for secrets storage, practically only two are available for `GitHub Control <https://github.com/infrahouse8/github-control>`_ out of box.
One is `Encrypted Secrets <https://docs.github.com/en/actions/security-guides/encrypted-secrets>`_ in GitHub itself.
Another is `AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`_.

Both systems store secrets securely, with strong encryption and access control.
Naturally, `AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`_ is better integrated with other AWS services.
It allows finer control on what should have access to the secrets and has important features like secrets rotation, secrets versions, etc.
We will need these features in future, so `AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`_ is going to be the choice for `GitHub Control <https://github.com/infrahouse8/github-control>`_.

For better secrets organization it is better to have one system for storing secrets.
Then it's only one source of truth for secrets, less room for data corruption when two systems by accident store the same secret.
It'll make managing secrets simpler.


Secrets Workflow.
-----------------
At :numref:`secrets_workflow` there are three Terraform "actions" and one manual entry. Let's review what each does.

Create Secret 1️⃣
~~~~~~~~~~~~~~~~~

A terraform resource `aws_secretsmanager_secret <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret>`_ creates a secret.
It is important to note it doesn't create a value for the secret (there is `aws_secretsmanager_secret_version resource <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version>`_ for that).
It's just a resource to manager the secret's metadata like a description, or an encryption key.

.. code-block:: terraform

    resource "aws_secretsmanager_secret" "pypi_api_token" {
      provider                       = aws.uw1
      name                           = "_github_control__PYPI_API_TOKEN"
      description                    = <<-EOT
    Token for "GitHub Publishing"
    Permissions: Upload packages
    Scope: Entire account (all projects)
    Created in https://pypi.org/manage/account/
    EOT
      force_overwrite_replica_secret = true
      recovery_window_in_days        = 0
    }

Enter Secret Value
~~~~~~~~~~~~~~~~~~
At this point the secret is created, but it doesn't have any value.
When you try to retrieve it from the Web UI you'll get an error:

.. figure:: docs/_static/retrieve-error.png
    :alt: A retrieve error

    A retrieve error.

The same form suggests you to "Set secret value". Let's do that to proceed to the next action.

.. figure:: docs/_static/set-secret-value.png
    :alt: Set secret value

    Set secret value.

Now the secret contains a value and it can be retrieved.

.. figure:: docs/_static/retrieve-ok.png
    :alt: The retrieved secret

    Successful read.


Read Secret in Terraform 2️⃣
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now we need to read the secret value in Terraform. The way to do it is to use a `aws_secretsmanager_secret_version data source <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version>`_.

.. code-block:: terraform

    data "aws_secretsmanager_secret_version" "pypi_api_token" {
      secret_id = aws_secretsmanager_secret.pypi_api_token.id
    }

Create GitHub Action Secret 3️⃣
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We got the secret value from the secrets manager. Now we can use it wherever the secret is needed.
In this particular example, we need a Python application repository to have access to the PyPI token in GitHub Actions,
so the CD workflow could publish packages.

.. code-block:: terraform

    resource "github_actions_secret" "pypi_api_token" {
      repository      = "infrahouse-toolkit"
      secret_name     = "PYPI_API_TOKEN" ## Note: not the same name as in aws_secretsmanager_secret.pypi_api_token
      plaintext_value = data.aws_secretsmanager_secret_version.pypi_api_token.secret_string
    }

It is worth to note there are more than one repositories that would need the PyPI token.

Secrets rotation
----------------

With this secrets workflow the rotation becomes a trivial task.

We update the secrets in the AWS Secrets Manager either in the WebUI or with a CLI tool.

The next ``terraform apply`` in the GitHub Control will update the secret in all repositories where it's needed.
