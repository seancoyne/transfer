<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testBasicList" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var q = getTransferD().list("Basic");
		var q2 = 0;
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select idbasic as id, basic_date as dateValue, basic_numeric as numericValue, basic_string as stringValue, basic_UUID as UUID from tbl_basicuuid
	</cfquery>
	<cfscript>
		AssertEquals("queries should be the same", q, q2);
	</cfscript>
</cffunction>

<cffunction name="testListByPropertyMap" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var map = StructNew();
		var q = 0;
		var q2 = 0;

		map.stringValue = "george";

		q = getTransferD().listByPropertyMap("Basic", map);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select idbasic as id, basic_date as dateValue, basic_numeric as numericValue, basic_string as stringValue, basic_uuid as UUID from tbl_basicuuid where basic_string = 'george'
	</cfquery>
	<cfscript>
		AssertEquals("queries should be the same", q, q2);
	</cfscript>
</cffunction>

<cffunction name="testlistByQueryBasic" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var q = 0;
		var tql = "from Basic";
		var q2 = 0;
		var query = 0;

		query = getTransferD().createQuery(tql);

		q = getTransferD().listByQuery(query);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select idbasic as id, basic_date as dateValue, basic_numeric as numericValue, basic_string as stringValue, basic_UUID as UUID from tbl_basicuuid
	</cfquery>
	<cfscript>
		AssertEquals("queries should be the same", q, q2);
	</cfscript>
</cffunction>

</cfcomponent>