<cfcomponent name="Dog" extends="transfer.com.TransferDecorator">

	<cffunction name="getThing" hint="" access="public" returntype="string" output="false">
		<cfreturn "dog">
	</cffunction>

	<cffunction name="getObject" access="public" returntype="any" output="false">
		<cfreturn variables.Object />
	</cffunction>

	<cffunction name="setObject" access="public" returntype="void" output="false">
		<cfargument name="Object" type="any" required="true">
		<cfset variables.Object = arguments.Object />
	</cffunction>

</cfcomponent>