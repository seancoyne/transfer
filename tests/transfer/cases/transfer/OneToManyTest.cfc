<cfcomponent name="OneToManyTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");

		assertEqualsBasic(simple.getClassName(), "onetomany.Basic");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var count = 0;

		var qAmount = 0;
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomany
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransfer().create(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomany
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testFailWrongChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomanyWrong.Basic");
		var check = false;
		var child = getTransfer().new("onetomany.Child");

		try
		{
			child.setParentBasic(simple);
		}
		catch(transfer.com.exception.InvalidTransferClassException exc)
		{
			check = true;
		}

		assertTrue(check, "Not correct class was allowed");
	</cfscript>
</cffunction>

<cffunction name="testSavingChildWithNonCachedParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var reget = 0;

		getTransfer().save(simple);

		getTransfer().discard(simple);

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		AssertEquals("reget should have no children", 0, ArrayLen(reget.getChildArray()));

		child.setParentBasic(simple);

		getTransfer().save(child);

		AssertEquals("simple should have children", 1, ArrayLen(simple.getChildArray()));

		AssertEquals("reget should have children", 1, ArrayLen(reget.getChildArray()));
	</cfscript>
</cffunction>

<cffunction name="testCreateChildrenInclude" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var children = 0;
		var parent = 0;
		var test = 0;

		getTransfer().save(simple);

		child.setParentBasic(simple);

		getTransfer().save(child);

		children = simple.getChildArray();

		assertTrue(ArrayLen(children) gt 0, "Child not added");

		assertSame("fail off copy", child, children[1]);

		assertSame("fail off get", child, simple.getChild(1));

		getTransfer().discard(simple);
		getTransfer().discard(child);

		simple = getTransfer().get("onetomany.Basic", simple.getIDBasic());
		child = getTransfer().get("onetomany.Child", child.getIDChild());

		assertSame("1: parent not same as child", simple, child.getParentBasic());

		getTransfer().discard(simple);
		getTransfer().discard(child);


		child = getTransfer().get("onetomany.Child", child.getIDChild());

		simple = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		parent = child.getParentBasic();

		assertEqualsBasic(simple.getClassName(), parent.getClassName());
		assertEqualsBasic(simple.getIDBasic(), parent.getIDBasic());

		assertSame("2: parent not same as child", simple, parent);
	</cfscript>
</cffunction>

<cffunction name="testSetParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var simple2 = getTransfer().new("onetomany.Basic");
		var child2 = 0;

		getTransfer().save(simple);

		//add child to parent
		child.setParentBasic(simple);

		getTransfer().save(child);

		assertSameBasic(child, simple.getChild(1));

		getTransfer().discard(child);

		child2 = getTransfer().get("onetomany.Child", child.getIDChild());

		child.setName("tttt");

		getTransfer().save(child);

		assertEqualsBasic(child.getName(), child2.getName());

		assertEquals("parent ID not same", child.getParentBasic().getIDBasic(), child2.getParentBasic().getIDBasic());

		getTransfer().save(simple2);

		child.setParentBasic(simple2);

		getTransfer().save(child);

		assertEquals("parent2 ID not same", child.getParentBasic().getIDBasic(), child2.getParentBasic().getIDBasic());
	</cfscript>
</cffunction>

<cffunction name="testCreateClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = 0;
		var clone = 0;
		var counter =1 ;
		var cloneChild = 0;

		getTransfer().save(simple);

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("onetomany.Child");
			child.setName(RandRange(1, 9999));

			child.setParentBasic(simple);

			getTransfer().save(child);
		}

		clone = simple.clone();

		assertTrue(clone.getIsClone(), "I'm not a clone?");
		assertTrue(clone.getIsPersisted(), "I'm not persisted?");
		assertEquals("Dirty doesn't match", clone.getIsDirty(), simple.getIsDirty());

		assertTrue(clone.getChild(1).getIsClone(), "I'm not a clone?");
		assertTrue(clone.getChild(1).getIsPersisted(), "I'm not persisted?");

		assertEquals("child: Dirty doesn't match", simple.getChild(1).getIsDirty(), clone.getChild(1).getIsDirty());

		assertNotSameBasic(clone, simple);
		assertEquals("should have 5", 5, ArrayLen(clone.getChildArray()));
		assertNotSameBasic(clone.getChild(1), simple.getChild(1));

		cloneChild = child.clone();

		assertTrue(cloneChild.getIsClone(), "I'm not a clone?");
		assertTrue(cloneChild.getIsPersisted(), "I'm not persisted?");

		assertEquals("clone child: Dirty doesn't match", child.getIsDirty(), cloneChild.getIsDirty());

		assertTrue(cloneChild.getParentBasic().getIsClone(), "parnet: I'm not a clone?");
		assertTrue(cloneChild.getParentBasic().getIsPersisted(), "parent: I'm not persisted?");
		assertEquals("clone child parent: Dirty doesn't match", cloneChild.getParentBasic().getIsDirty(), child.getParentBasic().getIsDirty());

		assertNotSame("clone parent is same as simple", simple, cloneChild.getParentBasic());

		getTransfer().delete(cloneChild);

		assertEquals("simple: one wasn't removed after delete", 4, ArrayLen(simple.getChildArray()));
		assertEquals("clone: one shouldn't have been removed", 5, ArrayLen(clone.getChildArray()));

		clone = simple.clone();
		assertEquals("clone: one should have been removed", 4, ArrayLen(clone.getChildArray()));

		child = simple.getChild(1);

		cloneChild = child.clone();

		assertEquals("cloneChild->Parent: one should have been removed", 4, ArrayLen(cloneChild.getParentBasic().getChildArray()));

		cloneChild.removeParentBasic();

		getTransfer().save(cloneChild);

		assertFalse(cloneChild.hasParentBasic());

		assertFalse(child.hasParentBasic(), "not removed parent");

		assertEquals("simple: one wasn't removed", 3, ArrayLen(simple.getChildArray()));

		child = getTransfer().new("onetomany.Child");
		child.setName(RandRange(1, 9999));

		assertFalse(child.hasParentBasic(), "child: has parent?");

		//getTransfer().save(child);

		cloneChild = child.clone();

		assertFalse(cloneChild.hasParentBasic(), "cloneChild: has parent?");
	</cfscript>
</cffunction>

<cffunction name="testCreateChildren" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var count = 0;
		var reget = 0;

		var qAmount = 0;
		var child = 0;
		var counter = 1;

		getTransfer().create(simple);
		</cfscript>

		<!--- see if the amount is more --->
		<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
			select count(*) as amount
			from
			tbl_onetomanychild
		</cfquery>

		<cfscript>
		count = qAmount.amount;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("onetomany.Child");
			child.setName(counter);

			child.setParentBasic(simple);

			getTransfer().save(child);
		}
	</cfscript>

	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomanychild
	</cfquery>
	<cfscript>
		AssertEquals("should be 5, no?", 5, ArrayLen(simple.getChildArray()));

		assertEqualsBasic(count + 5, qAmount.amount);

		assertEquals("find test", 5, simple.findChild(child));

		getTransfer().delete(child);

		AssertEqualsBasic(4, ArrayLen(simple.getChildArray()));

		getTransfer().discardAll();

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		assertTrue(reget.getIsPersisted(), "reget should be persisted");
		assertTrue(reget.getChild(1).getIsPersisted(), "reget:child should be persisted");

		assertFalse(reget.getIsDirty(), "reget should not be dirty");
		assertFalse(reget.getChild(1).getIsDirty(), "reget:child should not be dirty");
	</cfscript>
</cffunction>

<cffunction name="testCloneNonPersisted" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var clone = 0;

		getTransfer().save(simple);

		child.setParentBasic(simple);

		clone = simple.clone();

		getTransfer().save(clone);

		assertTrue(simple.getIsPersisted(), "parent is not persisted");
		assertFalse(simple.getChild(1).getIsPersisted(), "child is persisted, and shouldn't be'");
	</cfscript>
</cffunction>

<cffunction name="testFailUnSetParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = 0;
		var check = false;

		simple.setidbasic("45");

		child = getTransfer().new("onetomany.Child");
		child.setName(RandRange(1, 9999));

		child.setParentBasic(simple);

		try
		{
			getTransfer().save(child);
		}
		catch(transfer.com.sql.exception.ParentOneToManyNotCreatedException exc)
		{
			check = true;
		}

		assertTrue(check, "Child was created, when it shouldn't have been");
	</cfscript>
</cffunction>

<cffunction name="testChildNoParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var child = getTransfer().new("onetomany.Child");

		child.setName(RandRange(1, 9999));

		getTransfer().save(child);

		assertFalse(child.hasParentBasic(), "How can this child have a parent?");
	</cfscript>
</cffunction>

<cffunction name="testChildRemoveParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");

		getTransfer().save(simple);

		//add child to parent
		child.setParentBasic(simple);

		child.setName(RandRange(1, 9999));

		getTransfer().save(child);

		child.removeParentBasic();

		assertFalse(child.hasParentBasic(), "doesn't have a parent'");

		getTransfer().save(child);

		getTransfer().discard(child);

		child = getTransfer().get("onetomany.Child", child.getIDChild());

		assertFalse(child.hasParentBasic(), "Parent was set");
	</cfscript>
</cffunction>

<cffunction name="testDiscardedChild" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var reget = 0;

		getTransfer().save(child);
		getTransfer().save(simple);

		getTransfer().discard(child);

		child.setParentBasic(simple);

		getTransfer().save(child);

		reget = getTransfer().get("onetomany.Child", child.getIDChild());

		assertNotSame("should not be same due to discard", reget, child);
		assertSame("parent should be same(1)", simple, reget.getParentBasic());

		simple = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		assertSame("Child should be replaced (2)", reget, simple.getChild(1));
	</cfscript>
</cffunction>

<cffunction name="testDiscardedParent" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var reget = 0;

		getTransfer().save(simple);

		getTransfer().discard(simple);

		child.setParentBasic(simple);

		getTransfer().save(child);

		reget = getTransfer().get("onetomany.Child", child.getIDChild());

		assertNotSame("create:should not be same as not cached", reget, child);

		child = reget;

		simple = getTransfer().new("onetomany.Basic");

		getTransfer().save(simple);
		getTransfer().discard(simple);
		child.setParentBasic(simple);
		getTransfer().save(child);
		reget = getTransfer().get("onetomany.Child", child.getIDChild());

		assertNotSame("update:should not be same as not cached", reget, child);
	</cfscript>
</cffunction>


<cffunction name="testRetrieveChildNoParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var child = getTransfer().new("onetomany.Child");

		child.setName(RandRange(1, 9999));

		assertFalse(child.hasParentBasic(), "How can this have a parent?");

		getTransfer().save(child);

		getTransfer().discard(child);

		child = getTransfer().get("onetomany.Child", child.getIDChild());

		assertFalse(child.hasParentBasic(), "Parent was set");
	</cfscript>
</cffunction>

<cffunction name="testDeleteChildAndParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");

		getTransfer().save(simple);

		child.setParentBasic(simple);

		child.setName(RandRange(1, 9999));

		getTransfer().save(child);

		getTransfer().delete(child);

		getTransfer().delete(simple);
	</cfscript>
</cffunction>

<cffunction name="testCondition" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.BasicCondition");
		var child = getTransfer().new("onetomany.ChildCondition");
		var reget = 0;

		getTransfer().save(simple);

		//add child to parent
		child.setParentBasicCondition(simple);
		child.setName("george");
		getTransfer().save(child);

		//create 2
		child = getTransfer().new("onetomany.ChildCondition");
		child.setName("fred");
		child.setParentBasicCondition(simple);
		getTransfer().save(child);

		assertEquals("before save, should be 2", 2, ArrayLen(simple.getChildarray()));

		getTransfer().discard(simple);

		reget = getTransfer().get("onetomany.BasicCondition", simple.getIDBasic());

		assertEquals("reget, should be 1", 1, ArrayLen(reget.getChildarray()));
	</cfscript>
</cffunction>

<cffunction name="testRegetParentDirty" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");

		getTransfer().save(simple);

		//add child to parent
		child.setParentBasic(simple);

		child.setName(RandRange(1, 9999));

		getTransfer().save(child);

		getTransfer().discard(child);
		getTransfer().discard(simple);

		child = getTransfer().get("onetomany.Child", child.getIDChild());

		child.setName("fffff");

		AssertTrue(child.getIsDirty());

		parent = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		AssertTrue(child.getIsDirty(), "Should still be dirty");
	</cfscript>
</cffunction>

<cffunction name="testRegetParentNotDirty" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");

		getTransfer().save(simple);

		//add child to parent
		child.setParentBasic(simple);

		child.setName(RandRange(1, 9999));

		getTransfer().save(child);

		getTransfer().discard(child);
		getTransfer().discard(simple);

		child = getTransfer().get("onetomany.Child", child.getIDChild());

		AssertFalse(child.getIsDirty(), "should not be dirty to start");

		child.getParentBasic();

		AssertFalse(child.getIsDirty(), "should not be dirty after getParentBasic call");
	</cfscript>
</cffunction>

<cffunction name="testCascade" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var simple2 = getTransfer().new("onetomany.Basic");
		var child2 = 0;
		var reget =0 ;
		var util = createObject("component", "transfer.com.util.Utility").init();

		simple.setString(util.createGUID());

		//add child to parent
		child.setParentBasic(simple);

		getTransfer().cascadeCreate(simple);

		assertSameBasic(child, simple.getChild(1));

		getTransfer().discard(child);

		child2 = getTransfer().get("onetomany.Child", child.getIDChild());

		assertEquals("simple should have the same name", simple.getString(), child2.getParentBasic().getString());

		child.setName("tttt");

		getTransfer().cascadeSave(child);

		assertEqualsBasic(child.getName(), child2.getName());

		assertEquals("parent ID not same", child.getParentBasic().getIDBasic(), child2.getParentBasic().getIDBasic());

		simple2.setString(util.createGUID());

		child.setParentBasic(simple2);

		getTransfer().cascadeSave(child);

		getTransfer().discardAll();

		child2 = getTransfer().get("onetomany.Child", child.getIDChild());

		assertEquals("simple2 should have the same name", simple2.getString(), child2.getParentBasic().getString());

		getTransfer().cascadeDelete(child2.getParentBasic());

		child2 = getTransfer().get("onetomany.Child", child.getIDChild());

		AssertTrue(child.getIsPersisted(), "child should not be here");
	</cfscript>
</cffunction>

<cffunction name="testChildOneToManySave" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = 0;
		var clone = 0;
		var counter = 1;
		var reget = 0;
		var regetChild = 0;
		var array = 0;

		getTransfer().save(simple);

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("onetomany.Child");
			child.setName(RandRange(1, 9999));

			child.setParentBasic(simple);

			getTransfer().save(child);
		}

		getTransfer().discardAll();

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		AssertEquals("Should be 5", ArrayLen(reget.getChildArray()), 5);

		regetChild = getTransfer().get("onetomany.Child", reget.getChild(2).getIDChild());

		AssertEquals("should have same id", regetChild.getIdChild(), reget.getChild(2).getIdChild());

		AssertSame("(1) should be the same child", regetChild, reget.getChild(2));

		regetChild.setName("Yoda");

		AssertEquals("(1) should be 'Yoda'", "Yoda", regetChild.getName());

		AssertEquals("(2) should be 'Yoda'", "Yoda", reget.getChild(2).getName());

		getTransfer().save(regetChild);

		//now it has been re-ordered, so lets find it again
		array = reget.getChildArray();
		child = 0; //so it fails if it can't be found

		for(counter = 1; counter lte 5; counter = counter + 1)
		{
			if(array[counter].getIDChild() eq regetChild.getIDChild())
			{
				child = array[counter];
				break;
			}
		}


		AssertEquals("(3) should be 'Yoda'", "Yoda", child.getName());
		AssertSame("(2) should be the same child", regetChild, child);
	</cfscript>
</cffunction>

</cfcomponent>

