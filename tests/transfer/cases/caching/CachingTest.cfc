<cfcomponent name="AutoGenerateTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testDiscard" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var autoGenerate = getTransfer().new("AutoGenerate");
		var auto2 = 0;
		var query = QueryNew("idgenerate");
		var array = arrayNew(1);

		getTransfer().save(AutoGenerate);

		getTransfer().discard(autoGenerate);

		auto2 = getTransfer().get("AutoGenerate", autoGenerate.getIDGenerate());

		assertNotSameBasic(auto2, autoGenerate);

		getTransfer().discardByClassAndKey("AutoGenerate", autoGenerate.getIDGenerate());

		autoGenerate = getTransfer().get("AutoGenerate", autoGenerate.getIDGenerate());

		assertNotSameBasic(auto2, autoGenerate);

		autoGenerate = getTransfer().new("AutoGenerate");
		getTransfer().save(AutoGenerate);

		QueryAddRow(query);
		QuerySetCell(query, "idgenerate",autoGenerate.getIDGenerate());

		autoGenerate = getTransfer().new("AutoGenerate");
		getTransfer().save(autoGenerate);

		QueryAddRow(query);
		QuerySetCell(query, "idgenerate",autoGenerate.getIDGenerate());

		getTransfer().discardByClassAndKeyQuery("AutoGenerate", query, "idgenerate");

		auto2 = getTransfer().get("AutoGenerate", autoGenerate.getIDGenerate());

		assertNotSame("query discard: ", auto2, autoGenerate);

		autoGenerate = getTransfer().new("AutoGenerate");
		getTransfer().save(AutoGenerate);

		arrayAppend(array, autoGenerate.getIDGenerate());

		autoGenerate = getTransfer().new("AutoGenerate");
		getTransfer().save(autoGenerate);

		arrayAppend(array, autoGenerate.getIDGenerate());

		getTransfer().discardByClassAndKeyArray("AutoGenerate", array);

		auto2 = getTransfer().get("AutoGenerate", autoGenerate.getIDGenerate());

		assertNotSame("query discard: ", auto2, autoGenerate);
	</cfscript>
</cffunction>

<cffunction name="testDiscardAll" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var autoGenerate = getTransfer().new("AutoGenerate");
		var simple = getTransfer().new("onetomany.Basic");
		var auto2 = 0;
		var query = QueryNew("idgenerate");
		var array = arrayNew(1);

		getTransfer().save(AutoGenerate);
		getTransfer().save(simple);

		getTransfer().discardAll();

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());
		auto2 = getTransfer().get("AutoGenerate", autoGenerate.getIDGenerate());

		assertNotSameBasic("auto2", auto2, autoGenerate);
		assertNotSameBasic("simple", simple, reget);
	</cfscript>
</cffunction>

<cffunction name="testDiscardChild1" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var children = 0;
		var reget = 0;

		getTransfer().save(simple);

		child.setParentBasic(simple);

		getTransfer().save(child);

		reget = getTransfer().get("onetomany.Child", child.getIDChild());

		assertSame("Child : #child.getIDChild()# != reget: #reget.getIDChild()#", child, reget);

		getTransfer().discard(child);

		reget = getTransfer().get("onetomany.Child", child.getIDChild());

		AssertNotSame("child should be different (1)", child, reget);

		reget = getTransfer().get("onetomany.Basic", simple.getIDBasic());

		assertSameBasic(simple, reget);

		AssertNotSame("child should be different (2)", child, simple.getChild(1));
	</cfscript>
</cffunction>

<cffunction name="testDiscardParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");
		var children = 0;
		var reget = 0;

		getTransfer().save(simple);

		child.setParentBasic(simple);

		getTransfer().save(child);

		reget = getTransfer().get("onetomany.Child", child.getIDChild());

		assertSame("Child : #child.getIDChild()# != reget: #reget.getIDChild()#", child, reget);

		getTransfer().discard(simple);

		sleep(5000);

		AssertFalse(child.getParentBasicIsLoaded(), "should not be loaded");

		reget = getTransfer().get("onetomany.Child", child.getIDChild());

		assertSame("child should be different", child, reget);

		assertNotSame("child parent should be different", child.getParentBasic(), simple);
	</cfscript>
</cffunction>

<cffunction name="testDiscardChild2" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytoone.SimpleUUID");
		var child = getTransfer().new("manytoone.ChildUUID");
		var children = 0;
		var reget = 0;

		getTransfer().save(child);

		simple.setChild(child);

		getTransfer().save(simple);

		reget = getTransfer().get("manytoone.ChildUUID", child.getIDChild());

		assertSame("Child : #child.getIDChild()# != reget: #reget.getIDChild()#", child, reget);

		getTransfer().discard(child);

		reget = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

		//the parents should be the same
		assertSameBasic(simple, reget);

		AssertNotSame("child shoud be different", child, reget.getChild());
	</cfscript>
</cffunction>

<cffunction name="testManyToManyChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var simple = getTransfer().new("manytomany.SimpleUUID");
		var count = 0;
		var reget = 0;

		var qAmount = 0;
		var child = 0;
		var child1 = 0;
		var child2 = 0;
		var counter = 1;

		//add five children
		for(; counter lte 5; counter = counter + 1)
		{
			child = getTransfer().new("BasicUUID");
			child.setNumeric(RandRange(1, 9999));
			getTransfer().create(child);

			simple.addChildren(child);
		}

		simple.sortChildren();

		getTransfer().cascadeSave(simple);

		child1 = simple.getChildren(1);
		child2 = simple.getChildren(2);

	 	getTransfer().discard(simple.getChildren(2));

		sleep(5000);

		reget = getTransfer().get("manytomany.SimpleUUID", simple.getIDSimple());

		assertSame("parent should be same", reget, simple);

		assertSame("child 1 should be same", child1, simple.getChildren(1));

		assertNotSame("child 2 should be different", child2, simple.getChildren(2));
	</cfscript>
</cffunction>

<cffunction name="testGarbageCollection" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var counter = 1;
		var objarray = arrayNew(1);
		var check = false;
		var autoGenerate = 0;
		var regetAuto = 0;

		autoGenerate = getTransfer().new("AutoGenerate");
		getTransfer().save(AutoGenerate);

		regetAuto = getTransfer().get("AutoGenerate", autogenerate.getIDGenerate());

		AssertSame("Should be the same object", autogenerate, regetAuto);

		//push one up for higher fitness
		for(counter = 1; counter lte 20; counter = counter + 1)
		{
			regetAuto = getTransfer().get("AutoGenerate", autogenerate.getIDGenerate());
		}

		for(counter = 1; counter lte 20; counter = counter + 1)
		{
			autoGenerate = getTransfer().new("AutoGenerate");
			getTransfer().save(AutoGenerate);

			autogenerate.uuid = createUUID();

			arrayAppend(objarray, autoGenerate);
		}

		for(counter = 1; counter lte 20; counter = counter + 1)
		{
			autoGenerate = objarray[counter];
			regetAuto = getTransfer().get("AutoGenerate", autoGenerate.getIDGenerate());

			if((NOT StructKeyExists(regetAuto, "uuid")) OR (regetAuto.uuid neq autoGenerate.uuid))
			{
				check = true;
			}
		}

		AssertTrue(check, "Garbage collection not run");
	</cfscript>
</cffunction>

<cffunction name="testPersistanceWorks" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var obj = getTransfer().new("Basic");
		var obj2 = 0;
		getTransfer().save(obj);

		obj2 = getTransfer().get("Basic", obj.getIDBasic());

		assertSameBasic(obj, obj2);
	</cfscript>
</cffunction>

<cffunction name="testNone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var object = getTransfer().new("none.Basic");
		var child = getTransfer().new("none.Child");
		var reget = 0;

		child.setParentBasic(object);

		getTransfer().save(object);
		getTransfer().save(child);

		reget = getTransfer().get("none.Basic", object.getIDBasic());

		assertNotSameBasic(object, reget);
		assertNotSameBasic(object.getChild(1), reget.getChild(1));
		assertNotSameBasic(child, reget.getChild(1));
		assertSameBasic(child, object.getChild(1));

		reget = getTransfer().get("none.Child", child.getIDChild());

		assertNotSameBasic(child, reget);

		object = getTransfer().new("none.Basic");

		getTransfer().save(object);

		getTransfer().discard(object);

		getTransfer().recycle(object);
	</cfscript>
</cffunction>

<cffunction name="testCleaningKeys" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var reget = 0;
	</cfscript>

	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		delete from tbl_basic
		where idBasic = <cfqueryparam value="200000" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfscript>
		basic.setIDBasic(200000.0000);

		getTransfer().save(basic);

		reget = getTransfer().get("Basic", 200000);

		AssertSame("200000", reget, basic);

		reget = getTransfer().get("Basic", 200000.000);

		AssertSame("20000.000", reget, basic);
	</cfscript>

	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		delete from tbl_basic
		where idBasic = <cfqueryparam value="200000" cfsqltype="cf_sql_numeric">
	</cfquery>
</cffunction>

<cffunction name="testCacheAccessedTimeout" hint="tests if a cache times out" access="public" returntype="void" output="false">
	<cfscript>
		var thread = createObject("java", "java.lang.Thread").currentThread();
		var basic = getTransferD().new("onetomany.One");
		var reget = 0;

		getTransferD().save(basic);

		threadSleep(30);

		reget = getTransferD().get("onetomany.One", basic.getID());

		AssertSame("should be same after 30 seconds", reget, basic);

		threadSleep(90);

		reget = getTransferD().get("onetomany.One", basic.getID());

		AssertNotSame("should not be same after 90 seconds", reget, basic);
	</cfscript>
</cffunction>

</cfcomponent>