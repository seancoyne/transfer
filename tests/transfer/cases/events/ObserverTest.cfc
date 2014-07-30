<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testRemoveRegularObserver" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var collection = createObject("component", "transfer.com.events.collections.AfterCreateObserverCollection").init();
		var observer = createObject("component", "EventObserver").init();
		var event = createObject("component", "transfer.com.events.TransferEvent").init();

		collection.addObserver(observer);

		assertEquals("should be 0", 0, observer.getEventCount());

		collection.fireEvent(event);

		assertEquals("should be 1", 1, observer.getEventCount());

		collection.fireEvent(event);

		assertEquals("should be 2", 2, observer.getEventCount());

		collection.removeObserver(observer);

		collection.fireEvent(event);

		assertEquals("should be 2", 2, observer.getEventCount());
	</cfscript>
</cffunction>

<cffunction name="testRemoveTransferObserver" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var observer = createObject("component", "EventObserver").init();
		var basic = getTransfer().new("Basic");

		getTransfer().addAfterCreateObserver(observer);

		assertEquals("should be 0", 0, observer.getEventCount());

		getTransfer().save(basic);

		assertEquals("should be 1", 1, observer.getEventCount());

		basic = getTransfer().new("Basic");
		getTransfer().save(basic);

		assertEquals("should be 2", 2, observer.getEventCount());

		getTransfer().removeAfterCreateObserver(observer);

		basic = getTransfer().new("Basic");
		getTransfer().save(basic);

		assertEquals("should be 2", 2, observer.getEventCount());
	</cfscript>
</cffunction>

<cffunction name="testRemoveSoftRefObserver" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var collection = createObject("component", "transfer.com.events.collections.AfterCreateObserverCollection").init();
		var observer = createObject("component", "TOEventObserver").init();
		var event = createObject("component", "transfer.com.events.TransferEvent").init();

		collection.addObserver(observer);

		assertEquals("should be 0", 0, observer.getEventCount());

		collection.fireEvent(event);

		assertEquals("should be 1", 1, observer.getEventCount());

		collection.fireEvent(event);

		assertEquals("should be 2", 2, observer.getEventCount());

		collection.removeObserver(observer);

		collection.fireEvent(event);

		assertEquals("should be 2", 2, observer.getEventCount());
	</cfscript>
</cffunction>

<cffunction name="testTransferObjectObserver" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child =  getTransfer().new("manytoone.ChildUUID");
		var simple2 = 0;
		var thread = createObject("java", "java.lang.Thread").currentThread();

		getTransfer().create(child);
		simple.setChild(child);

		println("*** saving child");

		getTransfer().cascadeSave(simple);

		println("*** discard child");

		getTransfer().discard(child);

		println("*** discard simple");

		getTransfer().discard(simple);

		//println("*** waiting 5 seconds");

		//thread.threadSleep(5000);

		println("*** get child");

		child = simple.getChild();

		println("*** discard child");

		getTransfer().discard(child);
	</cfscript>
</cffunction>

</cfcomponent>