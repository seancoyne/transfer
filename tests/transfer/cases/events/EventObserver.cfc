<cfcomponent output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="EventObserver" output="false">
	<cfscript>
		setEventCount(0);

		return this;
	</cfscript>
</cffunction>

<cffunction name="actionAfterNewTransferEvent" hint="" access="public" returntype="void" output="false">
	<cfargument name="event" hint="" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		setEventCount(getEventCount() + 1);
	</cfscript>
</cffunction>

<cffunction name="actionAfterCreateTransferEvent" hint="" access="public" returntype="void" output="false">
	<cfargument name="event" hint="" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		setEventCount(getEventCount() + 1);
	</cfscript>
</cffunction>

<cffunction name="getEventCount" access="public" returntype="string" output="false">
	<cfreturn variables.EventCount />
</cffunction>

<cffunction name="setEventCount" access="private" returntype="void" output="false">
	<cfargument name="EventCount" type="string" required="true">
	<cfset variables.EventCount = arguments.EventCount />
</cffunction>


</cfcomponent>