<!--- Document Information -----------------------------------------------------

Title:      CannotDetermineTransferClassException.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Exception when unable to determine the VO=>Transfer Class translation

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		26/11/2008		Created

------------------------------------------------------------------------------->
<cfcomponent hint="Exception when unable to determine the VO=>Transfer Class translation" extends="transfer.com.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="vo" hint="the vo that can't be determined" type="any" required="Yes">
	<cfscript>
		super.init("Could not determine the TransferObject to convert this Flex VO into",
				"Transfer Alias for VO '#getMetaData(arguments.vo).name#' could not determined." &
				"You may need to set the 'transferAlias' meta data on the Decorator, or set 'this.transferAlias' on the Decorator");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>