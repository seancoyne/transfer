<!--- Document Information -----------------------------------------------------

Title:      TransferObjectNotFoundException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception when the required object cannot be found in the config file

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Exception when the required object cannot be found in the config file" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="className" hint="the name of class in question" type="string" required="Yes">
	<cfargument name="configReader" hint="the configuration reader" type="transfer.com.io.XMLFileReader" required="Yes">
	<cfscript>
		super.init("The requested object could not be found in the config file",
							"Could not find '"& arguments.className &"' in '" & arguments.configReader.getPathList() & "'.");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>