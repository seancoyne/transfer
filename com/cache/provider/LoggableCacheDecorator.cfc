<!--- Document Information -----------------------------------------------------

Title:      DebuggingProvider.cfc

Author:     Elliott Sprehn
Email:      esprehn@gmail.com

Website:    http://www.elliottsprehn.com

Purpose:    Cache decorator that logs cache activity to a file.

Usage:

Modification Log:

Name			Date			Description
================================================================================
Elliott Sprehn	13/12/2009		Created

------------------------------------------------------------------------------->
<cfcomponent output="false" extends="transfer.com.cache.provider.AbstractBaseProvider">

<cfscript>
	instance = StructNew();
	instance.observerAdded = false;
	
	instance.static.hashCode = createObject("java","java.lang.System").identityHashCode(this);
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="LoggableCacheDecorator" output="false">
	<cfargument name="provider" type="string" required="true">
	<cfargument name="logFile" type="string" required="true">
	<cfscript>
		setCacheProvider(createObject("component", arguments.provider).init(argumentCollection=arguments));
		setLogFileWriter(createObject("component", "transfer.com.io.FileWriter").init(expandPath(arguments.logFile)));
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());
		
		writeLogEntry("Startup");
		
		return super.init();
	</cfscript>
</cffunction>

<cffunction name="add" hint="virtual method: Add an object to the cache, returns if it was successfully cached or not" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfargument name="object" hint="the object to add to the cache" type="any" required="Yes">
	<cfscript>
		var result = getCacheProvider().add(argumentCollection=arguments);
		
		writeLogEntry("Add", arguments.class, arguments.key, lCase(yesNoFormat(result)));

		return result;
	</cfscript>
</cffunction>

<cffunction name="have" hint="virtual method: Is the given class and key in the cache?" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfscript>
		var result = getCacheProvider().have(argumentCollection=arguments);

		writeLogEntry("Have", arguments.class, arguments.key, lCase(yesNoFormat(result)));

		return result;
	</cfscript>
</cffunction>

<cffunction name="get" hint="virtual method: get the given class and key from the cache, if not there, return nothing" access="public" returntype="any" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfscript>
		var result = getCacheProvider().get(argumentCollection=arguments);

		writeLogEntry("Get", arguments.class, arguments.key, lCase(yesNoFormat(isDefined("result") and isObject(result))));

		return result;
	</cfscript>
</cffunction>

<cffunction name="discard" hint="virtual method: Remove the given class and key from the cache, if it exists. Implementations of this method must invoke fireDiscardEvent(obj) when an item is discarded from the cache, but only if it existed in the first place."
			access="public" returntype="void" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfscript>
		// Don't write the log entry here, instead wait for a fireDiscardEvent()
		// so we catch discards from inside the cache too.
		return getCacheProvider().discard(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="discardAll" hint="virtual method: Remove all items from the cache" access="public" returntype="void" output="false">
	<cfscript>
		writeLogEntry("DiscardAll");

		return getCacheProvider().discardAll(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="getCacheProvider" hint="virtual method: get access to the actual cache provider, beit eHCache, ColdBox cache etc" access="public" returntype="any" output="false">

	<!--- Lazy add ourselves as an observer on the first access --->
	<cfif not instance.observerAdded>
		<cflock name="transfer.cache.DebuggingProvider(#instance.static.hashCode#)" timeout="30">
			<cfif not instance.observerAdded>
				<cfset getEventManager().addAfterDiscardObserver(this)>
				<cfset instance.observerAdded = true>
			</cfif>
		</cflock>
	</cfif>
	
	<cfreturn instance.cacheProvider>
</cffunction>

<cffunction name="getCachedClasses" hint="virtual method: return a list of all the cached classes" access="public" returntype="array" output="false">

	<cfreturn getCacheProvider().getCachedClasses()>
</cffunction>

<cffunction name="getSize" hint="virtual method: The number of items in the cache, for  given class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">

	<cfreturn getCacheProvider().getSize(argumentCollection=arguments)>
</cffunction>

<cffunction name="getHits" hint="virtual method: returns the number of hits for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">

	<cfreturn getCacheProvider().getHits(argumentCollection=arguments)>
</cffunction>

<cffunction name="getMisses" hint="virtual method: returns the number of misses for that class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">

	<cfreturn getCacheProvider().getMisses(argumentCollection=arguments)>
</cffunction>

<cffunction name="getEvictions" hint="virtual method: get the total number of cache evictions for this class" access="public" returntype="numeric" output="false">
	<cfargument name="className" hint="the class to retrive hits for" type="string" required="Yes">

	<cfreturn getCacheProvider().getEvictions(argumentCollection=arguments)>
</cffunction>

<cffunction name="resetStatistics" hint="virtual method: resets the statistics" access="public" returntype="void" output="false">

	<cfset getCacheProvider().resetStatistics(argumentCollection=arguments)>
</cffunction>

<cffunction name="shutdown" hint="Some cache implementations may need to be shutdown for cleanup. Overwrite this method when needing this functionality."
			access="public" returntype="void" output="false">	
	<cfscript>
		writeLogEntry("Shutdown");
		
		getCacheProvider().shutdown(argumentCollection=arguments);
	</cfscript>
</cffunction>

<cffunction name="getScope" hint="If a cache is tied to the lifecycle specific coldfusion shared scope, specify it here. This is generally only needed when using request/session as a cache. Defaults to 'instance'"
			access="public" returntype="string" output="false">

	<cfreturn getCacheProvider().getScope(argumentCollection=arguments)>
</cffunction>

<cffunction name="getScopeKey" hint="If a cache is tied to the lifecycle specific coldfusion shared scope, Specify what the key it should be stored under, in that scope Defaults to 'transfer'"
			access="public" returntype="string" output="false">

	<cfreturn getCacheProvider().getScopeKey(argumentCollection=arguments)>
</cffunction>

<cffunction name="setEventManager" access="public" returntype="void" output="false">
	<cfargument name="eventManager" type="transfer.com.events.EventManager" required="true">
	<cfscript>
		super.setEventManager(arguments.eventManager);
		instance.cacheProvider.setEventManager(arguments.eventManager);
	</cfscript>
</cffunction>

<cffunction name="setObjectManager" access="public" returntype="void" output="false">
	<cfargument name="objectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfscript>
		super.setObjectManager(arguments.objectManager);
		instance.cacheProvider.setObjectManager(arguments.objectManager);
	</cfscript>
</cffunction>

<cffunction name="actionAfterDiscardTransferEvent" access="public" returntype="void" default="void" hint="Observer action method for when discards occur" output="false">
	<cfargument name="event" type="transfer.com.events.TransferEvent" required="true" hint="The Transfer Event Object">
	<cfscript>
		var transferObject = arguments.event.getTransferObject();
		var class = transferObject.getClassName();
		var object = getObjectManager().getObject(class);
		var key = JavaCast("string", getMethodInvoker().invokeMethod(transferObject, "get" & object.getPrimaryKey().getName()));
		
		writeLogEntry("Discard", transferObject.getClassName(), key);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writeLogEntry" hint="Writes a log entry to the file"
			access="private" returntype="void" output="false">
	<cfargument name="action" type="string" required="true">
	<cfargument name="className" type="string" required="false">
	<cfargument name="key" type="string" required="false">
	<cfargument name="result" type="string" required="false">
	
	<cfscript>
		// Do as much before as possible to reduce the time we hold the lock.
		var date = now();
		var dateFormatted = DateFormat(date,'d/m/yyyy') & " " & TimeFormat(date, "HH:mm:ss.l");
		var line = dateFormatted & " " & trim(arrayToList(arguments," "));
	</cfscript>
	
	<cflock name="transfer.cache.DebuggingProvider(#instance.static.hashCode#)" timeout="30">
		<cfscript>
			getLogFileWriter().append(line);
		</cfscript>
	</cflock>
</cffunction>

<cffunction name="getLogFileWriter" access="private" returntype="transfer.com.io.FileWriter" output="false">

	<cfreturn instance.logFileWriter>
</cffunction>

<cffunction name="setLogFileWriter" access="private" returntype="void" output="false">
	<cfargument name="logFileWriter" type="transfer.com.io.FileWriter" required="true">

	<cfset instance.logFileWriter = arguments.logFileWriter>
</cffunction>

<cffunction name="getMethodInvoker" access="private" returntype="transfer.com.dynamic.MethodInvoker" output="false">
	<cfreturn instance.methodInvoker />
</cffunction>

<cffunction name="setMethodInvoker" access="private" returntype="void" output="false">
	<cfargument name="methodInvoker" type="transfer.com.dynamic.MethodInvoker" required="true">
	<cfset instance.methodInvoker = arguments.methodInvoker />
</cffunction>

<cffunction name="setCacheProvider" access="private" returntype="void" output="false">
	<cfargument name="cacheProvider" type="any" required="true">
		
	<cfset instance.cacheProvider = arguments.cacheProvider>
</cffunction>

</cfcomponent>