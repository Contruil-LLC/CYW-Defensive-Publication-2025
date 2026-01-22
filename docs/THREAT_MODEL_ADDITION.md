# Threat Model Addition (For SOVEREIGN_CERTIFICATE.md)

## Threat Model

### Security Objective
Provide cryptographic assurance that deployed content matches authored content.

### Trust Boundaries
- **Trusted:** Local repo and signed commits
- **Partially trusted:** Build/deploy platform (Vercel)
- **Untrusted:** Public CDN and internet path

### Attack Vectors and Mitigations

| Vector | Mitigation |
| --- | --- |
| CDN cache poisoning | Remote audit compares hashes |
| Supply chain injection | Dependency pinning + audit |
| Unauthorized commit | SSH auth + commit history |
| DNS hijack | Post-propagation audit |
| Content drift | Regular audit checks |

### Detection vs Prevention
System is **detective**: it detects tampering quickly and halts deployment flow.

### Incident Response (Short)
1. Capture local vs remote hashes  
2. Re-run audit after CDN buffer  
3. Roll back if mismatch persists  
4. Log incident in SOVEREIGN_LOG.md

### Revision
2026-01-22: Initial threat model addition
