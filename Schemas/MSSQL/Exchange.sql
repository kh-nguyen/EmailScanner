USE [Exchange]
GO
/****** Object:  Table [dbo].[ImportMails]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MainDatabasePostProcessingQueues]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MsgTrackingExtendedLogs]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MsgTrackingLogs]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MsgTrackingLogsAttachments]    Script Date: 1/22/2017 1:26:33 PM ******/
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
	[SHA256] [char](64) NULL,
	[verified] [bit] NULL,
	[verified-time] [datetime] NULL,
 CONSTRAINT [PK_MsgTrackingLogsAttachments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MsgTrackingLogsBounces]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MsgTrackingLogsCategories]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Index [IX_MsgTrackingLogsCategories]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE UNIQUE CLUSTERED INDEX [IX_MsgTrackingLogsCategories] ON [dbo].[MsgTrackingLogsCategories]
(
	[Category] ASC,
	[MsgTrackingLogsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MsgTrackingLogsHeaders]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MsgTrackingLogsReceipts]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MsgTrackingLogsRecipientAddresses]    Script Date: 1/22/2017 1:26:33 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[MsgTrackingLogsExtended]    Script Date: 1/22/2017 1:26:33 PM ******/
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
E.[message-body],
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
/****** Object:  View [dbo].[MsgTrackingLogsExtendedPromotions]    Script Date: 1/22/2017 1:26:33 PM ******/
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
/****** Object:  View [dbo].[MsgTrackingLogsExtendedJunks]    Script Date: 1/22/2017 1:26:33 PM ******/
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
/****** Object:  View [dbo].[MsgTrackingLogsExtendedMain]    Script Date: 1/22/2017 1:26:33 PM ******/
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
/****** Object:  View [dbo].[MsgTrackingLogsAddresses]    Script Date: 1/22/2017 1:26:33 PM ******/
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
/****** Object:  View [dbo].[MsgTrackingLogsAttachmentsStatistics]    Script Date: 1/22/2017 1:26:33 PM ******/
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
/****** Object:  Index [IX_MsgTrackingLogs_DateTime]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogs_DateTime] ON [dbo].[MsgTrackingLogs]
(
	[date-time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MsgTrackingLogs_ID_Include_MessageSubject]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogs_ID_Include_MessageSubject] ON [dbo].[MsgTrackingLogs]
(
	[ID] ASC
)
INCLUDE ( 	[message-subject]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MsgTrackingLogs_SenderAddress]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogs_SenderAddress] ON [dbo].[MsgTrackingLogs]
(
	[sender-address] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MsgTrackingLogsMessageID]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsMessageID] ON [dbo].[MsgTrackingLogs]
(
	[message-id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MsgTrackingLogsBounces_ID]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MsgTrackingLogsBounces_ID] ON [dbo].[MsgTrackingLogsBounces]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MsgTrackingLogsHeaders]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsHeaders] ON [dbo].[MsgTrackingLogsHeaders]
(
	[FieldName] ASC,
	[MsgTrackingLogsID] ASC
)
INCLUDE ( 	[ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MsgTrackingLogsHeaders_Lookup]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsHeaders_Lookup] ON [dbo].[MsgTrackingLogsHeaders]
(
	[MsgTrackingLogsID] ASC,
	[ID] ASC,
	[FieldName] ASC
)
INCLUDE ( 	[FieldBody]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_MsgTrackingLogsHeaders_Unique]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MsgTrackingLogsHeaders_Unique] ON [dbo].[MsgTrackingLogsHeaders]
(
	[MsgTrackingLogsID] ASC,
	[Line] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MsgTrackingLogsRecipientAddresses_C2_C3]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsRecipientAddresses_C2_C3] ON [dbo].[MsgTrackingLogsRecipientAddresses]
(
	[MsgTrackingLogsID] ASC,
	[recipient-address] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MsgTrackingLogsRecipientAddresses_C5]    Script Date: 1/22/2017 1:26:33 PM ******/
CREATE NONCLUSTERED INDEX [IX_MsgTrackingLogsRecipientAddresses_C5] ON [dbo].[MsgTrackingLogsRecipientAddresses]
(
	[domain-part] ASC
)
INCLUDE ( 	[MsgTrackingLogsID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MsgTrackingExtendedLogs]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingExtendedLogs_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingExtendedLogs] CHECK CONSTRAINT [FK_MsgTrackingExtendedLogs_MsgTrackingLogs]
GO
ALTER TABLE [dbo].[MsgTrackingLogsAttachments]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsAttachments_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsAttachments] CHECK CONSTRAINT [FK_MsgTrackingLogsAttachments_MsgTrackingLogs]
GO
ALTER TABLE [dbo].[MsgTrackingLogsBounces]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsBounces_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsBounces] CHECK CONSTRAINT [FK_MsgTrackingLogsBounces_MsgTrackingLogs]
GO
ALTER TABLE [dbo].[MsgTrackingLogsCategories]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsCategories_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsCategories] CHECK CONSTRAINT [FK_MsgTrackingLogsCategories_MsgTrackingLogs]
GO
ALTER TABLE [dbo].[MsgTrackingLogsHeaders]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsHeaders_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsHeaders] CHECK CONSTRAINT [FK_MsgTrackingLogsHeaders_MsgTrackingLogs]
GO
ALTER TABLE [dbo].[MsgTrackingLogsReceipts]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsReceipts_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsReceipts] CHECK CONSTRAINT [FK_MsgTrackingLogsReceipts_MsgTrackingLogs]
GO
ALTER TABLE [dbo].[MsgTrackingLogsRecipientAddresses]  WITH CHECK ADD  CONSTRAINT [FK_MsgTrackingLogsRecipientAddresses_MsgTrackingLogs] FOREIGN KEY([MsgTrackingLogsID])
REFERENCES [dbo].[MsgTrackingLogs] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MsgTrackingLogsRecipientAddresses] CHECK CONSTRAINT [FK_MsgTrackingLogsRecipientAddresses_MsgTrackingLogs]
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
