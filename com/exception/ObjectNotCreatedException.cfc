<!--- Document Information -----------------------------------------------------

Title:      ObjectAlreadyCreatedException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception is thrown when attempting to upadate a non persistent exception

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		03/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception is thrown when attempting to upadate a non persistent exception" extends="Exception">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ObjectAlreadyCreatedException" output="false">
	<cfargument name="transfer" hint="the transfer object in question" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		super.init("Transfer Object has already not been created", 
				"The Transfer Object of type '"& arguments.transfer.getClassName() &"' has not been created in the database.");
	
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>