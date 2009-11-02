<!--- Document Information -----------------------------------------------------

Title:      EHCacheProvider.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    EHCache Provider

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		02/11/2009		Created

------------------------------------------------------------------------------->

<cfcomponent hint="EHCache Provider" extends="AbstractBaseProvider" output="false">

<cfscript>
	instance.static.SERVER_KEY = "ehCache.Provider.7D914950-C778-11DE-8A39-0800200C9A66";
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="EHCacheProvider" output="false">
	<cfargument name="config" hint="the path to the config file" type="string" required="Yes">
	<cfscript>
		var jars = 0;

		super.init();

		setSystem(createObject("java", "java.lang.System"));
	</cfscript>

	<cfif NOT hasJavaLoader()>
		<cflock name="transfer.com.cache.provider.EHCacheProvider" throwontimeout="true" timeout="60">
			<cfscript>
				if(NOT hasJavaLoader())
				{
					jars = queryJars();

					//also add in jars for dynamic proxies

					setJavaLoader(createObject("component", "transfer.com.util.javaloader.JavaLoader").init(jars));
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		setEHCacheManager(getJavaLoader().create("net.sf.ehcache.CacheManager").init(expandPath(arguments.config)));

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="add" hint="Adds an object to the cache. If there is no cache for this class, one is created based on the default cache configuration"
			access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfargument name="object" hint="the object to add to the cache" type="any" required="Yes">
	<cfscript>
		var cache = 0;
		var element = getJavaLoader().create("net.sf.ehcache.Element").init(arguments.key, arguments.object);
    </cfscript>
	<cfif NOT getEHCacheManager().cacheExists(arguments.class)>
    	<cflock name="transfer.com.cache.provider.EHCacheProvider.#getSystem().identityHashCode(this)#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(NOT getEHCacheManager().cacheExists(arguments.class))
    		{
				getEHCacheManager().addCache(arguments.class);
			}
    	</cfscript>
    	</cflock>
    </cfif>
	<cfscript>
		cache = getEHCacheManager().getCache(arguments.class);

		cache.put(element);

		return true;
    </cfscript>
</cffunction>

<cffunction name="have" hint="Is the given class and key in the cache?" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfscript>
		var cache = 0;

		if(NOT getEHCacheManager().cacheExists(arguments.class))
		{
			return false;
		}

		cache = getEHCacheManager().getCache(arguments.class);

		//isKeyInCache is not synchronized, so keep an eye out for any problems.
		return cache.isKeyInCache(arguments.key);
    </cfscript>
</cffunction>

<cffunction name="get" hint="virtual method: get the given class and key from the cache, if not there, return nothing" access="public" returntype="any" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfscript>
		var cache = 0;

		if(NOT getEHCacheManager().cacheExists(arguments.class))
		{
			return;
		}

		cache = getEHCacheManager().getCache(arguments.class);

		return cache.get(arguments.key);
    </cfscript>
</cffunction>


<cffunction name="getCacheProvider" hint="Returns the EHCache CacheManager" access="public" returntype="any" output="false">
	<cfreturn getEHCacheManager() />
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="queryJars" hint="pulls a query of all the jars in the /resources/lib folder" access="private" returntype="array" output="false">
	<cfscript>
		var qJars = 0;
		//the path to my jar library
		var path = getDirectoryFromPath(getMetaData(this).path) & "/ehcache-lib";
		var jarList = "";
		var aJars = ArrayNew(1);
		var libName = 0;
	</cfscript>

	<cfdirectory action="list" name="qJars" directory="#path#" filter="*.jar" sort="name desc"/>

	<cfloop query="qJars">
		<cfset ArrayAppend(aJars, directory & "/" & name)>
	</cfloop>

	<cfreturn aJars>
</cffunction>

<cffunction name="getEHCacheManager" access="private" returntype="any" output="false">
	<cfreturn instance.eHCacheManager />
</cffunction>

<cffunction name="setEHCacheManager" access="private" returntype="void" output="false">
	<cfargument name="eHCacheManager" type="any" required="true">
	<cfset instance.eHCacheManager = arguments.eHCacheManager />
</cffunction>

<cffunction name="getJavaLoader" access="public" returntype="transfer.com.util.javaLoader.JavaLoader" output="false">
	<cfreturn StructFind(server, instance.static.SERVER_KEY) />
</cffunction>

<cffunction name="setJavaLoader" access="public" returntype="void" output="false">
	<cfargument name="javaLoader" type="transfer.com.util.javaLoader.JavaLoader" required="true">
	<cfset StructInsert(server, instance.static.SERVER_KEY, arguments.javaLoader) />
</cffunction>

<cffunction name="hasJavaLoader" hint="if the server scope has the JavaLoader in it" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(server, instance.static.SERVER_KEY)/>
</cffunction>

<cffunction name="getSystem" access="private" returntype="any" output="false">
	<cfreturn instance.System />
</cffunction>

<cffunction name="setSystem" access="private" returntype="void" output="false">
	<cfargument name="System" type="any" required="true">
	<cfset instance.System = arguments.System />
</cffunction>

</cfcomponent>