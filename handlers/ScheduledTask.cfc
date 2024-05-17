component extends="coldbox.system.EventHandler" {

	property name="log" inject="logbox:logger:{this}";

	function preHandler( event, rc, prc ){
		prc.task = {
			id              : createUUID(),
			agent           : server.coldfusion.productName & " : " &
								( len(cgi.http_user_agent) ? cgi.http_user_agent : "ColdBox Scheduler" ),
			processing_time : getTickCount(),
			timestamp : {
				start : dateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss"),
				end   : ""
			}
		};
	}

	function short( event, rc, prc ){
		prc.task.identifier = "short : " & prc.task.id & " : " & prc.task.agent & " : ";
		log.info( prc.task.identifier & "started" );
		if ( event.valueExists( "sleep") )
			sleep( event.getValue( "sleep" ) );
		setTimes( prc );
		log.info( prc.task.identifier & "finished" );
		// throw( message="This is an error" );
		return prc.task;
	}

	function long( event, rc, prc ){
		prc.task.identifier = "long : " & prc.task.id & " : " & prc.task.agent & " : ";
		log.info( prc.task.identifier & "started" );
		if ( event.valueExists( "sleep") )
			sleep( event.getValue( "sleep" ) );
		setTimes( prc );
		log.info( prc.task.identifier & "finished" );
		return prc.task;
	}

	private function setTimes( prc ){
		prc.task.timestamp.end   = dateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss");
		prc.task.processing_time = ( getTickCount() - prc.task.processing_time ) / 1000 ;
	}
}