
/**
 * Module Task Scheduler
 * https://coldbox.ortusbooks.com/digging-deeper/scheduled-tasks
 */
component {

	function configure(){
		task( "photoNumbers" )
			.setGroup( "accounting" )
			.call( () => {
				var random = randRange( 0, 1000 );
				log.info( "EnhancedUI.photoNumbers > " & random );
				return random;
			} )
			.every( 5, "seconds" )
			.delay( 10, "seconds" );

			task( "task-01" )
			.setGroup( "accounting" )
			.call( () => {
				var random = randRange( 0, 1000 );
				log.info( "EnhancedUI.task-01 > " & random );
				return random;
			} )
			.every( 5, "seconds" );

			task( "clean-the-books" )
			.setGroup( "accounting" )
			.call( () => {
				log.info( "EnhancedUI.clean-the-books" );
			} )
			.everyYearOn( 12, 31, "23:00" );

			task( "start-of-month" )
			.setGroup( "accounting" )
			.call( () => {
				log.info( "EnhancedUI.start-of-month" );
			} )
			.onFirstBusinessDayOfTheMonth( "04:00" );

			task( "end-of-month" )
			.setGroup( "accounting" )
			.call( () => {
				log.info( "EnhancedUI.nd-of-month" );
			} )
			.onLastBusinessDayOfTheMonth( "18:00" );
	}

}