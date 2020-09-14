#import <UIKit/UIKit.h>
#import <MediaRemote/MediaRemote.h>
#import <MediaPlayerUI/MPUNowPlayingController.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>
#import <HSWidgets/HSWidgetViewController.h>
#import <MuseUI/MuseUI.h>
#import "MUMRecentViewController.h"

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

@interface MUMViewController : HSWidgetViewController {
    UIView *contentView, *playerContainer, *recentView;
    NSBundle *musicBundle;
    UIImage *logo;
    UIImageView *iconView, *albumArt;
    UILabel *appLabel;
    NSString *appName;
    NSLayoutConstraint *playerContainerCompactHeight, *playerContainerBottom, *albumLabelBottom, *albumPlayerBottom, *albumNormalTrailing, *albumCondensedWidth, *labelNormalLeading, *labelCondensedLeading, *labelCondensedCenter, *albumLargeBottom, *labelBottom, *recentViewLargeHeight;
    MUMRecentViewController *recentVC;
}

@property (nonatomic,copy) MUILabelView *labelView;
@property (nonatomic) CGFloat twoRowHeight;
@property (nonatomic) CGFloat compactHeight;

@end

