IAM Policy Configuration
========================

A GitHub Actions worker that manages a GitHub organization via the `GitHub Control repository <https://github.com/infrahouse8/github-control>`_ needs an AWS credentials with certain permissions.
By the principle of least privilege the permissions depend on what the worker is supposed to do.


Working with Terraform State
----------------------------

The worker works with the Terraform state in S3. Therefore it need all privileges to read and write to the state file.
Plus, Terraform itself (AWS provider to be accurate) also tries to list files in a states bucket.
That yields following requirements:

- ``s3:PutObject``
- ``s3:GetObject``
- ``s3:DeleteObject``
- ``s3:ListBucket``

The repository doesn't use Terraform state locking at the moment.
If it did, additional privileges would be needed to work with a DynamoDB table.

The following permissions should be scoped to the state bucket.
If the bucket is shared with other state files, the scope should be reduced to the state file.
However we find a dedicated bucket for a particular Terraform module more flexible.

Working with Terraform Plan
---------------------------

In the :ref:`ci-cd-doc-label` document it is explained how and why
the Terraform state should be saved during a CI stage and available in the CD stage.
Therefore the AWS user should be able to upload (``s3:PutObject``), download (``s3:GetObject``),
and delete (``s3:DeleteObject``) the plan file.

We re-use the states bucket to store the plan file, so the permission given for working with the state file will suffice for the plan exchange.

Working with Secrets
--------------------

Some repositories should have access to certain secrets.
For example, a Python application repository should have access to the PyPI token so it can publish packages.

Permissions required to work with the Secrets manager:

- ``secretsmanager:CreateSecret``
- ``secretsmanager:DescribeSecret``
- ``secretsmanager:GetResourcePolicy``
- ``secretsmanager:GetSecretValue``

To limit resources the AWS user can read the secrets must start with a prefix ``_github_control__``.
Then the policy can limit the scope of the permissions rule to :

.. code-block:: json

    "Resource": [
        "arn:aws:secretsmanager:*:990466748045:secret:_github_control__*"
    ]

Final IAM Policy
----------------

.. code-block:: json
    :caption: arn:aws:iam::990466748045:policy/TFAdminForGitHub

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:DeleteObject"
                ],
                "Resource": [
                    "arn:aws:s3:::infrahouse-github-state/*"
                ]
            },
            {
                "Effect": "Allow",
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::infrahouse-github-state"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "secretsmanager:CreateSecret",
                    "secretsmanager:DeleteSecret",
                    "secretsmanager:DescribeSecret",
                    "secretsmanager:GetResourcePolicy",
                    "secretsmanager:GetSecretValue"
                ],
                "Resource": [
                    "arn:aws:secretsmanager:*:990466748045:secret:_github_control__*"
                ]
            }
        ]
    }
