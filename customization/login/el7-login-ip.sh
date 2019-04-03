

sudo tee /sbin/ifup-local <<EOF
#!/bin/sh
PREFIX="Local IP addresses:"
IPADDRS=$(hostname -I | tr " " "\n" | grep -v "^$" | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tr "\n" " ")

perl -i -p -0777 -e "s/^$PREFIX[^\n]*\n\n//m; s/$/\n$PREFIX $IPADDRS\n/ if length('$IPADDRS')>6" /etc/issue
EOF

sudo chmod +x /sbin/ifup-local

sudo cp /sbin/ifup-local /sbin/ifdown-local
