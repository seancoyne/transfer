<cfcomponent name="CRUDTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("null.Basic");

		assertEqualsBasic(basic.getClassName(), "null.Basic");
	</cfscript>
</cffunction>

<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("null.Basic");
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
		basic = getTransfer().new("null.Basic");

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

<cffunction name="testEdit" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("null.Basic");

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
		var basic = getTransfer().new("null.Basic");
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
		assertEqualsBasic(count - 1, qAmount.amount);
	</cfscript>
</cffunction>

<cffunction name="testGetFailIsEmpty" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("null.Basic");
		var getBasic = 0;

		getBasic = getTransfer().get("null.Basic", -1);

		assertEqualsBasic(getBasic.getIDBasic(), 0);
	</cfscript>
</cffunction>

<cffunction name="testReGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("null.Basic");
		var getBasic = 0;
		getTransfer().create(basic);

		getBasic = getTransfer().get("null.Basic", basic.getIDBasic());

		assertSameBasic(basic, getBasic);
	</cfscript>
</cffunction>

<cffunction name="testGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("null.Basic");
		var getBasic = 0;
		getTransfer().create(basic);

		getTransfer().discard(basic);

		getBasic = getTransfer().get("null.Basic", basic.getIDBasic());

		assertEqualsBasic(basic.getIDBasic(), getBasic.getIDBasic());
	</cfscript>
</cffunction>

<cffunction name="testInsertNull" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransfer().new("null.Basic");
		var qBasic = 0;

		basic.setDateNull();

		assertTrue(basic.getDateIsNull());
		assertEqualsBasic(createDate(1200, 12, 12), basic.getDate());

		basic.setNumericNull();

		assertTrue(basic.getNumericIsNull());
		assertEquals("on set", -256, basic.getNumeric());

		basic.setStringNull();

		assertTrue(basic.getStringIsNull());
		assertEqualsBasic("::NULL::", basic.getString());

		basic.setUUIDNull();

		assertTrue(basic.getUUIDIsNull());
		assertEqualsBasic("10000000-0000-0000-0000000000000000", basic.getUUID());

		basic.setBooleanNull();

		assertTrue(basic.getBoolean(), "-1 boolean value?");
		assertTrue(basic.getBooleanIsNull(), "boolean: should be null");

		//insert
		getTransfer().save(basic);

		qBasic = getTransfer().listByProperty(className="null.Basic", propertyName="IDBasic", propertyValue=basic.getIDBasic(), useAliases=false);

		assertEquals("date", "", qBasic.basic_date);
		assertEquals("numeric", "", qBasic.basic_numeric);
		assertEquals("string", "", qBasic.basic_string);
		assertEquals("UUID", "", qBasic.basic_UUID);
		assertEquals("boolean", "", qBasic.basic_boolean);

		getTransfer().discard(basic);

		basic = getTransfer().get("null.Basic", basic.getIDBasic());

		assertTrue(basic.getDateIsNull());
		assertEqualsBasic(createDate(1200, 12, 12), basic.getDate());

		assertTrue(basic.getNumericIsNull());
		assertEquals("on reget", -256, basic.getNumeric());

		assertTrue(basic.getStringIsNull());
		assertEqualsBasic("::NULL::", basic.getString());

		assertTrue(basic.getUUIDIsNull());
		assertEqualsBasic("10000000-0000-0000-0000000000000000", basic.getUUID());

		//update
		basic.setUUID(createUUID());
		basic.setUUIDNull();

		getTransfer().discard(basic);

		basic = getTransfer().get("null.Basic", basic.getIDBasic());

		assertTrue(basic.getDateIsNull());
		assertEqualsBasic(createDate(1200, 12, 12), basic.getDate());

		assertTrue(basic.getNumericIsNull());
		assertEquals("on update", -256, basic.getNumeric());

		assertTrue(basic.getStringIsNull());
		assertEqualsBasic("::NULL::", basic.getString());

		assertTrue(basic.getUUIDIsNull());
		assertEqualsBasic("10000000-0000-0000-0000000000000000", basic.getUUID());
	</cfscript>
</cffunction>

</cfcomponent>