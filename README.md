# BruteForcer
![Demo](Demo/usage.png)
<pre><b>Just Run and Wait For Results.</b></pre>
<ul>
  <li>You can do automatically Brute Force attacks with this script.</li>
  <li>I designed it for internal network for now.</li>
  <li>But it will be new versions as soon possible.</li>
</ul>

## Installation
Clone the git and run.

```
git clone https://github.com/eraycakinn/BruteForcer.git
cd BruteForcer/
sudo chmod +x BruteForcer.sh Parser/ultimate-nmap-parser.sh
```
## How to Run ?
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

_**It doesn't work for subnet IPs.**_

Script won't do brute force attack for closed ports _**Time is important ;)**_

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
<strong>Note: </strong>If Brute Force Attack fails for any port(any credential information), Result file will not save. I think it is more readable like that.<br>

<pre><strong>***Important***</strong><br>Output Results are refreshing after every run the script.<br>So if you want to save old results,<br>Don't forget to save <b>Outputs/</b> file before again run the script.</pre>

### Output Demo
![Demo](Demo/output.gif)
