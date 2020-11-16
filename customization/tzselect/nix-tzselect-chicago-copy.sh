sudo cp /etc/localtime /etc/localtime.bak-"$(date --utc +%FT%T.%3NZ)"
sudo cp /usr/share/zoneinfo/America/Chicago /etc/localtime
