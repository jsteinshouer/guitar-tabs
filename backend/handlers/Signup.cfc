/**
 * My RESTFul Event Handler
 */
component extends="BaseHandler" {

	property name="passwordService" inject="security.PasswordService";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	/**
	 * Signup a new user
	 *
	 * @x-route (POST) /api/signup
	 */
	function index( event, rc, prc ) {

		var passwordValidationResult = passwordService.validatePassword( rc.password );
		if ( passwordValidationResult.hasErrors() ) {
				prc.response.setStatusCode( 400 );
				prc.response.setError( true );
				prc.response.setMessages( passwordValidationResult.getErrors() );
		} 
		else if ( !isNull( getInstance( "User" ).firstWhere( "username", rc.username ) ) ) {
				prc.response.setStatusCode( 400 );
				prc.response.setError( true );
				prc.response.addMessage( "An account already exists for #rc.username#." );
		}
		else {
			var user = getInstance( "User" ).create( {
				"username": rc.username,
				"password": rc.password,
				"firstName": rc.firstName,
				"lastName": rc.lastName
			});

			prc.response.setData( user.getMemento() );
			prc.response.setStatusCode( 201 );

		}
	}

}
