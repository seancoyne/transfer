<cfcomponent name="ManytooneTestUUID" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");

		assertEqualsBasic(simple.getClassName(), "manytoone.SimpleUUID");
	</cfscript>
</cffunction>

<cffunction name="testCreateNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		getTransfer().create(simple);

		assertFalse(simple.hasChild(), "Child was set");
	</cfscript>
</cffunction>

<cffunction name="testRemoveChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child =  getTransfer().new("manytoone.ChildUUID");

		getTransfer().create(child);
		simple.setChild(child);

		getTransfer().save(simple);

		simple.removeChild();

		getTransfer().save(simple);

		assertFalse(simple.hasChild(), "Child was set");
	</cfscript>
</cffunction>

<cffunction name="testRetrieveNoChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		getTransfer().create(simple);

		getTransfer().discard(simple);

		simple = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

		assertFalse(simple.hasChild(), "Child was set");
	</cfscript>
</cffunction>

<cffunction name="testFailWrongChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var check = false;
		var child = getTransfer().new("Basic");
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
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child =  getTransfer().new("manytoone.ChildUUID");
		var check = false;

		simple.setChild(child);

		try
		{
			getTransfer().create(simple);
		}
		catch(transfer.com.sql.exception.ManyToOneNotCreatedException exc)
		{
			check = true;
		}
		assertTrue(check, "No exception was thrown : create");

		simple.removeChild();

		getTransfer().create(simple);

		simple.setChild(child);

		check = false;

		try
		{
			getTransfer().update(simple);
		}
		catch(transfer.com.sql.exception.ManyToOneNotCreatedException exc)
		{
			check = true;
		}
		assertTrue(check, "No exception was thrown : update");
	</cfscript>
</cffunction>

<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child =  getTransfer().new("manytoone.ChildUUID");
		var simple2 = 0;
		var child2 = getTransfer().new("manytoone.ChildUUID");

		getTransfer().create(child);
		simple.setChild(child);

		getTransfer().create(simple);

		//for next test
		assertSameBasic(child, simple.getChild());

		getTransfer().discard(simple);

		simple2 = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

		simple.setString("iiiii");

		getTransfer().save(simple);

		assertEqualsBasic(simple.getIDSimple(), simple2.getIDSimple());
		assertEqualsBasic(simple.getString(), simple2.getString());

		assertSame("Child not the same", simple.getChild(), simple2.getChild());

		getTransfer().save(child2);

		simple.setChild(child2);

		getTransfer().save(simple);

		assertSame("Child2 not the same", simple.getChild(), simple2.getChild());
	</cfscript>
</cffunction>

<cffunction name="testCreateClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child =  getTransfer().new("manytoone.ChildUUID");
		var child2 =  getTransfer().new("manytoone.ChildUUID");
		var clone = 0;

		child.setDate("dogfog");

		getTransfer().save(child);

		simple.setChild(child);

		getTransfer().save(simple);

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

		getTransfer().save(child2);

		clone.setChild(child2);

		getTransfer().save(clone);

		AssertSame("sync failed", clone.getChild(), simple.getChild());

		simple.removeChild();

		clone = simple.clone();

		assertFalse(clone.hasChild());

		simple.setChild(child2);

		getTransfer().save(simple);

		clone = simple.clone();

		clone.removeChild();

		getTransfer().save(clone);

		AssertFalse(simple.hasChild(), "This child should not be here");
	</cfscript>
</cffunction>

<cffunction name="testDiscardedChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child =  getTransfer().new("manytoone.ChildUUID");
		var reget = 0;

		getTransfer().save(child);
		getTransfer().discard(child);

		simple.setChild(child);

		getTransfer().save(child);

		reget = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

		assertNotSameBasic("create:same", simple, reget);

		simple = reget;

		child =  getTransfer().new("manytoone.ChildUUID");
		getTransfer().save(child);

		getTransfer().discard(child);

		simple.setChild(child);

		getTransfer().save(child);

		reget = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

		assertNotSameBasic("update:same", simple, reget);
	</cfscript>
</cffunction>

<cffunction name="testUpdate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var qAmount = 0;
		var lnkIDChild = 0;
		var simple =  getTransfer().new("manytoone.SimpleUUID");

		var child = getTransfer().new("manytoone.ChildUUID");

		simple.setChild(child);
		getTransfer().save(child);
		getTransfer().save(simple);
	</cfscript>

	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select lnkIDChild
		from
		tbl_manytooneuuid
		where
		IDSimple = <cfqueryparam value="#simple.getIDSimple()#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>

	<cfscript>
		child = getTransfer().new("manytoone.ChildUUID");

		lnkIDChild = qAmount.lnkIDChild;

		getTransfer().create(child);

		simple.setChild(child);

		getTransfer().update(simple);
	</cfscript>

	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select lnkIDChild
		from
		tbl_manytooneuuid
		where
		IDSimple = <cfqueryparam value="#simple.getIDSimple()#" cfsqltype="CF_SQL_VARCHAR">
	</cfquery>

	<cfscript>
		assertTrueBasic(lnkIDChild neq qAmount.lnkIDChild);

		//added this in, as automatic updates on
		//cached objects has now been removed. **cached
		simple.removeChild(child);

		getTransfer().save(simple);

		getTransfer().delete(child);

		assertFalseBasic(simple.hasChild());
	</cfscript>
</cffunction>

<cffunction name="testDelete" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var qAmount = 0;
		var lnkIDChild = 0;

		var child = getTransfer().new("manytoone.ChildUUID");
		var simple = getTransfer().new("manytoone.SimpleUUID");

		simple.setChild(child);
		getTransfer().save(child);
		getTransfer().save(simple);
	</cfscript>

	<!--- see if the amount is less --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_manytooneuuid
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransfer().delete(simple);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_manytooneuuid
	</cfquery>
	<cfscript>
		assertEqualsBasic(count - 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testCascade" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child =  getTransfer().new("manytoone.ChildUUID");
		var simple2 = 0;
		var child2 = getTransfer().new("manytoone.ChildUUID");

		getTransfer().cascadeCreate(child);

		assertTrue(child.getIsPersisted(), "child should be persisted after save");

		simple.setChild(child);

		getTransfer().cascadeSave(simple);

		assertTrue(simple.getIsPersisted(), "simple should be persisted after save");

		//for next test
		assertSameBasic(child, simple.getChild());

		getTransfer().discard(simple);

		simple2 = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

		simple.setString("iiiii");

		getTransfer().cascadeUpdate(simple);

		assertEqualsBasic(simple.getIDSimple(), simple2.getIDSimple());
		assertEqualsBasic(simple.getString(), simple2.getString());

		assertSame("Child not the same", simple.getChild(), simple2.getChild());

		getTransfer().cascadeSave(child2);

		simple.setChild(child2);

		getTransfer().cascadeSave(simple);

		assertSame("Child2 not the same", simple.getChild(), simple2.getChild());

		getTransfer().cascadeDelete(simple);

		simple2 = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

		assertFalse(simple2.getIsPersisted(), "simple should be deleted");
	</cfscript>
</cffunction>

<cffunction name="testCascadeLazy" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransferB().new("manytoone.SimpleUUID");
		var child =  getTransferB().new("manytoone.ChildUUID");
		var simple2 = 0;
		var child2 = getTransferB().new("manytoone.ChildUUID");

		getTransferB().cascadeCreate(child);

		assertTrue(child.getIsPersisted(), "child should be persisted after save");

		simple.setChild(child);

		getTransferB().cascadeSave(simple);

		assertTrue(simple.getIsPersisted(), "simple should be persisted after save");

		//for next test
		assertSameBasic(child, simple.getChild());

		getTransferB().discard(simple);

		simple2 = getTransferB().get("manytoone.SimpleUUID", simple.getIDSimple());

		simple.setString("iiiii");

		getTransferB().cascadeUpdate(simple);

		assertEqualsBasic(simple.getIDSimple(), simple2.getIDSimple());
		assertEqualsBasic(simple.getString(), simple2.getString());

		assertSame("Child not the same", simple.getChild(), simple2.getChild());

		getTransferB().cascadeSave(child2);

		simple.setChild(child2);

		getTransferB().cascadeSave(simple);

		assertSame("Child2 not the same", simple.getChild(), simple2.getChild());

		child = simple2.getChild();

		println("childid = " & child.getIDChild());

		getTransferB().discardAll();

		simple = getTransferB().get("manytoone.SimpleUUID", simple2.getIDSimple());

		getTransferB().cascadeDelete(simple);

		simple2 = getTransferB().get("manytoone.SimpleUUID", simple.getIDSimple());

		assertFalse(simple2.getIsPersisted(), "simple should be deleted");

		child = getTransferB().get("manytoone.ChildUUID", child.getIDChild());

		assertFalse(child.getIsPersisted(), "child should be deleted");
	</cfscript>
</cffunction>

</cfcomponent>