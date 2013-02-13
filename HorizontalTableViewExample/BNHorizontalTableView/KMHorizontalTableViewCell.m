//
//  KMHorizontalTableViewCell.m
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import "KMHorizontalTableViewCell.h"

@implementation KMHorizontalTableViewCell

- (KMHorizontalTableViewCell *)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

@end
