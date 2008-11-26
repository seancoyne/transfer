<!--- Document Information -----------------------------------------------------

Title:      VOConverter.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Converts the data coming back from Flex VO's to real TransferObjects

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		26/11/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Converts the data coming back from Flex VO's to real TransferObjects" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="VOConverter" output="false">
	<cfargument name="transfer" hint="the transfer cfc from the TransferFactory" type="transfer.com.Transfer" required="Yes">
	<cfscript>
		setTransfer(arguments.transfer);

		return this;
	</cfscript>
</cffunction>

<cffunction name="convert" hint="converts the VO to a real transfer object" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="vo" hint="the value object" type="any" required="Yes">
	<cfscript>
		var className = "";
		var meta = getMetaData(vo);
		var object = 0;
		var transferObject = 0;

		if(StructKeyExists(meta, "transferAlias"))
		{
			className = meta.transferAlias;
		}
		else if(StructKeyExists(arguments.vo, "transferAlias"))
		{
			className = arguments.vo.transferAlias;
		}

		if(NOT Len(className))
		{
			createObject("component", "CannotDetermineTransferClassException").init(arguments.vo);
		}

		object = getTransfer().getTransferMetaData(className);

		transferObject = getTransfer().get(className, getVOPrimaryKey(arguments.vo, object));

		return transferObject;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getVOPrimaryKey" hint="gets the primary key from a VO" access="private" returntype="any" output="false">
	<cfargument name="vo" hint="the vo object" type="any" required="Yes">
	<cfargument name="object" hint="the object meta data" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var primaryKey = arguments.object.getPrimaryKey();
		var result = 0;

		if(primaryKey.getIsComposite())
		{
			//TODO: do composite key support
		}
		else
		{
			return arguments.vo[primaryKey.getName()];
		}
	</cfscript>
</cffunction>

<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.transfer = arguments.transfer />
</cffunction>

</cfcomponent>