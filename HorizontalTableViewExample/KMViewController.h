//
//  KMViewController.h
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMHorizontalTableView.h"

@interface KMViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, KMHorizontalTableViewDataSource, KMHorizontalTableViewDelegate>

@end
