FROM golang:1.13
WORKDIR /var/app
COPY main.go .
RUN GOOS=linux go build -o goapp

FROM debian:buster-slim
WORKDIR /var/app
COPY --from=0 /var/app/goapp goapp
COPY *.html .
EXPOSE 5000
ENTRYPOINT ["./goapp"]
