#import "MUMViewController.h"

@implementation MUMViewController

@synthesize labelView;

-(void)viewDidLoad {
	[super viewDidLoad];
    
    [self setCornerRadius:20];

    FBApplicationInfo *appInfo = [LSApplicationProxy applicationProxyForIdentifier:@"com.apple.Music"];
    musicBundle = [NSBundle bundleWithURL:appInfo.bundleURL];
    
    self.compactHeight = 30.0;
    
    [self addContentView];
    [self addPlayerContainer];
    [self addIconView];
    [self addLabelView];
    //[self addAlbumView];
    [self addRecentView];
    [self addAppLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMedia)
                                                 name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification
                                               object:nil];
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
    playerContainerBottom = [playerContainer.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor];
    playerContainerCompactHeight = [playerContainer.heightAnchor constraintEqualToConstant:70];
}

- (void)addIconView {
    iconView = [UIImageView new];
    //[iconView setFrame:CGRectMake(0,0,25,25)];
    logo = [UIImage imageNamed:@"BrowseTabIcon" inBundle:musicBundle compatibleWithTraitCollection:nil];
    
    [iconView setImage:[[logo resizeImageToWidth:25.0] imageWithTintColor:[UIColor systemPinkColor] renderingMode:UIImageRenderingModeAlwaysTemplate]];
    [iconView setTintColor:[UIColor systemPinkColor]];
    
    [iconView setContentMode:UIViewContentModeScaleAspectFit];
    
    [iconView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [playerContainer addSubview:iconView];
    
    [iconView.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor constant:-16].active = true;
    [iconView.topAnchor constraintEqualToAnchor:playerContainer.topAnchor constant:16].active = true;
    [iconView.widthAnchor constraintEqualToConstant:25].active = true;
    [iconView.heightAnchor constraintEqualToConstant:25].active = true;
}

- (void)addRecentView {
    if (recentView) {
        [recentView removeFromSuperview];
    }
    
    recentVC = [MUMRecentViewController new];
    [self addChildViewController:recentVC];
    recentView = recentVC.view;
    [contentView addSubview:recentView];
    
    [recentView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor].active = true;
    [recentView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor].active = true;
    [recentView.topAnchor constraintEqualToAnchor:playerContainer.bottomAnchor].active = true;
    [recentView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor].active = true;
    recentViewLargeHeight = [recentView.heightAnchor constraintEqualToConstant:10];
}

- (void)addLabelView {
    labelView = [MUILabelView new];
    [labelView.titleLabel setTextColor:[UIColor systemPinkColor]];
    [labelView.titleLabel setText:@"Music"];
    [labelView.artistLabel setText:[[UIDevice currentDevice] name]];
    
    [playerContainer addSubview:labelView];
    
    [self addAlbumView];
    
    labelNormalLeading = [labelView.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor
                                                                 constant:16];
    labelCondensedLeading = [labelView.leadingAnchor constraintEqualToAnchor:albumArt.trailingAnchor
                                                                    constant:8.0];
    [labelView.trailingAnchor constraintEqualToAnchor:playerContainer.trailingAnchor
                                             constant:-16].active = true;
    labelBottom = [labelView.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor
                                                         constant:-16];
    labelCondensedCenter = [labelView.centerYAnchor constraintEqualToAnchor:playerContainer.centerYAnchor];
    [labelView setContentCompressionResistancePriority:1000
                                               forAxis:1];
}

- (void)addAlbumView {
    albumArt = [UIImageView new];
    [albumArt.layer setCornerCurve:kCACornerCurveContinuous];
    [albumArt.layer setCornerRadius:4];
    [albumArt setClipsToBounds:true];
    [albumArt setBackgroundColor:[UIColor tertiarySystemFillColor]];
    
    [albumArt setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [playerContainer addSubview:albumArt];
    
    [albumArt.leadingAnchor constraintEqualToAnchor:playerContainer.leadingAnchor constant:16].active = true;
    [albumArt.trailingAnchor constraintLessThanOrEqualToAnchor:iconView.leadingAnchor constant:-4].active = true;
    [albumArt.topAnchor constraintEqualToAnchor:playerContainer.topAnchor constant:16].active = true;
    albumLabelBottom = [albumArt.bottomAnchor constraintLessThanOrEqualToAnchor:labelView.topAnchor constant:-4];
    albumLargeBottom = [albumArt.bottomAnchor constraintEqualToAnchor:playerContainer.bottomAnchor constant:-16.0];
    [albumArt.heightAnchor constraintEqualToAnchor:albumArt.widthAnchor].active = true;
}

- (void)addAppLabel {
    appLabel = [UILabel new];
    [appLabel setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]];
    [appLabel setTextColor:[UIColor whiteColor]];
    [appLabel setText:@"Music"];
    
    [appLabel setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:appLabel];
    
    [appLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [appLabel.centerYAnchor constraintEqualToAnchor:self.view.bottomAnchor
                                           constant:-2].active = true;
    [appLabel.heightAnchor constraintEqualToConstant:12].active = true;
    [contentView.bottomAnchor constraintEqualToAnchor:appLabel.topAnchor
                                             constant:-5].active = true;
}

- (void)updateMedia {
    [self musicPlaying];
    BOOL currentlyPlaying = [appName isEqualToString:@"Music"];
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        [labelView.artistLabel setText:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]) ? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] : [[UIDevice currentDevice] name]];
        [labelView.titleLabel setText:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]) ? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] : @"Music"];
        //[labelView.albumLabel setText:([(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] && self.widgetFrame.size.numCols > 2)? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] : nil];
        [albumArt setImage:[UIImage imageWithData:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) ? [(__bridge NSDictionary *)result objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData] : nil]];
    });
}

- (void)musicPlaying {
    MRMediaRemoteGetNowPlayingApplicationPID(dispatch_get_main_queue(), ^(int PID) {
        @try {
            SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithPid:PID];
            appName = [app displayName] ? [app displayName] : @"Hello";
        } @catch (NSException * e) {
            appName = @"Hello";
        }
    });
}

+(HSWidgetSize)minimumSize {
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

- (void)setRequestedSize:(CGSize)size {
    [super setRequestedSize:size];
    
    self.compactHeight = labelView.frame.size.height + 32.0;
    
    if (self.widgetFrame.size.numCols > 2) {
        playerContainerBottom.active = false;
        //albumCondensedWidth.active = true;
        albumLabelBottom.active = false;
        labelNormalLeading.active = false;
        labelCondensedLeading.active = true;
        //playerContainerLongBottom.active = true;
    } else {
        playerContainerBottom.active = true;
        //albumCondensedWidth.active = false;
        albumLabelBottom.active = true;
        labelCondensedLeading.active = false;
        labelNormalLeading.active = true;
    }
    if (self.widgetFrame.size.numRows > 2) {
        recentViewLargeHeight.active = true;
    } else {
        recentViewLargeHeight.active = false;
    }
    if (self.widgetFrame.size.numRows > 2 || self.widgetFrame.size.numCols > 2) {
        albumLargeBottom.active = true;
    } else {
        albumLargeBottom.active = false;
    }
    if (self.widgetFrame.size.numCols > 2 && self.widgetFrame.size.numRows == 2) {
        playerContainerCompactHeight.active = true;
        labelBottom.active = false;
        labelCondensedCenter.active = true;
    } else {
        playerContainerCompactHeight.active = false;
        labelBottom.active = true;
        labelCondensedCenter.active = false;
    }
    [recentVC.collectionView.collectionViewLayout invalidateLayout];
    recentViewLargeHeight.constant = recentVC.collectionView.contentSize.height;
    playerContainerCompactHeight.constant = (contentView.bounds.size.height - ((recentVC.collectionView.contentSize.height / 2) + 8));
}

@end
