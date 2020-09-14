//
//  MUSRecentViewController.h
//  dummy
//
//  Created by Sawyer Jester on 8/26/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MuseUI/UIImage+MuseUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface MUSRecentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) UILabel *collectionTitle;
@property (strong,nonatomic) NSString *collectionTitleString;
@property (strong,nonatomic) UIView *labelContainer;
@property (strong,nonatomic) NSArray *dataArray;
@property (strong,nonatomic) UIProgressView *progressView;
@property (nonatomic) CGFloat cellSize;

- (void)updateCellSize:(CGFloat)width;
- (MUSRecentViewController *)initWithCellWidth:(CGFloat)width dataArray:(NSArray *)array;
- (void)addProgressView;

@end

NS_ASSUME_NONNULL_END
