<cfcomponent name="LazySuite" hint="Suite for lazy loading">
	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTestSuite("test.transfer.cases.lazy.TreeTest");
			testSuite.addTestSuite("test.transfer.cases.lazy.OneToManyTest");
			testSuite.addTestSuite("test.transfer.cases.lazy.ManyToManyTestUUID");
			return testSuite;
		</cfscript>

	</cffunction>

</cfcomponent>