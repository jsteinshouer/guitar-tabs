/**
* TabList Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="user_list" {

	property name="id" column="user_list_id";
	property name="title" column="title";
	property name="userID" column="user_id";


    //Use ReturningKeyType because sqlite-jdbc stopped supporting getGeneratedKeys in https://github.com/xerial/sqlite-jdbc/releases/tag/3.43.0.0
    //  which caused AutoIncrementingKeyType to not work   
    function keyType() {
        return variables._wirebox.getInstance( "ReturningKeyType@quick" );
    }

    function user() {
	    return belongsTo( "User" );
	}

    function tabs() {
	    return belongsToMany( "Tab", "user_list_tablature", "user_list_id", "tablature_id" );
	}

}
