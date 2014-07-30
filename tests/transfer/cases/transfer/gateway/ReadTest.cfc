	<cfcomponent name="ReadTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testReadByProperty" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var number = TimeFormat(Now(), "hhmmssll") & randrange(0,9);

		var transfer = getTransfer();


		</cfscript>

		<!--- make sure it's unique' --->
		<cfquery name="qDel" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
			delete
			from
			tbl_basicuuid
			where
			basic_numeric = <cfqueryparam value="#number#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfscript>
		obj = transfer.new("BasicUUID");

		obj.setNumeric(number);

		transfer.save(obj);

		readobj = transfer.readByProperty("BasicUUID", "numeric", number);

		assertSameBasic(obj, readobj);
	</cfscript>
</cffunction>

<cffunction name="testReadByPropertyStruct" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var number = TimeFormat(Now(), "hhmmssll") & randrange(0,9);

		var transfer = getTransfer();

		var pStruct = StructNew();
		</cfscript>

		<!--- make sure it's unique' --->
		<cfquery name="qDel" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
			delete
			from
			tbl_basicuuid
			where
			basic_numeric = <cfqueryparam value="#number#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfscript>
		obj = transfer.new("BasicUUID");

		obj.setNumeric(number);

		transfer.save(obj);

		pStruct.numeric = number;
		pStruct.IDBasic = obj.getIDBasic();

		readobj = transfer.readByPropertyMap("BasicUUID", pStruct);

		assertSameBasic(obj, readobj);
	</cfscript>
</cffunction>

<cffunction name="testReadByPropertyBooelan" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var transfer = getTransfer();
	</cfscript>

	<!--- make sure it's unique' --->
	<cfquery name="qDel" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		delete
		from
		tbl_basic
		where
		basic_boolean = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
	</cfquery>

	<cfscript>
		obj = transfer.new("Basic");

		obj.setBoolean(true);

		transfer.save(obj);

		readobj = transfer.readByProperty("Basic", "boolean", true);

		assertSameBasic(obj, readobj);
	</cfscript>
</cffunction>

<cffunction name="testMultipleReadByPropertyFail" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var transfer = getTransfer();
		var obj = 0;
		var check = false;

		var a = transfer.new("BasicUUID");

		a.setString("george");

		transfer.save(a);

		a = transfer.new("BasicUUID");
		a.setString("george");

		transfer.save(a);

		try
		{
			obj = transfer.readByProperty("BasicUUID", "string", "george");
		}
		catch(transfer.com.exception.MultipleRecordsFoundException exc)
		{
			check = true;
		}

		assertTrue(check, "Exception not thrown");
	</cfscript>
</cffunction>

<cffunction name="testZeroReadByPropertyFail" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var transfer = getTransfer();
		var obj = 0;
		var check = false;

		obj = transfer.readByProperty("BasicUUID", "UUID", 5);

		//assertEqualsBasic(obj.getIDBasic(), "00000000-0000-0000-0000000000000000");
		assertFalse(obj.getIsPersisted());
	</cfscript>
</cffunction>

</cfcomponent>