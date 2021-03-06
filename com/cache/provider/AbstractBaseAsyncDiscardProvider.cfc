<!--- Document Information -----------------------------------------------------

Title:      AbstractBaseAsyncDiscardProvider.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Abstract base provider for caches, that fires discard events asyncronously

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		04/12/2009		Created

------------------------------------------------------------------------------->

<cfcomponent hint="Abstract base provider for caches, that fires discard events asyncronously" extends="AbstractBaseProvider" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AbstractBaseAsyncDiscardProvider" output="false">
	<cfscript>
		super.init();

		setThreadDate(dateAdd("h", -1, Now()));
		setSystem(createObject("java", "java.lang.System"));
		setThread(createObject("java", "java.lang.Thread"));
		setQueue(createObject("java", "java.util.concurrent.ConcurrentLinkedQueue").init());
		setThreadLocalNameCounter(createObject("java", "java.lang.ThreadLocal").init());

		/*
			For some stupid &^%@'d up reason, the super.fireDiscardEvent doesn't resolve to the actual parent
			on a random basis, and resolves to the local version instead when inside the cfthread.

			We will take the super.fireDiscardEvent and move it to a variable scoped method, so there is no confusion.
		*/
		variables.parentFireDiscardEvent = super.fireDiscardEvent;

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="fireDiscardEvent" hint="Fires off the discard to all the Observers" access="private" returntype="void" output="false">
	<cfargument name="object" hint="the object being discarded" type="any" required="Yes">

	<cfscript>
		getQueue().add(arguments.object);

		//if we are in a cfthread, and there is no current thread processing for discard, just do it now
		if(getThread().currentThread().getThreadGroup().getName() eq "cfthread")
		{
			if(dateCompare(getThreadDate(), Now()) eq -1)
			{
				processQueue();
			}
			return;
		}
    </cfscript>

	<cfif dateCompare(getThreadDate(), Now()) eq -1>
		<cflock name="transfer.com.cache.provider.AbstractBaseAsyncDiscardProvider.fireDiscardEvent.#getSystem().identityHashCode(this)#" timeout="3" throwontimeout="false">
			<cfif dateCompare(getThreadDate(), Now()) eq -1>

				<!--- If the thread is still going after 10 minutes, add a new one --->
				<cfset setThreadDate(dateAdd("n", 10, Now()))>
				<cfthread name="transfer.com.cache.provider.AbstractBaseAsyncDiscardProvider.fireDiscardEvent.#getSystem().identityHashCode(this)#.#getThreadLocalNameCount()#">
					<cfset processQueue()>
					<cfset setThreadDate(dateAdd("h", -1, Now()))>
				</cfthread>
			</cfif>
		</cflock>
	</cfif>
</cffunction>

<cffunction name="processQueue" hint="Processes the current queue of objects that are being discarded" access="public" returntype="void" output="false">
	<cfscript>
		var currentThread = getThread().currentThread();
		var priority = currentThread.getPriority();
		var local = {};

		currentThread.setPriority(3);
	</cfscript>
	<cftry>
		<cfscript>
			local.object = getQueue().poll();

			//run through the queue
			while(structKeyExists(local, "object"))
			{
				parentFireDiscardEvent(local.object);

				getThread().yield();

				local.object = getQueue().poll();
			}
		</cfscript>

		<cfcatch>
			<!--- have to do this due to thread pooling --->
			<cfscript>
				currentThread.setPriority(priority); //reset it
            </cfscript>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cfscript>
		currentThread.setPriority(priority); //reset it
    </cfscript>
</cffunction>

<cffunction name="getThreadLocalNameCount" hint="returns a unique incrementing count for this thread" access="public" returntype="numeric" output="false">
	<cfscript>
		var local = {};
		local.count = getThreadLocalNameCounter().get();

		if(structKeyExists(local, "count"))
		{
			getThreadLocalNameCounter().set(local.count + 1);
		}
		else
		{
			getThreadLocalNameCounter().set(1);
		}

		return getThreadLocalNameCounter().get();
    </cfscript>
</cffunction>

<cffunction name="getThreadLocalNameCounter" access="private" returntype="any" output="false">
	<cfreturn instance.threadLocalNameCounter />
</cffunction>

<cffunction name="setThreadLocalNameCounter" access="private" returntype="void" output="false">
	<cfargument name="threadLocalNameCounter" type="any" required="true">
	<cfset instance.threadLocalNameCounter = arguments.threadLocalNameCounter />
</cffunction>

<cffunction name="getThreadDate" access="private" returntype="date" output="false">
	<cfreturn instance.threadDate />
</cffunction>

<cffunction name="setThreadDate" access="private" returntype="void" output="false">
	<cfargument name="threadDate" type="date" required="true">
	<cfset instance.threadDate = arguments.threadDate />
</cffunction>

<cffunction name="getSystem" access="private" returntype="any" output="false">
	<cfreturn instance.system />
</cffunction>

<cffunction name="setSystem" access="private" returntype="void" output="false">
	<cfargument name="system" type="any" required="true">
	<cfset instance.system = arguments.system />
</cffunction>

<cffunction name="getQueue" access="private" returntype="any" output="false">
	<cfreturn instance.queue />
</cffunction>

<cffunction name="setQueue" access="private" returntype="void" output="false">
	<cfargument name="queue" type="any" required="true">
	<cfset instance.queue = arguments.queue />
</cffunction>

<cffunction name="getThread" access="private" returntype="any" output="false">
	<cfreturn instance.thread />
</cffunction>

<cffunction name="setThread" access="private" returntype="void" output="false">
	<cfargument name="thread" type="any" required="true">
	<cfset instance.thread = arguments.thread />
</cffunction>

</cfcomponent>