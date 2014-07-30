<cfcomponent name="CachingSuite" hint="Suite for caching">

	<cffunction name="suite" returntype="net.sourceforge.cfunit.framework.TestSuite" access="public" output="false" hint="">

		<cfscript>
			testSuite = createObject("component", "net.sourceforge.cfunit.framework.TestSuite").init();

			testSuite.addTestSuite("test.transfer.cases.caching.EHCacheProviderTest");
			testSuite.addTestSuite("test.transfer.cases.caching.NoCacheProviderTest");
			testSuite.addTestSuite("test.transfer.cases.caching.CachingTest");
			testSuite.addTestSuite("test.transfer.cases.caching.MonitorTest");

			return testSuite;
		</cfscript>

	</cffunction>

</cfcomponent>