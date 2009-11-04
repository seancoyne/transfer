<!--- Document Information -----------------------------------------------------

Title:      AfterUpdateObserverCollection.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Collection of Observers for after a Creation

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		06/10/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="AfterUpdateObserverCollection" hint="Collection of Observers for after a Creation" extends="AbstractBaseObserverCollection">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="AfterUpdateObserverCollection" output="false">
	<cfscript>
		super.init(argumentCollection=arguments);

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="fireActionMethod" hint="virtual: fires the action method" access="private" returntype="void" output="false">
	<cfargument name="object" hint="the object to fire against" type="any" required="Yes">
	<cfargument name="event" hint="The event object to fire" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		arguments.object.actionAfterUpdateTransferEvent(arguments.event);
	</cfscript>
</cffunction>

</cfcomponent>