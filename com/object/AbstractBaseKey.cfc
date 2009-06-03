<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseKey.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Abstract Base class for all keys

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		09/07/2007		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Abstract Base class for all keys" extends="Property" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="AbstractBaseKey" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="getIsComposite" access="public" returntype="boolean" output="false">
	<cfreturn instance.IsComposite />
</cffunction>

<cffunction name="setMemento" hint="Sets the state of the object" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="the state to be set" type="struct" required="Yes">
	<cfscript>
		super.setMemento(arguments.memento);

		setIsComposite(arguments.memento.isComposite);
	</cfscript>
</cffunction>

<cffunction name="validate" hint="Throws an exception if validation fails" access="public" returntype="void" output="false">
	<!--- does nothing --->
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="notifyComplete" hint="notifies the object that it has finished loading, and can do post processing" access="package" returntype="void" output="false">
	<!--- does nothing --->
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setIsComposite" access="private" returntype="void" output="false">
	<cfargument name="IsComposite" type="boolean" required="true">
	<cfset instance.IsComposite = arguments.IsComposite />
</cffunction>

</cfcomponent>