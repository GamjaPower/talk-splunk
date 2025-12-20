wget -O splunk_uf.tgz "https://download.splunk.com/products/universalforwarder/releases/9.4.7/linux/splunkforwarder-9.4.7-2a9293b80994-linux-amd64.tgz" && \
tar -xzf splunk_uf.tgz  -C /opt && \
install -m 400 hf_inputs.conf /opt/splunkforwarder/etc/system/local/inputs.conf && \
install -m 400 hf_outputs.conf /opt/splunkforwarder/etc/system/local/outputs.conf && \
/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt && \
/opt/splunkforwarder/bin/splunk stop && \
/opt/splunkforwarder/bin/splunk enable boot-start -user root && \
/opt/splunkforwarder/bin/splunk start

