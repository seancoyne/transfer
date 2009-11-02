<!--- Document Information -----------------------------------------------------

Title:      PropertyNotFoundException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception thrown when a Property could not be found

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception thrown when a Property could not be found" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="className" hint="the name of the class this represents" type="string" required="Yes">
	<cfargument name="name" hint="the name of the many to one" type="string" required="Yes">
	<cfscript>
		super.init("The property that was searched for could not be found", "The property '#arguments.name#' could not be found in the object '#arguments.className#'");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>