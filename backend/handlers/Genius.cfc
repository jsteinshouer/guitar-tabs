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

	/**
	 * Check API for metadata on all tabs
	 */
	any function scrape( event, rc, prc ){

		setting requestTimeout=240;
		
		var tabs = prc.user.getTablature();

		tabs.each( (tab, index) => {
			if ( tab.getSongTitle() == "" ) {
				try {
					var searchResult = geniusService.search( tab.getTitle().replace("'","","all") ).response;
					if ( searchResult.hits.len() && searchResult.hits[1].result.title == tab.getTitle() ) {
						var song = geniusService.getSong( searchResult.hits[1].result.id );
						tab.update( {
							songTitle: song.getTitle(),
							songThumbnail: song.getThumbnail(),
							artist: song.getArtist(),
							album: song.getAlbum(),
							geniusMetadata: serializeJSON(song.getGeniusMetadata( ))
						}, true );
					}
				}
				catch(any e) {
					// rethrow;
				}
			}
		});


		prc.response.setData( tabs.map( (i) => { return i.getMemento(); } ) );

	}



}