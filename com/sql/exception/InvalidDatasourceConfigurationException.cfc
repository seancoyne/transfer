<!--- Document Information -----------------------------------------------------

Title:      InvalidDatasourceConfigurationException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception for an invalid configuration of a datasource

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		05/06/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception for an invalid configuration of a datasource" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfscript>
		super.init("Neither a XML Configuration or a Configuration object configuration provided.",
				"Either a datsouce XML file needs to be provided, or the Configuration bean must have the DataSourceName set on it.");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>