# nethost/node

## Overview

**nethost/node** is a minimal, production-ready container base image for Node.js applications, built from and fully compatible with [Google’s distroless nodejs-debian12 images](https://github.com/GoogleContainerTools/distroless).  
This image includes only the essential runtime environment for Node.js (without shell, package managers, or debugging tools) and is perfect for secure, lightweight, and modern cloud-native deployments.

---

## Features

- **Ultra lightweight**: Images are only a few MB, enabling fast pulls and container startup.
- **Maximum security**: No shell, no package manager, no debugging tools – reduces vulnerabilities and attack surface.
- **LTS versions**: Built for Node.js 24, 22, and 20, covering current and recent LTS releases.
- **Cloud-native ready**: Ideal for Kubernetes, serverless, CI/CD pipelines, and production workloads.

---

## Supported Tags

- `nethost/node:24`
- `nethost/node:22`
- `nethost/node:20`

All tags correspond directly to the matching [distroless nodejsXX-debian12 images](https://github.com/GoogleContainerTools/distroless).

---

## Usage Example

Assuming your Node.js project is built and you want to run `app.js`:

```Dockerfile
# Stage 1: Build your app (if needed)
FROM nethost/node:24-builder AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Stage 2: Minimal runtime
FROM nethost/node:24
WORKDIR /app
COPY --from=builder /app /app
CMD ["app.js"]
```

- All application logs should go to stdout/stderr for best container practice.

---

## Notes

- These images **do not** include a shell (`sh`/`bash`), package managers (`npm`/`yarn`), or debugging tools.
- All dependencies (including `node_modules` and config files) should be installed during the build phase and copied in.
- For troubleshooting, use a debug sidecar container or ephemeral containers provided by your orchestrator.

---

## Recommended Use Cases

- Production deployment of Node.js microservices
- Environments with strict security or supply chain requirements
- Any workflow demanding minimal image size and fast startup

---

## References

- [GoogleContainerTools/distroless (GitHub)](https://github.com/GoogleContainerTools/distroless)
- [Distroless images: best practices (Google Cloud Blog)](https://cloud.google.com/blog/products/containers-kubernetes/introducing-distroless-container-images)

---

## License

These images are fully compatible with and follow the licensing of [Google’s distroless nodejs-debian images](https://github.com/GoogleContainerTools/distroless).

---
