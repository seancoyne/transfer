<!--- Document Information -----------------------------------------------------

Title:      CompositionNotFoundException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception thrown when a ManytoOne could not be found

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception thrown when a Composition could not be found" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="className" hint="the name of the class this represents" type="string" required="Yes">
	<cfargument name="compositeName" hint="the name of the composition" type="string" required="Yes">
	<cfscript>
		super.init("The composition element '#arguments.compositeName#' cannot be found",
				"The composition element '#arguments.compositeName#' cannot be found on an Object of type '#arguments.className#'");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>