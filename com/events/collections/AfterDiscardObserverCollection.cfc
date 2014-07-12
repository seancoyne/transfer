<!--- Document Information -----------------------------------------------------

Title:      AfterDiscardObserverCollection.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Collection of Observers for before a Update

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		18/06/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="AfterDiscardObserverCollection" hint="Collection of Observers for before a Discard" extends="AbstractBaseObserverCollection">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="AfterDiscardObserverCollection" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="fireActionMethod" hint="virtual: fires the action method" access="private" returntype="void" output="false">
	<cfargument name="object" hint="the object to fire against" type="any" required="Yes">
	<cfargument name="event" hint="The event object to fire" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		arguments.object.actionAfterDiscardTransferEvent(arguments.event);
	</cfscript>
</cffunction>

</cfcomponent>