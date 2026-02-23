# Use Ubuntu as the base image
FROM ubuntu:latest

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages: sudo, fish, bash, nano, and utilities
RUN apt-get update && apt-get install -y \
    sudo \
    fish \
    bash \
    nano \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create user 'kevinrp' with fish as default shell
RUN useradd -m -s /usr/bin/fish kevinrp

# Set passwords for root and kevinrp
# Root password: root@2026@123
# Kevinrp password: passwordpassword
RUN echo "root:root@2026@123" | chpasswd && \
    echo "kevinrp:passwordpassword" | chpasswd

# Add kevinrp to sudo group
RUN usermod -aG sudo kevinrp

# Configure sudoers:
# 1. Allow kevinrp to use sudo
# 2. Allow kevinrp to use specific commands without a password
RUN echo "kevinrp ALL=(ALL) ALL" >> /etc/sudoers && \
    echo "kevinrp ALL=(ALL) NOPASSWD: /usr/bin/nano, /usr/bin/apt-get, /bin/cp, /bin/mv, /usr/bin/curl" >> /etc/sudoers

# Create build-key.json with a specific value in /root/build/
# Only accessible by root (mode 600)
RUN mkdir -p /root/build && \
    echo '{"key": "cfygiukFYG#567257FG4CBH##"}' > /root/build/build-key.json && \
    chown root:root /root/build/build-key.json && \
    chmod 600 /root/build/build-key.json

# Set the default user to kevinrp
USER kevinrp

# Set the working directory to kevinrp's home directory
WORKDIR /home/kevinrp

# Set the default shell to fish for terminal access
ENTRYPOINT ["/usr/bin/fish"]
