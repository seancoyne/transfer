

<cfimport prefix="report" taglib="/transfer/tags/reports">

<p>

<report:cacheReport monitor="#application.transferFactory.getTransfer().getCacheMonitor()#">

</p>

<p>

<report:cacheReport monitor="#application.transferFactory.getTransfer().getCacheMonitor()#" mode="detail" chartsize="300">

</p>




