<cfcomponent name="Application.cfc">
	
<!--- constructor --->
<cfscript>
	this.name = "cfunit";
	this.applicationTimeout = CreateTimeSpan(0, 0, 30, 0);
	this.sessionManagement = true;
</cfscript>
<cfsetting showdebugoutput="false" requesttimeout="#(60 * 60)#">

</cfcomponent>