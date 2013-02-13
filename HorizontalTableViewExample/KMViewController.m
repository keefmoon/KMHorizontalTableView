//
//  KMViewController.m
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import "KMViewController.h"

@interface KMViewController ()

@property (nonatomic, retain) IBOutlet UITableView *caroselTableView;

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        CGRect cellFrame = cell.frame;
        cellFrame.size.height = 80.0f;
        
        KMHorizontalTableView *horizontalView = [[KMHorizontalTableView alloc] initWithFrame:cellFrame];
        horizontalView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        horizontalView.tableViewDataSource = self;
        horizontalView.tableViewDelegate = self;
        horizontalView.snappingBehaviour = KMHorizontalTableViewSnappingBehaviourLeft;
        horizontalView.tag = 10;
        
        [cell.contentView addSubview:horizontalView];
    }
    
    KMHorizontalTableView *innerView = (KMHorizontalTableView *)[cell.contentView viewWithTag:10];
    
    KMIndexPath *thisIndexPath = [KMIndexPath indexPathWithRowSection:indexPath.section columnSection:0 row:indexPath.row andColumn:0];
    innerView.parentIndexPath = thisIndexPath;
    [innerView reloadData];
    
    return cell;
}

#pragma mark - BNHorizontalTableViewDataSource Methods

- (NSInteger)horizontalTableView:(KMHorizontalTableView *)horizontalTableView numberOfColumnsInSection:(NSInteger)section
{
    return 10;
}

- (KMHorizontalTableViewCell *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView cellForColumnAtIndexPath:(KMIndexPath *)indexPath
{
    static NSString *horizontalCellIdentifier = @"horizontalCellIdentifier";
    
    KMHorizontalTableViewCell *cell = [horizontalTableView dequeueReusableCellWithIdentifier:horizontalCellIdentifier];
    
    if (!cell)
    {
        cell = [[KMHorizontalTableViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f) andReuseIdentifier:horizontalCellIdentifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 60.0f, 60.0f)];
        label.tag = 1;
        label.font = [UIFont systemFontOfSize:14.0f];
        [cell addSubview:label];
        
        UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 70.0f, 70.0f)];
        demoView.backgroundColor = [UIColor blueColor];
        [cell addSubview:demoView];
        [cell sendSubviewToBack:demoView];
    }
    
    UILabel *demoLabel = (UILabel *)[cell viewWithTag:1];
    demoLabel.text = [NSString stringWithFormat:@"R: %d C: %d", horizontalTableView.parentIndexPath.row, indexPath.column];
    
    return cell;
}

#pragma mark - BNHorizontalTableViewDelegate Methods

- (CGFloat)horizontalTableView:(KMHorizontalTableView *)horizontalTableView widthForRowAtIndexPath:(KMIndexPath *)indexPath
{
    return 80.0f;
}

@end
