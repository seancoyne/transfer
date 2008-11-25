<cfsilent>
<!--- Document Information -----------------------------------------------------

Title:      template.cfm

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    parent tag, to track child tag contents

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		25/11/2008		Created

------------------------------------------------------------------------------->

<cfif thisTag.ExecutionMode eq "start">
	<cfset blocks = ArrayNew(1) />
<cfelse>
	<cfset caller.local.blocks = blocks />
</cfif>

</cfsilent>