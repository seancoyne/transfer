<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseFacade.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    The abstract base for all facades

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		16/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="AbstractBaseFacade" hint="The abstract base to all the scope facades">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseFacade" output="false">
	<cfargument name="javaLoader" hint="The JavaLoader for loading the caching objects" type="transfer.com.util.JavaLoader" required="Yes" _autocreate="false">
	<cfargument name="eventManager" type="transfer.com.events.EventManager" required="true" _autocreate="false">
	<cfargument name="cacheMonitor" hint="The cache monitor" type="transfer.com.cache.CacheMonitor" required="Yes"
				_factory="transfer.com.cache.CacheManager" _factorymethod="getCacheMonitor" _autocreate="false">
	<cfscript>
		var functionMap = StructNew();

		setJavaLoader(arguments.javaLoader);
		setEventManager(arguments.eventManager);
		setCacheMonitor(arguments.cacheMonitor);

		//build the function map, for lookup later
		functionMap.aftercreate = getAfterCreateObserverCollection;
		functionMap.afterdelete = getAfterDeleteObserverCollection;
		functionMap.afterupdate = getAfterUpdateObserverCollection;
		functionMap.beforecreate = getBeforeCreateObserverCollection;
		functionMap.beforedelete = getBeforeDeleteObserverCollection;
		functionMap.beforeupdate = getBeforeUpdateObserverCollection;
		functionMap.afterdiscard = getAfterDiscardObserverCollection;
		functionMap.afternew = getAfterNewObserverCollection;

		setObserverFunctionMap(functionMap);

		return this;
	</cfscript>
</cffunction>

<!--- AfterCreateObserverCollection --->

<cffunction name="getAfterCreateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasAfterCreateObserverCollection()>
		<cflock name="transfer.facade.getAfterCreateObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasAfterCreateObserverCollection()>
				<cfset setAfterCreateObserverCollection(createObservable("AfterCreateObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().AfterCreateObserverCollection />
</cffunction>

<cffunction name="hasAfterCreateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterCreateObserverCollection")>
</cffunction>

<!--- AfterDeleteObserverCollection --->

<cffunction name="getAfterDeleteObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasAfterDeleteObserverCollection()>
		<cflock name="transfer.facade.getAfterDeleteObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasAfterDeleteObserverCollection()>
				<cfset setAfterDeleteObserverCollection(createObservable("AfterDeleteObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().AfterDeleteObserverCollection />
</cffunction>

<cffunction name="hasAfterDeleteObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterDeleteObserverCollection")>
</cffunction>

 <!---AfterUpdateObserverCollection --->

<cffunction name="getAfterUpdateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasAfterUpdateObserverCollection()>
		<cflock name="transfer.facade.getAfterUpdateObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasAfterUpdateObserverCollection()>
				<cfset setAfterUpdateObserverCollection(createObservable("AfterUpdateObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().AfterUpdateObserverCollection />
</cffunction>

<cffunction name="hasAfterUpdateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterUpdateObserverCollection")>
</cffunction>

 <!--- BeforeCreateObserverCollection --->

<cffunction name="getBeforeCreateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasBeforeCreateObserverCollection()>
	<cflock name="transfer.facade.getBeforeCreateObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasBeforeCreateObserverCollection()>
				<cfset setBeforeCreateObserverCollection(createObservable("BeforeCreateObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().BeforeCreateObserverCollection />
</cffunction>

<cffunction name="hasBeforeCreateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("BeforeCreateObserverCollection")>
</cffunction>

<!--- BeforeUpdateObserverCollection --->

<cffunction name="getBeforeUpdateObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasBeforeUpdateObserverCollection()>
		<cflock name="transfer.facade.getBeforeUpdateObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasBeforeUpdateObserverCollection()>
				<cfset setBeforeUpdateObserverCollection(createObservable("BeforeUpdateObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().BeforeUpdateObserverCollection />
</cffunction>

<cffunction name="hasBeforeUpdateObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("BeforeUpdateObserverCollection")>
</cffunction>

<!--- BeforeDeleteObserverCollection --->

<cffunction name="getBeforeDeleteObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasBeforeDeleteObserverCollection()>
		<cflock name="transfer.facade.getBeforeDeleteObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasBeforeDeleteObserverCollection()>
				<cfset setBeforeDeleteObserverCollection(createObservable("BeforeDeleteObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().BeforeDeleteObserverCollection />
</cffunction>

<cffunction name="hasBeforeDeleteObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("BeforeDeleteObserverCollection")>
</cffunction>

<!--- AfterDiscardObserverCollection --->

<cffunction name="getAfterDiscardObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasAfterDiscardObserverCollection()>
		<cflock name="transfer.facade.getAfterDiscardObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasAfterDiscardObserverCollection()>
				<cfset setAfterDiscardObserverCollection(createObservable("AfterDiscardObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().AfterDiscardObserverCollection />
</cffunction>

<cffunction name="hasAfterDiscardObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterDiscardObserverCollection")>
</cffunction>

<!--- AfterNewObserverCollection --->

<cffunction name="getAfterNewObserverCollection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfif NOT hasAfterNewObserverCollection()>
		<cflock name="transfer.facade.getAfterNewObserverCollection.#getScopeIdentityHashCode()#" timeout="60" throwontimeout="true">
			<cfif NOT hasAfterNewObserverCollection()>
				<cfset setAfterNewObserverCollection(createObservable("AfterNewObserverCollection"))>
			</cfif>
		</cflock>
	</cfif>
	<cfreturn getScopePlace().AfterNewObserverCollection />
</cffunction>

<cffunction name="hasAfterNewObserverCollection" hint="Whether it exists in the scope or not" access="public" returntype="boolean" output="false">
	<cfreturn scopePlaceKeyExists("AfterNewObserverCollection")>
</cffunction>

<!--- get observer by type --->

<cffunction name="getObserverCollectionByType" hint="returns a particular observer collection" access="public" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfargument name="type" hint="key for what type to get" type="string" required="Yes">
	<cfscript>
		//give me the appropriate method to map to the type, and call it.
		var call = StructFind(getObserverFunctionMap(), arguments.type);

		return call();
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="scopePlaceKeyExists" hint="Returns true if the scope place key exists" access="private" returntype="boolean" output="false">
	<cfargument name="key" hint="the key to look for" type="string" required="Yes">
	<cfscript>
		if(NOT hasScopePlace())
		{
			return false;
		}

		return StructKeyExists(getScopePlace(), key);
	</cfscript>
</cffunction>

<cffunction name="hasScopePlace" hint="checks to see if the scope has been accessed at all" access="private" returntype="boolean" output="false">
	<cfscript>
		var scope = 0;

		return structKeyExists(getScope(), getKey());
	</cfscript>
</cffunction>

<cffunction name="getScopePlace" hint="Returns the place in which the Transfer parts are stored" access="private" returntype="struct" output="false">
	<cfscript>
		var scope = getScope();
	</cfscript>

	<cfif NOT hasScopePlace()>
		<cflock name="transfer.ScopeFacade.#getIdentityHashCode(scope)#" timeout="60">
			<cfscript>
				if(NOT hasScopePlace())
				{
					scope[getKey()] = StructNew();
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfreturn scope[getKey()]>
</cffunction>

<cffunction name="createObservable" hint="Returns a Observable collection object" access="private" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfargument name="type" hint="key for what type to get" type="string" required="Yes">
	<cfscript>
		return createObject("component", "transfer.com.events.collections." & arguments.type).init();
	</cfscript>
</cffunction>

<cffunction name="getScope" hint="Overwrite to return the scope this facade refers to" access="private" returntype="struct" output="false">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("getScope", this) />
</cffunction>

<cffunction name="getScopeIdentityHashCode" hint="gets the identity hash code of the scope" access="private" returntype="string" output="false">
	<cfreturn getIdentityHashCode(getScope()) />
</cffunction>

<cffunction name="getIdentityHashCode" hint="Gets the object hash code" access="private" returntype="string" output="false">
	<cfargument name="object" hint="The Object the query is associated with" type="any" required="Yes">
	<cfscript>
		var system = createObject("java", "java.lang.System");
		return system.identityHashCode(arguments.object);
	</cfscript>
</cffunction>

<cffunction name="setCacheManager" access="private" returntype="void" output="false">
	<cfargument name="CacheManager" type="any" required="true">
	<cfscript>
		getScopePlace().CacheManager = arguments.CacheManager;
	</cfscript>
</cffunction>

<cffunction name="setSoftReferenceRegister" access="private" returntype="void" output="false">
	<cfargument name="softReferenceRegister" type="transfer.com.cache.SoftReferenceRegister" required="true">
	<cfset getScopePlace().softReferenceRegister = arguments.softReferenceRegister />
</cffunction>

<cffunction name="setBeforeCreateObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="BeforeCreateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().BeforeCreateObserverCollection = arguments.BeforeCreateObserverCollection />
</cffunction>

<cffunction name="setBeforeUpdateObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="BeforeUpdateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().BeforeUpdateObserverCollection = arguments.BeforeUpdateObserverCollection />
</cffunction>

<cffunction name="setBeforeDeleteObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="BeforeDeleteObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().BeforeDeleteObserverCollection = arguments.BeforeDeleteObserverCollection />
</cffunction>

<cffunction name="setAfterCreateObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="AfterCreateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterCreateObserverCollection = arguments.AfterCreateObserverCollection />
</cffunction>

<cffunction name="setAfterUpdateObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="AfterUpdateObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterUpdateObserverCollection = arguments.AfterUpdateObserverCollection />
</cffunction>

<cffunction name="setAfterDeleteObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="AfterDeleteObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterDeleteObserverCollection = arguments.AfterDeleteObserverCollection />
</cffunction>

<cffunction name="setAfterNewObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="AfterNewObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterNewObserverCollection = arguments.AfterNewObserverCollection />
</cffunction>

<cffunction name="setAfterDiscardObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="AfterDiscardObserverCollection" type="transfer.com.events.collections.AbstractBaseObserverCollection" required="true">
	<cfset getScopePlace().AfterDiscardObserverCollection = arguments.AfterDiscardObserverCollection />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="transfer.com.util.JavaLoader" output="false">
	<cfreturn instance.JavaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="JavaLoader" type="transfer.com.util.JavaLoader" required="true">
	<cfset instance.JavaLoader = arguments.JavaLoader />
</cffunction>

<cffunction name="setFacadeMap" access="private" returntype="void" output="false">
	<cfargument name="facadeMap" type="struct" required="true">
	<cfset instance.facadeMap = arguments.facadeMap />
</cffunction>

<cffunction name="getObserverFunctionMap" access="private" returntype="struct" output="false">
	<cfreturn instance.observerFunctionMap />
</cffunction>

<cffunction name="setObserverFunctionMap" access="private" returntype="void" output="false">
	<cfargument name="observerFunctionMap" type="struct" required="true">
	<cfset instance.observerFunctionMap = arguments.observerFunctionMap />
</cffunction>

<cffunction name="getEventManager" access="private" returntype="transfer.com.events.EventManager" output="false">
	<cfreturn instance.EventManager />
</cffunction>

<cffunction name="setEventManager" access="private" returntype="void" output="false">
	<cfargument name="EventManager" type="transfer.com.events.EventManager" required="true">
	<cfset instance.EventManager = arguments.EventManager />
</cffunction>

<cffunction name="getCacheMonitor" access="private" returntype="transfer.com.cache.CacheMonitor" output="false">
	<cfreturn instance.cacheMonitor />
</cffunction>

<cffunction name="setCacheMonitor" access="private" returntype="void" output="false">
	<cfargument name="cacheMonitor" type="transfer.com.cache.CacheMonitor" required="true">
	<cfset instance.cacheMonitor = arguments.cacheMonitor />
</cffunction>

</cfcomponent>