/**
* Tablature Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="tablature" {

	property name="id" column="tablature_id";
	property name="title" column="title";
	property name="content" column="content";
	property name="tags" column="tags";
	property name="userID" column="user_id";


    //Use ReturningKeyType because sqlite-jdbc stopped supporting getGeneratedKeys in https://github.com/xerial/sqlite-jdbc/releases/tag/3.43.0.0
    //  which caused AutoIncrementingKeyType to not work   
    function keyType() {
        return variables._wirebox.getInstance( "ReturningKeyType@quick" );
    }

    function user() {
	    return belongsTo( "User" );
	}

	//Overide default to provide tablatureID
	function getMemento() {
        return {
            "id" = getId(),
            "tablatureID" = getId(),
            "title" = getTitle(),
            "content" = getContent(),
            "userID" = getUserID(),
            "tags" = getTags()
        };
    }

}