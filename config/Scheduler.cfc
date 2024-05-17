component {

	/**
	 * Configure the ColdBox Scheduler
	 * https://coldbox.ortusbooks.com/digging-deeper/scheduled-tasks
	 */
	function configure() {
		/**
		 * --------------------------------------------------------------------------
		 * Configuration Methods
		 * --------------------------------------------------------------------------
		 * From here you can set global configurations for the scheduler
		 * - setTimezone( ) : change the timezone for ALL tasks
		 * - setExecutor( executorObject ) : change the executor if needed
		 * - setCacheName( "template" ) : Change the cachename for ALL tasks
		 * - setServerFixation( true ) : Set all tasks to run on one server
		 */
			setTimezone( "America/New_York" );
			setExecutor(
				asyncManager.newScheduledExecutor( "MyCustomExecutor", 10 )
			);

		/**
		 * --------------------------------------------------------------------------
		 * Register Scheduled Tasks
		 * --------------------------------------------------------------------------
		 * You register tasks with the task() method and get back a ColdBoxScheduledTask object
		 * that you can use to register your tasks configurations.
		 */

		task( "task-01" )
			.setGroup( "marketing" )
			.debug( true )
			.call( () => runEvent( "ScheduledTask.short" ) )
			.setMeta({
				"name" : "Giancarlo Gomez"
			})
			.every( 5, "seconds" )
			.between( 11, 17 );

		task( "task-02" )
			.call( () => runEvent( "ScheduledTask.long" ) )
			.setMeta({
				"name" : "Giancarlo Gomez"
			})
			.every( 10, "seconds" )
			.between( "08:00", "16:00" );

		task( "task-03" )
			.setGroup( "http" )
			.call( () => {
				return getInstance("httpService")
					.execute(
						name      : "http:task-03",
						url       : "http://127.0.0.1:#cgi.server_port#/scheduledtask/short/?sleep=6000",
						exclusive : false
					);
			})
			.every( 1,"day")
			.startOnTime( "06:00" );

		task( "task-04" )
			.setGroup( "http" )
			.call( () => {
				return true;
			})
			.every( 1,"day")
			.endOnTime( "13:00" );

		task( "cache-startup" )
			.setGroup( "single" )
			.call( () => {
				return true;
			});

		task( "dev-sync" )
			.setGroup( "single" )
			.call( () => {
				return true;
			})
			.onEnvironment( "staging" );
	}

	/**
	 * Called before the scheduler is going to be shutdown
	 */
	function onShutdown(){
		log.info( "Scheduler onShutdown Fired" );
	}

	/**
	 * Called after the scheduler has registered all schedules
	 */
	function onStartup(){
		log.info( "Scheduler onStartup Fired" );
	}

	/**
	 * Called whenever ANY task fails
	 *
	 * @task The task that got executed
	 * @exception The ColdFusion exception object
	 */
	function onAnyTaskError( required task, required exception ){
		log.info( renderBlock( task.getName() & " onAnyTaskError() " & chr(10) & exception.message ) );
	}

	/**
	 * Called whenever ANY task succeeds
	 *
	 * @task The task that got executed
	 * @result The result (if any) that the task produced
	 */
	function onAnyTaskSuccess( required task, result ){
		log.info( renderBlock( task.getName() & " onAnyTaskSuccess() " & repeatString(chr(10),2) & serializeJSON( result ) ) );
	}

	/**
	 * Called before ANY task runs
	 *
	 * @task The task about to be executed
	 */
	function beforeAnyTask( required task ){
		log.info( renderBlock( task.getName() & " beforeAnyTask()" ) );
	}

	/**
	 * Called after ANY task runs
	 *
	 * @task The task that got executed
	 * @result The result (if any) that the task produced
	 */
	function afterAnyTask( required task, result ){
		log.info( renderBlock( task.getName() & " afterAnyTask()" & repeatString(chr(10),2) &  task.getStats().toString() ) );
	}

	private string function renderBlock( required string value ){
		return " : " &
				chr(10) &
				repeatString("*",80) &
				repeatString(chr(10),2) &
				arguments.value &
				repeatString(chr(10),2) &
				repeatString("*",80);
	}

}