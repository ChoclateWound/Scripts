#! /bin/bash
# Created by HS from THP2
# Credit goes to https://github.com/g0tmi1k/os-scripts/blob/master/kali-rolling.sh

##### (Optional) Enable debug mode?
#set -x

##### (Cosmetic) Colour output
RED="\033[01;31m"      # Issues/Errors
GREEN="\033[01;32m"    # Success
YELLOW="\033[01;33m"   # Warnings/Information
BLUE="\033[01;34m"     # Heading
BOLD="\033[01;01m"     # Highlight
RESET="\033[00m"       # Normal

STAGE=0                                                         # Where are we up to
TOTAL=$( grep '(${STAGE}/${TOTAL})' $0 | wc -l );(( TOTAL-- ))  # How many things have we got todo

## My Start

## Installing Kali Updates
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Kali Updates${RESET} ~ Starting update and upgrade of Kali"
apt-get update && apt-get update -y && apt-get dist-upgrade -y \
  || echo -e ' '${RED}'[!] Issue installing updates'${RESET} 1>&2

## Setting up Metasploit database
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Metasploit Database${RESET} ~ Setting up database"
service postgresql start \
  || echo -e ' '${RED}'[!] Issue setting up Metasploit database'${RESET} 1>&2

## Making postgresql database start on boot
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Making ${GREEN}postgresql Database${RESET} ~ Setting up database to start on boot"
update-rc.d postgresql enable \
  || echo -e ' '${RED}'[!] Issue making postgresql database start on boot'${RESET} 1>&2

## Setup database.yml for Metasploit
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Setup ${GREEN}database.yml for Metasploit${RESET} ~ Database for Metasploit"
msfdb init \
  || echo -e ' '${RED}'[!] Issue setting up database.yml for Metasploit'${RESET} 1>&2

## Metasploit logging
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Setup ${GREEN}Metasploit logging${RESET} ~ Options for Metasploit"
echo "spool /root/msf_console.log" > /root/.msf4/msfconsole.rc \
 || echo -e ' '${RED}'[!] Issue with Metasploit logging'${RESET} 1>&2

#####  The Hacker Playbook 2 - Custom Scripts
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Downloading ${GREEN}Custom Scripts${RESET} ~ by The Hacker Playbook 2"
apt -y -qq install apache2 php git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone -q -b master https://github.com/cheetz/Easy-P.git /opt/Easy-P-git/ \
git clone -q -b master https://github.com/cheetz/Password_Plus_One.git /opt/Password_Plus_One-git/ \
git clone -q -b master https://github.com/cheetz/PowerShell_Popup.git /opt/PowerShell_Popup-git/ \
git clone -q -b master https://github.com/cheetz/icmpshock.git /opt/icmpshock-git/ \
git clone -q -b master https://github.com/cheetz/brutescrape.git /opt/brutescrape-git/ \
git clone -q -b master https://www.github.com/cheetz/reddit_xss.git /opt/reddit_xss-git/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2

##### Install the backdoor factory
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Backdoor Factory${RESET} ~ bypassing anti-virus"
apt -y -qq install backdoor-factory \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2


##### Install Backdoor Factory Proxy (BDFProxy)
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Backdoor Factory Proxy (BDFProxy)${RESET} ~ patches binaries files during a MITM"
apt -y -qq install bdfproxy \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2

##### Install BetterCap
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}BetterCap${RESET} ~ MITM framework"
apt -y -qq install git ruby-dev libpcap-dev \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone -q -b master https://github.com/evilsocket/bettercap.git /opt/bettercap-git/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/bettercap-git/ >/dev/null
git pull -q
gem build bettercap.gemspec
gem install bettercap*.gem
popd >/dev/null


##### Install mitmf
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}MITMf${RESET} ~ framework for MITM attacks"
apt -y -qq install mitmf \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2



#####  Discover Scripts
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Downloading ${GREEN}Discover Scripts${RESET} ~ by leebaird"
apt -y -qq install apache2 php git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone -q -b master https://github.com/leebaird/discover.git /opt/discover-git/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/discover-git/ >/dev/null
chmod +x update.sh
./update.sh
git pull -q
popd >/dev/null
#--- Add to path, this creates shortcut 
mkdir -p /usr/local/bin/
file=/usr/local/bin/discover-git
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
cd /opt/discover-git/ && bash discover.sh "\$@"
EOF
chmod +x "${file}"



#####  Install CMSmap
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}CMSmap${RESET} ~ CMS detection"
apt -y -qq install git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone -q -b master https://github.com/Dionach/CMSmap.git /opt/cmsmap-git/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/cmsmap-git/ >/dev/null
git pull -q
popd >/dev/null
#--- Add to path
mkdir -p /usr/local/bin/
file=/usr/local/bin/cmsmap-git
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
cd /opt/cmsmap-git/ && python cmsmap.py "\$@"
EOF
chmod +x "${file}"

#####  NoSQLMap 
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}NoSQLMap${RESET} ~ Pentesting toolset for MongoDB and web app"
apt -y -qq install git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone https://github.com/tcstool/NoSQLMap.git /opt/nosqlmap-git/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/nosqlmap-git/ >/dev/null
python setup.py install
git pull -q
popd >/dev/null
#--- Add to path
mkdir -p /usr/local/bin/
file=/usr/local/bin/nosqlmap-git
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
cd /opt/nosqlmap-git/ && python nosqlmap.py "\$@"
EOF
chmod +x "${file}"


#####  Spiderfoot
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Spiderfoot${RESET} ~ Open Source Footprinting Tool"
pip install lxml
pip install netaddr
pip install M2Crypto
pip install cherrypy
pip install mako
apt -y -qq install git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone https://github.com/smicallef/spiderfoot.git /opt/spiderfoot-git/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/spiderfoot-git/ >/dev/null
python setup.py install
git pull -q
popd >/dev/null
#--- Add to path
mkdir -p /usr/local/bin/
file=/usr/local/bin/spiderfoot-git
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
cd /opt/spiderfoot-git/ && python sf.py "\$@"
EOF
chmod +x "${file}"

# installed by discover script above skipping
###### Install veil framework
#(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}veil-evasion framework${RESET} ~ bypassing anti-virus"
#apt -y -qq install veil-evasion \
  #|| echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
##bash /usr/share/veil-evasion/setup/setup.sh --silent
#mkdir -p /var/lib/veil-evasion/go/bin/
#touch /etc/veil/settings.py
#sed -i 's/TERMINAL_CLEAR=".*"/TERMINAL_CLEAR="false"/' /etc/veil/settings.py


#####  Net-Creds Network Parsing 
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Net-Creds${RESET} ~ Parse PCAP files for username/passwords"
apt -y -qq install git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone -q -b master https://github.com/DanMcInerney/net-creds.git /opt/net-creds-git/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/net-creds-git/ >/dev/null
git pull -q
popd >/dev/null
#--- Add to path
mkdir -p /usr/local/bin/
file=/usr/local/bin/net-creds-git
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
cd /opt/net-creds-git/ && python net-creds.py "\$@"
EOF
chmod +x "${file}"


#####  WIFIPhisher
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}WIFIPhisher${RESET} ~ Automated phishing attacks against WiFi"
apt -y -qq install git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone https://github.com/sophron/wifiphisher.git /opt/wifiphisher/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/wifiphisher/ >/dev/null
python setup.py install
git pull -q
popd >/dev/null
#--- Add to path
mkdir -p /usr/local/bin/
file=/usr/local/bin/wifiphisher
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
cd /opt/wifiphisher/ && python wifiphisher.py "\$@"
EOF
chmod +x "${file}"


##### Install wifite
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}wifite${RESET} ~ automated Wi-Fi tool"
apt -y -qq install wifite \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2


#####  Windows Credential Editor (WCE)
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Windows Credential Editor ${RESET} ~ pull passwords from memory"
apt -y -qq install wget \
  || echo -e ' '${RED}'[!] Issue with wget install'${RESET} 1>&2
mkdir /opt/wce
cd /opt/wce
wget http://www.ampliasecurity.com/research/wce_v1_42beta_x64.zip \
  || echo -e ' '${RED}'[!] Issue when downloading wce'${RESET} 1>&2
pushd /opt/wce/ >/dev/null
unzip wce_v1* -d /opt/wce && rm wce_v1*.zip
popd >/dev/null

#####  DSHashes:
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}DSHashes${RESET} ~ Extracts user hashes in a user-friendly format for NTDSXtract"
apt -y -qq install wget \
  || echo -e ' '${RED}'[!] Issue with wget install'${RESET} 1>&2
mkdir /opt/DSHashes
cd /opt/DSHashes
wget https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/ptscripts/source-archive.zip \
  || echo -e ' '${RED}'[!] Issue when downloading wce'${RESET} 1>&2
pushd /opt/DSHashes/ >/dev/null
unzip source* -d /opt/DSHashes && rm source*.zip
mv /opt/DSHashes/ptscripts/trunk/dshashes.py /opt/NTDSXtract/dshashes.py
popd >/dev/null


#####  SMBExec
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}SMBExec${RESET} ~ Rapid psexec style attack with samba"
apt -y -qq install git \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
git clone https://github.com/pentestgeek/smbexec.git /opt/smbexec/ \
  || echo -e ' '${RED}'[!] Issue when git cloning'${RESET} 1>&2
pushd /opt/smbexec/ >/dev/null
git pull -q
chmod +x install.sh 
./install.sh<< END_OF_RESPONSES
4
5
END_OF_RESPONSES
popd >/dev/null
#--- Add to path
mkdir -p /usr/local/bin/
file=/usr/local/bin/smbexec
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
cd /opt/smbexec/ && ruby smbexec.rb "\$@"
EOF
chmod +x "${file}"



## Tool Installation
## The Backdoor Factory:
## ●	Patch PE, ELF, Mach-O binaries with shellcode.
## ●	git clone https://github.com/secretsquirrel/the-backdoor-factory /opt/the-backdoor-factory
## ●	cd the-backdoor-factory
## ●	./install.sh
##### Install the backdoor factory
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}Backdoor Factory${RESET} ~ bypassing anti-virus"
apt -y -qq install backdoor-factory \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2


##### Install seclist
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Installing ${GREEN}seclist${RESET} ~ multiple types of (word)lists (and similar things)"
apt -y -qq install seclists \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
#--- Link to others
apt -y -qq install wordlists \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
[ -e /usr/share/seclists ] \
  && ln -sf /usr/share/seclists /usr/share/wordlists/seclists

  ##### Update wordlists
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) Updating ${GREEN}wordlists${RESET} ~ collection of wordlists"
apt -y -qq install wordlists curl \
  || echo -e ' '${RED}'[!] Issue with apt install'${RESET} 1>&2
#--- Extract rockyou wordlist
[ -e /usr/share/wordlists/rockyou.txt.gz ] \
  && gzip -dc < /usr/share/wordlists/rockyou.txt.gz > /usr/share/wordlists/rockyou.txt
#--- Add 10,000 Top/Worst/Common Passwords
mkdir -p /usr/share/wordlists/
(curl --progress -k -L -f "http://xato.net/files/10k most common.zip" > /tmp/10kcommon.zip 2>/dev/null \
  || curl --progress -k -L -f "http://download.g0tmi1k.com/wordlists/common-10k_most_common.zip" > /tmp/10kcommon.zip 2>/dev/null) \
  || echo -e ' '${RED}'[!]'${RESET}" Issue downloading 10kcommon.zip" 1>&2
unzip -q -o -d /usr/share/wordlists/ /tmp/10kcommon.zip 2>/dev/null   #***!!! hardcoded version! Need to manually check for updates
mv -f /usr/share/wordlists/10k{\ most\ ,_most_}common.txt
#--- Linking to more - folders
[ -e /usr/share/dirb/wordlists ] \
  && ln -sf /usr/share/dirb/wordlists /usr/share/wordlists/dirb
#--- Extract sqlmap wordlist
unzip -o -d /usr/share/sqlmap/txt/ /usr/share/sqlmap/txt/wordlist.zip
ln -sf /usr/share/sqlmap/txt/wordlist.txt /usr/share/wordlists/sqlmap.txt
#--- Not enough? Want more? Check below!
#apt search wordlist
#find / \( -iname '*wordlist*' -or -iname '*passwords*' \) #-exec ls -l {} \;


### End


##### Clean the system
(( STAGE++ )); echo -e "\n\n ${GREEN}[+]${RESET} (${STAGE}/${TOTAL}) ${GREEN}Cleaning${RESET} the system"
#--- Clean package manager
for FILE in clean autoremove; do apt -y -qq "${FILE}"; done
apt -y -qq purge $(dpkg -l | tail -n +6 | egrep -v '^(h|i)i' | awk '{print $2}')   # Purged packages
#--- Update slocate database
updatedb
#--- Reset folder location
cd ~/ &>/dev/null
#--- Remove any history files (as they could contain sensitive info)
history -cw 2>/dev/null
for i in $(cut -d: -f6 /etc/passwd | sort -u); do
  [ -e "${i}" ] && find "${i}" -type f -name '.*_history' -delete
done


##### Time taken
finish_time=$(date +%s)
echo -e "\n\n ${YELLOW}[i]${RESET} Time (roughly) taken: ${YELLOW}$(( $(( finish_time - start_time )) / 60 )) minutes${RESET}"
echo -e " ${YELLOW}[i]${RESET} Stages skipped: $(( TOTAL-STAGE ))"


#-Done-----------------------------------------------------------------#


##### Done!
echo -e "\n ${YELLOW}[i]${RESET} Don't forget to:"
echo -e " ${YELLOW}[i]${RESET} + Check the above output (Did everything install? Any errors? (${RED}HINT: What's in RED${RESET}?)"
echo -e " ${YELLOW}[i]${RESET} + Manually install: Nessus, Nexpose, and/or Metasploit Community"
echo -e " ${YELLOW}[i]${RESET} + Agree/Accept to: Maltego, OWASP ZAP, w3af, PyCharm, etc"
echo -e " ${YELLOW}[i]${RESET} + Setup git:   ${YELLOW}git config --global user.name <name>;git config --global user.email <email>${RESET}"
echo -e " ${YELLOW}[i]${RESET} + ${BOLD}Change default passwords${RESET}: PostgreSQL/MSF, MySQL, OpenVAS, BeEF XSS, etc"
echo -e " ${YELLOW}[i]${RESET} + ${YELLOW}Reboot${RESET}"
(dmidecode | grep -iq virtual) \
  && echo -e " ${YELLOW}[i]${RESET} + Take a snapshot   (Virtual machine detected)"

echo -e '\n'${BLUE}'[*]'${RESET}' '${BOLD}'Done!'${RESET}'\n\a'
exit 0