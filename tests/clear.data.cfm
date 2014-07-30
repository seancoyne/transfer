<Cfsetting showdebugoutput="true">
<cfscript>
transferFactory = createObject("component", "transfer.TransferFactory").init("/test/resources/datasource.xml",
																					  "/test/resources/transfera.xml",
																					  "/test/resources/defs");
datasource = transferFactory.getDatasource();

transferFactory.shutdown();
</cfscript>

<cffile action="read" file="#expandPath('/test/resources/sql/clear.sql')#" variable="sql">

<cfloop list="#sql#" delimiters=";" index="sub_sql">
	<cfquery name="qDelete" datasource="#datasource.getName()#" username="#datasource.getUsername()#" password="#datasource.getPassword()#">
		#sub_sql#
	</cfquery>
</cfloop>