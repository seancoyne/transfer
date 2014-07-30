<cfcomponent name="AutoGenerateTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var AutoGenerate = getTransfer().new("AutoGenerate");
		
		assertEqualsBasic(AutoGenerate.getClassName(), "AutoGenerate");
	</cfscript>
</cffunction>

<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
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
		getTransfer().create(AutoGenerate);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_generate
	</cfquery>	
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testCreateID" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var AutoGenerate = getTransfer().new("AutoGenerate");
		var count = 0;
		
		var qAmount = 0;
	</cfscript>
	<!--- see if the amount is more --->
	<cfscript>
		getTransfer().create(AutoGenerate);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select Max(IDGenerate) as id
		from
		tbl_generate
	</cfquery>	
	<cfscript>
		assertEqualsBasic(autoGenerate.getIDGenerate(),qAmount.id);
	</cfscript>
</cffunction>

</cfcomponent>