<cfcomponent name="onetomanyTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");

		assertEqualsBasic(simple.getClassName(), "onetomany.Basic");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");
		var count = 0;

		var qAmount = 0;

		assertEqualsBasic("dog", simple.getThing());
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomany
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransferB().create(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomany
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testCreateChildrenInclude" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");
		var child = getTransferB().new("onetomany.Child");
		var children = 0;
		var parent = 0;
		var test = 0;


		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getThing());

		getTransferB().save(simple);

		child.setParentBasic(simple);

		getTransferB().save(child);

		children = simple.getChildArray();

		assertTrue(ArrayLen(children) gt 0, "Child not added");

		assertSame("fail off copy", child, children[1]);

		assertSame("fail off get", child, simple.getChild(1));

		getTransferB().discard(simple);
		getTransferB().discard(child);

		simple = getTransferB().get("onetomany.Basic", simple.getIDBasic());
		child = getTransferB().get("onetomany.Child", child.getIDChild());

		assertSame("1: parent not same as child", simple, child.getParentBasic());

		getTransferB().discard(simple);
		getTransferB().discard(child);


		child = getTransferB().get("onetomany.Child", child.getIDChild());

		simple = getTransferB().get("onetomany.Basic", simple.getIDBasic());

		parent = child.getParentBasic();


		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getThing());

		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", parent.getThing());

		assertEqualsBasic(simple.getClassName(), parent.getClassName());
		assertEqualsBasic(simple.getIDBasic(), parent.getIDBasic());
		assertSame("2: parent not same as child", simple, parent);
	</cfscript>
</cffunction>

<cffunction name="testSetParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");
		var child = getTransferB().new("onetomany.Child");

		//add child to parent
		child.setParentBasic(simple);

		assertSameBasic(child, simple.getChild(1));

		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getThing());
	</cfscript>
</cffunction>

<cffunction name="testCreateChildren" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");
		var count = 0;

		var qAmount = 0;
		var child = 0;
		var counter = 1;

		getTransferB().create(simple);
		</cfscript>

		<!--- see if the amount is more --->
		<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
			select count(*) as amount
			from
			tbl_onetomanychild
		</cfquery>

		<cfscript>
		count = qAmount.amount;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransferB().new("onetomany.Child");
			child.setName(counter);

			child.setParentBasic(simple);

			getTransferB().save(child);
		}

		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", simple.getChild(3).getThing());
		assertEqualsBasic("dog", simple.getChild(2).getThing());
		assertEqualsBasic("dog", simple.getChild(1).getThing());
	</cfscript>

	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomanychild
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 5, qAmount.amount);
		assertEquals("find test", 5, simple.findChild(child));
	</cfscript>

</cffunction>

<cffunction name="testFailUnSetParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");
		var child = 0;
		var check = false;

		simple.setidbasic("45");

		child = getTransferB().new("onetomany.Child");
		child.setName(RandRange(1, 9999));

		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getThing());

		child.setParentBasic(simple);

		try
		{
			getTransferB().save(child);
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
		var child = getTransferB().new("onetomany.Child");

		child.setName(RandRange(1, 9999));

		getTransferB().save(child);

		assertFalse(child.hasParentBasic(), "How can this child have a parent?");

		assertEqualsBasic("dog", child.getThing());
	</cfscript>
</cffunction>

<cffunction name="testChildRemoveParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");
		var child = getTransferB().new("onetomany.Child");

		getTransferB().save(simple);

		//add child to parent
		child.setParentBasic(simple);

		child.setName(RandRange(1, 9999));

		getTransferB().save(child);

		child.removeParentBasic();

		assertFalse(child.hasParentBasic(), "doesn't have a parent'");

		getTransferB().save(child);

		getTransferB().discard(child);

		child = getTransferB().get("onetomany.Child", child.getIDChild());

		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getThing());

		assertFalse(child.hasParentBasic(), "Parent was set");
	</cfscript>
</cffunction>

<cffunction name="testRetrieveChildNoParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var child = getTransferB().new("onetomany.Child");

		child.setName(RandRange(1, 9999));

		assertFalse(child.hasParentBasic(), "How can this have a parent?");

		getTransferB().save(child);

		getTransferB().discard(child);

		child = getTransferB().get("onetomany.Child", child.getIDChild());

		assertEqualsBasic("dog", child.getThing());

		assertFalse(child.hasParentBasic(), "Parent was set");
	</cfscript>
</cffunction>

<cffunction name="testCondition" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.BasicCondition");
		var child = getTransferB().new("onetomany.ChildCondition");
		var reget = 0;

		getTransferB().save(simple);

		//add child to parent
		child.setParentBasicCondition(simple);
		child.setName("george");
		getTransferB().save(child);

		//create 2
		child = getTransferB().new("onetomany.ChildCondition");
		child.setName("fred");
		child.setParentBasicCondition(simple);
		getTransferB().save(child);

		assertEquals("before save, should be 2", 2, ArrayLen(simple.getChildarray()));

		getTransferB().discard(simple);

		assertEquals("after discard, should be 2", 2, ArrayLen(simple.getChildarray()));

		reget = getTransferB().get("onetomany.BasicCondition", simple.getIDBasic());

		AssertNotSame("should not be same", reget, simple);

		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", simple.getChild(1).getThing());
		assertEqualsBasic("dog", reget.getThing());
		assertEqualsBasic("dog", reget.getChild(1).getThing());

		assertEquals("reget, should be 1", 1, ArrayLen(reget.getChildarray()));
	</cfscript>
</cffunction>

<cffunction name="testCreateClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomany.Basic");
		var child = 0;
		var clone = 0;
		var counter =1 ;
		var cloneChild = 0;

		getTransferB().save(simple);

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransferB().new("onetomany.Child");
			child.setName(RandRange(1, 9999));

			child.setParentBasic(simple);

			getTransferB().save(child);
		}

		clone = simple.clone();

		assertNotSameBasic(clone, simple);
		assertEquals("should have 5", 5, ArrayLen(clone.getChildArray()));
		assertNotSameBasic(clone.getChild(1), simple.getChild(1));

		cloneChild = child.clone();

		assertNotSame("clone parent is same as simple", simple, cloneChild.getParentBasic());

		getTransferB().delete(cloneChild);

		assertEquals("simple: one wasn't removed after delete", 4, ArrayLen(simple.getChildArray()));
		assertEquals("clone: one shouldn't have been removed", 5, ArrayLen(clone.getChildArray()));

		child = simple.getChild(1);

		cloneChild = child.clone();

		assertEquals("clone: one should have been removed", 4, ArrayLen(cloneChild.getParentBasic().getChildArray()));

		cloneChild.removeParentBasic();

		getTransferB().save(cloneChild);

		assertFalse(cloneChild.hasParentBasic());

		assertFalse(child.hasParentBasic(), "not removed parent");

		assertEquals("simple: one wasn't removed", 3, ArrayLen(simple.getChildArray()));

		cloneChild = child.clone();

		cloneChild.setParentBasic(simple.clone());

		getTransferB().save(cloneChild);

		assertEquals("simple: one wasn't added", 4, ArrayLen(simple.getChildArray()));

		/*
		child = getTransferB().new("onetomany.Child");

		child.setParentBasic(simple.clone());

		getTransferB().save(child);

		assertEquals("simple: new -> clone", 5, ArrayLen(simple.getChildArray()));
		*/
	</cfscript>
</cffunction>

</cfcomponent>

