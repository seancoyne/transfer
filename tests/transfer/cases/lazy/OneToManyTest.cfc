<cfcomponent name="OneToManyTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");

		assertEqualsBasic(simple.getClassName(), "lazy.o2mBasic");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
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
		var child = getTransfer().new("lazy.o2mChild");

		try
		{
			child.setParento2mBasic(simple);
		}
		catch(transfer.com.exception.InvalidTransferClassException exc)
		{
			check = true;
		}

		assertTrue(check, "Not correct class was allowed");
	</cfscript>
</cffunction>

<cffunction name="testCreateChildrenInclude" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
		var child = getTransfer().new("lazy.o2mChild");
		var children = 0;

		getTransfer().save(simple);

		child.setParento2mBasic(simple);

		getTransfer().save(child);

		children = simple.getChildArray();

		assertTrue(ArrayLen(children) gt 0, "Child not added");

		assertSame("fail off copy", child, children[1]);

		assertSame("fail off get", child, simple.getChild(1));
	</cfscript>
</cffunction>

<cffunction name="testSetParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
		var child = getTransfer().new("lazy.o2mChild");

		//add child to parent
		child.setParento2mBasic(simple);

		assertSameBasic(child, simple.getChild(1));
	</cfscript>
</cffunction>

<cffunction name="testDeleteNonLoaded" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");

		getTransfer().save(simple);

		getTransfer().discard(simple);

		simple = getTransfer().get("lazy.o2mBasic", simple.getIDBasic());

		getTransfer().delete(simple);

		AssertFalse(simple.getIsPersisted(), "simple.getIsPersisted() Should be false");
		AssertTrue(simple.getIsDirty(), "simple.getIsDirty() Should be true");

		simple.getChildArray();
	</cfscript>
</cffunction>

<cffunction name="testCreateChildren" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
		var count = 0;

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
			child = getTransfer().new("lazy.o2mChild");
			child.setName(RandRange(1, 9999));

			child.setParento2mBasic(simple);

			getTransfer().save(child);
		}
	</cfscript>

	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomanychild
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 5, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testFailUnSetParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
		var child = 0;
		var check = false;

		simple.setidbasic("45");

		child = getTransfer().new("lazy.o2mChild");
		child.setName(RandRange(1, 9999));

		child.setParento2mBasic(simple);

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
		var child = getTransfer().new("lazy.o2mChild");

		child.setName(RandRange(1, 9999));

		getTransfer().save(child);

		assertFalse(child.hasParento2mBasic(), "How can this child have a parent?");
	</cfscript>
</cffunction>

<cffunction name="testChildRemoveParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
		var child = getTransfer().new("lazy.o2mChild");

		getTransfer().save(simple);

		//add child to parent
		child.setParento2mBasic(simple);

		child.setName(RandRange(1, 9999));

		getTransfer().save(child);

		child.removeParento2mBasic();

		assertFalse(child.hasParento2mBasic(), "doesn't have a parent'");

		getTransfer().save(child);

		getTransfer().discard(child);

		child = getTransfer().get("lazy.o2mChild", child.getIDChild());

		assertFalse(child.hasParento2mBasic(), "Parent was set");
	</cfscript>
</cffunction>

<cffunction name="testRetrieveChildNoParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var child = getTransfer().new("lazy.o2mChild");

		child.setName(RandRange(1, 9999));

		assertFalse(child.hasParento2mBasic(), "How can this have a parent?");

		getTransfer().save(child);

		getTransfer().discard(child);

		child = getTransfer().get("lazy.o2mChild", child.getIDChild());

		assertFalse(child.hasParento2mBasic(), "Parent was set");
	</cfscript>
</cffunction>

<cffunction name="testRegetChildren" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
		var child = 0;
		var counter = 1;
		var reget = 0;

		getTransfer().create(simple);

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("lazy.o2mChild");
			child.setName(RandRange(1, 9999));

			child.setParento2mBasic(simple);

			getTransfer().save(child);
		}

		assertEquals("before discard", 5, ArrayLen(simple.getChildArray()));

		getTransfer().discard(simple);

		reget = getTransfer().get("lazy.o2mBasic", simple.getIDBasic());

		assertEquals("after discard", 5, ArrayLen(reget.getChildArray()));
	</cfscript>
</cffunction>

<cffunction name="testRegetChildLoadParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mBasic");
		var child = 0;
		var counter = 1;
		var reget = 0;
		var realChild = 0;

		getTransfer().create(simple);

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("lazy.o2mChild");
			child.setName(RandRange(1, 9999));

			child.setParento2mBasic(simple);

			getTransfer().save(child);
		}

		realChild = child;

		assertEquals("before discard", 5, ArrayLen(simple.getChildArray()));

		getTransfer().discard(simple);

		reget = getTransfer().get("lazy.o2mChild", child.getIDChild());

		reget.getParento2mBasic();

		assertEquals("after discard", 5, ArrayLen(reget.getParento2mBasic().getChildArray()));

		getTransfer().discard(reget.getParento2mBasic());
		getTransfer().discard(reget);

		reget = getTransfer().get("lazy.o2mBasic", simple.getIDBasic());

		child = getTransfer().new("lazy.o2mChild");
		child.setParento2mBasic(reget);

		reget.getChildArray();

		assertEquals("added before load", 6, ArrayLen(reget.getChildArray()));

		getTransfer().discard(reget);

		reget = getTransfer().get("lazy.o2mChild", realChild.getIDChild());

		simple = reget.getParento2mBasic();

		reget.removeParento2mBasic();

		assertEquals("removed before load", 4, ArrayLen(simple.getChildArray()));
	</cfscript>
</cffunction>

<cffunction name="testRegetLazyStruct" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("lazy.o2mStructBasic");
		var child = 0;
		var counter = 1;
		var reget = 0;
		var realChild = 0;

		getTransfer().create(simple);

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("lazy.o2mStructChild");
			child.setName(createUUID());

			child.setParento2mStructBasic(simple);

			getTransfer().save(child);
		}

		getTransfer().discardAll();

		reget = getTransfer().get("lazy.o2mStructBasic", simple.getIDBasic());

		AssertNotSame("should not be the same", simple, reget);

		AssertEquals("should be 5 children", 5, StructCount(reget.getChildStruct()));
	</cfscript>
</cffunction>

</cfcomponent>