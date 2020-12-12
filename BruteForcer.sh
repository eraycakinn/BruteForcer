#!/bin/bash


splash() {
	clear
	echo -e "${red}         ___ ___ ___ ___ ___ ___ ___ ___ ___ ___   "
	echo -e "
	██████╗ ██████╗ ██╗   ██╗████████╗███████╗       
	██╔══██╗██╔══██╗██║   ██║╚══██╔══╝██╔════╝       
	██████╔╝██████╔╝██║   ██║   ██║   █████╗       
	██╔══██╗██╔══██╗██║   ██║   ██║   ██╔══╝      
	██████╔╝██║  ██║╚██████╔╝   ██║   ███████╗       
	╚═════╝ ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝       

	███████╗ ██████╗ ██████╗  ██████╗███████╗██████╗ 
	██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗
	█████╗  ██║   ██║██████╔╝██║     █████╗  ██████╔╝
	██╔══╝  ██║   ██║██╔══██╗██║     ██╔══╝  ██╔══██╗
	██║     ╚██████╔╝██║  ██║╚██████╗███████╗██║  ██║
	╚═╝      ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝
	"
	echo -e "      ${red} developed_by: eraycakinn | Cyber Security Researcher"
	echo -e "       ${red}The Automatic Bruteforce Tool\n ${default}"
}

help() {
	splash
	echo -e "[${yellow}*${default}] Usage: ./BruteForcer.sh${default} <target/file>"
}

create_files() {
	mkdir Outputs Outputs &> /dev/null
	mkdir Outputs/Scans Outputs/Scans &> /dev/null
	mkdir Outputs/Brute_Result &> /dev/null
}

live_port_scan() {
	echo -e "[${yellow}*${default}] Target: $1"
	echo -e "[${yellow}*${default}] Starting agressive scan of supported ports against: ${1}...\n"
	sleep 1
	nmap -sn -n $1 -oG - | awk '/Up$/{print $2}' >> Outputs/Scans/livehosts 
	sort -u Outputs/Scans/livehosts > Outputs/Scans/livehosts.tmp | mv Outputs/Scans/livehosts.tmp Outputs/Scans/livehosts
	echo -e "[${yellow}*${default}] Scan finished for Live Host in Network."
	printf "\n\n"
	sleep 1
}


brute_port_scan() {

	echo -e "[${yellow}*${default}] Target: $1"
	echo -e "[${yellow}*${default}] Starting agressive scan of supported ports against: ${1}...\n"
	sleep 1
	nmap --open $1 -n --top-ports 3000 -oG Outputs/Scans/$1.txt
	grep -e 'Ports:' Outputs/Scans/$1.txt >> Outputs/Scans/nmap_result.gnmap
	sort -u Outputs/Scans/nmap_result.gnmap > Outputs/Scans/nmap_result.tmp | mv Outputs/Scans/nmap_result.tmp Outputs/Scans/nmap_result.gnmap     
	echo -e "[${yellow}*${default}] Port Scan finished for Brute Force Attack."
	printf "\n\n"
	sleep 1
}

bruteforce() { 

	if grep -q 21/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 21(FTP) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $ftp $1 ftp -I -o Outputs/Brute_Result/ftp_result.txt
		cat Outputs/Brute_Result/ftp_result.txt | grep "login" | sort -u > Outputs/Brute_Result/ftp_result.tmp | mv Outputs/Brute_Result/ftp_result.tmp Outputs/Brute_Result/ftp_result.txt

		ftp_file=Outputs/Brute_Result/ftp_result.txt

		if [[ ! -s $ftp_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $ftp_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi

		finished_brute $1

	else
		echo -e "[${red}!${default}] Port 21(FTP) is not open. Skipping to next port..."
	fi



	if grep -q 22/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 22(SSH) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $ssh $1 ssh -I -o Outputs/Brute_Result/ssh_result.txt
		cat Outputs/Brute_Result/ssh_result.txt | grep "login" | sort -u > Outputs/Brute_Result/ssh_result.tmp | mv Outputs/Brute_Result/ssh_result.tmp Outputs/Brute_Result/ssh_result.txt

		ssh_file=Outputs/Brute_Result/ssh_result.txt

		if [[ ! -s $ssh_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $ssh_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi

		finished_brute $1
		
	else
		echo -e "[${red}!${default}] Port 22(SSH) is not open. Skipping to next port..."
	fi



	if grep -q 23/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 23(Telnet) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $telnet $1 telnet -I -o Outputs/Brute_Result/telnet_result.txt
		cat Outputs/Brute_Result/telnet_result.txt | grep "login" | sort -u > Outputs/Brute_Result/telnet_result.tmp | mv Outputs/Brute_Result/telnet_result.tmp Outputs/Brute_Result/telnet_result.txt

		telnet_file=Outputs/Brute_Result/telnet_result.txt

		if [[ ! -s $telnet_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $telnet_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		
		finished_brute $1

	else
		echo -e "[${red}!${default}] Port 23(Telnet) is not open. Skipping to next port..."
	fi



	if grep -q 25/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 25(SMTP) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $user -P $pass $1 smtp-enum -I -o Outputs/Brute_Result/smtp-enum.txt
		hydra -V -e ns -L $smtp_u -P $smtp_p $1 smtp -I -o Outputs/Brute_Result/smtp.txt
		hydra -V -e ns -L $user -P $pass $1 smtp -I -o Outputs/Brute_Result/smtp1.txt
		cat Outputs/Brute_Result/smtp-enum.txt Outputs/Brute_Result/smtp.txt Outputs/Brute_Result/smtp1.txt  >> Outputs/Brute_Result/smtp_result.txt 
		cat Outputs/Brute_Result/smtp_result.txt | grep "login" | sort -u > Outputs/Brute_Result/smtp_result.tmp | mv Outputs/Brute_Result/smtp_result.tmp Outputs/Brute_Result/smtp_result.txt

		smtp_file=Outputs/Brute_Result/smtp_result.txt

		if [[ ! -s $smtp_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $smtp_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		
		rm Outputs/Brute_Result/smtp-enum.txt Outputs/Brute_Result/smtp.txt Outputs/Brute_Result/smtp1.txt 
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 25(SMTP) is not open. Skipping to next port..."
	fi



	if grep -q 110/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 110(POP3) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $pop_u -P $pop_p $1 pop3 -I -o Outputs/Brute_Result/pop3_result.txt
		cat Outputs/Brute_Result/pop3_result.txt | grep "login" | sort -u > Outputs/Brute_Result/pop3_result.tmp | mv Outputs/Brute_Result/pop3_result.tmp Outputs/Brute_Result/pop3_result.txt

		pop3_file=Outputs/Brute_Result/pop3_result.txt

		if [[ ! -s $pop3_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $pop3_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 110(POP3) is not open. Skipping to next port..."
	fi



	if grep -q 162/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 162(SNMP) is open. Starting bruteforce..."
		sleep 1
		hydra -V -e ns -P $snmp snmp -S 162 -I -o Outputs/Brute_Result/snmp_result.txt
		cat Outputs/Brute_Result/snmp_result.txt | grep "login" | sort -u > Outputs/Brute_Result/snmp_result.tmp | mv Outputs/Brute_Result/snmp_result.tmp Outputs/Brute_Result/snmp_result.txt

		snmp_file=Outputs/Brute_Result/snmp_result.txt

		if [[ ! -s $snmp_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $snmp_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 162(SNMP) is not open. Skipping to next port..."
	fi



	if grep -q 389/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 389(LDAP) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $windows -P $pass $1 ldap2 -S 389 -I -o Outputs/Brute_Result/ldap2.txt
		hydra -V -e ns -L $windows -P $pass $1 ldap3 -S 389 -I -o Outputs/Brute_Result/ldap3.txt
		cat Outputs/Brute_Result/ldap2.txt Outputs/Brute_Result/ldap3.txt >> Outputs/Brute_Result/ldap_result.txt 
		cat Outputs/Brute_Result/ldap_result.txt | grep "login" | sort -u > Outputs/Brute_Result/ldap_result.tmp | mv Outputs/Brute_Result/ldap_result.tmp Outputs/Brute_Result/ldap_result.txt

		ldap_file=Outputs/Brute_Result/ldap_result.txt

		if [[ ! -s $ldap_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $ldap_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		rm Outputs/Brute_Result/ldap2.txt Outputs/Brute_Result/ldap3.txt 
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 389(LDAP) is not open. Skipping to next port..."
	fi



	if grep -q 445/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 445(SMB) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $windows smb $1 -S 445 -I -o Outputs/Brute_Result/smb.txt
		hydra -V -e ns -L $user -P $pass $1 smb -S 445 -I -o Outputs/Brute_Result/smb_2.txt
		cat Outputs/Brute_Result/smb.txt Outputs/Brute_Result/smb_2.txt >> Outputs/Brute_Result/smb_result.txt 
		cat Outputs/Brute_Result/smb_result.txt | grep "login" | sort -u > Outputs/Brute_Result/smb_result.tmp | mv Outputs/Brute_Result/smb_result.tmp Outputs/Brute_Result/smb_result.txt		

		smb_file=Outputs/Brute_Result/smb_result.txt

		if [[ ! -s $smb_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $smb_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		rm Outputs/Brute_Result/smb.txt Outputs/Brute_Result/smb_2.txt
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 445(SMB) is not open. Skipping to next port..."
	fi



	if grep -q 512/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 512(rexec) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $user -P $pass $1 rexec -S 512 -I -o Outputs/Brute_Result/rexec_result.txt
		cat Outputs/Brute_Result/rexec_result.txt | grep "login" | sort -u > Outputs/Brute_Result/rexec_result.tmp | mv Outputs/Brute_Result/rexec_result.tmp Outputs/Brute_Result/rexec_result.txt

		rexec_file=Outputs/Brute_Result/rexec_result.txt

		if [[ ! -s $rexec_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $rexec_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 512(rexec) is not open. Skipping to next port..."
	fi



	if grep -q 513/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 513(rlogin) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $user -P $pass $1 rlogin -S 513 -I -o Outputs/Brute_Result/rlogin_result.txt
		cat Outputs/Brute_Result/rlogin_result.txt | grep "login" | sort -u > Outputs/Brute_Result/rlogin_result.tmp | mv Outputs/Brute_Result/rlogin_result.tmp Outputs/Brute_Result/rlogin_result.txt

		rlogin_file=Outputs/Brute_Result/rlogin_result.txt

		if [[ ! -s $rlogin_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $rlogin_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 513C(rlogin) is not open. Skipping to next port..."
	fi



	if grep -q 514/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 514(rsh) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $user -P $pass $1 rsh -S 514 -I -o Outputs/Brute_Result/rsh_result.txt
		cat Outputs/Brute_Result/rsh_result.txt | grep "login" | sort -u > Outputs/Brute_Result/rsh_result.tmp | mv Outputs/Brute_Result/rsh_result.tmp Outputs/Brute_Result/rsh_result.txt

		rsh_file=Outputs/Brute_Result/rsh_result.txt

		if [[ ! -s $rsh_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $rsh_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 514(rsh) is not open. Skipping to next port..."
	fi



	if grep -q 993/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 993(IMAP) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $user -P $pass $1 imap -S 993 -I -o Outputs/Brute_Result/imap_result.txt
		cat Outputs/Brute_Result/imap_result.txt | grep "login" | sort -u > Outputs/Brute_Result/imap_result.tmp | mv Outputs/Brute_Result/imap_result.tmp Outputs/Brute_Result/imap_result.txt

		imap_file=Outputs/Brute_Result/imap_result.txt

		if [[ ! -s $imap_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $imap_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 993(IMAP) is not open. Skipping to next port..."
	fi



	if grep -q 1433/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 1433(mssql) is open. Starting bruteforce.../n"
		sleep 1
		hydra -V -e ns -C $mssql $1 mssql -S 1433 -I -o Outputs/Brute_Result/mssql.txt
		hydra -V -e ns -L $windows -P $pass $1 mssql -S 1433 -I -o Outputs/Brute_Result/mssql_1.txt
		cat Outputs/Brute_Result/mssql.txt Outputs/Brute_Result/mssql_1.txt >> Outputs/Brute_Result/mssql_result.txt 
		cat Outputs/Brute_Result/mssql_result.txt | grep "login" | sort -u > Outputs/Brute_Result/mssql_result.tmp | mv Outputs/Brute_Result/mssql_result.tmp Outputs/Brute_Result/mssql_result.txt
		
		mssql_file=Outputs/Brute_Result/mssql_result.txt

		if [[ ! -s $mssql_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $mssql_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		rm Outputs/Brute_Result/mssql.txt Outputs/Brute_Result/mssql_1.txt
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 1433(mssql) is not open. Skipping to next port..."
	fi



	if grep -q 1521/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 1521(oracle) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $oracle $1 oracle -S 1521 -I -o Outputs/Brute_Result/oracle_result.txt
		cat Outputs/Brute_Result/oracle_result.txt | grep "login" | sort -u > Outputs/Brute_Result/oracle_result.tmp | mv Outputs/Brute_Result/oracle_result.tmp Outputs/Brute_Result/oracle_result.txt

		oracle_file=Outputs/Brute_Result/oracle_result.txt

		if [[ ! -s $oracle_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $oracle_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 1521(oracle) is not open. Skipping to next port..."
	fi



	if grep -q 3306/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 3306(mysql) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $mysql $1 mysql -I -o Outputs/Brute_Result/mysql_result.txt
		cat Outputs/Brute_Result/result_mysql.txt | grep "login" | sort -u > Outputs/Brute_Result/result_mysql.tmp | mv Outputs/Brute_Result/result_mysql.tmp Outputs/Brute_Result/mysql_result.txt

		mysql_file=Outputs/Brute_Result/mysql_result.txt

		if [[ ! -s $mysql_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $mysql_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 3306(mysql) is not open. Skipping to next port..."
	fi



	if grep -q 3389/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 3389(RDP) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $windows $1 rdp -I -o Outputs/Brute_Result/rdp_result.txt
		hydra -V -e ns -L $windows -P $pass $1 rdp -I -o Outputs/Brute_Result/rdp_1.txt
		cat Outputs/Brute_Result/rdp.txt Outputs/Brute_Result/rdp_1.txt >> Outputs/Brute_Result/result_rdp.txt 
		cat Outputs/Brute_Result/result_rdp.txt | grep "login" | sort -u > Outputs/Brute_Result/result_rdp.tmp | mv Outputs/Brute_Result/result_rdp.tmp Outputs/Brute_Result/rdp_result.txt
		
		rdp_file=Outputs/Brute_Result/rdp_result.txt

		if [[ ! -s $rdp_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $rdp_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		rm Outputs/Brute_Result/rdp.txt Outputs/Brute_Result/rdp_1.txt
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 3389(RDP) is not open. Skipping to next port..."
	fi



	if grep -q 5432/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 5432(postgres) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -C $postgres $1 postgres -I -o Outputs/Brute_Result/postgres_result.txt
		cat Outputs/Brute_Result/postgres_result.txt | grep "login" | sort -u > Outputs/Brute_Result/postgres_result.tmp | mv Outputs/Brute_Result/postgres_result.tmp Outputs/Brute_Result/postgres_result.txt

		postgres_file=Outputs/Brute_Result/postgres_result.txt

		if [[ ! -s $postgres_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $postgres_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 5432(postgres) is not open. Skipping to next port..."
	fi



	if grep -q 5900/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 5900(VNC) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $vnc -P $pass $1 vnc -S 5900 -I -o Outputs/Brute_Result/vnc_5900_result.txt
		cat Outputs/Brute_Result/vnc_5900_result.txt | grep "login" | sort -u > Outputs/Brute_Result/vnc_5900_result.tmp | mv Outputs/Brute_Result/vnc_5900_result.tmp Outputs/Brute_Result/vnc_5900_result.txt

		vnc_5900_file=Outputs/Brute_Result/vnc_5900_result.txt

		if [[ ! -s $vnc_5900_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $vnc_5900_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 5900(VNC) is not open. Skipping to next port..."
	fi



	if grep -q 5901/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 5901(VNC) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $vnc -P $pass $1 vnc -S 5901 -I -o Outputs/Brute_Result/vnc_5901_result.txt
		cat Outputs/Brute_Result/vnc_5901_result.txt | grep "login" | sort -u > Outputs/Brute_Result/vnc_5901_result.tmp | mv Outputs/Brute_Result/vnc_5901_result.tmp Outputs/Brute_Result/vnc_5901_result.txt

		vnc_5901_file=Outputs/Brute_Result/vnc_5901_result.txt

		if [[ ! -s $vnc_5901_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $vnc_5901_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 5901(VNC) is not open. Skipping to next port..."
	fi



	if grep -q 6667/open Outputs/Scans/$1.txt; then
		echo -e "[${yellow}*${default}] Port 6667(IRC) is open. Starting bruteforce...\n"
		sleep 1
		hydra -V -e ns -L $user -P $pass $1 irc -s 6667 -I -o Outputs/Brute_Result/irc_result.txt
		cat Outputs/Brute_Result/irc_result.txt | grep "login" | sort -u > Outputs/Brute_Result/irc_result.tmp | mv Outputs/Brute_Result/irc_result.tmp Outputs/Brute_Result/irc_result.txt

		irc_file=Outputs/Brute_Result/irc_result.txt

		if [[ ! -s $irc_file ]] ; then
			echo -e "[${red}-${default}] There are no default credentials for this port."
			rm $irc_file
		else
			echo -e "[${red}+${default}] Brute Force Completed."
		fi
		finished_brute $1
	else
		echo -e "[${red}!${default}] Port 6667(IRC) is not open. Skipping to next port..."
	fi

	printf "\n\n"
	rm Outputs/Scans/$1.txt

}

finished_brute() {
	echo -e "[${green}*${default}] Bruteforce finished. Credentials found saved at: Outputs/Brute_Result/."
	sleep 1
}

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
default='\033[0;39m'

ftp="Wordlist/ftp.txt"
ssh="Wordlist/ssh.txt"
smtp_u="Wordlist/smtp_u.txt"
smtp_p="Wordlist/smtp_p.txt"
pop_u="Wordlist/pop_u.txt"
pop_p="Wordlist/pop_p.txt"
telnet="Wordlist/telnet.txt"
snmp="Wordlist/snmp.txt"
mysql="Wordlist/mysql.txt"
mssql="Wordlist/mssql.txt"
oracle="Wordlist/oracle.txt"
postgres="Wordlist/postgres.txt"
windows="Wordlist/windows.txt"
user="Wordlist/user.txt"
pass="Wordlist/pass.txt"
vnc="Wordlist/vnc.txt"


splash

if [ $# -eq 0 ]; then
	echo -e "[${red}!${default}] Error: No arguments supplied."
	echo -e "[${yellow}*${default}] Usage: ./BruteForcer.sh <target/file>"

	exit
fi
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
	help
	exit
fi


    #For Reading File
    if [[ -f $1 ]]; then
    	while IFS= read -r line
    	do
    		sleep 1
    		create_files $line
    		live_port_scan $line
    		brute_port_scan $line
    		bruteforce $line $2
				#-----------

			done < "$1"
		#NMAP PARSER
		./Parser/ultimate-nmap-parser.sh Outputs/Scans/nmap_result.gnmap --summary
		cat summary.txt > Outputs/Scans/nmap_result
		rm Outputs/Scans/nmap_result.gnmap
		rm summary.txt
		#--------------
		exit
	fi

	#For Single Target
	sleep 1
	create_files $1
	live_port_scan $1
	brute_port_scan $1
	bruteforce $1 $2
	#-----------
	#NMAP PARSER
	./Parser/ultimate-nmap-parser.sh Outputs/Scans/nmap_result.gnmap --summary
	cat summary.txt > Outputs/Scans/nmap_result
	rm Outputs/Scans/nmap_result.gnmap
	rm summary.txt
	#-------------

