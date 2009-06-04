<!--- Document Information -----------------------------------------------------

Title:      ManyToOneNotCreatedException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for when a m2o is not persisted

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		03/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for when a m2m is not persisted" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="object" hint="The object meta in question" type="transfer.com.object.Object" required="Yes">
	<cfargument name="composite" hint="The composite object in question" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		super.init("A ManyToMany TransferObject child is not persisted.",
					"In TransferObject '"& arguments.object.getClassName() &"' manytomany '"& arguments.composite.getClassName() &"' has not been persisted in the database.");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>