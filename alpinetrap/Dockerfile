FROM alpine:3.9
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 22

## Root is gloriously unsecure!
RUN apk add --no-cache openssh \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:root" | chpasswd

RUN echo -e '#!/bin/ash\n\nssh-keygen -A\n/usr/sbin/sshd -D -e "$@"' > /entrypoint.sh
RUN chmod 555 /entrypoint.sh
