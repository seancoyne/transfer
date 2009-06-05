<!--- Document Information -----------------------------------------------------

Title:      ParentParentOneToManyNotFoundException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception thrown when a ParentOneToMany could not be found

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception thrown when a ParentOneToMany could not be found" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="className" hint="the name of the class this represents" type="string" required="Yes">
	<cfargument name="name" hint="the name of the parent one to many" type="string" required="no">
	<cfargument name="parentClass" hint="the class of the parent one to many" type="string" required="no">
	<cfscript>
		var detail = 0;
		
		if(StructKeyExists(arguments, "name"))
		{
			detail = "The ParentOneToMany '#arguments.name#' could not be found in the object '#arguments.className#'";
		}
		else
		{
			detail = "The ParentOneToMany '#arguments.parentClass#' could not be found in the object '#arguments.className#'";
		}
	
		super.init("The ParentOneToMany that was searched for could not be found", detail);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>