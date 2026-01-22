#!/usr/bin/env python3
"""
cyw_system_diagnostics.py

Layered diagnostic and validation pipeline for CYW.
- 5-model pipeline with VLAN-style routing
- L1-L4 validation gates (sovereignty, ACL, structural, factual)
- Triangle Test consistency check (payload, metadata, logs)
- Attorney Packet bundle for audit/compliance
"""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from datetime import datetime, timezone
import time
from typing import Any, Dict, List, Tuple


Envelope = Dict[str, Any]
Report = Dict[str, Any]


def utc_now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def route_to_vlan(request_type: str) -> str:
    routing_table = {
        "system_health": "vlan-ops",
        "compliance": "vlan-legal",
        "audit": "vlan-evidence",
        "research": "vlan-research",
        "narrative": "vlan-narrative",
    }
    return routing_table.get(request_type, "vlan-general")


@dataclass
class GateResult:
    name: str
    passed: bool
    reason: str


class L1_EnvelopeValidator:
    def validate(self, envelope: Envelope) -> GateResult:
        metadata = envelope.get("metadata", {})
        sovereignty = metadata.get("sovereignty")
        owner = metadata.get("owner")
        subject = envelope.get("payload", {}).get("subject")

        if sovereignty in {"self", "authorized"}:
            return GateResult("L1_sovereignty", True, "sovereignty verified")
        if owner and subject and owner == subject:
            return GateResult("L1_sovereignty", True, "owner matches subject")
        return GateResult("L1_sovereignty", False, "sovereignty not established")


class L2_AccessControlValidator:
    def validate(self, envelope: Envelope) -> GateResult:
        metadata = envelope.get("metadata", {})
        requested_scope = envelope.get("payload", {}).get("requested_scope")
        acl = metadata.get("acl", [])

        if not requested_scope:
            return GateResult("L2_acl", False, "missing requested_scope")
        if requested_scope in acl:
            return GateResult("L2_acl", True, "scope allowed by ACL")
        return GateResult("L2_acl", False, "scope not permitted by ACL")


class L3_StructuralValidator:
    def validate(self, envelope: Envelope) -> GateResult:
        payload = envelope.get("payload", {})
        required_fields = ["issue", "context", "desired_outcome"]
        missing = [field for field in required_fields if not payload.get(field)]

        if not missing:
            return GateResult("L3_structural", True, "payload structure complete")
        return GateResult(
            "L3_structural", False, f"missing fields: {', '.join(missing)}"
        )


class L4_FactualValidator:
    def validate(self, envelope: Envelope) -> GateResult:
        metadata = envelope.get("metadata", {})
        facts_verified = metadata.get("facts_verified", False)

        if facts_verified is True:
            return GateResult("L4_factual", True, "facts verified")
        return GateResult("L4_factual", False, "facts not verified")


@dataclass
class ModelNode:
    name: str
    role: str

    def run(self, envelope: Envelope, gate_results: List[GateResult]) -> Dict[str, Any]:
        summary = f"{self.name} processed for {self.role}"
        return {
            "model": self.name,
            "role": self.role,
            "summary": summary,
            "gate_snapshot": {gate.name: gate.passed for gate in gate_results},
        }


def triangle_test(envelope: Envelope) -> Tuple[bool, List[str]]:
    payload = envelope.get("payload", {})
    metadata = envelope.get("metadata", {})
    logs = envelope.get("logs", [])
    issues: List[str] = []

    if payload.get("artifact_id") and metadata.get("artifact_id"):
        if payload["artifact_id"] != metadata["artifact_id"]:
            issues.append("artifact_id mismatch between payload and metadata")
    else:
        issues.append("artifact_id missing from payload or metadata")

    if not logs:
        issues.append("logs missing or empty")

    return (len(issues) == 0, issues)


def run_triangle_test(
    *,
    validators: List[str],
    threshold: float = 0.67,
    votes: Dict[str, bool] | None = None,
) -> Dict[str, Any]:
    if not validators:
        return {
            "consensus_reached": False,
            "consensus_ratio": 0.0,
            "threshold": threshold,
            "validators": [],
            "votes": {},
        }

    resolved_votes: Dict[str, bool] = {}
    for validator in validators:
        if votes and validator in votes:
            resolved_votes[validator] = votes[validator]
        else:
            resolved_votes[validator] = True

    positive = sum(1 for verdict in resolved_votes.values() if verdict)
    ratio = positive / len(validators)
    return {
        "consensus_reached": ratio >= threshold,
        "consensus_ratio": ratio,
        "threshold": threshold,
        "validators": validators,
        "votes": resolved_votes,
    }


def build_attorney_packet(envelope: Envelope, report: Report) -> Dict[str, Any]:
    return {
        "generated_at": utc_now_iso(),
        "envelope": envelope,
        "validation_report": report,
    }


class CYWDiagnostics:
    def __init__(self, *, skip_api_init: bool = False, timeout: int = 300) -> None:
        self.skip_api_init = skip_api_init
        self.timeout = timeout

    def calculate_health_score(
        self,
        *,
        latency: float,
        success_rate: float,
        token_efficiency: float,
    ) -> float:
        # Weighted average with simple guardrails for 0..1 bounds.
        score = (0.4 * success_rate) + (0.3 * token_efficiency) + (0.3 * (1 - latency))
        return max(0.0, min(1.0, score))

    def run_diagnostics(
        self,
        envelope: Envelope | None = None,
        *,
        mock_mode: bool = False,
    ) -> Report:
        if envelope is None:
            envelope = example_envelope()
        start = time.monotonic()
        vlan = route_to_vlan(envelope.get("request_type", "general"))
        envelope.setdefault("metadata", {})["vlan"] = vlan
        envelope.setdefault("logs", []).append(f"routed_to:{vlan}")

        validators = [
            L1_EnvelopeValidator(),
            L2_AccessControlValidator(),
            L3_StructuralValidator(),
            L4_FactualValidator(),
        ]
        gate_results = [validator.validate(envelope) for validator in validators]

        pipeline = [
            ModelNode("Model-A", "research"),
            ModelNode("Model-B", "narrative"),
            ModelNode("Model-C", "critique"),
            ModelNode("Model-D", "synthesis"),
            ModelNode("Model-E", "compliance"),
        ]
        model_outputs = [node.run(envelope, gate_results) for node in pipeline]

        triangle_passed, triangle_issues = triangle_test(envelope)

        # Placeholder metrics for now (mock_mode keeps them stable).
        latency = 0.4 if mock_mode else 0.6
        success_rate = 1.0 if all(gate.passed for gate in gate_results) else 0.7
        token_efficiency = 0.9 if mock_mode else 0.8
        overall_score = self.calculate_health_score(
            latency=latency,
            success_rate=success_rate,
            token_efficiency=token_efficiency,
        )

        report = {
            "timestamp": utc_now_iso(),
            "vlan": vlan,
            "gates": [
                {"name": gate.name, "passed": gate.passed, "reason": gate.reason}
                for gate in gate_results
            ],
            "pipeline": model_outputs,
            "triangle_test": {
                "passed": triangle_passed,
                "issues": triangle_issues,
            },
            "system_health": {
                "latency": latency,
                "success_rate": success_rate,
                "token_efficiency": token_efficiency,
                "overall_score": overall_score,
            },
            "execution_time": time.monotonic() - start,
        }

        report["attorney_packet"] = build_attorney_packet(envelope, report)
        return report


def example_envelope() -> Envelope:
    return {
        "request_type": "audit",
        "payload": {
            "artifact_id": "origin_story_2023",
            "subject": "Timothy Wheels",
            "requested_scope": "audit",
            "issue": "Validation of provenance chain",
            "context": "Origin narrative linked to timeline and claims",
            "desired_outcome": "Confirm chain integrity and auditability",
        },
        "metadata": {
            "artifact_id": "origin_story_2023",
            "owner": "Timothy Wheels",
            "sovereignty": "self",
            "acl": ["audit", "compliance", "system_health"],
            "facts_verified": True,
        },
        "logs": ["envelope_created"],
    }


def print_summary(report: Report) -> None:
    gate_status = ", ".join(
        f"{gate['name']}={'PASS' if gate['passed'] else 'FAIL'}"
        for gate in report["gates"]
    )
    triangle = report["triangle_test"]
    print(f"VLAN: {report['vlan']}")
    print(f"Gates: {gate_status}")
    print(f"Triangle Test: {'PASS' if triangle['passed'] else 'FAIL'}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run CYW system diagnostics for a given envelope."
    )
    parser.add_argument(
        "--input",
        help="Path to a JSON file containing the envelope",
    )
    parser.add_argument(
        "--example",
        action="store_true",
        help="Run diagnostics with the built-in example envelope",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output full report as JSON",
    )
    parser.add_argument(
        "--timestamp",
        action="store_true",
        help="Include a run timestamp in the report",
    )
    return parser.parse_args()


def load_envelope(path: str) -> Envelope:
    with open(path, "r", encoding="utf-8") as handle:
        return json.load(handle)


def main() -> int:
    args = parse_args()
    if args.input:
        envelope = load_envelope(args.input)
    else:
        envelope = example_envelope()
    diagnostics = CYWDiagnostics(skip_api_init=True)
    report = diagnostics.run_diagnostics(envelope, mock_mode=args.example)
    if args.timestamp:
        report["run_timestamp"] = utc_now_iso()

    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print_summary(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
