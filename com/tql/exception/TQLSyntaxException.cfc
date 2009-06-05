<!--- Document Information -----------------------------------------------------

Title:      TQLSyntaxException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for TQL Syntax parsing and evaluation

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Exception for TQL Syntax parsing and evaluation" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="message" hint="the message to throw" type="string" required="Yes">
	<cfargument name="detail" hint="the detail in which to throw" type="string" required="Yes">
	<cfscript>
		super.init(argumentCollection=arguments);			
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>