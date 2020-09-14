//
//  SPTPlayerTrack.h
//  Muse
//
//  Created by Sawyer Jester on 8/21/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

#import <UIKit/UIKit.h>

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

- (id)initWithDictionary:(id)arg1;

@property(readonly, nonatomic, getter=isFullScreenAdvertisement) _Bool fullScreenAdvertisement;
@property(readonly, nonatomic, getter=isSASInterruption) _Bool sasInterruption;
@property(readonly, nonatomic, getter=isInterruption) _Bool interruption;
@property(readonly, nonatomic) NSString *adId;
@property(readonly, nonatomic) NSString *advertiserTitle;
@property(readonly, nonatomic) NSString *advertiser;
@property(readonly, nonatomic, getter=isSkippableAdvertisement) _Bool skippableAdvertisement;
@property(readonly, nonatomic, getter=isPodcastAdvertisement) _Bool podcastAdvertisement;
@property(readonly, nonatomic, getter=isAdvertisement) _Bool advertisement;
@property(readonly, nonatomic) _Bool hasCanvas;
@property(readonly, nonatomic, getter=isAdvertisementOrInterruption) _Bool advertisementOrInterruption;
- (id)getContributingArtistNameAtIndex:(unsigned long long)arg1 fromTrackMetadata:(id)arg2;
- (id)getMainArtistNameFromTrackMetadata:(id)arg1;
- (id)getArtistsFromTrackMetadata:(id)arg1;
@property(readonly, nonatomic, getter=isBanned) _Bool banned;
@property(readonly, nonatomic) NSURL *contextSource;
- (_Bool)wasInjected:(id)arg1;
@property(readonly, nonatomic) NSString *subtitle;
@property(readonly, nonatomic) NSNumber *albumDiscNumber;
@property(readonly, nonatomic) NSNumber *albumDiscCount;
@property(readonly, nonatomic) NSNumber *albumTrackNumber;
@property(readonly, nonatomic) NSNumber *albumTrackCount;
@property(readonly, nonatomic) _Bool hasPlayerVideoLayer;
@property(readonly, nonatomic) _Bool isShow;
@property(readonly, nonatomic) NSString *showTitle;
@property(readonly, nonatomic) _Bool isBackgroundable;
@property(readonly, nonatomic) _Bool isPodcast;
@property(readonly, nonatomic) _Bool isLiveVideo;
@property(readonly, nonatomic) _Bool isVideo;
@property(readonly, nonatomic) NSString *artistsString;
@property(readonly, nonatomic) NSString *artistTitle;
@property(readonly, nonatomic) NSURL *showURL;
@property(readonly, nonatomic) NSURL *trackClickURL;
@property(readonly, nonatomic) NSURL *nowPlayingBarCoverArtURL;
@property(readonly, nonatomic) NSURL *coverArtURLXLarge;
@property(readonly, nonatomic) NSURL *coverArtURLLarge;
@property(readonly, nonatomic) NSURL *coverArtURLSmall;
@property(readonly, nonatomic) NSURL *coverArtURL;
@property(readonly, nonatomic) _Bool wasManuallyQueued;
@property(readonly, nonatomic, getter=isMusicInjectionEpisode) _Bool isMusicInjectionEpisode;
@property(readonly, nonatomic) _Bool isAgeRestricted;
@property(readonly, nonatomic) _Bool isRatedExplicit;
@property(readonly, nonatomic, getter=spt_isMetaTrack) _Bool spt_metaTrack;
@property(readonly, nonatomic, getter=spt_isHidden) _Bool spt_hidden;
@property(readonly, nonatomic, getter=spt_isDelimiter) _Bool spt_delimiter;
@property(readonly, nonatomic) struct ContextTrack cpp;
@property(nonatomic) double fadeOverlap;
@property(nonatomic) unsigned long long fadeOutDuration;
@property(nonatomic) unsigned long long fadeOutStartTime;
@property(nonatomic) unsigned long long fadeInDuration;
@property(nonatomic) unsigned long long fadeInStartTime;
@property(readonly, nonatomic) NSURL *imageURL;
@property(readonly, nonatomic) NSURL *artistURI;
- (id)artistName;
@property(readonly, nonatomic) NSURL *albumURI;
- (id)albumTitle;
- (id)trackTitle;

@end
