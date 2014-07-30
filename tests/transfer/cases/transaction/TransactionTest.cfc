<cfcomponent name="TransactionTest" extends="test.transfer.cases.BaseCase">

<cffunction name="setup" hint="setup a transacion object" access="public" returntype="void" output="false">
	<cfscript>
		variables.trans = application.transferFactoryC.getTransaction();
	</cfscript>
</cffunction>

<cffunction name="testBasicSQL" hint="" access="public" returntype="void" output="false">
	<cfscript>
		assertFalse(variables.trans.getInTransaction(), "shouldn't be in transaction(1)");

		variables.trans.execute(this, "clearTBLA");

		assertFalse(variables.trans.getInTransaction(), "shouldn't be in transaction(2)");
		assertCount(0);
	</cfscript>
</cffunction>

<cffunction name="testRollback" hint="testing what happens when a rollback fails" access="public" returntype="void" output="false">
	<cfscript>
		var query = 0;
		var failed = false;
		clearTBLA();

		assertFalse(variables.trans.getInTransaction(), "shouldn't be in transaction(1)'");

		assertCount(0, "just cleared");

		try
		{
			variables.trans.execute(this, "insertFail");
		}
		catch(Erk exc)
		{
			failed = true;
		}

		assertFalse(variables.trans.getInTransaction(), "shouldn't be in transaction(2)");

		assertTrue(failed, "i didn't fail");

		assertCount(0, "after rollback");
	</cfscript>
</cffunction>

<cffunction name="testNestingTransactions" hint="" access="public" returntype="void" output="false">
	<cfscript>
		clearTBLA();
		assertCount(0);

		variables.trans.execute(this, "transactInsert");

		assertCount(1);
	</cfscript>
</cffunction>

<cffunction name="testAOPBasicSQL" hint="" access="public" returntype="void" output="false">
	<cfscript>
		variables.trans.advise(this, clearTBLA);
		clearTBLA();
		assertCount(0);
	</cfscript>
</cffunction>

<cffunction name="testAOPRollback" hint="testing what happens when a rollback fails" access="public" returntype="void" output="false">
	<cfscript>
		var query = 0;
		var failed = false;
		clearTBLA();

		variables.trans.advise(this, insertFail);

		assertCount(0, "just cleared");

		try
		{
			insertFail();
		}
		catch(Erk exc)
		{
			failed = true;
		}

		assertFalse(variables.trans.getInTransaction(), "shouldn't be in transaction(2)");

		assertTrue(failed, "i didn't fail");

		assertCount(0, "after rollback");
	</cfscript>
</cffunction>

<cffunction name="testAOPNestingTransactions" hint="" access="public" returntype="void" output="false">
	<cfscript>
		clearTBLA();
		assertCount(0);

		variables.trans.advise(this, transactInsert);

		transactInsert();

		assertCount(1);
	</cfscript>
</cffunction>

<cffunction name="testAOPNestingAOPTransactions" hint="" access="public" returntype="void" output="false">
	<cfscript>
		clearTBLA();
		assertCount(0);

		variables.trans.advise(this, insertTBLA);
		variables.trans.advise(this, transactAOPInsert);

		transactInsert();

		assertCount(1);
	</cfscript>
</cffunction>

<cffunction name="testAOPPatternBasicSQL" hint="" access="public" returntype="void" output="false">
	<cfscript>
		variables.trans.advise(this, "^clearTBLA");
		clearTBLA();
		assertCount(0);
	</cfscript>
</cffunction>

<cffunction name="testAOPPatternRollback" hint="testing what happens when a rollback fails" access="public" returntype="void" output="false">
	<cfscript>
		var query = 0;
		var failed = false;
		clearTBLA();

		variables.trans.advise(this, "^insertFail");

		assertCount(0, "just cleared");

		try
		{
			insertFail();
		}
		catch(Erk exc)
		{
			failed = true;
		}

		assertFalse(variables.trans.getInTransaction(), "shouldn't be in transaction(2)");

		assertTrue(failed, "i didn't fail");

		assertCount(0, "after rollback");
	</cfscript>
</cffunction>

<cffunction name="testAOPPatternNestingAOPTransactions" hint="" access="public" returntype="void" output="false">
	<cfscript>
		clearTBLA();
		assertCount(0);

		variables.trans.advise(this, "^insertTBLA", true);
		variables.trans.advise(this, "^transactAOPInsert", true);

		transactInsert();

		assertCount(1);
	</cfscript>
</cffunction>

<cffunction name="testObjectCommit" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var arr = ArrayNew(1);
		var reget = 0;

		trans.advise(this, saveAll);

		arr[1] = getTransferC().new("BasicUUID");
		arr[2] = getTransferC().new("BasicUUID");
		arr[3] = getTransferC().new("BasicUUID");

		saveAll(arr);

		reget = getTransferC().get("BasicUUID", arr[1].getIDBasic());
		assertSame("arr 1 should be same", reget, arr[1]);

		reget = getTransferC().get("BasicUUID", arr[2].getIDBasic());
		assertSame("arr 2 should be same", reget, arr[2]);

		reget = getTransferC().get("BasicUUID", arr[3].getIDBasic());
		assertSame("arr 2 should be same", reget, arr[3]);
	</cfscript>
</cffunction>

<cffunction name="testObjectInsertRollback" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var arr = ArrayNew(1);
		var reget = 0;
		var check = false;

		trans.advise(this, saveAllFail);

		arr[1] = getTransferC().new("BasicUUID");
		arr[2] = getTransferC().new("BasicUUID");
		arr[3] = getTransferC().new("BasicUUID");

		try
		{
			saveAllFail(arr);
		}
		catch(Erk exc)
		{
			check = true;
		}

		assertTrue(check, "not fail?");

		reget = getTransferC().get("BasicUUID", arr[1].getIDBasic());
		assertNotSame("arr 1 should not be same", reget, arr[1]);
		assertFalse(reget.getIsPersisted(), "1 persisted");

		reget = getTransferC().get("BasicUUID", arr[2].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[2]);
		assertFalse(reget.getIsPersisted(), "2 persisted");

		reget = getTransferC().get("BasicUUID", arr[3].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[3]);
		assertFalse(reget.getIsPersisted(), "3 persisted");
	</cfscript>
</cffunction>

<cffunction name="testObjectUpdateRollback" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var arr = ArrayNew(1);
		var reget = 0;
		var check = false;

		trans.advise(this, saveAllFail);

		arr[1] = getTransferC().new("BasicUUID");
		arr[2] = getTransferC().new("BasicUUID");
		arr[3] = getTransferC().new("BasicUUID");

		saveAll(arr);

		//make them dirty
		arr[1].setNumericValue(9);
		arr[2].setNumericValue(9);
		arr[3].setNumericValue(9);

		try
		{
			saveAllFail(arr);
		}
		catch(Erk exc)
		{
			check = true;
		}

		assertTrue(check, "not fail?");

		reget = getTransferC().get("BasicUUID", arr[1].getIDBasic());
		assertNotSame("arr 1 should not be same", reget, arr[1]);
		assertTrue(reget.getIsPersisted(), "1 not persisted");

		reget = getTransferC().get("BasicUUID", arr[2].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[2]);
		assertTrue(reget.getIsPersisted(), "2 not persisted");

		reget = getTransferC().get("BasicUUID", arr[3].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[3]);
		assertTrue(reget.getIsPersisted(), "3 not persisted");
	</cfscript>
</cffunction>

<cffunction name="testObjectDeleteCommit" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var arr = ArrayNew(1);
		var reget = 0;
		var check = false;

		trans.advise(this, deleteAll);

		arr[1] = getTransferC().new("BasicUUID");
		arr[2] = getTransferC().new("BasicUUID");
		arr[3] = getTransferC().new("BasicUUID");

		saveAll(arr);

		deleteAll(arr);

		reget = getTransferC().get("BasicUUID", arr[1].getIDBasic());
		assertNotSame("arr 1 should not be same", reget, arr[1]);
		assertFalse(reget.getIsPersisted(), "1 persisted");

		reget = getTransferC().get("BasicUUID", arr[2].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[2]);
		assertFalse(reget.getIsPersisted(), "2 persisted");

		reget = getTransferC().get("BasicUUID", arr[3].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[3]);
		assertFalse(reget.getIsPersisted(), "3 persisted");
	</cfscript>
</cffunction>

<cffunction name="testObjectDeleteRollback" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var arr = ArrayNew(1);
		var reget = 0;
		var check = false;

		trans.advise(this, deleteAllFail);

		arr[1] = getTransferC().new("BasicUUID");
		arr[2] = getTransferC().new("BasicUUID");
		arr[3] = getTransferC().new("BasicUUID");

		saveAll(arr);

		try
		{
			deleteAllFail(arr);
		}
		catch(Erk exc)
		{
			check = true;
		}

		assertTrue(check, "not fail?");

		reget = getTransferC().get("BasicUUID", arr[1].getIDBasic());
		assertNotSame("arr 1 should not be same", reget, arr[1]);
		assertTrue(reget.getIsPersisted(), "1 not persisted");

		reget = getTransferC().get("BasicUUID", arr[2].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[2]);
		assertTrue(reget.getIsPersisted(), "2 not persisted");

		reget = getTransferC().get("BasicUUID", arr[3].getIDBasic());
		assertNotSame("arr 2 should not be same", reget, arr[3]);
		assertTrue(reget.getIsPersisted(), "3 not persisted");
	</cfscript>
</cffunction>

<cffunction name="testObjectDeleteRecycleRollback" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var arr = ArrayNew(1);
		var reget = 0;
		var check = false;
		var id1 =0;
		var id2 = 0;
		var id3 = 0;

		trans.advise(this, deleteAllRecycleFail);

		arr[1] = getTransferC().new("BasicUUID");
		arr[2] = getTransferC().new("BasicUUID");
		arr[3] = getTransferC().new("BasicUUID");

		saveAll(arr);

		id1 = arr[1].getIDBasic();
		id2 = arr[2].getIDBasic();
		id3 = arr[3].getIDBasic();


		try
		{
			deleteAllRecycleFail(arr);
		}
		catch(Erk exc)
		{
			check = true;
		}

		assertTrue(check, "not fail?");

		reget = getTransferC().get("BasicUUID", id1);
		assertNotSame("arr 1 should not be same", reget, arr[1]);
		assertTrue(reget.getIsPersisted(), "1 not persisted");

		reget = getTransferC().get("BasicUUID", id2);
		assertNotSame("arr 2 should not be same", reget, arr[2]);
		assertTrue(reget.getIsPersisted(), "2 not persisted");

		reget = getTransferC().get("BasicUUID", id3);
		assertNotSame("arr 2 should not be same", reget, arr[3]);
		assertTrue(reget.getIsPersisted(), "3 not persisted");
	</cfscript>
</cffunction>

<!--- helper functions / executed functions --->

<cffunction name="clearTBLA" hint="" access="private" returntype="void" output="false">
	<cfquery name="qSelect" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		DELETE FROM
		tbl_a
	</cfquery>
</cffunction>

<cffunction name="insertTBLA" hint="" access="private" returntype="void" output="false">
	<cfscript>
		var query = 0;
	</cfscript>
	<cfquery name="qSelect" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		INSERT INTO tbl_a
		(a_id)
		VALUES
		(<cfqueryparam value="#createUUID()#" cfsqltype="cf_sql_varchar">)
	</cfquery>

	<cfscript>
		assertCount(1);
	</cfscript>
</cffunction>

<cffunction name="insertFail" hint="" access="private" returntype="void" output="false">
	<cfscript>
		insertTBLA();
	</cfscript>
	<cfthrow type="Erk">
</cffunction>

<cffunction name="transactInsert" hint="" access="private" returntype="void" output="false">
	<cfscript>
		assertTrue(1, variables.trans.getInTransaction(), "should be in a transaction");

		variables.trans.execute(this, "insertTBLA");
	</cfscript>
</cffunction>

<cffunction name="transactAOPInsert" hint="" access="private" returntype="void" output="false">
	<cfscript>
		assertTrue(1, variables.trans.getInTransaction(), "should be in a transaction");

		insertTBLA();
	</cfscript>
</cffunction>

<cffunction name="saveAll" hint="" access="private" returntype="void" output="false">
	<cfargument name="all" hint="" type="array" required="Yes">
	<cfscript>
		var len = ArrayLen(arguments.all);
		var counter = 1;
		for(; counter lte len; counter = counter + 1)
		{
			getTransferC().save(arguments.all[counter]);
		}
	</cfscript>
</cffunction>

<cffunction name="saveAllFail" hint="" access="private" returntype="void" output="false">
	<cfargument name="all" hint="" type="array" required="Yes">
	<cfscript>
		saveAll(arguments.all);
	</cfscript>
	<cfthrow type="Erk">
</cffunction>

<cffunction name="deleteAll" hint="" access="private" returntype="void" output="false">
	<cfargument name="all" hint="" type="array" required="Yes">
	<cfscript>
		var len = ArrayLen(arguments.all);
		var counter = 1;
		for(; counter lte len; counter = counter + 1)
		{
			getTransferC().delete(arguments.all[counter]);
		}
	</cfscript>
</cffunction>

<cffunction name="deleteAllRecycleFail" hint="" access="private" returntype="void" output="false">
	<cfargument name="all" hint="" type="array" required="Yes">
	<cfscript>
		var len = ArrayLen(arguments.all);
		var counter = 1;

		deleteAll(arguments.all);
		for(; counter lte len; counter = counter + 1)
		{
			getTransferC().recycle(arguments.all[counter]);
		}
	</cfscript>
	<cfthrow type="Erk">
</cffunction>

<cffunction name="deleteAllFail" hint="" access="private" returntype="void" output="false">
	<cfargument name="all" hint="" type="array" required="Yes">
	<cfscript>
		deleteAll(arguments.all);
	</cfscript>
	<cfthrow type="Erk">
</cffunction>

<cffunction name="assertCount" hint="" access="private" returntype="void" output="false">
	<cfargument name="count" hint="" type="numeric" required="Yes">
	<cfargument name="msg" hint="" type="string" required="No" default="">
	<cfscript>
		var query = 0;
	</cfscript>
	<cfquery name="query" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select count(*) as c
		from
		tbl_a
	</cfquery>
	<cfscript>
		AssertEquals("should be #arguments.count# : #arguments.msg#", arguments.count, query.c);
	</cfscript>
</cffunction>

</cfcomponent>