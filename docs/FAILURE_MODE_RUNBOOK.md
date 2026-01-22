# Failure Mode Runbook: Sovereign Deployment Pipeline

## Purpose
Diagnostic procedures and resolution steps for deployment integrity failures.

---

## Quick Reference Index

| Symptom | Likely Cause | Section |
| --- | --- | --- |
| Audit hash mismatch | CDN propagation / local drift | FM-001 |
| Git push rejected | Auth or divergent history | FM-002 |
| Remote fetch fails | DNS / connectivity | FM-003 |
| Hash generation failure | Missing build / permissions | FM-004 |
| Deployment timeout | Build or platform issue | FM-005 |
| Make failure | Missing make / syntax | FM-006 |

---

## FM-001: Audit Hash Mismatch

**Symptom**
```
❌ INTEGRITY BREACH DETECTED
Local:  <hash>
Remote: <hash>
```

**Resolution**
1. Check CDN propagation: wait 60s and rerun `make audit`.
2. Verify local build: `shasum -a 256 _site/index.html`.
3. Confirm git head: `git log -1 --format="%H %s"`.
4. If mismatch persists, redeploy: `make deploy`.

---

## FM-002: Git Push Failure

**Symptom**
```
! [rejected] main -> main (fetch first)
```

**Resolution**
1. `git fetch origin main`
2. `git rebase origin/main`
3. `git push origin main`

If auth failure:
```
ssh -T git@github.com
```
Re-add SSH key if needed.

---

## FM-003: Remote Fetch Failure

**Symptom**
```
curl: (6) Could not resolve host
```

**Resolution**
1. `dig timothywheels.com +short`
2. If empty, DNS is still propagating.
3. If IP present, test endpoint:
   `curl -I https://timothywheels.com`

---

## FM-004: Hash Generation Failure

**Symptom**
```
_site/index.html: No such file or directory
```

**Resolution**
1. Rebuild site output.
2. Confirm `_site/index.html` exists.
3. Retry `make audit`.

---

## FM-005: Deployment Timeout

**Symptom**
```
deployment exceeded maximum duration
```

**Resolution**
1. Check Vercel build logs.
2. Remove large assets from build.
3. Redeploy after build succeeds.

---

## FM-006: Make Execution Failure

**Symptom**
```
make: command not found
```

**Resolution**
1. Install build tools.
2. Verify Makefile tabs (must be tabs, not spaces).
3. Run `make -n deploy` to validate.

---

## Logging Standard
After every incident, append:
```
## <UTC timestamp> - [FM-XXX]
Symptom: <description>
Root Cause: <cause>
Resolution: <steps>
Prevention: <follow-up>
```

---

## Preventive Maintenance
- Daily: `make audit`
- Weekly: review SOVEREIGN_LOG.md
- Monthly: rotate credentials and verify DNS records
