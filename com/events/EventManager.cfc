<!--- Document Information -----------------------------------------------------

Title:      EventManager.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Manages Transfer events

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		26/08/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="EventManager" hint="Manages Transfer events">

<cfscript>
	instance = StructNew();
	instance.static.INSTANCE_CLASS = "__instance";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="EventManager" output="false">
	<cfargument name="facadeFactory" hint="The facade factory to access caches" type="transfer.com.facade.FacadeFactory" required="Yes" _autocreate="false">
	<cfargument name="javaLoader" hint="The java loader for the apache commons" type="transfer.com.util.JavaLoader" required="Yes" _autocreate="false">
	<cfscript>
		setTransferEventPool(createObject("component", "transfer.com.events.collections.TransferEventPool").init(arguments.javaLoader));
		setFacadeFactory(arguments.facadeFactory);

		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="use configure for circular dep's" access="public" returntype="void" output="false">
	<cfargument name="cacheManager" hint="The cache manager" type="transfer.com.cache.CacheManager" required="Yes">
	<cfscript>
		setCacheManager(arguments.cacheManager);
    </cfscript>
</cffunction>

<!--- get adapters --->

<!--- add observer functions --->
<cffunction name="addBeforeCreateObserver" hint="Adds a before create observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "beforecreate");
	</cfscript>
</cffunction>

<cffunction name="addAfterCreateObserver" hint="Adds a after create observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "aftercreate");
	</cfscript>
</cffunction>

<cffunction name="addBeforeUpdateObserver" hint="Adds a before Update observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "beforeupdate");
	</cfscript>
</cffunction>

<cffunction name="addAfterUpdateObserver" hint="Adds a after Update observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "afterupdate");
	</cfscript>
</cffunction>

<cffunction name="addBeforeDeleteObserver" hint="Adds a before Delete observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "beforedelete");
	</cfscript>
</cffunction>

<cffunction name="addAfterDeleteObserver" hint="Adds a after Delete observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "afterdelete");
	</cfscript>
</cffunction>

<cffunction name="addAfterDiscardObserver" hint="Adds a before discard observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "AfterDiscard");
	</cfscript>
</cffunction>

<cffunction name="addAfterNewObserver" hint="Adds a after new observer to the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfscript>
		addObserver(arguments.observer, "afternew");
	</cfscript>
</cffunction>

<!--- remove observer functions --->

<cffunction name="removeBeforeCreateObserver" hint="removes a before create observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "beforecreate");
	</cfscript>
</cffunction>

<cffunction name="removeAfterCreateObserver" hint="removes a after create observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "aftercreate");
	</cfscript>
</cffunction>

<cffunction name="removeBeforeUpdateObserver" hint="removes a before Update observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "beforeupdate");
	</cfscript>
</cffunction>

<cffunction name="removeAfterUpdateObserver" hint="removes a after Update observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "afterupdate");
	</cfscript>
</cffunction>

<cffunction name="removeBeforeDeleteObserver" hint="removes a before Delete observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "beforedelete");
	</cfscript>
</cffunction>

<cffunction name="removeAfterDeleteObserver" hint="removes a after Delete observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "afterdelete");
	</cfscript>
</cffunction>

<cffunction name="removeAfterNewObserver" hint="removes a after new observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfscript>
		removeObserver(arguments.observer, "afternew");
	</cfscript>
</cffunction>

<!--- Fire Event Methods --->

<cffunction name="fireBeforeCreateEvent" hint="Fires a before create event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "beforecreate");
	</cfscript>
</cffunction>

<cffunction name="fireAfterCreateEvent" hint="Fires a After create event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "aftercreate");
	</cfscript>
</cffunction>

<cffunction name="fireBeforeUpdateEvent" hint="Fires a before Update event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "beforeupdate");
	</cfscript>
</cffunction>

<cffunction name="fireAfterUpdateEvent" hint="Fires a After Update event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "afterupdate");
	</cfscript>
</cffunction>

<cffunction name="fireBeforeDeleteEvent" hint="Fires a before Delete event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "beforedelete");
	</cfscript>
</cffunction>

<cffunction name="fireAfterDeleteEvent" hint="Fires a After Delete event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "afterdelete");
	</cfscript>
</cffunction>

<cffunction name="fireAfterDiscardEvent" hint="Fires a After Delete event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var class = arguments.transfer.getClassName();
		var scope = getCacheManager().getScope(class);
		var facade = getFacadeFactory().getFacadeByScope(scope);

		/* before firing the discard event, make sure it is removed as an observer */
		if(facade.hasAfterCreateObserverCollection(class))
		{
			facade.getAfterCreateObserverCollection(class).removeObserver(arguments.transfer);
		}

		if(facade.hasAfterUpdateObserverCollection(class))
		{
			facade.getAfterUpdateObserverCollection(class).removeObserver(arguments.transfer);
		}

		if(facade.hasAfterDeleteObserverCollection(class))
		{
			facade.getAfterDeleteObserverCollection(class).removeObserver(arguments.transfer);
		}

		if(facade.hasAfterDiscardObserverCollection(class))
		{
			facade.getAfterDiscardObserverCollection(class).removeObserver(arguments.transfer);
		}

		fireEvent(arguments.transfer, "AfterDiscard");
	</cfscript>
</cffunction>

<cffunction name="fireAfterNewEvent" hint="Fires a After New event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		fireEvent(arguments.transfer, "afterNew");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="fireEvent" hint="fire an event on a ObserverCollection" access="private" returntype="void" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="type" hint="key for what type of collection to get" type="string" required="Yes">
	<cfscript>
		var event = getTransferEventPool().getTransferEvent(arguments.transfer);
		var scope = getCacheManager().getScope(arguments.transfer.getClassName());

		//run the instance scope one
		getFacadeFactory().getInstanceFacade().getObserverCollectionByType(arguments.type, instance.static.INSTANCE_CLASS).fireEvent(event);

		//run the transfer object one
		getObserverCollection(arguments.transfer, arguments.type).fireEvent(event);

		//put it back
		getTransferEventPool().recycle(event);
	</cfscript>
</cffunction>

<cffunction name="addObserver" hint="add an observer, if a TransferObject, make it a soft ref" access="private" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to add" type="any" required="Yes">
	<cfargument name="type" hint="key for what type of collection to get" type="string" required="Yes">
	<cfscript>
		getObserverCollection(arguments.observer, arguments.type).addObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="removeObserver" hint="removes an observer" access="private" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to remove" type="any" required="Yes">
	<cfargument name="type" hint="key for what type of collection to get" type="string" required="Yes">
	<cfscript>
		getObserverCollection(arguments.observer, arguments.type).removeObserver(arguments.observer);
	</cfscript>
</cffunction>

<cffunction name="getObserverCollection" hint="Returns the beforeCreateObserverCollection from the right scope" access="private" returntype="transfer.com.events.collections.AbstractBaseObserverCollection" output="false">
	<cfargument name="object" hint="The object that is being passed in" type="any" required="Yes">
	<cfargument name="type" hint="key for what type to get" type="string" required="Yes">
	<cfscript>
		var facade = 0;
		var cacheConfig = 0;
		var scope = "instance";
		var class = instance.static.INSTANCE_CLASS;

		if(isTransferObject(arguments.object))
		{
			class = arguments.object.getClassName();
			scope = getCacheManager().getScope(class);
		}

		facade = getFacadeFactory().getFacadeByScope(scope);

		return facade.getObserverCollectionByType(arguments.type, class);
	</cfscript>
</cffunction>

<cffunction name="isTransferObject" hint="Is this a transferObject?" access="private" returntype="boolean" output="false">
	<cfargument name="object" hint="The object that is being passed in" type="any" required="Yes">
	<cfscript>
		var metadata = getMetaData(arguments.object);

		while(StructKeyExists(metadata, "extends"))
		{
			if(LCase(metadata.name) eq "transfer.com.transferobject")
			{
				return true;
			}

			metadata = metadata.extends;
		}

		return false;
	</cfscript>
</cffunction>

<cffunction name="getTransferEventPool" access="private" returntype="transfer.com.events.collections.TransferEventPool" output="false">
	<cfreturn variables.TransferEventPool />
</cffunction>

<cffunction name="setTransferEventPool" access="private" returntype="void" output="false">
	<cfargument name="TransferEventPool" type="transfer.com.events.collections.TransferEventPool" required="true">
	<cfset variables.TransferEventPool = arguments.TransferEventPool />
</cffunction>

<cffunction name="getFacadeFactory" access="private" returntype="transfer.com.facade.FacadeFactory" output="false">
	<cfreturn instance.FacadeFactory />
</cffunction>

<cffunction name="setFacadeFactory" access="private" returntype="void" output="false">
	<cfargument name="FacadeFactory" type="transfer.com.facade.FacadeFactory" required="true">
	<cfset instance.FacadeFactory = arguments.FacadeFactory />
</cffunction>

<cffunction name="getCacheManager" access="private" returntype="transfer.com.cache.CacheManager" output="false">
	<cfreturn instance.cacheManager />
</cffunction>

<cffunction name="setCacheManager" access="private" returntype="void" output="false">
	<cfargument name="cacheManager" type="transfer.com.cache.CacheManager" required="true">
	<cfset instance.cacheManager = arguments.cacheManager />
</cffunction>

</cfcomponent>