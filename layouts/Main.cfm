<cfscript>
	prc.icon = server.keyExists("boxlang") ?
				"boxlang":
				server.keyExists("lucee") ?
				"lucee" :
				"acf";
</cfscript>
<cfoutput>
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>#prc.title ?: "Revolutionizing Task Scheduling in ColdBox"#</title>
	<meta name="author" content="Giancarlo Gomez @ Fuse Developments, Inc.">
	<meta name="description" content="Revolutionizing Task Scheduling in ColdBox">
	<base href="#event.getHTMLBaseURL()#" />
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
	<link rel="icon" href="/includes/icon/#prc.icon#-icon.png">
</head>
<body class="bg-light">
	#view()#
</body>
</html>
</cfoutput>