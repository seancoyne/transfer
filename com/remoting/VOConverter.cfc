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
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="convert" hint="converts the VO to a real transfer object" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="vo" hint="the value object" type="any" required="Yes">
	<cfargument name="convertEntireGraph" hint="if true, will convert all cfproperty values for the entire object graph. Otherwise, just converts this object."
				type="boolean" required="false" default="false">
	<cfscript>
		var className = "";
		var meta = getMetaData(vo);
		var object = 0;
		var len = 0;
		var counter = 1;
		var property = 0;
		var value = 0;
		var args = 0;

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

		if(StructKeyExists(meta, "properties"))
		{
			len = ArrayLen(meta.properties);
			for(; counter lte len; counter = counter + 1)
			{
				property = meta.properties[counter];

				if(StructKeyExists(arguments.vo, property.name))
				{
					value = arguments.vo[property.name];
					if(isSimpleValue(value))
					{
						args = StructNew();
						args[property.name] = value;

						getMethodInvoker().invokeMethod(transferObject, "set" & property.name, args);
					}
					else
					{
						//TODO: do composition
					}
				}
				else
				{
					//if there is no value, is it null, manage it

					if(Find("[", property.type))
					{
						if(StructKeyExists(transferObject, "clear" & property.name))
						{
							getMethodInvoker().invokeMethod(transferObject, "clear" & property.name);
						}
					}
					else if(Find(".", property.type))
					{
						if(StructKeyExists(transferObject, "remove" & property.name))
						{
							getMethodInvoker().invokeMethod(transferObject, "remove" & property.name);
						}
					}
					else //assume at this point its a simple value
					{
						if(StructKeyExists(transferObject, "set" & property.name & "Null"))
						{
							getMethodInvoker().invokeMethod(transferObject, "set" & property.name & "Null");
						}
					}

					//if there is nothing to do for it, ignore it
				}
			}
		}

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

<cffunction name="isTransferObject" hint="Is this a transferObject?" access="private" returntype="boolean" output="false">
	<cfargument name="object" hint="The object that is being passed in" type="any" required="Yes">
	<cfscript>
		var metadata = getMetaData(arguments.object);

		while(StructKeyExists(metadata, "extends"))
		{
			if(LCase(metadata.name) eq "transfer.com.transferobject")
			{
				return true;
			}

			metadata = metadata.extends;
		}

		return false;
	</cfscript>
</cffunction>

<cffunction name="getMethodInvoker" access="private" returntype="transfer.com.dynamic.MethodInvoker" output="false">
	<cfreturn instance.MethodInvoker />
</cffunction>

<cffunction name="setMethodInvoker" access="private" returntype="void" output="false">
	<cfargument name="MethodInvoker" type="transfer.com.dynamic.MethodInvoker" required="true">
	<cfset instance.MethodInvoker = arguments.MethodInvoker />
</cffunction>

<cffunction name="getTransfer" access="private" returntype="transfer.com.Transfer" output="false">
	<cfreturn instance.transfer />
</cffunction>

<cffunction name="setTransfer" access="private" returntype="void" output="false">
	<cfargument name="transfer" type="transfer.com.Transfer" required="true">
	<cfset instance.transfer = arguments.transfer />
</cffunction>

</cfcomponent>