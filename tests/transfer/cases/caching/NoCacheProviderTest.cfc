<cfcomponent output="false" extends="test.transfer.cases.BaseCase">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="" access="public" returntype="void" output="false">
	<cfscript>
		instance.provider = createObject("component", "transfer.com.cache.provider.NoCacheProvider").init();

		instance.provider.setEventManager(createObject("component", "StubEventManager").init());
    </cfscript>

</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="testSimpleCRUD" hint="test is ehCache is up and running for me" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.class = getMetadata(this).name;
		local.key = "123";

		local.transferObject = createObject("component", "transfer.com.TransferObject");

		instance.provider.add(local.class, local.key, local.transferObject);

		assertFalse(instance.provider.have(local.class, local.key), "should be in cache (1)");

		instance.provider.discard(local.class, local.key);

		assertFalse(instance.provider.have(local.class, local.key), "should not be in cache");

		local.get = instance.provider.get(local.class, local.key);

		assertFalse(structKeyExists(local, "get"), "should not be gotten from cache");

		instance.provider.add(local.class, local.key, local.transferObject);

		assertFalse(instance.provider.have(local.class, local.key), "should be in cache (2)");

		instance.provider.discardAll();

		assertFalse(instance.provider.have(local.class, local.key), "should not be in cache (discardAll)");
    </cfscript>
</cffunction>

<cffunction name="testStatistics" hint="Test to make sure statistics are working" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.class = getMetadata(this).name;
		local.key = "123";

		local.transferObject = createObject("component", "transfer.com.TransferObject");

		local.classes = instance.provider.getCachedClasses();
		AssertEquals("only the default", local.classes, ArrayNew(1));
		AssertEquals("len 0", ArrayLen(local.classes),0);

		assertEquals("size should be 0", 0, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("misses should be 0", 0, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		//put something in it, so the cache exists
		instance.provider.add(local.class, local.key & "4321", local.transferObject);

		local.get = instance.provider.get(local.class, local.key);

		AssertFalse(structKeyExists(local, "get"), "this can't be here");

		assertEquals("size should be 0", 0, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("[1] misses should be 0", 0, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		instance.provider.add(local.class, local.key, local.transferObject);

		local.get = instance.provider.get(local.class, local.key);

		assertEquals("size should be 0", 0, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("[2] misses should be 0", 0, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		instance.provider.discard(local.class, local.key);

		assertEquals("size should be 0", 0, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("[3] misses should be 0", 0, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

		instance.provider.resetStatistics();

		assertEquals("size should be 0", 0, instance.provider.getSize(local.class));
		assertEquals("hits should be 0", 0, instance.provider.getHits(local.class));
		assertEquals("misses should be 0", 0, instance.provider.getMisses(local.class));
		assertEquals("evictions should be 0", 0, instance.provider.getEvictions(local.class));

    </cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>