<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testAddNewEventObserver" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var obs = createObject("component", "EventObserver").init();
		var new = 0;

		getTransferC().addAfterNewObserver(obs);

		new = getTransferC().new("BasicUUID");

		assertEquals("c:Before", 1 ,obs.getEventCount());

		getTransferC().removeAfterNewObserver(obs);

		new = getTransferC().new("BasicUUID");

		assertEquals("c:after", 1 ,obs.getEventCount());

		//do the same for decorators

		getTransferB().addAfterNewObserver(obs);

		new = getTransferB().new("BasicUUID");

		assertEquals("b:Before", 2 ,obs.getEventCount());

		getTransferB().removeAfterNewObserver(obs);

		new = getTransferB().new("BasicUUID");

		assertEquals("b:after", 2 ,obs.getEventCount());
	</cfscript>
</cffunction>

<cffunction name="testInjection" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var obs = createObject("component", "InjectObserver").init();
		var new = 0;
		var clone = 0;

		getTransferB().addAfterNewObserver(obs);

		new = getTransferB().new("BasicUUID");

		assertTrue(isObject(new.getObject()), "new");

		getTransferB().save(new);

		assertTrue(isObject(new.getObject()), "saved");

		getTransferB().discard(new);

		getTransferB().get("BasicUUID", new.getIDBasic());

		assertTrue(isObject(new.getObject()), "get");

		clone = new.clone();

		assertTrue(isObject(new.getObject()), "clone");

		getTransferB().removeAfterNewObserver(obs);
	</cfscript>
</cffunction>

</cfcomponent>