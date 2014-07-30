<cfcomponent output="false" extends="test.transfer.cases.BaseCase">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="" access="public" returntype="void" output="false">
	<cfscript>
		instance.provider = createObject("component", "transfer.com.cache.provider.EHCacheProvider").init("/test/resources/ehcache.xml");

		instance.provider.setEventManager(createObject("component", "StubEventManager").init());
    </cfscript>

</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="testEHCacheSimpleCRUD" hint="test is ehCache is up and running for me" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.class = getMetadata(this).name;
		local.key = "123";

		local.transferObject = createObject("component", "transfer.com.TransferObject");

		instance.provider.add(local.class, local.key, local.transferObject);

		assertTrue(instance.provider.have(local.class, local.key), "should be in cache (1)");

		local.get = instance.provider.get(local.class, local.key);

		assertSame("should be the same", local.transferObject, local.get);

		instance.provider.discard(local.class, local.key);

		assertFalse(instance.provider.have(local.class, local.key), "should not be in cache");

		local.get = instance.provider.get(local.class, local.key);

		assertFalse(structKeyExists(local, "get"), "should not be gotten from cache");

		instance.provider.add(local.class, local.key, local.transferObject);

		assertTrue(instance.provider.have(local.class, local.key), "should be in cache (2)");

		instance.provider.discardAll();

		assertFalse(instance.provider.have(local.class, local.key), "should not be in cache (discardAll)");
    </cfscript>
</cffunction>

<cffunction name="testEHCacheStatistics" hint="Test to make sure statistics are working" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.class = getMetadata(this).name;
		local.key = "123";

		local.transferObject = createObject("component", "transfer.com.TransferObject");

		local.classes = instance.provider.getCachedClasses();
		AssertEquals("only the default", local.classes[1], "AutoGenerate");
		AssertEquals("len 1", ArrayLen(local.classes),1);

		assertEquals("size should be 0", 0, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("misses should be 0", 0, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		//put something in it, so the cache exists
		instance.provider.add(local.class, local.key & "4321", local.transferObject);

		local.get = instance.provider.get(local.class, local.key);

		AssertFalse(structKeyExists(local, "get"), "this can't be here");

		assertEquals("size should be 1", 1, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("[1] misses should be 1", 1, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		instance.provider.add(local.class, local.key, local.transferObject);

		local.get = instance.provider.get(local.class, local.key);

		assertEquals("size should be 2", 2, instance.provider.getSize(local.class));
		assertEquals("hits should be 1", 1, instance.provider.getHits(local.class));
		assertEquals("[2] misses should be 1", 1, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		instance.provider.discard(local.class, local.key);

		assertEquals("size should be 1", 1, instance.provider.getSize(local.class));
		assertEquals("hits should be 1", 1, instance.provider.getHits(local.class));
		assertEquals("[3] misses should be 1", 1, instance.provider.getMisses(local.class));
		//manual eviction doesn't count
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		instance.provider.resetStatistics();

		assertEquals("size should be 1", 1, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("misses should be 0", 0, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

    </cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>