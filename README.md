# EmailScanner
This is a software library tool with a demo web-based interface to retrieve/download emails from multiple email accounts and store the records in a basic database structure for archiving, querying or researching purposes. It stores only unique email attachments in a regular folder, helping to reduce database and storage space. It currently supports IMAP, POP3, Exchange, and Exchange Journal accounts. The trial license has a limit of 10,000 records.

# Install
Use Schemas\MSSQL\Exchange.sql file to install the database schema to a MS SQL Server Express.
You also need to modify the Web.config to update the database connection string, and the attachments storage location for your computer.
Please note that there is a size limit of 10GB for the MS SQL Server Express.
Add your email account details to the Settings section of the web interface.

# Events
AddMessageEventHandler: You can hook up other message processors to this event to process the messages further after they have been inserted into the database.

# Technologies
- Presentation tier: jQuery, AngularJS, MVC/Razor, SignalR
- Middle tier: ASP.NET MVC, C#
- Data tier: MS SQL, EntityFramework

#Donation:
BitCoin - [1PMXuwXE3iQ2DZiwgKF48EqkpiEaWdMCWU](bitcoin:1PMXuwXE3iQ2DZiwgKF48EqkpiEaWdMCWU)

#Screenshots
![ScreenShot 1](https://github.com/kh-nguyen/EmailScanner/blob/master/ScreenShoots/system.png)
![ScreenShot 2](https://github.com/kh-nguyen/EmailScanner/blob/master/ScreenShoots/email_view.png)
