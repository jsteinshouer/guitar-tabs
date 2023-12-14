/**
 * Service for accessing the Genius API
 */
component singleton="true" {
	
	property name="apiAccessKey" inject="coldbox:setting:GENIUS_API_KEY";
	property name="wirebox" inject="wirebox";

	/**
	 * Search the Genius API for a song
	 * 
	 * @searchQuery Search query i.e. Name of the song
	 */
	public struct function search( required string searchQuery ) {
		httpRequest = new http(
			url = "https://api.genius.com/search?q=#encodeForURL( arguments.searchQuery )#",
			method = "GET"
		);
		httpRequest.addParam(name="Authorization", type="header", value="Bearer #apiAccessKey#");
		return deserializeJSON(httpRequest.send().getPrefix().fileContent);
	}

	/**
	 * Search the Genius API for a song
	 * 
	 * @searchQuery Search query i.e. Name of the song
	 */
	public Song function getSong( required numeric geniusSongID ) {

		httpRequest = new http(
			url = "https://api.genius.com/songs/#encodeForURL( arguments.geniusSongID )#",
			method = "GET"
		);
		httpRequest.addParam(name="Authorization", type="header", value="Bearer #apiAccessKey#");
		var response =  deserializeJSON(httpRequest.send().getPrefix().fileContent).response;
		var song = wirebox.getInstance("songs.Song");

		song.setTitle(response.song.title);
		song.setThumbnail(response.song?.song_art_image_thumbnail_url);
		song.setArtist(response.song?.primary_artist?.name)
		song.setAlbum(response.song?.album?.name);
		song.setGeniusMetadata({
			"id": response?.song?.id,
			"title": response?.song?.title,
			"api_path": response?.song?.api_path,
			"path": response?.song?.path,
			"release_date_for_display": response?.song?.release_date_for_display,
			"song_art_image_thumbnail_url": response?.song?.song_art_image_thumbnail_url,
			"song_art_image_url": response?.song?.song_art_image_url,
			"url": response?.song?.url,
			"album_api_path": response?.song?.album?.api_path,
			"album_id": response?.song?.album?.id,
			"album_name":response?.song?.album?.name,
			"album_release_date": response?.song?.album?.release_date_for_display,
			"cover_art_url": response?.song?.album?.cover_art_url,
			"artist_id": response?.song?.primary_artist?.id,
			"artist_api_path": response?.song?.primary_artist?.api_path,
			"artist_image_url": response?.song?.primary_artist?.image_url
		})

		return song;
	}

}