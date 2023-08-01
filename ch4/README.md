# Mastering Prometheus Chapter 4
In this chapter we look at service discovery in Prometheus. This folder contains a code example of how to implement an `http_sd` provider for pulling data from sources not implemented as a discovery provider in Prometheus.

For example, if your company keeps track of servers in a database, you could implement an `http_sd` provider to pull that data and present it in a format acceptable to Prometheus.

The code used is located in the `http_sd` folder and it does two things:
1. Create a sqlite database and put some dummy data in it
2. Implement an HTTP server that will pull from the database and return it in a format Prometheus accepts.

## Running the Example
Presuming you already have Docker installed on your computer, you can run `docker compose up` from this directory and the example will be built and exposed on your computer.

You can access the example HTTP SD endpoint at `localhost:8888/targets` and Prometheus via `localhost:9090`.
