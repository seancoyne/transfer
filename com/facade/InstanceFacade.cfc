<!--- Document Information -----------------------------------------------------

Title:      InstanceFacade.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Facade to the Instance Scope

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		16/05/2006		Created

------------------------------------------------------------------------------->

<cfcomponent name="InstanceFacade" hint="Facade to the Instance Scope" extends="AbstractBaseFacade">

<cfscript>
	instance.static.LOCAL_CLASS = "__instance";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getScopePlace" hint="Returns the place in which the Transfer parts are stored" access="private" returntype="struct" output="false">
	<cfargument name="class" hint="the class in question" type="string" required="Yes">
	<cfscript>
		var scope = 0;
		if(arguments.class eq instance.static.LOCAL_CLASS)
		{
			scope = getScope();
			return scope[arguments.class];
		}

		return super.getScopePlace(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="getScope" hint="returns the Instance scope" access="private" returntype="struct" output="false">
	<cfreturn instance>
</cffunction>

</cfcomponent>