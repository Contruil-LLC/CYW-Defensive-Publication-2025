import pytest
from cyw_system_diagnostics import CYWDiagnostics


def test_diagnostics_initialization():
    """Verify diagnostics module loads without API keys."""
    diag = CYWDiagnostics(skip_api_init=True)
    assert diag is not None


def test_health_scoring_logic():
    """Validate health score calculation bounds."""
    diag = CYWDiagnostics(skip_api_init=True)
    score = diag.calculate_health_score(
        latency=0.5,
        success_rate=0.95,
        token_efficiency=0.85,
    )
    assert 0.0 <= score <= 1.0


@pytest.mark.timeout(10)
def test_api_timeout_handling():
    """Ensure diagnostics don't hang on unresponsive APIs."""
    diag = CYWDiagnostics(timeout=2)
    result = diag.run_diagnostics(mock_mode=True)
    assert result["execution_time"] < 5.0
