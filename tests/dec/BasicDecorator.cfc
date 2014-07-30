<cfcomponent name="BasicDecorator" extends="transfer.com.TransferDecorator">

<cffunction name="setString" hint="overwrite string to always say 'Decorator'" access="public" returntype="string" output="false">
	<cfset getTransferObject().setString("Decorator")>
</cffunction>

<cffunction name="executeQuery" hint="" access="public" returntype="boolean" output="false">
	<cfscript>
		return getTransaction().execute(this, "_executeQuery");
	</cfscript>
</cffunction>

<cffunction name="_executeQuery" hint="" access="public" returntype="boolean" output="false">
	<cfscript>
		var query = 0;
	</cfscript>
	<cfquery name="query" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select *
		from tbl_a
	</cfquery>

	<cfreturn true />
</cffunction>

</cfcomponent>