#!/usr/bin/env bash

set -e

DOMAIN=$1
OUT="recon-$DOMAIN"
mkdir -p $OUT

echo "[+] Subdomain enumeration"
subfinder -d $DOMAIN -silent >$OUT/subs.txt
assetfinder --subs-only $DOMAIN >>$OUT/subs.txt
amass enum -passive -d $DOMAIN >>$OUT/subs.txt
sort -u $OUT/subs.txt -o $OUT/subs.txt

echo "[+] Alive filtering"
cat $OUT/subs.txt | httpx -silent -mc 200,302,403 >$OUT/alive.txt

echo "[+] Port scanning"
masscan -iL $OUT/alive.txt -p1-65535 --rate=1000 -oL $OUT/masscan.txt || true
nmap -iL $OUT/alive.txt -T4 -oN $OUT/nmap.txt

echo "[+] Crawling"
cat $OUT/alive.txt | hakrawler -depth 2 -plain >$OUT/urls.txt
cat $OUT/alive.txt | gospider -q -o $OUT/gospider
cat $OUT/urls.txt | sort -u >$OUT/all_urls.txt

echo "[+] JS extraction"
cat $OUT/all_urls.txt | grep "\.js" | sort -u >$OUT/js.txt
cat $OUT/js.txt | subjs >$OUT/js_endpoints.txt

echo "[+] Parameter discovery"
paramspider -d $DOMAIN --quiet
mv output/$DOMAIN.txt $OUT/params.txt || true

echo "[+] Content fuzzing"
ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -u https://FUZZ.$DOMAIN -mc 200,302,403 -o $OUT/ffuf_subdomains.json || true

ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -u https://$DOMAIN/FUZZ -mc 200,302,403 -o $OUT/ffuf_dirs.json || true

echo "[+] Vulnerability scan"
nikto -h https://$DOMAIN -output $OUT/nikto.txt || true
sqlmap -m $OUT/params.txt --batch --level=1 --risk=1 --output-dir=$OUT/sqlmap || true

echo "[+] Subdomain takeover"
subjack -w $OUT/subs.txt -t 50 -o $OUT/takeover.txt || true

echo "[+] Cloud checks"
aws s3 ls s3://$DOMAIN || true
lazys3 -d $DOMAIN >$OUT/s3.txt || true

echo "[+] Screenshots"
gowitness file -f $OUT/alive.txt -P $OUT/screens || true

echo "[+] Secrets scanning"
trufflehog filesystem --directory . >$OUT/secrets.txt || true

echo "[+] Done. Output in $OUT"
