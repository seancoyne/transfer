<cfcomponent output="false" hint="Decorator for $$state.object.getClassName()$$" alias="$$state.object.getDecorator()$$"
			 transferAlias="$$state.object.getClassName()$$" extends="transfer.com.TransferDecorator">

{{gen:block name="cfproperty"}}
{{gen:compact}}
{{cfset local.primaryKey = state.object.getPrimaryKey()}}
	<!--- primary key --->
	<cfproperty name="$$local.primaryKey.getName()$$" type="$$local.primaryKey.getType()$$">
	<!--- properties --->
{{cfset local.iterator = state.object.getPropertyIterator() /}}
{{cfloop condition="$$local.iterator.hasNext()$$"}}
	{{cfset local.property = local.iterator.next() /}}
	<cfproperty name="$$local.property.getName()$$" type="$$local.property.getType()$$">
{{/cfloop}}

{{cfif state.object.hasManyToOne()}}
	<!--- manytooone --->
	{{cfset local.iterator = state.object.getManyToOneIterator() /}}

	{{cfloop condition="$$local.iterator.hasNext()$$"}}
		{{cfset local.manytoone = local.iterator.next() /}}
		{{cfset local.composite = local.manytoone.getLink().getToObject() /}}
		{{cfif local.composite.hasDecorator()}}
	<cfproperty name="$$local.manytoone.getName()$$" type="$$local.composite.getDecorator()$$">
		{{/cfif}}
	{{/cfloop}}
{{/cfif}}

{{/gen:compact}}
{{/gen:block}}

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>