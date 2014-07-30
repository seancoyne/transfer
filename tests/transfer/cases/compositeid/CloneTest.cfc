<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testCloneBasic" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferD().new("Basic");
		var key = StructNew();
		var reget = 0;

		basic.setStringValue("frodo");
		basic.setNumericValue(3.000);

		basic.setDateValue(CreateDate(1940, 10, 03));

		getTransferD().save(basic);

		reget = basic.clone();

		AssertNotSame("basic get should not be the same ", reget, basic);

		Assertequals("string", reget.getStringValue(), basic.getStringValue());
		Assertequals("numeric", basic.getNumericValue(), reget.getNumericValue());
		assertEquals("id", basic.getID(), reget.getID());
		AssertEquals("date", ParseDateTime(basic.getDateValue()), ParseDateTime(reget.getDateValue()));
		AssertEquals("1: UUID", basic.getUUID(), reget.getUUID());

		reget.setUUID(createUUID());

		getTransferD().save(reget);

		key = structNew();
		key.stringValue = "frodo";
		key.numericValue = 3;
		key.id = basic.getID();

		basic = getTransferD().get("Basic", key);

		AssertNotSame("basic get should not be the same ", reget, basic);
		AssertTrue(basic.getIsPersisted(), "should be persisted");
		Assertequals("2: string", reget.getStringValue(), basic.getStringValue());
		Assertequals("2: numeric", basic.getNumericValue(), reget.getNumericValue());
		assertEquals("2: id", basic.getID(), reget.getID());
		AssertEquals("2: date", ParseDateTime(basic.getDateValue()), ParseDateTime(reget.getDateValue()));
		AssertEquals("2: UUID", basic.getUUID(), reget.getUUID());
	</cfscript>
</cffunction>

<cffunction name="testCloneParentOneToMany" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var one = getTransferD().new("onetomany.One");
		var two = getTransferD().new("onetomany.Two");
		var key = StructNew();
		var reget = 0;

		getTransferD().save(one);

		two.setParentOne(one);
		two.setStringValue("george");

		getTransferD().save(two);

		reget = two.clone();

		AssertNotSame("Two reget should not be same", two, reget);
		AssertEquals("clone - two: id", reget.getID(), two.getID());
		AssertEquals("clone - two: string", reget.getStringValue(), two.getStringValue());
		AssertEquals("clone - two: parent", reget.getParentOne().getId(), one.getID());

		reget.setStringValue("xxx");

		getTransferD().save(reget);

		key = structNew();
		key.id = two.getId();
		key.parentOne = one.getId();

		two = getTransferD().get("onetomany.Two", key);

		AssertEquals("two: id", reget.getID(), two.getID());
		AssertEquals("two: string", reget.getStringValue(), two.getStringValue());
		AssertEquals("two: parent", reget.getParentOne().getId(), one.getID());
	</cfscript>
</cffunction>

<cffunction name="testCloneManyToOne" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoone.John");
		var key = StructNew();
		var reget = 0;
		var george = getTransferD().new("manytoone.George");

		getTransferD().save(george);

		john.setStringValue("john");
		john.setGeorge(george);

		getTransferD().save(john);

		reget = john.clone();

		AssertNotSame("should not be the same", reget, john);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());

		reget.setStringValue("uuu");

		getTransferD().save(reget);

		key = structNew();
		key.george = george.getID();
		key.id = john.getID();

		john = getTransferD().get("manytoone.John", key);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());
	</cfscript>
</cffunction>

<cffunction name="testCloneManyToOneLazy" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoonelazy.John");
		var key = StructNew();
		var reget = 0;
		var george = getTransferD().new("manytoonelazy.George");

		getTransferD().save(george);

		john.setStringValue("john");
		john.setGeorge(george);

		getTransferD().save(john);

		reget = john.clone();


		AssertTrue(reget.getIsPersisted(), "not persisted");
		assertNotSame("should be the same", john, reget);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());

		reget.setStringValue("arg!");

		getTransferD().save(reget);

		key = structNew();
		key.george = george.getID();
		key.id = john.getID();

		john = getTransferD().get("manytoonelazy.John", key);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());
	</cfscript>
</cffunction>

</cfcomponent>