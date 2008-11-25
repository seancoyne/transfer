<cfsilent>
<!--- Document Information -----------------------------------------------------

Title:      compact.cfm

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    tag for stripping out writespace lines

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		25/11/2008		Created

------------------------------------------------------------------------------->

<cfif NOT thisTag.HasEndTag>
	<cfthrow message="Compact tag must have an end tag">
</cfif>

<cfif thisTag.ExecutionMode eq "end">
	<cfscript>
		content = RTrim(thisTag.generatedContent);

		thisTag.generatedContent = "";
		//?m is multiline mode, not sure why, but it doesn't pick up the 1st line?
		content = rereplace(content, "^[\s]+?\n", "", "all");
		content = rereplace(content, "(?m)^[\s]+?\n", "", "all");
	</cfscript>
</cfif>

</cfsilent><cfif thisTag.ExecutionMode eq "end"><cfoutput>#content#</cfoutput></cfif>