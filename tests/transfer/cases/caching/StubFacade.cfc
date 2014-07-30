<cfcomponent output="false" extends="transfer.com.facade.AbstractBaseFacade">

<cffunction name="init" hint="Constructor" access="public" returntype="StubFacade" output="false">
	<cfargument name="cacheMonitor" hint="" type="any" required="Yes">
	<cfscript>
		instance = StructNew();
		instance.scope = StructNew();

		//super.init();
		configure("x");

		setEventManager(createObject("component", "StubEventManager").init());
		setCacheMonitor(arguments.cacheMonitor);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getScope" hint="Overwrite to return the scope this facade refers to" access="private" returntype="struct" output="false">
	<cfreturn instance.scope/>
</cffunction>

</cfcomponent>