# ------------------------------------------------------------
# Build stage
# ------------------------------------------------------------
FROM docker.io/library/golang:1.27 AS builder

WORKDIR /src

COPY go.mod ./
COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build \
    -trimpath \
    -ldflags="-s -w" \
    -o /hello \
    .


# ------------------------------------------------------------
# Runtime stage
# ------------------------------------------------------------
FROM gcr.io/distroless/static-debian13:nonroot

COPY --from=builder /hello /hello

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/hello"]
