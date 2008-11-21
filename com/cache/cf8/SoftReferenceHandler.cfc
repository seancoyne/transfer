<!--- Document Information -----------------------------------------------------

Title:      SoftReferenceHandler.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    CF8 implementation of the soft reference handler that uses a async reap()

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		20/09/2007		Created

------------------------------------------------------------------------------->

<cfcomponent hint="CF8 implementation of the soft reference handler that uses a async reap()" extends="transfer.com.cache.SoftReferenceHandler" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="SoftReferenceHandler" output="false">
	<cfargument name="facadeFactory" hint="The facade factpry for getting to the cache" type="transfer.com.facade.FacadeFactory" required="Yes" _autocreate="false">
	<cfargument name="eventManager" type="transfer.com.events.EventManager" required="true" _autocreate="false">
	<cfscript>
		super.init(argumentCollection=arguments);

		instance.static.THREAD_TIMEOUT = "10"; //if the reap() hasn't run in 10 minutes, run it
		resetLastRunTime();

		setRequestFacade(arguments.facadeFactory.getRequestFacade());
		setThread(createObject("java", "java.lang.Thread"));

		return this;
	</cfscript>
</cffunction>

<cffunction name="reap" hint="this has been seperated out, so the cf8 version can do this async" access="public" returntype="void" output="false">
	<cfset var group = getThread().currentThread().getThreadGroup().getName() />

	<!--- if we're in onAppEnd, or onSessionEnd, ignore --->
	<cfif group eq "scheduler">
		<cfreturn />
	<!--- if we're inside a cfthread, run syncronously --->
	<cfelseif group eq "cfthread">
		<cfscript>
			syncronousReap();
		</cfscript>
	<cfelse>
		<!---
		Let's not be so greedy about threads, let's just have one at a time, so we don't end up queueing stupidly.
		We have cfthread, so we don't need to do this as often.
		 --->
		<cfif DateDiff("n", getLastRunTime(), Now()) gt instance.static.THREAD_TIMEOUT>

			<cflock name="transfer.SoftReferenceHandler.reap" throwontimeout="true" timeout="60">

				<cfif DateDiff("n", getLastRunTime(), Now()) gt instance.static.THREAD_TIMEOUT>
					<cfset setLastRunTime(Now()) />
					<cfthread action="run" name="transfer.SoftReferenceHandler_#getRequestFacade().getThreadID()#">
						<cfscript>
							syncronousReap();
							resetLastRunTime();
						</cfscript>
					</cfthread>
				</cfif>
			</cflock>
		</cfif>
	</cfif>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getLastRunTime" access="private" returntype="date" output="false">
	<cfreturn instance.lastRunTime />
</cffunction>

<cffunction name="setLastRunTime" access="private" returntype="void" output="false">
	<cfargument name="lastRunTime" type="date" required="true">
	<cfset instance.lastRunTime = arguments.lastRunTime />
</cffunction>

<cffunction name="resetLastRunTime" hint="resets the value of the last runtime" access="private" returntype="void" output="false">
	<cfscript>
		var resetAmount = -1 * (instance.static.THREAD_TIMEOUT + 1);
		//set it to the static value + 1
		setLastRuntime(DateAdd("n", resetAmount, Now()));
	</cfscript>
</cffunction>

<cffunction name="getThread" access="private" returntype="any" output="false">
	<cfreturn instance.Thread />
</cffunction>

<cffunction name="setThread" access="private" returntype="void" output="false">
	<cfargument name="Thread" type="any" required="true">
	<cfset instance.Thread = arguments.Thread />
</cffunction>

<cffunction name="getRequestFacade" access="private" returntype="transfer.com.facade.RequestFacade" output="false">
	<cfreturn instance.requestFacade />
</cffunction>

<cffunction name="setRequestFacade" access="private" returntype="void" output="false">
	<cfargument name="requestFacade" type="transfer.com.facade.RequestFacade" required="true">
	<cfset instance.requestFacade = arguments.requestFacade />
</cffunction>

</cfcomponent>