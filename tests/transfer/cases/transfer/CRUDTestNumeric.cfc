<cfcomponent name="CRUDTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");

		assertEqualsBasic(basic.getClassName(), "Basic");
	</cfscript>
</cffunction>

<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var count = 0;

		var qAmount = 0;

		basic.setBoolean(RandRange(0,1));
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransfer().create(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>
	<cfscript>
		assertEqualsBasic(count + 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testCreateTwiceFail" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = 0;
		var check = false;

		initTransfer();
		basic = getTransfer().new("Basic");

		basic.setBoolean(RandRange(0,1));

		try
		{
			//lets try creating it twice
			getTransfer().create(basic);
			getTransfer().create(basic);
		}
		catch(transfer.com.exception.ObjectAlreadyCreatedException exc)
		{
			check = true;
		}

		AssertTrue(check, "Object created twice.");
	</cfscript>
</cffunction>

<cffunction name="testCreateSequenceTable" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = 0;
	</cfscript>

	<cftransaction>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		drop table transfer_sequence
	</cfquery>
	</cftransaction>

	<cfscript>
		initTransfer();

		basic = getTransfer().new("Basic");
		getTransfer().create(basic);
	</cfscript>
</cffunction>

<cffunction name="testEdit" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");

		var qSelect = 0;

		getTransfer().create(basic);

		basic.setString("george");

		basic.setBoolean(RandRange(0,1));

		getTransfer().update(basic);
	</cfscript>
	<cfquery name="qSelect" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select basic_string
		from
		tbl_basic
		where
		idbasic = <cfqueryparam value="#basic.getIDBasic()#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfscript>
		assertEqualsBasic(qSelect.basic_string, basic.getString());
	</cfscript>
</cffunction>

<cffunction name="testDelete" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var count = 0;

		var qAmount = 0;
		getTransfer().create(basic);
	</cfscript>
	<!--- see if the amount is less --->
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransfer().delete(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>
	<cfscript>
		assertEquals("Basic wasn't deleted properly", count - 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testGetFailIsEmpty" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var getBasic = 0;

		getBasic = getTransfer().get("Basic", -1);

		assertEqualsBasic(getBasic.getIDBasic(), 0);
	</cfscript>
</cffunction>

<cffunction name="testReGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var getBasic = 0;
		getTransfer().create(basic);

		getBasic = getTransfer().get("Basic", basic.getIDBasic());

		assertSameBasic(basic, getBasic);
	</cfscript>
</cffunction>

<cffunction name="testGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var getBasic = 0;
		var dec = 3.5678;
		var int = 8;

		basic.setBoolean(false);

		basic.setString("decimal");
		basic.setDecimal(dec);
		basic.setNumeric(int);

		getTransfer().create(basic);

		assertEquals("return value decimal", dec, basic.getDecimal());
		assertEquals("return value int", int, basic.getNumeric());

		getBasic = getTransfer().get("Basic", basic.getIDBasic());
		assertSame("should be the same from cache", basic, getBasic);

		assertEqualsBasic(basic.getIDBasic(), getBasic.getIDBasic());
		assertFalseBasic(getBasic.getBoolean());

		getTransfer().discard(basic);

		getBasic = getTransfer().get("Basic", basic.getIDBasic());

		assertEqualsBasic(basic.getIDBasic(), getBasic.getIDBasic());

		assertFalseBasic(getBasic.getBoolean());

		basic.setString("1234");

		assertEquals("reget value decimal", dec, getBasic.getDecimal());
		assertEquals("reget value int", int, getBasic.getNumeric());

		getTransfer().save(basic);

		assertEquals("sync should occur", basic.getString(), getBasic.getString());
	</cfscript>
</cffunction>

<cffunction name="testGetClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("Basic");
		var clone = 0;

		basic.setString("I am original");

		getTransfer().create(basic);

		clone = basic.clone();

		assertTrue(clone.getIsClone(), "I'm not a clone?");
		assertTrue(clone.getIsPersisted(), "I'm not persisted?");
		assertFalse(clone.getIsDirty(), "I'm a dirty dirty whore");

		AssertNotSameBasic(basic, clone);
		AssertEqualsBasic(basic.getString(), clone.getString());

		clone.setString("I am clone");

		getTransfer().save(clone);

		AssertEquals("arg! clone not sync'd'", basic.getString(), clone.getString());
	</cfscript>
</cffunction>

</cfcomponent>