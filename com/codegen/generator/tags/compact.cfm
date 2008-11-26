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
		ls = createObject("java", "java.lang.System").getProperty("line.separator");
		stringReader = createObject("java", "java.io.StringReader").init(thisTag.generatedContent);
		bufferedReader = createObject("java", "java.io.BufferedReader").init(stringReader);
		stringBuffer = createObject("java", "java.lang.StringBuffer").init();

		thisTag.generatedContent = "";

		local = StructNew();

		local.line = bufferedReader.readLine();

		while(StructKeyExists(local, "line"))
		{
			if(Len(Trim(local.line)))
			{
				if(stringBuffer.length())
				{
					stringBuffer.append(ls);
				}
				stringBuffer.append(local.line);
			}

			local.line = bufferedReader.readLine();
		}
	</cfscript>
</cfif>

</cfsilent><cfif thisTag.ExecutionMode eq "end"><cfoutput>#stringBuffer.toString()#</cfoutput></cfif>