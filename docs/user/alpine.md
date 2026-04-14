# Alpine Linux Setup

To add this repository to your Alpine Linux installation, follow these steps:

### 1. Download and Trust the Repository Public Key
```bash
sudo curl -fsSL https://nerdit-tech.github.io/pkg-linux/repo/alpine.rsa.pub -o /etc/apk/keys/pkg-linux.rsa.pub
```

### 2. Add the Repository
```bash
echo "https://nerdit-tech.github.io/pkg-linux/repo/alpine" | sudo tee -a /etc/apk/repositories
```

### 3. Update and Install
```bash
sudo apk update
sudo apk add [package-name]
```

---
*For a list of available packages, visit the [Package Search](../packages.md) page.*

