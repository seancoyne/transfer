<!--- Document Information -----------------------------------------------------

Title:      RemoteProxy.cfc.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Direct Transfer remote proxy for remoting integration

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		21/11/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Direct Transfer remote proxy for remoting integration" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="get" hint="remote proxy for Transfer.get()" access="remote" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="class" hint="The name of the package and class (Case Sensitive)" type="string" required="Yes">
	<cfargument name="key" hint="Primary key for the object in the DB, string if non composite, struct if composite" type="any" required="Yes">
	<cfscript>
		return getTransfer().get(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="save" hint="remote proxy for Transfer.save()" access="remote" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="transfer" hint="The transfer to save" type="transfer.com.TransferObject" required="Yes">

	<cfset arguments.transfer = getVOConverter().convert(arguments.transfer) />

	<cfset getTransfer().save(arguments.transfer) />

	<cfreturn arguments.transfer />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RemoteProxy" output="false">
	<cfargument name="transferFactory" hint="the TransferFactory" type="transfer.TransferFactory" required="Yes">
	<cfscript>
		setTransfer(arguments.transferFactory.getTransfer());
		setVoConverter(createObject("component", "VOConverter").init(getTransfer()));

		return this;
	</cfscript>
</cffunction>

<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.transfer = arguments.transfer />
</cffunction>

<cffunction name="getVOConverter" access="private" returntype="VOConverter" output="false">
	<cfreturn instance.voConverter />
</cffunction>

<cffunction name="setVOConverter" access="private" returntype="void" output="false">
	<cfargument name="voConverter" type="voConverter" required="true">
	<cfset instance.voConverter = arguments.voConverter />
</cffunction>

</cfcomponent>