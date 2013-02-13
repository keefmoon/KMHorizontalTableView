//
//  KMHorizontalTableViewController.h
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMHorizontalTableView.h"

@interface KMHorizontalTableViewController : UIViewController <KMHorizontalTableViewDataSource, KMHorizontalTableViewDelegate>

@property (nonatomic, retain) IBOutlet KMHorizontalTableView *horizontalTableView;

@end
