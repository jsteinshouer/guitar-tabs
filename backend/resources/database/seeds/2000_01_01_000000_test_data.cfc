component {

    function run( qb, mockdata ) {

        //itssoeasy
        var passworHash = "$2a$12$zPKie2txytkxQrZW17/xc.3KT3hAPTvF4jj4tyIOHHkHMAghYbxyO"

        qb.newQuery().from("tablature").delete();
        qb.newQuery().from("user").delete();

        qb.newQuery().table( "user" ).insert([
            {
                "first_name": "Saul",
                "last_name": "Hudson",
                "username": "slash",
                "password": passworHash
            }
        ]);

        var userQuery = qb.newQuery().select(["user_id"]).from("user").where("username","=","slash").get();
        var data = deserializeJSON( fileRead( getDirectoryFromPath( getCurrentTemplatePath() ) & "tabs.json" ) )
        for ( var item in data ) {
            item.user_id = userQuery[1].user_id;
            structDelete( item, "uri" );
            qb.newQuery().table( "tablature" ).insert(item);
        }

    }

}