<!--- Document Information -----------------------------------------------------

Title:      Exception.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Throws a given exception

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		24/11/2008		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Throws a given exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="message" hint="the message to throw" type="string" required="Yes">
	<cfargument name="detail" hint="the detail in which to throw" type="string" required="Yes">

	<cfthrow type="#getMetaData(this).name#" message="#arguments.message#" detail="#detail#">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>