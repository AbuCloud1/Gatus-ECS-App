# Multi-stage build for Gatus from source
# Test comment to trigger build workflow
# Updated: Testing automatic workflow trigger
# Final test: Improved workflow with ECR repo check
# OIDC test: Checking if authentication works now
FROM golang:1.24-alpine AS builder

RUN apk --update add ca-certificates git make
WORKDIR /app
COPY source/ ./

# Build Go binary
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o gatus .

# Runtime stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates tzdata
WORKDIR /app

COPY --from=builder /app/gatus .
COPY config.yaml ./config/config.yaml

ENV GATUS_CONFIG_PATH="/app/config/config.yaml"
ENV GATUS_LOG_LEVEL="INFO"
ENV PORT="8080"

EXPOSE ${PORT}

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

ENTRYPOINT ["/app/gatus"]
