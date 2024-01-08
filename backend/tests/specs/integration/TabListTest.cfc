/*******************************************************************************
*	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
*
*	Extends the integration class: coldbox.system.testing.BaseTestCase
*
*	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
*	the '/root' mapping created in the test folder Application.cfc.  Please note that this
*	Application.cfc must mimic the real one in your root, including ORM settings if needed.
*
*	The 'execute()' method is used to execute a ColdBox event, with the following arguments
*	* event : the name of the event
*	* private : if the event is private or not
*	* prePostExempt : if the event needs to be exempt of pre post interceptors
*	* eventArguments : The struct of args to pass to the event
*	* renderResults : Render back the results of the event
*******************************************************************************/
component extends="BaseIntegrationTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
		util = new coldbox.system.core.util.Util();
		jwt = new lib.jwt.JWT( key = util.getSystemSetting("JWT_SECRET"), issuer = util.getSystemSetting("JWT_ISSUER") );
		var authTokenPayload = {
			"iss" = util.getSystemSetting("JWT_ISSUER"),
			"exp" = dateAdd( "n", util.getSystemSetting("JWT_EXP_MIN"), now() ).getTime(),
			"sub" = "nigel"
		};
		testUser = {
			"username": "nigel",
			"firstName": "Nigel",
			"lastName": "Tufnel",
			"password": "turnitto11"
		};
		mockAuthToken = jwt.encode( authTokenPayload );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Test TabList Resource", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				//Create mock auth cookie
				cookie[ util.getSystemSetting( "AUTH_COOKIE_NAME" ) ] = mockAuthToken;

			});

			describe( "GET /list/:id", function(){

				it( "should get a list", function(){
					var user = getInstance( "User" ).create(testUser);

					var tab = getInstance( "Tab" ).create( {
						"title": "My Tab Title",
						"content": "test content",
						"userID": user.getID()
					});
					var tab2 = getInstance( "Tab" ).create( {
						"title": "Another tab",
						"content": "more content",
						"userID": user.getID()
					});

					var list = getInstance( "TabList" ).create( {
						"title": "My List Title",
						"userID": user.getID()
					});
					list.tabs().attach( tab );
					list.tabs().attach( tab2 );
					
					var event = get( route = "api/list/" & list.getID()  );
					
					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().id ).toBe( list.getID() );
					expect(	response.getData().title ).toBe( "My List Title" );
					expect(	response.getData().tabs.len() ).toBe( 2 );

				});

			});


			describe( "GET /list", function(){

				it( "should return the user's lists", function(){

					var user = getInstance( "User" ).create(testUser);

					var tab = getInstance( "Tab" ).create( {
						"title": "My Tab Title",
						"content": "test content",
						"userID": user.getID()
					});
					var tab2 = getInstance( "Tab" ).create( {
						"title": "Another tab",
						"content": "more content",
						"userID": user.getID()
					});

					var list = getInstance( "TabList" ).create( {
						"title": "My Favorites",
						"userID": user.getID()
					});
					list.tabs().attach( tab );
					list.tabs().attach( tab2 );

					var list2 = getInstance( "TabList" ).create( {
						"title": "Another list",
						"userID": user.getID()
					});
					list2.tabs().attach( tab );

					var event = get( route = "api/list" );

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().len() ).toBe( 2 );
					expect(	response.getData()[1].title ).toBe( "My Favorites" );
					expect(	response.getData()[1].tabs.len() ).toBe( 2 );
					expect(	response.getData()[2].tabs.len() ).toBe( 1 );

				});

			});


			describe( "POST /list", function(){

				it( "should create a new list", function(){
					var user = getInstance( "User" ).create(testUser);

					var event = post(
						route = "api/list",
						params = {
							title = "My Favortites"
						}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 201 );
					expect(	response.getData().id ).toBeGT( 0 );
					expect(	response.getData().title ).toBe( "My Favortites" );
				});

			});

			describe( "POST /list/:id/item/:tabID", function(){

				it( "should add an item to a list", function(){
					var user = getInstance( "User" ).create(testUser);

					var list = getInstance( "TabList" ).create( {
						"title": "My List",
						"userID": user.getID()
					});

					var tab = getInstance( "Tab" ).create( {
						"title": "My Tab",
						"content": "test content",
						"userID": user.getID()
					});

					var event = post(
						route = "api/list/#list.getID()#/item/#tab.getID()#"
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 201 );
					expect(	list.getTabs().len() ).toBe( 1 );
				});

			});

			describe( "DELETE /list/:id/item/:tabID", function(){

				it( "should remove an item to a list", function(){
					var user = getInstance( "User" ).create(testUser);

					var list = getInstance( "TabList" ).create( {
						"title": "My List",
						"userID": user.getID()
					});

					var tab = getInstance( "Tab" ).create( {
						"title": "My Tab",
						"content": "test content",
						"userID": user.getID()
					});

					list.tabs().attach( tab );

					var event = delete(
						route = "api/list/#list.getID()#/item/#tab.getID()#"
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	list.getTabs().len() ).toBe( 0 );
				});

			});

			describe( "PUT /list/:id", function(){

				it( "should get a tab", function(){
					var user = getInstance( "User" ).create(testUser);

					var list = getInstance( "TabList" ).create( {
						"title": "My List",
						"userID": user.getID()
					});

					var event = put( 
						route = "api/list/" & list.getID(),
						params = {
							title = "Change the Title"
						}
					);
					
					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().id ).toBe( list.getID() );
					expect(	response.getData().title ).toBe( "Change the Title" );

				});

			});

			describe( "DELETE /list", function(){

				it( "should delete tab record", function(){
					var user = getInstance( "User" ).create(testUser);

					var testList = getInstance( "TabList" ).create( {
						"title": "Test 1",
						"userID": user.getID()
					});

					var event = delete(
						route = "api/list/#testList.getID()#"
					);

					var response 	= event.getPrivateValue( "response" );

					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	getInstance( "TabList" ).find( testList.getID() ) ).toBeNull();
				});

			});


		});

	}

}