<!--- Document Information -----------------------------------------------------

Title:      CacheMonitor.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    The cache monitor class for introspection and statistics on caching

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		14/07/2008		Created

------------------------------------------------------------------------------->

<cfcomponent hint="The cache monitor class for introspection and statistics on caching" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CacheMonitor" output="false">
	<cfargument name="providerManager" hint="The provider manager" type="transfer.com.cache.provider.ProviderManager" required="true" _autocreate="false">
	<cfscript>
		setProviderManager(arguments.providerManager);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getCachedClasses" hint="returns all the cached classes" access="public" returntype="array" output="false">
	<cfscript>
		var args = StructNew();
		args.classArray = createObject("java", "java.util.ArrayList").init();

		eachCacheProvider(executeGetCachedClasses, args);

		return args.classArray;
	</cfscript>
</cffunction>

<cffunction name="getSize" hint="A look at how many items are in cache, where a copy of the cache is taken, and inspected item by item. Speed and accurancy is determined by the Cache Provider"
			access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfscript>
		return getProviderManager().getProvider(arguments.className).getSize(arguments.className);
	</cfscript>
</cffunction>

<cffunction name="getTotalSize" hint="get the total cache size for all classes" access="public" returntype="numeric" output="false">
	<cfscript>
		var iterator = getCachedClasses().iterator();
		var sum = 0;

		while(iterator.hasNext())
		{
			sum = sum + getSize(iterator.next());
		}

		return sum;
	</cfscript>
</cffunction>

<cffunction name="getHits" hint="returns the number of hits for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfscript>
		return getProviderManager().getProvider(arguments.className).getHits(arguments.className);
	</cfscript>
</cffunction>

<cffunction name="getMisses" hint="returns the number of misses for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfscript>
		return getProviderManager().getProvider(arguments.className).getMisses(arguments.className);
	</cfscript>
</cffunction>

<cffunction name="resetStatistics" hint="reset all statistics" access="public" returntype="void" output="false">
	<cfscript>
		eachCacheProvider(executeResetStatistics);
	</cfscript>
</cffunction>

<cffunction name="getTotalHits" hint="get the total number of hits" access="public" returntype="numeric" output="false">
	<cfscript>
		var iterator = getCachedClasses().iterator();
		var sum = 0;

		while(iterator.hasNext())
		{
			sum = sum + getHits(iterator.next());
		}

		return sum;
	</cfscript>
</cffunction>

<cffunction name="getTotalMisses" hint="get the total number of hits" access="public" returntype="numeric" output="false">
	<cfscript>
		var iterator = getCachedClasses().iterator();
		var sum = 0;

		while(iterator.hasNext())
		{
			sum = sum + getMisses(iterator.next());
		}

		return sum;
	</cfscript>
</cffunction>

<cffunction name="getHitMissRatio" hint="returns the ratio of hits vs misses. Values above 1 mean that more hits are occuring than misses." access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the name of the class to get the ratio for" type="string" required="Yes">
	<cfscript>
		var misses = getMisses(arguments.className);

		//avoid /0 errors
		if(misses eq 0)
		{
			return 1;
		}

		return getHits(arguments.className) / misses;
	</cfscript>
</cffunction>

<cffunction name="getTotalHitMissRatio" hint="returns the ratio of total hits vs total misses. Values above 1 mean that more hits are occurring more than misses." access="public" returntype="numeric" output="false">
	<cfscript>
		var misses = getTotalMisses();

		//avoid /0 errors
		if(misses eq 0)
		{
			return 1;
		}

		return getTotalHits() / misses;
	</cfscript>
</cffunction>

<cffunction name="getEvictions" hint="get the total number of cache evictions for this class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfscript>
		return getProviderManager().getProvider(arguments.className).getEvictions(arguments.className);
	</cfscript>
</cffunction>

<cffunction name="getTotalEvictions" hint="get the total number of cache evictions" access="public" returntype="numeric" output="false">
	<cfscript>
		var iterator = getCachedClasses().iterator();
		var sum = 0;

		while(iterator.hasNext())
		{
			sum = sum + getEvictions(iterator.next());
		}

		return sum;
	</cfscript>
</cffunction>

<cffunction name="getDefaultCache" hint="gets the default native implementation of the cache" access="public" returntype="any" output="false">
	<cfreturn getProviderManager().getDefaultProvider().getCacheProvider() />
</cffunction>

<cffunction name="getCache" hint="gets the native implementation of the cache for a given class" access="public" returntype="any" output="false">
	<cfargument name="className" hint="the name of the class we are looking for a cache for" type="string" required="Yes">
	<cfreturn getProviderManager().getProvider(arguments.className).getCacheProvider() />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="eachCacheProvider" hint="HOF for running a function against each provider" access="private" returntype="void" output="false">
	<cfargument name="func" hint="the function to be run against the provider" type="any" required="Yes">
	<cfargument name="args" hint="the argument collections" type="struct" required="No" default="#StructNew()#">
	<cfscript>
		var call = arguments.func;
		var classes = getProviderManager().listClasses();
		var class = 0;

		args.provider = getProviderManager().getDefaultProvider();

		call(argumentCollection=args);
    </cfscript>
	<cfloop array="#classes#" index="class">
		<cfscript>
			args.provider = getProviderManager().getProvider(class);
			call(argumentCollection=args);
        </cfscript>
	</cfloop>
</cffunction>

<!--- HOF commands --->

<cffunction name="executeGetCachedClasses" hint="Command function for getting all the caches" access="private" returntype="void" output="false">
	<cfargument name="provider" hint="a cache provider" type="transfer.com.cache.provider.AbstractBaseProvider" required="Yes">
	<cfargument name="classArray" hint="the array of classes" type="array" required="Yes">
	<cfscript>
		var classes = arguments.provider.getCachedClasses();

		arguments.classArray.addAll(classes);
    </cfscript>
</cffunction>

<cffunction name="executeResetStatistics" hint="Command function for resetting the statistics on all cache providers" access="private" returntype="void" output="false">
	<cfargument name="provider" hint="a cache provider" type="transfer.com.cache.provider.AbstractBaseProvider" required="Yes">
	<cfscript>
		arguments.provider.resetStatistics();
    </cfscript>
</cffunction>


<cffunction name="getProviderManager" access="private" returntype="transfer.com.cache.provider.ProviderManager" output="false">
	<cfreturn instance.providerManager />
</cffunction>

<cffunction name="setProviderManager" access="private" returntype="void" output="false">
	<cfargument name="providerManager" type="transfer.com.cache.provider.ProviderManager" required="true">
	<cfset instance.providerManager = arguments.providerManager />
</cffunction>

</cfcomponent>
