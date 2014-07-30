<cfcomponent name="CompositeTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testCompositeGet" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var composite = getTransfer().new("composite.Composite");
		var simple = getTransfer().new("onetomany.Basic");
		var child = getTransfer().new("onetomany.Child");

		getTransfer().save(simple);

		child.setName(RandRange(1, 9999));

		child.setParentBasic(simple);

		getTransfer().save(child);

		getTransfer().save(composite);

		composite.setOneToMany(simple);

		getTransfer().save(composite);

		assertSame("10:", composite.getOneToMany(), simple);
		assertSame("20:", composite.getOneToMany().getChild(1), simple.getChild(1));

		composite.addChild(simple);

		getTransfer().save(composite);

		assertSame("30:", composite.getChild(1), simple);
		assertSame("40:", composite.getChild(1).getChild(1), simple.getChild(1));
		assertEquals("50:", 1, ArrayLen(composite.getChildArray()));
		assertEquals("60:", 1, ArrayLen(composite.getChild(1).getChildArray()));

		getTransfer().discard(simple);
		getTransfer().discard(child);
		getTransfer().discard(composite);

		composite = getTransfer().get("composite.Composite", composite.getIDComposite());

		assertEquals("70:", 1, ArrayLen(composite.getChildArray()));
		assertEquals("80:", 1, ArrayLen(composite.getChild(1).getChildArray()));
	</cfscript>
</cffunction>

<cffunction name="testCompositeClone" hint="" access="public" returntype="void" output="false">
<cfscript>
	var composite = getTransfer().new("composite.Composite");
	var simple = getTransfer().new("onetomany.Basic");
	var child = getTransfer().new("onetomany.Child");
	var clone = 0;

	getTransfer().save(simple);

	child.setName(RandRange(1, 9999));

	child.setParentBasic(simple);

	getTransfer().save(child);

	getTransfer().save(composite);

	composite.setOneToMany(simple);

	getTransfer().save(composite);

	clone = composite.clone();

	assertTrue(clone.getIsPersisted(), "clone");

	assertTrue(clone.getIsPersisted(), "clone");
	assertTrue(clone.getOneToMany().getIsPersisted(), "clone.getOneToMany");
	assertTrue(clone.getOneToMany().getChild(1).getIsPersisted(), "clone.getOneToMany().getChild(1)");

	composite.addChild(simple);

	getTransfer().save(composite);

	clone = composite.clone();

	assertTrue(clone.getIsPersisted(), "clone");
	assertTrue(clone.getOneToMany().getIsPersisted(), "clone.getOneToMany");
	assertTrue(clone.getOneToMany().getChild(1).getIsPersisted(), "clone.getOneToMany().getChild(1)");
	assertTrue(clone.getChild(1).getIsPersisted(), "clone.getChild(1)");
</cfscript>
</cffunction>

<cffunction name="testGetSamePropertyNameAsPrimaryKey" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var b = getTransferC().new("brianTest.Brian");
		var student = getTransferC().new("brianTest.Student");
		var br = getTransferC().new("brianTest.Break");
		var reget = 0;

		br.setA_id("value");

		b.addB(student);

		br.setParentStudent(student);

		getTransferC().save(student);
		getTransferC().save(br);
		getTransferC().save(b);

		getTransferC().discard(br);
		getTransferC().discard(b);
		getTransferC().discard(student);

		reget = getTransferC().get("brianTest.Brian", b.getID());

		AssertEquals("should be 'value'", "value", reget.getB(1).getNext(1).getA_id());
	</cfscript>
</cffunction>

</cfcomponent>