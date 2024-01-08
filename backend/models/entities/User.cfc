/**
* User Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="user" {

    property name="bcrypt" inject="@BCrypt" persistent="false";

	property name="id" column="user_id";
	property name="firstName" column="first_name";
	property name="lastName" column="last_name";
	property name="username" column="username";
	property name="password" column="password";

	//Use ReturningKeyType because sqlite-jdbc stopped supporting getGeneratedKeys in https://github.com/xerial/sqlite-jdbc/releases/tag/3.43.0.0
    //  which caused AutoIncrementingKeyType to not work   
    function keyType() {
        return variables._wirebox.getInstance( "ReturningKeyType@quick" );
    }

    function tablature() {
       return hasMany( "Tab" );
    }

    function lists() {
       return hasMany( "TabList" );
    }

    public User function setPassword( required string password ){
		return assignAttribute( "password", bcrypt.hashPassword( arguments.password ) );
	}

    public struct function getMemento(){
		return { 
			"id": variables.getID(), 
			"username" : variables.getUsername(),
			"firstName": variables.getFirstName(),
			"lastName": variables.getLastName()
		};
	}

}