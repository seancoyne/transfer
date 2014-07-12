<!--- Document Information -----------------------------------------------------

Title:      NoneFacade.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Dummy Facade for none cached objects

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		16/05/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="NoneFacade" hint="Facade to dummy objects for none cached objects" extends="AbstractBaseFacade">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="createObservable" hint="Returns a Observable collection object" access="private" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfargument name="type" hint="key for what type to get" type="string" required="Yes">
	<cfscript>
		return createObject("component", "transfer.com.events.collections.DummyObserverCollection").init();
	</cfscript>
</cffunction>

<cffunction name="getScope" hint="returns the Instance scope" access="private" returntype="struct" output="false">
	<cfreturn instance>
</cffunction>

</cfcomponent>