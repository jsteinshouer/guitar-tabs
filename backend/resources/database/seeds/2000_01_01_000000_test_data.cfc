component {

    function run( qb, mockdata ) {



        qb.newQuery().from("tablature").delete();
        qb.newQuery().from("user").delete();

        qb.newQuery().table( "user" ).insert([
            "username": "nigel",
            "first_name": "Nigel",
            "last_name": "Tufnel",
            "password": "$2a$12$9eYmPms6fagzqK4M/30aGen8xMxsVgjEWck7JSCuNUETHc6xfdKnm" //turnitto11
        ]);

        var userQuery = qb.newQuery().select(["user_id"]).from("user").where("username","=","nigel").get();
        var data = deserializeJSON( fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & "tabs.json" ) )
        for ( var item in data ) {
            item.user_id = userQuery[1].user_id;
            structDelete( item, "uri" );
            qb.newQuery().table( "tablature" ).insert(item);
        }

    }

}