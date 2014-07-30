<cfcomponent output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="InjectObserver" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="actionAfterNewTransferEvent" hint="" access="public" returntype="void" output="false">
	<cfargument name="event" hint="" type="transfer.com.events.TransferEvent" required="Yes">
	<cfscript>
		arguments.event.getTransferObject().setObject(this);
	</cfscript>
</cffunction>

</cfcomponent>