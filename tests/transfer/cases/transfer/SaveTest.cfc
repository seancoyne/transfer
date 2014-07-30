<cfcomponent name="AutoGenerateTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testSave" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var AutoGenerate = getTransfer().new("AutoGenerate");
		var count = 0;
		
		var qAmount = 0;
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_generate
	</cfquery>
	
	<cfscript>
		count = qAmount.amount;
		getTransfer().save(AutoGenerate);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_generate
	</cfquery>	
	<cfscript>
		assertEquals("insert failed", count + 1, qAmount.amount);
	</cfscript>
	<cfscript>
		autogenerate.setValue("george");
		getTransfer().save(autogenerate);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_generate
	</cfquery>
	<cfscript>
		assertEquals("update failed", count + 1, qAmount.amount);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select generate_value
		from
		tbl_generate
		where
		IDGenerate = <cfqueryparam value="#autogenerate.getIDGenerate()#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfscript>
		assertEquals("update values failed", autogenerate.getValue(), qAmount.generate_value);
	</cfscript>	
</cffunction>

<cffunction name="testSaveUUID" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var BasicUUID = getTransfer().new("BasicUUID");
		var count = 0;
		
		var qAmount = 0;
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>
	
	<cfscript>
		count = qAmount.amount;
		getTransfer().save(BasicUUID);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>	
	<cfscript>
		assertEquals("insert failed", count + 1, qAmount.amount);
	</cfscript>
	<cfscript>
		BasicUUID.setString("george");
		getTransfer().save(BasicUUID);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>
	<cfscript>
		assertEquals("update failed", count + 1, qAmount.amount);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select basic_string
		from
		tbl_basicuuid
		where
		IDBasic = <cfqueryparam value="#BasicUUID.getIDBasic()#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>
	<cfscript>
		assertEquals("update values failed", BasicUUID.getString(), qAmount.basic_string);
	</cfscript>	
</cffunction>

</cfcomponent>