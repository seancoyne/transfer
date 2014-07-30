<cfcomponent name="AllTests" output="false" hint="Runs all unit tests in package.">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			var testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();
			testSuite.addTest(createObject("component", "test.transfer.TransferSuite").suite());
			testSuite.addTest(createObject("component", "test.transfer.ObjectSuite").suite());

			return testsuite;
		</cfscript>
	</cffunction>

</cfcomponent>
