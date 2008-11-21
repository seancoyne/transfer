<!--- Document Information -----------------------------------------------------

Title:      DiscardQueueHandler.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    async runs the 'hand Queue' functionality

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		11/09/2007		Created

------------------------------------------------------------------------------->

<cfcomponent hint="async runs the 'hand Queue' functionality" extends="transfer.com.cache.DiscardQueueHandler" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="DiscardQueueHandler" output="false">
	<cfargument name="facadeFactory" hint="The facade factpry for getting to the cache" type="transfer.com.facade.FacadeFactory" required="Yes" _autocreate="false">
	<cfargument name="transfer" hint="Need transfer to call discard" type="transfer.com.Transfer" required="Yes" _autocreate="false">
	<cfscript>
		super.init(argumentCollection=arguments);

		instance.static.THREAD_TIMEOUT = "10"; //if the run() hasn't run in 10 minutes, run it
		resetLastRunTime();

		setThread(createObject("java", "java.lang.Thread"));
		setRequestFacade(arguments.facadeFactory.getRequestFacade());

		return this;
	</cfscript>
</cffunction>

<cffunction name="run" hint="Runs the aspect of clearing out discard queues" access="public" returntype="void" output="false">

	<!--- if we're inside a cfthread, run syncronously --->
	<cfif getThread().currentThread().getThreadGroup().getName() eq "cfthread">
		<cfscript>
			syncronousRun();
		</cfscript>
	<cfelse>
		<!---
		Let's not be so greedy about threads, let's just have one at a time, so we don't end up queueing stupidly.
		We have cfthread, so we don't need to do this as often.
		 --->
		<cfif DateDiff("n", getLastRunTime(), Now()) gt instance.static.THREAD_TIMEOUT>

			<cflock name="transfer.discardQueue.run" throwontimeout="true" timeout="60">

				<cfif DateDiff("n", getLastRunTime(), Now()) gt instance.static.THREAD_TIMEOUT>
					<cfset setLastRunTime(Now()) />
					<cfthread action="run" name="transfer.DiscardQueue_#getRequestFacade().getThreadID()#">
						<cfscript>
							syncronousRun();
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

<cffunction name="getRequestFacade" access="private" returntype="transfer.com.facade.RequestFacade" output="false">
	<cfreturn instance.requestFacade />
</cffunction>

<cffunction name="setRequestFacade" access="private" returntype="void" output="false">
	<cfargument name="requestFacade" type="transfer.com.facade.RequestFacade" required="true">
	<cfset instance.requestFacade = arguments.requestFacade />
</cffunction>

<cffunction name="getThread" access="private" returntype="any" output="false">
	<cfreturn instance.Thread />
</cffunction>

<cffunction name="setThread" access="private" returntype="void" output="false">
	<cfargument name="Thread" type="any" required="true">
	<cfset instance.Thread = arguments.Thread />
</cffunction>

</cfcomponent>