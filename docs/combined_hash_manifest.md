# CYW Defensive Publication - Combined Hash Manifest

**Document ID:** CYW-MANIFEST-2025-001  
**Version:** 1.0  
**Date:** December 30, 2025  
**Authority:** Timothy I. Wheels  
**Organization:** Contruil LLC  
**Classification:** Defensive Publication Evidence

---

## Executive Summary

This manifest certifies the integrity, completeness, and blockchain anchoring status of the CYW Defensive Publication evidence package. Two primary hashes are documented herein, establishing a three-tier evidence system for patent defense under 35 U.S.C. § 102(a)(1).

---

## Hash Inventory

### Tier 1: Primary Prior Art (CRITICAL)

| Field | Value |
|-------|-------|
| **Document** | Defensive Publication Bundle |
| **File** | `defensive_pub_20251230_bundle.zip` |
| **Size** | 34,459 bytes |
| **SHA-256** | `4a1466d6193cd6d3c69952510cad6461c6aeeb0d3841171549c1aac9cc3c6758` |
| **MD5** | `1510e4ccc685660e3ef766b292143c07` |
| **Publication Date** | December 30, 2025, 6:42:05 AM EST |
| **Priority Date** | December 30, 2025 (35 U.S.C. § 102(a)(1)) |
| **OriginStamp Status** | Submitted for Bitcoin blockchain anchoring |
| **Purpose** | Complete technical disclosure of three inventions |

**Verification Command:**
```bash
shasum -a 256 defensive_pub_20251230_bundle.zip
# Expected: 4a1466d6193cd6d3c69952510cad6461c6aeeb0d3841171549c1aac9cc3c6758
```

### Tier 2: Supporting Documentation

| Field | Value |
|-------|-------|
| **Document** | Verification Card PDF |
| **File** | `verification_card_4x6.pdf` |
| **Size** | 18,447 bytes |
| **SHA-256** | `4cfc4787a9524350bd79bf648ba18aa70d6ad1012816ed7f3e49f46406e00826` |
| **Publication Date** | December 30, 2025, 11:53 AM EST |
| **OriginStamp Status** | Submitted, anchoring in progress |
| **Purpose** | Quick reference verification card for professional presentation |

**Verification Command:**
```bash
shasum -a 256 verification_card_4x6.pdf
# Expected: 4cfc4787a9524350bd79bf648ba18aa70d6ad1012816ed7f3e49f46406e00826
```

### Tier 3: Implementation Evidence

| Field | Value |
|-------|-------|
| **Document** | CYW System Diagnostics |
| **File** | `cyw_system_diagnostics.py` |
| **SHA-256** | To be calculated |
| **Purpose** | Reduction to practice evidence |
| **Status** | Covered by Git commit history |

**Verification Command:**
```bash
shasum -a 256 cyw_system_diagnostics.py
```

---

## Bundle Contents (8 Files)

| # | File | Description |
|---|------|-------------|
| 1 | `cyw_operating_manual.md` | Complete operating manual v1.1 |
| 2 | `DEFENSIVE_PUBLICATION_COVER.md` | Cover sheet with legal declarations |
| 3 | `manifest_20251230_064205.txt` | Original manifest with timestamps |
| 4 | `master_index_governance.md` | Index governance protocols |
| 5 | `nsls_outreach_cyw_deployment.md` | NSLS outreach system documentation |
| 6 | `project_status_report.md` | Multi-platform project status |
| 7 | `section_3_master_index_governance.md` | Detailed governance section |
| 8 | `section_4_project_status_and_appendices.md` | Status and appendices |

---

## Multi-Platform Publication

| Platform | URL | Status |
|----------|-----|--------|
| **Google Drive** | [Public Link](https://drive.google.com/open?id=1zkp4bSuJjhj8WdNh80-pySMA9ZMLIGWw) | ✅ Live |
| **GitHub** | `github.com/Contruil-LLC/CYW-Defensive-Publication-2025` | ⏳ Pending |
| **IP.com** | TBD | ⏳ Pending submission |
| **Bitcoin Blockchain** | Via OriginStamp | ⏳ Anchoring in progress |
| **Internet Archive** | TBD | ⏳ Pending submission |

---

## Blockchain Anchoring Status

### OriginStamp Submissions

| Hash | Type | Submitted | Certificate |
|------|------|-----------|-------------|
| `4a1466d6...` | Bundle (Tier 1) | Dec 30, 2025 12:15 PM | Pending (~12 hours) |
| `4cfc4787...` | Card (Tier 2) | Dec 30, 2025 11:53 AM | Pending (~12 hours) |

### Expected Certificate Delivery

- **Verification Card:** ~December 31, 2025, 12:00 AM EST
- **Bundle:** ~December 31, 2025, 12:15 AM EST

---

## Legal Significance

### Three-Tier Evidence Hierarchy

**Tier 1 - Primary Prior Art (MUST TIMESTAMP):**
> The bundle hash `4a1466d6193cd6d3c69952510cad6461c6aeeb0d3841171549c1aac9cc3c6758` represents the complete technical disclosure. This is the legally defensible prior art evidence.

**Tier 2 - Supporting Documentation (GOOD TO TIMESTAMP):**
> The verification card hash `4cfc4787a9524350bd79bf648ba18aa70d6ad1012816ed7f3e49f46406e00826` provides professional presentation and quick reference. Enhances credibility.

**Tier 3 - Implementation Evidence (COVERED BY GIT):**
> Source code files demonstrate reduction to practice. Git commits provide timestamps; blockchain timestamp optional.

### Legal Basis

This defensive publication establishes prior art under:

> **35 U.S.C. § 102(a)(1):** A person shall be entitled to a patent unless the claimed invention was patented, described in a printed publication, or in public use, on sale, or otherwise available to the public before the effective filing date of the claimed invention.

---

## Protocol Compliance

| Protocol | Status |
|----------|--------|
| CYW Metadata Protocol | ✅ All files include required metadata headers |
| VLAN Routing Standard | ✅ Layer order and routing patterns followed |
| Operator Action Protocol | ✅ [OPERATOR:ACTION] template present |
| Guardrail Charter | ✅ Human-led boundaries enforced |
| Audit Logging | ✅ Documentation references audit log |

---

## QR Codes

### Bundle Hash QR Code
Scan to verify SHA-256: `4a1466d6193cd6d3c69952510cad6461c6aeeb0d3841171549c1aac9cc3c6758`

File: `qr_bundle_hash.png`

### Verification Card Hash QR Code
Scan to verify SHA-256: `4cfc4787a9524350bd79bf648ba18aa70d6ad1012816ed7f3e49f46406e00826`

File: `qr_verification_card_hash.png`

---

## Cross-Platform Verification Commands

### macOS / Linux
```bash
shasum -a 256 defensive_pub_20251230_bundle.zip
shasum -a 256 verification_card_4x6.pdf
```

### Windows (PowerShell)
```powershell
Get-FileHash defensive_pub_20251230_bundle.zip -Algorithm SHA256
Get-FileHash verification_card_4x6.pdf -Algorithm SHA256
```

### Windows (CMD)
```cmd
certutil -hashfile defensive_pub_20251230_bundle.zip SHA256
certutil -hashfile verification_card_4x6.pdf SHA256
```

---

## Attestation

I, Timothy I. Wheels, hereby certify that:

1. The hashes documented in this manifest accurately represent the files described
2. The files were created and published on the dates specified
3. The publication establishes prior art for patent defense purposes
4. All protocol compliance requirements have been met

**Signature:** ________________________________

**Date:** December 30, 2025

**Witness:** ________________________________

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | Dec 30, 2025 | Timothy I. Wheels | Initial manifest creation |

---

*This manifest and verification record certifies the integrity, completeness, and protocol compliance of the CYW Defensive Publication evidence bundle.*

**End of Document**
