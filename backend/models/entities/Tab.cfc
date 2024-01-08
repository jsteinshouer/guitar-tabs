/**
* Tablature Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="tablature" {

	property name="id" column="tablature_id";
	property name="title" column="title";
	property name="content" column="content";
	property name="tags" column="tags";
    property name="songTitle" column="song_title";
    property name="songThumbnail" column="song_thumbnail";
    property name="artist" column="song_artist";
    property name="album" column="song_album";
    property name="geniusMetadata" column="genius_metadata";
	property name="userID" column="user_id";


    //Use ReturningKeyType because sqlite-jdbc stopped supporting getGeneratedKeys in https://github.com/xerial/sqlite-jdbc/releases/tag/3.43.0.0
    //  which caused AutoIncrementingKeyType to not work   
    function keyType() {
        return variables._wirebox.getInstance( "ReturningKeyType@quick" );
    }

    function user() {
	    return belongsTo( "User" );
	}

    function lists() {
	    return belongsToMany( "TabList", "user_list_tablature", "tablature_id", "user_list_id" );
	}

	//Overide default to provide tablatureID
	function getMemento() {
        var data = $getMemento( argumentCollection = arguments );
        data["tablatureID"] = getId();
        return data;
    }

}