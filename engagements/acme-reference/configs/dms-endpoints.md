# T3 — DMS source/target endpoint configuration

## Source (lab-executed)

Published by the source-simulation stack as SSM parameters — read, never modified:

| Parameter | Value |
|---|---|
| `/migration-workshop/source/mysql_endpoint` | `<private-ip>` |
| `/migration-workshop/source/mysql_port` | `3306` |
| `/migration-workshop/source/mysql_secret_arn` | `<arn-redacted>` |

## Target

From `acme-target` stack outputs (T7, `CREATE_COMPLETE` 2026-10-29T18:35:35Z):

| Output | Value |
|---|---|
| `DbEndpoint` | `<rds-endpoint>` |
| `DbPort` | `3306` |
| `DbSecretArn` | `<arn-redacted>` |
| `AppUrl` | `http://<private-ip>:8080` |
| `DmsReplicationInstanceArn` | `<arn-redacted>` |

## Mobilize value (record, do not substitute)

Acme's real Azure Database for MySQL hostname: `[OPEN]` — not in the discovery export or the Module 2 interview; only the engine, size, and TPS figures were captured. Owner: Infrastructure Lead. This lab's source endpoint above stands in for it and must never be reported as Acme's real endpoint.
