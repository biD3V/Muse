//
//  MUSPreferencesViewController.m
//  Muse
//
//  Created by Sawyer Jester on 8/27/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

#import "MUSPreferencesViewController.h"

@implementation MUSPreferencesViewController

-(NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

@end
