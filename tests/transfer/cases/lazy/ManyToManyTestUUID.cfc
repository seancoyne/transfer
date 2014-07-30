<cfcomponent name="ManyToManyTestUUID" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.m2mSimple");

		assertEqualsBasic(simple.getClassName(), "lazy.m2mSimple");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.m2mSimple");
		var count = 0;

		var qAmount = 0;
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_manytomanyuuid
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransfer().create(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_manytomanyuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testFailWrongChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.m2mSimple");
		var check = false;
		var child = getTransfer().new("Basic");

		try
		{
			simple.addChildren(child);
		}
		catch(transfer.com.exception.InvalidTransferClassException exc)
		{
			check = true;
		}

		assertTrue(check, "Not correct class was allowed");
	</cfscript>
</cffunction>


<cffunction name="testCreateChildren" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.m2mSimple");
		var count = 0;

		var qAmount = 0;
		var child = 0;
		var counter = 1;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("BasicUUID");
			child.setNumeric(RandRange(1, 9999));
			getTransfer().create(child);

			simple.addChildren(child);
		}
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		lnk_manytomanyuuid
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransfer().create(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		lnk_manytomanyuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 5, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testCreateTwoCollections" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.m2mSimple");
		var child = getTransfer().new("BasicUUID");
		var child2 = getTransfer().new("BasicUUID");
		var reget = 0;
		var t =0;

		getTransfer().save(child);

		simple.addChildren(child);

		simple.addChildren2(child);

		getTransfer().save(simple);

		assertSameBasic(simple.getChildren(1), simple.getChildren2(child.getUUID()));

		//2nd child
		getTransfer().save(child2);

		simple.addChildren2(child2);

		getTransfer().save(simple);

		t = simple.getChildren2Struct();

		assertEqualsBasic(2, StructCount(t));

		getTransfer().discard(simple);
		getTransfer().discard(child);
		getTransfer().discard(child2);

		reget = getTransfer().get("lazy.m2mSimple", simple.getIDSimple());

		assertNotSameBasic(simple, reget);
		assertNotSameBasic(reget.getChildren(1), simple.getChildren2(child.getUUID()));

		assertEquals("after reget", StructCount(reget.getChildren2Struct()), 2);
	</cfscript>
</cffunction>

<cffunction name="testRegetChildren" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.m2mSimple");
		var child = 0;
		var counter = 1;
		var reget = 0;
		var realChild = 0;

		getTransfer().create(simple);

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("BasicUUID");
			child.setString(RandRange(1, 9999));
			getTransfer().save(child);

			simple.addChildren(child);
		}

		simple.addChildren2(child);

		realChild = child;

		getTransfer().save(simple);

		assertEquals("before discard", 5, ArrayLen(simple.getChildrenArray()));
		assertEquals("before discard2", 1, StructCount(simple.getChildren2Struct()));

		getTransfer().discard(simple);

		reget = getTransfer().get("lazy.m2mSimple", simple.getIDSimple());

		assertEquals("before second discard", 5, ArrayLen(reget.getChildrenArray()));
		assertEquals("before second discard2", 1, StructCount(reget.getChildren2Struct()));

		getTransfer().discard(reget);

		reget = getTransfer().get("lazy.m2mSimple", simple.getIDSimple());

		reget.clearChildren();
		reget.clearChildren2();

		assertEquals("clear", 0, ArrayLen(reget.getChildrenArray()));
		assertEquals("clear 2", 0, StructCount(reget.getChildren2Struct()));

		getTransfer().discard(reget);

		reget = getTransfer().get("lazy.m2mSimple", simple.getIDSimple());

		child = getTransfer().new("BasicUUID");
		reget.addChildren(child);
		reget.addChildren2(child);

		assertEquals("add", 6, ArrayLen(reget.getChildrenArray()));
		assertEquals("add 2", 2, StructCount(reget.getChildren2Struct()));

		getTransfer().discard(reget);

		reget = getTransfer().get("lazy.m2mSimple", simple.getIDSimple());

		reget.removeChildren(realChild);
		reget.removeChildren2(realChild);

		assertEquals("remove", 4, ArrayLen(reget.getChildrenArray()));
		assertEquals("remove 2", 0, StructCount(reget.getChildren2Struct()));

		getTransfer().save(reget);

		assertEquals("after save", 4, ArrayLen(reget.getChildrenArray()));
		assertEquals("after save", 0, StructCount(reget.getChildren2Struct()));
	</cfscript>
</cffunction>

<cffunction name="testUpdateLazyM2M" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.m2mSimple");
		var count = 0;

		var qAmount = 0;
		var child = 0;
		var counter = 1;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("BasicUUID");
			child.setNumeric(RandRange(1, 9999));
			getTransfer().create(child);

			simple.addChildren(child);
		}

		assertEquals("5 children", 5, ArrayLen(simple.getChildrenArray()));

		getTransfer().save(simple);

		getTransfer().discardAll();

		reget = getTransfer().get("lazy.m2mSimple", simple.getIDSimple());

		assertNotSame("not the same", simple, reget);

		assertFalse(reget.getChildrenIsLoaded(), "shouldn't be loaded");

		getTransfer().save(reget);

		assertFalse(reget.getChildrenIsLoaded(), "shouldn't be loaded, after save");

		assertEquals("5 children, after reget", 5, ArrayLen(reget.getChildrenArray()));
	</cfscript>
</cffunction>

</cfcomponent>