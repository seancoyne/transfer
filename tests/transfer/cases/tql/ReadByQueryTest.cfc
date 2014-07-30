<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testABToCManyToOne" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//setup the data
		var a = getTransferC().new("abcmanytoone.A");
		var a2 = 0;
		var uuid = createUUID();

		a.setStringValue(uuid);
		getTransferC().save(a);

		//do it twice to ensure mutliple data records
		uuid = createUUID();
		a = getTransferC().new("abcmanytoone.A");
		a.setStringValue(uuid);
		getTransferC().save(a);

		query = getTransferC().createQuery("select a.id from abcmanytoone.A as a where a.stringValue = :uuid");
		query.setParam("uuid", uuid);

		a2 = getTransferC().readByQuery("abcmanytoone.A", query);

		assertSame("read with select", a, a2);

		query = getTransferC().createQuery("from abcmanytoone.A as a where a.stringValue = :uuid");
		query.setParam("uuid", uuid);

		a2 = getTransferC().readByQuery("abcmanytoone.A", query);
		assertSame("read with from", a, a2);
	</cfscript>
</cffunction>

<cffunction name="tearDown" hint="" access="public" returntype="string" output="false">
	<cfset var tables = "a,b,c" />
	<cfloop list="#tables#" index="table">
	<cfquery name="qTable" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			Delete from tbl_#LCase(table)#
	</cfquery>
	</cfloop>
</cffunction>

</cfcomponent>