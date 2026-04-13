# RedHat/Fedora/CentOS Setup

To use this repository on RedHat Enterprise Linux, CentOS, or Fedora, follow these steps:

## 1. Create the Repo Configuration

Create a new repository configuration file in `/etc/yum.repos.d/pkg-linux.repo`:

```bash
sudo tee /etc/yum.repos.d/pkg-linux.repo <<EOF
[pkg-linux]
name=Package Linux Repository
baseurl=https://your-username.github.io/pkg-linux/repo/redhat/
enabled=1
gpgcheck=1
gpgkey=https://your-username.github.io/pkg-linux/repo/redhat/RPM-GPG-KEY-pkg-linux
EOF
```

*(Replace `your-username` with the actual GitHub username)*

## 2. Install Packages

Once the repository is configured, you can install packages using `dnf` or `yum`:

```bash
# Using DNF (modern systems)
sudo dnf install <package-name>

# Using YUM (older systems)
sudo yum install <package-name>
```

## GPG Key Troubleshooting

If the automatic GPG key import fails, you can manually import it:

```bash
sudo rpm --import https://your-username.github.io/pkg-linux/repo/redhat/RPM-GPG-KEY-pkg-linux
```
