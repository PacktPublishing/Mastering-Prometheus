# Chapter 13

## Robust Request Based SLO Query
In this chapter, we use the following query that has a noted edge case:
```promql
  clamp_min(
    sum without (pod, instance) (increase(prometheus_http_request_duration_seconds_bucket{le="0.1"}[5m])),
    1
  )
/ ignoring (le)
  clamp_min(
    sum without (pod, instance) (increase(prometheus_http_request_duration_seconds_bucket{le="+Inf"}[5m])),
    1
  )

```

The more robust version is:
```promql
  (
      (
          (
            clamp_min(
              sum without (pod, instance) (
                increase(prometheus_http_request_duration_seconds_bucket{le="0.1"}[5m])
              ),
              1
            )
          )
        and ignoring (le)
          (
              sum without (pod, instance) (
                increase(prometheus_http_request_duration_seconds_bucket{le="+Inf"}[5m])
              )
            ==
              0
          )
      )
    or
      (
        sum without (pod, instance) (
          increase(prometheus_http_request_duration_seconds_bucket{le="0.1"}[5m])
        )
      )
  )
/ ignoring (le)
  clamp_min(
    sum without (pod, instance) (
      increase(prometheus_http_request_duration_seconds_bucket{le="+Inf"}[5m])
    ),
    1
  )
```
This version will only apply the `clamp_min` on the numerator if the total number of requests is 0.

## Sloth

To use [Sloth](https://sloth.dev/) to generate Prometheus rules:
```console
$ sloth generate -i ch13/sloth.yaml -o ch13/sloth-generated.yaml
```

## Pyrra
To use [Pyyra](https://github.com/pyrra-dev/pyrra) to generate Prometheus rules:
```console
$ pyrra generate --config-files ch13/pyrra.yaml --prometheus-folder="ch13/pyrra-out/"
```
