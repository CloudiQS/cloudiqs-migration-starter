---
inclusion: always
---
# Engagement Context — Acme Outdoor Supplies cloud exit

> Derived from the Workload Migration SSB (SDD) for this engagement. General AWS guidance for this migration pattern, read automatically on every turn. The full SDD remains queryable for any passage needing more than this summary; `ssb/evidence-index.md` is the address map, not a quotable source.

## Deployment tiers and upgrade triggers

Base tier: single AWS account, one DataSync task, one S3 destination bucket, two IAM roles, CloudWatch metrics — operational in under 30 minutes. `ssb/workload-migration/sdd.md`, `## Source page 9`: "the base tier provides adequate security, observability, and operational control for SMB-scale migrations without enterprise-grade complexity."

Enhanced tier adds AWS Control Tower (minimum four accounts) only when a concrete trigger is present: regulatory compliance (PCI DSS, ISO 27001, SOC 2), data residency mandates, quota exhaustion approaching 80% of the 100-tasks-per-account ceiling, credential isolation across business units, or per-account cost allocation.

## Encryption defaults

Destination-side re-encryption under AWS KMS is the default. `## Source page 5`: "The default pattern for SMB cloud-to-cloud workloads is destination-side re-encryption under AWS KMS." Imported key material and CloudHSM-backed keys are reserved for engagements where a compliance framework explicitly requires key continuity or hardware-level isolation.

## Credential handling

Source-cloud credentials are separate from AWS-side IAM and have their own scoping, rotation, and audit trail. `## Source page 5`: SAS tokens for Azure Blob Storage, source-cloud service principals for the AWS Replication Agent, and source database service accounts for AWS DMS "each have source-cloud-specific scoping, rotation, and audit-logging considerations that the partner addresses during source readiness." AWS CloudTrail covers AWS-side activity only; source-cloud audit logs are a separate trail.

## Connectivity defaults

`## Source page 3`: "Public internet with Transport Layer Security (TLS) encryption is the default and simplest connectivity path, appropriate for most SMB transfers at this scale." All three services encrypt in transit (TLS 1.3 with mTLS) regardless of path. AWS Site-to-Site VPN is the private-connectivity alternative when traffic isolation is required; Direct Connect and partner interconnects are out of scope for this SMB architecture.

## Egress-cost framing

`## Source page 8`: "Source cloud egress charges represent the dominant cost component of any cross-cloud migration — often exceeding DataSync service fees by five to six times for a typical 50 TB transfer." AWS inbound transfer is always free. Azure and GCP free-egress exit programs are the single highest-impact cost lever and must be engaged before any transfer begins; they are a direct commercial relationship between the customer and the incumbent provider, not something this architecture provides.

## This Customer

**Correction (Module 1 Step 5, participant-reviewed):** the sections above describe the SSB's general guidance for this migration pattern, profiled at 10–50 servers with an implied dedicated migration/operations team across a multi-account landing zone. None of that holds for Acme. Acme has three VMs and two generalists (the Infrastructure Lead and the Applications Lead, per R4 — the target must be operable by two generalists without continuous platform administration). Read every tier, triggers, and operational section above against that reality: single-account base tier, AWS-managed services rather than self-managed infrastructure, and runbooks written so two generalists can execute and recover a migration without becoming platform specialists.

- Deployment tier: **base, single account — confirmed** (Module 1 Step 4). No PCI DSS/ISO 27001/SOC 2, data-residency, quota-exhaustion, or credential-isolation trigger is present for Acme.
- Cost allocation: R5 (AWS run cost visible by workload) is met with per-workload cost allocation tags on the base-tier resources, not a landing-zone-level cost tool.
- Data classification: dispatch data includes delivery addresses and customer contact details (per the brief); no formal data-classification assessment exists. `[OPEN]` — owner: Managing Director.
- Encryption: destination-side KMS re-encryption default stands; no compliance driver requiring CloudHSM or imported keys has surfaced.
- Credentials: Azure service principal / SAS scoping for dispatch-blob, dispatch-db, and reporting-db — not yet confirmed. `[OPEN]`
- Connectivity: public internet is the assumed default; the warehouse scanners share the same site internet link all day (R3), which this file's general connectivity guidance does not mention on its own — any migration traffic plan here must account for that shared link, not just cite the TLS default.
- Egress: Azure free-egress exit program eligibility — not yet confirmed; R5's cost validation depends on this. `[OPEN]`
