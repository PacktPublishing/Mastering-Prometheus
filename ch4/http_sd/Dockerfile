FROM golang:1.20 AS build
WORKDIR /app
COPY go.mod go.sum main.go /app/

RUN go build -o http_sd_example main.go 

FROM busybox
COPY --from=build /app/http_sd_example /usr/bin/http_sd_example
EXPOSE 8888
ENTRYPOINT ["/usr/bin/http_sd_example"]
