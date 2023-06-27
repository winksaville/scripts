Scripts that are used by OpenWRT router with a Hostname of
mwan3-2850. This is configured with MutliWAN support using mwan3.
See https://openwrt.org/docs/guide-user/network/wan/multiwan/mwan3

mwan3.user       A script that lives in /etc/ and is automatially
                 invoked by mwan3 when an ACTION occurs

date-utc-nlf.sh  A script that is used by mwan3.user and lives in
                 /root it prints the date in utc without a linefeed

mail-wink.sh     A script that is used by mwan3.user and lives in
                 /root it sends an email to wink@saville.com and an
                 sms to 8312342134

