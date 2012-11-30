//
//  FlickrFetcher.m
//
//  Created for Stanford CS193p Fall 2011.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "FlickrFetcher.h"
#import "FlickrAPIKey.h"

#define FLICKR_PLACE_ID @"place_id"

@implementation FlickrFetcher

+ (NSDictionary *)executeFlickrFetch:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FlickrAPIKey];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    // NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return results;
}

+ (NSArray *)topPlaces
{
    NSString *request = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"places.place"];
}

+ (NSArray *)stanfordPhotos
{
    NSString *request = @"http://api.flickr.com/services/rest/?user_id=48247111@N07&format=json&nojsoncallback=1&extras=original_format,tags,description,geo,date_upload,owner_name&page=1&method=flickr.photos.search";
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

+ (NSArray *)photosInPlace:(NSDictionary *)place maxResults:(int)maxResults
{
    NSArray *photos = nil;
    NSString *placeId = place[FLICKR_PLACE_ID];
    if (placeId) {
        NSString *request = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=%@&per_page=%d&extras=original_format,tags,description,geo,date_upload,owner_name,place_url", placeId, maxResults];
        NSString *placeName = place[FLICKR_PLACE_NAME];
        photos = [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
        for (NSMutableDictionary *photo in photos) {
            photo[FLICKR_PHOTO_PLACE_NAME] = placeName;
        }
    }
    return photos;
}

+ (NSArray *)recentGeoreferencedPhotos
{
    NSString *request = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&per_page=500&license=1,2,4,7&has_geo=1&extras=original_format,tags,description,geo,date_upload,owner_name,place_url"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

+ (NSString *)urlStringForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
	id farm = photo[@"farm"];
	id server = photo[@"server"];
	id photo_id = photo[@"id"];
	id secret = photo[@"secret"];
	if (format == FlickrPhotoFormatOriginal) secret = photo[@"originalsecret"];
    
	NSString *fileType = @"jpg";
	if (format == FlickrPhotoFormatOriginal) fileType = photo[@"originalformat"];
	
	if (!farm || !server || !photo_id || !secret) return nil;
	
	NSString *formatString = @"s";
	switch (format) {
		case FlickrPhotoFormatSquare:    formatString = @"s"; break;
		case FlickrPhotoFormatLarge:     formatString = @"b"; break;
		// case FlickrPhotoFormatThumbnail: formatString = @"t"; break;
		// case FlickrPhotoFormatSmall:     formatString = @"m"; break;
		// case FlickrPhotoFormatMedium500: formatString = @"-"; break;
		// case FlickrPhotoFormatMedium640: formatString = @"z"; break;
		case FlickrPhotoFormatOriginal:  formatString = @"o"; break;
	}
    
	return [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
}

+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
    return [NSURL URLWithString:[self urlStringForPhoto:photo format:format]];
}

@end
