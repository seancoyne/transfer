<cfcomponent name="UDFTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testConfigure" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var autoGenerate = getTransfer().new("AutoGenerate");
		
		assertTrue(autoGenerate.getSet(), "value not set correctly");
	</cfscript>
</cffunction>

</cfcomponent>