//
//  Tweak.h
//  Muse
//
//  Created by Sawyer Jester on 8/21/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSDistributedNotificationCenter.h>

@interface SPTPlayerTrack : NSObject {
    NSURL *_URI;
    NSString *_UID;
    NSString *_provider;
    NSDictionary *_metadata;
}

@property(copy, nonatomic) NSDictionary *metadata; // @synthesize metadata=_metadata;
@property(copy, nonatomic) NSString *provider; // @synthesize provider=_provider;
@property(copy, nonatomic) NSString *UID; // @synthesize UID=_UID;
@property(copy, nonatomic) NSURL *URI; // @synthesize URI=_URI;

@end

@interface SPTPlayerQueue : NSObject {
    SPTPlayerTrack *_track;
    NSArray *_prevTracks;
    NSArray *_nextTracks;
    NSString *_revision;
}

@property(copy, nonatomic) NSString *revision; // @synthesize revision=_revision;
@property(copy, nonatomic) NSArray<SPTPlayerTrack *> *nextTracks; // @synthesize nextTracks=_nextTracks;
@property(copy, nonatomic) NSArray *prevTracks; // @synthesize prevTracks=_prevTracks;
@property(copy, nonatomic) SPTPlayerTrack *track; // @synthesize track=_track;

- (SPTPlayerQueue *)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)serializedDictionary;
- (void)grabNextUp;
@end

@interface HUBComponentModelBuilderImplementation : NSObject {
    NSString *_modelIdentifier;
    NSString *_title;
    NSMutableDictionary *_childBuilders;
    NSMutableArray *_childIdentifierOrder;
}

@property(readonly, nonatomic) NSMutableArray *childIdentifierOrder; // @synthesize childIdentifierOrder=_childIdentifierOrder;
@property(readonly, nonatomic) NSMutableDictionary *childBuilders; // @synthesize childBuilders=_childBuilders;
@property(copy, nonatomic) NSString *title;
@property(readonly, copy, nonatomic) NSString *modelIdentifier; // @synthesize modelIdentifier=_modelIdentifier;

@property(retain, nonatomic) UIImage *mainImage;
@property(copy, nonatomic) NSURL *mainImageURL;

@end

@interface HUBViewModelBuilderImplementation : NSObject {
    NSMutableDictionary *_bodyComponentModelBuilders;
    NSMutableArray *_bodyComponentIdentifierOrder;
}

@property(readonly, nonatomic) NSMutableArray *bodyComponentIdentifierOrder; // @synthesize bodyComponentIdentifierOrder=_bodyComponentIdentifierOrder;
@property(readonly, nonatomic) NSMutableDictionary *bodyComponentModelBuilders; // @synthesize bodyComponentModelBuilders=_bodyComponentModelBuilders;

- (HUBComponentModelBuilderImplementation *)getOrCreateBuilderForBodyComponentModelWithIdentifier:(NSString *)identifier;

@end

@interface HUBContentOperationLoader : NSObject {
    HUBViewModelBuilderImplementation *_currentBuilder;
}

@property(retain, nonatomic) HUBViewModelBuilderImplementation *currentBuilder; // @synthesize currentBuilder=_currentBuilder;

@end

@interface SPTHomeContentOperationLoader : HUBContentOperationLoader

- (SPTHomeContentOperationLoader *)initWithContentOperations:(id)arg1 componentDefaults:(id)arg2 iconImageResolver:(id)arg3 viewLoggerFactory:(id)arg4 source:(unsigned long long)arg5;

@end

@interface SPTRecentlyPlayedListImplementation : NSObject {
    NSMutableArray *_entities;
    NSMutableArray *_allEntities;
}

@property(retain, nonatomic) NSMutableArray *allEntities; // @synthesize allEntities=_allEntities;
@property(retain, nonatomic) NSMutableArray *entities; // @synthesize entities=_entities;

- (SPTRecentlyPlayedListImplementation *)initWithRecentlyPlayedModel:(id)arg1 maxNumberOfItems:(unsigned long long)arg2 filterPredicate:(id)arg3;

@end

@interface SPTRecentlyPlayedEntity : NSObject {
    NSString *_title;
    NSString *_subtitle;
    NSURL *_imageURL;
}

@property(copy, nonatomic) NSURL *imageURL; // @synthesize imageURL=_imageURL;
@property(copy, nonatomic) NSString *subtitle; // @synthesize subtitle=_subtitle;
@property(copy, nonatomic) NSString *title; // @synthesize title=_title;

@end
