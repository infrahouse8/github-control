.. image:: https://readthedocs.org/projects/github-control/badge/?version=latest
    :target: https://github-control.readthedocs.io/en/latest/?badge=latest
    :alt: Documentation Status

GitHub Control
==============
The `GitHub Control <https://github.com/infrahouse8/github-control>`_ repository manages the `InfraHouse <https://github.com/infrahouse>`_ GitHub organization.
The repository uses `GitHub Terraform provider <https://registry.terraform.io/providers/integrations/github/latest/docs>`_ to define organization settings, repositories, and everything else supported by the provider.
It is the configuration source of truth.
If anything needs to be changed, including adding a new repository, the change should be made in this repository.
Changes made outside of the repository may be reverted.
Continuous Integration and Deployment (CI/CD) is configured for this repository.


.. admonition:: **See also**

    A `cookiecutter template <https://github.com/infrahouse/cookiecutter-github-control>`_ is available
    to create a Terraform repository with CI/CD to manage a GitHub organization.

Out of Band Management
----------------------

A GutHub user `infrahouse8 <https://github.com/infrahouse8>`_ and the `InfraHouse <https://github.com/infrahouse>`_ organization are separated from each other.
`infrahouse8 <https://github.com/infrahouse8>`_ is an owner of the `InfraHouse <https://github.com/infrahouse>`_ organizations.
The `GitHub Control <https://github.com/infrahouse8/github-control>`_ repository is hosted under `infrahouse8 <https://github.com/infrahouse8>`_.
This way ensures the out-of-band management of the organization.
Only `infrahouse8 <https://github.com/infrahouse8>`_ has admin privileges in the `InfraHouse <https://github.com/infrahouse>`_ organization.
All other members of the organization will have "member" privileges only.

.. figure:: docs/_static/infrahouse8-user.png
    :align: center
    :alt: relationship between infrahouse8 and InfraHouse

    Relationship between `infrahouse8` user and `InfraHouse` organization.

Workflow
--------

When a user wants to make a change in InfraHouse GitHub configuration they should submit a pull request into the ``main`` branch.
Once the pull request is created, GitHub Actions worker will run a set of checks.
The checks include executing ``terraform plan``, linter, and other tests that are included now or will be included in future.
A failed check will block the pull request from merging.

Once the pull request is merged, GitHub Actions runs ``terraform apply`` to implement new changes.

.. figure:: docs/_static/workflow.png
    :align: center
    :alt: repository workflow

    Repository workflow.

Input secrets
-------------
The repo needs a set of inputs available for in the pull request stage as well as for deployment.

Secrets
~~~~~~~
Defined in https://github.com/infrahouse8/github-control/settings/secrets/actions.

``GH_TOKEN``
    Personal token of a user `infrahouse8 <https://github.com/infrahouse8>`_.
    Created in https://github.com/settings/tokens.
