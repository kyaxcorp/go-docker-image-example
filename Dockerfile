# syntax=docker/dockerfile:1

# https://docs.docker.com/language/golang/build-images/#prerequisites

# Select the starting docker image
FROM golang:1.16-alpine

# Change the working directory
WORKDIR /app

# Copy the go modules so we can start the download of the necessary libraries
COPY go.mod ./
COPY go.sum ./
# Start downloading the libs
RUN go mod download

# Copy the current project contents
COPY *.go ./

# Start the go builder
RUN go build -o /go-docker-image-example


EXPOSE 8080

# Launch the app
CMD [ "/go-docker-image-example" ]


