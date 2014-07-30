<cfcomponent name="ManyToManyTestUUID" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytomany.SimpleUUID");


		assertEqualsBasic(simple.getClassName(), "manytomany.SimpleUUID");
		assertEqualsBasic("dog", simple.getThing());
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytomany.SimpleUUID");
		var count = 0;

		var qAmount = 0;
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_manytomanyuuid
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransferB().create(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_manytomanyuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
		assertEqualsBasic("dog", simple.getThing());
	</cfscript>
</cffunction>

<cffunction name="testCreateClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytomany.SimpleUUID");
		var child = 0;
		var clone = 0;
		var cloneChild = 0;

		var counter = 1;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransferB().new("BasicUUID");
			child.setNumeric(RandRange(1, 9999));
			getTransferB().create(child);

			simple.addChildren(child);
		}

		getTransferB().save(simple);

		clone = simple.clone();

		assertTrue(clone.getIsClone(), "I'm not a clone?");
		assertTrue(clone.getIsPersisted(), "I'm not persisted?");
		assertEquals("Dirty doesn't match", clone.getIsDirty(), simple.getIsDirty());

		assertTrue(clone.getChildren(1).getIsClone(), "I'm not a clone?");
		assertTrue(clone.getChildren(1).getIsPersisted(), "I'm not persisted?");
		assertEquals("Dirty doesn't match", clone.getChildren(1).getIsDirty(), simple.getChildren(1).getIsDirty());

		assertNotSameBasic(clone, simple);
		assertNotSameBasic(clone.getChildren(1), simple.getChildren(1));
		assertEquals("children should be the same", 5, ArrayLen(clone.getChildrenArray()));

		getTransferB().delete(clone.getChildren(1));

		assertEquals("clone: one shouldn't be removed", 5, ArrayLen(clone.getChildrenArray()));
		assertEquals("simple: one should be removed", 4, ArrayLen(simple.getChildrenArray()));

		clone = simple.clone();

		assertEquals("children should be the same, after delete", 4, ArrayLen(clone.getChildrenArray()));

		clone.removeChildren(clone.getChildren(1));

		getTransferB().save(clone);

		assertEquals("children should be same, after save", ArrayLen(clone.getChildrenArray()), ArrayLen(simple.getChildrenArray()));

		child = getTransferB().new("BasicUUID");
		child.setNumeric(RandRange(1, 9999));
		getTransferB().create(child);

		clone.addChildren(child);

		getTransferB().save(clone);

		assertEquals("children should be same, after save", ArrayLen(clone.getChildrenArray()), ArrayLen(simple.getChildrenArray()));
	</cfscript>
</cffunction>

<cffunction name="testFailWrongChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytomany.SimpleUUID");
		var check = false;
		var child = getTransferB().new("Basic");

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
		var simple = getTransferB().new("manytomany.SimpleUUID");
		var count = 0;

		var qAmount = 0;
		var child = 0;
		var counter = 1;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransferB().new("BasicUUID");
			child.setNumeric(RandRange(1, 9999));
			getTransferB().create(child);

			simple.addChildren(child);
			assertEqualsBasic("dog", child.getThing());
		}
		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", simple.getChildren(1).getThing());
		assertEqualsBasic("dog", simple.getChildren(2).getThing());
		assertEqualsBasic("dog", simple.getChildren(3).getThing());
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
		select count(*) as amount
		from
		lnk_manytomanyuuid
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransferB().create(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
		select count(*) as amount
		from
		lnk_manytomanyuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 5, qAmount.amount);
		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", simple.getChildren(1).getThing());
		assertEqualsBasic("dog", simple.getChildren(2).getThing());
		assertEqualsBasic("dog", simple.getChildren(3).getThing());
	</cfscript>
</cffunction>

<cffunction name="testCreateTwoCollections" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytomany.SimpleUUID");
		var child = getTransferB().new("BasicUUID");
		var child2 = getTransferB().new("BasicUUID");
		var reget = 0;
		var key = 0;

		getTransferB().save(child);

		simple.addChildren(child);

		simple.addChildren2(child);

		getTransferB().save(simple);

		assertSameBasic(simple.getChildren(1), simple.getChildren2(child.getUUID()));

		//2nd child
		getTransferB().save(child2);

		simple.addChildren2(child2);

		getTransferB().save(simple);

		assertEqualsBasic(StructCount(simple.getChildren2Struct()), 2);

		assertEquals("struct find: ", simple.findChildren2(child2), child2.getUUID());

		getTransferB().discard(simple);
		getTransferB().discard(child);
		getTransferB().discard(child2);

		reget = getTransferB().get("manytomany.SimpleUUID", simple.getIDSimple());

		assertNotSameBasic(simple, reget);
		assertNotSameBasic(reget.getChildren(1), simple.getChildren2(child.getUUID()));
		assertEqualsBasic(StructCount(reget.getChildren2Struct()), 2);

		key = simple.findChildren2(child2);

		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", simple.getChildren(1).getThing());
		assertEqualsBasic("dog", simple.getChildren2(key).getThing());
	</cfscript>
</cffunction>

</cfcomponent>