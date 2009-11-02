<!--- Document Information -----------------------------------------------------

Title:      RecursiveCompositionException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for when selection goes into a recursive loop

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for when selection goes into a recursive loop" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="object" hint="the object in question" type="transfer.com.object.Object" required="Yes">
	<cfargument name="compositionName" hint="the name of the composition we are looking at" type="string" required="Yes">
	<cfscript>
		super.init("The structure of your configuration file causes an infinite loop",
					"The object '#arguments.object.getClassName()#' has a recursive link back to itself through composition '#arguments.compositionName#'.
				You will need to set one of the elements in this chain to lazy='true' for it to work.");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>