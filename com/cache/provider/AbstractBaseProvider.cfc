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

<cffunction name="discard" hint="virtual method: Remove the given class and key from the cache, if it exists. Implementations of this method must invoke fireDiscardEvent(obj) when an item is discarded from the cache, but only if it existed in the first place."
			access="public" returntype="void" output="false">
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

<cffunction name="getCachedClasses" hint="virtual method: return a list of all the cached classes" access="public" returntype="array" output="false">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("getCachedClasses", this)>
</cffunction>

<cffunction name="getSize" hint="virtual method: The number of items in the cache, for  given class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("getSize", this)>
</cffunction>

<cffunction name="getHits" hint="virtual method: returns the number of hits for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("getHits", this)>
</cffunction>

<cffunction name="getMisses" hint="virtual method: returns the number of misses for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("getMisses", this)>
</cffunction>

<cffunction name="getEvictions" hint="virtual method: get the total number of cache evictions for this class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("getEvictions", this)>
</cffunction>

<cffunction name="resetStatistics" hint="virtual method: resets the statistics" access="public" returntype="void" output="false">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("resetStatistics", this)>
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

<cffunction name="shutdown" hint="Some cache implementations may need to be shutdown for cleanup. Overwrite this method when needing this functionality."
			access="public" returntype="void" output="false">
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

</cfcomponent>