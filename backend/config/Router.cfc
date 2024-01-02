component{

	function configure(){
		setFullRewrites( true );

        // A nice healthcheck route example
		route( "/healthcheck", function( event, rc, prc ) {
			return "Ok!";
		} );

		addNamespace( namespace="api", pattern="/api" );
		// API Echo
		route( "/echo")
			.withNamespace("api")
			.withAction({
				GET: "index" 
			})
			.toHandler("Echo");
		route( "/genius/song/:id")
			.withNamespace("api")
			.withAction({
				GET: "song" 
			})
			.toHandler("Genius");
		route( "/genius/scrape")
			.withNamespace("api")
			.withAction({
				GET: "scrape" 
			})
			.toHandler("Genius");
		route( "/genius")
			.withNamespace("api")
			.withAction({
				GET: "index" 
			})
			.toHandler("Genius");
		route( "/signup")
			.withNamespace("api")
			.withAction({
				POST: "index" 
			})
			.toHandler("Signup");
		route( "/authorize/logout")
			.withNamespace("api")
			.withAction({
				GET: "logout" 
			})
			.toHandler("Authorize")
		route( "/authorize")
			.withNamespace("api")
			.withAction({
				POST: "index" 
			})
			.toHandler("Authorize")

		resources( resource="Tablature", namespace="api" );

		route(pattern=".*",handler="Main",action="index").end();
	}

}