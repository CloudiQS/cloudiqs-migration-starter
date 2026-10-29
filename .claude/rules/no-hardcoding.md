# No hardcoding

Never write literal values for: region, account ID, ARN, hostname, IP or CIDR, instance or class sizes, engine or version pins, timeouts, feature flags, bucket names, or any credential.

Sources, in order: CloudFormation parameters; `engagements/<e>/configs/*.env` (identifiers only, gitignored); Parameter Store (`/cq/<engagement>/...`); Secrets Manager (`cq/<engagement>/...`) read in memory at run time.

Allowed literals: protocol ports defined by the engine (3306 for MySQL) and AWS-managed policy names, each with a comment.
