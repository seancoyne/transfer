<cfcomponent name="BigStuff" extends="test.transfer.cases.BaseCase">

<cffunction name="setUp" hint="" access="public" returntype="string" output="false">
	<cfscript>
	</cfscript>
</cffunction>

<cffunction name="tearDown" hint="" access="public" returntype="void" output="false">
 	<cfquery name="clearBigStuff" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		delete from
		tbl_bigstuff
	</cfquery>
</cffunction>

<cffunction name="testClob" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var bigstuff = getTransfer().new("clobnblob.BigStuff");
		var reget = 0;
		var buffer = createObject("java", "java.lang.StringBuffer").init();
		var lb = createObject("java", "java.lang.System").getProperty("line.separator");
		var string = 0;

		/* setup big text */
		//for(i = 1; i lte 5; i = i + 1)
		for(i = 1; i lte 1000; i = i + 1)
		{
			buffer.append(JavaCast("string", randRange(1, 1000000)));
			if((randRange(1,10) mod 3) eq 0)
			{
				buffer.append(" ");
			}

			if((randRange(1,10) mod 5) eq 0)
			{
				buffer.append(lb);
			}
		}

		string = buffer.toString();

		bigStuff.setClobValue(string);

		getTransfer().save(bigStuff);

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertSame("should be the same", reget, bigstuff);

		getTransfer().discardAll();

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertNotSame("should not be the same objects", bigstuff, reget);

		AssertEquals("insert: same id?", reget.getid(), bigstuff.getID());

		AssertEquals("insert: same clob data?", reget.getClobValue(), bigstuff.getClobValue());
		AssertEquals("insert: same clob data as string?", string, reget.getClobValue());

		string = reverse(string);

		reget.setClobValue(string);

		getTransfer().save(reget);

		AssertFalse(reget.getClobValue() eq bigstuff.getClobValue(), "string should be different #Right(reget.getClobValue(), 50)# vs #Right(bigstuff.getClobValue(), 50)#");

		getTransfer().discardAll();

		bigstuff = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertEquals("update: same id?", reget.getid(), bigstuff.getID());

		AssertEquals("update: same clob data?", reget.getClobValue(), bigstuff.getClobValue());
		AssertEquals("update: same clob data as string?", string, bigstuff.getClobValue());
	</cfscript>
</cffunction>

<cffunction name="testNullClob" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var bigstuff = getTransfer().new("clobnblob.BigStuff");
		var reget = 0;

		bigstuff.setClobValueNull();

		getTransfer().save(bigStuff);

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertSame("should be the same", reget, bigstuff);

		getTransfer().discardAll();

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertEquals("insert: same id?", reget.getid(), bigstuff.getID());

		AssertEquals("insert: same clob data?", reget.getClobValue(), bigstuff.getClobValue());
		AssertTrue(bigStuff.getClobValueIsNull(), "insert: should be null");

		getTransfer().save(reget);

		getTransfer().discardAll();

		bigstuff = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertEquals("update: same id?", reget.getid(), bigstuff.getID());

		AssertEquals("update: same clob data?", reget.getClobValue(), bigstuff.getClobValue());
		AssertTrue(bigStuff.getClobValueIsNull(), "update: should be null");
	</cfscript>
</cffunction>

<cffunction name="testBlob" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var image = 0;
		var image2 = 0;
		var bigstuff = getTransfer().new("clobnblob.BigStuff");
		var Arrays = createObject("java", "java.util.Arrays");

		bigStuff.setClobValueNull();
	</cfscript>
	<cffile action="readbinary" file="#expandPath('/test/resources/asset/logo.png')#" variable="image">
	<cffile action="readbinary" file="#expandPath('/test/resources/asset/logo_single.png')#" variable="image2">

	<cfscript>
		bigStuff.setBlobValue(image);

		getTransfer().save(bigStuff);

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertSame("should be the same", reget, bigstuff);

		getTransfer().discardAll();

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertEquals("insert: same id?", reget.getid(), bigstuff.getID());

		AssertTrue(Arrays.equals(reget.getBlobValue(), bigStuff.getBlobValue()), "insert: same blob data?");
		AssertTrue(Arrays.equals(reget.getBlobValue(), image), "insert: same blob data as image?");

		reget.setBlobValue(image2);

		getTransfer().save(reget);

		AssertFalse(Arrays.equals(reget.getBlobValue(), bigStuff.getBlobValue()), "image should be different");

		getTransfer().discardAll();

		bigstuff = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertEquals("update: same id?", reget.getid(), bigstuff.getID());

		AssertTrue(Arrays.equals(reget.getBlobValue(), bigStuff.getBlobValue()), "update: same blob data?");
		AssertTrue(Arrays.equals(reget.getBlobValue(), image2), "update: same blob data as image?");
	</cfscript>
</cffunction>

<cffunction name="testNullBlob" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var bigstuff = getTransfer().new("clobnblob.BigStuff");
		var reget = 0;
		var Arrays = createObject("java", "java.util.Arrays");

		bigstuff.setBlobValueNull();

		getTransfer().save(bigStuff);

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertSame("should be the same", reget, bigstuff);

		getTransfer().discardAll();

		reget = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertEquals("insert: same id?", reget.getid(), bigstuff.getID());

		AssertTrue(Arrays.equals(reget.getBlobValue(), bigStuff.getBlobValue()), "insert: same blob data?");
		AssertTrue(bigStuff.getBlobValueIsNull(), "insert: should be null");

		getTransfer().save(reget);

		getTransfer().discardAll();

		bigstuff = getTransfer().get("clobnblob.BigStuff", bigStuff.getID());

		AssertEquals("update: same id?", reget.getid(), bigstuff.getID());

		AssertTrue(bigStuff.getBlobValueIsNull(), "update: should be null");
		AssertTrue(Arrays.equals(reget.getBlobValue(), bigStuff.getBlobValue()), "update: same blob data?");
		AssertTrue(bigStuff.getBlobValueIsNull(), "update: should be null");
	</cfscript>
</cffunction>

<cffunction name="testNullBlob2" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var bigstuff = getTransfer().new("clobnblob.BigStuff2");
		var Arrays = createObject("java", "java.util.Arrays");
		var reget = 0;
		var null = "-------";

		bigstuff.setBlobValueNull();
		AssertTrue(Arrays.equals(null.getBytes(), bigStuff.getBlobValue()), "nullvalue value is not correct");

		getTransfer().save(bigStuff);

		reget = getTransfer().get("clobnblob.BigStuff2", bigStuff.getID());

		AssertSame("should be the same", reget, bigstuff);

		getTransfer().discardAll();

		reget = getTransfer().get("clobnblob.BigStuff2", bigStuff.getID());

		AssertEquals("insert: same id?", reget.getid(), bigstuff.getID());

		AssertTrue(Arrays.equals(reget.getBlobValue(), bigStuff.getBlobValue()), "insert: same blob data?");

		AssertTrue(bigStuff.getBlobValueIsNull(), "insert: should be null");

		getTransfer().save(reget);

		getTransfer().discardAll();

		bigstuff = getTransfer().get("clobnblob.BigStuff2", bigStuff.getID());

		AssertEquals("update: same id?", reget.getid(), bigstuff.getID());

		AssertTrue(bigStuff.getBlobValueIsNull(), "update: should be null");
		AssertTrue(Arrays.equals(reget.getBlobValue(), bigStuff.getBlobValue()), "update: same blob data?");
		AssertTrue(bigStuff.getBlobValueIsNull(), "update: should be null");
	</cfscript>
</cffunction>

</cfcomponent>