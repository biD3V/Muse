#import "MUSViewController.h"

@implementation MUSViewController

@synthesize labelView;

- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self setCornerRadius:20];
    
    if (!self.twoRowHeight) {
        self.twoRowHeight = 163.0;
    }
    
    FBApplicationInfo *appInfo = [LSApplicationProxy applicationProxyForIdentifier: @"com.spotify.client"];
    spotifyBundle = [NSBundle bundleWithURL:appInfo.bundleURL];

    [self addContentView];
    [self addPlayerContainer];
    [self addPause];
    [self addTestLabel];
    [self addIconView];
    [self addAlbumView];
    [self addLabelView];
    [self addUpNextView];
    [self addWaveCenteringView];
    [self addAppLabel];
    
    NSFileManager *fileManager = [NSFileManager new];
    
    if ([fileManager fileExistsAtPath:@"/var/mobile/Documents/SpotifyRecentlyPlayed.plist"]) {
        if (!recentArray) {
            recentArray = [[NSArray alloc] initWithContentsOfFile:@"/var/mobile/Documents/SpotifyRecentlyPlayed.plist"];
        }
        [self addRecentViewForArray:recentArray];
    }
    
    NSDictionary *missingnest = [NSDictionary dictionaryWithObjects:@[@"No Songs",@"In Queue"] forKeys:@[@"title",@"artist_name"]];
    NSDictionary *missingno = [NSDictionary dictionaryWithObject:missingnest forKey:@"metadata"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMedia) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.bid3v.musespotifyapi/sendnext"
                                                                 object:nil
                                                                  queue:[NSOperationQueue mainQueue]
                                                             usingBlock:^(NSNotification *notification) {
        [self updateNextUpWithDictionary:notification.userInfo ? notification.userInfo : missingno];
//        [(NSDictionary *)[notification.userInfo objectForKey:@"next_tracks"] writeToFile:@"/var/mobile/Documents/SpotifyQueue.plist" atomically:NO];
    }];
    [[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.bid3v.musespotifyapi/recent"
                                                                 object:nil
                                                                  queue:[NSOperationQueue mainQueue]
                                                             usingBlock:^(NSNotification *notification) {
        recentArray = [notification.userInfo objectForKey:@"imageURLs"];
        [recentArray writeToFile:@"/var/mobile/Documents/SpotifyRecentlyPlayed.plist" atomically:NO];
        [self addRecentViewForArray:recentArray];
    }];
}

- (void)addContentView {
    contentView = [UIView new];
    [contentView setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
    [contentView.layer setCornerRadius:20];
    [contentView.layer setCornerCurve:kCACornerCurveContinuous];
    [contentView setClipsToBounds:true];
    
    [contentView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:contentView];
    
    [contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    //[contentView.centerXAnchor constraintEqualToAncor:self.view.centerXAnchor].active = true;
    [contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    //[contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
    UIView *editingView = (UIView *)[self valueForKey:@"_editingView"];
    [editingView setTranslatesAutoresizingMaskIntoConstraints:false];
    [editingView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor].active = true;
    [editingView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor].active = true;
    [editingView.topAnchor constraintEqualToAnchor:contentView.topAnchor].active = true;
    [editingView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor].active = true;
}

- (void)addPlayerContainer {
    playerContainer = [UIView new];
    
    [playerContainer setTranslatesAutoresizingMaskIntoConstraints:false];
    [contentView addSubview:playerContainer];
    [playerContainer.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor].active = true;
    [playerContainer.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor].active = true;
    [playerContainer.topAnchor constraintEqualToAnchor:contentView.topAnchor].active = true;
    playerContainterBottom = [playerContainer.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor];
    playerContainerHeight = [playerContainer.heightAnchor constraintEqualToConstant:self.twoRowHeight];
}

- (void)addPause {
    pause = [UIButton buttonWithType:UIButtonTypeSystem];
    [pause setImage:[UIImage systemImageNamed:@"playe.circle.fill"] forState:UIControlStateNormal];
    pause.tintColor = [UIColor labelColor];
    
    [pause addTarget:self
              action:@selector(pausePlayMusic)
    forControlEvents:UIControlEventTouchUpInside];
    
    [pause setTranslatesAutoresizingMaskIntoConstraints:false];
    [playerContainer addSubview:pause];
    
    pauseLeading = [pause.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor constant:16];
    pauseTrailing = [pause.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor constant:-16];
    pauseTop = [pause.topAnchor constraintEqualToAnchor:playerContainer.topAnchor constant:16];
    pauseBottom = [pause.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor constant:-16];
    [pause.widthAnchor constraintEqualToConstant:25].active = true;
    [pause.heightAnchor constraintEqualToConstant:25].active = true;
}

- (void)pauseExpandContraints {
    labelViewShrunk.active = false;
    labelViewExpanded.active = true;
    pauseLeading.active = false;
    pauseTrailing.active = true;
    pauseTop.active = false;
    pauseBottom.active = true;
}

- (void)pauseShrinkConstraints {
    labelViewExpanded.active = false;
    labelViewShrunk.active = true;
    pauseTrailing.active = false;
    pauseLeading.active = true;
    pauseBottom.active = false;
    pauseTop.active = true;
}

- (void)addWaveCenteringView {
    centeringView = [UIView new];

    [centeringView setTranslatesAutoresizingMaskIntoConstraints:false];

    [playerContainer addSubview:centeringView];

    centeringViewTop = [centeringView.topAnchor constraintEqualToAnchor:iconView.bottomAnchor];
    centeringViewBottom = [centeringView.bottomAnchor constraintEqualToAnchor:labelView.topAnchor];
}

- (void)addWaveformView {
    config = [WKWebViewConfiguration new];
    
    CGFloat codeWidth = (((playerContainer.frame.size.width - 16.0) * 10.0) / 8.0);
    
    source = [NSString stringWithFormat:@"var svg = document.getElementsByTagName('svg')[0];\n"
                        "svg.setAttribute(\"viewBox\", \"80 0 400 100\");\n"
              "svg.setAttribute(\"width\", \"%fpt\");\n"
              "svg.setAttribute(\"height\", \"%fpt\");\n"
              "var background = document.getElementsByTagName('rect')[0];\n"
              "background.setAttribute(\"fill\", \"#00000000\");", (codeWidth * 3.0), ((codeWidth * 3.0) / 4)];
    script = [[WKUserScript alloc] initWithSource:source injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true];
    
    contentController = [WKUserContentController new];
    [contentController addUserScript:script];
    
    [config setUserContentController:contentController];
    
    [svgView removeFromSuperview];
    svgView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    [svgView setUIDelegate:self];
    [svgView setNavigationDelegate:self];
    
    if (self.widgetFrame.size.numCols == 2) {
        [svgView setAlpha:1];
    } else {
        [svgView setAlpha:0];
    }
    
    [svgView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [playerContainer addSubview:svgView];
    
    [svgView.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor
                                          constant:8].active = true;
    [svgView.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor
                                           constant:-8].active = true;
    [svgView.centerYAnchor constraintEqualToAnchor:centeringView.centerYAnchor].active = true;
    [svgView.heightAnchor constraintEqualToConstant:(codeWidth / 4)].active = true;
    
    NSString *svgURLString = [NSString stringWithFormat:@"https://scannables.scdn.co/uri/plain/svg/000000/white/640/%@", trackUrlString];
    
    NSURL *url = [NSURL URLWithString:svgURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [svgView loadRequest:request];
    
    [svgView setOpaque:false];
    [svgView.scrollView setScrollEnabled:false];
    [svgView.scrollView setContentInset:UIEdgeInsetsZero];
}

- (void)addTestLabel {
    testLabel = [UILabel new];
    //[testLabel setText:[[NSBundle mainBundle] bundlePath]];
    
    [testLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [playerContainer addSubview:testLabel];
    
    [testLabel.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor constant:16].active = true;
    [testLabel.topAnchor constraintEqualToAnchor:pause.bottomAnchor constant:4].active = true;
}

- (void)addIconView {
    iconView = [UIImageView new];
    UIImage *logo = [UIImage imageNamed:@"Default" inBundle:spotifyBundle compatibleWithTraitCollection:nil];
    iconView.image = [logo resizeImageToWidth:25.0];
    
    [iconView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [playerContainer addSubview:iconView];
    
    [iconView.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor constant:-16].active = true;
    [iconView.topAnchor constraintEqualToAnchor:playerContainer.topAnchor constant:16].active = true;
    [iconView.widthAnchor constraintEqualToConstant:25].active = true;
    [iconView.heightAnchor constraintEqualToConstant:25].active = true;
}

- (void)addAlbumView {
    albumView = [UIView new];
    [albumView setBackgroundColor:[UIColor systemFillColor]];
    [albumView setClipsToBounds:true];
    [albumView.layer setCornerRadius:10];
    [albumView.layer setCornerCurve:kCACornerCurveContinuous];
    
    albumImageView = [UIImageView new];
    
    [albumView setTranslatesAutoresizingMaskIntoConstraints:false];
    [albumImageView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [albumView addSubview:albumImageView];
    [playerContainer addSubview:albumView];
    
    [albumImageView.trailingAnchor constraintEqualToAnchor:albumView.trailingAnchor].active = true;
    [albumImageView.heightAnchor constraintEqualToAnchor:albumView.heightAnchor].active = true;
    [albumImageView.widthAnchor constraintEqualToAnchor:albumImageView.heightAnchor].active = true;
    [albumImageView.centerYAnchor constraintEqualToAnchor:albumView.centerYAnchor].active = true;
    
    [albumView.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor constant:10].active = true;
    [albumView.topAnchor constraintEqualToAnchor:playerContainer.topAnchor constant:10].active = true;
    [albumView.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor constant:-10].active = true;
    albumExpanded = [albumView.widthAnchor constraintEqualToAnchor:albumView.heightAnchor];
    albumShrunk = [albumView.widthAnchor constraintEqualToConstant:0];
}

//- (void)updateProgressView {
//
//}

- (void)addLabelView {
    labelView = [MUILabelView new];
    [labelView.titleLabel setTextColor:[UIColor systemGreenColor]];
    //[labelView.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightBold]];
    [labelView.titleLabel setText:@"Spotify"];
    [labelView.artistLabel setText:[[UIDevice currentDevice] name]];
    //[labelView.artistLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold]];
    
    [playerContainer addSubview:labelView];
    
    labelLeadingShrunk = [labelView.leadingAnchor constraintEqualToAnchor:albumView.trailingAnchor constant:6];
    labelLeadingExpanded = [labelView.leadingAnchor constraintEqualToAnchor:albumView.trailingAnchor constant:10];
    labelViewShrunk = [labelView.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor
                                             constant:-16];
    labelViewExpanded = [labelView.trailingAnchor constraintEqualToAnchor:iconView.leadingAnchor
                                                                 constant:-8];
    labelViewBottom = [labelView.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor
                                                             constant:-16];
    labelViewTop = [labelView.topAnchor constraintEqualToAnchor:playerContainer.topAnchor
                                                       constant:16];
}

- (void)addUpNextView {
    nextUpLabel = [UILabel new];
    [nextUpLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightSemibold]];
    [nextUpLabel setTextColor:[UIColor systemGreenColor]];
    [nextUpLabel setText:@"Next Up"];
    
    nextSong = [UILabel new];
    [nextSong setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    
    nextArtist = [UILabel new];
    [nextArtist setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    
    nextUpView = [UIView new];
    
    [nextUpLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [nextSong setTranslatesAutoresizingMaskIntoConstraints:false];
    [nextArtist setTranslatesAutoresizingMaskIntoConstraints:false];
    [nextUpView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [nextUpView addSubview:nextUpLabel];
    [nextUpView addSubview:nextSong];
    [nextUpView addSubview:nextArtist];
    [playerContainer addSubview:nextUpView];
    
    [nextUpLabel.leadingAnchor constraintEqualToAnchor:nextUpView.leadingAnchor].active = true;
    [nextUpLabel.trailingAnchor constraintEqualToAnchor:nextUpView.trailingAnchor].active = true;
    [nextUpLabel.topAnchor constraintEqualToAnchor:nextUpView.topAnchor].active = true;
    
    [nextSong.leadingAnchor constraintEqualToAnchor:nextUpView.leadingAnchor].active = true;
    [nextSong.trailingAnchor constraintEqualToAnchor:nextUpView.trailingAnchor].active = true;
    [nextSong.topAnchor constraintEqualToAnchor:nextUpLabel.lastBaselineAnchor constant:4].active = true;
    
    [nextArtist.leadingAnchor constraintEqualToAnchor:nextUpView.leadingAnchor].active = true;
    [nextArtist.trailingAnchor constraintEqualToAnchor:nextUpView.trailingAnchor].active = true;
    [nextArtist.topAnchor constraintEqualToAnchor:nextSong.lastBaselineAnchor constant:4].active = true;
    [nextArtist.bottomAnchor constraintEqualToAnchor:nextUpView.bottomAnchor].active = true;
    
    [nextUpView.leadingAnchor constraintEqualToAnchor:albumView.trailingAnchor constant:8].active = true;
    [nextUpView.trailingAnchor constraintEqualToAnchor:pause.leadingAnchor constant:-8].active = true;
    [nextUpView.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor constant:-16].active = true;
}

- (void)updateNextUpWithDictionary:(NSDictionary *)dictionary {
    [nextSong setText:[[dictionary objectForKey:@"metadata"] objectForKey:@"title"]];
    [nextArtist setText:[[dictionary objectForKey:@"metadata"] objectForKey:@"artist_name"]];
}

- (void)addAppLabel {
    appLabel = [UILabel new];
    [appLabel setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]];
    [appLabel setTextColor:[UIColor whiteColor]];
    [appLabel setText:@"Spotify"];
    
    [appLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:appLabel];
    
    [appLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [appLabel.centerYAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                           constant:-2].active = true;
    [appLabel.heightAnchor constraintEqualToConstant:12].active = true;
    [contentView.bottomAnchor constraintEqualToAnchor:appLabel.topAnchor
                                             constant:-5].active = true;
}

- (void)addRecentViewForArray:(NSArray *)array {
    if (recentView) {
        [recentView removeFromSuperview];
    }
    recentVC = [[MUSRecentViewController alloc] initWithCellWidth:((contentView.frame.size.width - 80.0) / 4.0) dataArray:array];
    [self addChildViewController:recentVC];
    recentView = recentVC.view;
    [contentView addSubview:recentView];
    
    [recentView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor].active = true;
    [recentView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor].active = true;
    [recentView.topAnchor constraintEqualToAnchor:playerContainer.bottomAnchor].active = true;
    [recentView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor].active = true;
    
    if ([widgetOptions[@"ProgressView"] boolValue]) {
        [recentVC addProgressView];
    }
}

- (void)updateMedia {
    [self spotifyPlaying];
    BOOL currentlyPlaying = [appName isEqualToString:@"Spotify"];
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        [labelView.artistLabel setText:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]) ? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] : [[UIDevice currentDevice] name]];
        [labelView.titleLabel setText:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]) ? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] : @"Spotify"];
        //[labelView.albumLabel setText:([(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] && self.widgetFrame.size.numCols > 2) ? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] : nil];
        albumImageView.image = [UIImage imageWithData:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) ? [(__bridge NSDictionary *)result objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData] : nil];
        trackUrlString = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoExternalContentIdentifier];
        [self addWaveformView];
        if (currentlyPlaying) {
            [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bid3v.musespotifyapi/requestnext"
                                                                          object:nil
                                                                        userInfo:nil];
        }
        //[(__bridge NSDictionary *)result writeToFile:@"/var/mobile/Documents/song.plist" atomically:NO];
    });
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlaying) {
        if (isPlaying && currentlyPlaying) {
            [pause setImage:[UIImage systemImageNamed:@"pause.circle.fill"] forState:UIControlStateNormal];
        } else {
            [pause setImage:[UIImage systemImageNamed:@"play.circle.fill"] forState:UIControlStateNormal];
        }
    });
//    if (currentlyPlaying) {
//        progressTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
//                                                        repeats:true
//                                                          block:^(NSTimer *timer) {
//            MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
//                float elapsed = [[(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] floatValue];
//                float duration = [[(__bridge NSDictionary *)result objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoDuration] floatValue];
//                [recentVC.progressView setProgress:(elapsed / duration)];
//            });
//        }];
//    } else {
//        if (progressTimer) {
//            [progressTimer invalidate];
//            progressTimer = nil;
//        }
//    }
}

- (void)pausePlayMusic {
    MRMediaRemoteSendCommand(MRMediaRemoteCommandTogglePlayPause, 0);
}

- (void)spotifyPlaying {
    MRMediaRemoteGetNowPlayingApplicationPID(dispatch_get_main_queue(), ^(int PID) {
        @try {
            SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithPid:PID];
            appName = [app displayName] ? [app displayName] : @"Music";
        } @catch (NSException * e) {
            
        }
    });
}

+ (HSWidgetSize)minimumSize {
	return HSWidgetSizeMake(2, 2); // least amount of rows and cols the widget needs
}

- (BOOL)isAccessoryTypeEnabled:(AccessoryType)accessoryType {
    if (accessoryType == AccessoryTypeExpand) {
        HSWidgetSize finalHorizontalExpandedSize = HSWidgetSizeAdd(self.widgetFrame.size, 0, 2);
        HSWidgetSize finalVerticalExpandedSize = HSWidgetSizeAdd(self.widgetFrame.size, 2, 0);
        return [self containsSpaceToExpandOrShrinkToWidgetSize:finalHorizontalExpandedSize] || [self containsSpaceToExpandOrShrinkToWidgetSize:finalVerticalExpandedSize];
    } else if (accessoryType == AccessoryTypeShrink) {
        return self.widgetFrame.size.numCols > 2;
    }

    // anything else we don't support but let super class handle it incase new accessory types are added
    return [super isAccessoryTypeEnabled:accessoryType];
}

-(void)accessoryTypeTapped:(AccessoryType)accessoryType {
    if (accessoryType == AccessoryTypeExpand) {
        if (self.widgetFrame.size.numCols == 2) {
            HSWidgetSize finalExpandSize = HSWidgetSizeAdd(self.widgetFrame.size, 0, 2);
            [self updateForExpandOrShrinkToWidgetSize:finalExpandSize];
        } else {
            self.twoRowHeight = contentView.frame.size.height;
            HSWidgetSize finalExpandSize = HSWidgetSizeAdd(self.widgetFrame.size, 2, 0);
            [self updateForExpandOrShrinkToWidgetSize:finalExpandSize];
        }

        // handle any state changes for expanding to new size
    } else if (accessoryType == AccessoryTypeShrink) {
        if (self.widgetFrame.size.numRows == 4) {
            HSWidgetSize finalShrinkSize = HSWidgetSizeAdd(self.widgetFrame.size, -2, 0);
            [self updateForExpandOrShrinkToWidgetSize:finalShrinkSize];
        } else {
            HSWidgetSize finalShrinkSize = HSWidgetSizeAdd(self.widgetFrame.size, 0, -2);
            [self updateForExpandOrShrinkToWidgetSize:finalShrinkSize];
        }

        // handle any state changes for shrinking to new size
    }
}

-(void)setRequestedSize:(CGSize)size {
    [super setRequestedSize:size];

    if (self.widgetFrame.size.numCols > 2) {
        [svgView setAlpha:0];
        [nextUpView setAlpha:1];
        albumShrunk.active = false;
        labelLeadingShrunk.active = false;
        labelViewBottom.active = false;
        centeringViewTop.active = false;
        centeringViewBottom.active = false;
        albumExpanded.active = true;
        labelLeadingExpanded.active = true;
        labelViewTop.active = true;
        [self pauseExpandContraints];
    } else {
        [svgView setAlpha:1];
        [nextUpView setAlpha:0];
        albumExpanded.active = false;
        labelLeadingExpanded.active = false;
        labelViewTop.active = false;
        centeringViewTop.active = true;
        centeringViewBottom.active = true;
        albumShrunk.active = true;
        labelLeadingShrunk.active = true;
        labelViewBottom.active = true;
        [self pauseShrinkConstraints];
    }
    if (self.widgetFrame.size.numRows > 2) {
        [recentView setAlpha:1];
        playerContainterBottom.active = false;
        playerContainerHeight.active = true;
    } else {
        [recentView setAlpha:0];
        playerContainerHeight.active = false;
        playerContainterBottom.active = true;
    }
    
    [recentVC.collectionView.collectionViewLayout invalidateLayout];
    [recentVC updateCellSize:((contentView.frame.size.width - 80.0) / 4.0)];
    [recentVC.labelContainer.heightAnchor constraintEqualToConstant:(recentView.frame.size.height - ((recentVC.cellSize * 2) + 48.0))].active = true;
}

-(void)setWidgetOptionValue:(id<NSCoding>)object forKey:(NSString *)key {
    [super setWidgetOptionValue:object forKey:key];

    if ([key isEqualToString:@"ProgressView"]) {
        if ([widgetOptions[key] boolValue]) {
            [recentVC addProgressView];
        } else {
            [recentVC.progressView removeFromSuperview];
        }
    }
}

@end
