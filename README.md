# BruteForcer
You can do automatically Brute Force attacks with this script. I designed it for internal network for now. But there will be new versions as soon possible.

<b>Just Run and Wait For Results.</b>
## Installation
Clone the git and you pretty much ready to roll

```
git clone https://github.com/eraycakinn/BruteForcer.git
cd BruteForcer/
sudo chmod +x BruteForcer.sh Parser/ultimate-nmap-parser.sh
```
## How to Run
```
sudo ./BruteForcer.sh <target> or <targets_file>
```
![Demo](Demo/run.gif)

When script finished, You will get Outputs Files. All Results in there.

## Features
<ul>
  <li>Live Hosts in ALL network </li>
  <li>Open Ports in ALL network </li>
  <li>Brute Force Attacks to Popular ports </li>
</ul>
Script won't do brute force attack for closed ports. <strong>**Time is Important** :)</strong>

## Which results can you get ? 
### Outputs File Hierarchy
<ul>
  <li>Scans
  <ul>
    <li>livehosts</li>
    <li>nmap_result</li>
   </ul>
  </li>
  <li>Brute_Result
  <ul>
    <li>(protocol-name)_result.txt</li>
  </ul>
  </li>
</ul>
<strong>Note: </strong>If Brute Force Attack fails for any port(any credential information), Result file will not save. I think it is more readable like that.

### Output Demo
![Demo](Demo/output.gif)

### References
https://github.com/MS-WEB-BN/t14m4t/
