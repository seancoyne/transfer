<cfcomponent name="SQLSuite" hint="Suite for SQL engine">
	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTestSuite("test.transfer.cases.sql.QueryEngineTest");
			return testSuite;
		</cfscript>

	</cffunction>

</cfcomponent>