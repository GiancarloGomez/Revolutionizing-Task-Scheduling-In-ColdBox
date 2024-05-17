component accessors=true output=false singleton=true {

	property name="timestamp";
	property name="log" inject="logbox:logger:{this}";

	/**
	 * Init
	 * @configSettings.inject coldbox:configSettings
	 */
	public HttpService function init(
		required configSettings
	){
		setTimestamp(now());
		return this;
	}

	public any function execute(
		required string name,
		required string url,
		string method  = "GET",
		boolean exclusive = false,
		array params = []
	){
		// create uuid for db logging
		arguments.id = createUUID();
		return arguments.exclusive ?
				executeExclusively( argumentCollection:arguments ) :
				executeInThread( argumentCollection:arguments );
	}

	private boolean function executeInThread(
		required uuid id,
		required string name,
		required string url,
		string method  = "GET",
		boolean exclusive = false,
		array params = []
	){
		cfthread(
			name      = "HttpService-Thread-" & arguments.id,
			action    = "run",
			data      = arguments
		) {
			variables.log.info( "executeInThread : " & data.name & " : " & data.id & " : " & data.url );
			var response = call( argumentCollection:attributes.data );
			variables.log.info( "executeInThread : " & data.name & " : " & data.id & " : completed" & chr(10) & serializeJSON( response.data ) );
		}
		return true;
	}

	private struct function executeExclusively(
		required uuid id,
		required string name,
		required string url,
		string method  = "GET",
		boolean exclusive = false,
		array params = []
	){
		variables.log.info( "executeExclusively : " & arguments.name & " : " & arguments.id & " : " & arguments.url );
		var response = call( argumentCollection:arguments );
		variables.log.info("executeExclusively : " &  arguments.name & " : " & arguments.id & " : completed" ); // chr(10) & serializeJSON( response )
		return response.data;
	}

	private any function call(
		required string url,
		string method  = "GET",
		boolean exclusive = false,
		array params = []
	){
		var requestStart = getTickCount();
		var apiResponse  = makeHttpRequest( argumentCollection:arguments );
		var result       = {
			"request"      : apiResponse,
			"request_time" : getTickCount() - requestStart,
			"success"      : false,
			"status_code"  : listFirst( apiResponse.statuscode, " " ),
			"status_text"  : listRest( apiResponse.statuscode, " " ),
			"error"        : "",
			"data"         : ""
		};
		var htmlInResponse = {};

		// process response
		if ( apiResponse.keyExists( "fileContent" ) ){
			if ( result.status_code.reFind("200|202") ){
				result.success = true;
				// JSON or simple response
				result.data = isJSON( apiResponse.fileContent )  ?
								deserializeJSON( apiResponse.fileContent ) :
								apiResponse.fileContent;
			}
			else {
				htmlInResponse = reFind( "<body([^>]+)?>(.*)</body>", apiResponse.fileContent , 1, true );
				// trimmed and sanitized body text or all response content
				result.error = htmlInResponse.match.len() >= 3 ?
								htmlInResponse.match.last().replaceAll( "<[^>]*>", "" ).trim().left( 1000) :
								apiResponse.fileContent;
			}
		}
		else if ( !isNull(apiResponse.error.message) ){
			result.error = apiResponse.error.message;
		}

		// cleanups
		structDelete( result, result.success ? "error" : "data" );

		return result;
	}

	private any function makeHttpRequest(
		required string url,
		required string method = "GET",
		required array params,
		boolean exclusive = false,
		numeric timeout = 0
	){
		var response = {};

		try{
			cfhttp(
				url         = arguments.url,
				method      = arguments.method,
				result      = "response",
				timeout     = arguments.timeout
			) {
				for ( var param in arguments.params )
					cfhttpparam ( type=param.type ?: "", value=param.value ?: "", name=param.name ?: "", file=param.file ?: "" );
			}
		}
		catch( any e ){
			response = {
				"statuscode" : 500,
				"success"    : false,
				"error"      : {
					"message"    : e.message,
					"stackTrace" : e.stackTrace,
					"tagContext" : e.tagContext
				}
			};
		}

		return response;
	}
}