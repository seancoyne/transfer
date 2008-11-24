<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseGenerator.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    abstract base class for generation functions

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		24/11/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="abstract base class for generation functions" output="false">

<cfscript>
	instance = StructNew();

	instance.static.tagOpen = chr(2234);
	instance.static.tagClose = chr(2235);
	instance.static.hash = "$$";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="run" hint="run the code generation" access="public" returntype="void" output="false">
	<cfset createObject("component", "transfer.com.exception.VirtualMethodException").init("run", this) />
</cffunction>

<cffunction name="setTemplate" access="public" returntype="void" output="false">
	<cfargument name="template" hint="Either the root path (for cfinclude) to a template, or the name of a template in ./templates" type="string" required="true">

	<cfscript>
		//if we know where it is, great, if not, we assume its in ./templates
		if(FindOneOf("\/", arguments.template))
		{
			instance.template = arguments.template;
			setTemplateFilePath(expandPath(getTemplate()));
		}
		else
		{
			instance.template = "templates/" & arguments.template;
			setTemplateFilePath(getDirectoryFromPath(getMetaData(this).path) & getTemplate());
		}
	</cfscript>
</cffunction>

<cffunction name="println" hint="" access="private" returntype="void" output="false">
	<cfargument name="str" hint="" type="string" required="Yes">
	<cfscript>
		createObject("Java", "java.lang.System").out.println(arguments.str);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseGenerator" output="false">
	<cfargument name="configReader" hint="The XML Reader for the config file" type="transfer.com.io.XMLFileReader" required="Yes" _autocreate="false">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes" _autocreate="false">
	<cfscript>
		setConfigReader(arguments.configReader);
		setObjectManager(arguments.objectManager);

		return this;
	</cfscript>
</cffunction>

<cffunction name="writeCFMLTemplate" hint="writes out a CFML template, escaping cfml, and using the templating language" access="private" returntype="void" output="false">
	<cfargument name="path" hint="the path to write the template to" type="string" required="Yes">
	<cfscript>
		var fileName = createUUID() & ".tmp";
		var templateContents = 0;

		var TemplateFilePath = 0;

		var originalTemplate = getTemplate();

		println(getTemplateFilePath());
	</cfscript>

	<cffile action="read" file="#getTemplateFilePath()#" variable="templateContents">

	<cfscript>
		//skip out tags
		templateContents = replace(templateContents, "<", instance.static.tagOpen, "all");
		templateContents = replace(templateContents, ">", instance.static.tagClose, "all");

		//replace $$ with hashes
		templateContents = replace(templateContents, instance.static.hash, "##", "all");
	</cfscript>

	<cffile action="write" file="#getDirectoryFromPath(getMetaData(this).path)##fileName#" output="#templateContents#">

	<cfscript>
		instance.template = originalTemplate;
	</cfscript>
</cffunction>

<cffunction name="writeTemplate" hint="writes a regular template, in which you can use regular CFML" access="private" returntype="void" output="false">
	<cfargument name="path" hint="the path to write the template to" type="string" required="Yes">

	<cfscript>
		var content = 0;

		if(fileExists(arguments.path))
		{
			//right now, just escape it
			return;
		}

		arguments.configReader = getConfigReader();
		arguments.objectManager = getObjectManager();
	</cfscript>

	<cfsavecontent variable="content">
		<cfinclude template="#getTemplate()#">
	</cfsavecontent>

	<cffile action="write" file="#arguments.path#" output="#content#">
</cffunction>

<cffunction name="ensureDirectory" hint="if a directory doesn't exist, create it" access="private" returntype="void" output="false">
	<cfargument name="path" hint="" type="string" required="Yes">
	<cfif NOT directoryExists(arguments.path)>
		<cfdirectory action="create" directory="#arguments.path#">
	</cfif>
</cffunction>

<cffunction name="resolveCFCPath" hint="determines the directory for a cfc path" access="private" returntype="string" output="false">
	<cfargument name="cfcPath" hint="the . notation to a cfc" type="string" required="Yes">
	<cfscript>
		var root = ListGetAt(arguments.cfcPath, 1, ".");
		var path = expandPath("/" & root);

		//kill off the first one
		arguments.cfcPath = replace(arguments.cfcPath, root, "");
		//use /
		path = path & replace(arguments.cfcPath, ".", "/", "all");

		return path;
	</cfscript>
</cffunction>

<cffunction name="getTemplate" access="private" returntype="string" output="false">
	<cfreturn instance.template />
</cffunction>

<cffunction name="getTemplateFilePath" access="private" returntype="string" output="false">
	<cfreturn instance.templateFilePath />
</cffunction>

<cffunction name="setTemplateFilePath" access="private" returntype="void" output="false">
	<cfargument name="templateFilePath" type="string" required="true">
	<cfset instance.templateFilePath = arguments.templateFilePath />
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="getConfigReader" access="private" returntype="transfer.com.io.XMLFileReader" output="false">
	<cfreturn instance.ConfigReader />
</cffunction>

<cffunction name="setConfigReader" access="private" returntype="void" output="false">
	<cfargument name="ConfigReader" type="transfer.com.io.XMLFileReader" required="true">
	<cfset instance.ConfigReader = arguments.ConfigReader />
</cffunction>

</cfcomponent>