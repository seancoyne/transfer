<!--- Document Information -----------------------------------------------------

Title:      AutoWireException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception thrown when internal autowiring fails

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Exception thrown when internal autowiring fails" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="target" hint="the autowiring target" type="any" required="Yes">
	<cfargument name="exception" hint="the exception" type="any" required="Yes">
	<cfscript>
		super.init("Error while attempting to autowire object of type #getMetaData(arguments.target).name#",
			"<br/>[Line: #arguments.exception.tagContext[1].line# :: #arguments.exception.tagContext[1].template# :: #arguments.exception.message# :: #arguments.exception.detail#]");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>