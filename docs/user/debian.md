# Debian/Ubuntu Setup

To add this repository to your Debian-based system, follow these steps:

### 1. Download the Repository Public Key
```bash
curl -fsSL https://[USER].github.io/[REPO]/public.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/pkg-repo.gpg
```

### 2. Add the Repository to your Sources List
```bash
echo "deb [signed-by=/etc/apt/trusted.gpg.d/pkg-repo.gpg] https://[USER].github.io/[REPO]/debian /" | sudo tee /etc/apt/sources.list.d/pkg-repo.list
```

### 3. Update and Install
```bash
sudo apt update
sudo apt install [package-name]
```

---
*Note: Replace `[USER]` and `[REPO]` with your actual GitHub username and repository name.*
