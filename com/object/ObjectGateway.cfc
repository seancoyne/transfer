<!--- Document Information -----------------------------------------------------

Title:      ObjectGateway.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    gateway to queries on the XML structure

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		11/10/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="ObjectGateway" hint="gateway to queries on the XML structure">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="ObjectGateway" output="false">
	<cfargument name="configReader" hint="XML config reader" type="transfer.com.io.XMLFileReader" required="Yes">
	<cfscript>
		setConfigReader(arguments.configReader);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getManyToManyLinksByClassLinkTo" hint="Gets a query of Many to Many details by the class it is linked to" access="public" returntype="query" output="false">
	<cfargument name="className" hint="The classname to search on" type="string" required="Yes">

	<cfscript>
		//get all many to many that have a link to the given class
		var result = getConfigReader().search("/transfer/objectDefinitions//manytomany[link[@to='#arguments.className#']]");
		var len = ArrayLen(result);
		var counter = 1;

		var qManyToMany = QueryNew("name,table,linkFrom,linkTo,columnFrom,columnTo");

		var manytomany = 0;

		for(; counter lte len; counter = counter + 1)
		{
			manytomany = result[counter];

			QueryAddRow(qManyToMany);
			QuerySetCell(qManyToMany, "name", manyToMany.xmlAttributes.name);
			QuerySetCell(qManyToMany, "table", manyToMany.xmlAttributes.table);
			QuerySetCell(qManyToMany, "linkFrom", manyToMany.xmlChildren[1].xmlAttributes.to);
			QuerySetCell(qManyToMany, "linkTo", manyToMany.xmlChildren[2].xmlAttributes.to);
			QuerySetCell(qManyToMany, "columnFrom", manyToMany.xmlChildren[1].xmlAttributes.column);
			QuerySetCell(qManyToMany, "columnTo", manyToMany.xmlChildren[2].xmlAttributes.column);
		}

		return qManyToMany;
	</cfscript>
</cffunction>

<cffunction name="getObjectCount" hint="returns the count of the total number of objects defined" access="public" returntype="numeric" output="false">
	<cfscript>
		var result = getConfigReader().search("//object");

		return ArrayLen(result);
	</cfscript>
</cffunction>

<cffunction name="getCacheScopeCount" hint="returns the right count for the number of objects under a certain cache scope" access="public" returntype="numeric" output="false">
	<cfargument name="scope" hint="the scope to look for caching under" type="string" required="Yes">
	<cfscript>
		var xDefault = getConfigReader().search("/transfer/objectCache/defaultcache/scope");
		var count = 0;
		var xCache = 0;

		if(ArrayLen(xDefault) AND xDefault[1].xmlAttributes.type eq arguments.scope)
		{
			//if the default cache is this value, we need to check how many aren't of this type
			xCache = getConfigReader().search("/transfer/objectCache/cache/scope[@type != '#arguments.scope#']");

			return getObjectCount() - ArrayLen(xCache);
		}
		else
		{
			//otherwise, we just count those that are
			xCache = getConfigReader().search("/transfer/objectCache/cache/scope[@type = '#arguments.scope#']");

			return ArrayLen(xCache);
		}
	</cfscript>
</cffunction>

<cffunction name="getParentOneToManyClasses" hint="get's the className of objects that have oneToMany that point to this class" access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfscript>
		var xParentOneToMany = getConfigReader().search("/transfer/objectDefinitions[//object[onetomany[link[@to = '#arguments.className#']]]]");

		return getClassNameArray(xParentOneToMany, oneToManyFilter, arguments);
	</cfscript>
</cffunction>


<cffunction name="getParentManyToManyClasses" hint="get's the classNames of objects that have a ManyToMany that point to this class" access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfscript>
		var xParentManyToMany = getConfigReader().search("/transfer/objectDefinitions[//object[manytomany[link[@to = '#arguments.className#']]]]");

		return getClassNameArray(xParentManyToMany, manyToManyFilter, arguments);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getClassNameArray" hint="returns xpath search as a classname query" access="private" returntype="array" output="false">
	<cfargument name="objects" type="any" required="true">
	<cfargument name="filter" hint="filter higher order function to test with" type="any" required="Yes">
	<cfargument name="filterArgs" hint="arguments to pass the the filter" type="struct" required="No" default="#StructNew()#">
	<cfargument name="packageName" type="string" required="false" default="">
	<cfargument name="classSet" hint="the struct to put the data in" type="struct" required="no" default="#StructNew()#">
	<cfscript>
		var name = 0;
		var counter = 0;
		var len = 0;
		var item = 0;
		var filterCheck = true;
		var call = arguments.filter;

		if(isArray(arguments.objects))
		{
			len = ArrayLen(arguments.objects);
			for(counter = 1; counter lte len; counter = counter + 1)
			{
				item = arguments.objects[counter];
				if(item.xmlName eq "package")
				{
					name = item.xmlattributes.name;
				}
				else
				{
					name = "";
				}

				getClassNameArray(item, filter, arguments.filterArgs, name, arguments.classSet);
			}

			return StructKeyArray(arguments.classSet);
		}
	</cfscript>

	<cfif StructKeyExists(arguments.objects, "object")>
		<cfset len = ArrayLen(arguments.objects.object) />
		<cfloop from="1" to="#len#" index="counter">
			<cfscript>
				item = arguments.objects.object[counter];

				arguments.filterArgs.xObject = item;
				filterCheck = call(argumentCollection=arguments.filterArgs);

				if(filterCheck)
				{
					name = ListAppend(arguments.packageName, item.xmlattributes.name, ".");
					arguments.classSet[name] = 1;
				}
			</cfscript>
		</cfloop>
	</cfif>

	<cfif StructKeyExists(arguments.objects, "package")>
		<cfset len = ArrayLen(arguments.objects.package) />
		<cfloop from="1" to="#len#" index="counter">
			<cfscript>
				item = arguments.objects.package[counter];
				name = ListAppend(arguments.packageName, item.xmlattributes.name, ".");
				getClassNameArray(item, arguments.filter, arguments.filterArgs, name, arguments.classSet);
			</cfscript>
		</cfloop>
	</cfif>

	<cfreturn StructKeyArray(arguments.classSet) />
</cffunction>

<!--- HOF for getClassNameQuery --->

<cffunction name="onetoManyFilter" hint="the one to many filter" access="private" returntype="boolean" output="false">
	<cfargument name="xObject" hint="xml data for an object" type="any" required="Yes">
	<cfargument name="className" hint="the classname for the onetomany to have to point to" type="string" required="Yes">
	<cfscript>
		if(StructKeyExists(arguments.xObject, "onetomany") AND Compare(arguments.xObject.onetomany.link.xmlAttributes.to, arguments.className) eq 0)
		{
			return true;
		}

		return false;
	</cfscript>
</cffunction>

<cffunction name="manytoManyFilter" hint="the many to many filter" access="private" returntype="boolean" output="false">
	<cfargument name="xObject" hint="xml data for an object" type="any" required="Yes">
	<cfargument name="className" hint="the classname for the onetomany to have to point to" type="string" required="Yes">
	<cfscript>
		if(StructKeyExists(arguments.xObject, "manytomany"))
		{
			if(Compare(arguments.xObject.manytomany.link[1].xmlAttributes.to, arguments.className) eq 0
			 	OR
			 	Compare(arguments.xObject.manytomany.link[2].xmlAttributes.to, arguments.className) eq 0)
			 {
			 	return true;
			 }
		}

		return false;
	</cfscript>
</cffunction>

<!--- /HOF for getClassNameQuery --->

<cffunction name="getConfigReader" access="private" returntype="transfer.com.io.XMLFileReader" output="false">
	<cfreturn instance.ConfigReader />
</cffunction>

<cffunction name="setConfigReader" access="private" returntype="void" output="false">
	<cfargument name="ConfigReader" type="transfer.com.io.XMLFileReader" required="true">
	<cfset instance.ConfigReader = arguments.ConfigReader />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>