import metrics, metrics/chronos_httpserver, chronicles, strformat, std/random
import net
import os

const
  version = "0.1.0"
  metricsAddress = "127.0.0.1"
  metricsPort = Port(8000)
  labelSeed = 15

proc randomString(length: int): string =
  const alphabet = "abcdefghijklmnopqrstuvwxyz"
  for _ in 0 ..< length:
    result.add(alphabet[rand(alphabet.high)])
  return result

proc randomServiceName(): string =
  const friendlyNames = [
    "microservice", "worker", "cogitator", "generator", "facilitator", "mailer",
    "notifier", "scheduler", "processor", "aggregator", "collector", "dispatcher",
    "monitor", "analyzer", "validator", "transformer", "router", "broker", "connector",
    "adapter", "listener", "watcher", "watchdog", "controller", "supervisor",
    "inspector", "auditor", "regulator", "evaluator", "profiler", "tracer",
  ]
  return friendlyNames[rand(friendlyNames.high)]

proc daysToExpireCerts(seed: int) =
  declareCounter ssl_days_to_expire,
    "http endpoints and their certificates", ["cert_name", "fqdn"]
  var
    days = 0
    certSuffix: string = ".pem"
    fqdnSuffix: string = ".sosafe.de"

  for i in 0 .. seed:
    days += rand(365)
    let numSuffix = rand(9)
    let certname = randomString(4) & certSuffix
    let fqdnRandom = randomServiceName() & "-" & $numSuffix & fqdnSuffix
    info "Certificate expiration in days",
      days = days, certname = certname, fqdn = fqdnRandom
    ssl_days_to_expire.inc(days, labelValues = [certname, fqdnRandom])

proc setupMetrics() =
  declareGauge memoryUtilization, "memory utilization"
  daysToExpireCerts(labelSeed)
  startMetricsHttpServer(metricsAddress, metricsPort)

  info fmt"Server started http://{metricsAddress}:{metricsPort}",
    address = $metricsAddress, port = $metricsPort

  while true:
    sleep(1000)
    info "Memory usage", memoryUtilization = memoryUtilization.value
    memoryUtilization.inc(rand(6))

proc main() =
  setupMetrics()

when isMainModule:
  main()
