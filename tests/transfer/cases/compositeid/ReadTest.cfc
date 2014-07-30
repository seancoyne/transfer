<cfcomponent extends="test.transfer.cases.BaseCase" output="false">


<cffunction name="testReadByProperty" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferD().new("Basic");
		var key = StructNew();
		var reget = 0;
		var uuid = CreateUUID();

		basic.setStringValue(uuid);
		basic.setNumericValue(3.000);

		getTransferD().save(basic);

		getTransferD().discardAll();

		reget = getTransferD().readByProperty("Basic", "stringValue", uuid);

		AssertEquals("UUID", basic.getUUID(), reget.getUUID());
		Assertequals("string", reget.getStringValue(), basic.getStringValue());
		Assertequals("numeric", basic.getNumericValue(), reget.getNumericValue());
		assertEquals("id", basic.getID(), reget.getID());

		AssertEquals("date", DateFormat(basic.getDateValue()), DateFormat(reget.getDateValue())); //because this can be weird
	</cfscript>
</cffunction>

<cffunction name="testReadByPropertyMap" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var one = getTransferD().new("onetomany.One");
		var two = getTransferD().new("onetomany.Two");
		var map = StructNew();
		var reget = 0;
		var uuid = createUUID();

		getTransferD().save(one);

		two.setParentOne(one);
		two.setStringValue(uuid);

		getTransferD().save(two);

		map.stringValue = uuid;

		reget = getTransferD().readByPropertyMap("onetomany.Two", map);

		AssertEquals("two: id", reget.getID(), two.getID());
		AssertEquals("two: string", reget.getStringValue(), two.getStringValue());
		AssertEquals("two: parent", reget.getParentOne().getId(), one.getID());
	</cfscript>
</cffunction>

<cffunction name="testReadByQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoone.John");
		var key = StructNew();
		var george = getTransferD().new("manytoone.George");
		var uuid = createUUID();
		var tql = "from manytoone.John as john where john.stringValue = :value";
		var query = getTransferD().createQuery(tql);
		var reget = 0;

		getTransferD().save(george);

		john.setStringValue(uuid);
		john.setGeorge(george);

		getTransferD().save(john);

		query.setParam("value", uuid);

		reget = getTransferD().readByQuery("manytoone.John", query);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());
	</cfscript>
</cffunction>

</cfcomponent>