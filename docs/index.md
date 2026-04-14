# Automated Package Repository

This repository hosts a multi-format package repository for **Debian** (APT), **RedHat** (YUM/DNF), and **Alpine** (APK). It is automatically managed and deployed via GitHub Actions and GitHub Pages.

## 🚢 For End-Users

To add this repository to your system, please refer to our user guides.

- [Debian/Ubuntu Setup](user/debian.md)
- [CentOS/Fedora/RHEL Setup](user/redhat.md)
- [Alpine Linux Setup](user/alpine.md)

## 📦 For Contributors

We welcome package submissions! To submit a package:

1.  **Fork** this repository.
2.  Place your binary package file in the appropriate `incoming/` directory:
    - `incoming/debian/` (for `.deb`)
    - `incoming/redhat/` (for `.rpm`)
    - `incoming/alpine/` (for `.apk`)
3.  **Open a Pull Request** using the provided template.
4.  Our automated CI will validate the package.
5.  Once merged, the package will be automatically signed and added to the official repository index.

## 🛠️ Developer Resources

- [Architecture Overview](dev/architecture.md)
- [CI/CD Workflow Details](dev/workflows.md)
- [Automated Submission via API/CLI](dev/automation.md)
