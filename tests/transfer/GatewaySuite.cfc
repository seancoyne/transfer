<cfcomponent name="CollectionsSuite" hint="Collections Suite of tests"> 

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">
			
		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTestSuite("test.transfer.cases.transfer.gateway.GatewayTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.gateway.ReadTest");
			
			return testSuite;
		</cfscript>
		
	</cffunction>

</cfcomponent>