set -x
echo "script vers: $(git rev-parse HEAD)"
echo "start time: $(date)"

awk -v OFS=',' '{
    cmd = "echo \047" $0 "\047 | md5sum"
    val = ( (cmd | getline line) > 0 ? line : "FAILED")
    close(cmd)
    sub(/ .*/,"",val)
    print $0, val
}' Minimized.csv > mini2md5.csv

headr_m=$(awk -F, 'NR == 1 { print $10 }' mini2md5.csv)
sed -i -e '1s/'$headr_m'/md5sum/' mini2md5.csv
