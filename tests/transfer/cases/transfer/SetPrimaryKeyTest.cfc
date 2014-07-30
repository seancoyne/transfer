<cfcomponent name="setPrimaryKeyTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testCreateNumeric" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var count = 0;
		
		var qAmount = 0;
		var pk = 42;
		
		basic.setString("setprimarykey" & randrange(0, 1000));
		basic.setIDBasic(pk);
	</cfscript>
	<!--- clear 43 --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		delete
		from
		tbl_basic
		where idbasic = <cfqueryparam value="#pk#" cfsqltype="cf_sql_numeric">
	</cfquery>	
	
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>
	
	<cfscript>
		count = qAmount.amount;
		getTransfer().create(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
		assertEqualsBasic(basic.getIDBasic(), pk);
		
		getTransfer().discard(basic);
		
		test = getTransfer().get("Basic", pk);
		
		assertEqualsBasic(test.getString(), basic.getString());
	</cfscript>
</cffunction>

<cffunction name="testCreateUUID" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("BasicUUID");
		var count = 0;

		var qAmount = 0;
		var pk = createUUID();
		
		basic.setIDBasic(pk);
		basic.setString("setprimarykey" & randrange(0, 1000));
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		delete
		from
		tbl_basicuuid
		where idbasic = <cfqueryparam value="#pk#" cfsqltype="cf_sql_varchar">
	</cfquery>		
	
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>
	
	<cfscript>
		count = qAmount.amount;
		getTransfer().create(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>	
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
		assertEqualsBasic(basic.getIDBasic(), pk);
		
		getTransfer().discard(basic);
		
		test = getTransfer().get("BasicUUID", pk);
		
		assertEqualsBasic(test.getString(), basic.getString());		
	</cfscript>
</cffunction>

<cffunction name="testCreateGUID" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("BasicGUID");
		var count = 0;
		
		var qAmount = 0;
		var util = createObject("component", "transfer.com.util.Utility").init();
		var pk = util.createGUID();
		
		basic.setIDBasic(pk);
		basic.setString("setprimarykey" & randrange(0, 1000));
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		delete
		from
		tbl_basicguid
		where idbasic = <cfqueryparam value="#pk#" cfsqltype="cf_sql_varchar">
	</cfquery>		
	
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicguid
	</cfquery>
	
	<cfscript>
		count = qAmount.amount;
		getTransfer().create(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicguid
	</cfquery>	
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
		assertEqualsBasic(basic.getIDBasic(), pk);
		
		initTransfer();
		
		test = getTransfer().get("BasicGUID", pk);
		
		assertEqualsBasic(test.getString(), basic.getString());
	</cfscript>
</cffunction>

</cfcomponent>