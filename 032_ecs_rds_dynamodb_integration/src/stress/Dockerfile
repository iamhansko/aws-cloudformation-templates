FROM public.ecr.aws/docker/library/golang:1.22.2-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build -o stressapp main.go
FROM public.ecr.aws/docker/library/amazonlinux:2023
WORKDIR /app
COPY --from=builder /app/stressapp /app/stressapp
RUN yum install -y ca-certificates && yum clean all
EXPOSE 8080
ENTRYPOINT ["/app/stressapp"]