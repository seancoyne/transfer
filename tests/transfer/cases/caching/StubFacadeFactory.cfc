<cfcomponent extends="transfer.com.facade.FacadeFactory" output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="StubFacadeFactory" output="false">
	<cfscript>
		var map = Structnew();

		setSingletonCache(StructNew());
		setPropertyValueCache(StructNew());

		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="configure for di loops" access="public" returntype="void" output="false">
	<cfargument name="cacheMonitor" hint="" type="any" required="Yes">
	<cfscript>
		//setSingleton(arguments.cacheMonitor);
		variables.instance.cm = arguments.cacheMonitor;

				//build the lookup
		map.instance = getInstanceFacade();
		map.application = getApplicationFacade();
		map.session = getSessionFacade();
		map.transaction = getSessionFacade();
		map.request = getRequestFacade();
		map.none = getNoneFacade();
		map.server = getServerFacade();

		setFacadeMap(map);

	</cfscript>
</cffunction>

<cffunction name="getInstanceFacade" hint="" access="public" returntype="any" output="false">
	<cfreturn createObject("component", "StubFacade").init(variables.instance.cm)/>
</cffunction>

<cffunction name="getApplicationFacade" hint="" access="public" returntype="any" output="false">
	<cfreturn createObject("component", "StubFacade").init(variables.instance.cm)/>
</cffunction>

<cffunction name="getRequestFacade" hint="" access="public" returntype="any" output="false">
	<cfreturn createObject("component", "StubFacade").init(variables.instance.cm)/>
</cffunction>

<cffunction name="getServerFacade" hint="" access="public" returntype="any" output="false">
	<cfreturn createObject("component", "StubFacade").init(variables.instance.cm)/>
</cffunction>

<cffunction name="getSessionFacade" hint="" access="public" returntype="any" output="false">
	<cfreturn createObject("component", "StubFacade").init(variables.instance.cm)/>
</cffunction>

<cffunction name="getNoneFacade" hint="" access="public" returntype="any" output="false">
	<cfreturn createObject("component", "StubFacade").init(variables.instance.cm)/>
</cffunction>

</cfcomponent>