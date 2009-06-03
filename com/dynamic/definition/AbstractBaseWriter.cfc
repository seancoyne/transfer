<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseWriter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Abstract Base Class for all writers

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/04/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="AbstractBaseWriter" hint="Abstract Base Class for all writers">

<cfscript>
	instance = StructNew();

	//constants
	static = StructNew();

	//characters to use
	static.char.quote = """";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfargument name="objectManager" hint="The Object Manager" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		setObjectManager(objectManager);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="q" hint="returns a quote" access="private" returntype="string" output="false">
	<cfreturn static.char.quote>
</cffunction>

</cfcomponent>