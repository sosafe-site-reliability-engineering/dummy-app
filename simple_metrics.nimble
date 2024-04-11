# Package

version       = "0.1.0"
author        = "sosafe-michal-scasny"
description   = "Just a dummy metrics and log server"
license       = "MIT"
srcDir        = "src"
bin           = @["simple_metrics"]


# Dependencies

requires "nim >= 2.0.2"
requires "chronicles"
requires "metrics"
