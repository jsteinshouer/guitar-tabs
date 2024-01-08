component {
    
    function up( schema, qb ) {
        schema.dropIfExists( "user_list_tablature" );
        schema.dropIfExists( "user_list" );
        schema.create( "user_list", function(table) {
			table.increments( "user_list_id" );
			table.string( "title",50 );
            table.integer("user_id")
            table.foreignKey( "user_id" ).references( "user_id" ).onTable( "user" );
		} );
        schema.create( "user_list_tablature", function(table) {
			table.increments( "user_list_tablature_id" );
            table.integer("user_list_id")
            table.foreignKey( "user_list_id" ).references( "user_list_id" ).onTable( "user_list" );
            table.integer("tablature_id")
            table.foreignKey( "tablature_id" ).references( "tablature_id" ).onTable( "tablature" );
		} );
    }

    function down( schema, qb ) {
        schema.dropIfExists( "user_list_tablature" );
        schema.dropIfExists( "user_list" );
    }

}
