//
//  MUSPreferencesViewController.m
//  Muse
//
//  Created by biD3V on 8/27/20.
//  Copyright © 2020 biD3V. All rights reserved.
//

// Does not do anything
#import "MUSPreferencesViewController.h"

@implementation MUSPreferencesViewController

-(NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

@end
