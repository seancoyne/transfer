<!--- Document Information -----------------------------------------------------

Title:      AfterNewObserverCollection.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Collection of observers for after new event

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		22/02/2007		Newd

------------------------------------------------------------------------------->
<cfcomponent name="AfterNewObserverCollection" hint="Collection of Observers for after a New" extends="AbstractBaseObserverCollection">

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="AfterNewObserverCollection" output="false">
	<cfscript>
		variables.instance = StructNew();

		super.init();

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="fireActionMethod" hint="virtual: fires the action method" access="private" returntype="void" output="false">
	<cfargument name="adapter" hint="the adapter to fire against" type="transfer.com.events.adapter.AbstractBaseEventActionAdapter" required="Yes">
	<cfargument name="event" hint="The event object to fire" type="transfer.com.events.TransferEvent" required="Yes">
	<cfset arguments.adapter.actionAfterNewTransferEvent(arguments.event) />
</cffunction>

</cfcomponent>