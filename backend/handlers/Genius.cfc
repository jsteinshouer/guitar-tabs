/**
* Genius API Proxy
*/
component extends="BaseHandler" secured="true" {

	property name="geniusService" inject="songs.GeniusAPIService";
	/**
	 * Runs before each action
	 */
	any function preHandler( event, rc, prc ){
		prc.user = getInstance("User")
			.where( "username", prc.authorizedUsername )
			.firstOrFail();
	}

	/**
	 * Index
	 */
	any function index( event, rc, prc ){
		
		if ( rc.keyExists("searchQuery") ) {
			prc.response.setData( geniusService.search( rc.searchQuery ) );
		}
		else {
			prc.response.setErrorMessage(
				errorMessage = "Search query is required",
				statusCode = 400,
				statusText = "Bad Request"
			)
		}
	}

	/**
	 * Get song data from the API
	 */
	any function song( event, rc, prc ){
		
		if ( rc.keyExists("id") ) {
			prc.response.setData( geniusService.getSong( rc.id ).getMemento() );
		}
		else {
			prc.response.setErrorMessage(
				errorMessage = "Song ID is required",
				statusCode = 400,
				statusText = "Bad Request"
			)
		}
	}



}