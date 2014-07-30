<cfcomponent name="RefreshSuite" hint="Refresh Suite of tests">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTestSuite("test.transfer.cases.refresh.RefreshTest");
			return testSuite;
		</cfscript>

	</cffunction>

</cfcomponent>