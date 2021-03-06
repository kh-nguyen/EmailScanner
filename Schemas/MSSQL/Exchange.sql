USE [master]
GO
/****** Object:  Database [Emails]    Script Date: 06/17/2017 18:16:47 ******/
CREATE DATABASE [Emails] ON  PRIMARY 
( NAME = N'Emails', FILENAME = N'G:\Backup\Emails.mdf' , SIZE = 7749376KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Emails_log', FILENAME = N'G:\Backup\Emails_log.ldf' , SIZE = 3226240KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Emails] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Emails].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Emails] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [Emails] SET ANSI_NULLS OFF
GO
ALTER DATABASE [Emails] SET ANSI_PADDING OFF
GO
ALTER DATABASE [Emails] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [Emails] SET ARITHABORT OFF
GO
ALTER DATABASE [Emails] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [Emails] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [Emails] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [Emails] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [Emails] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [Emails] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [Emails] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [Emails] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [Emails] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [Emails] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [Emails] SET  DISABLE_BROKER
GO
ALTER DATABASE [Emails] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [Emails] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [Emails] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [Emails] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [Emails] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [Emails] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [Emails] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [Emails] SET  READ_WRITE
GO
ALTER DATABASE [Emails] SET RECOVERY SIMPLE
GO
ALTER DATABASE [Emails] SET  MULTI_USER
GO
ALTER DATABASE [Emails] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [Emails] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'Emails', N'ON'
GO
USE [Emails]
GO
/****** Object:  User [test]    Script Date: 06/17/2017 18:16:47 ******/
CREATE USER [test] FOR LOGIN [test] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IIS APPPOOL\DefaultAppPool]    Script Date: 06/17/2017 18:16:47 ******/
CREATE USER [IIS APPPOOL\DefaultAppPool] FOR LOGIN [IIS APPPOOL\DefaultAppPool]
GO
/****** Object:  User [BackupOperator]    Script Date: 06/17/2017 18:16:47 ******/
CREATE USER [BackupOperator] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  Schema [HangFire]    Script Date: 06/17/2017 18:16:48 ******/
CREATE SCHEMA [HangFire] AUTHORIZATION [test]
GO
/****** Object:  Table [dbo].[MsgTrackingLogs]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MsgTrackingLogs](
	[client-ip] [nvarchar](255) NULL,
	[client-hostname] [nvarchar](255) NULL,
	[server-ip] [nvarchar](255) NULL,
	[server-hostname] [nvarchar](255) NULL,
	[source-context] [nvarchar](max) NULL,
	[connector-id] [nvarchar](max) NULL,
	[source] [nvarchar](11) NULL,
	[event-id] [nvarchar](13) NULL,
	[internal-message-id] [bigint] NULL,
	[message-id] [nvarchar](255) NULL,
	[recipient-address] [nvarchar](max) NULL,
	[recipient-status] [nvarchar](max) NULL,
	[total-bytes] [bigint] NULL,
	[recipient-count] [int] NULL,
	[related-recipient-address] [nvarchar](max) NULL,
	[reference] [nvarchar](max) NULL,
	[message-subject] [nvarchar](max) NULL,
	[sender-address] [nvarchar](255) NULL,
	[return-path] [nvarchar](255) NULL,
	[message-info] [nvarchar](255) NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[date-time] [datetime2](7) NULL,
 CONSTRAINT [PK_MsgTrackingLogs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogs_DateTime] ON [dbo].[MsgTrackingLogs] 
(
	[date-time] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogs_ID_Include_MessageSubject] ON [dbo].[MsgTrackingLogs] 
(
	[ID] ASC
)
INCLUDE ( [message-subject]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogs_SenderAddress] ON [dbo].[MsgTrackingLogs] 
(
	[sender-address] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsMessageID] ON [dbo].[MsgTrackingLogs] 
(
	[message-id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Job]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Job](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StateId] [int] NULL,
	[StateName] [nvarchar](20) NULL,
	[InvocationData] [nvarchar](max) NOT NULL,
	[Arguments] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Job] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Job_ExpireAt] ON [HangFire].[Job] 
(
	[ExpireAt] ASC
)
INCLUDE ( [Id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Job_StateName] ON [HangFire].[Job] 
(
	[StateName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ImportMails]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ImportMails](
	[ID] [uniqueidentifier] NOT NULL,
	[ContactID] [int] NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Recursive] [bit] NOT NULL,
	[Hostname] [nvarchar](50) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[PasswordSalt] [nvarchar](10) NULL,
	[Port] [int] NULL,
	[SSL] [bit] NULL,
	[SkipSslValidation] [bit] NULL,
	[ScanFromDate] [datetime] NULL,
	[ScanToDate] [datetime] NULL,
	[Status] [nvarchar](max) NULL,
	[MailboxName] [nvarchar](100) NULL,
	[MailboxCurrent] [nvarchar](100) NULL,
	[MessageCount] [bigint] NULL,
	[Processing] [bit] NULL,
	[Error] [bit] NULL,
	[LastSeenId] [bigint] NULL,
	[LastSeenMessageId] [nvarchar](255) NULL,
	[LastSeenMessageDate] [datetime] NULL,
	[PageSize] [int] NULL,
	[OffSet] [int] NULL,
 CONSTRAINT [PK_ImportMails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Hash]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Hash](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Field] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime2](7) NULL,
 CONSTRAINT [PK_HangFire_Hash] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Hash_ExpireAt] ON [HangFire].[Hash] 
(
	[ExpireAt] ASC
)
INCLUDE ( [Id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Hash_Key] ON [HangFire].[Hash] 
(
	[Key] ASC
)
INCLUDE ( [ExpireAt]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_HangFire_Hash_Key_Field] ON [HangFire].[Hash] 
(
	[Key] ASC,
	[Field] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Counter]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Counter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Value] [smallint] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Counter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Counter_Key] ON [HangFire].[Counter] 
(
	[Key] ASC
)
INCLUDE ( [Value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contacts]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contacts](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[First Name] [nvarchar](50) NOT NULL,
	[Last Name] [nvarchar](50) NOT NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[AggregatedCounter]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[AggregatedCounter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Value] [bigint] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_CounterAggregated] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_HangFire_CounterAggregated_Key] ON [HangFire].[AggregatedCounter] 
(
	[Key] ASC
)
INCLUDE ( [Value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MainDatabasePostProcessingQueues]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MainDatabasePostProcessingQueues](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[TaskCommand] [int] NULL,
	[TaskArg1] [varbinary](max) NULL,
	[TaskArg2] [varbinary](max) NULL,
	[TaskDataInt] [int] NULL,
	[TaskDataBigInt] [bigint] NULL,
	[TaskDataGuid] [uniqueidentifier] NULL,
	[TaskDataString] [nvarchar](max) NULL,
	[ExecutionTime] [datetime] NULL,
	[Priority] [smallint] NULL,
	[Notes] [nvarchar](max) NULL,
	[IsScheduled] [bit] NULL,
	[FetchedAt] [datetime] NULL,
	[Hangfire] [datetime] NULL,
	[AutoDelete] [bit] NULL,
	[Abort] [bit] NULL,
	[CreationTime] [datetime] NULL,
 CONSTRAINT [PK_MainDatabasePostProcessingQueues] PRIMARY KEY NONCLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [HangFire].[List]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[List](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_List] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_List_ExpireAt] ON [HangFire].[List] 
(
	[ExpireAt] ASC
)
INCLUDE ( [Id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_List_Key] ON [HangFire].[List] 
(
	[Key] ASC
)
INCLUDE ( [ExpireAt],
[Value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobQueue]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobQueue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[Queue] [nvarchar](50) NOT NULL,
	[FetchedAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_JobQueue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_JobQueue_QueueAndFetchedAt] ON [HangFire].[JobQueue] 
(
	[Queue] ASC,
	[FetchedAt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Set]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Set](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Score] [float] NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Set] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Set_ExpireAt] ON [HangFire].[Set] 
(
	[ExpireAt] ASC
)
INCLUDE ( [Id]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_Set_Key] ON [HangFire].[Set] 
(
	[Key] ASC
)
INCLUDE ( [ExpireAt],
[Value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_HangFire_Set_KeyAndValue] ON [HangFire].[Set] 
(
	[Key] ASC,
	[Value] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Server]    Script Date: 06/17/2017 18:16:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Server](
	[Id] [nvarchar](100) NOT NULL,
	[Data] [nvarchar](max) NULL,
	[LastHeartbeat] [datetime] NOT NULL,
 CONSTRAINT [PK_HangFire_Server] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Schema]    Script Date: 06/17/2017 18:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Schema](
	[Version] [int] NOT NULL,
 CONSTRAINT [PK_HangFire_Schema] PRIMARY KEY CLUSTERED 
(
	[Version] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[State]    Script Date: 06/17/2017 18:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[State](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Reason] [nvarchar](100) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Data] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_State] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_State_JobId] ON [HangFire].[State] 
(
	[JobId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MsgTrackingLogsRecipientAddresses]    Script Date: 06/17/2017 18:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MsgTrackingLogsRecipientAddresses](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[recipient-address] [nvarchar](255) NOT NULL,
	[MsgTrackingLogsID] [bigint] NOT NULL,
	[recipient-name] [nvarchar](max) NULL,
	[domain-part] [nvarchar](255) NULL,
	[MsgTrackingLogsBounceID] [bigint] NULL,
	[recipient-type] [nvarchar](4) NULL,
	[MsgTrackingLogsReceiptDeliveryID] [bigint] NULL,
 CONSTRAINT [PK_MsgTrackingLogsRecipientAddresses] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsRecipientAddresses_C2_C3] ON [dbo].[MsgTrackingLogsRecipientAddresses] 
(
	[MsgTrackingLogsID] ASC,
	[recipient-address] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsRecipientAddresses_C5] ON [dbo].[MsgTrackingLogsRecipientAddresses] 
(
	[domain-part] ASC
)
INCLUDE ( [MsgTrackingLogsID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MsgTrackingLogsReceipts]    Script Date: 06/17/2017 18:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MsgTrackingLogsReceipts](
	[MsgTrackingLogsID] [bigint] NOT NULL,
	[receipt-id] [bigint] NOT NULL,
	[receipt-type] [tinyint] NOT NULL,
 CONSTRAINT [PK_MsgTrackingLogsReceipts] PRIMARY KEY CLUSTERED 
(
	[MsgTrackingLogsID] ASC,
	[receipt-id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MsgTrackingLogsHeaders]    Script Date: 06/17/2017 18:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MsgTrackingLogsHeaders](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[MsgTrackingLogsID] [bigint] NOT NULL,
	[Line] [smallint] NOT NULL,
	[FieldName] [nvarchar](255) NOT NULL,
	[FieldBody] [nvarchar](max) NULL,
 CONSTRAINT [PK_MsgTrackingLogsHeaders] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsHeaders] ON [dbo].[MsgTrackingLogsHeaders] 
(
	[FieldName] ASC,
	[MsgTrackingLogsID] ASC
)
INCLUDE ( [ID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsHeaders_Lookup] ON [dbo].[MsgTrackingLogsHeaders] 
(
	[MsgTrackingLogsID] ASC,
	[ID] ASC,
	[FieldName] ASC
)
INCLUDE ( [FieldBody]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MsgTrackingLogsHeaders_Unique] ON [dbo].[MsgTrackingLogsHeaders] 
(
	[MsgTrackingLogsID] ASC,
	[Line] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobParameter]    Script Date: 06/17/2017 18:16:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobParameter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[JobId] [int] NOT NULL,
	[Name] [nvarchar](40) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_JobParameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HangFire_JobParameter_JobIdAndName] ON [HangFire].[JobParameter] 
(
	[JobId] ASC,
	[Name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[ContactsExtended]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ContactsExtended]
AS
SELECT     ID, [First Name], [Last Name], [First Name] + ' ' + [Last Name] AS Name, Notes
FROM         dbo.Contacts
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Contacts"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 111
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ContactsExtended'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ContactsExtended'
GO
/****** Object:  Table [dbo].[MsgTrackingExtendedLogs]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MsgTrackingExtendedLogs](
	[message-body] [nvarchar](max) NULL,
	[message-body-type] [nvarchar](4) NULL,
	[attachments] [nvarchar](max) NULL,
	[sender-name] [nvarchar](255) NULL,
	[display-to] [nvarchar](max) NULL,
	[display-cc] [nvarchar](max) NULL,
	[journal-message-id] [nvarchar](255) NULL,
	[MsgTrackingLogsID] [bigint] NOT NULL,
	[conversation-id] [uniqueidentifier] NULL,
	[conversation-count] [int] NULL,
	[message-body-sha1] [char](40) NULL,
	[message-body-text] [nvarchar](max) NULL,
	[list-unsubscribe-headers-id] [bigint] NULL,
	[is-message-receipt] [bit] NULL,
	[from-address] [nvarchar](255) NULL,
	[from-name] [nvarchar](255) NULL,
 CONSTRAINT [PK_MsgTrackingExtendedLogs] PRIMARY KEY CLUSTERED 
(
	[MsgTrackingLogsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactsEmails]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactsEmails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NOT NULL,
	[E-mail Address] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_ContactsEmails] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MsgTrackingLogsAttachments]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MsgTrackingLogsAttachments](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[MsgTrackingLogsID] [bigint] NOT NULL,
	[attachment-name] [nvarchar](max) NULL,
	[attachment-location] [nvarchar](max) NULL,
	[attachment-content-type] [nvarchar](255) NULL,
	[attachment-size] [bigint] NULL,
	[attachment-is-inline] [bit] NULL,
	[attachment_content_id] [nvarchar](max) NULL,
	[SHA256] [char](64) NULL,
	[verified] [bit] NULL,
	[verified-time] [datetime] NULL,
 CONSTRAINT [PK_MsgTrackingLogsAttachments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MsgTrackingLogsCategories]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MsgTrackingLogsCategories](
	[MsgTrackingLogsID] [bigint] NOT NULL,
	[Category] [int] NOT NULL,
	[Assignor] [int] NULL,
 CONSTRAINT [PK_MsgTrackingLogsCategories] PRIMARY KEY NONCLUSTERED 
(
	[MsgTrackingLogsID] ASC,
	[Category] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [IX_MsgTrackingLogsCategories] ON [dbo].[MsgTrackingLogsCategories] 
(
	[Category] ASC,
	[MsgTrackingLogsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MsgTrackingLogsBounces]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MsgTrackingLogsBounces](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[MsgTrackingLogsID] [bigint] NOT NULL,
	[source-id] [bigint] NOT NULL,
	[date-time] [datetime] NULL,
	[smtp-code] [int] NULL,
	[extended-smtp-code] [char](10) NULL,
	[error-message] [nvarchar](max) NULL,
	[recipient-address] [nvarchar](255) NULL,
	[server-address] [nvarchar](255) NULL,
 CONSTRAINT [PK_MsgTrackingLogsBounces] PRIMARY KEY CLUSTERED 
(
	[MsgTrackingLogsID] ASC,
	[source-id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_MsgTrackingLogsBounces_ID] ON [dbo].[MsgTrackingLogsBounces] 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  View [dbo].[MsgTrackingLogsAttachmentsStatistics]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsAttachmentsStatistics]
AS

WITH A AS (
	SELECT SHA256, COUNT(*) AS Count,
	MIN(A.ID) AS RowID,
	MIN([attachment-size]) AS FileSize,
	SUM([attachment-size]) As TotalSize
	FROM MsgTrackingLogsAttachments A
	GROUP BY SHA256
)
SELECT
B.MsgTrackingLogsID,
B.[attachment-name],
B.[attachment-size],
A.*
FROM A
INNER JOIN MsgTrackingLogsAttachments B
ON A.RowID = B.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 189
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 227
               Bottom = 114
               Right = 429
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsAttachmentsStatistics'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsAttachmentsStatistics'
GO
/****** Object:  View [dbo].[MsgTrackingLogsAddresses]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsAddresses]
AS
SELECT
	ID AS MsgTrackingLogsID,
	[sender-address] AS EmailAddress
FROM
	dbo.MsgTrackingLogs

UNION ALL

SELECT
	MsgTrackingLogsID,
	[recipient-address] AS EmailAddress
FROM
	MsgTrackingLogsRecipientAddresses
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MsgTrackingLogs"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 18
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsAddresses'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsAddresses'
GO
/****** Object:  View [dbo].[ContactsEmailsExtended]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ContactsEmailsExtended]
AS
SELECT     ID, ContactID, [E-mail Address]
FROM         dbo.ContactsEmails
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ContactsEmails"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 111
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ContactsEmailsExtended'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ContactsEmailsExtended'
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtended]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtended]
AS

SELECT
M.ID,
M.[date-time],
M.[client-ip], 
M.[client-hostname],
M.[server-ip],
M.[server-hostname],
M.[source-context], 
M.[connector-id],
M.source,
M.[event-id],
M.[internal-message-id], 
M.[message-id],
M.[recipient-address],
M.[recipient-status],
M.[total-bytes], 
M.[recipient-count],
M.[related-recipient-address],
M.reference,
M.[message-subject], 
M.[sender-address],
M.[return-path],
M.[message-info],
ISNULL(E.[message-body], E.[message-body-text]) as [message-body],
E.[message-body-text],
E.[message-body-type],
E.attachments,
ISNULL(E.[sender-name], M.[sender-address]) AS [sender-name],
ISNULL(E.[display-to], M.[recipient-address]) AS [display-to],
E.[display-cc]
FROM dbo.MsgTrackingLogs M
LEFT OUTER JOIN
dbo.MsgTrackingExtendedLogs E
ON M.ID = E.MsgTrackingLogsID
GO
/****** Object:  View [dbo].[MsgTrackingLogsContacts]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsContacts]
AS
	SELECT
		M.ID, E.ContactID
	FROM
		dbo.MsgTrackingLogs AS M
	INNER JOIN
		dbo.ContactsEmails AS E
	ON
		M.[sender-address] = E.[E-mail Address]
	
	UNION
	
	SELECT
		M.MsgTrackingLogsID, E.ContactID
	FROM
		dbo.MsgTrackingLogsRecipientAddresses AS M
	INNER JOIN
		dbo.ContactsEmails AS E
	ON
		M.[recipient-address] = E.[E-mail Address]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MsgTrackingLogsExtended"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsContacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsContacts'
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtendedJunks]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtendedJunks]
AS

SELECT E.*
FROM  MsgTrackingLogsExtended E
INNER JOIN MsgTrackingLogsCategories C
ON E.ID = C.MsgTrackingLogsID
AND C.Category = 6
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtendedContacts]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtendedContacts]
AS

SELECT
	A.ContactID,
	M.*
FROM
	dbo.MsgTrackingLogsExtended AS M
INNER JOIN
	dbo.MsgTrackingLogsContacts A
ON
	M.ID = A.ID
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtendedMain]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtendedMain]
AS

SELECT E.*
FROM  MsgTrackingLogsExtended E
LEFT JOIN MsgTrackingLogsCategories C
ON E.ID = C.MsgTrackingLogsID
WHERE C.MsgTrackingLogsID IS NULL
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtendedPromotions]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtendedPromotions]
AS

SELECT E.*
FROM  MsgTrackingLogsExtended E
INNER JOIN MsgTrackingLogsCategories C
ON E.ID = C.MsgTrackingLogsID
AND C.Category = 5
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "E"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 297
               Bottom = 119
               Right = 491
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedPromotions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedPromotions'
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtendedMainContacts]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtendedMainContacts]
AS

SELECT
	A.ContactID,
	M.*
FROM
	dbo.MsgTrackingLogsExtendedMain AS M
INNER JOIN
	dbo.MsgTrackingLogsContacts A
ON
	M.ID = A.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "M"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedMainContacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedMainContacts'
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtendedJunksContacts]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtendedJunksContacts]
AS

SELECT
	A.ContactID,
	M.*
FROM
	dbo.MsgTrackingLogsExtendedJunks AS M
INNER JOIN
	dbo.MsgTrackingLogsContacts A
ON
	M.ID = A.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "M"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "A_1"
            Begin Extent = 
               Top = 6
               Left = 286
               Bottom = 96
               Right = 446
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedJunksContacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedJunksContacts'
GO
/****** Object:  View [dbo].[MsgTrackingLogsExtendedPromotionsContacts]    Script Date: 06/17/2017 18:16:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[MsgTrackingLogsExtendedPromotionsContacts]
AS

SELECT
	A.ContactID,
	M.*
FROM
	dbo.MsgTrackingLogsExtendedPromotions AS M
INNER JOIN
	dbo.MsgTrackingLogsContacts A
ON
	M.ID = A.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MsgTrackingLogsExtendedPromotions"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedPromotionsContacts'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'MsgTrackingLogsExtendedPromotionsContacts'
GO
/****** Object:  ForeignKey [FK_HangFire_State_Job]    Script Date: 06/17/2017 18:16:50 ******/
ALTER TABLE [HangFire].[State]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_State_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[State] CHECK CONSTRAINT [FK_HangFire_State_Job]
GO
/****** Object:  ForeignKey [FK_MsgTrackingLogsRecipientAddresses_MsgTrackingLogs]    Script Date: 06/17/2017 18:16:50 ******/
ALTER TABLE [dbo].[MsgTrackingLogsRecipientAddresses]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsRecipientAddresses_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsRecipientAddresses] CHECK CONSTRAINT [FK_MsgTrackingLogsRecipientAddresses_MsgTrackingLogs]
GO
/****** Object:  ForeignKey [FK_MsgTrackingLogsReceipts_MsgTrackingLogs]    Script Date: 06/17/2017 18:16:50 ******/
ALTER TABLE [dbo].[MsgTrackingLogsReceipts]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsReceipts_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsReceipts] CHECK CONSTRAINT [FK_MsgTrackingLogsReceipts_MsgTrackingLogs]
GO
/****** Object:  ForeignKey [FK_MsgTrackingLogsHeaders_MsgTrackingLogs]    Script Date: 06/17/2017 18:16:50 ******/
ALTER TABLE [dbo].[MsgTrackingLogsHeaders]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsHeaders_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsHeaders] CHECK CONSTRAINT [FK_MsgTrackingLogsHeaders_MsgTrackingLogs]
GO
/****** Object:  ForeignKey [FK_HangFire_JobParameter_Job]    Script Date: 06/17/2017 18:16:50 ******/
ALTER TABLE [HangFire].[JobParameter]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_JobParameter_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[JobParameter] CHECK CONSTRAINT [FK_HangFire_JobParameter_Job]
GO
/****** Object:  ForeignKey [FK_MsgTrackingExtendedLogs_MsgTrackingLogs]    Script Date: 06/17/2017 18:16:51 ******/
ALTER TABLE [dbo].[MsgTrackingExtendedLogs]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingExtendedLogs_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingExtendedLogs] CHECK CONSTRAINT [FK_MsgTrackingExtendedLogs_MsgTrackingLogs]
GO
/****** Object:  ForeignKey [FK_ContactsEmails_Contacts]    Script Date: 06/17/2017 18:16:51 ******/
ALTER TABLE [dbo].[ContactsEmails]  WITH CHECK ADD  CONSTRAINT [FK_ContactsEmails_Contacts] FOREIGN KEY([ContactID])
REFERENCES [dbo].[Contacts] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ContactsEmails] CHECK CONSTRAINT [FK_ContactsEmails_Contacts]
GO
/****** Object:  ForeignKey [FK_MsgTrackingLogsAttachments_MsgTrackingLogs]    Script Date: 06/17/2017 18:16:51 ******/
ALTER TABLE [dbo].[MsgTrackingLogsAttachments]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsAttachments_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsAttachments] CHECK CONSTRAINT [FK_MsgTrackingLogsAttachments_MsgTrackingLogs]
GO
/****** Object:  ForeignKey [FK_MsgTrackingLogsCategories_MsgTrackingLogs]    Script Date: 06/17/2017 18:16:51 ******/
ALTER TABLE [dbo].[MsgTrackingLogsCategories]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsCategories_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsCategories] CHECK CONSTRAINT [FK_MsgTrackingLogsCategories_MsgTrackingLogs]
GO
/****** Object:  ForeignKey [FK_MsgTrackingLogsBounces_MsgTrackingLogs]    Script Date: 06/17/2017 18:16:51 ******/
ALTER TABLE [dbo].[MsgTrackingLogsBounces]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsBounces_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsBounces] CHECK CONSTRAINT [FK_MsgTrackingLogsBounces_MsgTrackingLogs]
GO
