# Multi-stage build for Gatus from source
FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk --update add ca-certificates git make

# Set working directory
WORKDIR /app

# Copy Gatus source code
COPY source/ ./

# Download Go dependencies and build
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o gatus .

# Build frontend if needed (uncomment if you want to customize the UI)
# RUN cd web/app && npm install && npm run build

# Final stage
FROM alpine:latest

# Install runtime dependencies
RUN apk --no-cache add ca-certificates tzdata

# Create app directory
WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/gatus .

# Copy your custom config
COPY config.yaml ./config/config.yaml

# Set environment variables
ENV GATUS_CONFIG_PATH="/app/config/config.yaml"
ENV GATUS_LOG_LEVEL="INFO"
ENV PORT="8080"

# Expose port
EXPOSE ${PORT}

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

# Run Gatus
ENTRYPOINT ["/app/gatus"]
