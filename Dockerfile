# stage build
FROM --platform=linux/amd64 golang:latest as build

WORKDIR /build

COPY go.mod ./
RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app

# stage imagem final
FROM --platform=linux/amd64 alpine:latest

RUN apk add tzdata \
    && cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

WORKDIR /apps

COPY --from=build /build/app ./

CMD [ "./app" ]