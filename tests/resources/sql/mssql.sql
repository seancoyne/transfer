if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lnk_composite1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lnk_composite1]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lnk_manytomany2UUID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lnk_manytomany2UUID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[lnk_manytomanyUUID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[lnk_manytomanyUUID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_A]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_A]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_B]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_B]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_C]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_C]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_ChildManyToOneUUID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_ChildManyToOneUUID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_NoneChild]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_NoneChild]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_ap]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_ap]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_basic]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_basic]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_basicGUID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_basicGUID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_basicUUID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_basicUUID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_bigstuff]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_bigstuff]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_composite]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_composite]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_d]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_d]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_generate]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_generate]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_manyToOneUUID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_manyToOneUUID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_manytomanyUUID]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_manytomanyUUID]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_none]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_none]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_onetomany]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_onetomany]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_onetomanyChild]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_onetomanyChild]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_propchild]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_propchild]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_propparent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_propparent]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_transaction]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_transaction]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_tree]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_tree]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[transfer_sequence]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[transfer_sequence]
GO

CREATE TABLE [dbo].[lnk_composite1] (
	[lnkidbasic] [numeric](18, 0) NOT NULL ,
	[lnkIDComposite] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[lnk_manytomany2UUID] (
	[lnkIDManytoMany] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkIDBasic] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[lnk_manytomanyUUID] (
	[lnkIDManytoMany] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkIDBasic] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_A] (
	[a_id] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkid] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkid2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[a_value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_B] (
	[b_id] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkid] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkid2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[b_value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_C] (
	[c_id] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkid] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkid2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[c_value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_ChildManyToOneUUID] (
	[IDChild] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[manytoonechild_string] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_NoneChild] (
	[IDChild] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[child_name] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkBasicID] [numeric](18, 0) NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_ap] (
	[ap_id] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[a_id] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[stringvalue] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_basic] (
	[IDBasic] [numeric](18, 0) NOT NULL ,
	[basic_date] [datetime] NULL ,
	[basic_numeric] [numeric](18, 0) NULL ,
	[basic_string] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[basic_UUID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[basic_boolean] [bit] NULL ,
	[basic_decimal] [decimal](18, 5) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_basicGUID] (
	[IDBasic] [uniqueidentifier] NOT NULL ,
	[basic_date] [datetime] NOT NULL ,
	[basic_numeric] [numeric](18, 0) NOT NULL ,
	[basic_string] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[basic_UUID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_basicUUID] (
	[IDBasic] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[basic_date] [datetime] NOT NULL ,
	[basic_numeric] [numeric](18, 0) NULL ,
	[basic_string] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[basic_UUID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_bigstuff] (
	[bigstuffid] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[bigstuff_clob] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[bigstuff_blob] [image] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_composite] (
	[IDComposite] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[composite_string] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkidbasic] [numeric](18, 0) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_d] (
	[d_id] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkid] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkid2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[d_value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_generate] (
	[IDGenerate] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[generate_value] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_manyToOneUUID] (
	[IDSimple] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[manytoone_string] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[lnkIDChild] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_manytomanyUUID] (
	[IDSimple] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_none] (
	[idbasic] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[basic_string] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_onetomany] (
	[idbasic] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[basic_string] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_onetomanyChild] (
	[IDChild] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[child_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkBasicID] [numeric](18, 0) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_propchild] (
	[idpropchild] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[thing] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkidpropparent] [numeric](18, 0) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_propparent] (
	[idpropparent] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[thing] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_transaction] (
	[idtransaction] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[string] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tbl_tree] (
	[IDTree] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[tree_Value] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lnkIDTree] [numeric](18, 0) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[transfer_sequence] (
	[sequence_name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[sequence_value] [numeric](20, 0) NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_bigstuff] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_bigstuff] PRIMARY KEY  CLUSTERED 
	(
		[bigstuffid]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_d] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[d_id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[transfer_sequence] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[sequence_name]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_basicUUID] ADD 
	CONSTRAINT [DF_tbl_basicUUID_basic_string] DEFAULT ('gandalf') FOR [basic_string]
GO

ALTER TABLE [dbo].[tbl_bigstuff] ADD 
	CONSTRAINT [DF_tbl_bigstuff_bigstuff_clob] DEFAULT (null) FOR [bigstuff_clob]
GO

