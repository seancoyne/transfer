<!--- Document Information -----------------------------------------------------

Title:      ObjectAlreadyCreatedException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception is thrown when attempting to save an already created object

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		03/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception is thrown when attempting to save an already created object" extends="Exception">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="the transfer object in question" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		super.init("Transfer Object has already been created",
					"The Transfer Object of type '"& arguments.transfer.getClassName() &"' has already been created in the database."			
					);
	
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>