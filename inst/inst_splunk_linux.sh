wget -O splunk.tgz "https://download.splunk.com/products/splunk/releases/9.4.7/linux/splunk-9.4.7-2a9293b80994-linux-amd64.tgz" && \
tar -xzf splunk.tgz  -C /opt && \
install -m 400 user-seed.conf /opt/splunk/etc/system/local/user-seed.conf && \
/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt && \
/opt/splunk/bin/splunk enable boot-start