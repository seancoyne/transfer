<cfcomponent name="QueryCacheTest" extends="test.transfer.cases.BaseCase">

<cffunction name="setUp" hint="" access="public" returntype="void" output="false">
	<cfscript>
		variables.queryCache = createObject("component", "transfer.com.collections.QueryCache").init();
		
		variables.query = QueryNew("IDTest,Test");
		QueryAddRow(variables.query);
		querySetCell(variables.query, "IDTest", RandRange(1,100));
		querySetCell(variables.query, "Test", "George");
		QueryAddRow(variables.query);
		querySetCell(variables.query, "IDTest", RandRange(1,100));
		querySetCell(variables.query, "Test", "Fred");
		QueryAddRow(variables.query);
		querySetCell(variables.query, "IDTest", RandRange(1,100));
		querySetCell(variables.query, "Test", "Mandy");		

		
		variables.queryCache.cacheQuery(variables.query, "key");
	</cfscript>
</cffunction>

<cffunction name="testCheck" hint="" access="public" returntype="void" output="false">
	<cfscript>
		assertTrueBasic(variables.queryCache.checkQuery("key"));
	</cfscript>
</cffunction>

<cffunction name="testGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		assertEqualsBasic(variables.query, variables.queryCache.getQuery("key"));
	</cfscript>
</cffunction>

<cffunction name="testRemove" hint="" access="public" returntype="void" output="false">
	<cfscript>
		variables.queryCache.removeQuery("key");
		
		assertFalseBasic(variables.queryCache.checkQuery("key"));
	</cfscript>
</cffunction>

<cffunction name="testExpired" hint="" access="public" returntype="void" output="false">
	<cfscript>
		variables.queryCache.cacheQuery(variables.query, "key", DateAdd("h", -10, Now()));
		
		assertFalseBasic(variables.queryCache.checkQuery("key"));
	</cfscript>
</cffunction>

</cfcomponent>