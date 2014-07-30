<cfcomponent name="BaseCase" extends="net.sourceforge.cfunit.framework.TestCaseExtra">

<cffunction name="initTransfer" hint="" access="private" returntype="void" output="false">
	<cfscript>
		if(structKeyExists(application, "transferFactory"))
		{
			application.transferFactory.shutdown();
		}

		application.transferFactory = createObject("component", "transfer.TransferFactory").init("/test/resources/datasource.xml",
																							  "/test/resources/transfera.xml",
																							  "/test/resources/defs");
	</cfscript>
</cffunction>

<cffunction name="getTransfer" hint="" access="public" returntype="transfer.com.Transfer" output="false">
	<cfreturn application.transferFactory.getTransfer()>
</cffunction>

<cffunction name="getDatasource" hint="" access="public" returntype="transfer.com.sql.Datasource" output="false">
	<cfreturn application.transferFactory.getDataSource()>
</cffunction>

<cffunction name="getTransferB" hint="" access="public" returntype="transfer.com.Transfer" output="false">
	<cfreturn application.transferFactoryb.getTransfer()>
</cffunction>

<cffunction name="getDatasourceB" hint="" access="public" returntype="transfer.com.sql.Datasource" output="false">
	<cfreturn application.transferFactoryb.getDataSource()>
</cffunction>

<cffunction name="getTransferC" hint="" access="public" returntype="transfer.com.Transfer" output="false">
	<cfreturn application.transferFactoryc.getTransfer()>
</cffunction>

<cffunction name="getDatasourceC" hint="" access="public" returntype="transfer.com.sql.Datasource" output="false">
	<cfreturn application.transferFactoryc.getDataSource()>
</cffunction>

<cffunction name="getTransferD" hint="" access="public" returntype="transfer.com.Transfer" output="false">
	<cfreturn application.transferFactoryd.getTransfer()>
</cffunction>

<cffunction name="getDatasourceD" hint="" access="public" returntype="transfer.com.sql.Datasource" output="false">
	<cfreturn application.transferFactoryd.getDataSource()>
</cffunction>

<cffunction name="getTransferE" hint="" access="public" returntype="transfer.com.Transfer" output="false">
	<cfreturn application.transferFactoryE.getTransfer()>
</cffunction>

<cffunction name="debug" hint="" access="public" returntype="void" output="false">
	<cfsetting showdebugoutput="true">
</cffunction>

<cffunction name="threadSleep" hint="" access="public" returntype="void" output="false">
	<cfargument name="seconds" hint="" type="numeric" required="Yes">
	<cfscript>
		createObject("java", "java.lang.Thread").currentThread().sleep(JavaCast("long", arguments.seconds * 1000));
	</cfscript>
</cffunction>

<cffunction name="queryComment" hint="" access="public" returntype="void" output="false">
	<cfargument name="str" hint="" type="string" required="Yes">
	<cfset var q = QueryNew(arguments.str) />
	<cfquery name="q" dbtype="query">
		select #arguments.str#
		from
		q
	</cfquery>
</cffunction>

<cffunction name="println" hint="" access="private" returntype="void" output="false">
	<cfargument name="str" hint="" type="string" required="Yes">
	<cfscript>
		createObject("Java", "java.lang.System").out.println(arguments.str);
	</cfscript>
</cffunction>

<cffunction name="_trace">
	<cfargument name="s">
	<cfset var g = "">
	<cfsetting showdebugoutput="true">
	<cfsavecontent variable="g">
		<cfdump var="#arguments.s#">
	</cfsavecontent>
	<cftrace text="#g#">
</cffunction>

<cffunction name="_dump">
	<cfargument name="s">
	<cfargument name="abort" default="true">
	<cfset var g = "">
		<cfdump var="#arguments.s#">
		<cfif arguments.abort>
		<cfabort>
		</cfif>
</cffunction>

</cfcomponent>