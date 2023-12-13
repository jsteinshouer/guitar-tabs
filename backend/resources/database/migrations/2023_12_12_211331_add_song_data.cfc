component {
    
    function up( schema, qb ) {
        schema.alter( "tablature", function(table) {
			table.addColumn( table.string( "song_title" ).nullable() );
            table.addColumn( table.string( "song_artist" ).nullable() );
            table.addColumn( table.string( "song_thumbnail" ).nullable() );
            table.addColumn( table.string( "song_album" ).nullable() );
            table.addColumn( table.json( "genius_metadata" ).nullable() );
		} );
    }

    function down( schema, qb ) {
        schema.alter( "tablature", function( table ) {
            if ( schema.hascolumn("tablature","song_title") ) {
                table.dropColumn( "song_title" );
            }
            if ( schema.hascolumn("tablature","song_artist") ) {
                table.dropColumn( "song_artist" );
            }
            if ( schema.hascolumn("tablature","song_thumbnail") ) {
                table.dropColumn( "song_thumbnail" );
            }
            if ( schema.hascolumn("tablature","song_album") ) {
                table.dropColumn( "song_album" );
            }
            if ( schema.hascolumn("tablature","genius_metadata") ) {
                table.dropColumn( "genius_metadata" );
            }
        } );
    }

}
