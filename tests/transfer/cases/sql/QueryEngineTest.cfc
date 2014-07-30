<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cfscript>
	variables.loader = createObject("component", "transfer.com.util.JavaLoader").init("test");
</cfscript>

<cffunction name="testQueryCreate" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var ds = getDatasource();
		var pool = createObject("component", "transfer.com.sql.collections.QueryExecutionPool").init(ds, variables.loader);
		var query = createObject("component", "transfer.com.sql.Query").init(pool);

		query.start();

		query.appendSQL("select * from tbl_a");

		query.mapParam("george", "string");

		query.appendSQL("frodo baggings");

		query.start();

		query.appendSQL("hello?");

		query.stop();
	</cfscript>
</cffunction>

<cffunction name="testQueryExecutionCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var ds = getDatasource();
		var queryExec = createObject("component", "transfer.com.sql.QueryExecution").init(ds);

		queryExec.setParam("george", "1234");
	</cfscript>
</cffunction>

<cffunction name="testQueryExecPoolCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var ds = getDatasource();
		var pool = createObject("component", "transfer.com.sql.collections.QueryExecutionPool").init(ds, variables.loader);

		var exec = pool.getQueryExecution(ArrayNew(1));
		var i = 1;

		pool.recycle(exec);

		for(; i lte 20; i = i +1)
		{
			exec = pool.getQueryExecution(ArrayNew(1));
			pool.recycle(exec);
		}
	</cfscript>
</cffunction>

<cffunction name="testQueryExecution" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var ds = getDatasource();
		var pool = createObject("component", "transfer.com.sql.collections.QueryExecutionPool").init(ds, variables.loader);
		var query = createObject("component", "transfer.com.sql.Query").init(pool);
		var exec = 0;
		var q = 0;
		var d = 0;
	</cfscript>
	<cfscript>
		query.start();
		query.appendSQL("select * from tbl_a where a_value =");
		query.mapParam("value", "string");
		query.stop();

		exec = query.createExecution();
		exec.setParam("value", "george");

		q = exec.executeQuery();
	</cfscript>
	<cfquery name="d" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select * from tbl_a where a_value =
		<cfqueryparam value="george" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfscript>
		assertEquals("execution is different",q, d);
	</cfscript>
</cffunction>

<cffunction name="testQueryCache" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var cache = createObject("component", "transfer.com.sql.collections.QueryCache").init();
		var ds = getDatasource();
		var pool = createObject("component", "transfer.com.sql.collections.QueryExecutionPool").init(ds, variables.loader);
		var query = createObject("component", "transfer.com.sql.Query").init(pool);
		var query1 = 0;

		cache.addQuery("fred", query);

		AssertTrue(cache.hasQuery("fred"), "should have fred");
		AssertFalse(cache.hasQuery("george"), "should not have george");

		query1 = cache.getQuery("fred");

		assertSame("should be same query", query, query1);
	</cfscript>
</cffunction>

</cfcomponent>