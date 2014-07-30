<cfcomponent name="OneToManyTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomanydefault.tbl_onetomany");

		assertEqualsBasic(simple.getClassName(), "onetomanydefault.tbl_onetomany");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomanydefault.tbl_onetomany");
		var count = 0;

		var qAmount = 0;
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_onetomany
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransferB().create(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
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
		var simple = getTransferB().new("onetomanydefault.tbl_onetomany");
		var child = getTransferB().new("onetomanydefault.tbl_onetomanychild");
		var children = 0;
		var parent = 0;
		var test = 0;

		getTransferB().save(simple);

		child.setParenttbl_onetomany(simple);

		getTransferB().save(child);

		children = simple.getChildArray();

		assertTrue(ArrayLen(children) gt 0, "Child not added");

		assertSame("fail off copy", child, children[1]);

		assertSame("fail off get", child, simple.getChild(1));

		getTransferB().discard(simple);
		getTransferB().discard(child);

		simple = getTransferB().get("onetomanydefault.tbl_onetomany", simple.getIDBasic());
		child = getTransferB().get("onetomanydefault.tbl_onetomanychild", child.getIDChild());

		assertSame("1: parent not same as child", simple, child.getParenttbl_onetomany());

		getTransferB().discard(simple);
		getTransferB().discard(child);


		child = getTransferB().get("onetomanydefault.tbl_onetomanychild", child.getIDChild());

		simple = getTransferB().get("onetomanydefault.tbl_onetomany", simple.getIDBasic());

		parent = child.getParenttbl_onetomany();

		assertEqualsBasic(simple.getClassName(), parent.getClassName());
		assertEqualsBasic(simple.getIDBasic(), parent.getIDBasic());
		assertSame("2: parent not same as child", simple, parent);
	</cfscript>
</cffunction>

<cffunction name="testSetParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomanydefault.tbl_onetomany");
		var child = getTransferB().new("onetomanydefault.tbl_onetomanychild");

		//add child to parent
		child.setParenttbl_onetomany(simple);

		assertSameBasic(child, simple.getChild(1));
	</cfscript>
</cffunction>

<cffunction name="testCreateChildren" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomanydefault.tbl_onetomany");
		var count = 0;

		var qAmount = 0;
		var child = 0;
		var counter = 1;

		getTransferB().create(simple);
		</cfscript>

		<!--- see if the amount is more --->
		<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
			select count(*) as amount
			from
			tbl_onetomanychild
		</cfquery>

		<cfscript>
		count = qAmount.amount;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransferB().new("onetomanydefault.tbl_onetomanychild");
			child.setName(counter);

			child.setParenttbl_onetomany(simple);

			getTransferB().save(child);
		}
	</cfscript>

	<cfquery name="qAmount" datasource="#getDataSourceB().getName()#" username="#getDataSourceB().getUsername()#" password="#getDataSourceB().getUsername()#">
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
		var simple = getTransferB().new("onetomanydefault.tbl_onetomany");
		var child = 0;
		var check = false;

		simple.setidbasic("45");

		child = getTransferB().new("onetomanydefault.tbl_onetomanychild");
		child.setName(RandRange(1, 9999));

		child.setParenttbl_onetomany(simple);

		try
		{
			getTransferB().save(child);
		}
		catch(transfer.com.sql.exception.ParentOneToManyNotCreatedException exc)
		{
			check = true;
		}

		assertTrue(check, "Child was created, when it shouldn't have been");

		child.removeParenttbl_onetomany();
		getTransferB().save(child);

		check = false;

		child.setParenttbl_onetomany(simple);

		try
		{
			getTransferB().save(child);
		}
		catch(transfer.com.sql.exception.ParentOneToManyNotCreatedException exc)
		{
			check = true;
		}

		assertTrue(check, "Child was udpated, when it shouldn't have been");
	</cfscript>
</cffunction>

<cffunction name="testChildNoParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var child = getTransferB().new("onetomanydefault.tbl_onetomanychild");

		child.setName(RandRange(1, 9999));

		getTransferB().save(child);

		assertFalse(child.hasParenttbl_onetomany(), "How can this child have a parent?");
	</cfscript>
</cffunction>

<cffunction name="testChildRemoveParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("onetomanydefault.tbl_onetomany");
		var child = getTransferB().new("onetomanydefault.tbl_onetomanychild");

		getTransferB().save(simple);

		//add child to parent
		child.setParenttbl_onetomany(simple);

		child.setName(RandRange(1, 9999));

		getTransferB().save(child);

		child.removeParenttbl_onetomany();

		assertFalse(child.hasParenttbl_onetomany(), "doesn't have a parent'");

		getTransferB().save(child);

		getTransferB().discard(child);

		child = getTransferB().get("onetomanydefault.tbl_onetomanychild", child.getIDChild());

		assertFalse(child.hasParenttbl_onetomany(), "Parent was set");
	</cfscript>
</cffunction>

<cffunction name="testRetrieveChildNoParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var child = getTransferB().new("onetomanydefault.tbl_onetomanychild");

		child.setName(RandRange(1, 9999));

		assertFalse(child.hasParenttbl_onetomany(), "How can this have a parent?");

		getTransferB().save(child);

		getTransferB().discard(child);

		child = getTransferB().get("onetomanydefault.tbl_onetomanychild", child.getIDChild());

		assertFalse(child.hasParenttbl_onetomany(), "Parent was set");
	</cfscript>
</cffunction>

</cfcomponent>

