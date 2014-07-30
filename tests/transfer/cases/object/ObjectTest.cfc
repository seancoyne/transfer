<cfcomponent name="CRUDTest" extends="test.transfer.cases.BaseCase">


<cffunction name="setup" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var config = createObject("component", "transfer.com.io.XMLFileReader").init(expandPath("/test/resources/transfera.xml"), expandpath("/transfer/resources/xsd/transfer.xsd"));
		variables.objectmanager = createObject("component", "transfer.com.object.ObjectManager").init(config);
	</cfscript>
</cffunction>

<cffunction name="testChildHasParentOneToMany" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var child = objectManager.getObject("onetomany.Child");

		AssertTrue(child.getParentOneToManyIterator().hasNext(), "should have a parent");

		//var parent = objectManager.getObject("onetomany.Basic");
	</cfscript>
</cffunction>

<cffunction name="testChildHasParentMayToMany" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//is a m2m child
		var child = objectManager.getObject("BasicUUID");

		AssertTrue(child.getParentManyToManyIterator().hasNext(), "should have a parent");
	</cfscript>
</cffunction>


</cfcomponent>