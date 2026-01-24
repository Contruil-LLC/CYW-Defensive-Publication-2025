# Failure Mode Runbook: Sovereign Deployment Pipeline

## Purpose
Operational troubleshooting guide for deployment integrity, availability, and provenance. This runbook mirrors RME diagnostic practice: identify symptoms, isolate layers, and restore service with evidence.

## RME Analogy: Vercel Routing = Conveyor Jam Logic
- **Routing rules** are the conveyor pathing map.
- **404 at root** is a jam at the first divert—items never reach the correct lane.
- **Mislinked project** is the wrong line assignment—work is flowing, but to the wrong destination.
- **Fix** is clearing the obstruction (rewrite), confirming correct line (project link), and restarting flow (redeploy).

## RME Analogy: 404/401 = QC Rejection / Access Control Failure
- **404 Not Found** is a QC reject: the item fails inspection because the expected part isn't on the line.
- **401 Unauthorized** is access control: the part exists, but the gate won't open without credentials.
- **Fix** is either supplying the correct part (route/file) or providing authorization (disable protection or bypass).

## RME Analogy: Hash Verification = PM Inspection Checkpoints
- **SHA-256 hash** is the PM spec: the required measurement for integrity.
- **`make audit`** is the inspection gate: it compares live output to spec before release.
- **Mismatch** is a failed PM check: stop the line, isolate cause, then resume.

## RME Analogy: Deployment Pipeline = Production Line Flow
- **Source update** is the work order.
- **Build/commit** is assembly completion.
- **Deploy** is line release to shipping.
- **Audit** is outbound QC before customer receipt.

---

## Quick Reference Index

| Symptom | Likely Cause | Section |
| --- | --- | --- |
| Audit hash mismatch | CDN propagation, stale deploy, local drift | FM-001 |
| Git push rejected | Divergent history or auth failure | FM-002 |
| Remote fetch fails | DNS, CDN, or TLS issue | FM-003 |
| Local hash failure | Missing file or path change | FM-004 |
| Deployment blocked | Vercel routing/config errors | FM-005 |
| Make failure | Missing tools or Makefile errors | FM-006 |
| 404 on root | Routing config or wrong project | FM-007 |
| 401 on deployment | Protection enabled | FM-008 |

---

## Common Failure Patterns (Indexed)

| Pattern ID | Pattern | Primary Signal | Typical Root Cause |
| --- | --- | --- | --- |
| P-01 | **Stale deploy** | `make audit` mismatch after push | CDN propagation lag |
| P-02 | **Wrong project** | 404 on root with successful deploy | Mislinked Vercel project |
| P-03 | **Routing conflict** | Vercel config validation error | Mixed `routes`/`rewrites` |
| P-04 | **Protection gate** | 401 with `x-vercel-error: PROTECTED` | Auth enabled in prod |
| P-05 | **Local drift** | Hash mismatch + dirty `git status` | Uncommitted changes |
| P-06 | **DNS drift** | `dig` empty or incorrect IP | DNS not propagated/incorrect |
| P-07 | **Missing root** | `index.html` not found | File moved or deleted |

---

## Immediate Containment (Halt + Rollback)

**When to halt:** Any integrity breach (hash mismatch), unknown deployment state, or 4xx/5xx at root.

**Containment steps**
1. **Stop propagation:** do not push further commits until the cause is isolated.
2. **Freeze deploys:** pause automation or avoid `make deploy` until verified.
3. **Rollback if public impact:**
   - `git revert HEAD --no-edit`
   - `git push origin main`
   - wait 30–60s, then `make audit`

**Verification gate**
Only resume normal deployment once `make audit` returns **DEPLOYMENT INTEGRITY VERIFIED**.

---

## Escalation Triggers (Involve Senior Engineers)

Escalate immediately if any of the following occur:
- **Repeated integrity failures** after two redeploy attempts.
- **Persistent 404/401** for more than 30 minutes after verified deploy.
- **Git history risk** (force-push request, conflicting rewrites, or lost commits).
- **Security signal** (suspicious access, unexpected domain changes, or cert anomalies).
- **Unknown root cause** after completing the decision tree for the failure mode.

Provide in escalation:
- Latest `make audit` output
- Current git commit hash and status
- Vercel deployment URL + build log snippet
- Timeline of actions taken

---

## Recovery Verification (Post-Fix Validation)

Use this checklist after any fix or rollback:
1. `git status -sb` shows clean working tree.
2. `git log -1 --oneline` matches intended deploy commit.
3. `curl -I https://timothywheels.com/` returns **200**.
4. `make audit` returns **DEPLOYMENT INTEGRITY VERIFIED**.
5. Record the incident in `SOVEREIGN_LOG.md`.

If any step fails, return to the relevant failure mode and re-run the decision tree.

---

## 5-Why Examples (Root Cause Discipline)

### Example A: Root 404 on Production
1. **Why** is the root returning 404?  
   Because Vercel is not serving `index.html`.
2. **Why** isn’t `index.html` being served?  
   Because routing rules were misconfigured.
3. **Why** were routing rules misconfigured?  
   Because `routes` and `rewrites` were mixed.
4. **Why** were both used together?  
   Because the config was copied from different templates.
5. **Why** was the template mismatch not caught?  
   Because no pre-deploy config validation existed.

**Corrective action:** enforce a single routing strategy and add a pre-deploy config check.

### Example B: Audit Hash Mismatch
1. **Why** did the audit fail?  
   Remote hash differed from local hash.
2. **Why** were hashes different?  
   CDN served stale content.
3. **Why** did the CDN serve stale content?  
   Deployment propagated slowly to the edge.
4. **Why** was propagation slow?  
   Cache invalidation lagged behind deploy.
5. **Why** wasn’t the lag accounted for?  
   Audit was run immediately after push.

**Corrective action:** add a wait window or retry loop before final audit.

---

## FM-001: Audit Hash Mismatch

**Symptom**
```
❌ INTEGRITY BREACH DETECTED
Local:  <hash>
Remote: <hash>
```

**Diagnostic**
1. Wait 60–120 seconds for CDN propagation; rerun `make audit`.
2. Verify local source hash: `shasum -a 256 index.html`.
3. Confirm git head: `git log -1 --format="%H %s"`.

**Observable Indicators**
- `make audit` output shows local/remote hashes differ.
- Vercel deployment shows latest commit but CDN still serves old content.
- User report: "Site looks outdated" or "content doesn't match repo".

**Decision Tree**
```
Hash mismatch?
├─ Local hash matches HEAD? -> yes
│  ├─ Remote hash matches HEAD? -> yes -> Re-run audit after 60s
│  └─ Remote hash matches HEAD? -> no  -> Redeploy (vercel --prod)
└─ Local hash matches HEAD? -> no
   ├─ Uncommitted changes? -> yes -> Commit + push
   └─ Uncommitted changes? -> no  -> Restore index.html from git
```

**Root Cause**
- Local drift: `git status -sb` shows uncommitted changes.
- Stale deploy: Vercel is serving a previous commit.
- CDN delay: edge cache lagging behind origin.

**Resolution**
1. If local drift, commit and push changes.
2. Trigger redeploy (CLI): `vercel --prod`.
3. Re-run `make audit` until hashes match.

---

## FM-002: Git Push Failure

**Symptom**
```
! [rejected] main -> main (fetch first)
```

**Diagnostic**
1. `git fetch origin main`
2. `git status -sb` (confirm branch divergence)

**Observable Indicators**
- Git output: `rejected (fetch first)` or `non-fast-forward`.
- GitHub shows new commits not in local branch.
- User report: "Push is blocked" or "permission denied".

**Root Cause**
- Divergent history between local `main` and `origin/main`.

**Resolution**
1. `git rebase origin/main`
2. `git push origin main`

**Auth Failure Check**
```
ssh -T git@github.com
```
If denied, re-add SSH key and retry.

---

## FM-003: Remote Fetch Failure

**Symptom**
```
curl: (6) Could not resolve host
```

**Diagnostic**
1. `dig timothywheels.com +short`
2. If empty, DNS is still propagating.
3. If IP present, test endpoint:
   `curl -I https://timothywheels.com`
4. If TLS error, verify certificate expiry and system time.

**Observable Indicators**
- `curl` error: `Could not resolve host` or TLS handshake failure.
- Browser shows DNS_PROBE_FINISHED_NXDOMAIN or certificate warning.
- Status page/edge logs show unavailable host.

**Decision Tree**
```
Remote fetch fails?
├─ DNS resolves? -> no  -> Wait/repair DNS
└─ DNS resolves? -> yes
   ├─ TLS error? -> yes -> Fix system time/cert
   └─ TLS error? -> no
      ├─ HEAD returns 200? -> yes -> Retry full GET
      └─ HEAD returns 200? -> no  -> Check Vercel deploy status
```

**Root Cause**
- DNS not propagated or incorrect records.
- TLS handshake failure due to cert or clock issues.

**Resolution**
1. Wait for DNS propagation or correct DNS records.
2. Re-test after 5–10 minutes.

---

## FM-004: Local Hash Failure

**Symptom**
```
index.html: No such file or directory
```

**Diagnostic**
1. Confirm file exists: `ls -la index.html`.
2. Rebuild or restore the root file.
3. Retry `make audit`.

**Observable Indicators**
- `make audit` reports `index.html: No such file or directory`.
- Local repo root missing `index.html`.
- User report: "Local file missing after cleanup".

**Root Cause**
- File moved, deleted, or incorrect working directory.

**Resolution**
1. Restore `index.html` to repo root.
2. Commit and redeploy if needed.

---

## FM-005: Deployment Blocked (Vercel Config)

**Symptom**
```
Error: If `rewrites`, `redirects`, `headers`, `cleanUrls` or `trailingSlash` are used, then `routes` cannot be present.
```

**Diagnostic**
1. Ensure `vercel.json` uses **either** `routes` **or** `rewrites`.
2. Prefer `rewrites` for static routing:
   - `/` → `/index.html`
3. Redeploy: `vercel --prod`.

**Observable Indicators**
- Vercel CLI error about mixed routing keys.
- Build logs show configuration validation failures.
- Deploy fails immediately without uploading output.

**Root Cause**
- Mixed routing keys in `vercel.json`.

**Resolution**
1. Remove `routes` when using `rewrites`.
2. Re-deploy after config update.

---

## FM-006: Make Execution Failure

**Symptom**
```
make: command not found
```

**Diagnostic**
1. Install build tools: `xcode-select --install` (macOS).
2. Validate Makefile uses tabs, not spaces.
3. Run dry-run: `make -n deploy`.

**Observable Indicators**
- Shell output: `make: command not found`.
- Makefile step fails on first command.
- User report: "Make won't run on this machine".

**Root Cause**
- Build tools missing or Makefile syntax invalid.

**Resolution**
1. Install required tooling.
2. Fix tab indentation if needed.

---

## FM-007: Root 404 (Deployment Up, Content Missing)

**Symptom**
```
HTTP/2 404
x-vercel-error: NOT_FOUND
```

**Diagnostic**
1. Confirm root `index.html` exists in repo.
2. Verify Vercel project link is correct.
3. Force static build in `vercel.json`:
   - `builds`: `@vercel/static`
   - `rewrites`: `/` → `/index.html`
4. Deploy via CLI: `vercel --prod`.

**Observable Indicators**
- `curl -I https://timothywheels.com` returns 404.
- Vercel deployment shows success but serves NOT_FOUND.
- User report: "Domain is up but root is blank/404".

**Decision Tree**
```
Root 404?
├─ index.html exists? -> no  -> Restore file
└─ index.html exists? -> yes
   ├─ Correct project linked? -> no  -> vercel link
   └─ Correct project linked? -> yes
      ├─ Static builds + rewrite set? -> no  -> update vercel.json
      └─ Static builds + rewrite set? -> yes -> redeploy
```

**Root Cause**
- Wrong project linked or missing root file.
- Routing misconfiguration in `vercel.json`.

**Resolution**
1. Link correct project (`vercel link`).
2. Re-deploy after config fix.

---

## FM-008: 401 Unauthorized

**Symptom**
```
HTTP/2 401
x-vercel-error: PROTECTED
```

**Diagnostic**
1. Check Deployment Protection settings in Vercel.
2. Confirm whether protection bypass is configured.

**Observable Indicators**
- `curl -I` returns 401 with `x-vercel-error: PROTECTED`.
- Browser shows "Authentication required" interstitial.
- External users cannot access site.

**Root Cause**
- Vercel Authentication enabled for production.

**Resolution**
1. Disable Vercel Authentication in project settings, or
2. Use protection bypass header with automation secret.

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
- Daily: `make audit` after any deploy
- Weekly: review `SOVEREIGN_LOG.md`, Vercel logs, and DNS resolution
- Monthly: rotate credentials and verify DNS records

## Preventive Measures (Before Incidents)
- Pin routing strategy (`rewrites` only) and lint `vercel.json` before deploy.
- Require clean working tree before release (`git status -sb`).
- Maintain a standard deploy checklist with timestamps.
- Keep a rollback-ready last known good commit tagged.
