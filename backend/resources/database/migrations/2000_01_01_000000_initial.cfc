component {
    
    function up( schema, query ) {

        schema.dropIfExists( "tablature" );
        schema.dropIfExists( "user" );
        schema.create( "user", function(table) {
			table.increments( "user_id" );
			table.string( "first_name",50 );
			table.string( "last_name",50 );
			table.string( "username",50 );
			table.string( "password",150 );
		} );
        schema.create( "tablature", function(table) {
			table.increments( "tablature_id" );
			table.string( "title" );
			table.text( "content" );
            table.json( "tags" ).nullable();
            table.integer("user_id")
            table.foreignKey( "user_id" ).references( "user_id" ).onTable( "user" );
		} );
    }

    function down( schema, query ) {

        schema.dropIfExists( "tablature" );
        schema.dropIfExists( "user" );

    }

}
