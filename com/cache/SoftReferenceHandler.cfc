<!--- Document Information -----------------------------------------------------

Title:      SoftReferenceHandler.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    A place to manage all the soft references in the system

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		20/02/2007		Created

------------------------------------------------------------------------------->

<cfcomponent name="SoftReferenceHandler" hint="Handles Soft References in Transfer" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="SoftReferenceHandler" output="false">
	<cfargument name="facadeFactory" hint="The facade factpry for getting to the cache" type="transfer.com.facade.FacadeFactory" required="Yes" _autocreate="false">
	<cfscript>
		var Collections = createObject("java", "java.util.Collections");
		//instance scope please
		variables.instance = StructNew();

		setFacadeFactory(arguments.facadeFactory);
		setReferenceQueue(createObject("java", "java.lang.ref.ReferenceQueue").init());

		//we need to use a Java collection, as we are using objects as keys
		setReferenceClassMap(Collections.synchronizedMap(createObject("java", "java.util.HashMap").init()));

		return this;
	</cfscript>
</cffunction>

<cffunction name="register" hint="Registers a new TransferObject with the Handler, and returns a java.ref.softReference" access="public" returntype="any" output="false">
	<cfargument name="transfer" hint="The transfer object" type="transfer.com.TransferObject" required="Yes">
	<cfscript>
		var softRef = createObject("java", "java.lang.ref.SoftReference").init(arguments.transfer, getReferenceQueue());

		//StructInsert(getReferenceClassMap(), softRef, arguments.transfer.getClassName());
		getReferenceClassMap().put(softRef, arguments.transfer.getClassName());

		return softRef;
	</cfscript>
</cffunction>

<cffunction name="clearAllReferences" hint="clear and queue all the soft refrences stored in here" access="public" returntype="void" output="false">
	<cfscript>
		var iterator = getReferenceClassMap().keySet().iterator();
		var softRef = 0;

		//loop over all soft references
		while(iterator.hasNext())
		{
			softRef = iterator.next();
			softRef.clear();
			softRef.enqueue();
		}
	</cfscript>
</cffunction>

<cffunction name="reap" hint="this has been seperated out, so the cf8 version can do this async" access="public" returntype="void" output="false">
	<cfscript>
		syncronousReap();
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="syncronousReap" hint="syncronous Reap: reaps the collected objects out of the pool" access="private" returntype="void" output="false">
	<cfscript>
		var local = StructNew(); //we will use this, as isDefined seems to be causing heap issues
		var softRef = 0;

		local.softRef = getReferenceQueue().poll();

		while(StructKeyExists(local, "softRef"))
		{
			//remove resolution
			softRef = local.softRef;

			//tell the world that we've been reap'd!!!
			handleReap(softRef, getFacadeFactory().getInstanceFacade());
			handleReap(softRef, getFacadeFactory().getApplicationFacade());
			handleReap(softRef, getFacadeFactory().getRequestFacade());
			handleReap(softRef, getFacadeFactory().getServerFacade());
			handleReap(softRef, getFacadeFactory().getSessionFacade());
			//really not required, but to keep clean
			handleReap(softRef, getFacadeFactory().getNoneFacade());

			getReferenceClassMap().remove(softRef);
			//StructDelete(getReferenceClassMap(), softRef);

			local.softRef = getReferenceQueue().poll();
		}
	</cfscript>
</cffunction>

<cffunction name="handleReap" hint="Handles a single reap for a facade" access="private" returntype="void" output="false">
	<cfargument name="softRef" hint="java.lang.ref.SoftReference: The soft reference to reap" type="any" required="Yes">
	<cfargument name="facade" hint="The facade to handle" type="transfer.com.facade.AbstractBaseFacade" required="Yes">
	<cfscript>
		//reap on the caching layer
		if(arguments.facade.hasCacheManager())
		{
			arguments.facade.getCacheManager().reap(JavaCast("string", getReferenceClassMap().get(arguments.softRef)), arguments.softRef);
		}

		//reap on the observer layer
		if(arguments.facade.hasAfterCreateObserverCollection())
		{
			arguments.facade.getAfterCreateObserverCollection().removeObserverByKey(arguments.softRef);
		}

		if(arguments.facade.hasAfterUpdateObserverCollection())
		{
			arguments.facade.getAfterUpdateObserverCollection().removeObserverByKey(arguments.softRef);
		}

		if(arguments.facade.hasAfterDeleteObserverCollection())
		{
			arguments.facade.getAfterDeleteObserverCollection().removeObserverByKey(arguments.softRef);
		}

		if(arguments.facade.hasBeforeCreateObserverCollection())
		{
			arguments.facade.getBeforeCreateObserverCollection().removeObserverByKey(arguments.softRef);
		}

		if(arguments.facade.hasBeforeUpdateObserverCollection())
		{
			arguments.facade.getBeforeUpdateObserverCollection().removeObserverByKey(arguments.softRef);
		}

		if(arguments.facade.hasBeforeDeleteObserverCollection())
		{
			arguments.facade.getBeforeDeleteObserverCollection().removeObserverByKey(arguments.softRef);
		}

		if(arguments.facade.hasAfterDiscardObserverCollection())
		{
			arguments.facade.getAfterDiscardObserverCollection().removeObserverByKey(arguments.softRef);
		}
	</cfscript>
</cffunction>

<cffunction name="getReferenceClassMap" access="private" returntype="struct" output="false">
	<cfreturn instance.ReferenceClassMap />
</cffunction>

<cffunction name="setReferenceClassMap" access="private" returntype="void" output="false">
	<cfargument name="ReferenceClassMap" type="struct" required="true">
	<cfset instance.ReferenceClassMap = arguments.ReferenceClassMap />
</cffunction>

<cffunction name="getFacadeFactory" access="private" returntype="transfer.com.facade.FacadeFactory" output="false">
	<cfreturn instance.FacadeFactory />
</cffunction>

<cffunction name="setFacadeFactory" access="private" returntype="void" output="false">
	<cfargument name="FacadeFactory" type="transfer.com.facade.FacadeFactory" required="true">
	<cfset instance.FacadeFactory = arguments.FacadeFactory />
</cffunction>

<cffunction name="getReferenceQueue" access="private" hint="java.lang.ref.ReferenceQueue" returntype="any" output="false">
	<cfreturn instance.ReferenceQueue />
</cffunction>

<cffunction name="setReferenceQueue" access="private" returntype="void" output="false">
	<cfargument name="ReferenceQueue" type="any" hint="java.lang.ref.ReferenceQueue" required="true">
	<cfset instance.ReferenceQueue = arguments.ReferenceQueue />
</cffunction>

</cfcomponent>