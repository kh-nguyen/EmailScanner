# EmailScanner
This is a tool with web-based interface to retrieve/download emails from multiple email accounts and store the records in a basic database structure for archiving, querying or researching purposes. It stores only unique email attachments in a regular folder, helping to reduce database and storage space. It currently supports IMAP, POP3, Exchange, and Exchange Journal protocols. The trial license has a limit of 10,000 records.

#Install
Use Schemas\MSSQL\Exchange.sql file to install the database schema to a MS SQL Server Express.
You also need to modify the Web.config to update the database connection string, and the attachments storage location for your computer.
Please note that there is a size limit of 10GB for the MS SQL Server Express.
Add your email account details to the Settings section of the web interface.

#Donation:
BitCoin - [1PMXuwXE3iQ2DZiwgKF48EqkpiEaWdMCWU](bitcoin:1PMXuwXE3iQ2DZiwgKF48EqkpiEaWdMCWU)

#Screenshots
![ScreenShot 1](https://github.com/kh-nguyen/EmailScanner/blob/master/ScreenShoots/System%20Status.png)
