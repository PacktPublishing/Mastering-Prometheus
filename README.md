# Mastering Prometheus

<a href="https://www.packtpub.com/product/mastering-prometheus/9781805125662"><img src="https://m.media-amazon.com/images/I/71ViQFC0tML._SY425_.jpg" alt="Book Name" height="256px" align="right"></a>

This is the code repository for [Mastering Prometheus](https://www.packtpub.com/product/mastering-prometheus/9781805125662), published by Packt.

**Gain expert tips to monitoring your infrastructure, applications, and services**

## What is this book about?
With an increased focus on observability and reliability, establishing a scalable and reliable monitoring environment is more important than ever. Over the last decade, Prometheus has emerged as the leading open-source, time-series based monitoring software catering to this demand. This book is your guide to scaling, operating, and extending Prometheus from small on-premises workloads to multi-cloud globally distributed workloads and everything in between.
Starting with an introduction to Prometheus and its role in observability, the book provides a walkthrough of its deployment. You’ll explore Prometheus’s query language and TSDB data model, followed by dynamic service discovery for monitoring targets and refining alerting through custom templates and formatting.

This book covers the following exciting features: 
* Deploy Prometheus and Node Exporter to public clouds and Kubernetes
* Gain in-depth knowledge of how Prometheus’s underlying code works
* Build your own custom service-discovery providers for Prometheus
* Debug Prometheus performance issues to identify cardinality issues in your environment
* Use VictoriaMetrics and/or Grafana Mimir for remote storage of Prometheus data
* Define and implement SLO-based alerting

If you feel this book is for you, get your [copy](https://www.amazon.com/Mastering-Prometheus-monitoring-infrastructure-applications-ebook/dp/B0CW19LP68) today!

<a href="https://www.packtpub.com/?utm_source=github&utm_medium=banner&utm_campaign=GitHubBanner"><img src="https://raw.githubusercontent.com/PacktPublishing/GitHub/master/GitHub.png" alt="https://www.packtpub.com/" border="5" /></a>

## Instructions and Navigations
All of the code is organized into folders. For example, Chapter09.

The code will look like the following:
```
$ helm uninstall vmsingle --namespace prometheus

$ helm upgrade --namespace prometheus \
--version 47.0.0 \
--values mastering-prometheus/ch9/prom-values.yaml \
mastering-prometheus \
prometheus-community/kube-prometheus-stack

```

**Following is what you need for this book:**
The book is for site reliability engineers (SREs), developers, and platform engineers involved in the monitoring and observability of their team or company’s systems. A background in Prometheus is assumed, so the book dedicates minimal time to the basics of getting Prometheus up and running. Whether you aim to expand monitoring capabilities, streamline configuration management, or enhance integration with existing tools, this book will help you maximize the potential of your Prometheus monitoring stack.

With the following software and hardware list you can run all code files present in the book (Chapter 1-15).

### Software and Hardware List

| Chapter  | Software required                                                       | OS required                       |
| -------- | ------------------------------------------------------------------------| ----------------------------------|
| 1-15     | Kubernetes, Prometheus, Thanos, OpenTelemetry, Helm                     | Windows, Mac OS X, and Linux (Any)|


### Related products <Other books you may enjoy>
* The Music Producer's Creative Guide to Ableton Live 11 [[Packt]](https://www.packtpub.com/product/the-music-producers-creative-guide-to-ableton-live-11/9781801817639) [[Amazon]](https://www.amazon.com/Music-Producers-Guide-Ableton-Live/dp/1801817634)

* The Music Producer's Ultimate Guide to FL Studio 21 - Second Edition [[Packt]](https://www.packtpub.com/product/the-music-producers-ultimate-guide-to-fl-studio-21-second-edition/9781837631650) [[Amazon]](https://www.amazon.com/Music-Producers-Ultimate-Guide-Studio-ebook/dp/B0C3MGC72H)

## Get to Know the Author
**Will Hegedus**
He has worked in tech for over a decade in a variety of roles, most recently in Site Reliability Engineering. After becoming the first SRE at Linode, an independent cloud provider, he came to Akamai Technologies by way of an acquisition.
Now, Will manages a team of SREs focused on building an internal observability platform for Akamai&rsquo;s Connected Cloud. His team's responsibilities include managing a global fleet of Prometheus servers ingesting millions of data points every second.
Will is an open-source advocate with contributions to Prometheus, Thanos, and other CNCF projects related to Kubernetes and observability.
