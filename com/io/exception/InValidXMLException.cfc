<!--- Document Information -----------------------------------------------------

Title:      InValidXMLException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for XML that doesn't match its schema

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for XML that doesn't match its schema'" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="xmlPath" hint="the path to the xml" type="string" required="Yes">
	<cfargument name="detail" hint="the detail of the exception" type="string" required="Yes">
	<cfscript>
		super.init("The XML Provided in '" & arguments.xmlPath & "' is not valid against its XML Schema", arguments.detail);
					
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>