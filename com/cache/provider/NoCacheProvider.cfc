<!--- Document Information -----------------------------------------------------

Title:      NoCacheProvider.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    A Cache Provider, that does not cache at all. Crazy!

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		02/11/2009		Created

------------------------------------------------------------------------------->
<cfcomponent hint="A Cache Provider, that does not cache at all. Crazy!" extends="AbstractBaseProvider" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="NoCacheProvider" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="add" hint="Does nothing" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfargument name="object" hint="the object to add to the cache" type="any" required="Yes">
	<cfreturn false />
</cffunction>

<cffunction name="have" hint="Nope, I don't have it'" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfreturn false />
</cffunction>

<cffunction name="get" hint="virtual method: get the given class and key from the cache, if not there, return nothing" access="public" returntype="any" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
	<cfreturn  />
</cffunction>

<cffunction name="discard" hint="Discarded, even though I have nothing" access="public" returntype="void" output="false">
	<cfargument name="class" hint="the class of the object" type="string" required="Yes">
	<cfargument name="key" hint="the primary key of the object" type="string" required="Yes">
</cffunction>

<cffunction name="discardAll" hint="Discard the nothing that I have" access="public" returntype="void" output="false">
</cffunction>

<cffunction name="getCacheProvider" hint="Returns this" access="public" returntype="any" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="getScope" hint="Returns 'none'"
			access="public" returntype="string" output="false">
	<cfreturn "none" />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>