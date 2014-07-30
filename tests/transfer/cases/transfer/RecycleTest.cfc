<cfcomponent name="RecycleTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testRecycle" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var counter = 1;
		var len = 40;
		var obj = 0;
		var transfer = getTransfer();
		var simple = 0;
		var child = 0;
		var children = 0;
		var reget = 0;

		for(; counter lte len; counter = counter + 1)
		{
			obj = transfer.new("BasicGUID");
			obj = transfer.new("Basic");
			transfer.recycle(obj);
		}

		counter = 1;
		for(; counter lte 5; counter = counter + 1)
		{
			simple = getTransfer().new("manytoone.SimpleUUID");
			child = getTransfer().new("manytoone.ChildUUID");

			getTransfer().save(child);

			simple.setChild(child);

			getTransfer().save(simple);

			reget = getTransfer().get("manytoone.ChildUUID", child.getIDChild());

			assertSame("Child : #child.getIDChild()# != reget: #reget.getIDChild()#", child, reget);

			getTransfer().discardAll();

			reget = getTransfer().get("manytoone.SimpleUUID", simple.getIDSimple());

			assertNotSameBasic(simple, reget);
		}

		counter = 1;
		for(; counter lte len; counter = counter + 1)
		{
			obj = transfer.new("BasicGUID");
			obj = transfer.new("Basic");
			assertFalse(obj.sameTransfer(reget), "same?");

			transfer.recycle(obj);
		}


	</cfscript>
</cffunction>

</cfcomponent>