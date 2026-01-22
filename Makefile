# Sovereign Deployment Ritual
# Purpose: Rebuild, Validate, Commit, and Audit remote integrity.

.PHONY: deploy audit

deploy:
	@echo "🛡️ Executing Sovereign Deployment Ritual..."
	./scripts/validation/rebuild_chain.sh && \
	./scripts/validation/validate_chain.sh && \
	git add . && \
	git commit -m "Sovereign Update: $(shell date +%Y-%m-%d)" && \
	git push origin main
	@echo "⌛ Waiting for Vercel propagation..."
	@sleep 15
	@$(MAKE) audit

audit:
	@echo "📡 Verifying remote deployment at timothywheels.com..."
	./scripts/validation/remote_audit.sh
