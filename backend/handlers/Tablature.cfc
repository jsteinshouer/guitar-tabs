/**
* My RESTFul Event Handler
*/
component extends="coldbox.system.RestHandler" secured="true" {

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
		prc.response.setData( prc.user.getTablature().map( (i) => { return i.getMemento(); }) );
	}


	/**
	 * Read a tab
	 */
	any function show( event, rc, prc ){
		var tab = getInstance( "Tab" )
				.findOrFail( rc.id );
		if ( tab.getUserID() == prc.user.getID() ) {
			prc.response.setData( tab.getMemento() );
		}
		else {
			prc.response.setStatus( 403 );
		}
	}

	/**
	 * Create a new tablature
	 */
	any function create( event, rc, prc ){

		var tab = getInstance( "Tab" ).create( {
			"title": rc.title,
			"content": rc.content,
			"userID": prc.user.getID()
		});

		prc.response.setData( tab.getMemento() );
		prc.response.setStatusCode( 201 );
	}

	/**
	 * Update a tab
	 */
	any function update( event, rc, prc ){

		var movie =prc.user.tablature()
			.findOrFail( rc.id )
			.update( {
				"title": rc.title,
				"content": rc.content
			});

		prc.response.setData( movie.getMemento() );
		prc.response.setStatusCode( 200 );
	}

	/**
	 * Delete a tablature record
	 */
	any function delete( event, rc, prc ){

		var tab = getInstance( "Tab" ).findOrFail( rc.id );
		if ( tab.getUserID() == prc.user.getID() ) {
			tab.delete();
			prc.response.setStatusCode( 200 );
		}
		else {
			prc.response.setStatus( 403 );
		}
	}

}