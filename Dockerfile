FROM golang:1.25.4-alpine AS build

RUN apk add --no-cache git ca-certificates

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main main.go

FROM alpine:3.20

RUN apk add --no-cache git ca-certificates

WORKDIR /app

COPY --from=build /app/main .

EXPOSE 3000

CMD ["./main"]