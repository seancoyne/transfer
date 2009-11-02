<!--- Document Information -----------------------------------------------------

Title:      MethodInjectException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for when something goes wrong injecting a method

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for when something goes wrong injecting a method" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="udf" hint="the udf in question" type="any" required="Yes">
	<cfargument name="message" hint="the error message" type="string" required="Yes">
	<cfscript>
		super.init("Error inserting method #toString(arguments.UDF)#", arguments.message);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>