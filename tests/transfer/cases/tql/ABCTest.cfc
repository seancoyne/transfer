<cfcomponent extends="test.transfer.cases.BaseCase" output="false">

<cffunction name="testABToCManyToOne" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//setup the data
		var a = getTransferC().new("abcmanytoone.A");
		var b = getTransferC().new("abcmanytoone.B");
		var c = getTransferC().new("abcmanytoone.C");
		var q = 0;
		var tql = "select * from abcmanytoone.A join abcmanytoone.C join abcmanytoone.B";

		a.setC(c);
		b.setC(c);

		getTransferC().save(c);
		getTransferC().save(b);
		getTransferC().save(a);

		query = getTransferC().createQuery(tql);

		q = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select
			tbl_a.a_value as stringValue,
			tbl_a.a_id as id,
			tbl_c.c_value as stringValue_1,
			tbl_c.c_id as id_1,
			tbl_b.b_value as stringValue_2,
			tbl_b.b_id as id_2
		from
			tbl_a
			inner join
			tbl_c
			ON
			tbl_a.lnkid = tbl_c.c_id
			AND
			tbl_a.lnkid2 = tbl_c.c_id
			AND
			tbl_a.a_id = tbl_c.lnkid
			inner join tbl_b
			ON tbl_c.c_id = tbl_b.lnkid
	</cfquery>
	<cfset AssertEqualsBasic(q2, q)>
</cffunction>

<cffunction name="testABToCOneToMany" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//setup the data
		var a = getTransferC().new("abconetomany.xA");
		var b = getTransferC().new("abconetomany.xB");
		var c = getTransferC().new("abconetomany.xC");
		var q = 0;
		var tql = "from abconetomany.xA join abconetomany.xC join abconetomany.xB";

		c.setParentxA(a);
		c.setParentxB(b);

		getTransferC().save(b);
		getTransferC().save(a);
		getTransferC().save(c);

		query = getTransferC().createQuery(tql);

		q = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			select tbl_a.a_value as stringValue, tbl_a.a_id as id, tbl_c.c_value as stringValue_1, tbl_c.c_id as id_1, tbl_b.b_value as stringValue_2, tbl_b.b_id as id_2
			from
			tbl_a
			inner join tbl_c
			ON tbl_a.a_id = tbl_c.lnkid
			AND tbl_a.lnkid = tbl_c.c_id
			inner join tbl_b
			ON tbl_c.lnkid2 = tbl_b.b_id
	</cfquery>
	<cfset AssertEqualsBasic(q2, q)>
</cffunction>

<cffunction name="testACManyToOneOUter" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//setup the data
		var a = getTransferC().new("abcmanytoone.A");
		var c = getTransferC().new("abcmanytoone.C");
		var q = 0;
		var tql = "from abcmanytoone.A outer join abcmanytoone.C";

		a.setC(c);

		getTransferC().save(c);
		getTransferC().save(a);

		query = getTransferC().createQuery(tql);

		q = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
	select tbl_a.a_value as stringValue, tbl_a.a_id as id, tbl_c.c_value as stringValue_1, tbl_c.c_id as id_1
	from tbl_a
	left outer join tbl_c
	ON tbl_a.lnkid = tbl_c.c_id
	AND tbl_a.lnkid2 = tbl_c.c_id
	AND tbl_a.a_id = tbl_c.lnkid
	</cfquery>
	<cfset AssertEqualsBasic(q2, q)>
</cffunction>

<cffunction name="testACManyToOneLeftOUter" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//setup the data
		var a = getTransferC().new("abcmanytoone.A");
		var c = getTransferC().new("abcmanytoone.C");
		var q = 0;
		var tql = "from abcmanytoone.A left outer join abcmanytoone.C";

		a.setC(c);

		getTransferC().save(c);
		getTransferC().save(a);

		query = getTransferC().createQuery(tql);

		q = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
	select tbl_a.a_value as stringValue, tbl_a.a_id as id, tbl_c.c_value as stringValue_1, tbl_c.c_id as id_1
	from tbl_a
	left outer join tbl_c
	ON tbl_a.lnkid = tbl_c.c_id
	AND tbl_a.lnkid2 = tbl_c.c_id
	AND tbl_a.a_id = tbl_c.lnkid
	</cfquery>
	<cfset AssertEqualsBasic(q2, q)>
</cffunction>

<cffunction name="testACManyToOneRightOUter" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//setup the data
		var a = getTransferC().new("abcmanytoone.A");
		var c = getTransferC().new("abcmanytoone.C");
		var q = 0;
		var tql = "from abcmanytoone.A right outer join abcmanytoone.C";

		a.setC(c);

		getTransferC().save(c);
		getTransferC().save(a);

		query = getTransferC().createQuery(tql);

		q = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
	select tbl_a.a_value as stringValue, tbl_a.a_id as id, tbl_c.c_value as stringValue_1, tbl_c.c_id as id_1
	from tbl_a
	right outer join tbl_c
	ON tbl_a.lnkid = tbl_c.c_id
	AND tbl_a.lnkid2 = tbl_c.c_id
	AND tbl_a.a_id = tbl_c.lnkid
	</cfquery>
	<cfset AssertEqualsBasic(q2, q)>
</cffunction>

<cffunction name="testABToCOneToManyCacheEvaluation" hint="" access="public" returntype="void" output="false">
	<cfscript>
		//setup the data
		var a = getTransferC().new("abconetomany.xA");
		var b = getTransferC().new("abconetomany.xB");
		var c = getTransferC().new("abconetomany.xC");
		var q = 0;

		var tql = "from abconetomany.xA join abconetomany.xC join abconetomany.xB";

		c.setParentxA(a);
		c.setParentxB(b);

		getTransferC().save(b);
		getTransferC().save(a);
		getTransferC().save(c);

	</cfscript>

	<cfscript>
		query = getTransferC().createQuery(tql);
		query.setCacheEvaluation(true);
		q = getTransferC().listByQuery(query);
	</cfscript>

	<cfscript>
		query = getTransferC().createQuery(tql);
		query.setCacheEvaluation(true);
		q = getTransferC().listByQuery(query);
	</cfscript>
</cffunction>

<cffunction name="testManyToOne3Join" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var a = getTransferC().new("seanTest.yA");
		var b = getTransferC().new("seanTest.yB");
		var c = getTransferC().new("seanTest.yC");

		var tql = "from seanTest.yA as A join seanTest.yB as B ON A.next join seanTest.yC as C on C.next";
		var query = getTransferC().createQuery(tql);
		var q = 0;

		a.setNext(b);
		c.setNext(b);

		getTransferC().save(b);
		getTransferC().save(c);
		getTransferC().save(a);

		q = getTransferC().listByQuery(query);
	</cfscript>
</cffunction>

<cffunction name="testOneToMany3join" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var a = getTransferC().new("danLTest.dA");
		var b = getTransferC().new("danLTest.dB");
		var c = getTransferC().new("danLTest.dC");

		var tql = "from danLTest.dC join danLTest.dB join danLTest.dA";

		var query = getTransferC().createQuery(tql);
		var q = 0;
		var q2 = 0;

		b.setParentdA(a);
		c.setParentdA(a);

		getTransferC().save(a);
		getTransferC().save(b);
		getTransferC().save(c);

		q = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q2" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_c.c_value as stringValue, tbl_c.c_id as id, tbl_b.b_value as stringValue_1, tbl_b.b_id as id_1, tbl_a.a_value as stringValue_2, tbl_a.a_id as id_2
		from tbl_c left
		join tbl_b
		ON tbl_c.lnkid = tbl_b.b_id
		inner join tbl_a
			ON tbl_c.lnkid2 = tbl_a.a_id
			AND tbl_b.lnkid = tbl_a.a_id
	</cfquery>
	<cfset AssertEqualsBasic(q2, q)>
</cffunction>

<cffunction name="tearDown" hint="" access="public" returntype="string" output="false">
	<cfset var tables = "a,b,c" />
	<cfloop list="#tables#" index="table">
	<cfquery name="qTable" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
			Delete from tbl_#LCase(table)#
	</cfquery>
	</cfloop>
</cffunction>


</cfcomponent>