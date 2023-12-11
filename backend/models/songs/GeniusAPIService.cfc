/**
 * Service for accessing the Genius API
 */
component singleton="true" {
	
	property name="apiAccessKey" inject="coldbox:setting:GENIUS_API_KEY";

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

}