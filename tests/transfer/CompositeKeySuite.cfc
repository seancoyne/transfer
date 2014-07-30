<cfcomponent name="CollectionsSuite" hint="Collections Suite of tests">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">
		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTestSuite("test.transfer.cases.compositeid.CloneTest");
			testSuite.addTestSuite("test.transfer.cases.compositeid.CompositeIDTest");
			testSuite.addTestSuite("test.transfer.cases.compositeid.ListTest");
			testSuite.addTestSuite("test.transfer.cases.compositeid.ReadTest");
			return testSuite;
		</cfscript>
	</cffunction>

</cfcomponent>