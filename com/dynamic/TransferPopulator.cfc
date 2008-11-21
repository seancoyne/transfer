<!--- Document Information -----------------------------------------------------

Title:      TransferPopulator.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    Populates a Transfer Object with Query Information

Usage:

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		19/07/2005		Created

------------------------------------------------------------------------------->
<cfcomponent name="TransferPopulator" hint="Populates a Transfer Objects with Query information">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="TransferPopulator" output="false">
	<cfargument name="sqlManager" hint="The SQL Manager" type="transfer.com.sql.SQLManager" required="Yes">
	<cfargument name="objectManager" hint="Need to object manager for making queries" type="transfer.com.object.ObjectManager" required="Yes">
	<cfargument name="keyRationalise" hint="key rationaliser" type="transfer.com.dynamic.KeyRationalise" required="Yes">
	<cfscript>
		setSQLManager(arguments.sqlManager);
		setObjectManager(arguments.objectManager);
		setKeyRationalise(arguments.keyRationalise);
		setMethodInvoker(createObject("component", "transfer.com.dynamic.MethodInvoker").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="populate" hint="Populates a Transfer object with query data" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer object to populate" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="key" hint="Key for the BO" type="any" required="Yes">

	<cfscript>
		var object = getObjectManager().getObject(arguments.transfer.getClassName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().select(object, arguments.key);

		//create memento from the result
		var memento = buildMemento(qObject);

		//if key not found, it will return an empty object
		if(not StructIsEmpty(memento))
		{
			//setMemento on the transfer object
			arguments.transfer.setMemento(memento);
		}
	</cfscript>
</cffunction>

<cffunction name="populateManyToOne" hint="populates many to one data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytoone to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyManyToOne(arguments.transfer.getClassName(), arguments.name);

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().select(lazyObject, key, arguments.name);
		var memento = buildMemento(qObject);
		var args = structNew();

		//build memento arguments
		args.memento = StructNew();

		if(StructKeyExists(memento, arguments.name))
		{
			args.memento = memento[arguments.name];
		}

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<cffunction name="populateOneToMany" hint="populates onetomany data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytoone to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyOneToMany(arguments.transfer.getClassName(), arguments.name);

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().select(lazyObject, key, arguments.name);

		var memento = buildMemento(qObject);
		var args = structNew();

		//build memento arguments
		args.memento = ArrayNew(1);

		if(StructKeyExists(memento, arguments.name))
		{
			args.memento = memento[arguments.name];
		}

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<cffunction name="populateManyToMany" hint="populates manytomany data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the manytoone to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyManyToMany(arguments.transfer.getClassName(), arguments.name);

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().select(lazyObject, key, arguments.name);

		var memento = buildMemento(qObject);
		var args = structNew();

		//build memento arguments
		args.memento = ArrayNew(1);

		if(StructKeyExists(memento, arguments.name))
		{
			args.memento = memento[arguments.name];
		}

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<cffunction name="populateParentOneToMany" hint="populates parent onetomany data into the object for lazy load" access="public" returntype="void" output="false">
	<cfargument name="transfer" hint="The transfer to load into" type="transfer.com.TransferObject" required="Yes">
	<cfargument name="name" hint="The name of the external onetomany to load" type="string" required="Yes">
	<cfscript>
		var lazyObject = getObjectManager().getObjectLazyParentOneToMany(arguments.transfer.getClassName());

		//get primary key
		var key = getMethodInvoker().invokeMethod(arguments.transfer, "get" & lazyObject.getPrimaryKey().getName());

		//pass the object over to the query maker, and get back the result
		var qObject = getSQLManager().select(lazyObject, key, arguments.name);

		var args = structNew();

		//build memento arguments
		args.memento = buildMemento(qObject);

		getMethodInvoker().invokeMethod(arguments.transfer, "set" & arguments.name & "Memento", args);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildMemento" hint="Builds a memento from a object and query" access="private" returntype="struct" output="false">
	<cfargument name="qObject" hint="The query that has the data" type="query" required="Yes">
	<cfscript>
		var object = 0;
		var parentClassName = 0;
		var parentCompositeName = 0;
		var compositeName = 0;
		var isArray = 0;
		var parentKey = 0;
		var parentOneToMany = 0;
		var mementoPart = 0;
		var parentObject = 0;
		var iterator = 0;
		var property = 0;
		var mementoBuilder = createObject("component", "transfer.com.dynamic.MementoBuilder").init(getObjectManager(), arguments.qObject, getKeyRationalise());
		var primarykey = 0;
		var parentParentClassName = 0;
		var key = 0;

		//throw exception if empty
		if(NOT arguments.qObject.recordCount)
		{
			throw("transfer.EmptyQueryException", "The query provided to populate this transfer is empty", "It is likely the ID that has been selected for this query no longer exists");
		}
	</cfscript>

	<cfloop query="arguments.qObject">
		<cfscript>
			object = getObjectManager().getObject(transfer_className);
			parentClassName = transfer_parentClassName;
			isArray = transfer_isArray;
			compositeName = transfer_compositeName;
			parentParentClassName = transfer_parentParentClassName;
			primarykey = object.getPrimaryKey();


			if(Len(parentClassName))
			{
				parentKey = transfer_parentKey;
				parentCompositeName = transfer_parentCompositeName;
			}

			mementoPart = StructNew();

			//tell it that it is not dirty, and is persisted
			mementoPart.transfer_isDirty = false;
			mementoPart.transfer_isPersisted = true;

			//loop throough properties
			iterator = object.getPropertyIterator();

			while(iterator.hasNext())
			{
				property = iterator.next();
				//mementoPart[property.getName()] = arguments.qObject[property.getColumn()][arguments.qObject.currentRow];
				mementoPart[property.getName()] = getSQLManager().getPropertyColumnValue(arguments.qObject, object, property);
			}

			//loop through qExternalObjects
			iterator = object.getParentOneToManyIterator();
			while(iterator.hasNext())
			{
				parentOneToMany = iterator.next();

				parentObject = getObjectManager().getObject(parentOneToMany.getLink().getTo());

				mementoPart["parent"& parentObject.getObjectName() & "_" & parentObject.getPrimaryKey().getName()] = arguments.qObject[parentOneToMany.getLink().getColumn()][arguments.qObject.currentRow];
			}

			//do this last, so we can use what we already have in the memento
			if(primaryKey.getIsComposite())
			{
				key = arguments.qObject.transfer_compositeid[arguments.qObject.currentRow];
				buildCompositeKeyMemento(mementoPart, object, arguments.qObject);
			}
			else
			{
				//lets get the peices of the primary key
				key = getSQLManager().getPropertyColumnValue(arguments.qObject, object, object.getPrimaryKey());
				mementoPart[primaryKey.getName()] = getSQLManager().getPropertyColumnValue(arguments.qObject, object, object.getPrimaryKey());
			}

			//add the details to the memento objects
			mementoBuilder.add(compositeName, key, object.getClassName(), isArray, mementoPart, parentClassName, parentKey, parentCompositeName, parentParentClassName);
		</cfscript>
	</cfloop>

	<cfreturn mementoBuilder.getMementoStruct()>
</cffunction>

<cffunction name="buildCompositeKeyMemento" hint="builds the composite key memento" access="private" returntype="void" output="false">
	<cfargument name="memento" hint="the memento to append to" type="struct" required="Yes">
	<cfargument name="object" hint="the object BO" type="transfer.com.object.Object" required="Yes">
	<cfargument name="query" hint="the query that the data is coming from" type="query" required="Yes">
	<cfscript>
		var key = StructNew();
		var primaryKey = arguments.object.getPrimaryKey();
		var property = 0;
		var manytoone = 0;
		var parentOneToMany = 0;
		var iterator = primaryKey.getPropertyIterator();
		var value = 0;
		var composite = 0;

		while(iterator.hasNext())
		{
			property = iterator.next();
			key[property.getName()] = arguments.memento[property.getName()];
		}

		iterator = primaryKey.getManyToOneIterator();

		while(iterator.hasNext())
		{
			manytoone = iterator.next();

			key[manytoone.getName()] = arguments.query[manytoone.getLink().getColumn()][arguments.query.currentRow];
		}

		iterator = primaryKey.getParentOneToManyIterator();

		while(iterator.hasNext())
		{
			parentOneToMany = iterator.next();
			composite = getObjectManager().getObject(parentOneToMany.getLink().getTo());

			value = arguments.memento["parent"& composite.getObjectName() & "_" & composite.getPrimaryKey().getName()];
			if(len(value))
			{
				key["parent" & composite.getObjectName()] = value;
			}
		}

		arguments.memento[object.getPrimaryKey().getName()] = key;
	</cfscript>
</cffunction>

<cffunction name="getSQLManager" access="private" returntype="transfer.com.sql.SQLManager" output="false">
	<cfreturn instance.SQLManager />
</cffunction>

<cffunction name="setSQLManager" access="private" returntype="void" output="false">
	<cfargument name="SQLManager" type="transfer.com.sql.SQLManager" required="true">
	<cfset instance.SQLManager = arguments.SQLManager />
</cffunction>

<cffunction name="getObjectManager" access="private" returntype="transfer.com.object.ObjectManager" output="false">
	<cfreturn instance.ObjectManager />
</cffunction>

<cffunction name="setObjectManager" access="private" returntype="void" output="false">
	<cfargument name="ObjectManager" type="transfer.com.object.ObjectManager" required="true">
	<cfset instance.ObjectManager = arguments.ObjectManager />
</cffunction>

<cffunction name="getMethodInvoker" access="private" returntype="transfer.com.dynamic.MethodInvoker" output="false">
	<cfreturn instance.MethodInvoker />
</cffunction>

<cffunction name="setMethodInvoker" access="private" returntype="void" output="false">
	<cfargument name="MethodInvoker" type="transfer.com.dynamic.MethodInvoker" required="true">
	<cfset instance.MethodInvoker = arguments.MethodInvoker />
</cffunction>

<cffunction name="getKeyRationalise" access="private" returntype="transfer.com.dynamic.KeyRationalise" output="false">
	<cfreturn instance.KeyRationalise />
</cffunction>

<cffunction name="setKeyRationalise" access="private" returntype="void" output="false">
	<cfargument name="KeyRationalise" type="transfer.com.dynamic.KeyRationalise" required="true">
	<cfset instance.KeyRationalise = arguments.KeyRationalise />
</cffunction>

<cffunction name="throw" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>

</cfcomponent>