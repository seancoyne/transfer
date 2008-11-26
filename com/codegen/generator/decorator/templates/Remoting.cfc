<cfcomponent output="false" hint="Decorator for $$state.object.getClassName()$$" alias="$$state.object.getDecorator()$$"
			 transferAlias="$$state.object.getClassName()$$" extends="transfer.com.TransferDecorator">

{{gen:block name="cfproperty"}}
{{gen:compact}}
{{cfset primaryKey = state.object.getPrimaryKey()}}
	<cfproperty name="$$primaryKey.getName()$$" type="$$primaryKey.getType()$$">
{{cfset iterator = state.object.getPropertyIterator() /}}
{{cfloop condition="$$iterator.hasNext()$$"}}
	{{cfset property = iterator.next() /}}
	<cfproperty name="$$property.getName()$$" type="$$property.getType()$$">
{{/cfloop}}

{{/gen:compact}}
{{/gen:block}}

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>