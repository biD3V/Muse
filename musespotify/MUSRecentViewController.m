//
//  MUSRecentViewController.m
//  dummy
//
//  Created by Sawyer Jester on 8/26/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

#import "MUSRecentViewController.h"

@interface MUSRecentViewController ()

@end

@implementation MUSRecentViewController

static NSString * const reuseIdentifier = @"recentCoverCell";

- (MUSRecentViewController *)initWithCellWidth:(CGFloat)width dataArray:(NSArray *)array {
    self = [super init];
    
    self.cellSize = width;
    self.dataArray = array;
    
    [self loadView];
    
    return self;
}

- (void)loadView {
    [super loadView];
    // Do any additional setup after loading the view.
    self.view = [UIView new];
    [self.view setUserInteractionEnabled:false];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    self.collectionTitleString = @"Recently Played";
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self addLabelView];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.collectionView.topAnchor constraintEqualToAnchor:self.labelContainer.bottomAnchor constant:-8].active = true;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
}

- (void)addLabelView {
    self.labelContainer = [UIView new];
    self.collectionTitle = [UILabel new];
    [self.collectionTitle setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightSemibold]];
    [self.collectionTitle setText:self.collectionTitleString];
    [self.collectionTitle setTextColor:[UIColor lightTextColor]];
    
    [self.labelContainer setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.collectionTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.labelContainer addSubview:self.collectionTitle];
    [self.view addSubview:self.labelContainer];
    
    [self.labelContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.labelContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.labelContainer.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:16].active = true;
//    [self.labelContainer.heightAnchor constraintEqualToConstant:(self.view.frame.size.height - ((self.cellSize * 2.0) + 48.0))].active = true;
    
    [self.collectionTitle.leadingAnchor constraintEqualToAnchor:self.labelContainer.leadingAnchor
                                                       constant:16.0].active = true;
    [self.collectionTitle.trailingAnchor constraintEqualToAnchor:self.labelContainer.trailingAnchor
                                                        constant:-16.0].active = true;
    [self.collectionTitle.bottomAnchor constraintEqualToAnchor:self.labelContainer.bottomAnchor].active = true;
}

- (void)addProgressView {
    self.progressView = [UIProgressView new];
    
    [self.progressView setTintColor:[UIColor systemGreenColor]];
    [self.progressView setTrackTintColor:[[UIColor systemGreenColor] colorWithAlphaComponent:0.25]];
    
    [self.progressView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.labelContainer addSubview:self.progressView];
    
    [self.progressView.leadingAnchor constraintEqualToAnchor:self.labelContainer.leadingAnchor
                                                    constant:16.0].active = true;
    [self.progressView.trailingAnchor constraintEqualToAnchor:self.labelContainer.trailingAnchor
                                                     constant:-16.0].active = true;
    [self.progressView.topAnchor constraintEqualToAnchor:self.labelContainer.topAnchor].active = true;
}

- (void)updateCellSize:(CGFloat)width {
    self.cellSize = width;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    [cell setBackgroundColor:[UIColor secondarySystemBackgroundColor]];
    [cell setClipsToBounds:true];
    [cell.layer setCornerCurve:kCACornerCurveContinuous];
    [cell.layer setCornerRadius:4.0];
    
    if (indexPath.item < self.dataArray.count) {
        UIImageView *coverArt = [UIImageView new];
        
        [UIImage loadFromURL:[NSURL URLWithString:self.dataArray[indexPath.item]] callback:^(UIImage *urlImage) {
            [coverArt setImage:urlImage];
        }];
        
        [coverArt setTranslatesAutoresizingMaskIntoConstraints:false];
        
        [cell addSubview:coverArt];
        
        [coverArt.leadingAnchor constraintEqualToAnchor:cell.leadingAnchor].active = true;
        [coverArt.trailingAnchor constraintEqualToAnchor:cell.trailingAnchor].active = true;
        [coverArt.topAnchor constraintEqualToAnchor:cell.topAnchor].active = true;
        [coverArt.bottomAnchor constraintEqualToAnchor:cell.bottomAnchor].active = true;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat size = ((self.collectionView.frame.size.width - 80) / 4);
    if (size < 1.0) {
        return CGSizeMake(1.0, 1.0);
    } else {
        return CGSizeMake(size, size);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 16.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 16.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
}

@end
