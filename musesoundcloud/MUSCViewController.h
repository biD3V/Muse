#import <UIKit/UIKit.h>
#import <HSWidgets/HSWidgetViewController.h>
#import <MediaRemote/MediaRemote.h>
#import <MediaPlayerUI/MPUNowPlayingController.h>
#import <MuseUI/MuseUI.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBApplicationController.h>

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

@interface MUSCViewController : HSWidgetViewController {
    NSBundle *soundCloudBundle;
    UIView *contentView;
    UILabel *appLabel;
    UIImageView *albumArt, *iconView;
    MUILabelView *labelView;
    NSString *appName;
    UIImage *logo;
}

@property (nonatomic,copy) MUILabelView *labelView;

@end

