<cfcomponent name="TQLSuite" hint="Suite for TQL">
	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTestSuite("test.transfer.cases.tql.ListByQueryTest");
			testSuite.addTestSuite("test.transfer.cases.tql.ABCTest");
			testSuite.addTestSuite("test.transfer.cases.tql.ReadByQueryTest");
			testSuite.addTestSuite("test.transfer.cases.tql.CacheEvalTest");
			return testSuite;
		</cfscript>

	</cffunction>

</cfcomponent>