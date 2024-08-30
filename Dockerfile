FROM debian:stable-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    build-essential \
    nghttp2 \
    libnghttp2-dev \
    libssl-dev

# Install Python packages
RUN pip3 install fava beancount --break-system-packages

# Create update script
RUN echo '#!/bin/bash\n\
cd /beans\n\
git pull\n\
git add .\n\
git commit -m "Automatic update"\n\
git push\n\
' > /usr/local/bin/update_repo.sh \
    && chmod +x /usr/local/bin/update_repo.sh

# Create entrypoint script
RUN echo '#!/bin/bash\n\
# Clone the repository if it doesn'"'"'t exist\n\
if [ ! -d "/beans/.git" ]; then\n\
    # Depending on the USE_HTTPS environment variable, use the appropriate URL\n\
    if [ "${USE_HTTPS}" = "true" ]; then\n\
        URL="https://${GIT_USERNAME}:${GIT_PASSWORD}@${GIT_REPO_URL#https://}"\n\
    else\n\
        URL="http://${GIT_USERNAME}:${GIT_PASSWORD}@${GIT_REPO_URL#http://}"\n\
    fi\n\
    git clone ${URL} /beans\n\
fi\n\
\n\
# Configure git\n\
git config --global user.email "${GIT_EMAIL}"\n\
git config --global user.name "${GIT_NAME}"\n\
\n\
# Start the update loop\n\
(while true; do\n\
    /usr/local/bin/update_repo.sh\n\
    sleep 10\n\
done) &\n\
\n\
# Start Fava\n\
fava --host=0.0.0.0 /beans/beans/main.beancount\n\
' > /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 5000

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
