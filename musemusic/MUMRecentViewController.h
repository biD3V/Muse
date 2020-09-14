//
//  MUMRecentViewController.h
//  Muse
//
//  Created by Sawyer Jester on 8/28/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MUMRecentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
