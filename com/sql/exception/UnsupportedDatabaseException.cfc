<!--- Document Information -----------------------------------------------------

Title:      UnsupportedDatabaseException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for unsupported dbs

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for unsupported dbs" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="dbType" hint="the type of the db" type="string" required="Yes">
	<cfscript>
		super.init("An unsupported database has been attempted to be used", "The database of type '#arguments.dbType#' is currently not supported by Transfer");					
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>