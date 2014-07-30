<cfcomponent name="ManyToManyTestUUID" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");

		assertEqualsBasic(simple.getClassName(), "manytomany.SimpleUUID");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");
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
		var simple = getTransfer().new("manytomany.SimpleUUID");
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
		var simple = getTransfer().new("manytomany.SimpleUUID");
		var count = 0;
		var simple2 = 0;

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

		getTransfer().delete(child);

		count = qAmount.amount;
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		lnk_manytomanyuuid
	</cfquery>
	<cfscript>
		AssertEquals("not removed from linking table", count - 1, qAmount.amount);

		AssertEqualsBasic(4, ArrayLen(simple.getChildrenArray()));

		getTransfer().discard(simple);

		simple2 = getTransfer().get("manytomany.SimpleUUID", simple.getIDSimple());

		child = getTransfer().new("BasicUUID");
		child.setNumeric(RandRange(1, 9999));
		getTransfer().create(child);

		simple.addChildren(child);

		AssertEquals("simple, before save, child: ", 5, ArrayLen(simple.getChildrenArray()));

		getTransfer().save(simple);

		AssertEquals("simple, child: ", 5, ArrayLen(simple.getChildrenArray()));
		AssertEquals("simple2, child: ", 5, ArrayLen(simple2.getChildrenArray()));
		AssertSame("simple", child, simple.getChildren(5));
		AssertSame("simple", child, simple2.getChildren(5));
	</cfscript>
</cffunction>

<cffunction name="testCloneNonPersisted" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");
		var child = getTransfer().new("BasicUUID");
		var clone = 0;
		var check = false;

		getTransfer().save(simple);

		assertTrue(simple.getIsPersisted(), "persisted should be true");

		clone = simple.clone();

		assertTrue(clone.getIsPersisted(), "clone, persisted should be true");

		clone.addChildren(child);

		try
		{
			getTransfer().save(clone);
		}
		catch(transfer.com.sql.exception.ManyToManyNotCreatedException exc)
		{
			check = true;
		}

		assertTrue(check, "Should throw an error as object is not persisted through");
	</cfscript>
</cffunction>

<cffunction name="testCreateClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");
		var child = 0;
		var clone = 0;
		var cloneChild = 0;

		var counter = 1;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("BasicUUID");
			child.setNumeric(RandRange(1, 9999));
			getTransfer().create(child);

			simple.addChildren(child);
		}

		getTransfer().save(simple);

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

		getTransfer().delete(clone.getChildren(1));

		assertEquals("clone: one shouldn't be removed", 5, ArrayLen(clone.getChildrenArray()));
		assertEquals("simple: one should be removed", 4, ArrayLen(simple.getChildrenArray()));

		clone = simple.clone();

		assertEquals("children should be the same, after delete", 4, ArrayLen(clone.getChildrenArray()));

		clone.removeChildren(clone.getChildren(1));

		getTransfer().save(clone);

		assertEquals("children should be same, after save", ArrayLen(clone.getChildrenArray()), ArrayLen(simple.getChildrenArray()));

		child = getTransfer().new("BasicUUID");
		child.setNumeric(RandRange(1, 9999));
		getTransfer().create(child);

		clone.addChildren(child);

		getTransfer().save(clone);

		assertEquals("children should be same, after save", ArrayLen(clone.getChildrenArray()), ArrayLen(simple.getChildrenArray()));

	</cfscript>
</cffunction>

<cffunction name="testCreateTwoCollections" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");
		var child = getTransfer().new("BasicUUID");
		var child2 = getTransfer().new("BasicUUID");
		var reget = 0;

		getTransfer().save(child);

		simple.addChildren(child);

		simple.addChildren2(child);

		getTransfer().save(simple);

		assertSame("Children should be the same", simple.getChildren(1), simple.getChildren2(child.getUUID()));

		//2nd child
		getTransfer().save(child2);

		simple.addChildren2(child2);

		getTransfer().save(simple);


		assertEquals("before reget:", 1, ArrayLen(simple.getChildrenArray()));

		assertEquals("before reget:", 2, StructCount(simple.getChildren2Struct()));

		assertEquals("struct find: ", simple.findChildren2(child2), child2.getUUID());

		getTransfer().discard(simple);
		getTransfer().discard(child);
		getTransfer().discard(child2);

		reget = getTransfer().get("manytomany.SimpleUUID", simple.getIDSimple());

		assertNotSame("Parents should not be the same", simple, reget);
		assertNotSame("Children should not be the same", reget.getChildren(1), simple.getChildren2(child.getUUID()));

		assertEquals("reget Children :", 1, ArrayLen(simple.getChildrenArray()));
		assertEquals("reget Children2 :", 2, StructCount(reget.getChildren2Struct()));
	</cfscript>
</cffunction>

<cffunction name="testAddDiscardChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");
		var child = getTransfer().new("BasicUUID");
		var reget = 0;

		getTransfer().save(child);
		getTransfer().discard(child);

		simple.addChildren(child);

		getTransfer().save(simple);

		reget = getTransfer().get("manytomany.SimpleUUID", simple.getIDSimple());

		assertNotSame("create: simple shouldn't cache", reget, simple);

		simple = reget;

		child = getTransfer().new("BasicUUID");

		getTransfer().save(child);
		getTransfer().discard(child);

		simple.addChildren(child);

		getTransfer().save(simple);

		reget = getTransfer().get("manytomany.SimpleUUID", simple.getIDSimple());

		assertNotSame("update: simple shouldn't cache", reget, simple);
	</cfscript>
</cffunction>


<cffunction name="testConditions" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleCondition");
		var child = getTransfer().new("BasicUUID");
		var reget = 0;
		var uuid = 0;
		var qData = 0;

		child.setString("fred");

		getTransfer().save(child);

		simple.addChildren(child);

		child = getTransfer().new("BasicUUID");
		child.setString("george");

		getTransfer().save(child);

		simple.addChildren(child);

		getTransfer().save(simple);

		assertEquals("before save, should be 2", 2, ArrayLen(simple.getChildrenarray()));

		</cfscript>
			<cfquery name="qData" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
				select * from lnk_manytomanyuuid where
				lnkIDManytoMany = <cfqueryparam value="#simple.getIDSimple()#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfscript>
		assertEquals("has 2 records on save", 2, #qData.recordcount#);

		getTransfer().discard(simple);

		reget = getTransfer().get("manytomany.SimpleCondition", simple.getIDSimple());

		assertEquals("reget, should be 1", 1, ArrayLen(reget.getChildrenarray()));

		//just to make it dirty
		uuid = reget.getIDSimple();
		reget.setIDSimple(createUUID());
		reget.setIDSimple(uuid);

		getTransfer().save(reget);
	</cfscript>
		<cfquery name="qData" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			select * from lnk_manytomanyuuid where
			lnkIDManytoMany = <cfqueryparam value="#simple.getIDSimple()#" cfsqltype="cf_sql_varchar">
		</cfquery>
	<cfscript>
	assertEquals("reget has 2 records on save", 2, #qData.recordcount#);
	</cfscript>
</cffunction>

<cffunction name="testStructContains" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferC().new("manytomany.SimpleUUID");
		var child = getTransferC().new("BasicUUID");

		var simple2 = getTransferC().new("manytomany.SimpleUUID");
		var child2 = getTransferC().new("BasicUUID");

		child.setStringValue("987654321");

		simple.addChild(child);

		getTransferC().save(child);
		getTransferC().save(simple);

		child2.setStringValue("987654321");

		simple2.addChild(child2);

		getTransferC().save(child2);
		getTransferC().save(simple2);

		AssertTrue(simple.containsChild(child), "should contain own");
		AssertFalse(simple.containsChild(child2), "shouldn't contain other");

		AssertTrue(simple2.containsChild(child2), "2 should contain own");
		AssertFalse(simple2.containsChild(child), "2 shouldn't contain other");

		getTransferC().delete(child2);

		AssertTrue(structIsEmpty(simple2.getChildStruct()), "2 struct should be empty");
		AssertFalse(structIsEmpty(simple.getChildStruct()), "struct should NOT be empty");
	</cfscript>
</cffunction>

<cffunction name="testBroken" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var simple = 0;

		var check = false;

		try
		{
			getTransfer().new("manytomany.SimpleBroken");
		}
		catch(transfer.com.object.exception.InvalidManyToManyConfigurationException exc)
		{
			check = true;
		}

		AssertTrue(check, "Should return error for misconfig");
	</cfscript>
</cffunction>

<cffunction name="testCascade" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");
		var count = 0;
		var simple2 = 0;

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

		getTransfer().cascadeSave(simple);

		getTransfer().discardAll();

		simple2 = getTransfer().get("manytomany.SimpleUUID", simple.getIDSimple());

		AssertTrue(simple2.getIsPersisted(), "should be persisted");

		AssertEquals("shoud be 5", 5, arrayLen(simple2.getChildrenArray()));

		getTransfer().cascadeDelete(simple2);

		simple2 = getTransfer().get("manytomany.SimpleUUID", simple.getIDSimple());

		AssertFalse(simple2.getIsPersisted(), "should not be persisted");
	</cfscript>
</cffunction>

<cffunction name="testRecursive" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("recurse.RyanW");
		var count = 0;
		var simple2 = 0;

		var qAmount = 0;
		var child = 0;
		var counter = 1;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("recurse.RyanW");
			child.setStringValue(RandRange(1, 9999));
			getTransfer().create(child);

			simple.addB(child);
		}

		getTransfer().cascadeSave(simple);

		getTransfer().discardAll();

		simple2 = getTransfer().get("recurse.RyanW", simple.getID());

		AssertTrue(simple2.getIsPersisted(), "should be persisted");

		AssertEquals("shoud be 5", 5, arrayLen(simple2.getBArray()));
	</cfscript>
</cffunction>

</cfcomponent>