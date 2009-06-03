<!--- Document Information -----------------------------------------------------

Title:      MethodNotFoundException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for method not being found

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		03/06/2009		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Exception for method not being found" extends="Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="component" hint="the component that the method is attempting to be called on" type="any" required="Yes">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">

	<cfscript>
		super.init("The method '#arguments.methodName#' in '#getMetaData(arguments.component).name#' could not be found.",
					"This method could not be found. Please ensure that it was spelled correctly"
					);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>