#import "MUSCViewController.h"

@implementation MUSCViewController

@synthesize labelView;

-(void)viewDidLoad {
	[super viewDidLoad];
    
    [self setCornerRadius:20];
    
    FBApplicationInfo *appInfo = [LSApplicationProxy applicationProxyForIdentifier: @"com.soundcloud.TouchApp"];
    soundCloudBundle = [NSBundle bundleWithURL:appInfo.bundleURL];
    // sc_logo_7_bars.png
    // logo_sticker.pdf

    [self addContentView];
    [self addIconView];
    [self addLabelView];
    [self addAlbumView];
    [self addAppLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMedia) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
}

- (void)addContentView {
    contentView = [UIView new];
    [contentView setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
    [contentView.layer setCornerRadius:20];
    [contentView.layer setCornerCurve:kCACornerCurveContinuous];
    
    [contentView setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:contentView];
    
    [contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    //[contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
    UIView *editingView = (UIView *)[self valueForKey:@"_editingView"];
    [editingView setTranslatesAutoresizingMaskIntoConstraints:false];
    [editingView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor].active = true;
    [editingView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor].active = true;
    [editingView.topAnchor constraintEqualToAnchor:contentView.topAnchor].active = true;
    [editingView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor].active = true;
}

- (void)addIconView {
    iconView = [UIImageView new];
    //[iconView setFrame:CGRectMake(0,0,25,25)];
    logo = [UIImage imageNamed:@"sc_logo_7_bars" inBundle:soundCloudBundle compatibleWithTraitCollection:nil];
    
    [iconView setImage:[[logo resizeImageToWidth:25.0] imageWithTintColor:[UIColor systemOrangeColor] renderingMode:UIImageRenderingModeAlwaysTemplate]];
    [iconView setTintColor:[UIColor systemOrangeColor]];
    
    [iconView setContentMode:UIViewContentModeScaleAspectFit];
    
    [iconView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [contentView addSubview:iconView];
    
    [iconView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-16].active = true;
    [iconView.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:16].active = true;
    [iconView.widthAnchor constraintEqualToConstant:25].active = true;
    [iconView.heightAnchor constraintEqualToConstant:25].active = true;
}

- (void)addLabelView {
    labelView = [MUILabelView new];
    [labelView.titleLabel setTextColor:[UIColor systemOrangeColor]];
    [labelView.titleLabel setText:@"SoundCloud"];
    [labelView.artistLabel setText:[[UIDevice currentDevice] name]];
    
    [contentView addSubview:labelView];
    
    [labelView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor
                                            constant:16].active = true;
    [labelView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor
                                             constant:-16].active = true;
    [labelView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor
                                           constant:-16].active = true;
}

- (void)addAlbumView {
    albumArt = [UIImageView new];
    [albumArt.layer setCornerCurve:kCACornerCurveContinuous];
    [albumArt.layer setCornerRadius:12];
    [albumArt setClipsToBounds:true];
    
    [albumArt setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [contentView addSubview:albumArt];
    
    [albumArt.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:8].active = true;
    [albumArt.trailingAnchor constraintLessThanOrEqualToAnchor:iconView.leadingAnchor constant:-8].active = true;
    [albumArt.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:8].active = true;
    [albumArt.bottomAnchor constraintLessThanOrEqualToAnchor:labelView.topAnchor constant:-8].active = true;
    [albumArt.heightAnchor constraintEqualToAnchor:albumArt.widthAnchor].active = true;
}

- (void)addAppLabel {
    appLabel = [UILabel new];
    [appLabel setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]];
    [appLabel setTextColor:[UIColor whiteColor]];
    [appLabel setText:@"SoundCloud"];
    
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
    [self soundCloudPlaying];
    BOOL currentlyPlaying = [appName isEqualToString:@"SoundCloud"];
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        [labelView.artistLabel setText:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]) ? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] : [[UIDevice currentDevice] name]];
        [labelView.titleLabel setText:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]) ? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] : @"SoundCloud"];
        //[labelView.albumLabel setText:([(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] && self.widgetFrame.size.numCols > 2)? [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] : nil];
        [albumArt setImage:[UIImage imageWithData:(currentlyPlaying && [(__bridge NSDictionary *)result objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) ? [(__bridge NSDictionary *)result objectForKey:(NSData *)(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData] : nil]];
    });
}

- (void)soundCloudPlaying {
    MRMediaRemoteGetNowPlayingApplicationPID(dispatch_get_main_queue(), ^(int PID) {
        @try {
            SBApplication *app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithPid:PID];
            appName = [app displayName] ? [app displayName] : @"Music";
        } @catch (NSException * e) {
            appName = @"Music";
        }
    });
}

+(HSWidgetSize)minimumSize {
	return HSWidgetSizeMake(2, 2); // least amount of rows and cols the widget needs
}

@end
