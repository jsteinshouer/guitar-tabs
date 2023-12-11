/**
* Genius API Proxy
*/
component extends="coldbox.system.RestHandler" secured="true" {

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



}