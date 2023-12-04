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

		describe( "Test Tablature Resource", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				//Create mock auth cookie
				cookie[ util.getSystemSetting( "AUTH_COOKIE_NAME" ) ] = mockAuthToken;

			});

			describe( "GET /tablature/:id", function(){

				it( "should get a tab", function(){
					var user = getInstance( "User" ).create(testUser);

					var tab = getInstance( "Tab" ).create( {
						"title": "My Tab Title",
						"content": "test content",
						"userID": user.getID()
					});

					var event = get( route = "api/tablature/" & tab.getID()  );

					
					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().id ).toBe( tab.getID() );
					expect(	response.getData().title ).toBe( "My Tab Title" );
					expect(	response.getData().content ).toBe( "test content" );

				});

			});


			describe( "GET /tablatures", function(){

				it( "should list existing tabs", function(){

					var user = getInstance( "User" ).create(testUser);

					var tab = getInstance( "Tab" );

					tab.create( {
						"title": "Test 1",
						"content": "test 1",
						"userID": user.getID()

					});
					tab.create( {
						"title": "Test 2",
						"content": "test 2",
						"userID": user.getID()
					});

					var event = get( route = "api/tablature" );

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().len() ).toBe( 2 );
					expect(	response.getData()[1].content ).toBe( "test 1" );

				});

			});


			describe( "POST /tablature", function(){

				it( "should create a new tab", function(){
					var user = getInstance( "User" ).create(testUser);

					var event = post(
						route = "api/tablature",
						params = {
							title = "Test Tab Title",
							content = "Some Tab Content"
						}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 201 );
					expect(	response.getData().id ).toBeGT( 0 );
					expect(	response.getData().title ).toBe( "Test Tab Title" );
					expect(	response.getData().content ).toBe( "Some Tab Content" );
				});

			});

			describe( "DELETE /tablature", function(){

				it( "should delete tab record", function(){
					var user = getInstance( "User" ).create(testUser);

					var testTab = getInstance( "Tab" ).create( {
						"title": "Test 1",
						"content": "test 1",
						"userID": user.getID()
					});

					var event = delete(
						route = "api/tablature/#testTab.getID()#"
					);

					var response 	= event.getPrivateValue( "response" );

					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	getInstance( "Tab" ).find( testTab.getID() ) ).toBeNull();
				});

			});


		});

	}

}