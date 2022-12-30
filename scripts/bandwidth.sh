#! /bin/bash

TEST_FILES=(
    # softlayer
    http://speedtest.sea01.softlayer.com/downloads/test500.zip
    http://speedtest.sjc01.softlayer.com/downloads/test500.zip
    http://speedtest.hkg02.softlayer.com/downloads/test500.zip
    http://speedtest.tok02.softlayer.com/downloads/test500.zip

    # hetzner
    https://speed.hetzner.de/100MB.bin
    
    # Digital Ocean
    http://speedtest-sgp1.digitalocean.com/5gb.test
    http://speedtest-sfo3.digitalocean.com/5gb.test

    # Linode
    http://speedtest.ap-south-1.linodeobjects.com/1GB_test.file
    http://speedtest.ap-south-1.linodeobjects.com/10GB_test.file

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

for file in ${TEST_FILES[@]}; do
    echo "Testing $file"
    wget -O /dev/null $file
done