terraform {
  required_providers {
    datadog = {
      source = "Datadog/datadog"
    }
  }
  required_version = ">= 0.11"
}
# Configure the Datadog provider
provider "datadog" {
  api_url = "https://api.datadoghq.eu/
}
# Create a new monitor
resource "datadog_monitor" "cpu_anomalous" {
  name = "Anomalous CPU usage"
  type = "query alert"
  message = "CPU utilization is outside normal bounds"
  query = "avg(last_4h):anomalies(ewma_20(avg:system.cpu.system{env:prod,service:website}.as_rate()), 'robust', 3, direction='below', alert_window='last_30m', interval=60, count_default_zero='true', seasonality='weekly') >= 1"
  thresholds {
    critical          = 1.0
    critical_recovery = 0.0
  }
  threshold_windows {
    trigger_window    = "last_30m"
    recovery_window   = "last_30m"
  }

  notify_no_data    = false
  renotify_interval = 60
}
