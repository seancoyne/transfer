<!--- Document Information -----------------------------------------------------

Title:      MultipleRecordsFoundException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for when multiple records are found in a read statement

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		04/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for when multiple records are found in a read statement" extends="Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="className" hint="the class name of the object" type="string" required="Yes">
	<cfargument name="query" hint="the query in question" type="query" required="Yes">
	<cfscript>
		super.init("The parameters provided resulted in more than one record",
					"The query for '#arguments.className#' resulted in #arguments.query.recordCount# records in the Query"
					);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>