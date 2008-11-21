<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseMeta.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Abstract Base class for metadata operations

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		28/10/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Abstract base class for metadata operations" output="false">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="clone" hint="clone this object" access="public" returntype="AbstractBaseMeta" output="false">
	<cfscript>
		//we won't bother init'ing it, as we will clone it
		var clone = createObject("component", getMetaData(this).name);

		clone.setInstance = instance.mixins.setInstance;

		clone.setInstance(StructCopy(variables.instance));

		StructDelete(clone, "setInstance");

		return clone;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfscript>
		//manage mixins
		instance.mixins.setInstance = variables.setInstance;

		StructDelete(this, "setInstance");
		StructDelete(variables, "setInstance");
	</cfscript>
</cffunction>

<cffunction name="cloneArray" hint="clone's an array" access="private" returntype="array" output="false">
	<cfargument name="array" hint="the array to clone all elements on" type="array" required="Yes">
	<cfscript>
		var cloneArray = ArrayNew(1);
		var len = ArrayLen(arguments.array);
		var counter = 1;

		for(; counter lte len; counter = counter + 1)
		{
			ArrayAppend(cloneArray, arguments.array[counter].clone());
		}

		return cloneArray;
	</cfscript>
</cffunction>

<!--- mixins --->

<cffunction name="setInstance" hint="sets the clone instance data" access="public" returntype="void" output="false">
	<cfargument name="instance" hint="the instance scope to pass through" type="struct" required="Yes">
	<cfscript>
		variables.instance = arguments.instance;
	</cfscript>
</cffunction>

</cfcomponent>