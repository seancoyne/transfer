<cfcomponent name="NullSuite" hint="Null Suite of tests">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTestSuite("test.transfer.cases.null.NullTest");
			return testSuite;
		</cfscript>

	</cffunction>

</cfcomponent>