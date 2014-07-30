<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testGetMetaData" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var meta = getTransferD().getTransferMetaData("Basic");

		assertTrue(meta.getPrimaryKey().getIsComposite(), "composite id false");

		AssertTrue(meta.getPrimaryKey().getPropertyIterator().hasNext(), "should have a property");

		assertEquals("property name not right", meta.getPrimaryKey().getPropertyIterator().next().getName(), "stringValue");

		meta = getTransferD().getTransferMetaData("onetomany.Two");

		AssertTrue(meta.getPrimaryKey().getParentOneToManyIterator().hasNext(), "should have a parent");

		AssertEquals("parent one to many class not right", meta.getPrimaryKey().getParentOneToManyIterator().next().getLink().getTo(), "onetomany.One");

		meta = getTransferD().getTransferMetaData("manytoone.John");

		AssertTrue(meta.getPrimaryKey().getManyToOneIterator().hasNext(), "should have a manytoone");

		AssertEquals("many to one not right", meta.getPrimaryKey().getManyToOneIterator().next().getName(), "George");
	</cfscript>
</cffunction>

<cffunction name="testNewObject" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferD().new("Basic");
		var two = getTransferD().new("onetomany.Two");
		var john = getTransferD().new("manytoone.John");
		var uuid = createUUID();

		var one = getTransferD().new("onetomany.One");
		var george = getTransferD().new("manytoone.George");

		getTransferD().save(one);

		//test actual cml
		basic.setID(uuid);
		basic.setNumericValue("200.00");
		basic.setStringValue("frodo");

		AssertEquals("composite id on basic is wrong", "frodo|200|" & uuid & "|", basic.getCompositeID());

		two.setID(uuid);
		two.setParentOne(one);

		AssertEquals("composite id on two is wrong", uuid & "|" & one.getID() & "|", two.getCompositeID());

		getTransferD().save(george);

		john.setStringValue("john");
		john.setID(uuid);
		john.setGeorge(george);

		AssertEquals("composite id on john is wrong", uuid & "|" & george.getID() & "|", john.getCompositeID());
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectBasic" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferD().new("Basic");
		var key = StructNew();
		var reget = 0;

		basic.setStringValue("frodo");
		basic.setNumericValue(3.000);

		basic.setDateValue(CreateDate(1940, 10, 03));

		getTransferD().save(basic);

		//get the objects - from cache ;)
		key.stringValue = "frodo";
		key.numericValue = 3.0;
		key.id = basic.getID();

		reget = getTransferD().get("Basic", key);

		AssertSame("basic reget should be same", basic, reget);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(basic);

		key = structNew();
		key.stringValue = "frodo";
		key.numericValue = 3;
		key.id = basic.getID();

		reget = getTransferD().get("Basic", key);

		AssertNotSame("basic get should not be the same ", reget, basic);

		Assertequals("string", reget.getStringValue(), basic.getStringValue());
		Assertequals("numeric", basic.getNumericValue(), reget.getNumericValue());
		assertEquals("id", basic.getID(), reget.getID());
		//assertTrue(DateCompare(basic.getDate(), reget.getDate()) eq 0, "date");
		AssertEquals("date", ParseDateTime(basic.getDateValue()), ParseDateTime(reget.getDateValue()));
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectBasicWithNull" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var basic = getTransferD().new("Basic");
		var key = StructNew();
		var reget = 0;

		basic.setStringValue("frodo");
		basic.setNumericValueNull();
		basic.setDateValue(CreateDate(1940, 10, 03));

		getTransferD().save(basic);

		//get the objects - from cache ;)
		key.stringValue = "frodo";
		key.id = basic.getID();

		reget = getTransferD().get("Basic", key);

		AssertTrue(reget.getIsPersisted(), "should be persisted");
		AssertSame("basic reget should be same", basic, reget);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(basic);

		key = structNew();
		key.stringValue = "frodo";
		key.id = basic.getID();

		reget = getTransferD().get("Basic", key);

		AssertNotSame("basic get should not be the same ", reget, basic);

		Assertequals("string", reget.getStringValue(), basic.getStringValue());
		Assertequals("numeric", basic.getNumericValue(), reget.getNumericValue());
		assertEquals("id", basic.getID(), reget.getID());
		//assertTrue(DateCompare(basic.getDate(), reget.getDate()) eq 0, "date");
		AssertEquals("date", ParseDateTime(basic.getDateValue()), ParseDateTime(reget.getDateValue()));
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectParentOneToMany" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var one = getTransferD().new("onetomany.One");
		var two = getTransferD().new("onetomany.Two");
		var key = StructNew();
		var reget = 0;

		getTransferD().save(one);

		two.setParentOne(one);
		two.setStringValue("george");

		getTransferD().save(two);

		//get the objects - from cache ;)
		key = structNew();
		key.id = two.getId();
		key.parentOne = one.getId();


		reget = getTransferD().get("onetomany.Two", key);

		AssertSame("Two reget should be same", two, reget);

		//discard the objects, and retrieve them again from the db
		getTransferD().discardAll();

		key = structNew();
		key.id = two.getId();
		key.parentOne = one.getId();

		reget = getTransferD().get("onetomany.Two", key);

		AssertEquals("two: id", reget.getID(), two.getID());
		AssertEquals("two: string", reget.getStringValue(), two.getStringValue());
		AssertEquals("two: parent", reget.getParentOne().getId(), one.getID());

		AssertEquals("two: should only be 1", 1, Arraylen(reget.getParentOne().getTwoArray()));

		getTransfer().discardAll();

		reget = getTransferD().get("onetomany.One", one.getID());

		AssertEquals("one: should only be 1", 1, Arraylen(reget.getTwoArray()));

		queryComment("finishedLaoding");

		AssertSame("should be same, for child parent", reget, reget.getTwo(1).getParentOne());
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectParentOneToManySingle" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var one = getTransferD().new("onetomanySingle.OneSingle");
		var two = getTransferD().new("onetomanySingle.TwoSingle");
		var key = StructNew();
		var reget = 0;

		getTransferD().save(one);

		two.setParentOneSingle(one);
		two.setStringValue("george");

		getTransferD().save(two);

		//get the objects - from cache ;)
		key = structNew();
		key.parentOneSingle = one.getId();

		reget = getTransferD().get("onetomanySingle.TwoSingle", key);

		AssertSame("Two reget should be same", two, reget);

		//discard the objects, and retrieve them again from the db
		getTransferD().discardAll();

		key = structNew();
		key.parentOneSingle = one.getId();

		reget = getTransferD().get("onetomanySingle.TwoSingle", key);

		AssertEquals("two: id", reget.getID(), two.getID());
		AssertEquals("two: string", reget.getStringValue(), two.getStringValue());
		AssertEquals("two: parent", reget.getParentOneSingle().getId(), one.getID());

		AssertEquals("two: should only be 1", 1, Arraylen(reget.getParentOneSingle().getTwoArray()));

		getTransfer().discardAll();

		reget = getTransferD().get("onetomanySingle.OneSingle", one.getID());

		AssertEquals("one: should only be 1", 1, Arraylen(reget.getTwoArray()));

		AssertSame("should be same, for child parent", reget, reget.getTwo(1).getParentOneSingle());
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectParentOneToManyWithNull" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var two = getTransferD().new("onetomany.Two");
		var key = StructNew();
		var reget = 0;

		two.setStringValue("george");

		getTransferD().save(two);

		//get the objects - from cache ;)
		key = structNew();
		key.id = two.getId();

		reget = getTransferD().get("onetomany.Two", key);

		AssertSame("Two reget should be same", two, reget);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(two);

		key = structNew();
		key.id = two.getId();

		reget = getTransferD().get("onetomany.Two", key);

		AssertTrue(reget.getIsPersisted(), "should be persisted");
		AssertEquals("two: id", reget.getID(), two.getID());
		AssertEquals("two: string", reget.getStringValue(), two.getStringValue());
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectManyToOne" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoone.John");
		var key = StructNew();
		var reget = 0;
		var george = getTransferD().new("manytoone.George");
		var george2 = getTransferD().new("manytoone.George");

		getTransferD().save(george);
		getTransferD().save(george2);

		john.setStringValue("john");
		john.setGeorge(george);
		john.setGeorge2(george2);

		getTransferD().save(john);

		//get the objects - from cache ;)
		key = structNew();
		key.george = george.getID();
		key.id = john.getID();

		reget = getTransferD().get("manytoone.John", key);

		AssertSame("should be the same", reget, john);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(john);
		getTransferD().discard(george);

		key = structNew();
		key.george = george.getID();
		key.id = john.getID();

		reget = getTransferD().get("manytoone.John", key);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());

		AssertTrue(reget.hasGeorge2(), "should have a george");
		AssertEquals("should be same id", george2.getID(), reget.getGeorge2().getID());
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectManyToOneWithNull" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoone.John");
		var key = StructNew();
		var reget = 0;

		john.setStringValue("john");

		getTransferD().save(john);

		//get the objects - from cache ;)
		key = structNew();
		key.id = john.getID();

		reget = getTransferD().get("manytoone.John", key);

		AssertSame("should be the same", reget, john);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(john);

		key = structNew();
		key.id = john.getID();

		reget = getTransferD().get("manytoone.John", key);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());
	</cfscript>
</cffunction>

<cffunction name="testInsertAndGetObjectManyToOneLazy" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoonelazy.John");
		var key = StructNew();
		var reget = 0;
		var george = getTransferD().new("manytoonelazy.George");

		getTransferD().save(george);

		john.setStringValue("john");
		john.setGeorge(george);

		getTransferD().save(john);

		//get the objects - from cache ;)
		key = structNew();
		key.george = george.getID();
		key.id = john.getID();

		reget = getTransferD().get("manytoonelazy.John", key);

		AssertTrue(reget.getIsPersisted(), "not persisted");
		assertSame("should be the same", john, reget);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(john);
		getTransferD().discard(george);

		key = structNew();
		key.stringValue = "john";
		key.george = george.getID();
		key.id = john.getID();

		reget = getTransferD().get("manytoonelazy.John", key);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());
	</cfscript>
</cffunction>

<cffunction name="testUpdateProperty" hint="" access="public" returntype="void" output="false">
<cfscript>
	var basic = getTransferD().new("Basic");
	var key = StructNew();
	var reget = 0;
	var uuid = createUUID();

	basic.setStringValue("frodo");
	basic.setNumericValue(3.000);
	basic.setDateValue(CreateDate(1940, 10, 03));

	getTransferD().save(basic);

	basic.setuuid(uuid);

	getTransferD().save(basic);

	getTransferD().discard(basic);

	key = structNew();
	key.stringValue = "frodo";
	key.numericValue = 3;
	key.id = basic.getID();

	reget = getTransferD().get("Basic", key);

	AssertNotSame("basic get should not be the same ", reget, basic);

	Assertequals("string", reget.getStringValue(), basic.getStringValue());
	Assertequals("numeric", basic.getNumericValue(), reget.getNumericValue());
	assertEquals("id", basic.getID(), reget.getID());
	AssertEquals("date", ParseDateTime(basic.getDateValue()), ParseDateTime(reget.getDateValue()));
	assertEquals("uuid", basic.getUUID(), reget.getUUID());
</cfscript>
</cffunction>

<cffunction name="testUpdateParentOneToMany" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var one = getTransferD().new("onetomany.One");
		var two = getTransferD().new("onetomany.Two");
		var key = StructNew();
		var reget = 0;

		getTransferD().save(one);

		two.setParentOne(one);
		two.setStringValue("george");

		getTransferD().save(two);

		two.setStringValue("richard");

		getTransferD().save(two);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(two);
		getTransferD().discard(one);

		key = structNew();
		key.id = two.getId();
		key.parentOne = one.getId();

		reget = getTransferD().get("onetomany.Two", key);

		assertEquals("class check", "onetomany.Two", reget.getClassName());

		assertTrue(reget.getIsPersisted(), "Should be persisted");

		AssertNotSame("should be different", two, reget);

		AssertEquals("two: id", reget.getID(), two.getID());
		AssertEquals("two: string", reget.getStringValue(), two.getStringValue());
		AssertEquals("two: parent", reget.getParentOne().getId(), one.getID());
	</cfscript>
</cffunction>

<cffunction name="testUpdateManyToOne" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoone.John");
		var key = StructNew();
		var reget = 0;
		var george = getTransferD().new("manytoone.George");

		getTransferD().save(george);

		john.setStringValue("john");
		john.setGeorge(george);

		getTransferD().save(john);

		john.setStringValue("ardvarck");

		getTransferD().save(john);

		//discard the objects, and retrieve them again from the db
		getTransferD().discard(john);
		getTransferD().discard(george);

		key = structNew();
		key.george = george.getID();
		key.id = john.getID();

		reget = getTransferD().get("manytoone.John", key);

		AssertEquals("string", john.getStringValue(), reget.getStringValue());
		AssertEquals("id", john.getID(), reget.getID());

		AssertEquals("george", john.getGeorge().getId(), reget.getGeorge().getId());
	</cfscript>
</cffunction>

<cffunction name="testDeleteProperty" hint="" access="public" returntype="void" output="false">
<cfscript>
	var basic = getTransferD().new("Basic");
	var key = StructNew();
	var reget = 0;
	var uuid = createUUID();

	basic.setStringValue("frodo");
	basic.setNumericValue(3.000);

	getTransferD().save(basic);

	basic.setuuid(uuid);

	getTransferD().delete(basic);

	key = structNew();
	key.string = "frodo";
	key.numeric = 3;
	key.id = basic.getID();

	reget = getTransferD().get("Basic", key);

	AssertFalse(reget.getIsPersisted(), "should not be found");
</cfscript>
</cffunction>

<cffunction name="testDeleteParentOneToMany" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var one = getTransferD().new("onetomany.One");
		var two = getTransferD().new("onetomany.Two");
		var key = StructNew();
		var reget = 0;

		getTransferD().save(one);

		two.setParentOne(one);
		two.setStringValue("george");

		getTransferD().save(two);

		two.setStringValue("richard");

		getTransferD().delete(two);

		//discard the objects, and retrieve them again from the db

		key = structNew();
		key.id = two.getId();
		key.parentOne = one.getId();

		reget = getTransferD().get("onetomany.Two", key);
		AssertFalse(reget.getIsPersisted(), "should not be found");
	</cfscript>
</cffunction>

<cffunction name="testDeleteManyToOne" hint="inserts the object into the db" access="public" returntype="void" output="false">
	<cfscript>
		var john = getTransferD().new("manytoone.John");
		var key = StructNew();
		var reget = 0;
		var george = getTransferD().new("manytoone.George");

		getTransferD().save(george);

		john.setStringValue("john");
		john.setGeorge(george);

		getTransferD().save(john);

		john.setStringValue("ardvarck");

		getTransferD().delete(john);

		key = structNew();
		key.george = george.getID();
		key.id = john.getID();

		reget = getTransferD().get("manytoone.John", key);
		AssertFalse(reget.getIsPersisted(), "should not be found");
	</cfscript>
</cffunction>

<cffunction name="testWrongManyToOneConfig" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var obj = 0;
		var check = false;
		try
		{
			object = getTransferD().get("manytoonewrong.A", 1);
		}
		catch(transfer.com.object.exception.InvalidRelationshipExeception exc)
		{
			check = true;
		}

		AssertTrue(check, "many to one error failed");
	</cfscript>
</cffunction>

<cffunction name="testWrongManyToManyConfig" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var obj = 0;
		var check = false;
		try
		{
			object = getTransferD().get("manytomanywrong.A", 1);
		}
		catch(transfer.com.object.exception.InvalidRelationshipExeception exc)
		{
			check = true;
		}

		AssertTrue(check, "many to many (1) error failed");

		check = false;

		try
		{
			object = getTransferD().get("manytomanywrong.A2", StructNew());
		}
		catch(transfer.com.object.exception.InvalidRelationshipExeception exc)
		{
			check = true;
		}

		AssertTrue(check, "many to many (1) error failed");
	</cfscript>
</cffunction>

<cffunction name="testDoubleParent" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var paul = getTransferD().new("paul.Paul");
		var robin = getTransferD().new("paul.Robin");
		var mark = getTransferD().new("paul.Mark");
		var reget = 0;

		paul.setStringValue("is paul working?");

		getTransferD().save(paul);
		getTransferD().save(robin);

		//discard, an reget
		getTransferD().discard(paul);
		getTransferD().discard(robin);

		paul = getTransferD().get("paul.Paul", paul.getID());
		robin = getTransferD().get("paul.Robin", robin.getID());

		AssertEquals("should be 0 child", 0, ArrayLen(paul.getMarkArray()));

		mark.setParentPaul(paul);
		mark.setParentRobin(robin);

		getTransferD().save(mark);

		getTransferD().discardAll();

		reget = getTransferD().get("paul.Paul", paul.getID());

		AssertTrue(reget.getIsPersisted(), "paul is persisted");
		AssertEquals("paul: should be 1 child", 1, ArrayLen(reget.getMarkArray()));

		getTransferD().discardAll();

		//let's retrieve by user, and see what happens
		reget = getTransferD().get("paul.Robin", robin.getID());
		AssertTrue(reget.getIsPersisted(), "robin is persisted");
		AssertEquals("robin: should be 1 child", 1, ArrayLen(reget.getMarkArray()));
	</cfscript>
</cffunction>

<cffunction name="testCompositeManyToMany" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var user = getTransferD().new("dude.User");
		var album = getTransferD().new("dude.Album");
		var albumUser = getTransferD().new("dude.AlbumUser");
		var reget = 0;

		getTransferD().save(user);
		getTransferD().save(album);

		albumUser.setParentUser(user);
		albumUser.setParentAlbum(album);

		getTransferD().save(albumUser);

		getTransferD().discardAll();

		reget = getTransferD().get("dude.User", user.getID());

		AssertNotSame("not the same object", reget, albumUser);

		AssertEquals("same user id", user.getId(), reget.getId());
		AssertEquals("same album id", user.getAlbums(1).getParentAlbum().getID(), reget.getAlbums(1).getParentAlbum().getID());

		getTransferD().delete(reget.getAlbums(1));
	</cfscript>
</cffunction>

<cffunction name="testWrongCompositeManyToMany" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var check = false;

		try
		{
			getTransferD().new("wrongDude.wrongUser");
		}
		catch(transfer.com.object.exception.InvalidCompositeIDException exc)
		{
			check = true;
		}

		AssertTrue(check, "not caught error");
	</cfscript>
</cffunction>

<cffunction name="testDooubleParentWithChild" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var yoko = getTransferD().new("parentChild.Yoko");
		var ono = getTransferD().new("parentChild.Ono");
		var frodo = getTransferD().new("parentChild.Frodo");
		var oneMore = getTransferD().new("parentChild.OneMore");
		var reget = 0;

		frodo.setOneMore(oneMore);
		frodo.setParentYoko(yoko);
		frodo.setParentOno(ono);

		getTransferD().save(yoko);
		getTransferD().save(ono);
		getTransferD().save(oneMore);
		getTransferD().save(frodo);

		getTransferD().discardAll();

		reget = getTransferD().get("parentChild.Ono", ono.getID());

		AssertTrue(reget.getIsPersisted(), "is persisted");
		AssertEquals("ono: should be one", ArrayLen(reget.getFrodoArray()), 1);

		AssertTrue(reget.getFrodo(1).hasOneMore(), "should have one more");
		AssertEquals("should have the same id", oneMore.getID(), reget.getFrodo(1).getOneMore().getID());
	</cfscript>
</cffunction>

<cffunction name="testTrainingGuide" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var training = getTransferD().new("trainingguide.training");
		var traininglocation = getTransferD().new("trainingguide.traininglocation");
		var contactperson = getTransferD().new("trainingguide.contactperson");
		var traininglocationcontactperson = getTransferD().new("trainingguide.traininglocationcontactperson");
		var reget = 0;

		traininglocation.setParentTraining(training);

		traininglocationcontactperson.setParentTrainingLocation(traininglocation);
		traininglocationcontactperson.setContactPerson(contactPerson);

		getTransferD().cascadeSave(training);

		getTransferD().discardAll();

		reget = getTransferD().get("trainingguide.training", training.getID());

		AssertTrue(reget.getIsPersisted(), "should be persisted");

		AssertEquals("should be 1 child (1)", 1, ArrayLen(reget.getTrainingLocationArray()));

		reget = reget.getTrainingLocation(1);

		AssertEquals("should be 1 child (2)", 1, ArrayLen(reget.getlocationcontactpersonArray()));

		AssertEquals("should be the same id", contactperson.getID() ,reget.getlocationcontactperson(1).getContactPerson().getID());
	</cfscript>
</cffunction>

</cfcomponent>