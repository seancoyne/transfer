<!--- Document Information -----------------------------------------------------

Title:      GeneratationManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manager for code generation templates

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		24/11/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Manager for code generation" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="GenerationManager" output="false">
	<cfargument name="configReader" hint="The XML Reader for the config file" type="transfer.com.io.XMLFileReader" required="Yes" _autocreate="false">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes" _autocreate="false">
	<cfscript>
		setConfigReader(arguments.configReader);
		setObjectManager(arguments.objectManager);

		return this;
	</cfscript>
</cffunction>

<cffunction name="createDecoratorGenerator" hint="shorthand to get a Decorator Generator" access="public" returntype="transfer.com.codegen.generator.decorator.Generator" output="false">
	<cfreturn create("transfer.com.codegen.generator.decorator.Generator") />
</cffunction>

<cffunction name="create" hint="creates a code generator with the given class name, and passes in the configReader, and the objectManager"
			access="public" returntype="transfer.com.codegen.generator.AbstractBaseGenerator" output="false">
			<cfargument name="className" hint="the classname of the generator" type="string" required="Yes">
	<cfreturn createObject("component", arguments.className).init(getConfigReader(), getObjectManager()) />
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

<cffunction name="getConfigReader" access="private" returntype="transfer.com.io.XMLFileReader" output="false">
	<cfreturn instance.ConfigReader />
</cffunction>

<cffunction name="setConfigReader" access="private" returntype="void" output="false">
	<cfargument name="ConfigReader" type="transfer.com.io.XMLFileReader" required="true">
	<cfset instance.ConfigReader = arguments.ConfigReader />
</cffunction>

</cfcomponent>