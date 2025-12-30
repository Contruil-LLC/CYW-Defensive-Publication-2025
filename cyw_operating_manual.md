# CYW Operating Manual
**Version:** 1.0  
**Date:** December 29, 2025  
**Owner:** Timothy I. Wheels  
**Classification:** Operational Reference Document

---

## Document Overview

This operating manual consolidates all active workstreams under the CYW Networked Creative OS umbrella into a single, cohesive reference document. Each section follows an identical structure for consistency and rapid navigation.

| Section | Scope | System Tags |
|---------|-------|-------------|
| 1. Virgil OS | Routing, Patent Alignment, Failure Testing | `Architecture` `Patent` `Evidence` |
| 2. NSLS Outreach / CYW Deployment | Outreach Reset, Automation, Metrics | `Outreach` `Architecture` `Evidence` |
| 3. Master Index Governance | Discovery, Lifecycle, Dependencies | `Architecture` `Patent` `Evidence` |
| 4. Project Status | Platform Overview, Assets, Tags | `Architecture` `Patent` `Legal` `Outreach` `Evidence` |

---

## System Tags Legend

| Tag | Description |
|-----|-------------|
| `Legal` | Legal compliance, judicial matters, LLC formation |
| `Patent` | Intellectual property, patent filings, proprietary systems |
| `Outreach` | External communications, NSLS, community engagement |
| `Evidence` | Documentation for validation, audit trails, proof of work |
| `Architecture` | System design, technical specifications, infrastructure |

---

## 1. Virgil OS – Routing, Patent Alignment, and Failure Testing

**Scope:** Virgil OS multi-model orchestration layer (routing, governance, and evidence handling)  
**Owner:** Timothy I. Wheels (Virgil OS / Contruil)  
**Report Date:** December 29, 2025  

| Field | Value |
|-------|-------|
| **Last Reviewed** | December 29, 2025 |
| **Owner** | Timothy I. Wheels |
| **System Tags** | `Architecture` `Patent` `Evidence` |

---

### 1.1 Routing Patterns & Diagrams

**Goal:**  
Make the current and future routing topologies explicit at both the logical and physical layers, so engineering, legal, and evidence bundles are all referencing the same map.

**Current Status:**  
Logical flows are partially documented in narrative form. Physical layout (nodes/VPCs/segments) is implicit in notes but not standardized as diagrams. No consolidated transformation table yet (current → future routes).

**Target Artifacts:**

| Artifact ID | Description |
|-------------|-------------|
| `FIG-R-1` | Current-State Logical Routing Diagram |
| `FIG-R-2` | Current-State Physical Topology (nodes/VPCs/LAN segments) |
| `FIG-R-3` | Future-State Logical Routing Diagram |
| `FIG-R-4` | Future-State Physical Topology (including multi-region / tenancy) |
| `TABLE-R-Δ` | Transformation table (current vs future flows) |

**Execution Checklist**

1. **Current-State – Logical**

   Enumerate all producers and consumers (Clients, Partner systems, Admin/operator tools). For each request type, map full hop from entrypoint through gateway/API to service, data store/queue, and downstream service. Annotate per hop with protocol, port/endpoint, auth boundary, and synchrony.

2. **Current-State – Physical**

   Identify all compute nodes and their grouping (VPCs, subnets, security groups, pods/instances). Draw network segments distinguishing public edge, private services, and data layer. Mark trust boundaries between Internet and edge gateway, edge and control plane, control plane and data plane.

3. **Future-State – Logical**

   Start from desired properties including latency SLOs, availability model, and tenancy model. Introduce explicit patterns such as API Gateway, message bus/event backbone, CQRS read paths, cache layers, and circuit breakers. Decide which calls become async, which responsibilities move to the edge, and where command vs query boundaries sit.

4. **Future-State – Physical**

   Map region/AZ layout and cross-region links. Identify sharded/split databases and their routing rules. Mark observability components (tracing, metrics, logs) as first-class nodes.

5. **Transformation Table**

   Build `TABLE-R-Δ` with columns for Route ID, Current flow, Future flow, Change type, and Impacted diagrams. Link each transformation row to the corresponding patent claim(s) it touches.

**Suggested Deadline:**  
- Draft diagrams + transformation table: **January 5, 2026**  
- Review / final pass before attorney bundle: **January 10, 2026**

**Key Risks:**  
Hidden hops or side channels not represented in diagrams. Future-state not fully reflected in patent language or evidence logs.

---

### 1.2 Architecture vs Patent Scope Mapping

**Goal:**  
Create a tight, auditable mapping from each independent (and key dependent) claim to concrete Virgil OS components and flows, so there is no "floating" claim that isn't implemented or deliberately excluded.

**Current Status:**  
Claims and architecture exist, but element-by-element mapping is not yet formalized. No standardized grid yet that compares current vs future coverage.

**Target Artifacts:**

| Artifact ID | Description |
|-------------|-------------|
| `GRID-C-<n>` | Claim → Architecture mapping grid (one per independent claim) |
| `CHECKLIST-C-1` | "Design ↔ Legal" routing change checklist |
| Master Index Annotations | Links from each claim to primary diagram(s) and evidence bundles |

**Execution Checklist**

1. **Normalize Each Independent Claim**

   Break each independent claim into atomic elements. For each element, create a normalized bullet and note any defined terms or constructions that matter (Markman-style interpretations, glossary terms, spec definitions).

2. **Build the Validation Grid (per Claim)**

   For each independent claim `C_n`, create `GRID-C-n` with columns for Claim element text (normalized), Current architecture mapping, Future architecture mapping, and Coverage type (Literal or Equivalent).

3. **Decision Rules & Flags**

   For any future change that removes or bypasses a mapped element, flag as "potential scope exit" and decide explicitly whether to keep this feature as a protected implementation path or accept that the change moves outside the original claim scope. Identify any design features that look like unclaimed embodiments and decide whether to leave them unclaimed or plan a continuation/follow-on filing.

4. **Design–Legal Checklist**

   Create `CHECKLIST-C-1` that every new routing/architecture decision must pass: Which claims does this touch? Does it still satisfy the mapped elements? Does it accidentally enter someone else's likely claim territory? Do we need to update evidence logs?

**Suggested Deadline:**  
- First full claim-mapping pass (independent claims): **January 12, 2026**  
- Dependent claim refinement + cleanup: **January 20, 2026**

**Key Risks:**  
Claims drafted more broadly than actual implementation (enablement/written description issues). Future refactors silently drifting away from what is actually claimed.

---

### 1.3 Failure-Focused Test Scenarios

**Goal:**  
Validate Virgil OS as a *resilient* multi-model router, not just a happy-path orchestrator, by explicitly testing how routing and coordination fail under stress.

**Current Status:**  
Some informal reasoning exists about error handling. No systematic, route-by-route failure matrix or chaos-style scenarios defined yet.

**Target Artifacts:**

| Artifact ID | Description |
|-------------|-------------|
| `MATRIX-F-1` | Route-by-route failure scenario matrix |
| `SCENARIOS-F-SET-A` | Initial test catalog (10–15 scenarios) |
| Evidence Links | Connections to relevant diagrams, claim grid rows, and evidence logs |

**Execution Checklist**

1. **Identify Core Failure Modes**

   For Virgil OS routes, explicitly cover Network/Infra failures (partial outages, partitions), Dependencies (slow dependency, flapping dependency, wrong/stale responses, overload), State & Ordering (in-flight request loss, duplicate deliveries, out-of-order events, conflicting writes), and Control Plane/Config (bad routing configuration rollout, misconfigured feature flag, stale service discovery).

2. **Scenario Design Pattern (Per Route)**

   For each key route in your diagrams, define a "Golden Path" test with baseline expected latency, success rate, and evidence logging behavior. Create at least one single-fault scenario per hop and at least one compound-fault scenario.

3. **Fault Injection & Chaos Strategy**

   Choose how to inject faults (RPC/message layer, synthetic latency, error codes via test harness). For lower environments, plan chaos experiments including killing pods/instances, temporarily blocking network segments, and rolling intentionally bad config with guardrails. For each scenario, define system-level assertions for data loss bounds, latency SLOs, error budget, and resource exhaustion prevention.

4. **Link to Patent & Evidence**

   Tag each failure scenario with the claim elements it exercises. Capture traces/logs as part of the Evidence Bundle with hash runs and stored pointers. Mark in the Master Index which scenarios are "canonical" for attorney review.

**Suggested Deadline:**  
- First 10–15 scenarios defined and runnable: **January 18, 2026**  
- Evidence integration + cleanup: **January 25, 2026**

**Key Risks:**  
Hidden coupling or emergent failure patterns not covered by single-fault tests. Incomplete logging making post-incident reconstruction difficult.

---

### 1.4 Summary for Virgil OS Workstream

| Asset | Last Reviewed | Owner | System Tags |
|-------|---------------|-------|-------------|
| Routing Diagrams (FIG-R-1..4) | Pending | Timothy I. Wheels | `Architecture` |
| Transformation Table (TABLE-R-Δ) | Pending | Timothy I. Wheels | `Architecture` `Patent` |
| Claim Mapping Grids (GRID-C-n) | Pending | Timothy I. Wheels | `Patent` `Evidence` |
| Failure Scenario Matrix (MATRIX-F-1) | Pending | Timothy I. Wheels | `Architecture` `Evidence` |
| Design-Legal Checklist (CHECKLIST-C-1) | Pending | Timothy I. Wheels | `Patent` `Legal` |

**Routing:** Explicit diagrams + transformation table = shared mental model across engineering, legal, and evidence.  
**Patent Mapping:** Claim grids ensure every claim is tied to a real implementation (or intentionally not) and every major routing decision is legally aware.  
**Failure Testing:** Scenario catalog + fault injection gives you proof that Virgil OS is robust under real-world stress, not just in design.

---

## 2. NSLS Outreach System Reset / CYW Deployment

**Scope:** NSLS 826 Outreach Reset — Infrastructure-based value delivery transition  
**Owner:** Timothy I. Wheels (CYW / Contruil)  
**Report Date:** December 29, 2025  

| Field | Value |
|-------|-------|
| **Last Reviewed** | December 29, 2025 |
| **Owner** | Timothy I. Wheels |
| **System Tags** | `Outreach` `Architecture` `Evidence` |

---

### 2.1 Terminology Migration & Logic Rerouting

**Goal:**  
Transition NSLS outreach from personality-based pitch to infrastructure-based value proposition using CYW methodology, ensuring terminology and routing logic align with systems-thinking principles.

**Current Status:**  
Terminology migration complete (Leadership training → Capacity building protocols). Logic rerouting implemented (High-volume broadcast → Qualified checkpoint routing). Integration latency identified (48-hour manual hand-off lag). Prompt calibration issue flagged (ambiguous for literal interpreters).

**Target Artifacts:**

| Artifact ID | Description |
|-------------|-------------|
| `TABLE-T-1` | Terminology Migration Matrix (Before/After/Rationale) |
| `FLOW-L-1` | Lead Routing Logic Diagram |
| `VARIANT-P-SET` | Prompt Variant Catalog (A/B/C abstraction levels) |
| `DASHBOARD-M-1` | Baseline Metrics Dashboard |

**Terminology Migration Matrix**

| Before (Legacy) | After (CYW) | Strategic Rationale |
|-----------------|-------------|---------------------|
| Leadership training | Capacity building protocols | Shifted conversation from personality-based pitch to infrastructure-based value proposition |
| Member recruitment | Systems onboarding | Emphasizes repeatable process over individual persuasion |
| Engagement metrics | Throughput indicators | Aligns with CYW operational language |

**Logic Rerouting Flow**

| Previous Flow | New Flow | CYW Principle Applied |
|---------------|----------|----------------------|
| High-volume broadcast → Mass scheduling | Low-clarity onboarding checkpoints → Qualified scheduling | Routing Efficiency |
| All leads → Same pipeline | Systems-thinking prompt filter → Segmented routing | Constraint as Feature |
| Immediate CTA | Engagement verification → Delayed CTA | Quality Over Velocity |

**Routing Logic:**
```
[Incoming Lead] 
    → [Systems-Thinking Prompt]
        → [Engaged] → Scheduling Phase
        → [Not Engaged] → Nurture Sequence
        → [No Response] → Archive + Re-engagement Queue
```

**Suggested Deadline:**  
- Automation deployment: **January 4, 2026**  
- Prompt variants B and C drafted: **January 2, 2026**  
- Baseline metrics dashboard: **January 7, 2026**  
- Variant analysis complete: **January 14, 2026**

**Key Risks:**  
Manual hand-off creating context loss and opportunity cost. Single-variant testing insufficient for segment diversity. CRM automation tier pending financial approval.

---

### 2.2 Breakage Analysis & Root Cause

**Goal:**  
Document and remediate all friction points identified during the NSLS Outreach System Reset, ensuring systematic resolution and evidence logging for future reference.

**Current Status:**  
Two breakage categories identified and documented. Root cause analysis complete for both issues. Mitigation paths defined but not yet implemented.

**Breakage Analysis Matrix**

| Issue | Root Cause | Impact | Severity |
|-------|------------|--------|----------|
| Integration Latency | No automated bridge between LinkedIn and CRM; context loss during manual transfer; single-operator dependency | 2 high-capacity leads dropped; Medium-High opportunity cost; trust erosion | 🟠 Medium-High |
| Constraint Friction | Prompt assumed baseline systems-thinking familiarity; no fallback path for literal interpreters; single-variant testing | Zero throughput for specific segment; potential permanent disengagement; data gap | 🟡 Medium |

**Remediation Actions**

| Priority | Action | Owner | Due Date | Status |
|----------|--------|-------|----------|--------|
| P0 | Configure LinkedIn to CRM automation | Timothy I. Wheels | 2025-01-04 | TODO |
| P0 | Draft prompt variants B and C | Timothy I. Wheels | 2025-01-02 | TODO |
| P1 | Establish baseline metrics dashboard | Timothy I. Wheels | 2025-01-07 | TODO |
| P1 | Schedule Week 3 variant analysis | Timothy I. Wheels | 2025-01-14 | TODO |
| P2 | Document automation for delegation | Timothy I. Wheels | 2025-01-21 | TODO |

**Success Criteria for Integration Automation:**  
Lead capture to CRM entry under 5 minutes. Zero context loss on transfer. Automatic tagging with source attribution.

**Suggested Deadline:**  
- Integration automation live: **January 4, 2026**  
- Prompt variants deployed: **January 7, 2026**  
- Evidence logging complete: **January 10, 2026**

**Key Risks:**  
Delayed automation extends context loss window. Segment disengagement may be permanent without rapid re-engagement.

---

### 2.3 Metrics & Measurement Framework

**Goal:**  
Establish a comprehensive measurement framework for NSLS Outreach System performance, enabling data-driven optimization and CYW methodology audit.

**Current Status:**  
KPIs defined with baseline and target values. Measurement schedule established (Daily/Weekly/Monthly). Dashboard implementation pending.

**Key Performance Indicators**

| Metric | Baseline | Target | Current | Owner |
|--------|----------|--------|---------|-------|
| Lead Response Rate | 12% | 25% | TBD | Timothy I. Wheels |
| Scheduling Conversion | 8% | 18% | TBD | Timothy I. Wheels |
| Context Retention Score | 60% | 95% | TBD | Timothy I. Wheels |
| Throughput per Segment | Variable | Consistent | TBD | Timothy I. Wheels |

**Measurement Schedule**

| Cadence | Metrics |
|---------|---------|
| Daily | Lead capture count, response rate |
| Weekly | Conversion funnel analysis, segment performance |
| Monthly | Full cycle review, CYW methodology audit |

**Suggested Deadline:**  
- Dashboard live: **January 7, 2026**  
- First weekly analysis: **January 14, 2026**  
- First monthly audit: **February 1, 2026**

**Key Risks:**  
Data fragmentation across platforms. Manual tracking introducing measurement error. Delayed dashboard delaying optimization cycles.

---

### 2.4 CYW Routing Protocol & Layer Activation

**Goal:**  
Document the CYW routing protocol applied to NSLS Outreach, including VLAN assignment, layer activation, and next routing decisions.

**Current Status:**  
VLAN 40 (Deployment) assigned. Layers L2, L3, L4 activated and verified. Guardian verification complete.

**VLAN Assignment:** VLAN 40 (Deployment)

**Layer Activation**

| Layer | Role | Status | Activities |
|-------|------|--------|------------|
| L2 (Strategist) | Strategy & Planning | ✅ Active | Terminology migration, logic rerouting design |
| L3 (Architect) | System Design | ✅ Active | Automation architecture, prompt variant structure |
| L4 (Guardian) | Risk & Validation | ✅ Verified | Breakage identification, risk assessment |
| L5 (Operator) | Maintenance | ⏳ Pending | Awaiting automation success |

**Next Routing Decision:**  
If automation succeeds → Route to L5 (Operator) for maintenance mode.  
If friction persists → Route back to L2 (Strategist) for re-architecture.

**Guardian Sign-Off**

| Field | Value |
|-------|-------|
| Deployment Log Completed | 2025-12-28 16:30 EST |
| Reviewed By | Timothy Wheels |
| Guardian Verification | Verified |
| Next Review Date | 2025-01-04 |

**Suggested Deadline:**  
- L5 transition decision: **January 14, 2026**  
- Re-architecture (if needed): **January 21, 2026**

**Key Risks:**  
Premature L5 transition before automation stability confirmed. Re-architecture delay extending friction window.

---

### 2.5 Summary for NSLS Outreach / CYW Deployment Workstream

| Asset | Last Reviewed | Owner | System Tags |
|-------|---------------|-------|-------------|
| NSLS Outreach System Reset Plan | Dec 28, 2025 | Timothy I. Wheels | `Outreach` |
| CYW Deployment Log — NSLS Outreach | Dec 28, 2025 | Timothy I. Wheels | `Outreach` `Evidence` |
| CYW Deployment Log Template v1.1 | Dec 28, 2025 | Timothy I. Wheels | `Architecture` |
| Terminology Migration Matrix | Dec 28, 2025 | Timothy I. Wheels | `Outreach` |
| Lead Routing Logic Diagram | Dec 28, 2025 | Timothy I. Wheels | `Architecture` |
| Metrics Dashboard (Pending) | — | Timothy I. Wheels | `Evidence` |

**Terminology:** Migration complete — Infrastructure-first language deployed.  
**Routing:** Checkpoint logic implemented — Quality over velocity enforced.  
**Automation:** Pending — LinkedIn → CRM bridge in progress.  
**Measurement:** Framework defined — Dashboard implementation by January 7.

---

## 3. Master Index Governance

**Scope:** Master Index maintenance, artifact discovery, and governance protocols  
**Owner:** Timothy I. Wheels (Virgil OS / Contruil)  
**Report Date:** December 29, 2025  

| Field | Value |
|-------|-------|
| **Last Reviewed** | December 29, 2025 |
| **Owner** | Timothy I. Wheels |
| **System Tags** | `Architecture` `Patent` `Evidence` |

---

### 3.1 Index Structure & Navigation

**Goal:**  
Maintain a single source of truth for all CYW/Virgil OS artifacts, enabling rapid discovery via standardized search strings and eliminating the need to sift through full conversation logs.

**Current Status:**  
Master Index established with four primary sections (A–D). Search string conventions documented for all major artifacts. Linked pages for Virgil OS Defensibility & Production Readiness collection.

**Index Architecture**

| Section | Category | Search String Convention | Asset Count |
|---------|----------|--------------------------|-------------|
| A | Layer 1 Entry Boundary | `LAYER 1 ENVELOPE v1.1` | 4 artifacts |
| B | Patent / IP Artifacts | `PRIOR ART PATENT LANDSCAPE` | 3 artifacts |
| C | Quantum Herd / Orchestration | `Full Quantum Herd Structure` | 1 artifact |
| D | Virgil OS Defensibility | Page URLs (Notion links) | 4 artifacts |

**Section A — Layer 1 Entry Boundary**

| Artifact | Search String | Description |
|----------|---------------|-------------|
| Layer 1 Envelope v1.1 – JSON Schema | `LAYER 1 ENVELOPE v1.1 - JSON SCHEMA` | Hostile-by-default envelope schema |
| Entry contract test script | `# test_entry_[` | Sanity checks: JSON well-formed, duplicate key detection |
| Entry fixtures (valid) | `// tests/fixtures/entry/valid_entry.json` | Happy path validation |
| Entry fixtures (invalid) | `invalid_missing_intent.json` | Rejection cases |

**Section B — Patent / IP Artifacts**

| Artifact | Search String | Description |
|----------|---------------|-------------|
| Prior Art Patent Landscape Analysis | `PRIOR ART PATENT LANDSCAPE ANALYSIS` | 3 domains: AI orchestration, split learning, contract-based gateways |
| Attorney Brief – Prior Art Pressure Test | `ATTORNEY BRIEF: PRIOR ART PRESSURE TEST & CLAIM SCOPING ANALYSIS` | Exec summary, risk checkpoints, draft claims |
| Patentable Core Summary | `What Makes This Patentable` | Triad architecture definition |

**Section C — Quantum Herd / Orchestration Topology**

| Artifact | Search String | Description |
|----------|---------------|-------------|
| Quantum Herd v2.0 | `Full Quantum Herd Structure` | Layered stack, VLAN assignments, cross-layer collaboration |

**Section D — Virgil OS Defensibility & Production Readiness**

| Artifact | Description |
|----------|-------------|
| Executive Summary | One-page summary for stakeholders and legal review |
| Evidence Bundle: Multi-Model Orchestration | 5-model orchestration run with telemetry, hash chain, routing logs |
| The Golden Signals | Observability framework: Latency, Traffic, Errors, Saturation |
| Gate Conditions & Critical Review Protocol | Machine-enforceable criteria for artifact transitions |

**Suggested Deadline:**  
- Index structure review: **Ongoing (weekly)**  
- New artifact integration: **Within 24 hours of creation**

**Key Risks:**  
Stale search strings if artifacts are renamed or restructured. Orphaned artifacts not linked to Master Index.

---

### 3.2 Artifact Lifecycle & Version Control

**Goal:**  
Establish governance protocols for artifact creation, modification, deprecation, and archival, ensuring the Master Index remains authoritative and audit-ready.

**Current Status:**  
Version conventions partially established (e.g., v1.0, v1.1, v2.0). No formal lifecycle state machine documented. Deprecation and archival protocols implicit but not standardized.

**Lifecycle States**

| State | Definition | Transition Rules |
|-------|------------|------------------|
| Draft | Initial creation, not yet reviewed | → Active (after Guardian review) |
| Active | Current authoritative version | → Superseded (when new version released) |
| Superseded | Replaced by newer version | → Archived (after retention period) |
| Archived | Historical reference only | Terminal state |
| Deprecated | Scheduled for removal | → Archived (after grace period) |

**Version Numbering Convention**

| Component | Format | Example | Usage |
|-----------|--------|---------|-------|
| Major | X.0 | v2.0 | Breaking changes, architectural shifts |
| Minor | X.Y | v1.1 | Additions, non-breaking enhancements |
| Patch | X.Y.Z | v1.1.1 | Corrections, typo fixes |

**Governance Actions**

| Action | Trigger | Owner | Evidence Required |
|--------|---------|-------|-------------------|
| Create | New artifact needed | Author | Draft review by Guardian |
| Update | Content change | Author | Version increment, changelog entry |
| Deprecate | Artifact obsolete | Owner | Deprecation notice, migration path |
| Archive | Retention period complete | Owner | Archive confirmation, index removal |

All lifecycle transitions must be logged in the evidence chain with timestamp, actor, previous state, new state, and justification.

**Suggested Deadline:**  
- Lifecycle protocol formalized: **January 10, 2026**  
- State machine diagram created: **January 15, 2026**

**Key Risks:**  
Version drift between Master Index and actual artifacts. Undocumented deprecations creating discovery gaps.

---

### 3.3 Cross-Reference & Dependency Mapping

**Goal:**  
Maintain explicit mappings between Master Index artifacts and their dependencies (patent claims, evidence bundles, routing diagrams), ensuring no artifact exists in isolation.

**Current Status:**  
Implicit dependencies exist in narrative form. No standardized dependency matrix. Patent claim → artifact mapping initiated but not complete.

**Dependency Categories**

| Category | Description | Example |
|----------|-------------|---------|
| Patent | Artifact supports specific claim element | Layer 1 Envelope → Claim 1 |
| Evidence | Artifact generates or consumes evidence | Evidence Bundle → Hash chain logs |
| Architecture | Artifact defines or implements system component | Quantum Herd → VLAN routing |
| Operational | Artifact guides operational procedures | CYW Deployment Log → NSLS Outreach |

**Cross-Reference Matrix Structure**

| Artifact | Patent Claims | Evidence Bundles | Architecture Diagrams | Operational Docs |
|----------|---------------|------------------|----------------------|------------------|
| Layer 1 Envelope v1.1 | C1, C2 | Evidence Bundle | FIG-R-1 | — |
| Attorney Brief | C1–C5 | — | — | — |
| Quantum Herd v2.0 | C3, C4 | — | FIG-R-3, FIG-R-4 | CYW Ops Schema |
| Evidence Bundle | C1–C5 | Self | FIG-R-1..4 | — |

**Dependency Validation Rules:**  
Every artifact must have at least one dependency link documented. No circular dependencies without explicit justification. Orphan detection during weekly review.

**Suggested Deadline:**  
- Dependency matrix draft: **January 12, 2026**  
- Cross-reference validation: **January 20, 2026**

**Key Risks:**  
Hidden dependencies not captured in matrix. Stale cross-references after artifact updates.

---

### 3.4 Access & Discovery Protocols

**Goal:**  
Define standardized protocols for artifact discovery, access control, and export, ensuring authorized users can rapidly locate and retrieve artifacts while maintaining security boundaries.

**Current Status:**  
Search string conventions established. No formal access control matrix. Export protocols (flatten commands) documented informally.

**Discovery Methods**

| Method | Use Case | Example |
|--------|----------|---------|
| Search String | Rapid artifact location | `LAYER 1 ENVELOPE v1.1 - JSON SCHEMA` |
| Category Browse | Section exploration | Navigate to Section B for Patent artifacts |
| Dependency Trace | Find related artifacts | From Attorney Brief → Prior Art Analysis |
| Flatten Export | Full artifact extraction | `"Flatten the Attorney Brief bundle for export."` |

**Export Commands**

| Command | Output | Use Case |
|---------|--------|----------|
| `Flatten the Attorney Brief bundle for export.` | Single continuous block | Legal review, Word paste |
| `Flatten the Tech bundle (schema + tests + fixtures).` | Complete technical package | Engineering handoff |
| `Flatten the Evidence Bundle for patent filing.` | Reduction-to-practice document | Patent application |

**Access Control Levels**

| Level | Permissions | Roles |
|-------|-------------|-------|
| Read | View, search, export | All team members |
| Write | Create, update artifacts | Authors, Architects |
| Admin | Deprecate, archive, access control | Owner, Guardian |

Artifacts tagged with `Patent` or `Legal` require Guardian verification before external export.

**Suggested Deadline:**  
- Access protocol formalized: **January 15, 2026**  
- Permission matrix implemented: **January 20, 2026**

**Key Risks:**  
Unauthorized export of sensitive patent materials. Search string drift reducing discovery effectiveness.

---

### 3.5 Summary for Master Index Governance Workstream

| Asset | Last Reviewed | Owner | System Tags |
|-------|---------------|-------|-------------|
| Master Index – What we built and how to find it | Dec 29, 2025 | Timothy I. Wheels | `Architecture` |
| Layer 1 Envelope v1.1 – JSON Schema | Dec 29, 2025 | Timothy I. Wheels | `Architecture` `Patent` |
| Prior Art Patent Landscape Analysis | Dec 29, 2025 | Timothy I. Wheels | `Patent` `Legal` |
| Attorney Brief – Prior Art Pressure Test | Dec 29, 2025 | Timothy I. Wheels | `Patent` `Legal` |
| Quantum Herd v2.0 | Dec 23, 2025 | Timothy I. Wheels | `Architecture` |
| Virgil OS Defensibility Collection | Dec 29, 2025 | Timothy I. Wheels | `Patent` `Evidence` |

**Structure:** Four-section index with standardized search strings for rapid discovery.  
**Lifecycle:** Version control and state machine governance pending formalization.  
**Dependencies:** Cross-reference matrix linking artifacts to claims, evidence, and diagrams.  
**Access:** Flatten export commands and permission levels defined.

---

## 4. Project Status Overview

| Field | Value |
|-------|-------|
| **Last Reviewed** | December 29, 2025 |
| **Owner** | Timothy I. Wheels |
| **System Tags** | `Architecture` `Patent` `Legal` `Outreach` `Evidence` |

---

### 4.1 Notion Workspace

Your Notion workspace contains **50+ pages** with active project documentation across five major categories.

| Category | Asset Count | Last Updated | System Tags |
|----------|-------------|--------------|-------------|
| CYW Networked Creative OS | 4+ assets | Dec 28, 2025 | `Architecture` `Patent` |
| Sovereign Survival (Unity) | 5+ assets | Dec 15, 2025 | `Architecture` `Evidence` |
| Contruil Ecosystem | 4+ assets | Dec 16, 2025 | `Architecture` `Legal` |
| Legal/Judicial Track | 2+ assets | Dec 14, 2025 | `Legal` `Evidence` |
| Technical Documentation | 3+ assets | Dec 26, 2025 | `Architecture` `Evidence` |

**Legal Track Status:** 12/40 community service hours complete. Target: January 31, 2026.

---

### 4.2 Vercel Platform

| Field | Value |
|-------|-------|
| **Last Reviewed** | December 29, 2025 |
| **Owner** | Contruil LLC |
| **System Tags** | `Architecture` |

| Team Name | Team ID | Projects |
|-----------|---------|----------|
| Contruil LLC | team_KA67AUojkH35lCGW3a0ZJ43z | 0 (pending deployment) |

The Contruil ecosystem documentation exists in Notion with landing page specifications ready for deployment.

---

### 4.3 GitHub Repositories

| Field | Value |
|-------|-------|
| **Last Reviewed** | December 29, 2025 |
| **Owner** | — |
| **System Tags** | `Architecture` |

**Status:** GitHub CLI not authenticated. Authentication required to retrieve repository status.

---

### 4.4 Platform Summary

| Platform | Status | Last Reviewed | Owner | System Tags |
|----------|--------|---------------|-------|-------------|
| Notion | ✅ Active | Dec 29, 2025 | Timothy I. Wheels | `Architecture` `Patent` `Legal` `Outreach` `Evidence` |
| Vercel | ⚪ Empty | Dec 29, 2025 | Contruil LLC | `Architecture` |
| GitHub | ⚠️ Not Connected | Dec 29, 2025 | — | `Architecture` |

---

## Appendix A: Consolidated Deadline Calendar

| Date | Deliverable | Section | Owner |
|------|-------------|---------|-------|
| Jan 2, 2026 | Prompt variants B and C drafted | 2.1 | Timothy I. Wheels |
| Jan 4, 2026 | LinkedIn → CRM automation deployed | 2.2 | Timothy I. Wheels |
| Jan 4, 2026 | NSLS Outreach next review | 2.4 | Timothy I. Wheels |
| Jan 5, 2026 | Routing diagrams + transformation table draft | 1.1 | Timothy I. Wheels |
| Jan 7, 2026 | Baseline metrics dashboard live | 2.3 | Timothy I. Wheels |
| Jan 10, 2026 | Routing diagrams final pass | 1.1 | Timothy I. Wheels |
| Jan 10, 2026 | Lifecycle protocol formalized | 3.2 | Timothy I. Wheels |
| Jan 12, 2026 | Claim-mapping pass (independent claims) | 1.2 | Timothy I. Wheels |
| Jan 12, 2026 | Dependency matrix draft | 3.3 | Timothy I. Wheels |
| Jan 14, 2026 | Variant analysis complete | 2.1 | Timothy I. Wheels |
| Jan 14, 2026 | L5 transition decision | 2.4 | Timothy I. Wheels |
| Jan 15, 2026 | State machine diagram created | 3.2 | Timothy I. Wheels |
| Jan 15, 2026 | Access protocol formalized | 3.4 | Timothy I. Wheels |
| Jan 18, 2026 | Failure scenarios defined (10–15) | 1.3 | Timothy I. Wheels |
| Jan 20, 2026 | Dependent claim refinement | 1.2 | Timothy I. Wheels |
| Jan 20, 2026 | Cross-reference validation | 3.3 | Timothy I. Wheels |
| Jan 20, 2026 | Permission matrix implemented | 3.4 | Timothy I. Wheels |
| Jan 21, 2026 | Re-architecture (if needed) | 2.4 | Timothy I. Wheels |
| Jan 25, 2026 | Evidence integration + cleanup | 1.3 | Timothy I. Wheels |
| Jan 31, 2026 | Legal obligation closure target | 4.1 | Timothy I. Wheels |
| Feb 1, 2026 | First monthly CYW audit | 2.3 | Timothy I. Wheels |

---

## Appendix B: Document Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Dec 29, 2025 | Timothy I. Wheels | Initial consolidated operating manual |

---

*CYW Operating Manual v1.0 — Generated December 29, 2025*
