FROM golang:1.18-buster AS builder
WORKDIR /app
COPY go.* ./
COPY *.go ./
RUN go build -o /hello_go_http

FROM gcr.io/distroless/base-debian11

WORKDIR /

COPY --from=builder /hello_go_http /hello_go_http

ENTRYPOINT ["/hello_go_http"]
