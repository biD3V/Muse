//
//  UIImage+Color.h
//  
//
//  Created by Sawyer Jester on 8/17/20.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage*)setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect;


+ (UIImage *)replaceColor:(UIColor *)color inImage:(UIImage *)image withTolerance:(float)tolerance;

+ (UIImage *)changeWhiteColorTransparent:(UIImage *)image;

+ (UIImage *)changeColorTo:(NSMutableArray*)array Transparent:(UIImage *)image;

//resizing Stuff...
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
