#! /usr/bin/zsh
# nexttrace

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Check if root
if [ "$EUID" -ne 0 ]
  then echo -e "${RED}Please run as root${NC}"
  exit
fi

# Variables
export ipAddr=''
export ip6Addr=''
export linux_relese=''


# read arguments with while
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            echo "Usage: yistc.sh [options]"
            echo "Options:"
            echo "  -h, --help            show brief help"
            echo "  -i, --ip              set ip address"
            echo "  -6, --ip6             set ip6 address"
            exit 0
            ;;
        -i|--ip)
            shift
            if test $# -gt 0; then
                export ipAddr=$1
            else
                echo "no ip specified"
                exit 1
            fi
            shift
            ;;
        -6|--ip6)
            shift
            if test $# -gt 0; then
                export ip6Addr=$1
            else
                echo "no ip6 specified"
                exit 1
            fi
            shift
            ;;
        *)


# OS
OS=$(uname -s) # Linux, FreeBSD, Darwin
ARCH=$(uname -m) # x86_64, arm64, aarch64
DISTRO=$( ([[ -e "/usr/bin/yum" ]] && echo 'CentOS') || ([[ -e "/usr/bin/apt" ]] && echo 'Debian') || echo 'unknown' )
debug=$( [[ $OS == "Darwin" ]] && echo true || echo false )
cnd=$( tr '[:upper:]' '[:lower:]' <<<"$1" )
GITPROXY='https://ghproxy.com'

# ipv4 precedence over ipv6
sed -i 's/#precedence ::ffff:0:0\/96  100/precedence ::ffff:0:0\/96  100/' /etc/gai.conf

# bbr
cat >>/etc/sysctl.conf<<EOF
net.core.default_qdisc = fq_pie
net.ipv4.tcp_congestion_control = bbr
EOF
sysctl -p

# function to change the welcome information
function change_welcome() {
  if [[ "$linux_relese" == 'debian' ]]; then
    apt update -y
    rm -rf /etc/update-motd.d/ /etc/motd /run/motd.dynamic
    mkdir -p /etc/update-motd.d/
    wget --no-check-certificate -qO /etc/update-motd.d/00-header 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/updatemotd/00-header'
}

# ntp
apt purge ntp -y
apt install systemd-timesyncd -y
systemctl enable systemd-timesyncd --now
timedatectl

# change hostname
echo -n "Enter hostname:"
read hostname
hostnamectl set-hostname $hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "127.0.0.1 $hostname" >> /etc/hosts

apt update -y
apt install sudo net-tools xz-utils lsb-release ca-certificates dpkg pwgen zsh unzip vim ripgrep git -y

# set zsh
chsh -s `which zsh`



# Set timezone
timedatectl set-timezone Asia/Hong_Kong

sed -i 's/^#\?Storage=.*/Storage=volatile/' /etc/systemd/journald.conf
sed -i 's/^#\?SystemMaxUse=.*/SystemMaxUse=8M/' /etc/systemd/journald.conf
sed -i 's/^#\?RuntimeMaxUse=.*/RuntimeMaxUse=8M/' /etc/systemd/journald.conf
systemctl restart systemd-journald

# ssh & key
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config;

cd ~ && mkdir -p .ssh && echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0kVbDmjFhOtyoli41xVYMqok5zQNWUkYbdHBvVpAb9 yistc' >> ~/.ssh/authorized_keys
# servercat_key
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICJ+sdnCybIStkqj/lNE8LLu5EPtUwRHmMquMLJgT6RP' >> ~/.ssh/authorized_keys
service sshd restart

# nftables & iptables & ufw
apt remove --auto-remove nftables -y && apt purge nftables -y
apt update && apt install iptables -y

# apt install ufw -y
# ufw default allow incoming
# ufw default allow routed
# yes | ufw enable

# install dust
cd /tmp
wget https://github.com/bootandy/dust/releases/download/v0.8.1/dust-v0.8.1-x86_64-unknown-linux-gnu.tar.gz
tar zxvf dust-v0.8.1-x86_64-unknown-linux-gnu.tar.gz
mv dust-v0.8.1-x86_64-unknown-linux-gnu/dust /usr/local/bin
rm -rf dust-v0.8.1-x86_64-unknown-linux-gnu dust-v0.8.1-x86_64-unknown-linux-gnu.tar.gz

# install lsd
wget https://github.com/Peltoche/lsd/releases/download/0.23.1/lsd-0.23.1-x86_64-unknown-linux-gnu.tar.gz
tar zxvf lsd-0.23.1-x86_64-unknown-linux-gnu.tar.gz
mv lsd-0.23.1-x86_64-unknown-linux-gnu/lsd /usr/local/bin
rm -rf lsd-0.23.1-x86_64-unknown-linux-gnu lsd-0.23.1-x86_64-unknown-linux-gnu.tar.gz

# lsd theme
wget https://gist.githubusercontent.com/yistc/de5b8c0f9fc5536d528ccfa75c9b9328/raw/lsd_theme.sh
bash lsd_theme.sh
rm lsd_theme.sh

# install fd, an alternative to `find` written in Rust
# https://github.com/sharkdp/fd
# apt install fd-find -y
# ln -s $(which fdfind) /usr/local/bin/fd
wget https://github.com/sharkdp/fd/releases/download/v8.5.2/fd-v8.5.2-x86_64-unknown-linux-gnu.tar.gz
tar zxvf fd-v8.5.2-x86_64-unknown-linux-gnu.tar.gz
mv fd-v8.5.2-x86_64-unknown-linux-gnu/fd /usr/local/bin
rm -rf fd-v8.5.2-x86_64-unknown-linux-gnu.tar.gz fd-v8.5.2-x86_64-unknown-linux-gnu

# install procs, an alternative to `ps` written in Rust
wget https://github.com/dalance/procs/releases/download/v0.13.3/procs-v0.13.3-x86_64-linux.zip
unzip procs-v0.13.3-x86_64-linux.zip
mv procs /usr/local/bin/procs
rm procs-v0.13.3-x86_64-linux.zip

# install sd
wget -O /usr/local/bin/sd https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-gnu
chmod +x /usr/local/bin/sd

# install bottom
wget https://gist.githubusercontent.com/yistc/de5b8c0f9fc5536d528ccfa75c9b9328/raw/bottom.sh
bash bottom.sh
rm bottom.sh

# install xh, alternative to httpie
# wget https://github.com/ducaale/xh/releases/download/v0.16.1/xh-v0.16.1-x86_64-unknown-linux-musl.tar.gz
# tar zxvf xh-v0.16.1-x86_64-unknown-linux-musl.tar.gz
# mv xh-v0.16.1-x86_64-unknown-linux-musl/xh /usr/local/bin/xh
# rm -rf xh-v0.16.1-x86_64-unknown-linux-musl.tar.gz xh-v0.16.1-x86_64-unknown-linux-musl

# starship
wget https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz
tar zxvf starship-x86_64-unknown-linux-gnu.tar.gz
mv starship /usr/local/bin/starship
rm starship-x86_64-unknown-linux-gnu.tar.gz

# install zoxide
wget https://github.com/ajeetdsouza/zoxide/releases/download/v0.8.3/zoxide-0.8.3-x86_64-unknown-linux-musl.tar.gz
tar zxvf zoxide-0.8.3-x86_64-unknown-linux-musl.tar.gz zoxide
mv zoxide /usr/local/bin/zoxide
rm zoxide-0.8.3-x86_64-unknown-linux-musl.tar.gz

# install croc
wget https://github.com/schollz/croc/releases/download/v9.6.1/croc_9.6.1_Linux-64bit.tar.gz
tar zxvf croc_9.6.1_Linux-64bit.tar.gz croc
mv croc /usr/local/bin/croc
rm croc_9.6.1_Linux-64bit.tar.gz

# vim config
wget https://gist.githubusercontent.com/yistc/de5b8c0f9fc5536d528ccfa75c9b9328/raw/vim.sh
bash vim.sh
rm vim.sh

# change locale to en_US.utf8
sd "# en_US.UTF-8 UTF-8" "en_US.UTF-8 UTF-8" /etc/locale.gen
locale-gen
sd 'LANG="en_US"' 'LANG="en_US.utf8"' /etc/default/locale

rm /root/debian-11-init.sh

reboot