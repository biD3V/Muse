#import "Tweak.h"

@implementation SPTPlayerQueue

- (NSArray *)previousTracks {
    NSLog(@"[Muse] %@", %orig);
    return %orig;
}

- (SPTPlayerQueue *)initWithDictionary:(NSDictionary *)dictionary {
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(grabNextUp)
                                                            name:@"com.bid3v.musespotifyapi/requestnext"
                                                          object:nil];
    // Debug stuff
//    NSLog(@"[Muse] %@", dictionary);
//    NSURL *documents = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
//                                                               inDomains:NSUserDomainMask] lastObject];
//    NSString *path = [documents.path stringByAppendingPathComponent:@"queue.plist"];
//    NSLog(@"[Muse] Path: %@", path);
//    [dictionary writeToFile:path atomically:NO];
    
    return %orig;
}

%new
- (void)grabNextUp {
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    // Get the Metadata for the next track
    [userInfo setObject:self.nextTracks[0].metadata? self.nextTracks[0].metadata : NULL forKey:@"metadata"];
    // Send Metadata
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.musespotifyapi/sendnext"
                                                                  object:nil
                                                                userInfo:userInfo];
}

@end

@implementation SPTRecentlyPlayedListImplementation

- (SPTRecentlyPlayedListImplementation *)initWithRecentlyPlayedModel:(id)arg1 maxNumberOfItems:(unsigned long long)arg2 filterPredicate:(id)arg3 {
    SPTRecentlyPlayedListImplementation *implementation = %orig;
    //NSLog(@"[Muse] Recent %@", implementation.entities);
    NSMutableArray *imageURLs = [NSMutableArray new];
    NSMutableArray *rawImageURLs = [NSMutableArray new];
    for (SPTRecentlyPlayedEntity *entity in implementation.entities) {
        [rawImageURLs addObject:entity.imageURL.absoluteString];
    }
    
    NSURL *documents = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                               inDomains:NSUserDomainMask] lastObject];
    NSString *museDir = [documents.path stringByAppendingPathComponent:@"/Muse"];
    NSString *rawPath = [documents.path stringByAppendingPathComponent:@"/Muse/recentRaw.plist"];
    NSString *path = [documents.path stringByAppendingPathComponent:@"/Muse/recent.plist"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:museDir]) [[NSFileManager defaultManager] createDirectoryAtPath:museDir withIntermediateDirectories:NO attributes:nil error:&error];
    
    [rawImageURLs writeToFile:rawPath atomically:NO];
    
    // Filter and create image urls
    for (SPTRecentlyPlayedEntity *entity in implementation.entities) {
        NSArray *components = [entity.imageURL.absoluteString componentsSeparatedByString:@":"]; // Separate URL
        if (components.count > 2) { // Check if URL is actually an identifier
            if ([components[1] isEqualToString:@"mosaic"] && components.count > 3) { // Playlist
                //NSLog(@"[Muse] Entity Image URL: https://mosaic.scdn.co/300/%@%@%@%@", components[2], components[3], components[4], components[5]);
                [imageURLs addObject:[NSString stringWithFormat:@"https://mosaic.scdn.co/300/%@%@%@%@", components[2], components[3] ? components[3] : components[2], components[4] ? components[4] : components[2], components[5] ? components[5] : components[2]]];
            } else if ([components[1] isEqualToString:@"image"] && components.count == 3) { // Single Image
                //NSLog(@"[Muse] Entity Image URL: https://i.scdn.co/image/%@", components[2]);
                [imageURLs addObject:[NSString stringWithFormat:@"https://i.scdn.co/image/%@", components[2]]];
            } else if (components[2] && [components[2] isEqualToString:@"tracksheart"]) { // Liked Songs
               NSLog(@"[Muse] Entity Image URL: https://t.scdn.co/images/3099b3803ad9496896c43f22fe9be8c4.png");
               [imageURLs addObject:@"https://t.scdn.co/images/3099b3803ad9496896c43f22fe9be8c4.png"];
            } else { // Fallback
                [imageURLs addObject:entity.imageURL.absoluteString];
            }
        } else { // Regular Link
            //NSLog(@"[Muse] Entity Image URL: %@", entity.imageURL);
            [imageURLs addObject:entity.imageURL.absoluteString];
        }
    }
    [imageURLs writeToFile:path atomically:NO]; // Log for Debug
    
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setObject:imageURLs forKey:@"imageURLs"];
    // Send URLs
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.musespotifyapi/recent"
                                                                  object:nil
                                                                userInfo:userInfo];
    return implementation;
}

@end
