<a href="https://www.paypal.me/masato/"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/others/Banners/Donate using PayPal.png" height=40></a> <!-- Paypal Banner -->  
[paypal.me/masato](https://www.paypal.me/masato) - [Alternative paypal cart button](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BSWU76BLQBMCU)
    
Steam Account Switcher is and will always be free to use.  
Your name will appear on this page if you choose to donate!

Join the official discord channel!  
<a href="https://discord.gg/UMxqtfC"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/imgs/Discord_big.png" height=50></a>

If needed, you can contact me on:  
<a href="https://discord.gg/UMxqtfC"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/imgs/Discord_big.png" height=30></a>&nbsp;&nbsp;&nbsp;
<a href="https://www.reddit.com/user/lemasato/submitted/"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/imgs/Reddit_big.png" height=30></a>  

***

## Usage

- Download the latest executable from the [releases page](https://github.com/lemasato/Steam-Account-Switcher/releases)
- Run the downloaded executable
### OR
- Download and install [AutoHotKey](https://autohotkey.com/download/) from the official website.  
- Download and extract [Steam-Account-Switcher-AHK.zip](https://github.com/lemasato/Steam-Account-Switcher/releases) from the releases page.  
- Run Steam Account Switcher.ahk  

You can add or remove accounts from the list by using right click.  

***

||||
|---|---|---|
|<img src=https://raw.githubusercontent.com/lemasato/Steam-Account-Switcher/master/screenshots/interface.png>|<img src=https://raw.githubusercontent.com/lemasato/Steam-Account-Switcher/master/screenshots/interface-3.png>|<img src=https://raw.githubusercontent.com/lemasato/Steam-Account-Switcher/master/screenshots/interface-2.png>|

## Key Features  
- **Easily log into your Steam accounts, without having to type your password.**  
**We do not need your password.**  
The tool makes clever use of the cookies/tokens system Steam is using.  
Simply make sure to tick the "Remember my password" checkbox when logging on Steam.  
- **Automatic updates.**  
Receive a notification when an update is available.  
The entire updating process is automated.  

***

## Command-line parameters

- **/Account=accountname**  
Logs into the account, skipping the interface.  
⚠ Note that after loging into the account, the tool will always close, ignoring the `"minimize instead of close"` setting ⚠

- **/Offline**  
⚠ Requires to be used with `/Account=` ⚠  
Forces Steam to start in Offline mode.  
When omitted, forces Steam to start in Online mode.  

- **/StartMinimized**
⚠ Does not work with `/Account=` or `/Offline` as they bypass the interface ⚠
Starts the tool minimized in the tray. Useful if you want to add a shortcut to run on startup.|

- **/SteamPath="C:\Program Files (x86)\Steam\"**
Forces to use the specified Steam folder instead of the default installation.
Note that this is really only required if you have multiple Steam installation and want to run the application on a specific one.

- **/NoSteamShutdown**
Normally we close the currently running any Steam instance running from the same folder we are trying to start it from.
This parameter prevent this behaviour from occuring. I'm not quite sure how could this be used and why, but it exists.

- **/SteamParams**
In case you would like to run Steam with specific parameters.
I don't see any use for this, but it exists.

- **/LaunchCommand="C:\Path\to\some\app\launcher.exe"**
If you want Steam Account Switcher to run an application other than Steam.
Useful if you want to run Steam through a wrapper/launcher of some sort.