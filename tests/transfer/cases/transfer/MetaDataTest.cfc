<cfcomponent name="UDFTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testHasProperty" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var meta = getTransfer().getTransferMetaData("BasicUUID");

		assertTrue(meta.hasProperty("numeric"), "should have property");

		assertFalse(meta.hasProperty("darthvader"), "should not have property");
	</cfscript>
</cffunction>

</cfcomponent>