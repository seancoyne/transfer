<cfcomponent name="TransferObjectPoolTest" extends="test.transfer.cases.BaseCase">
	<cffunction name="setUp" hint="" access="public" returntype="void" output="false">
		<cfscript>
			variables.loader = createObject("component", "transfer.com.util.JavaLoader").init("test");
			variables.cache = createObject("component", "transfer.com.dynamic.collections.TransferObjectPool").init(variables.loader);
		</cfscript>
	</cffunction>

	<cffunction name="testIsTransfer" hint="" access="public" returntype="void" output="false">
		<cfscript>
			obj = variables.cache.getTransferObject();
			assertEqualsBasic("transfer.com.TransferObject", getMetaData(obj).name);
		</cfscript>
	</cffunction>

	<cffunction name="testCreateTransfer" hint="" access="public" returntype="void" output="false">
		<cfscript>
			var len = 20;
			var counter = 1;
			var test = true;
			var obj = 0;
			try
			{
				for(; counter lte len; counter = counter + 1)
				{
					obj = variables.cache.getTransferObject();
				}
			}
			catch(any exc)
			{
				test = false;
			}
			assertTrue(test, "Creating 20 TransferObjects");
		</cfscript>
	</cffunction>

	<cffunction name="testRecycle" hint="" access="public" returntype="void" output="false">
		<cfscript>
			var obj = variables.cache.getTransferObject();
			var check = false;
			var counter = 1;
			var reget = 0;

			obj.tag = createUUID();
			variables.cache.recycleTransferObject(obj);

			for(; counter lte 30; counter = counter + 1)
			{
				reget = variables.cache.getTransferObject();
				if(StructKeyExists(reget, "tag") AND reget.tag eq obj.tag)
				{
					check = true;
				}
			}
			assertTrue(check);
		</cfscript>
	</cffunction>
</cfcomponent>