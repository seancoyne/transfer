<cfcomponent output="false" hint="Decorator for $$state.object.getClassName()$$" extends="transfer.com.TransferDecorator">

{{gen:block name="cfproperty"}}
{{gen:compact}}
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