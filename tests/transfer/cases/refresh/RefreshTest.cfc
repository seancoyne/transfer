<cfcomponent name="CRUDTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");

		assertEqualsBasic(basic.getClassName(), "reload.Basic");
	</cfscript>
</cffunction>

<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");
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
		getTransfer().create(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testEdit" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");

		var qSelect = 0;

		getTransfer().create(basic);

		basic.setString("george");

		getTransfer().update(basic);
	</cfscript>
	<cfquery name="qSelect" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select basic_string
		from
		tbl_basicuuid
		where
		idbasic = <cfqueryparam value="#basic.getIDBasic()#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfscript>
		assertEqualsBasic(qSelect.basic_string, basic.getString());
	</cfscript>
</cffunction>

<cffunction name="testDelete" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");
		var count = 0;

		var qAmount = 0;
		getTransfer().create(basic);
	</cfscript>
	<!--- see if the amount is less --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransfer().delete(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basicuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count - 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testReGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");
		var getBasic = 0;
		getTransfer().create(basic);

		getBasic = getTransfer().get("reload.Basic", basic.getIDBasic());

		assertSameBasic(basic, getBasic);
	</cfscript>
</cffunction>

<cffunction name="testGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");
		var getBasic = 0;
		getTransfer().create(basic);

		getTransfer().discard(basic);

		getBasic = getTransfer().get("reload.Basic", basic.getIDBasic());

		assertEqualsBasic(basic.getIDBasic(), getBasic.getIDBasic());
	</cfscript>
</cffunction>

<cffunction name="testReload" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");

		basic.setString("value");
		basic.setNumeric("128");

		getTransfer().create(basic);

		assertEqualsBasic("gandalf", basic.getString());

		basic.setNumeric("465");

		getTransfer().update(basic);

		assertEqualsBasic("128", basic.getNumeric());
	</cfscript>
</cffunction>

<cffunction name="testReloadNull" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("reload.Basic");

		basic.setString("value");
		basic.setNumericNull();

		getTransfer().create(basic);

		assertEqualsBasic("gandalf", basic.getString());

		basic.setNumeric("465");

		getTransfer().update(basic);

		assertTrueBasic(basic.getNumericIsNull());
	</cfscript>
</cffunction>

</cfcomponent>