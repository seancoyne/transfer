<!--- Document Information -----------------------------------------------------

Title:      InvalidCompositeIDException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for invlalid configuration of composite id's

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for invlalid configuration of composite id's" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="object" hint="the object in question" type="transfer.com.object.Object" required="Yes">
	<cfargument name="parentOneToMany" hint="the parent one to many that causes the issue" type="transfer.com.object.parentOneToMany" required="Yes">
	
	<cfscript>
		super.init("All of the parent oneToMany declared in a 'compositeid' declaration' must be lazy='true'",
					"The operation you have tried to execute would have caused corrupt data, or an infinite loop. In object '#arguments.object.getClassName()#' the
					oneToMany '#arguments.parentOneToMany.getName()#' on object '#arguments.parentOneToMany.getLink().getToObject().getClassName()#' are lazy='false', when it must be lazy='true'");			
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>