<!--- Document Information -----------------------------------------------------

Title:      RemoteFactory.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    cfc for managing how Transfer is set up for remoting

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		07/04/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="cfc for managing how Transfer is setup for remoting" output="false">

<cfscript>
	instance.static = StructNew();

	instance.static.REMOTING_KEY = "7F81C709-C251-62CF-792787C2D04480A5";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RemoteFactory" output="false">
	<cfargument name="remotingName" hint="the remoting name, if there is one" type="string" required="No">
	<cfscript>
		if(StructKeyExists(arguments, "remotingName"))
		{
			setRemotingName(arguments.remotingName);
		}

		return this;
	</cfscript>
</cffunction>

<cffunction name="storeTransferFactory" hint="stores a given transfer factrory" access="public" returntype="void" output="false">
	<cfargument name="transferFactory" hint="the transfer factory" type="transfer.TransferFactory" required="Yes">
	<cfscript>
		application[getKey()] = arguments.transferFactory;
	</cfscript>
</cffunction>

<cffunction name="getTransferFactory" hint="returns the Transfer factory for the given remoting name, if no remoting name, returns the default"
			access="public" returntype="transfer.TransferFactory" output="false">
	<cfscript>
		return application[getKey()];
	</cfscript>
</cffunction>

<cffunction name="getRemotingName" access="public" returntype="string" output="false">
	<cfreturn instance.remotingName />
</cffunction>

<cffunction name="hasRemotingName" hint="if a remoting name has been configured" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "remotingName") />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setRemotingName" access="private" returntype="void" output="false">
	<cfargument name="remotingName" type="string" required="true">
	<cfset instance.remotingName = arguments.remotingName />
</cffunction>

<cffunction name="getKey" hint="gets the key to store the item under" access="private" returntype="string" output="false">
	<cfscript>
		var key = instance.static.REMOTING_KEY;

		if(hasRemotingName())
		{
			key = key & ":" & getRemotingName();
		}

		return key;
	</cfscript>
</cffunction>

</cfcomponent>