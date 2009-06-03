<!--- Document Information -----------------------------------------------------

Title:      InvalidTransferClassException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception thrown when composite's classes are not as they should be

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		03/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception thrown when composite's classes are not as they should be" extends="Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="the transfer object being passed in" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="className" hint="the classname of what should be passed in" type="string" required="Yes">
	
	<cfset super.init("The supplied Transfer class was not the one specified in the configuration file",
				"The Transfer class of '#arguments.transfer.getClassName()#' does not match the expected class of '#arguments.className#'")/>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>