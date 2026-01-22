.PHONY: hash-chain validate deploy audit help

# Sovereign Deployment Pipeline - Static Site Version
# ===================================================

help:
	@echo "Sovereign Deployment Pipeline Commands:"
	@echo ""
	@echo "  make hash-chain   Generate SHA-256 hash of index.html"
	@echo "  make validate     Verify hash matches expected value"
	@echo "  make deploy       Full deployment: hash → commit → push"
	@echo "  make audit        Verify deployed site matches local source"
	@echo "  make help         Show this help message"
	@echo ""

hash-chain:
	@echo "Generating hash chain..."
	@shasum -a 256 index.html | tee HASH_CHAIN.txt
	@echo "✅ Hash chain generated"

validate:
	@echo "Validating local integrity..."
	@if [ ! -f "HASH_CHAIN.txt" ]; then \
		echo "❌ No hash chain found. Run: make hash-chain"; \
		exit 1; \
	fi
	@STORED_HASH=$$(cat HASH_CHAIN.txt | awk '{print $$1}'); \
	CURRENT_HASH=$$(shasum -a 256 index.html | awk '{print $$1}'); \
	if [ "$$STORED_HASH" = "$$CURRENT_HASH" ]; then \
		echo "✅ Validation passed: Hash matches"; \
	else \
		echo "❌ Validation failed: Hash mismatch"; \
		echo "   Expected: $$STORED_HASH"; \
		echo "   Current:  $$CURRENT_HASH"; \
		exit 1; \
	fi

deploy: hash-chain validate
	@echo "Starting deployment sequence..."
	@echo ""
	@echo "Phase 1: Hash generation ✅"
	@echo "Phase 2: Local validation ✅"
	@echo ""
	@echo "Phase 3: Git commit..."
	@git add index.html vercel.json HASH_CHAIN.txt docs/ README.md 2>/dev/null || true
	@git commit -m "Sovereign Update: $$(date -u +"%Y-%m-%d %H:%M:%S UTC")" || echo "No changes to commit"
	@echo ""
	@echo "Phase 4: Push to GitHub..."
	@git push origin main
	@echo ""
	@echo "Phase 5: Waiting for Vercel deployment (15s)..."
	@sleep 15
	@echo ""
	@echo "✅ Deployment complete"
	@echo ""
	@echo "Next: Run 'make audit' to verify integrity"

audit:
	@chmod +x scripts/validation/remote_audit.sh 2>/dev/null || chmod +x remote_audit.sh
	@if [ -f scripts/validation/remote_audit.sh ]; then \
		./scripts/validation/remote_audit.sh; \
	elif [ -f remote_audit.sh ]; then \
		./remote_audit.sh; \
	else \
		echo "❌ Audit script not found"; \
		echo "   Expected: scripts/validation/remote_audit.sh or ./remote_audit.sh"; \
		exit 1; \
	fi

# Emergency rollback
rollback:
	@echo "Rolling back to previous commit..."
	@git revert HEAD --no-edit
	@git push origin main
	@echo "Waiting for Vercel redeploy (15s)..."
	@sleep 15
	@echo "✅ Rollback complete"
	@echo ""
	@echo "Run 'make audit' to verify rollback integrity"
