<!--- Document Information -----------------------------------------------------

Title:      VirtualMethodException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exceptions for virtual methods

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		24/11/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Exceptions for virtual methods" extends="Exception" output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">
	<cfargument name="component" hint="the component that the method is attempting to be called on" type="any" required="Yes">

	<cfscript>
		super.init("This method is virtual and must be overwritten",
					"The method '#arguments.methodName#' in '#getMetaData(arguments.component).name#' is virtual and must be overwritten"
					);
	</cfscript>
</cffunction>

</cfcomponent>