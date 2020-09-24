#import <HSWidgets/HSWidgetViewController.h>
#import <MediaRemote/MediaRemote.h>
#import <MediaPlayerUI/MPUNowPlayingController.h>
#import <MuseUI/MuseUI.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "UIImage+Color.h"
#import "SPTPlayerTrack.h"
#import "MUSRecentViewController.h"

@interface LSApplicationProxy
/*MobileCoreServices*/
- (id)_initWithBundleUnit:(NSUInteger)arg1 applicationIdentifier:(NSString *)arg2;
+ (id)applicationProxyForIdentifier:(NSString *)arg1;
+ (id)applicationProxyForBundleURL:(NSURL *)arg1;
@end

@interface FBApplicationInfo : NSObject
/*FrontBoard*/
- (NSURL *)dataContainerURL;
- (NSURL *)bundleURL;
- (NSString *)bundleIdentifier;
- (NSString *)bundleType;
- (NSString *)bundleVersion;
- (NSString *)displayName;
- (id)initWithApplicationProxy:(id)arg1;
@end

@interface MUILabelView ()

@end

@interface MUSViewController : HSWidgetViewController <WKUIDelegate, WKNavigationDelegate> {
    UIView *contentView, *playerContainer, *albumView, *centeringView, *nextUpView, *recentView;
    UIImageView *iconView, *albumImageView;
    UIImage *waveformImage;
    MUILabelView *labelView;
    UILabel *appLabel, *testLabel, *nextUpLabel, *nextSong, *nextArtist;
    NSBundle *spotifyBundle, *widgetBundle;
    NSString *trackUrlString, *urlString, *appName, *source, *lastTrackTitle, *lastTrackArtist;
    NSLayoutConstraint *albumExpanded, *albumShrunk, *labelLeadingExpanded, *labelLeadingShrunk, *pauseLeading, *pauseTrailing, *pauseTop, *pauseBottom, *labelViewExpanded, *labelViewShrunk, *labelViewBottom, *labelViewTop, *centeringViewTop, *centeringViewBottom, *playerContainterBottom, *playerContainerHeight;
    WKWebView *svgView;
    WKWebViewConfiguration *config;
    WKUserScript *script;
    WKUserContentController *contentController;
    MUSRecentViewController *recentVC;
    NSArray *recentArray;
    NSTimer *progressTimer;
    BOOL injected;
    unsigned int lastAlbumDataLength;
    UIButton *pause;
}

@property (nonatomic,copy) MUILabelView *labelView;
@property (nonatomic) CGFloat twoRowHeight;

typedef void(^imageCreated)(UIImage *);

@end
