component{

	this.name = "standalone";


	function onApplicationStart(){
		application.asyncManager = new coldbox.system.async.AsyncManager();
		application.scheduler    = application.asyncmanager.newScheduler( "standalone-app-scheduler" );

		application.scheduler.setExecutor(
			application.asyncManager.newScheduledExecutor( "standalone-app-executor", 50 )
		);

		/**
		 * --------------------------------------------------------------------------
		 * Register Scheduled Tasks
		 * --------------------------------------------------------------------------
		 * You register tasks with the task() method and get back a ColdBoxScheduledTask object
		 * that you can use to register your tasks configurations.
		 */

		// application.scheduler.task( "my-simple-task", true )
		// 	.call( () => {
		// 		writeDump( var:"I am running now!!", output:"console" );
		// 		return { success:true };
		// 	} )
		// 	.every( "5", "seconds" )
		// 	.between( "09:00", "17:00" )
		// 	.delay( "20", "seconds" );

		// Startup the scheduler
		application.scheduler.startup();

	}

	function onRequestStart(){
		if ( url.keyExists( "reset" ) ){
			applicationStop();
			location( "./", false );
		}
		return true;
	}


	function onApplicationEnd( appScope ){
		// When the app is restart or dies make sure you cleanup
		appScope.scheduler.shutdown();
	}
}