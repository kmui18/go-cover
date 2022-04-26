test-coverage:
	@echo "integration testing..."
	TESTING=anar go test -v ./... -coverprofile=tmp.cov ./...
	@EXIT_CODE=$$?
	@cat tmp.cov | grep -v '.pb.go' > nongenerated_code.cov
	@go tool cover -func nongenerated_code.cov
	# @go tool cover -html=nongenerated_code.cov
	# -@rm *.cov
	@exit $$EXIT_CODE

test-coverage-multiple:
	@go test -v -cover `go list ./... | grep -v /pkg2/`  -coverprofile=tmp1.cov ./... || exit
	@go test -v -cover ./pkg2/... -coverprofile=tmp2.cov ./... || (make test-teardown && false)
	@echo "mode: set" > coverage.out && cat *.cov | grep -v mode: | sort -r | awk '{if($$1 != last) {print $$0;last=$$1}}' >> coverage.out
	@cat coverage.out | grep -v '.pb.go' > nongenerated_code.cov
	@go tool cover -func nongenerated_code.cov