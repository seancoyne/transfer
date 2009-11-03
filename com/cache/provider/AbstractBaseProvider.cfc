<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseProvider.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Abstract Base class for a Cache Provider

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		02/11/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Abstract Base class for a Cache Provider" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseProvider" output="false">
	<cfscript>
		var linkedHashMap = createObject("java", "java.util.LinkedHashMap").init();
		var Collections = createObject("java", "java.util.Collections");

		setSystem(createObject("java", "java.lang.System"));

		setCollection(Collections.synchronizedMap(linkedHashMap));

		return this;
	</cfscript>
</cffunction>

<cffunction name="add" hint="virtual method: Add an object to the cache, returns if it was successfully cached or not" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfargument name="object" hint="the object to add to the cache" type="any" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("add", this)>
</cffunction>

<cffunction name="have" hint="virtual method: Is the given class and key in the cache?" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("have", this)>
</cffunction>

<cffunction name="get" hint="virtual method: get the given class and key from the cache, if not there, return nothing" access="public" returntype="any" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("get", this)>
</cffunction>

<cffunction name="discard" hint="virtual method: Remove the given class and key from the cache, if it exists. Implementations of this method must invoke fireDiscardEvent(obj) when an item is discarded from the cache." access="public" returntype="void" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("discard", this)>
</cffunction>

<cffunction name="discardAll" hint="virtual method: Remove all items from the cache" access="public" returntype="void" output="false">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("discardAll", this)>
</cffunction>

<cffunction name="getCacheProvider" hint="virtual method: get access to the actual cache provider, beit eHCache, ColdBox cache etc" access="public" returntype="any" output="false">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("getCacheProvider", this)>
</cffunction>

<cffunction name="getScope" hint="If a cache is tied to the lifecycle specific coldfusion shared scope, specify it here. This is generally only needed when using request/session as a cache. Defaults to 'instance'"
			access="public" returntype="string" output="false">
	<cfreturn "instance" />
</cffunction>

<cffunction name="getScopeKey" hint="If a cache is tied to the lifecycle specific coldfusion shared scope, Specify what the key it should be stored under, in that scope Defaults to 'transfer'"
			access="public" returntype="string" output="false">
	<cfreturn "transfer" />
</cffunction>

<cffunction name="setEventManager" access="public" returntype="void" output="false">
	<cfargument name="eventManager" type="transfer.com.events.EventManager" required="true">
	<cfset instance.eventManager = arguments.eventManager />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="fireDiscardEvent" hint="Fires off the discard to all the Observers" access="private" returntype="void" output="false">
	<cfargument name="object" hint="the object being discarded" type="any" required="Yes">
	<cfscript>
		getEventManager().fireAfterDiscardEvent(arguments.object);
    </cfscript>
</cffunction>

<cffunction name="getEventManager" access="private" returntype="transfer.com.events.EventManager" output="false">
	<cfreturn instance.eventManager />
</cffunction>

<cffunction name="getCollection" access="private" returntype="any" output="false">
	<cfreturn instance.Collection />
</cffunction>

<cffunction name="setCollection" access="private" returntype="void" output="false">
	<cfargument name="Collection" type="any" required="true">
	<cfset instance.Collection = arguments.Collection />
</cffunction>

<cffunction name="getSystem" access="private" returntype="any" output="false">
	<cfreturn instance.System />
</cffunction>

<cffunction name="setSystem" access="private" returntype="void" output="false">
	<cfargument name="System" type="any" required="true">
	<cfset instance.System = arguments.System />
</cffunction>

</cfcomponent>