<!--- Document Information -----------------------------------------------------

Title:      InvalidRelationshipExeception.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for when a composite configuration points to an object witha composite key

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for when a composite configuration points to an object witha composite key" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="relationShipType" hint="the relationship type, m2o, o2m" type="string" required="Yes">
	<cfargument name="compositionName" hint="the name of the composition" type="string" required="Yes">
	<cfargument name="object" hint="the originating object" type="transfer.com.object.Object" required="Yes">
	<cfargument name="linkObject" hint="the objet the composition links to" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		super.init("A #arguments.relationShipType# Relationship must link to an object with an 'id' element",
				"The #arguments.relationShipType# Relationship '#arguments.compositionName#' in class '#arguments.object.getClassName()#' cannot link to class #arguments.linkObject.getClassName()# as it utilises a composite key");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>