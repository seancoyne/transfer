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
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="getCachedClasses" hint="returns all the cached classes" access="public" returntype="array" output="false">
	<cfscript>
		var args = StructNew();
		args.classArray = createObject("java", "java.util.ArrayList").init();

		eachCacheManager(executeGetCachedClasses, args);

		return args.classArray;
	</cfscript>
</cffunction>

<cffunction name="getEstimatedSize" hint="A fast lookup of how many items in the cache, simply by checking its size, which may not be exactly accurate" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfscript>
		var config = getCacheConfigManager().getCacheConfig().getConfig(arguments.className);
		var facade = getFacadeFactory().getFacadeByScope(config.getScope());

		if(facade.hasCacheManager())
		{
			return facade.getCacheManager().getEstimatedSize(arguments.className);
		}

		return 0;
	</cfscript>
</cffunction>

<cffunction name="getCalculatedSize" hint="A slow look at how many items are in cache, where a copy of the cache is taken, and inspected item by item." access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfscript>
		var config = getCacheConfigManager().getCacheConfig().getConfig(arguments.className);
		var facade = getFacadeFactory().getFacadeByScope(config.getScope());

		if(facade.hasCacheManager())
		{
			return facade.getCacheManager().getCalculatedSize(arguments.className);
		}

		return 0;
	</cfscript>
</cffunction>

<cffunction name="getTotalEstimatedSize" hint="get the estimated size for all classes" access="public" returntype="numeric" output="false">
	<cfscript>
		var iterator = getCachedClasses().iterator();
		var sum = 0;

		while(iterator.hasNext())
		{
			sum = sum + getEstimatedSize(iterator.next());
		}

		return sum;
	</cfscript>
</cffunction>

<cffunction name="getTotalCalculatedSize" hint="get the calculated size for all classes" access="public" returntype="numeric" output="false">
	<cfscript>
		var iterator = getCachedClasses().iterator();
		var sum = 0;

		while(iterator.hasNext())
		{
			sum = sum + getCalculatedSize(iterator.next());
		}

		return sum;
	</cfscript>
</cffunction>

<cffunction name="getHits" hint="returns the number of hits for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfscript>
		return getMapValue(getHitMap(), arguments.className);
	</cfscript>
</cffunction>

<cffunction name="getMisses" hint="returns the number of misses for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfscript>
		return getMapValue(getMissMap(), arguments.className);
	</cfscript>
</cffunction>

<cffunction name="resetHitsAndMisses" hint="resets the Hit and MIss counters back to 0" access="public" returntype="void" output="false">
	<cfscript>
		setHitMap(StructNew());
		setMissMap(StructNew());
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
			return 0;
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
			return 0;
		}

		return getTotalHits() / misses;
	</cfscript>
</cffunction>

<cffunction name="resetEvictions" hint="resets eviction counters back to 0" access="public" returntype="void" output="false">
	<cfscript>
		setEvictMap(StructNew());
	</cfscript>
</cffunction>

<cffunction name="getEvictions" hint="get the total number of cache evictions for this class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">
	<cfscript>
		return getMapValue(getEvictMap(), arguments.className);
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


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>
