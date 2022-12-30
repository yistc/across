#! /bin/bash

TEST_FILES_ALL=(
    # softlayer
    http://speedtest.tok02.softlayer.com/downloads/test500.zip
    
    # Digital Ocean
    http://speedtest-sgp1.digitalocean.com/5gb.test
    http://speedtest-sfo3.digitalocean.com/5gb.test

    # Linode
    http://speedtest.ap-south-1.linodeobjects.com/1GB_test.file
    http://speedtest.ap-south-1.linodeobjects.com/10GB_test.file
    http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin
    http://speedtest.singapore.linode.com/100MB-singapore.bin

    # Vultr
    https://sgp-ping.vultr.com/vultr.com.1000MB.bin
    https://hnd-jp-ping.vultr.com/vultr.com.1000MB.bin
    https://wa-us-ping.vultr.com/vultr.com.1000MB.bin

    # Discord CDN

    # Leaseweb
    http://mirror.hkg10.hk.leaseweb.net/speedtest/1000mb.bin
    http://mirror.tyo10.jp.leaseweb.net/speedtest/1000mb.bin
    http://mirror.sin1.sg.leaseweb.net/speedtest/1000mb.bin
    http://mirror.sfo12.us.leaseweb.net/speedtest/1000mb.bin
)

TEST_FILES_JP=(
    http://speedtest.tok02.softlayer.com/downloads/test500.zip
    http://mirror.tyo10.jp.leaseweb.net/speedtest/1000mb.bin
    https://hnd-jp-ping.vultr.com/vultr.com.1000MB.bin
    http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin
)

for i in {1..10}; do
    for file in ${TEST_FILES_JP[@]}; do
        echo "Testing $file"
        wget -O /dev/null $file
    done
done