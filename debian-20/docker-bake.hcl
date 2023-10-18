group "default" {
  targets = ["builder"]
}

target "builder" {
  context    = "."
  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64", "linux/arm64/v8"]
  tags = [
    "registry.cn-shanghai.aliyuncs.com/nethost/node:20-builder",
    "docker.io/nethost/node:20-builder",
    "quay.io/nethost/node:20-builder",
    "ghcr.io/nethost/node:20-builder",
  ]
  push = true
}