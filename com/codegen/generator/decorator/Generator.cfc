<!--- Document Information -----------------------------------------------------

Title:      Generator.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Generator for Decorator Templates

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		24/11/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Generator for Decorator Templates" extends="transfer.com.codegen.generator.AbstractBaseGenerator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="run" hint="generates the decorators, according to the template" access="public" returntype="void" output="false">
	<cfargument name="regexFilter" hint="optional regex filter against the className of what decorators you want to gen" type="string" required="No">
	<cfscript>
		var classes = getObjectManager().listClasses();
		var len = ArrayLen(classes);
		var class = 0;
		var counter = 1;
		var args = StructNew();
		var object = 0;
		var check = 0;

		for(; counter lte len; counter = counter + 1)
		{
			class = classes[counter];
			object = getObjectManager().getObject(class);

			check = true;

			if(StructKeyExists(arguments, "regexFilter"))
			{
				check = reFind(arguments.regexFilter, class);
			}

			//only write them if they have them
			if(check AND object.hasDecorator())
			{
				writeTemplate(
					path=resolveDotPath(object.getDecorator()) & ".cfc",
					object=object
				);
			}
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>