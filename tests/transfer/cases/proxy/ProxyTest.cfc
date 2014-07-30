<cfcomponent name="CRUDTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testManyToOneProxy" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var a = getTransferE().new("proxy.A");
		var b = getTransferE().new("proxy.B");

		b.setStringValue("Yoda");

		a.setB(b);

		getTransferE().cascadeSave(a);

		getTransferE().discardAll();

		a = getTransferE().get("proxy.A", a.getID());

		AssertFalse(a.getB().getIsLoaded(), "should not be loaded (1)");

		AssertTrue(a.getB().getIsPersisted(), "should be persisted");

		AssertFalse(a.getB().getIsLoaded(), "should not be loaded (2)");

		AssertFalse(a.getB().hasParentC(), "should not have a parent");

		AssertTrue(a.getB().getIsLoaded(), "should be loaded (1)");

		AssertTrue(a.getB().getIsPersisted(), "should be persisted (after load)");

		AssertEquals("Should be yoda", "Yoda", a.getB().getStringValue());

		AssertSame("should be the same object", getTransferE().get("proxy.B", a.getB().getID()), a.getB());

		AssertSame("should be the same object", a.getB(), a.getB());
	</cfscript>
</cffunction>

<cffunction name="testOneToManyProxy" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var c = getTransferE().new("proxy.C");
		var b = 0;
		var i = 1;
		var id = 0;
		var string = 0;
		var local = StructNew();

		for(; i lte 5; i = i + 1)
		{
			b = getTransferE().new("proxy.B");
			b.setStringValue(i & "fooBar!");
			b.setParentC(c);
		}

		c.sortB();

		getTransferE().cascadeSave(c);

		id = c.getB(1).getID();
		string = c.getB(5).getStringValue();

		local.old = c;

		getTransferE().discardAll();

		c = getTransferE().get("proxy.C", c.getID());

		AssertNotSame("should be different", local.old, c);

		AssertEquals("should be 5 children", 5, ArrayLen(c.getBArray()));

		for(i = 1; i lte 5; i = i + 1)
		{
			AssertFalse(c.getB(i).getIsLoaded(), "should not be loaded - (#i#)");
			AssertNotSame("should be different: #i#", local.old.getB(i), c.getB(i));
		}

		AssertEquals("id should be the same", c.getB(1).getId(), id);

		AssertFalse(c.getB(1).getIsLoaded(), "should not be loaded [1]");

		AssertEquals("string should be the same", string, c.getB(5).getStringValue());

		AssertFalse(c.getB(1).getIsLoaded(), "should not be loaded [2]");

		AssertFalse(c.getB(5).getParentCIsLoaded(), "should not be loaded at this time");

		AssertTrue(c.getB(5).getIsLoaded(), "should be loaded [1]");

		AssertTrue(c.getB(5).getIsPersisted(), "should be persisted");

		AssertSame("Parent should be equals", c, c.getB(4).getParentC());

		c.getB(4).setStringValue("WAGGA!");

		getTransferE().save(c.getB(4));

		//doing getProxied testing

		AssertFalse(c.getB(2).getIsLoaded(), "should not be loaded [3]");
		AssertFalse(c.getB(2).getLoadedObject().getIsProxy(), "should not be a proxy");
		AssertSame("same getLoadedObject", c.getB(2).getLoadedObject().getLoadedObject(), c.getB(2).getLoadedObject());
		AssertTrue(c.getB(2).getIsLoaded(), "should  be loaded [2]");
	</cfscript>
</cffunction>

<cffunction name="testOneToManyProxyStruct" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var c = getTransferE().new("proxy.sC");
		var b = 0;
		var i = 1;
		var id = 0;
		var string = 0;

		for(; i lte 5; i = i + 1)
		{
			b = getTransferE().new("proxy.sB");
			b.setStringValue(i & "fooBar!");
			b.setParentSC(c);
		}

		getTransferE().cascadeSave(c);

		id = c.getB("1fooBar!").getID();
		string = c.getB("5fooBar!").getStringValue();

		getTransferE().discardAll();

		c = getTransferE().get("proxy.sC", c.getID());

		for(i = 1; i lte 5; i = i + 1)
		{
			AssertFalse(c.getB(i & "fooBar!").getIsLoaded(), "should not be loaded - (#i#)");
		}

		AssertEquals("should be 5 children", 5, StructCount(c.getBStruct()));

		AssertEquals("id should be the same", c.getB("1fooBar!").getId(), id);

		AssertFalse(c.getB("5fooBar!").getIsLoaded(), "should not be loaded [1]");

		AssertEquals("string should be the same", string, c.getB("5fooBar!").getStringValue());

		AssertFalse(c.getB("5fooBar!").getIsLoaded(), "should not be loaded [2]");

		AssertFalse(c.getB("5fooBar!").getParentSCIsLoaded(), "should not be loaded at this time");

		AssertTrue(c.getB("5fooBar!").getIsLoaded(), "should be loaded [1]");

		AssertTrue(c.getB("5fooBar!").getIsPersisted(), "should be persisted");

		AssertSame("Parent should be equals", c, c.getB("4fooBar!").getParentSC());

		c.getB("4fooBar!").setStringValue("WAGGA!");

		getTransferE().save(c.getB("4fooBar!"));
	</cfscript>
</cffunction>

<cffunction name="_testOneToManyProxyStructIDKey" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var c = getTransferE().new("pk.xC");
		var b = 0;
		var i = 1;
		var id = 0;
		var string = 0;
		var uuid = createUUID();

		for(; i lte 5; i = i + 1)
		{
			b = getTransferE().new("pk.xB");
			uuid = createUUID();
			b.setID(uuid);
			b.setStringValue("foo" & i);
			b.setParentXC(c);
		}

		getTransferE().cascadeSave(c);

		id = c.getB(uuid).getID();
		string = c.getB(uuid).getStringValue();

		getTransferE().discardAll();

		c = getTransferE().get("pk.xC", c.getID());

		for(key in c.getBStruct())
		{
			AssertFalse(c.getB(key).getIsLoaded(), "should not be loaded - (#key#)");
		}

		AssertEquals("should be 5 children", 5, StructCount(c.getBStruct()));

		AssertEquals("id should be the same", c.getB(uuid).getId(), id);

		AssertFalse(c.getB(uuid).getIsLoaded(), "should not be loaded [1]");

		AssertEquals("string should be the same", uuid, c.getB(uuid).getID());

		AssertFalse(c.getB(uuid).getIsLoaded(), "should not be loaded [2]");

		AssertFalse(c.getB(uuid).getParentXCIsLoaded(), "should not be loaded at this time");

		AssertTrue(c.getB(uuid).getIsLoaded(), "should be loaded [1]");

		AssertTrue(c.getB(uuid).getIsPersisted(), "should be persisted");

		AssertSame("Parent should be equals", c, c.getB(uuid).getParentXC());

		c.getB(uuid).setStringValue("WAGGA!");

		getTransferE().save(c.getB(uuid));
	</cfscript>
</cffunction>

<cffunction name="_testManyToManyProxyArray" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var a = getTransferE().new("proxy.A2");
		var b = 0;
		var i = 1;
		var id = 0;
		var string = 0;

		for(; i lte 5; i = i + 1)
		{
			b = getTransferE().new("proxy.B2");
			b.setStringValue(RandRange(0, 10000) & "foo");
			b.setNumber(4);
			a.addB(b);
		}

		a.sortB();

		getTransferE().cascadeSave(a);

		id = a.getB(1).getID();
		string = a.getB(5).getStringValue();

		getTransferE().discardAll();

		a = getTransferE().get("proxy.A2", a.getID());

		AssertEquals("should be 5", 5, ArrayLen(a.getBArray()));

		for(i = 1; i lte 5; i = i + 1)
		{
			AssertFalse(a.getB(i).getIsLoaded(), "should not be loaded - (#i#)");
		}

		AssertEquals("id should be the same", a.getB(1).getId(), id);

		AssertFalse(a.getB(1).getIsLoaded(), "should not be loaded [1]");

		AssertEquals("string should be the same", string, a.getB(5).getStringValue());

		AssertFalse(a.getB(1).getIsLoaded(), "should not be loaded [2]");

		AssertEquals("should be 4", 4, a.getB(5).getNumber());

		AssertTrue(a.getB(5).getIsLoaded(), "should be loaded [1]");

		AssertTrue(a.getB(5).getIsPersisted(), "should be persisted");

		a.getB(3).setStringValue("WAGGA!");

		AssertTrue(a.getB(3).getIsLoaded(), "should be loaded [2]");

		getTransferE().save(a.getB(3));
	</cfscript>
</cffunction>

<cffunction name="_testManyToManyProxyArrayDecorator" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var a = getTransferE().new("proxy.A3");
		var b = 0;
		var i = 1;
		var id = 0;
		var string = 0;

		for(; i lte 5; i = i + 1)
		{
			b = getTransferE().new("proxy.B3");
			b.setStringValue(RandRange(0, 10000) & "foo");
			b.setNumber(4);
			a.addB(b);
		}

		a.sortB();

		getTransferE().cascadeSave(a);

		id = a.getB(1).getID();
		string = a.getB(5).getStringValue();

		getTransferE().discardAll();

		a = getTransferE().get("proxy.A3", a.getID());

		AssertEquals("should be 5", 5, ArrayLen(a.getBArray()));

		for(i = 1; i lte 5; i = i + 1)
		{
			AssertFalse(a.getB(i).getIsLoaded(), "should not be loaded - (#i#)");
		}

		AssertEquals("id should be the same", a.getB(1).getId(), id);

		AssertFalse(a.getB(1).getIsLoaded(), "should not be loaded [1]");

		AssertEquals("string should be the same", string, a.getB(5).getStringValue());

		AssertFalse(a.getB(1).getIsLoaded(), "should not be loaded [2]");

		AssertEquals("should be 4", 4, a.getB(5).getNumber());

		AssertTrue(a.getB(5).getIsLoaded(), "should be loaded [1]");

		AssertTrue(a.getB(5).getIsPersisted(), "should be persisted");

		a.getB(3).setStringValue("WAGGA!");

		AssertTrue(a.getB(3).getIsLoaded(), "should be loaded [2]");

		getTransferE().save(a.getB(3));
	</cfscript>
</cffunction>

<cffunction name="_testManyToOneCompositeProxy" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var a = getTransferE().new("proxyComposite.A");
		var b = getTransferE().new("proxyComposite.B");
		var key = StructNew();

		b.setStringValue("Yoda");

		a.setB(b);

		getTransferE().cascadeSave(a);

		getTransferE().discardAll();

		key.id = a.getID();
		key.b = a.getB().getId();

		a = getTransferE().get("proxyComposite.A", key);

		AssertTrue(a.getIsPersisted(), "should be persisted (1)");

		AssertFalse(a.getB().getIsLoaded(), "should not be loaded (1)");

		AssertTrue(a.getB().getIsPersisted(), "should be persisted (2)");

		AssertFalse(a.getB().getIsLoaded(), "should not be loaded (2)");

		AssertEquals("Should be yoda", "Yoda", a.getB().getStringValue());

		AssertTrue(a.getB().getIsLoaded(), "should be loaded (1)");

		AssertTrue(a.getB().getIsPersisted(), "should be persisted (after load)");

		AssertSame("should be the same object (1)", getTransferE().get("proxyComposite.B", a.getB().getID()), a.getB());

		AssertSame("should be the same object (2)", a.getB(), a.getB());
	</cfscript>
</cffunction>

<cffunction name="_testMesserLazyProxy" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var transfer = getTransferE();
		var reget = 0;

		p = transfer.new('messer.Person');
		p.setStringValue('Messer');

		a = transfer.new('messer.Address');
		pa = transfer.new('messer.PersonsAddress');

		pa.setAddress(a);
		pa.setParentPerson(p);
		transfer.cascadeSave(p);

		transfer.discardAll();

		reget = transfer.get("messer.Person", p.getID());

		AssertTrue(p.getIsPersisted(), "should be persisted");

		AssertEquals("should be 1", 1, ArrayLen(reget.getAddressesArray()));

		AssertTrue(reget.getAddresses(1).hasAddress(), "should have address");
	</cfscript>
</cffunction>

<cffunction name="_testMesserNonLazyProxy" hint="" access="public" returntype="void" output="false">
    <cfscript>
        var transfer = getTransferE();
        var reget = 0;

        p = transfer.new('messer.PersonNonLazy');
        p.setStringValue('Messer');

        a = transfer.new('messer.Address');
        pa = transfer.new('messer.PersonsNonLazyProxiedAddress');

        pa.setAddress(a);
        pa.setParentPersonNonLazy(p);
        transfer.cascadeSave(p);

        transfer.discardAll();

        reget = transfer.get("messer.PersonNonLazy", p.getID());

        AssertTrue(p.getIsPersisted(), "should be persisted");

        AssertEquals("should be 1", 1, ArrayLen(reget.getNonLazyProxiedAddressesArray()));

        AssertTrue(reget.getNonLazyProxiedAddresses(1).hasAddress(), "should have address");
    </cfscript>
</cffunction>

<cffunction name="_testCloneManyToOne" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var a = getTransferE().new("proxy.A");
		var b = getTransferE().new("proxy.B");
		var clone = 0;

		b.setStringValue("Yoda");

		a.setB(b);

		getTransferE().cascadeSave(a);

		getTransferE().discardAll();

		a = getTransferE().get("proxy.A", a.getID());

		AssertTrue(a.getB().getIsProxy(), "should be a proxy (0)");
		AssertFalse(a.getB().getIsLoaded(), "should not be loaded (0)");

		clone = a.clone();

		AssertTrue(clone.getB().getIsProxy(), "clone should be proxy");

		AssertFalse(clone.getB().getIsLoaded(), "clone shouldn't be loaded");

		AssertTrue(clone.getB().getIsClone(), "should be a clone");

		clone.getB().setStringValue("1547");

		getTransferE().save(clone.getB());

		AssertEquals("should be 1574", clone.getB().getStringValue(), a.getB().getStringValue());
	</cfscript>
</cffunction>

<cffunction name="_testCloneOneToManyProxyStruct" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var c = getTransferE().new("proxy.sC");
		var b = 0;
		var i = 1;
		var id = 0;
		var string = 0;
		var clone = 0;
		var uuid = 0;

		for(; i lte 5; i = i + 1)
		{
			b = getTransferE().new("proxy.sB");
			b.setStringValue(i & "fooBar!");
			b.setParentSC(c);
		}

		getTransferE().cascadeSave(c);


		id = c.getB("1fooBar!").getID();
		string = c.getB("5fooBar!").getStringValue();

		getTransferE().discardAll();

		c = getTransferE().get("proxy.sC", c.getID());

		clone = c.clone();

		for(i = 1; i lte 5; i = i + 1)
		{
			AssertFalse(clone.getB(i & "fooBar!").getIsLoaded(), "should not be loaded - (#i#)");
		}

		AssertEquals("should be 5 children", 5, StructCount(c.getBStruct()));

		AssertEquals("id should be the same", clone.getB("1fooBar!").getId(), id);

		AssertFalse(clone.getB("5fooBar!").getIsLoaded(), "should not be loaded [1]");

		AssertEquals("string should be the same", string, clone.getB("5fooBar!").getStringValue());

		AssertFalse(clone.getB("5fooBar!").getIsLoaded(), "should not be loaded [2]");

		AssertFalse(clone.getB("5fooBar!").getParentSCIsLoaded(), "should not be loaded at this time");

		AssertTrue(clone.getB("5fooBar!").getIsLoaded(), "should be loaded [1]");

		AssertTrue(clone.getB("5fooBar!").getIsPersisted(), "should be persisted");
	</cfscript>
</cffunction>

<cffunction name="_testCloneManyToManyProxyArray" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var a = getTransferE().new("proxy.A2");
		var b = 0;
		var i = 1;
		var id = 0;
		var string = 0;
		var clone = 0;
		var item = 0;

		for(; i lte 5; i = i + 1)
		{
			b = getTransferE().new("proxy.B2");
			b.setStringValue(RandRange(0, 10000) & "foo");
			b.setNumber(4);
			a.addB(b);
		}

		a.sortB();

		getTransferE().cascadeSave(a);

		id = a.getB(1).getID();
		string = a.getB(5).getStringValue();

		getTransferE().discardAll();

		a = getTransferE().get("proxy.A2", a.getID());

		clone = a.clone();

		AssertEquals("should be 5", 5, ArrayLen(clone.getBArray()));

		for(i = 1; i lte 5; i = i + 1)
		{
			AssertFalse(clone.getB(i).getIsLoaded(), "should not be loaded - (#i#)");
		}

		AssertEquals("id should be the same", clone.getB(1).getId(), id);

		AssertFalse(clone.getB(1).getIsLoaded(), "should not be loaded [1]");

		AssertEquals("string should be the same", string, clone.getB(5).getStringValue());

		AssertFalse(clone.getB(1).getIsLoaded(), "should not be loaded [2]");

		item = a.getB(1);

		clone.getB(1).setStringValue("FooBar!");

		getTransferE().save(clone.getB(1));

		AssertEquals("Should now have been Foo'd", "FooBar!", item.getStringValue());
	</cfscript>
</cffunction>

</cfcomponent>