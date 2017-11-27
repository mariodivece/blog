# A Small Guide to Redmine Maintenance

This guide covers basic administration tasks for a Windows Bitnami Redmine Installation and Upgrade steps.

## 1. Stop Services
 - Go to: C:\bitnami\redmine and run the ```manager-windows``` application
 - Stop all Services except for ```MySQL```

## 2. Backup your Database
 - Verify that a FULL database backup is available in a remote server. See section 11.2 for more info.
 - Make note of the current Redmine version running
 - Run ```MySQL Workbench``` and connect to the ```localhost``` instance
 - Select ```Export Data```
 - Select the ```bitnami_redmine database```, ```Self-Contained File```, ```Single Transaction```, and ```Include Create Schema``` options
 - Run the backup and keep the output sql file in your ```Desktop``` folder

## 3. Backup your Files
 - Run the ```manager-windows``` application again, and stop the ```MySQL``` Server. All services must be stopped at this point.
 - Copy the entire ```redmine``` folder to a safe and temporary location. This takes a few minutes. -- Good time for coffee!

## 4. Cleanup prior Version
 - Go to ```Add and Remove Programs``` in the Windows ```Control Panel```, and uninstall the current version of ```Bitnami Redmine```

## 5. Install the new Version
 - Run the Bitnami Redmine installer
 - Set the target folder to ```C:\bitnami\redmine```
 - For Login, choose username: ```admin```, Password: ```password1``` -- We will change this very soon
 - Do not setup STMP (Email) at this point. We will copy those setting from the existing backup files.
 - Uncheck the ```Deploy to Bitnami Cloud``` option
 - Wait for the installation to complete. Go get another coffee!

## 6. Stop Redmine and Restore the Database
 - Open the Bitnami Service Manager application as in step 1. Stop all services except MySQL
 - Open MySQL Workbench and ufor username enter root. For password enter password1 (previously set during installation)
 - Drop the bitnami_redmine schema completely
 - Restore the bitnami_redmine schema from the previously created backup file
 - Run the following SQL Query in order to reset the cached authentication states: FLUSH PRIVILEGES;
 - Go to users and update the password for the bitnami user. You can find the password in the following file: ```C:\bitnami\redmine\apps\redmine\htdocs\config\database.yml```
 - Now, allow remote connections to the database by going into ```Instance```, ```Options File```, scroll to the bottom, and under ```General```, uncheck the ```bind-address``` and click on ```Apply```
 - Now go to ```Instance```, ```Startup/Shutdown``` and stop and start the service.

## 7. Restore files from backup
 - Copy the notes and tasks folders to ```c:\bitnami```
 - Copy the cacert.pem file to ```c:\bitnami```
 - Copy the configuration.yml file to ```C:\bitnami\redmine\apps\redmine\htdocs\config\configuration.yml```
 - Copy the contents of the files folder to ```C:\bitnami\redmine\apps\redmine\htdocs\files```
 - Copy the contents of the plugins folder to ```C:\bitnami\redmine\apps\redmine\htdocs\plugins```
 - Copy the contents of the banner htdocs folder to ```C:\bitnami\redmine\apps\bitnami\banner\htdocs```
 - Copy the custom themes of the themes folder to ```C:\bitnami\redmine\apps\redmine\htdocs\public\themes```
 - Copy apache htdocs to ```C:\bitnami\redmine\apache2\htdocs```

Note: Installation of the abacus theme and customization for your company is preferred. Please download from: 
http://www.abacusthemes.com/en/

## 8. Setup and migrate to the new version

```batch
CALL "C:\bitnami\redmine\scripts\setenv.bat"
SET SSL_CERT_FILE=c:\bitnami\cacert.pem
C:
cd "C:\bitnami\redmine\apps\redmine\htdocs"
bundle install --no-deployment --without development test
bundle exec rake generate_secret_token
bundle exec rake db:migrate RAILS_ENV=production
```

 - If the above fails, open ```C:\bitnami\redmine\apps\redmine\htdocs\log\production.log``` and add the stuck migrations. For example: 
```MYSQL
insert into bitnami_redmine.schema_migrations values('20150113194759');
insert into bitnami_redmine.schema_migrations values('20150113213955');
insert into bitnami_redmine.schema_migrations values('20150526183158');
```

 - Now we will migrate the plugins. In the command line:
```batch
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

 - Finally, open the Bitnami Service manager and start all services

## 9. Upgrade the RedmineUP Plugins

 - Stop all services except for MySQL
 - delete the existing plugins in C:\bitnami\redmine\apps\redmine\htdocs\plugins
 - Extract the new plugin in C:\bitnami\redmine\apps\redmine\htdocs\plugins
 - In the command line:
```bacth
CALL "C:\bitnami\redmine\scripts\setenv.bat"
SET SSL_CERT_FILE=c:\bitnami\cacert.pem
C:
cd "C:\bitnami\redmine\apps\redmine\htdocs\"
bundle install --no-deployment --without development test
bundle exec rake redmine:plugins NAME=redmine_agile RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_checklists RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_contacts RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_people RAILS_ENV=production
bundle exec rake redmine:plugins NAME=redmine_contacts_helpdesk RAILS_ENV=production
```

 - Now start the services again!

## 10. Adjust the Abacus Theme

 - find the theme javascripts/theme.js
 - find the line decalring the subFolder variable and enter subFolder = "/redmine"
 - Copy and paste the logo.png and favicon.ico in the images folder

## 11. Additional configuration (Apache, Tasks, and Email)

### 11.1. We need Apache to redirect to https always. 
 - From the backup, copy the certificates to: C:\bitnami\redmine\apache2\conf
 - The following files: 
   - ```privkey.pem```, 
   - ```server.pfx```, 
   - ```server.csr```, and 
   - ```server.key```
 - Now, open ```C:\bitnami\redmine\apps\redmine\conf\httpd-prefix.conf```
 - and add the following lines to the TOP of the file:
```CONFIG
# Force HTTPS Redirection
RewriteEngine On
RewriteCond %{HTTPS} !=on
RewriteRule ^/(.*) https://%{SERVER_NAME}/$1 [R,L]
```

 - Finally, restart the Apache server

### 11.2 Verify Taks
 - To verify the backup task, run C:\bitnami\tasks\mysqlbackup.bat
 - Correct the batch file if any errors show up
 - Batch file for refence below:
```BACTH
set BackupFolder=D:\MySQL_Backups
set RemoteFolder=\\backupservernamehere\backupfolderhere
set SAVESTAMP=%DATE:/=-%@%TIME::=-%
set BackupFile=MySql-%SAVESTAMP: =%.sql
set FullBackupPath=%BackupFolder%\%BackupFile%

IF not exist %BackupFolder% (mkdir %BackupFolder%)
C:\bitnami\redmine\mysql\bin\mysqldump -h localhost -u root --password=XXXXX --all-databases >> %FullBackupPath%
forfiles -p %BackupFolder% -s -m *.* -d 30 -c "cmd /c del @path"
robocopy "%BackupFolder%" "%RemoteFolder%" /E
```

 - To verify the Helpdesk email processing, 
   - send an email to ```helpdesk@mydomainhere.com``` and then
   - run ```C:\bitnami\tasks\ProcessRedmineEmails.bat```
   - Ensure you receive a response
Batch file for refence below:
```BACTH
@echo off

CALL "C:\bitnami\redmine\scripts\setenv.bat"
SET SSL_CERT_FILE=c:\bitnami\cacert.pem
C:
CD "C:\bitnami\redmine\apps\redmine\htdocs"

ECHO Processing Redmine Emails . . .
CALL rake redmine:email:receive_imap RAILS_ENV="production" move_on_success=Processed move_on_failure=Failed host=outlook.office365.com username=redmine@mydomain.com password=XXXX port=993 ssl=1 -r 'openssl' -E 'OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE'
ECHO Processing Helpdesk Emails . . .
CALL rake redmine:email:helpdesk:receive RAILS_ENV=production

ECHO All Email procesing completed.
```

 - Verify that the above 2 tasks are running correctly from the Windows task scheduler

## 12. Adding Time Entry Validation Constraints to the database

```MYSQL

DELIMITER $$

DROP TRIGGER `time_entries_Validate`
$$
-- validate time entries
CREATE TRIGGER `time_entries_Validate`
	BEFORE INSERT
	ON `time_entries`
	FOR EACH ROW
BEGIN
	IF NEW.`comments` IS NULL OR CHAR_LENGTH(NEW.`comments`) < 5 THEN
		SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT = 'Comments cannot be NULL and must be of a reasonable length';
	END IF;
    
    IF YEAR(NEW.`spent_on`) < YEAR(CURDATE()) - 1 OR YEAR(NEW.`spent_on`) > YEAR(CURDATE()) + 1 THEN
		SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT = 'The year of the spent_on field is invalid';
	END IF;
END;

$$
```
