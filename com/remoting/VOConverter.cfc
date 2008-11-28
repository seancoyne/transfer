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
		var className = resolveVOTransferClassName(arguments.vo);
		var meta = getMetaData(vo);
		var object = 0;
		var len = 0;
		var counter = 1;
		var property = 0;
		var value = 0;
		var args = 0;
		var composite = 0;
		var compositeClass = 0;

		object = getTransfer().getTransferMetaData(className);

		if(voHasPrimaryKey(arguments.vo, object))
		{
			transferObject = getTransfer().get(className, getVOPrimaryKey(arguments.vo, object));
			transferObject = transferObject.clone(); //take a clone to avoid multithread issues
		}
		else
		{
			transferObject = getTransfer().new(className);
		}

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
						invokeSetProperty(transferObject, property.name, value);
					}
					else
					{
						if(isObject(value))
						{
							if(arguments.convertEntireGraph)
							{
								composite = convert(value, arguments.convertEntireGraph);
							}
							else
							{
								compositeClass = resolveVOTransferClassName(value);
								composite = getTransfer().get(compositeClass, getVOPrimaryKey(value, getTransfer().getTransferMetaData(compositeClass)));
								composite = composite.clone();
							}

							invokeSetProperty(transferObject, property.name, composite);
						}
						else if(isArray(value))
						{
						}
						else if(isStruct(value))
						{
						}
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
					else if(Find(".", property.type) OR NOT FindOneOf("string,boolean,guid,uuid,date,binary", property.type))
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

<cffunction name="invokeSetProperty" hint="inokes setting a property on a TO" access="private" returntype="void" output="false">
	<cfargument name="transferObject" hint="the transfer object" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="property" hint="the name of the property" type="string" required="Yes">
	<cfargument name="value" hint="the value to set" type="any" required="Yes">
	<cfscript>
		var meta = getMetaData(arguments.transferObject["set" & arguments.property]);
	</cfscript>
	<cfinvoke component="#arguments.transferObject#" method="set#arguments.property#">
		<cfinvokeargument name="#meta.parameters[1].name#" value="#arguments.value#">
	</cfinvoke>
</cffunction>

<cffunction name="voHasPrimaryKey" hint="checks to see if the VO has a primary key value" access="private" returntype="boolean" output="false">
	<cfargument name="vo" hint="the vo object" type="any" required="Yes">
	<cfargument name="object" hint="the object meta data" type="transfer.com.object.Object" required="Yes">
	<cfscript>
		var primaryKey = arguments.object.getPrimaryKey();

		if(primaryKey.getIsComposite())
		{
			//TODO: do composite key support
		}
		else
		{
			return StructKeyExists(arguments.vo, primaryKey.getName());
		}
	</cfscript>
</cffunction>

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

<cffunction name="resolveVOTransferClassName" hint="resolves the Transfer classname for VO" access="private" returntype="string" output="false">
	<cfargument name="vo" hint="the vo object" type="any" required="Yes">
	<cfscript>
		var meta = getMetaData(arguments.vo);
		var className = 0;

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

		return className;
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