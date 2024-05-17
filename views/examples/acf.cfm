<cfscript>

	cfschedule(
		action       = "update",
		group        = "PREZ",
		task         = "GO-SHORT",
		interval     = 5,
		eventHandler = "standalone.TaskEventHandler",
		mode         = "application",
		url          = "http://127.0.0.1:8091/scheduledtask/short/"
	);

	// cfschedule(
	// 	action       = "update",
	// 	group        = "PREZ",
	// 	task         = "GO-LONG",
	// 	interval     = 5,
	// 	eventHandler = "standalone.TaskEventHandler",
	// 	url          = "http://127.0.0.1:8091/scheduledtask/long/?sleep=10000"
	// );

	cfschedule(
		action = "list",
		result = "app_schedule",
		mode   = "application"
	);

	cfschedule(
		action = "list",
		result = "server_schedule"
	);

	writeDump( app_schedule );
	writeDump( server_schedule );
</cfscript>