<cfcomponent name="GatewayTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testList" hint="" access="public" returntype="void" output="false">
	<cfscript>

		var transfer = getTransfer();
		var qQuery = 0;
		var qGateway = transfer.list(className="onetomany.Basic", useAliases=false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select *
		from
		tbl_onetomany
	</cfquery>

	<cfscript>
		assertEqualsBasic(qQuery, qGateway);
	</cfscript>
</cffunction>

<cffunction name="testListOrder" hint="" access="public" returntype="void" output="false">
	<cfscript>

		var transfer = getTransfer();
		var qQuery = 0;
		var qGateway = transfer.list("onetomany.Basic", "string", false, false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select
		*
		from
		tbl_onetomany
		order by basic_string desc
	</cfquery>

	<cfscript>
		assertEqualsBasic(qQuery, qGateway);
	</cfscript>
</cffunction>

<cffunction name="testListAlias" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var qGateway = getTransferB().list("BasicAliasID");

		assertTrue(Len(qGateway.id));
	</cfscript>
</cffunction>

<cffunction name="testListBlank" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var transfer = getTransfer();
		var qQuery = 0;
		var qGateway = transfer.list("onetomany.Basic", "string", false);
		//var qGateway2 = transfer.listByWhere("onetomany.Basic", "", "string", false);
		var qGateway3 = transfer.listByPropertyMap("onetomany.Basic", StructNew(), "string", false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select
		BASIC_STRING as STRING,
		IDBASIC
		from
		tbl_onetomany
		order by basic_string desc
	</cfquery>

	<cfscript>
		assertEquals("list", qQuery, qGateway);
		//assertEquals("listByWhere", qQuery, qGateway2);
		assertEquals("listByPropertyMap", qQuery, qGateway3);
	</cfscript>
</cffunction>


<cffunction name="testListByProperty" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var transfer = getTransfer();
		var qQuery = 0;
		var qGateway = transfer.listByProperty(className="AutoGenerate", propertyName="value", propertyValue="george", useAliases=false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select *
		from
		tbl_generate
		where
		generate_value
		=
		'george'
	</cfquery>

	<cfscript>
		assertEqualsBasic(qQuery, qGateway);
	</cfscript>
</cffunction>

<cffunction name="testListByPropertyStruct" hint="" access="public" returntype="void" output="false">
	<cfscript>

		var transfer = getTransfer();
		var qQuery = 0;
		var pStruct = StructNew();
		var qGateway = 0;

		pStruct.boolean = 0;
		pStruct.string = "george";

		qGateway = getTransfer().listByPropertyMap(className="Basic", propertyMap=pStruct, useAliases=false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select *
		from
		tbl_basic
		where
		basic_string
		=
		'george'
		and
		basic_boolean = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>

	<cfscript>
		assertEqualsBasic(qQuery, qGateway);
	</cfscript>
</cffunction>

<cffunction name="testListByPropertyOrder" hint="" access="public" returntype="void" output="false">
	<cfscript>

		var transfer = getTransfer();
		var qQuery = 0;
		var qGateway = transfer.listByProperty("AutoGenerate", "value", "george", "IDGenerate", true, false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select *
		from
		tbl_generate
		where
		generate_value
		=
		'george'
		order by IDGenerate asc
	</cfquery>

	<cfscript>
		assertEqualsBasic(qQuery, qGateway);
	</cfscript>
</cffunction>

<cffunction name="testListByPropertyEmptyStruct" hint="" access="public" returntype="void" output="false">
	<cfscript>

		var transfer = getTransfer();
		var qQuery = 0;
		var pStruct = StructNew();
		var qGateway = 0;

		qGateway = getTransfer().listByPropertyMap(className="Basic", propertyMap=pStruct, useAliases=false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select *
		from
		tbl_basic
	</cfquery>

	<cfscript>
		assertEqualsBasic(qQuery, qGateway);
	</cfscript>
</cffunction>

<cffunction name="testListByPropertyEmptyStructNull" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var transfer = getTransfer();
		var qQuery = 0;
		var pStruct = StructNew();
		var qGateway = 0;

		pStruct.string = JavaCast("null", "");
		
		qGateway = getTransfer().listByPropertyMap(className="Basic", propertyMap=pStruct, useAliases=false);
	</cfscript>

	<!--- see if the amount is more --->
	<cfquery name="qQuery" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select *
		from
		tbl_basic
	</cfquery>

	<cfscript>
		assertEqualsBasic(qQuery, qGateway);
	</cfscript>
</cffunction>

</cfcomponent>