This script is used to install SQL Server 2017 Standard on a newly provisioned VM using the vRealize Guest Agent.

This will copy files from a file server with the SQL installation media, slipstream update files (SQL cumulative updates), and the SQL configuration file needed for an unattended installation. 

Our company uses CommVault to backup our production servers, so this script automatically installs the backup agent and then notifies the CommVault administrators. 

After all of this, the script deletes the installation files that were copied over locally to clean up the boot drive. 
