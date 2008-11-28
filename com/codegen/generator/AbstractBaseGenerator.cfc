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
	instance.static.escapeHash = "$$";
	instance.static.escapeTagOpen = "{{";
	instance.static.escapeTagClose = "}}";
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

<cffunction name="_dump">
	<cfargument name="s">
	<cfargument name="abort" default="true">
	<cfset var g = "">
		<cfdump var="#arguments.s#">
		<cfif arguments.abort>
		<cfabort>
		</cfif>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseGenerator" output="false">
	<cfargument name="configReader" hint="The XML Reader for the config file" type="transfer.com.io.XMLFileReader" required="Yes" _autocreate="false">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes" _autocreate="false">
	<cfargument name="definitionPath" hint="Path to where the definitions are kept" type="string" required="Yes">
	<cfscript>
		setConfigReader(arguments.configReader);
		setObjectManager(arguments.objectManager);
		setDefinitionPath(arguments.definitionPath);

		setCommentStart("<!" & "---");
		setCommentEnd("--->");

		return this;
	</cfscript>
</cffunction>

<cffunction name="writeTemplate" hint="writes a regular template, in which you can use regular CFML" access="private" returntype="void" output="false">
	<cfargument name="path" hint="the path to write the template to" type="string" required="Yes">
	<cfargument name="escapeCFML" hint="whether or not escape CFML processing" type="boolean" required="No" default="true">

	<cfscript>
		var content = 0;
		var fileName = createUUID() & ".template";

		//state for the template
		var state = StructCopy(arguments);
		var templateReader = 0;
		var templateWriter = 0;
		var local = StructNew();

		StructDelete(state, "path");
		StructDelete(state, "escapeCFML");

		templateReader = createObject("component", "transfer.com.io.FileReader").init(getTemplateFilePath());

		content = templateReader.getContent();

		if(arguments.escapeCFML)
		{
			//skip out tags and hashes
			content = replace(content, "<", instance.static.tagOpen, "all");
			content = replace(content, ">", instance.static.tagClose, "all");
			content = replace(content, "##", "####", "all");
			content = replace(content, instance.static.escapeTagOpen, "<", "all");
			content = replace(content, instance.static.escapeTagClose, ">", "all");

			//replace $$ with hashes
			content = replace(content, instance.static.escapeHash, "##", "all");
		}

		content = '<cfimport prefix="gen" taglib="/transfer/com/codegen/generator/tags"><gen:template><cfoutput>' & content & '</cfoutput></gen:template>';

		state.configReader = getConfigReader();
		state.objectManager = getObjectManager();

		templateWriter = createObject("component", "transfer.com.io.FileWriter").init(expandPath(getDefinitionPath()) & fileName);

		templateWriter.write(content);
	</cfscript>

<cfsavecontent variable="content"><cfinclude template="#getDefinitionPath()##fileName#"></cfsavecontent>

	<cfscript>
		//delete the template after we are done
		templateWriter.delete();

		if(fileExists(arguments.path))
		{
			doBlockWrite(arguments.path, local.blocks, arguments.escapeCFML);
		}
		else
		{
			doTemplateWrite(arguments.path, content, arguments.escapeCFML);
		}
	</cfscript>
</cffunction>

<cffunction name="doTemplateWrite" hint="does a write of the template, assuming it doesn't exist" access="private" returntype="void" output="false">
	<cfargument name="path" hint="the path to write the template to" type="string" required="Yes">
	<cfargument name="content" hint="the string content for the template" type="string" required="Yes">
	<cfargument name="escapeCFML" hint="whether or not escape CFML processing" type="boolean" required="Yes">
	<cfscript>
		var outputWriter = createObject("component", "transfer.com.io.FileWriter").init(arguments.path);

		if(arguments.escapeCFML)
		{
			arguments.content = replace(arguments.content, instance.static.tagOpen, "<", "all");
			arguments.content = replace(arguments.content, instance.static.tagClose, ">", "all");
		}

		outputWriter.ensureDirectory();

		outputWriter.write(arguments.content);
	</cfscript>
</cffunction>

<cffunction name="doBlockWrite" hint="does a write of the template, assuming it doesn't exist" access="private" returntype="void" output="false">
	<cfargument name="path" hint="the path to write the template to" type="string" required="Yes">
	<cfargument name="blocks" hint="the blocks content for the template" type="array" required="Yes">
	<cfargument name="escapeCFML" hint="whether or not escape CFML processing" type="boolean" required="Yes">

	<cfscript>
		var reader = createObject("component", "transfer.com.io.FileReader").init(arguments.path);

		var buffer = createObject("java", "java.lang.StringBuffer").init(reader.getContent());

		var writer = createObject("component", "transfer.com.io.FileWriter").init(arguments.path);

		var pattern = createObject("java", "java.util.regex.Pattern");
		var matcher = 0;
		var block = 0;

		var len = ArrayLen(arguments.blocks);
		var counter = 1;
		for(; counter lte len; counter = counter + 1)
		{
			block = blocks[counter];

			/*
			<!--- :::cfproperty::: --->
			*/

			pattern = createObject("java", "java.util.regex.Pattern").compile("(" & getCommentStart() & " :::" & block.name & "::: " & getCommentEnd() & ")(.*?)("& getCommentStart() &" :::/" & block.name & "::: "& getCommentEnd() &")", pattern.DOTALL);

			matcher = pattern.matcher(buffer);

			if(matcher.find())
			{
				if(arguments.escapeCFML)
				{
					block.content = replace(block.content, instance.static.tagOpen, "<", "all");
					block.content = replace(block.content, instance.static.tagClose, ">", "all");
				}

				//replace the content with the block
				buffer.replace(matcher.start(2), matcher.end(2), block.content);
			}
		}

		//do this very last, in case something goes wrong
		reader.delete();

		writer.write(Trim(buffer.toString()));
	</cfscript>
</cffunction>

<cffunction name="resolveDotPath" hint="determines the directory for a dot path" access="private" returntype="string" output="false">
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

<cffunction name="getDefinitionPath" access="private" returntype="string" output="false">
	<cfreturn instance.DefinitionPath />
</cffunction>

<cffunction name="setDefinitionPath" access="private" returntype="void" output="false">
	<cfargument name="DefinitionPath" type="string" required="true">
	<cfset instance.DefinitionPath = arguments.DefinitionPath />
</cffunction>

<cffunction name="getCommentStart" access="private" returntype="string" output="false">
	<cfreturn instance.commentStart />
</cffunction>

<cffunction name="setCommentStart" access="private" returntype="void" output="false">
	<cfargument name="commentStart" type="string" required="true">
	<cfset instance.commentStart = arguments.commentStart />
</cffunction>

<cffunction name="getCommentEnd" access="private" returntype="string" output="false">
	<cfreturn instance.commentEnd />
</cffunction>

<cffunction name="setCommentEnd" access="private" returntype="void" output="false">
	<cfargument name="commentEnd" type="string" required="true">
	<cfset instance.commentEnd = arguments.commentEnd />
</cffunction>

</cfcomponent>