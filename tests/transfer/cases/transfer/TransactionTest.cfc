<cfcomponent name="CRUDTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");

		assertEqualsBasic(basic.getClassName(), "Basic");
	</cfscript>
</cffunction>

<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var count = 0;

		var qAmount = 0;

		basic.setBoolean(RandRange(0,1));
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>

	<cftransaction>
		<cfscript>
			count = qAmount.amount;
			getTransfer().create(basic, false);
		</cfscript>
	</cftransaction>

	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testEdit" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");

		var qSelect = 0;

		getTransfer().create(basic);

		basic.setString("george");

		basic.setBoolean(RandRange(0,1));
	</cfscript>

	<cftransaction>
	<cfscript>
		getTransfer().update(basic, false);
	</cfscript>
	</cftransaction>

	<cfquery name="qSelect" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select basic_string
		from
		tbl_basic
		where
		idbasic = <cfqueryparam value="#basic.getIDBasic()#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfscript>
		assertEqualsBasic(qSelect.basic_string, basic.getString());
	</cfscript>
</cffunction>

<cffunction name="testSave" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");

		var qSelect = 0;

	</cfscript>

	<cftransaction>
	<cfscript>
		getTransfer().save(basic, false);

		basic.setString("george");

		basic.setBoolean(RandRange(0,1));
	</cfscript>

	<cfscript>
		getTransfer().save(basic, false);
	</cfscript>
	</cftransaction>

	<cfquery name="qSelect" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select basic_string
		from
		tbl_basic
		where
		idbasic = <cfqueryparam value="#basic.getIDBasic()#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfscript>
		assertEqualsBasic(qSelect.basic_string, basic.getString());
	</cfscript>
</cffunction>

<cffunction name="testDelete" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var count = 0;

		var qAmount = 0;
		getTransfer().create(basic);
	</cfscript>
	<!--- see if the amount is less --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>

	<cftransaction>
		<cfscript>
			count = qAmount.amount;
			getTransfer().delete(basic, false);
		</cfscript>
	</cftransaction>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>
	<cfscript>
		assertEqualsBasic(count - 1, qAmount.amount);
	</cfscript>
</cffunction>

</cfcomponent>