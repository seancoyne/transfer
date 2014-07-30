<cfcomponent name="ObjectPoolTest" hint="tests object pool" extends="test.transfer.cases.BaseCase">

<cfscript>
	variables.loader = createObject("component", "transfer.com.util.JavaLoader").init("test");
</cfscript>

<cffunction name="testEventPool" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var objArray = ArrayNew(1);
		var pool =createObject("component", "transfer.com.events.collections.TransferEventPool").init(variables.loader);
		var iterator = 0;
		var obj = 0;
		var counter = 0;
		var System = createObject("java", "java.lang.System");

		for(; counter le 2000; counter = counter + 1)
		{
			arrayAppend(objArray, pool.pop());
		}

		iterator = objArray.iterator();

		while(iterator.hasNext())
		{
			pool.push(iterator.next());
			iterator.remove();
		}

		counter = 0;

		println("calling gc()");
		System.gc();

		for(; counter le 2000; counter = counter + 1)
		{
			arrayAppend(objArray, pool.pop());
		}

		counter = 0;
		iterator = objArray.iterator();

		for(; counter le 1000; counter = counter + 1)
		{
			pool.push(iterator.next());
			iterator.remove();
		}

		ArrayClear(objArray);

		counter = 0;

		for(; counter le 1500; counter = counter + 1)
		{
			createObject("java", "java.lang.Thread").currentThread().sleep(10);
			arrayAppend(objArray, pool.pop());
		}
	</cfscript>
</cffunction>

</cfcomponent>