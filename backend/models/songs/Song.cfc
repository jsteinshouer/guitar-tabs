component accessors="true" {
    
    property name="title";
    property name="thumbnail";
    property name="artist";
    property name="album";
    property name="geniusMetadata";


    function getMemento() {
        return {
            "title" = getTitle(),
            "thumbnail" = getThumbnail(),
            "album" = getAlbum(),
            "artist" = getArtist(),
            "geniusMetadata" = getGeniusMetadata()
        };
    }
}