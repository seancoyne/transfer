<cfcomponent name="AutoGenerateTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testTree" hint="" access="public" returntype="void" output="false">
<cfscript>
	var tree = getTransfer().new("lazy.Tree");
	var child = getTransfer().new("lazy.Tree");

	getTransfer().save(tree);
	getTransfer().save(child);

	assertFalseBasic(tree.hasChild());

	getTransfer().discard(tree);

	tree = getTransfer().get("lazy.Tree", tree.getIDTree());

	assertFalseBasic(tree.hasChild());

	tree.setChild(child);

	getTransfer().save(tree);

	assertTrueBasic(tree.hasChild());

	getTransfer().discard(tree);
	getTransfer().discard(child);

	tree = getTransfer().get("lazy.Tree", tree.getIDTree());

	assertTrueBasic(tree.hasChild());
</cfscript>
</cffunction>

<cffunction name="testSelfReferentialTree" hint="" access="public" returntype="void" output="false">
<cfscript>
	var tree = getTransfer().new("lazy.Tree");

	getTransfer().save(tree);

	tree.setChild(tree);

	getTransfer().save(tree);

	assertSame("before dump, should be same object", tree, tree.getChild());

	getTransfer().discard(tree);

	tree = getTransfer().get("lazy.Tree", tree.getIDTree());

	assertTrue(tree.hasChild(), "should have a child");

	assertSame("after get, should be same object", tree, tree.getChild());
</cfscript>
</cffunction>



<cffunction name="testTree3Level" hint="" access="public" returntype="void" output="false">
<cfscript>
	var tree = getTransfer().new("lazy.Tree");
	var child = getTransfer().new("lazy.Tree");
	var child2 = getTransfer().new("lazy.Tree");

	getTransfer().save(tree);
	getTransfer().save(child);
	getTransfer().save(child2);

	assertFalseBasic(tree.hasChild());

	getTransfer().discard(tree);

	tree = getTransfer().get("lazy.Tree", tree.getIDTree());

	assertFalseBasic(tree.hasChild());

	tree.setChild(child);

	getTransfer().save(tree);

	child.setChild(child2);

	getTransfer().save(child);

	assertTrueBasic(tree.hasChild());
	assertTrueBasic(tree.getChild().hasChild());

	getTransfer().discard(tree);
	getTransfer().discard(child);
	getTransfer().discard(child2);

	tree = getTransfer().get("lazy.Tree", tree.getIDTree());

	assertTrueBasic(tree.hasChild());
	assertTrueBasic(tree.getChild().hasChild());

	getTransfer().discard(tree.getChild().getChild());
</cfscript>
</cffunction>


<cffunction name="testTreeNonLazyFail" hint="" access="public" returntype="void" output="false">

<cfscript>
	var tree = getTransfer().new("lazy.TreeFail");
	var child = getTransfer().new("lazy.TreeFail");
	var check = 0;

	getTransfer().save(tree);
	getTransfer().save(child);

	assertFalseBasic(tree.hasChild());

	getTransfer().discard(tree);

	try
	{
		tree = getTransfer().get("lazy.TreeFail", tree.getIDTree());
	}
	catch(transfer.com.sql.exception.RecursiveCompositionException exc)
	{
		check = true;
	}

	assertTrueBasic(check);
</cfscript>
</cffunction>

<cffunction name="testOneToManyTree" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var one = getTransfer().new("lazy.o2mTree");
		var two = getTransfer().new("lazy.o2mTree");
		var three = getTransfer().new("lazy.o2mTree");

		two.setParentO2mTree(one);
		three.setParentO2mTree(two);

		getTransfer().save(one);
		getTransfer().save(two);
		getTransfer().save(three);

		AssertEquals("one: should be 1 child", 1, Arraylen(one.getChildArray()));
		AssertEquals("two: should be 1 child", 1, Arraylen(two.getChildArray()));

		getTransfer().discard(three);

		one = getTransfer().get("lazy.o2mTree", one.getID());

		AssertSame("should be different, one, two.parent", one, two.getParentO2mTree());

		AssertNotSame("should be different, one.child.child, three", one.getChild(1).getChild(1), three);

		//testing for 500's here

		getTransfer().discard(one.getChild(1).getChild(1));

		one = getTransfer().get("lazy.o2mTree", one.getID());

		one.getChild(1).getChild(1);

		getTransfer().discard(one.getChild(1));

		one = getTransfer().get("lazy.o2mTree", one.getID());

		one.getChild(1).getChild(1);

		getTransfer().discard(one);
	</cfscript>
</cffunction>

</cfcomponent>

