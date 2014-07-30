<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testCacheEvaluation" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var cache = createObject("component", "transfer.com.tql.collections.EvaluationCache").init();
		var query = createObject("component", "transfer.com.tql.Query").init("Hello There!");
		var eval = ArrayNew(1);
		var reget = 0;
		var query2 = createObject("component", "transfer.com.tql.Query").init("Hello There!");

		eval[1] = createUUID();

		cache.add(query, eval);

		AssertTrue(cache.has(query), "should have this eval");

		reget = cache.get(query);
		AssertEquals("should be the same", eval[1], reget[1]);

		query.setDistinctMode(true);

		AssertFalse(cache.has(query), "should not have this eval");

		AssertTrue(cache.has(query2), "should have this 2nd eval");
	</cfscript>
</cffunction>

</cfcomponent>