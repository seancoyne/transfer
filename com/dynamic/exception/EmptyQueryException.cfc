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

<cfcomponent hint="Exception when the query provided to populate this Transfer object is empty" extends="transfer.com.exception.Exception">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">

	<cfscript>
		super.init("The query provided to populate this transfer is empty.",
					"It is likely the ID that has been selected for this query no longer exists"
					);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>