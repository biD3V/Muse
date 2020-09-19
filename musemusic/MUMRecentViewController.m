//
//  MUMRecentViewController.m
//  Muse
//
//  Created by Sawyer Jester on 8/28/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

#import "MUMRecentViewController.h"

@interface MUMRecentViewController ()

@end

@implementation MUMRecentViewController

static NSString * const reuseIdentifier = @"recentMusicCoverCell";

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
    [self.collectionView setBackgroundColor:[UIColor quaternarySystemFillColor]];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.collectionView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
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
    
    [cell setBackgroundColor:[UIColor tertiarySystemFillColor]];
    [cell setClipsToBounds:true];
    [cell.layer setCornerCurve:kCACornerCurveContinuous];
    [cell.layer setCornerRadius:4.0];
    
    MPMediaQuery *songs = [MPMediaQuery songsQuery];
    NSMutableArray *songArray = [NSMutableArray new];

    for (MPMediaItem *song in [songs items]) {
        NSMutableDictionary *songDict = [NSMutableDictionary new];
        [songDict setObject:(NSDate *)[song valueForKey:@"dateAdded"] forKey:@"dateAdded"];
        [songDict setObject:[song valueForKey:@"lastPlayedDate"] ? (NSDate *)[song valueForKey:@"lastPlayedDate"] : (NSDate *)[song valueForKey:@"dateAdded"] forKey:@"lastPlayedDate"];
        [songDict setObject:(NSString *)[song valueForKey:@"title"] forKey:@"title"];
        [songDict setObject:(MPMediaItemArtwork *)[song valueForKey:@"artwork"] ?: [UIImage emptyImageWithSize:CGSizeMake(100, 100)] forKey:@"artwork"];
        [songArray addObject:songDict];
    }
    
    //[songArray writeToFile:@"/var/mobile/Documents/MusicSongs.plist" atomically:NO];
    
    NSArray *sortedSongs = [songArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *song1, NSDictionary *song2) {
        return [(NSDate *)[song2 valueForKey:@"lastPlayedDate"] compare:(NSDate *)[song1 valueForKey:@"lastPlayedDate"]];
    }];
    
    //[sortedSongs writeToFile:@"/var/mobile/Documents/MusicSongsSorted.plist" atomically:NO];
    
    if (sortedSongs[indexPath.item] != nil) {
        UIImageView *coverArt = [UIImageView new];
        
        [coverArt setImage:[[sortedSongs[indexPath.item] valueForKey:@"artwork"] isKindOfClass:[MPMediaItemArtwork class]] ? [(MPMediaItemArtwork *)[sortedSongs[indexPath.item] valueForKey:@"artwork"] imageWithSize:CGSizeMake(100, 100)] : (UIImage *)[sortedSongs[indexPath.item] valueForKey:@"artwork"]];

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
