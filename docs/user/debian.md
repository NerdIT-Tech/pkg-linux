# Debian/Ubuntu Setup

To add this repository to your Debian-based system, follow these steps:

### 1. Download the Repository Public Key
```bash
curl -fsSL https://nerdit-tech.github.io/pkg-linux/repo/public.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/pkg-repo.gpg
```

### 2. Add the Repository to your Sources List
```bash
echo "deb [signed-by=/etc/apt/trusted.gpg.d/pkg-repo.gpg] https://nerdit-tech.github.io/pkg-linux/repo/debian /" | sudo tee /etc/apt/sources.list.d/pkg-repo.list
```

### 3. Update and Install
```bash
sudo apt update
sudo apt install [package-name]
```

---
*For a list of available packages, visit the [Package Search](../packages.md) page.*
