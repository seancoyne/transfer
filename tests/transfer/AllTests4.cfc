<cfcomponent name="AllTests" output="false" hint="Runs all unit tests in package.">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			var testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();

			testSuite.addTest(createObject("component", "test.transfer.PropSuite").suite());
			testSuite.addTest(createObject("component", "test.transfer.LazySuite").suite());
			testSuite.addTest(createObject("component", "test.transfer.TQLSuite").suite());
			testSuite.addTest(createObject("component", "test.transfer.CompositeKeySuite").suite());
			testSuite.addTest(createObject("component", "test.transfer.SQLSuite").suite());
			testSuite.addTest(createObject("component", "test.transfer.TransactionSuite").suite());
			testSuite.addTest(createObject("component", "test.transfer.ProxySuite").suite());

			return testsuite;
		</cfscript>

	</cffunction>

</cfcomponent>
