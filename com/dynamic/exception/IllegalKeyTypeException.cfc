<!--- Document Information -----------------------------------------------------

Title:      EmptyQueryException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception when the query provided to populate this Transfer object is empty

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		03/06/2009		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Exception for when the key provided for retrieving an object is not valid" extends="transfer.com.exception.Exception">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="type" hint="simple, or struct" type="string" required="Yes">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfscript>
		super.init("The key for this class should be a #arguments.type# value", 
					"The key for class '#arguments.className#' should be of #arguments.type# value"
					);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>