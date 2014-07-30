<cfcomponent name="CollectionsSuite" hint="Collections Suite of tests">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();

			if(Server.ColdFusion.ProductVersion.startsWith("8") OR Server.ColdFusion.ProductVersion.startsWith("9"))
			{
				println("Running Proxy Tests...");
				testSuite.addTestSuite("test.transfer.cases.proxy.ProxyTest");
			}

			return testSuite;
		</cfscript>

	</cffunction>

	<cffunction name="println" hint="" access="private" returntype="void" output="false">
		<cfargument name="str" hint="" type="string" required="Yes">
		<cfscript>
			createObject("Java", "java.lang.System").out.println(arguments.str);
		</cfscript>
	</cffunction>

</cfcomponent>