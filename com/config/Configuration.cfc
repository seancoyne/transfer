<!--- Document Information -----------------------------------------------------

Title:      Configuration.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Configuration bean

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		14/09/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="Configuration" hint="Configuration bean">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Configuration" output="false">
	<cfargument name="datasourcePath" hint="The path to datasource xml file. Should be a relative path, i.e. /myapp/configs/datasource.xml" type="string" required="no" default="">
	<cfargument name="configPath" hint="The path to the config xml file, Should be a relative path, i.e. /myapp/configs/transfer.xml" type="string" required="no" default="">
	<cfargument name="definitionPath" hint="directory to write the defition files. Should be from root, i.e. /myapp/definitions/, as it is used for cfinclude" default="/transfer/resources/definitions/" type="string" required="No">
	<cfargument name="enableRemotingSupport" hint="enables remoting support by storing this object in the application scope" type="boolean" required="No" default="false">
	<cfargument name="remotingName" hint="the name for this remoting TransferFactory, only required if you are using 2 Factories in an application" type="string" required="No">
	<cfscript>
		variables.instance = StructNew();

		setConfigPathCollection(ArrayNew(1));

		setDataSourcePath(arguments.datasourcePath);
		setConfigPath(arguments.configPath);
		setDefinitionPath(arguments.definitionPath);
		setDatasourceUserName("");
		setDatasourcePassword("");
		setEnableRemotingSupport(arguments.enableRemotingSupport);

		if(StructKeyExists(arguments, "remotingName"))
		{
			setRemotingName(arguments.remotingName);
		}

		return this;
	</cfscript>
</cffunction>

<cffunction name="getDataSourcePath" access="public" returntype="string" output="false">
	<cfreturn instance.dataSourcePath />
</cffunction>

<cffunction name="setDataSourcePath" access="public" returntype="Configuration" output="false">
	<cfargument name="dataSourcePath" type="string" required="true">
	<cfset instance.dataSourcePath = arguments.dataSourcePath />
	<cfreturn this />
</cffunction>

<cffunction name="getConfigPath" hint="gets the first config path, without includes" access="public" returntype="string" output="false">
	<cfscript>
		var configPathCollection = getConfigPathCollection();

		return configPathCollection[1].configPath;
	</cfscript>
</cffunction>

<cffunction name="getConfigPathCollection" access="public" returntype="array" output="false">
	<cfreturn instance.ConfigPathCollection />
</cffunction>

<cffunction name="setConfigPath" access="public" returntype="Configuration" output="false">
	<cfargument name="configPath" type="string" required="true">
	<cfscript>
		var configPathCollection = getConfigPathCollection();
		configPathCollection[1] = StructNew();
		configPathCollection[1].configPath = arguments.configPath;
		configPathCollection[1].overwrite = false;

		setConfigPathCollection(configPathCollection);

		return this;
	</cfscript>
</cffunction>

<cffunction name="addConfigImport" hint="adds a configuration file import" access="public" returntype="Configuration" output="false">
	<cfargument name="configPath" type="string" required="true">
	<cfargument name="overwrite" hint="overwrite the previous configurations" type="boolean" required="No" default="false">
	<cfscript>
		ArrayAppend(getConfigPathCollection(), arguments);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getDefinitionPath" access="public" returntype="string" output="false">
	<cfreturn instance.definitionPath />
</cffunction>

<cffunction name="setDefinitionPath" access="public" returntype="Configuration" output="false">
	<cfargument name="definitionPath" type="string" required="true">
	<cfset instance.definitionPath = arguments.definitionPath />
	<cfreturn this />
</cffunction>

<cffunction name="getDataSourceName" access="public" returntype="string" output="false">
	<cfreturn instance.datasourceName />
</cffunction>

<cffunction name="setDataSourceName" access="public" returntype="Configuration" output="false">
	<cfargument name="datasourceName" type="string" required="true">
	<cfset instance.datasourceName = arguments.datasourceName />
	<cfreturn this />
</cffunction>

<cffunction name="hasDataSourceName" hint="whether this config object has a datasource name" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "datasourceName") />
</cffunction>

<cffunction name="getDatasourceUserName" access="public" returntype="string" output="false">
	<cfreturn instance.datasourceUserName />
</cffunction>

<cffunction name="setDatasourceUserName" access="public" returntype="Configuration" output="false">
	<cfargument name="datasourceUserName" type="string" required="true">
	<cfset instance.datasourceUserName = arguments.datasourceUserName />
	<cfreturn this />
</cffunction>

<cffunction name="getDatasourcePassword" access="public" returntype="string" output="false">
	<cfreturn instance.datasourcePassword />
</cffunction>

<cffunction name="setDatasourcePassword" access="public" returntype="Configuration" output="false">
	<cfargument name="datasourcePassword" type="string" required="true">
	<cfset instance.datasourcePassword = arguments.datasourcePassword />
	<cfreturn this />
</cffunction>

<cffunction name="getEnableRemotingSupport" access="public" returntype="boolean" output="false">
	<cfreturn instance.enableRemotingSupport />
</cffunction>

<cffunction name="setEnableRemotingSupport" access="public" returntype="Configuration" output="false">
	<cfargument name="enableRemotingSupport" type="boolean" required="true">
	<cfset instance.enableRemotingSupport = arguments.enableRemotingSupport />
	<cfreturn this />
</cffunction>

<cffunction name="getRemotingName" access="public" returntype="string" output="false">
	<cfreturn instance.remotingName />
</cffunction>

<cffunction name="setRemotingName" access="public" returntype="Configuration" output="false">
	<cfargument name="remotingName" type="string" required="true">
	<cfset instance.remotingName = arguments.remotingName />
	<cfreturn this />
</cffunction>

<cffunction name="hasRemotingName" hint="if a remoting name has been configured" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "remotingName") />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setConfigPathCollection" access="private" returntype="void" output="false">
	<cfargument name="ConfigPathCollection" type="array" required="true">
	<cfset instance.ConfigPathCollection = arguments.ConfigPathCollection />
</cffunction>

</cfcomponent>