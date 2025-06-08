find /Oracle -type f -name "*.tar" -exec ls -l {} \;
find /Oracle -type f -name "*.tar" -mtime -7 -exec ls -l {} \;
find /Oracle -type f -name "*.tar" -size +100M -exec ls -l {} \;