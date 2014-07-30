<cfcomponent extends="transfer.com.events.EventManager" output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="any" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="fireAfterDiscardEvent" hint="Fires a After Delete event" access="public" returntype="string" output="false">
	<cfargument name="transfer" hint="a transfer object the event is about" type="transfer.com.TransferObject" required="Yes">
</cffunction>

</cfcomponent>