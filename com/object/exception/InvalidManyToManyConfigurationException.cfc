<!--- Document Information -----------------------------------------------------

Title:      InvalidManyToManyConfiguration.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for an invalid M2M configuration

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		04/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for an invalid M2M configuration" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="className" hint="the classname of what should be passed in" type="string" required="Yes">
	<cfargument name="classLink1" hint="The first class link" type="string" required="Yes">
	<cfargument name="classLink2" hint="The second class link" type="string" required="Yes">
	
	<cfset super.init("In '#arguments.className#', neither links in the manytomany declaration point to the source object",
					"link[1] refers to class '#arguments.classLink1#', and link[2] refers to #arguments.classLink2#,
						one of which should refer to '#arguments.className#'"
				)/>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>