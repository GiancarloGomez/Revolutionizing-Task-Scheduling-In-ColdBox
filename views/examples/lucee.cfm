<cfscript>
	cfschedule(
		action       = "update",
		task         = "GO-SHORT",
		interval     = 10,
		startDate    = now(),
		startTime    = now(),
		url          = "http://127.0.0.1:8090/scheduledtask/short/",
		unique       = false,
		readonly     = true,
		autodelete   = true
	);

	cfschedule(
		action = "list",
		result = "server_schedule"
	);

	writeDump( server_schedule );
</cfscript>
```