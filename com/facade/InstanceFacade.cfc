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

<cffunction name="hasScopePlace" hint="checks to see if the scope has been accessed at all" access="private" returntype="boolean" output="false">
	<cfargument name="class" hint="the class in question" type="string" required="Yes">
	<cfscript>
		if(arguments.class eq instance.static.LOCAL_CLASS)
		{
			return structKeyExists(getScope(), arguments.class);
		}

		return super.hasScopePlace(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="getScopePlace" hint="Returns the place in which the Transfer parts are stored" access="private" returntype="struct" output="false">
	<cfargument name="class" hint="the class in question" type="string" required="Yes">
	<cfscript>
		var scope = 0;
	</cfscript>

	<cfif arguments.class eq instance.static.LOCAL_CLASS>
		<cfset scope = getScope()>

		<cfif NOT structKeyExists(scope, arguments.class)>
			<cflock name="transfer.ScopeFacade.#getIdentityHashCode(scope)#" timeout="60">
				<cfscript>
					if(NOT structKeyExists(scope, arguments.class))
					{
						scope[arguments.class] = StructNew();
					}
				</cfscript>
			</cflock>
		</cfif>

		<cfreturn scope[arguments.class] />

	</cfif>

	<cfreturn super.getScopePlace(argumentCollection=arguments) />
</cffunction>

<cffunction name="getScope" hint="returns the Instance scope" access="private" returntype="struct" output="false">
	<cfreturn variables.instance>
</cffunction>

</cfcomponent>