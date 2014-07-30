<cfcomponent name="CollectionsSuite" hint="Collections Suite of tests">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();

			testSuite.addTestSuite("test.transfer.cases.transfer.ManyToManyTestUUID");
			testSuite.addTestSuite("test.transfer.cases.transfer.OneToManyTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.BigStuffTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.CRUDTestNumeric");
			testSuite.addTestSuite("test.transfer.cases.transfer.CRUDTestUUID");
			testSuite.addTestSuite("test.transfer.cases.transfer.CRUDTestGUID");
			testSuite.addTestSuite("test.transfer.cases.transfer.ManyToOneTestUUID");
			testSuite.addTestSuite("test.transfer.cases.transfer.OneToManyDefaultTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.AutoGenerateTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.SaveTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.UDFTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.RecycleTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.SetPrimaryKeyTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.TransactionTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.CompositeTest");
			testSuite.addTestSuite("test.transfer.cases.transfer.MetaDataTest");

			return testSuite;
		</cfscript>

	</cffunction>

</cfcomponent>