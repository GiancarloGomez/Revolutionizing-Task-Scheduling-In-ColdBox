/**
 * Event handler for Scheduler tasks Events.
 */
component implements="CFIDE.scheduler.ITaskEventHandler" {

	/**
	 * Called when job is about to be executed.If this returns false,
	 * CF will veto the job and wont execute it
	 */
	public boolean function onTaskStart( struct context ){
		writeDump( var:arguments.context, label:"onTaskStart", output:"console" );
		return true;
	}

	/**
	 * Called once execution of the task is over
	 */
	public void function onTaskEnd( struct context ){
		writeDump( var:arguments.context, label:"onTaskEnd", output:"console" );
	}

	/**
	 * Called when a task gets misfired
	 */
	public void function onMisfire( struct context ){
		writeDump( var:arguments.context, label:"onMisfire", output:"console" );
	}

	/**
	 * Called when a task throws an runtime exception
	 */
	public void function onError( struct context ){
		writeDump( var:arguments.context, label:"onError", output:"console" );
	}

	/**
	 * Called when URL is not specified.Instead this method will be
	 * invoked on scheduled times
	 */
	public void function execute( struct context ){ }
}