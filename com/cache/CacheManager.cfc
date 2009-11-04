<!--- Document Information -----------------------------------------------------

Title:      CacheManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manages data persistance

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		19/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="CacheManager" hint="Manages data persistance">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CacheManager" output="false">
	<cfargument name="cacheFactory" hint="the cache factory" type="transfer.com.cache.CacheFactory" required="Yes" _factoryMethod="getCacheFactory">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes" _autocreate="false">
	<cfargument name="facadeFactory" hint="The facade factory to access caches" type="transfer.com.facade.FacadeFactory" required="Yes" _autocreate="false">
	<cfscript>
		setObjectManager(arguments.objectManager);
		setMethodInvoker(arguments.cacheFactory.getMethodInvoker());
		setFacadeFactory(arguments.facadeFactory);

		//append this circular dependency
		arguments.cacheFactory.setSingleton(this);

		setValidateCacheState(arguments.cacheFactory.getValidateCacheState());
		setCacheSynchronise(arguments.cacheFactory.getCacheSynchronise());
		setTransactionQueue(arguments.cacheFactory.getTransactionQueue());
		setCacheMonitor(arguments.cacheFactory.getCacheMonitor());
		setProviderManager(arguments.cacheFactory.getProviderManager());

		return this;
	</cfscript>
</cffunction>

<cffunction name="add" hint="Adds a Transfer Object to the Pool" access="public" returntype="void" output="false">
	<cfargument name="transferObject" hint="the transfer object to be stored" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var class = arguments.transferObject.getClassName();
		var object = getObjectManager().getObject(class);
		var provider = getProviderManager().getProvider(class);
		var key = JavaCast("string", getMethodInvoker().invokeMethod(arguments.transferObject, "get" & object.getPrimaryKey().getName()));

		provider.add(class, key, arguments.transferObject);
	</cfscript>
</cffunction>

<cffunction name="have" hint="Checks if the Transfer Object is persistent in the cache" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfargument name="key" hint="The key for the id of the data" type="string" required="Yes">
	<cfscript>
		var provider = getProviderManager().getProvider(arguments.class);

		return provider.have(arguments.class, JavaCast("string", arguments.key));
	</cfscript>
</cffunction>

<cffunction name="haveObject" hint="Checks to see if the current object is in the cache" access="public" returntype="boolean" output="false">
	<cfargument name="transferObject" hint="The transfer object to be stored" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var class = arguments.transferObject.getClassName();
		var provider = getProviderManager().getProvider(class);
		var object = getObjectManager().getObject(class);
		var key = JavaCast("string", getMethodInvoker().invokeMethod(arguments.transferObject, "get" & object.getPrimaryKey().getName()));

		return provider.have(class, key);
	</cfscript>
</cffunction>

<cffunction name="get" hint="gets a TransferObject from the pool" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfargument name="key" hint="The key for the id of the data" type="string" required="Yes">
	<cfscript>
		var provider = getProviderManager().getProvider(arguments.class);

		return provider.get(arguments.class, JavaCast("string", arguments.key));
	</cfscript>
</cffunction>

<cffunction name="discard" hint="removes a transfer from the cache" access="public" returntype="void" output="false">
	<cfargument name="transferObject" hint="The transfer object to be stored" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var class = arguments.transferObject.getClassName();
		var provider = getProviderManager().getProvider(class);
		var object = getObjectManager().getObject(class);
		var key = JavaCast("string", getMethodInvoker().invokeMethod(arguments.transferObject, "get" & object.getPrimaryKey().getName()));

		provider.discard(class, key);
	</cfscript>
</cffunction>

<cffunction name="discardByClassAndKey" hint="Discards an Object by its class and its key, if it exists" access="public" returntype="void" output="false">
	<cfargument name="className" hint="The class name of the object to discard" type="string" required="Yes">
	<cfargument name="key" hint="The primary key value for the object" type="any" required="Yes">
	<cfscript>
		var provider = getProviderManager().getProvider(arguments.className);

		provider.discard(arguments.className, JavaCast("string", arguments.key));
	</cfscript>
</cffunction>

<cffunction name="discardAll" hint="discards everything from the cache" access="public" returntype="void" output="false">
	<cfscript>
		var classes = getProviderManager().listClasses();
		var class = 0;

		getProviderManager().getDefaultProvider().discardAll();

		getFacadeFactory().clearAll("__instance");
	</cfscript>
	<cfloop array="#classes#" index="class">
		<cfscript>
			getProviderManager().getProvider(class).discardAll();

			getFacadeFactory().clearAll(class);
        </cfscript>
	</cfloop>
</cffunction>

<cffunction name="getScope" hint="gets the scope for a given class" access="public" returntype="string" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfscript>
		return getProviderManager().getProvider(arguments.class).getScope();
    </cfscript>
</cffunction>

<cffunction name="getScopeKey" hint="gets the scope key for a given class" access="public" returntype="string" output="false">
	<cfargument name="class" hint="The name of the class" type="string" required="Yes">
	<cfscript>
		return getProviderManager().getProvider(arguments.class).getScopeKey();
    </cfscript>
</cffunction>

<cffunction name="synchronise" hint="syncronises the data, and returns the cached TransferObject if there is one, otherwise returns the original TransferObject" access="public" returntype="transfer.com.TransferObject" output="false">
	<cfargument name="transfer" hint="The transfer object to syncronise" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getCacheSynchronise().synchronise(arguments.transfer) />
</cffunction>

<cffunction name="validateIsCached" hint="validates if a TransferObject is the same one as in cache" access="public" returntype="boolean" output="false">
	<cfargument name="transfer" hint="The transfer object to syncronise" type="transfer.com.TransferObject" required="Yes">
	<cfreturn getValidateCacheState().validateIsCached(arguments.transfer) />
</cffunction>

<cffunction name="appendTransactionQueue" hint="append a Transfer Objects to the transaction queue" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="the transfer object to append" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		getTransactionQueue().append(arguments.transfer);
	</cfscript>
</cffunction>

<cffunction name="removeTransactionQueue" hint="append a Transfer Objects to the transaction queue" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="the transfer object to append" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		getTransactionQueue().remove(arguments.transfer);
	</cfscript>
</cffunction>

<cffunction name="getCacheMonitor" access="public" returntype="CacheMonitor" output="false">
	<cfreturn instance.CacheMonitor />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getFacadeFactory" access="private" returntype="transfer.com.facade.FacadeFactory" output="false">
	<cfreturn instance.facadeFactory />
</cffunction>

<cffunction name="setFacadeFactory" access="private" returntype="void" output="false">
	<cfargument name="facadeFactory" type="transfer.com.facade.FacadeFactory" required="true">
	<cfset instance.facadeFactory = arguments.facadeFactory />
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="getMethodInvoker" access="private" returntype="transfer.com.dynamic.MethodInvoker" output="false">
	<cfreturn instance.MethodInvoker />
</cffunction>

<cffunction name="setMethodInvoker" access="private" returntype="void" output="false">
	<cfargument name="MethodInvoker" type="transfer.com.dynamic.MethodInvoker" required="true">
	<cfset instance.MethodInvoker = arguments.MethodInvoker />
</cffunction>

<cffunction name="getCacheSynchronise" access="private" returntype="transfer.com.cache.CacheSynchronise" output="false">
	<cfreturn instance.CacheSynchronise />
</cffunction>

<cffunction name="setCacheSynchronise" access="private" returntype="void" output="false">
	<cfargument name="CacheSynchronise" type="transfer.com.cache.CacheSynchronise" required="true">
	<cfset instance.CacheSynchronise = arguments.CacheSynchronise />
</cffunction>

<cffunction name="getValidateCacheState" access="private" returntype="transfer.com.cache.ValidateCacheState" output="false">
	<cfreturn instance.ValidateCacheState />
</cffunction>

<cffunction name="setValidateCacheState" access="private" returntype="void" output="false">
	<cfargument name="ValidateCacheState" type="transfer.com.cache.ValidateCacheState" required="true">
	<cfset instance.ValidateCacheState = arguments.ValidateCacheState />
</cffunction>

<cffunction name="getTransactionQueue" access="private" returntype="TransactionQueue" output="false">
	<cfreturn instance.transactionQueue />
</cffunction>

<cffunction name="setTransactionQueue" access="private" returntype="void" output="false">
	<cfargument name="transactionQueue" type="TransactionQueue" required="true">
	<cfset instance.transactionQueue = arguments.transactionQueue />
</cffunction>

<cffunction name="setCacheMonitor" access="private" returntype="void" output="false">
	<cfargument name="CacheMonitor" type="CacheMonitor" required="true">
	<cfset instance.CacheMonitor = arguments.CacheMonitor />
</cffunction>

<cffunction name="getProviderManager" access="private" returntype="transfer.com.cache.provider.ProviderManager" output="false">
	<cfreturn instance.providerManager />
</cffunction>

<cffunction name="setProviderManager" access="private" returntype="void" output="false">
	<cfargument name="providerManager" type="transfer.com.cache.provider.ProviderManager" required="true">
	<cfset instance.providerManager = arguments.providerManager />
</cffunction>

</cfcomponent>