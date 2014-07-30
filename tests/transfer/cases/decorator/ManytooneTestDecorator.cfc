<cfcomponent name="ManytooneTestUUID" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");

		assertEqualsBasic(simple.getClassName(), "manytoone.SimpleUUID");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		getTransferB().create(simple);

		assertFalse(simple.hasChild(), "Child was set");

		assertEqualsBasic("dog", simple.getThing());
	</cfscript>
</cffunction>

<cffunction name="testCreateClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		var child =  getTransferB().new("manytoone.ChildUUID");
		var child2 =  getTransferB().new("manytoone.ChildUUID");
		var clone = 0;

		child.setDate("dogfog");

		getTransferB().save(child);

		simple.setChild(child);

		getTransferB().save(simple);

		clone = simple.clone();

		assertNotSameBasic(clone, simple);
		assertNotSameBasic(clone.getChild(), simple.getChild());

		assertTrue(clone.getIsClone(), "I'm not a clone?");
		assertTrue(clone.getIsPersisted(), "I'm not persisted?");
		assertEquals("Dirty doesn't match", clone.getIsDirty(), simple.getIsDirty());

		assertTrue(clone.getChild().getIsClone(), "I'm not a clone?");
		assertTrue(clone.getChild().getIsPersisted(), "I'm not persisted?");
		assertEquals("Dirty doesn't match", clone.getChild().getIsDirty(), simple.getChild().getIsDirty());

		assertEqualsBasic(child.getDate(), clone.getChild().getDate());

		getTransferB().save(child2);

		clone.setChild(child2);

		getTransferB().save(clone);

		AssertSame("sync failed", clone.getChild(), simple.getChild());
	</cfscript>
</cffunction>


<cffunction name="testRemoveChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		var child =  getTransferB().new("manytoone.ChildUUID");

		getTransferB().create(child);
		simple.setChild(child);

		getTransferB().save(simple);

		simple.removeChild();

		getTransferB().save(simple);

		assertFalse(simple.hasChild(), "Child was set");

		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", child.getThing());
	</cfscript>
</cffunction>

<cffunction name="testRetrieveNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		getTransferB().create(simple);

		getTransferB().discard(simple);

		simple = getTransferB().get("manytoone.SimpleUUID", simple.getIDSimple());

		assertFalse(simple.hasChild(), "Child was set");

		assertEqualsBasic("dog", simple.getThing());
	</cfscript>
</cffunction>

<cffunction name="testFailWrongChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		var check = false;
		var child = getTransferB().new("Basic");
		try
		{
			simple.setChild(child);
		}
		catch(transfer.com.exception.InvalidTransferClassException exc)
		{
			check = true;
		}

		assertTrue(check, "Not correct class was allowed");
	</cfscript>
</cffunction>

<cffunction name="testFailNonCreatedChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		var child =  getTransferB().new("manytoone.ChildUUID");
		var check = false;

		simple.setChild(child);

		try
		{
			getTransferB().create(simple);
		}
		catch(transfer.com.sql.exception.ManyToOneNotCreatedException exc)
		{
			check = true;
		}
		assertTrue(check, "No exception was thrown");
	</cfscript>
</cffunction>

<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		var child =  getTransferB().new("manytoone.ChildUUID");

		getTransferB().create(child);
		simple.setChild(child);

		getTransferB().create(simple);

		//for next test
		variables.test.IDSimple = simple.getIDSimple();
		variables.test.IDChild = child.getIDChild();

		assertSameBasic(child, simple.getChild());

		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", child.getThing());
		assertEqualsBasic("dog", simple.getChild().getThing());
	</cfscript>
</cffunction>

<cffunction name="testGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = 0;

		testCreate();

		simple = getTransferB().get("manytoone.SimpleUUID", variables.test.IDSimple);

		assertEqualsBasic(variables.test.IDSimple, simple.getIDSimple());
		assertEqualsBasic(variables.test.IDChild, simple.getChild().getIDChild());

		getTransferB().discard(simple);

		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", simple.getChild().getThing());

		simple = getTransferB().get("manytoone.SimpleUUID", variables.test.IDSimple);

		assertEqualsBasic(variables.test.IDSimple, simple.getIDSimple());
		assertEqualsBasic(variables.test.IDChild, simple.getChild().getIDChild());

		assertEqualsBasic("dog", simple.getThing());
		assertEqualsBasic("dog", simple.getChild().getThing());
	</cfscript>
</cffunction>

<cffunction name="testUpdate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var qAmount = 0;
		var lnkIDChild = 0;
		var simple = 0;

		var child = getTransferB().new("manytoone.ChildUUID");
		testCreate();
		simple = getTransferB().get("manytoone.SimpleUUID", variables.test.IDSimple);

		assertEqualsBasic("dog", simple.getThing());
	</cfscript>

	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select lnkIDChild
		from
		tbl_manytooneuuid
		where
		IDSimple = <cfqueryparam value="#simple.getIDSimple()#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>

	<cfscript>
		lnkIDChild = qAmount.lnkIDChild;

		getTransferB().create(child);

		simple.setChild(child);

		getTransferB().update(simple);
	</cfscript>

	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select lnkIDChild
		from
		tbl_manytooneuuid
		where
		IDSimple = <cfqueryparam value="#simple.getIDSimple()#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>

	<cfscript>
		assertTrueBasic(lnkIDChild neq qAmount.lnkIDChild);
	</cfscript>
</cffunction>

<cffunction name="testDelete" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var qAmount = 0;
		var lnkIDChild = 0;
		var simple = 0;

		var child = getTransferB().new("manytoone.ChildUUID");
		testCreate();
		simple = getTransferB().get("manytoone.SimpleUUID", variables.test.IDSimple);
	</cfscript>

	<!--- see if the amount is less --->
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_manytooneuuid
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransferB().delete(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_manytooneuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count - 1, qAmount.amount);
	</cfscript>
</cffunction>
</cfcomponent>