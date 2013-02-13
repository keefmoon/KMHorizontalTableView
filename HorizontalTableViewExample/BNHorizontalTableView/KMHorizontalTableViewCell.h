//
//  KMHorizontalTableViewCell.h
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMHorizontalTableViewCell : UIView

@property (nonatomic, retain) NSString *reuseIdentifier;

//Need to implement Select/Unselect
//Need to implement Highlight/Unhighlight

- (KMHorizontalTableViewCell *)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier;

@end
