<!--- Document Information -----------------------------------------------------

Title:      DatasourceDAO.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    DAO for datasource

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		27/06/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="DatasourceDAO" hint="DAO for the datasource Bean">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="DatasourceDAO" output="false">
	<cfargument name="datasourceFactory" hint="the datasource factory" type="transfer.com.sql.DatasourceFactory" required="Yes">
	<cfargument name="xmlFileReader" hint="The file path to the config file" type="transfer.com.io.XMLFileReader" required="No">
	<cfargument name="configuration" hint="A configuration bean. Can hold the datasource details" type="transfer.com.config.Configuration" required="No">
	<cfscript>
		if(StructKeyExists(arguments, "xmlFileReader"))
		{
			setXMLReader(arguments.xmlFileReader);
		}
		else if(StructKeyExists(arguments, "configuration"))
		{
			setConfiguration(configuration);
		}
		else
		{
			createObject("component", "transfer.com.sql.exception.InvalidDatasourceConfigurationException").init();
		}

		setDatasourceFactory(arguments.datasourceFactory);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getDataSource" hint="Gets a datasource bean" access="public" returntype="Datasource" output="false">
	<cfscript>
		if(hasXMLReader())
		{
			return getDatasourceFromXML();
		}
		else if(getConfiguration().hasDatasourceName())
		{
			return getDatasoucefromConfiguration();
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getDataSourceFromXML" hint="returns a datasource from xml" access="private" returntype="Datasource" output="false">
	<cfscript>
		var datasource = getDatasourceFactory().getDatasource();
		var xDataSource = getXMLReader().search("/datasource/");

		var memento = Structnew();

		//convenience
		xDatasource = xDatasource[1];

		memento.name = xDatasource.name.xmlText;
		memento.username = xDatasource.username.xmlText;
		memento.password = xDatasource.password.xmlText;

		datasource.setMemento(memento);

		return datasource;
	</cfscript>
</cffunction>

<cffunction name="getDatasoucefromConfiguration" hint="returns te data source from a config obejct" access="private" returntype="Datasource" output="false">
	<cfscript>
		var datasource = getDatasourceFactory().getDatasource();
		var memento = StructNew();

		memento.name = getConfiguration().getDatasourceName();
		memento.username = getConfiguration().getDatasourceUserName();
		memento.password = getConfiguration().getDatasourcePassword();

		datasource.setMemento(memento);

		return datasource;
	</cfscript>
</cffunction>

<cffunction name="getXMLReader" access="private" returntype="transfer.com.io.XMLFileReader" output="false">
	<cfreturn instance.XMLReader />
</cffunction>

<cffunction name="setXMLReader" access="private" returntype="void" output="false">
	<cfargument name="XMLReader" type="transfer.com.io.XMLFileReader" required="true">
	<cfset instance.XMLReader = arguments.XMLReader />
</cffunction>

<cffunction name="hasXmlReader" hint="whether this object has a xmlReader" access="private" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "XMLReader") />
</cffunction>

<cffunction name="getConfiguration" access="private" returntype="transfer.com.config.Configuration" output="false">
	<cfreturn instance.configuration />
</cffunction>

<cffunction name="setConfiguration" access="private" returntype="void" output="false">
	<cfargument name="configuration" type="transfer.com.config.Configuration" required="true">
	<cfset instance.configuration = arguments.configuration />
</cffunction>

<cffunction name="hasConfiguration" hint="whether this object has a Configuration" access="private" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "configuration") />
</cffunction>

<cffunction name="getDatasourceFactory" access="private" returntype="transfer.com.sql.DatasourceFactory" output="false">
	<cfreturn instance.DatasourceFactory />
</cffunction>

<cffunction name="setDatasourceFactory" access="private" returntype="void" output="false">
	<cfargument name="DatasourceFactory" type="transfer.com.sql.DatasourceFactory" required="true">
	<cfset instance.DatasourceFactory = arguments.DatasourceFactory />
</cffunction>

</cfcomponent>