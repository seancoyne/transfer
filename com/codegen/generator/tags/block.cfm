<cfsilent>
<!--- Document Information -----------------------------------------------------

Title:      block.cfm

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    This represents a block of code generated code, which can be regenerated

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		25/11/2008		Created

------------------------------------------------------------------------------->

<cfparam name="attributes.name" type="string">

<cfif NOT thisTag.HasEndTag>
	<cfthrow message="Block tag must have an end tag">
</cfif>

<cfif thisTag.ExecutionMode eq "start">
	<cfset block = "<!" & "--- :::" & attributes.name & "::: ---" & ">"/>
<cfelse>
	<cfset block = "<!" & "--- :::/" & attributes.name & "::: ---" & ">"/>
	<cfset parentData = getBaseTagData("cf_template") />

	<cfset data = StructCopy(attributes) />
	<cfset data.content = thisTag.GeneratedContent />

	<cfset ArrayAppend(parentData.blocks, data) />
</cfif>

</cfsilent><cfoutput>#block#</cfoutput>