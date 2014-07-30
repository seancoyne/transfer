f<cfcomponent name="ListByQueryTest" extends="test.transfer.cases.BaseCase">

<cffunction name="testBasicFromQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("from BasicAliasID");
		var qList = getTransferB().listByQuery(query);

		assertEqualsBasic(qList, getTransferB().list("BasicAliasID"));
	</cfscript>
</cffunction>

<cffunction name="testBasicAliasFromQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("from BasicAliasID as Dog");
		var qList = getTransferB().listByQuery(query);

		assertEqualsBasic(qList, getTransferB().list("BasicAliasID"));
	</cfscript>
</cffunction>

<cffunction name="testBasicSelectAliasFromQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("Select Dog.string from Basic as Dog");
		var qList = getTransferB().listByQuery(query);
		var q = 0;
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select basic_string as string from tbl_basic
	</cfquery>
	<cfscript>
		assertEqualsBasic(qList, q);
	</cfscript>
</cffunction>

<cffunction name="testBasicSelectTwoFromQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("Select BasicAliasID.numericValue, BasicAliasID.stringValue from BasicAliasID");
		var qList = getTransferB().listByQuery(query);
		var q = 0;
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select basic_string as stringValue, basic_numeric as numericValue from tbl_basic
	</cfquery>
	<cfscript>
		assertEqualsBasic(qList, q);
	</cfscript>
</cffunction>

<cffunction name="testBasicFromWhereQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("from BasicAliasID as Basic where Basic.stringValue = :string");
		var qList = 0;

		query.setParam("string", "george", "string");

		qList = getTransferB().listByQuery(query);

		assertEqualsBasic(qList, getTransferB().listByProperty("BasicAliasID", "stringValue", "george"));
	</cfscript>
</cffunction>

<cffunction name="testBasicAliasFromWhereQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("from BasicAliasID as YYY where YYY.stringValue = :string");
		var qList = 0;

		query.setParam("string", "george", "string");

		qList = getTransferB().listByQuery(query);

		assertEqualsBasic(qList, getTransferB().listByProperty("BasicAliasID", "stringValue", "george"));
	</cfscript>
</cffunction>

<cffunction name="testBasicAliasFromWhereJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("from BasicAliasID as YYY where YYY.stringValue = YYY.stringValue");
		var qList = 0;
		var q = 0;
		query.setDistinctMode(true);

		qList = getTransferB().listByQuery(query);

	</cfscript>

	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select  distinct YYY.basic_date as dateValue, YYY.basic_numeric as numericValue, YYY.basic_string as stringValue, YYY.basic_UUID as UUIDValue, YYY.basic_boolean as booleanValue, YYY.IDBasic as id from tbl_basic YYY where YYY.basic_string = YYY.basic_string
	</cfquery>
	<cfscript>
		assertEqualsBAsic(qList, q);
	</cfscript>
</cffunction>

<cffunction name="testSelectFromWhereQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("select Basic.stringValue, Basic.dateValue from BasicAliasID as Basic where Basic.stringValue = :string OR (Basic.stringValue = :frodo) OR Basic.stringValue = :null");
		var qList = 0;
		var qDList = 0;

		query.setParam("string", "george", "string");
		query.setParam("frodo", "xxyyzz", "string");
		query.setParam(name="null", isNull=true);

		qList = getTransferB().listByQuery(query);
	</cfscript>

	<cfquery name="qDList" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select tbl_basic.basic_string as stringValue , tbl_basic.basic_date as dateValue from tbl_basic where tbl_basic.basic_string =
						<cfqueryparam value="george" cfsqltype="cf_sql_varchar">
			 OR ( tbl_basic.basic_string =
						<cfqueryparam value="xxyyzz" cfsqltype="cf_sql_varchar">
			 ) OR tbl_basic.basic_string =
						<cfqueryparam value="string" cfsqltype="cf_sql_varchar" null="true">
	</cfquery>
	<cfscript>
		assertEqualsBAsic(qList, qDlist);
	</cfscript>
</cffunction>

<cffunction name="testSelectFromWhereQueryISNull" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("select Basic.stringValue, Basic.dateValue from BasicAliasID as Basic where Basic.stringValue = :string OR (Basic.stringValue = :frodo) OR Basic.stringValue IS NULL");
		var qList = 0;
		var qDList = 0;

		query.setParam("string", "george", "string");
		query.setParam("frodo", "xxyyzz", "string");

		qList = getTransferB().listByQuery(query);
	</cfscript>

	<cfquery name="qDList" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select tbl_basic.basic_string as stringValue , tbl_basic.basic_date as dateValue from tbl_basic where tbl_basic.basic_string =
						<cfqueryparam value="george" cfsqltype="cf_sql_varchar">
			 OR ( tbl_basic.basic_string =
						<cfqueryparam value="xxyyzz" cfsqltype="cf_sql_varchar">
			 ) OR tbl_basic.basic_string IS NULL
	</cfquery>
	<cfscript>
		assertEqualsBAsic(qList, qDlist);
	</cfscript>
</cffunction>

<cffunction name="testSelectFromWhereInQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("select X.stringValue, X.dateValue from BasicAliasID as X where ( X.stringValue IN (:list) )");

		var qList = 0;
		var qDList = 0;

		query.setParam(name="list", value="george,XXX,tod", list="true");

		qList = getTransferB().listByQuery(query);
	</cfscript>
</cffunction>

<cffunction name="testBasicFromQueryOrderBy" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("from BasicAliasID as Basic Order By Basic.stringValue");
		var qList = getTransferB().listByQuery(query);

		assertEqualsBasic(qList, getTransferB().list("BasicAliasID", "stringValue"));
	</cfscript>
</cffunction>

<cffunction name="testSelectFromWhereQueryOrderBy" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("select Basic.stringValue, Basic.dateValue from BasicAliasID as Basic where Basic.stringValue = :string OR (Basic.stringValue = :frodo) OR Basic.stringValue = :null Order by Basic.stringValue, Basic.dateValue");
		var qList = 0;
		var qDList = 0;

		query.setParam("string", "george", "string");
		query.setParam("frodo", "xxyyzz", "string");
		query.setParam(name="null", isNull=true);

		qList = getTransferB().listByQuery(query);
	</cfscript>

	<cfquery name="qDList" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select tbl_basic.basic_string as stringValue , tbl_basic.basic_date as dateValue from tbl_basic where tbl_basic.basic_string =
						<cfqueryparam value="george" cfsqltype="cf_sql_varchar">
			 OR ( tbl_basic.basic_string =
						<cfqueryparam value="xxyyzz" cfsqltype="cf_sql_varchar">
			 ) OR tbl_basic.basic_string =
						<cfqueryparam value="string" cfsqltype="cf_sql_varchar" null="true">
			order by tbl_basic.basic_string, tbl_basic.basic_date
	</cfquery>
	<cfscript>
		assertEqualsBAsic(qList, qDlist);
	</cfscript>
</cffunction>

<cfimport taglib="/transfer/tags" prefix="t">

<cffunction name="testSelectFromWhereQueryOrderByTAG" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = 0;
		var qList = 0;
		var qDList = 0;
	</cfscript>
	<t:query name="qList" transfer="#getTransferB()#">
		select Basic.stringValue,
				Basic.dateValue
		from BasicAliasID as Basic
		where Basic.stringValue = <t:queryparam value="george">
		OR (Basic.stringValue = <t:queryparam value="xxyyzz">)
		OR Basic.stringValue = <t:queryparam isNull="true">
		Order
		by Basic.stringValue, Basic.dateValue
	</t:query>

	<cfquery name="qDList" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select tbl_basic.basic_string as stringValue , tbl_basic.basic_date as dateValue from tbl_basic where tbl_basic.basic_string =
						<cfqueryparam value="george" cfsqltype="cf_sql_varchar">
			 OR ( tbl_basic.basic_string =
						<cfqueryparam value="xxyyzz" cfsqltype="cf_sql_varchar">
			 ) OR tbl_basic.basic_string =
						<cfqueryparam value="string" cfsqltype="cf_sql_varchar" null="true">
			order by tbl_basic.basic_string, tbl_basic.basic_date
	</cfquery>
	<cfscript>
		assertEqualsBAsic(qList, qDlist);
	</cfscript>
</cffunction>

<cffunction name="testSubselect" hint="" access="public" returntype="void" output="false">
<cfscript>
	var query = 0;
	var tql = 0;
	var qList = 0;
</cfscript>
<cfsavecontent variable="tql">
from manytoone.SimpleUUID as S
where S.string in
(
	Select Basic.string from Basic
)
</cfsavecontent>
<cfscript>
	query = getTransferB().createQuery(tql);
	qList = getTransferB().listByQuery(query);
</cfscript>
</cffunction>

<cffunction name="testSubselectWhere" hint="" access="public" returntype="void" output="false">
<cfscript>
	var query = 0;
	var tql = 0;
	var qList = 0;
</cfscript>
<cfsavecontent variable="tql">
from manytoone.SimpleUUID as S
where S.string in
(
	Select Basic.stringValue from BasicAliasID as Basic where Basic.stringValue LIKE :param
)
</cfsavecontent>
<cfscript>
	query = getTransferB().createQuery(tql);
	query.setParam("param", "g%", "string");
	qList = getTransferB().listByQuery(query);
</cfscript>
</cffunction>

<cffunction name="testBasicOneToManyJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from onetomany.Basic join onetomany.Child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select tbl_onetomany.basic_string as stringValue, tbl_onetomany.idbasic, tbl_onetomanychild.child_name as name, tbl_onetomanychild.IDChild from tbl_onetomany inner join tbl_onetomanychild ON tbl_onetomany.idbasic = tbl_onetomanychild.lnkBasicID
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicReverseOneToManyJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from onetomany.Child join onetomany.Basic";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select tbl_onetomanychild.child_name as name, tbl_onetomanychild.IDChild, tbl_onetomany.basic_string as stringValue, tbl_onetomany.idbasic from tbl_onetomanychild inner join tbl_onetomany ON tbl_onetomanychild.lnkBasicID = tbl_onetomany.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicOneToManyJoinWithAlias" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from onetomany.Basic as Basic join onetomany.Child as Child";
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select Basic.basic_string as stringValue, Basic.idbasic, Child.child_name as name, Child.IDChild from tbl_onetomany Basic inner join tbl_onetomanychild Child ON Basic.idbasic = Child.lnkBasicID
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicManyToManyJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from manytomany.SimpleUUID join BasicUUID";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_manytomanyuuid.IDSimple, tbl_basicuuid.basic_date as dateValue, tbl_basicuuid.basic_numeric as numericValue, tbl_basicuuid.basic_string as stringValue, tbl_basicuuid.basic_UUID as UUIDValue, tbl_basicuuid.IDBasic from tbl_manytomanyuuid inner join lnk_manytomanyuuid ON tbl_manytomanyuuid.IDSimple = lnk_manytomanyuuid.lnkIDManytoMany inner join tbl_basicuuid ON lnk_manytomanyuuid.lnkIDBasic = tbl_basicuuid.IDBasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicReverseManyToManyJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from BasicUUID join manytomany.SimpleUUID";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_basicuuid.basic_date as dateValue, tbl_basicuuid.basic_numeric as numericValue, tbl_basicuuid.basic_string as stringValue, tbl_basicuuid.basic_UUID as UUIDValue, tbl_basicuuid.IDBasic, tbl_manytomanyuuid.IDSimple from tbl_basicuuid inner join lnk_manytomanyuuid ON lnk_manytomanyuuid.lnkIDBasic = tbl_basicuuid.IDBasic inner join tbl_manytomanyuuid ON lnk_manytomanyuuid.lnkIDManytoMany = tbl_manytomanyuuid.IDSimple
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicManyToOneJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from manytoone.SimpleUUID join manytoone.ChildUUID";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_manytooneuuid.manytoone_string as stringValue, tbl_manytooneuuid.IDSimple, tbl_childmanytooneuuid.manytoonechild_string as dateValue, tbl_childmanytooneuuid.IDChild from tbl_manytooneuuid inner join tbl_childmanytooneuuid ON tbl_manytooneuuid.lnkIDChild = tbl_childmanytooneuuid.IDChild
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicReverseManyToOneJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from manytoone.ChildUUID join manytoone.SimpleUUID";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_childmanytooneuuid.manytoonechild_string as dateValue, tbl_childmanytooneuuid.IDChild, tbl_manytooneuuid.manytoone_string as stringValue, tbl_manytooneuuid.IDSimple from tbl_childmanytooneuuid inner join tbl_manytooneuuid ON tbl_childmanytooneuuid.IDChild = tbl_manytooneuuid.lnkIDChild
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testComposite" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "from composite.Composite join onetomany.Basic";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_composite.composite_string as stringValue, tbl_composite.IDComposite, tbl_onetomany.basic_string as stringValue_1, tbl_onetomany.idbasic from tbl_composite inner join lnk_composite1 ON tbl_composite.IDComposite = lnk_composite1.lnkIDComposite inner join tbl_onetomany ON tbl_composite.lnkIDBasic = tbl_onetomany.idbasic AND lnk_composite1.lnkIDBasic = tbl_onetomany.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testSingleColumnAliasing" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "select Comp.stringValue as CompStringValue from composite.Composite as Comp join onetomany.Basic";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select Comp.composite_string as CompStringValue from tbl_composite Comp inner join lnk_composite1 ON Comp.IDComposite = lnk_composite1.lnkIDComposite inner join tbl_onetomany ON Comp.lnkIDBasic = tbl_onetomany.idbasic AND lnk_composite1.lnkIDBasic = tbl_onetomany.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testMultipleColumnAliasing" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "select Comp.stringValue as CompStringValue, Basic.stringValue as BasicStringValue, Comp.IDComposite from composite.Composite as Comp join onetomany.Basic as Basic";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		 select Comp.composite_string as CompStringValue , Basic.basic_string as BasicStringValue , Comp.IDComposite from tbl_composite Comp inner join lnk_composite1 ON Comp.IDComposite = lnk_composite1.lnkIDComposite inner join tbl_onetomany Basic ON Comp.lnkIDBasic = Basic.idbasic AND lnk_composite1.lnkIDBasic = Basic.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testAsterisk" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "select * from composite.Composite as Comp join onetomany.Basic as Basic";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select Comp.composite_string as stringValue, Comp.IDComposite, Basic.basic_string as stringValue_1, Basic.idbasic from tbl_composite Comp inner join lnk_composite1 ON Comp.IDComposite = lnk_composite1.lnkIDComposite inner join tbl_onetomany Basic ON Comp.lnkIDBasic = Basic.idbasic AND lnk_composite1.lnkIDBasic = Basic.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testMultipleColumnWithAsterisk" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "select Comp.stringValue, * from composite.Composite as Comp join onetomany.Basic as Basic";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
	 select Comp.composite_string as stringValue , Comp.composite_string as stringValue_1, Comp.IDComposite, Basic.basic_string as stringValue_2, Basic.idbasic from tbl_composite Comp inner join lnk_composite1 ON Comp.IDComposite = lnk_composite1.lnkIDComposite inner join tbl_onetomany Basic ON Comp.lnkIDBasic = Basic.idbasic AND lnk_composite1.lnkIDBasic = Basic.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testMultipleColumnAliasingWithAsterisk" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "select Comp.stringValue as CompStringValue, Basic.stringValue as BasicStringValue, * from composite.Composite as Comp join onetomany.Basic as Basic";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		 select Comp.composite_string as CompStringValue , Basic.basic_string as BasicStringValue , Comp.composite_string as stringValue, Comp.IDComposite, Basic.basic_string as stringValue_1, Basic.idbasic from tbl_composite Comp inner join lnk_composite1 ON Comp.IDComposite = lnk_composite1.lnkIDComposite inner join tbl_onetomany Basic ON Comp.lnkIDBasic = Basic.idbasic AND lnk_composite1.lnkIDBasic = Basic.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicDistinctFromQuery" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var query = getTransferB().createQuery("from BasicAliasID");
		var qList = 0;
		query.setDistinctMode(true);
		qList = getTransferB().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select  distinct tbl_basic.basic_date as dateValue, tbl_basic.basic_numeric as numericValue, tbl_basic.basic_string as stringValue, tbl_basic.basic_UUID as UUIDValue, tbl_basic.basic_boolean as booleanValue, tbl_basic.IDBasic as id from tbl_basic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testSingleColumnDistinctAliasing" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "select Comp.stringValue as CompStringValue from composite.Composite as Comp join onetomany.Basic join onetomany.Child";
		var q = 0;
		query = getTransferC().createQuery(tql);
		query.setDistinctMode(true);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select distinct Comp.composite_string as CompStringValue from tbl_composite Comp inner join lnk_composite1 ON Comp.IDComposite = lnk_composite1.lnkIDComposite inner join tbl_onetomany ON Comp.lnkIDBasic = tbl_onetomany.idbasic AND lnk_composite1.lnkIDBasic = tbl_onetomany.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeSpecificCompositionJoin" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "from composite.Composite as Comp join onetomany.Basic ON Comp.OneToMany";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select Comp.composite_string as stringValue, Comp.IDComposite, tbl_onetomany.basic_string as stringValue_1, tbl_onetomany.idbasic from tbl_composite Comp inner join tbl_onetomany ON Comp.lnkIDBasic = tbl_onetomany.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testJoinJoinJoin" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from  composite.Composite as Comp join onetomany.Basic join onetomany.Child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select
			Comp.composite_string as stringValue,
			Comp.IDComposite,
			tbl_onetomany.basic_string as stringValue_1,
			tbl_onetomany.idbasic,
			tbl_onetomanychild.child_name as name,
			tbl_onetomanychild.IDChild
		from
			tbl_composite Comp
			inner join
			lnk_composite1
				on Comp.IDComposite = lnk_composite1.lnkIDComposite
			inner join
			tbl_onetomany
				ON Comp.lnkIDBasic = tbl_onetomany.idbasic
				AND
				lnk_composite1.lnkIDBasic = tbl_onetomany.idbasic
			inner join
			tbl_onetomanychild
				ON tbl_onetomany.idbasic = tbl_onetomanychild.lnkBasicID
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeSpecificCompositionJoinReverse" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "from onetomany.Basic join composite.Composite as Comp ON Comp.OneToMany";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_onetomany.basic_string as stringValue, tbl_onetomany.idbasic, Comp.composite_string as stringValue_1, Comp.IDComposite from tbl_onetomany inner join tbl_composite Comp ON tbl_onetomany.idbasic = Comp.lnkIDBasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicOneToManyJoinOn" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from onetomany.Basic as b join onetomany.Child ON b.child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select
			b.basic_string as stringValue,
			b.idbasic,
			tbl_onetomanychild.child_name as name,
			tbl_onetomanychild.IDChild
		from
			tbl_onetomany b
			inner join
			tbl_onetomanychild
				ON b.idbasic = tbl_onetomanychild.lnkBasicID
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testBasicOneToManyJoinOnReverse" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from onetomany.Child join onetomany.Basic as b ON b.child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getUsername()#">
		select
			tbl_onetomanychild.child_name as name,
			tbl_onetomanychild.IDChild,
			b.basic_string as stringValue,
			b.idbasic
		from
			tbl_onetomanychild
			inner join
			tbl_onetomany b
				ON tbl_onetomanychild.lnkBasicID = b.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testManyToManyJoinOn" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from manytomany.SimpleUUID as s join BasicUUID on s.Child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_manytomanyuuid.idsimple, tbl_basicuuid.basic_date as datevalue, tbl_basicuuid.basic_numeric as numericvalue, tbl_basicuuid.basic_string as stringvalue, tbl_basicuuid.basic_uuid as uuidvalue, tbl_basicuuid.idbasic from tbl_manytomanyuuid inner join lnk_manytomanyuuid on tbl_manytomanyuuid.idsimple = lnk_manytomanyuuid.lnkidmanytomany inner join tbl_basicuuid on lnk_manytomanyuuid.lnkidbasic = tbl_basicuuid.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testManyToManyJoinOnReverse" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from BasicUUID join manytomany.SimpleUUID as s on s.Child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select tbl_basicuuid.basic_date as datevalue, tbl_basicuuid.basic_numeric as numericvalue, tbl_basicuuid.basic_string as stringvalue, tbl_basicuuid.basic_uuid as uuidvalue, tbl_basicuuid.idbasic, s.idsimple from tbl_basicuuid  inner join lnk_manytomanyuuid on lnk_manytomanyuuid.lnkidbasic = tbl_basicuuid.idbasic inner join tbl_manytomanyuuid s on lnk_manytomanyuuid.lnkidmanytomany = s.idsimple
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeSpecificCompositionJoinAND" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "from composite.Composite as Comp join onetomany.Basic ON Comp.OneToMany AND Comp.Child";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select
			comp.composite_string as stringvalue,
			comp.idcomposite,
			tbl_onetomany.basic_string as stringvalue_1,
		tbl_onetomany.idbasic
			from tbl_composite comp
		inner join
			lnk_composite1
			on comp.idcomposite = lnk_composite1.lnkidcomposite
		inner join
			tbl_onetomany
		on comp.lnkidbasic = tbl_onetomany.idbasic
		and
		lnk_composite1.lnkidbasic = tbl_onetomany.idbasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeManualJoin" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "select B.stringValue from BasicUUID as B join manytoone.SimpleUUID as S ON B.stringValue = S.stringValue";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		query.setDistinctMode(true);
		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select distinct  B.basic_string as stringValue from tbl_basicuuid B inner join tbl_manytooneuuid S ON B.basic_string = S.manytoone_string
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeManualOuterJoin" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "select B.stringValue from BasicUUID as B outer join manytoone.SimpleUUID as S ON B.stringValue = S.stringValue";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		query.setDistinctMode(true);
		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select distinct  B.basic_string as stringValue from tbl_basicuuid B left outer join tbl_manytooneuuid S ON B.basic_string = S.manytoone_string
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeManualLeftOuterJoin" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "select B.stringValue from BasicUUID as B left outer join manytoone.SimpleUUID as S ON B.stringValue = S.stringValue";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		query.setDistinctMode(true);
		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select distinct  B.basic_string as stringValue from tbl_basicuuid B left outer join tbl_manytooneuuid S ON B.basic_string = S.manytoone_string
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeManualRightOuterJoin" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "select B.stringValue from BasicUUID as B right outer join manytoone.SimpleUUID as S ON B.stringValue = S.stringValue";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		query.setDistinctMode(true);
		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select distinct  B.basic_string as stringValue from tbl_basicuuid B right outer join tbl_manytooneuuid S ON B.basic_string = S.manytoone_string
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testManyToManyOuterJoinOn" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from manytomany.SimpleUUID as s outer join BasicUUID on s.Child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select s.IDSimple, tbl_basicuuid.basic_date as dateValue, tbl_basicuuid.basic_numeric as numericValue, tbl_basicuuid.basic_string as stringValue, tbl_basicuuid.basic_UUID as UUIDValue, tbl_basicuuid.IDBasic from tbl_manytomanyuuid s left outer  join lnk_manytomanyuuid on s.IDSimple = lnk_manytomanyuuid.lnkIDManytoMany left outer join tbl_basicuuid on lnk_manytomanyuuid.lnkIDBasic = tbl_basicuuid.IDBasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testManyToManyLeftOuterJoinOn" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var tql = "from manytomany.SimpleUUID as s left outer join BasicUUID on s.Child";
		var q = 0;
		query = getTransferC().createQuery(tql);

		qList = getTransferC().listByQuery(query);
	</cfscript>
	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select s.IDSimple, tbl_basicuuid.basic_date as dateValue, tbl_basicuuid.basic_numeric as numericValue, tbl_basicuuid.basic_string as stringValue, tbl_basicuuid.basic_UUID as UUIDValue, tbl_basicuuid.IDBasic from tbl_manytomanyuuid s left outer  join lnk_manytomanyuuid on s.IDSimple = lnk_manytomanyuuid.lnkIDManytoMany left outer join tbl_basicuuid on lnk_manytomanyuuid.lnkIDBasic = tbl_basicuuid.IDBasic
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

<cffunction name="testCompositeManualJoinMappedParam" hint="" access="public" returntype="string" output="false">
	<cfscript>
		var tql = "select B.stringValue from BasicUUID as B join manytoone.SimpleUUID as S ON B.stringValue = S.stringValue AND B.stringValue = :value";
		var q = 0;
		var qList = 0;
		query = getTransferC().createQuery(tql);
		query.setParam("value", "george");
		query.setDistinctMode(true);
		qList = getTransferC().listByQuery(query);
	</cfscript>
 	<cfquery name="q" datasource="#getDataSource().getName()#" username="#getDataSource().getUsername()#" password="#getDataSource().getPassword()#">
		select distinct  B.basic_string as stringValue from tbl_basicuuid B inner join tbl_manytooneuuid S ON B.basic_string = S.manytoone_string AND B.basic_string =
		<cfqueryparam value="george" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset AssertEqualsBasic(q, qList)>
</cffunction>

</cfcomponent>