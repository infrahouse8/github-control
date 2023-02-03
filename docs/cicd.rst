Continuous Integration and Deployment (CI/CD)
=============================================

The `GitHub Control <https://github.com/infrahouse8/github-control>`_ is a Terraform live repository [#]_.
The Continuous Integration part of the workflow ensures that a proposed change is syntactically correct and it prepares the ``terraform plan`` output for the code review.
The Continuous Deployment part of the workflow applies the suggested change i.e. runs ``terraform apply``.

The document describes how CI/CD is implemented in `GitHub Control <https://github.com/infrahouse8/github-control>`_.

GitHub Actions
--------------

GitHub Actions acts as execution engine for the `GitHub Control <https://github.com/infrahouse8/github-control>`_'s CI/CD.
GitHub Actions workers run both ``terraform plan``, ``terraform apply``, linters, and other commands.
Even though GitHub Actions is tightly integrated with GitHub itself,
the worker still needs a GitHub token so the `GitHub provider <https://registry.terraform.io/providers/integrations/github/latest/docs>`_ can access the GitHub organization and make appropriate changes.
Besides the GitHub token the workers need AWS credentials to work with the Terraform state file.

Repository settings
-------------------

In the context of the CI/CD the most important part of the repository configuration is branch protection.
The default branch (that happens to have the name "main") needs to be "protected".

Code review rules
~~~~~~~~~~~~~~~~~

Normally you want to require a code review for a pull request.
There is only one user in `GitHub Control <https://github.com/infrahouse8/github-control>`_, so only pull requests are required.
It means direct pushes to the main branch are not allowed.

.. figure:: docs/_static/codereview.png
    :alt: Code review settings

    Code review settings.


Status check rules
~~~~~~~~~~~~~~~~~~

A "Terraform Plan" check runs ``terraform plan``, so we want to enable it.

**Require branches to be up to date before merging** is especially important when it comes to Terraform repositories.
It requires a pull request to include all known commits from the default branch.
If this option is not set, a user may unintentionally destroy resources created in recent commits.

.. figure:: docs/_static/branchprotect.png
    :alt: Code review settings

    Status checks settings.

Continuous Integration
----------------------

A workflow defined in ``.github/workflows/terraform-plan.yml`` triggers on a new pull request or any updates in it.
Among other trivial steps like running a linter and checking code style there are two important steps.

.. code-block:: yaml
    :caption: Step 1. terraform plan.

    # Generates an execution plan for Terraform
    - name: Terraform Plan
    run: terraform plan -input=false -out=${{ github.event.pull_request.number }}.plan

Not only the step runs ``terraform plan`` but it also saves the plan in a file.
The plan file will be used by Continuous Deployment.

.. code-block:: yaml
    :caption: Step 2. Save the plan.

    # Upload Terraform Plan
    - name: Upload Terraform Plan
    run: aws s3 cp "${{ github.event.pull_request.number }}.plan" "s3://${{ vars.STATES_BUCKET }}/pending/${{ github.event.pull_request.number }}.plan"

This step upload the plan file to an S3 bucket. The plan is identified by a pull request number.


Continuous Deployment
---------------------

The deployment workflow is defined in ``.github/workflows/terraform-deploy.yml``.
It is triggered when a pull request is closed.

.. code-block:: yaml
    :caption: Trigger condition.

    on:  # yamllint disable-line rule:truthy
      pull_request:
        types:
          - closed

Why not on a push to the default branch?
The matter is we need to know what pull request is being merged into the main branch.
In a context of the push event there is no a pull request number and we need it to download the plan.

.. code-block:: yaml
    :caption: Download the plan.

    # Download a plan from the approved pull request
    - name: Download plan
    run: aws s3 cp s3://${{ vars.STATES_BUCKET }}/pending/${{ github.event.pull_request.number }}.plan tf.plan

When the plan is downloaded, the worker can execute it:

.. code-block:: yaml
    :caption: Execute the plan.

    # Execute the plan
    - name: Terraform Apply
    run: terraform apply -auto-approve -input=false tf.plan

Thus ``terraform apply`` applies only approved plan exactly as it was shown in the pull request.


.. [#] There are two kinds of Terraform repositories: a live repository and a module repository.
    The live repository contains the Terraform code and creates real resources.
    The module repository contains a Terraform module code.
    The module code is supposed to be used in other live repositories.