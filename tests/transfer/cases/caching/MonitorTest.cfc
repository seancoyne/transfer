<cfcomponent name="MonitorGenerateTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testCachedClasses" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var manytone = getTransfer().new("manytoone.SimpleUUID");
		var monitor = getTransfer().getCacheMonitor();
		var none = getTransfer().new("none.Basic");
		var classes = 0;

		getTransfer().save(basic);
		getTransfer().save(manytone);
		getTransfer().save(getTransfer().new("AutoGenerate"));
		getTransfer().save(none);

		none = getTransfer().get("none.Basic", none.getIDBasic());

		classes = monitor.getCachedClasses();

		AssertTrue(classes.contains("Basic"), "should have 'Basic'");
		AssertTrue(classes.contains("manytoone.SimpleUUID"), "should have 'manytoone.SimpleUUID'");
		AssertTrue(classes.contains("AutoGenerate"), "should have 'AutoGenerate'");
		AssertFalse(classes.contains("none.Basic"), "should not have 'none.Basic'");
	</cfscript>
</cffunction>

<cffunction name="testSize" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = 0;
		var manytone = 0;
		var i = 1;
		var monitor = getTransfer().getCacheMonitor();

		getTransfer().discardAll();

		for(; i lte 5; i = i + 1)
		{
			basic = getTransfer().new("Basic");
			getTransfer().save(basic);

			manytone = getTransfer().new("manytoone.SimpleUUID");
			getTransfer().save(manytone);
		}

		AssertTrue(monitor.getSize("Basic") gt 1, "basic, should be > 1");

		AssertTrue(monitor.getTotalSize() gt 5, "total, should be > 5");

		getTransfer().discardAll();

		//do this as cfthread could have started, or not
		AssertTrue((monitor.getTotalSize() eq 10 OR monitor.getTotalSize() eq 0), "could be 10, or 0 after discard all");
	</cfscript>
</cffunction>

<cffunction name="testCalculatedSize" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = 0;
		var manytone = 0;
		var i = 1;
		var monitor = getTransfer().getCacheMonitor();

		getTransfer().discardAll();

		for(; i lte 5; i = i + 1)
		{
			basic = getTransfer().new("Basic");
			getTransfer().save(basic);

			manytone = getTransfer().new("manytoone.SimpleUUID");
			getTransfer().save(manytone);
		}

		AssertEquals("basic, should be 5", 5, monitor.getSize("Basic"));

		AssertEquals("total, should be 10", 10, monitor.getTotalSize());

		getTransfer().discardAll();

		AssertEquals("discard all, should be 0", 0, monitor.getTotalSize());
	</cfscript>
</cffunction>

<cffunction name="testHitMiss" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var monitor = getTransfer().getCacheMonitor();
		var simple = getTransfer().new("onetomany.Basic");
		var child = 0;
		var reget = 0;
		var counter =1 ;

		monitor.resetStatistics();

		AssertEquals("should be no hits, just after reset (0)", 0, monitor.getHits("onetomany.Basic"));

		getTransfer().save(simple);

		AssertEquals("should be no hits, just after reset (1)", 0, monitor.getHits("onetomany.Basic"));

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("onetomany.Child");
			child.setName(RandRange(1, 9999));

			child.setParentBasic(simple);
		}

		AssertEquals("should be no hits, just after reset (2)", 0, monitor.getHits("onetomany.Basic"));

		getTransfer().cascadeSave(simple);

		AssertTrue(monitor.getHits("onetomany.Basic") gt 5, "Hits from save cache sync");
		AssertEquals("should be no hits (2)", 0, monitor.getHits("onetomany.Child"));
		AssertEquals("should be no misses (1)", 0, monitor.getMisses('onetomany.Basic'));
		AssertEquals("should be no misses (2)", 0, monitor.getMisses('onetomany.Child'));

		AssertEquals("ratio, for Basic, 1", 1, monitor.getHitMissRatio("onetomany.Basic"));
		AssertEquals("ratio, for total, 1", 1, monitor.getTotalHitMissRatio());

		getTransfer().discardAll();

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		AssertTrue(monitor.getMisses("onetomany.Basic") lt 5, "should be < 5 misses [1]");
		AssertTrue(monitor.getMisses("onetomany.Child") lt 20, "should be < 20 misses [2]: #monitor.getMisses("onetomany.Child")#");
		AssertEquals("should be 10 hits (3)", 10, monitor.getHits("onetomany.Basic"));
		AssertEquals("should be no hits (4)", 0, monitor.getHits("onetomany.Child"));

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		AssertTrue(monitor.getHits("onetomany.Basic") gt 5, "Hits from save cache sync (2)");
		AssertEquals("should be no hits (5)", 0, monitor.getHits("onetomany.Child"));

		getTransfer().discard(reget);

		sleep(5000);

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		AssertTrue(monitor.getMisses("onetomany.Basic") lt 5, "should be < 5 misses");
		AssertTrue(monitor.getHits("onetomany.Child") gt 5, "should be > 5");

		AssertTrue(monitor.getTotalMisses() gte 0, "should be gte 0");
		AssertTrue(monitor.getTotalHits() gte 6, "should be gte > 6 hits, total");

		AssertTrue(monitor.getHitMissRatio("onetomany.Basic") gt 0, "ratio, for Basic > gt 0");
		AssertTrue(monitor.getTotalHitMissRatio() gt 0, "ratio, for total gte 1");
	</cfscript>
</cffunction>

<cffunction name="testEvictions" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var monitor = getTransfer().getCacheMonitor();
		var simple = getTransfer().new("onetomany.Basic");
		var child = 0;
		var reget = 0;
		var counter = 1;

		getTransfer().discardAll();

		monitor.resetStatistics();

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("onetomany.Child");
			child.setName(RandRange(1, 9999));

			child.setParentBasic(simple);
		}

		getTransfer().cascadeSave(simple);

		AssertEquals("evictions: 0, Parent", 0, monitor.getEvictions("onetoMany.Basic"));
		AssertEquals("evictions: 0, child", 0, monitor.getEvictions("onetoMany.Child"));

		AssertEquals("total evictions: 0", 0, monitor.getTotalEvictions());

		getTransfer().discard(simple);

		AssertEquals("evictions: 0, Parent", 0, monitor.getEvictions("onetoMany.Basic"));
		AssertEquals("evictions: 0, child (2)", 0, monitor.getEvictions("onetoMany.Child"));

		AssertEquals("total evictions: 0", 0, monitor.getTotalEvictions());
	</cfscript>
</cffunction>

<cffunction name="testGetNativeCacheImplementation" hint="" access="public" returntype="any" output="false">
	<cfscript>
		var monitor = getTransfer().getCacheMonitor();

		var defaultCache = monitor.getDefaultCache();
		var classCache = monitor.getCache("none.Basic");

		AssertEquals("Should be the EHCacheManager", defaultCache.getClass().getName(), "net.sf.ehcache.CacheManager");

		AssertEquals("No cache", getMetadata(classCache).name, "transfer.com.cache.provider.NoCacheProvider");
    </cfscript>
</cffunction>

</cfcomponent>