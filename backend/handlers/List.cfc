/**
* My RESTFul Event Handler
*/
component extends="BaseHandler" secured="true" {

	/**
	 * Runs before each action
	 */
	any function preHandler( event, rc, prc ){
		prc.user = getInstance("User")
			.where( "username", prc.authorizedUsername )
			.firstOrFail();
	}

	// /**
	//  * Index
	//  */
	any function index( event, rc, prc ){
		prc.response.setData( prc.user.getLists().map( (i) => { 
			var data = i.getMemento();
			data["tabs"] = i.getTabs().map( (tab) => tab.getMemento( excludes="content" ) );
			return data; 
		} ) );
	}


	/**
	 * Get a list
	 */
	any function show( event, rc, prc ){
		var list = getInstance( "TabList" )
				.findOrFail( rc.id );
		if ( list.getUserID() == prc.user.getID() ) {
			var data = list.getMemento();
			data["tabs"] = list.getTabs().map( (tab) => tab.getMemento( excludes="content" ) );
			prc.response.setData( data );
		}
		else {
			prc.response.setStatus( 403 );
		}
	}

	/**
	 * Create a new tablature
	 */
	any function create( event, rc, prc ){

		var list = getInstance( "TabList" ).create( {
			"title": rc.title,
			"userID": prc.user.getID()
		});

		prc.response.setData( list.getMemento() );
		prc.response.setStatusCode( 201 );
	}

	/**
	 * Update a tab
	 */
	any function update( event, rc, prc ){

		var list =prc.user.lists()
			.findOrFail( rc.id )
			.update( {
				"title": rc.title
			});

		prc.response.setData( list.getMemento() );
		prc.response.setStatusCode( 200 );
	}

	/**
	 * Delete a tablature record
	 */
	any function delete( event, rc, prc ){

		var list = getInstance( "TabList" ).findOrFail( rc.id );
		if ( list.getUserID() == prc.user.getID() ) {
			list.delete();
			prc.response.setStatusCode( 200 );
		}
		else {
			prc.response.setStatus( 403 );
		}
	}

	/**
	 * Add an item to a list
	 */
	any function addItem( event, rc, prc ){

		var list = prc.user.lists()
			.findOrFail( rc.id );

		list.tabs().attach( prc.user.tablature().findOrFail( rc.tabID ) );
	
		prc.response.setData( list.getMemento() );
		prc.response.setStatusCode( 201 );
	}

	/**
	 * remove an item to a list
	 */
	any function removeItem( event, rc, prc ){

		var list = prc.user.lists()
			.findOrFail( rc.id );

		list.tabs().detach( prc.user.tablature().findOrFail( rc.tabID ) );
	
		prc.response.setData( list.getMemento() );
		prc.response.setStatusCode( 200 );
	}

}