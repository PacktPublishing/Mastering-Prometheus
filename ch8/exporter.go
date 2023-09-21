package main

import (
	"log"
	"net/http"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var myMetric = prometheus.NewDesc("exporter_success", "Reflects if the exporter is working.", []string{}, nil)

type myCollector struct{}

func (c myCollector) Describe(ch chan<- *prometheus.Desc) {
	ch <- myMetric
}

func (c myCollector) Collect(ch chan<- prometheus.Metric) {
	ch <- prometheus.MustNewConstMetric(myMetric, prometheus.GaugeValue, 1.0)
}

func main() {
	prometheus.MustRegister(&myCollector{})
	http.Handle("/metrics", promhttp.Handler())
	log.Fatal(http.ListenAndServe(":9999", nil))
}
