<!--- Document Information -----------------------------------------------------

Title:      OneToMany.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    BO for one to many relationships

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		20/09/2005		Created

------------------------------------------------------------------------------->

<cfcomponent name="OneToMany" hint="BO for one to many relationships" extends="AbstractBaseComposition">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="OneToMany" output="false">
	<cfargument name="object" hint="the parent obect" type="transfer.com.object.Object" required="Yes">
	<cfargument name="objectManager" hint="The object manager" type="transfer.com.object.ObjectManager" required="Yes">
	<cfscript>
		super.init(arguments.object, arguments.objectManager);
		setLink(createObject("component", "transfer.com.object.Link").init(arguments.objectManager));
		setCollection(createObject("component", "transfer.com.object.Collection").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="getLink" access="public" returntype="link" output="false">
	<cfreturn instance.Link />
</cffunction>

<cffunction name="getCollection" access="public" returntype="Collection" output="false">
	<cfreturn instance.Collection />
</cffunction>

<cffunction name="setMemento" hint="Sets the state of the object" access="public" returntype="void" output="false">
	<cfargument name="memento" hint="the state to be set" type="struct" required="Yes">
	<cfscript>
		super.setMemento(arguments.memento);
		getLink().setMemento(arguments.memento.link);
		getCollection().setMemento(arguments.memento.collection);

		/*
		we'll be cheeky, and store the memento temporarily, as we know we'll grab it later
		and then delete it
		*/
		instance.memento = arguments.memento;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="notifyComplete" hint="notifies the object that it has finished loading, and can do post processing" access="package" returntype="void" output="false">
	<cfscript>
		var parentOneToMany = 0;
		var object = 0;

		/*
			Defer the notifyComplete on toObject, so we can add the parent, before the
			composite key meta goes looking for it.
		*/
		object = getObjectManager().getObject(getLink().getTo(), true);

		if(NOT object.containsParentOneToMany(getObject().getClassName()))
		{

			parentOneToMany = createObject("component", "transfer.com.object.ParentOneToMany").init(object, getObjectManager());

			//change the memento to point to parent
			instance.memento.link.to = getObject().getClassName();
			instance.memento.lazy = false;
			instance.memento.proxied = false;

			parentOneToMany.setMemento(instance.memento);

			object.addParentOneToMany(parentOneToMany);

			/* object.notifyComplete();
			object.validate(); */
		}

		//cleanup
		StructDelete(instance, "memento");
	</cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCollection" access="private" returntype="void" output="false">
	<cfargument name="Collection" type="Collection" required="true">
	<cfset instance.Collection = arguments.Collection />
</cffunction>

<cffunction name="setLink" access="private" returntype="void" output="false">
	<cfargument name="Link" type="link" required="true">
	<cfset instance.Link = arguments.Link />
</cffunction>

</cfcomponent>