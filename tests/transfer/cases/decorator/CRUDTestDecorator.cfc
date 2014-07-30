<cfcomponent name="CRUDTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testNew" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferB().new("Basic");

		assertEqualsBasic(basic.getClassName(), "Basic");

		basic.setString("fred");

		assertEqualsBasic(basic.getString(), "Decorator");
	</cfscript>
</cffunction>

<cffunction name="testDatsourceTransaction" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferB().new("Basic");

		AssertTrue(basic.executeQuery());
	</cfscript>
</cffunction>

<cffunction name="testGetClone" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferB().new("Basic");
		var clone = 0;

		basic.setString("I am original");

		getTransferB().create(basic);

		clone = basic.clone();

		assertTrue(clone.getIsClone(), "I'm not a clone?");
		assertTrue(clone.getIsPersisted(), "I'm not persisted?");
		assertFalse(clone.getIsDirty(), "I'm a dirty dirty whore");

		AssertNotSameBasic(basic, clone);
		AssertEqualsBasic(basic.getString(), clone.getString());

		clone.setString("I am clone");

		getTransferB().save(clone);

		AssertEquals("arg! clone not sync'd'", basic.getString(), clone.getString());
	</cfscript>
</cffunction>


<cffunction name="testCreate" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferB().new("Basic");
		var count = 0;

		var qAmount = 0;

		basic.setBoolean(RandRange(0,1));
	</cfscript>
	<!--- see if the amount is more --->
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransferB().create(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
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

		basic = getTransferB().new("Basic");

		basic.setBoolean(RandRange(0,1));

		try
		{
			//lets try creating it twice
			getTransferB().create(basic);
			getTransferB().create(basic);
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
		var basic = getTransferB().new("Basic");

		var qSelect = 0;

		getTransferB().create(basic);

		basic.setString("george");

		basic.setBoolean(RandRange(0,1));

		getTransferB().update(basic);
	</cfscript>
	<cfquery name="qSelect" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select basic_string
		from
		tbl_basic
		where
		idbasic = <cfqueryparam value="#basic.getIDBasic()#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfscript>
		assertEqualsBasic(qSelect.basic_string, "Decorator");

		basic = getTransferB().new("Basic");

		getTransferB().save(basic);

		getTransferB().discard(basic);

		getTransferB().recycle(basic);
	</cfscript>
</cffunction>

<cffunction name="testDelete" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferB().new("Basic");
		var count = 0;

		var qAmount = 0;
		getTransferB().create(basic);
	</cfscript>
	<!--- see if the amount is less --->
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
		select count(*) as amount
		from
		tbl_basic
	</cfquery>

	<cfscript>
		count = qAmount.amount;
		getTransferB().delete(basic);
	</cfscript>
	<cfquery name="qAmount" datasource="#getDatasourceB().getName()#" username="#getDatasourceB().getUsername()#" password="#getDatasourceB().getUsername()#">
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
		var basic = getTransferB().new("Basic");
		var getBasic = 0;

		getBasic = getTransferB().get("Basic", -1);

		assertEqualsBasic(getBasic.getIDBasic(), 0);
	</cfscript>
</cffunction>

<cffunction name="testReGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferB().new("Basic");
		var getBasic = 0;
		getTransferB().create(basic);

		getBasic = getTransferB().get("Basic", basic.getIDBasic());

		assertSameBasic(basic, getBasic);
	</cfscript>
</cffunction>

<cffunction name="testGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferB().new("Basic");
		var getBasic = 0;
		getTransferB().create(basic);

		getTransferB().discard(basic);

		getBasic = getTransferB().get("Basic", basic.getIDBasic());

		assertEqualsBasic(basic.getIDBasic(), getBasic.getIDBasic());
	</cfscript>
</cffunction>

<cffunction name="testEquals" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic1 = getTransferB().new("Basic");
		var basic2 = getTransferB().new("Basic");

		assertTrue(basic1.sameTransfer(basic1), "These should be the same");
		assertFalse(basic2.sameTransfer(basic1) ,"These should not be the same");
		assertTrue(basic1.equalsTransfer(basic1), "These should be equal");
		assertFalse(basic2.equalsTransfer(basic1), "These should not be equal");
	</cfscript>
</cffunction>


</cfcomponent>