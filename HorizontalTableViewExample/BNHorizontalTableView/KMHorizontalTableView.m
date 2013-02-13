//
//  KMHorizontalTableView.m
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import "KMHorizontalTableView.h"

@interface KMHorizontalTableView ()

@property (nonatomic, retain) NSMutableArray *visibleCells;
@property (nonatomic, retain) NSMutableArray *visibleIndexPaths;
@property (nonatomic, retain) NSMutableDictionary *cellsForReuse;

- (void)setupVisibleCells;
- (void)queueCellForReuse:(KMHorizontalTableViewCell *)cell;

@end

@implementation KMHorizontalTableView

#pragma mark - Setup Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // We are going to receive our own scrolling delegate messages to affect scrolling behaviour alter if necessary
        self.delegate = self;
        _visibleCells = [[NSMutableArray alloc] init];
        _snappingBehaviour = KMHorizontalTableViewSnappingBehaviourNone;
    }
    return self;
}

- (void)loadFromNib
{
    [self setupVisibleCells];
}

- (void)didMoveToSuperview
{
    [self setupVisibleCells];
}

- (void)setupVisibleCells
{
    CGRect viewBounds = self.bounds;
    CGRect contentFrame = CGRectInset(viewBounds, self.contentInset.left, self.contentInset.right);
    
    //Check which cells are now note visible and can go into the reuse pool
    for (KMHorizontalTableViewCell *cell in self.visibleCells)
    {
        if (!CGRectIntersectsRect(cell.frame, contentFrame))
        {
            [self queueCellForReuse:cell];
        }
    }
    
    NSInteger numberOfSections = 0;
    
    if ([self.tableViewDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
        numberOfSections = [self.tableViewDataSource numberOfSectionsInTableView:self];
    
    CGFloat cumulativeXPosition = 0.0f;
    
    for (NSInteger section = 0; section < numberOfSections; section++)
    {
        NSInteger columnsInSection = 0;
        
        if ([self.tableViewDataSource respondsToSelector:@selector(horizontalTableView:numberOfColumnsInSection:)])
            columnsInSection = [self.tableViewDataSource horizontalTableView:self numberOfColumnsInSection:section];
        
        for (NSInteger column = 0; column < columnsInSection; column++)
        {
            KMIndexPath *cellIndexPath = [KMIndexPath indexPathWithIndexPath:self.parentIndexPath];
            cellIndexPath.columnSection = section;
            cellIndexPath.column = column;
            
            CGFloat cellWidth = 0.0f;
            if ([self.tableViewDelegate respondsToSelector:@selector(horizontalTableView:widthForRowAtIndexPath:)])
                cellWidth = [self.tableViewDelegate horizontalTableView:self widthForRowAtIndexPath:cellIndexPath];            
            
            CGRect cellFrame = CGRectMake(cumulativeXPosition, viewBounds.origin.y, cellWidth, viewBounds.size.height);
            
            if (CGRectIntersectsRect(cellFrame, contentFrame))
            {
                //If already visible don't re-add
                if (![self.visibleIndexPaths containsObject:cellIndexPath])
                {
                    KMHorizontalTableViewCell *cell = [self.tableViewDataSource horizontalTableView:self cellForColumnAtIndexPath:cellIndexPath];
                    
                    if (cell)
                    {
                        cell.frame = cellFrame;
                        [self.visibleCells addObject:cell];
                        [self.visibleIndexPaths addObject:cellIndexPath];
                        [self addSubview:cell];
                    }
                }
            }
            
            cumulativeXPosition += cellWidth;
        }
        
    }
    
    self.contentSize = CGSizeMake(cumulativeXPosition, self.bounds.size.height);
}

#pragma mark - Cell Reuse Methods

- (void)queueCellForReuse:(KMHorizontalTableViewCell *)cell
{
    //Lazy load
    if (!self.cellsForReuse)
        self.cellsForReuse = [NSMutableDictionary dictionary];
    
    NSMutableArray *cellsForIdentifier = [self.cellsForReuse objectForKey:cell.reuseIdentifier];
    
    if (!cellsForIdentifier)
        cellsForIdentifier = [NSMutableArray array];
    
    [cellsForIdentifier addObject:cell];
    [self.cellsForReuse setObject:cellsForIdentifier forKey:cell.reuseIdentifier];
    
    [cell removeFromSuperview];
}

- (KMHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier
{
    NSMutableArray *queuedCells = [self.cellsForReuse objectForKey:reuseIdentifier];
    KMHorizontalTableViewCell *queuedCell = [queuedCells lastObject];
    
    [queuedCells removeLastObject];
    
    return queuedCell;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setupVisibleCells];
}

// To implement snapping behaviour, well check where the scrollview intends to come to rest
// and alter change it to match a cell boundary.
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.snappingBehaviour == KMHorizontalTableViewSnappingBehaviourNone)
        return;
    
    CGFloat cumulativeXPosition = 0.0f;
    CGFloat originalFinalXPosition = targetContentOffset->x;
    
    NSInteger numberOfSections = 0;
    if ([self.tableViewDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
        numberOfSections = [self.tableViewDataSource numberOfSectionsInTableView:self];
    
    // Go through the cell boundaries and check which one the scrollview would stop on.
    for (NSInteger section = 0; section < numberOfSections; section++)
    {
        NSInteger columnsInSection = 0;
        
        if ([self.tableViewDataSource respondsToSelector:@selector(horizontalTableView:numberOfColumnsInSection:)])
            columnsInSection = [self.tableViewDataSource horizontalTableView:self numberOfColumnsInSection:section];
        
        for (NSInteger column = 0; column < columnsInSection; column++)
        {
            KMIndexPath *cellIndexPath = [KMIndexPath indexPathWithIndexPath:self.parentIndexPath];
            cellIndexPath.columnSection = section;
            cellIndexPath.column = column;
            
            CGFloat cellWidth = 0.0f;
            if ([self.tableViewDelegate respondsToSelector:@selector(horizontalTableView:widthForRowAtIndexPath:)])
                cellWidth = [self.tableViewDelegate horizontalTableView:self widthForRowAtIndexPath:cellIndexPath];
            else
                cellWidth = self.rowHeight;
            
            // Check against left, right or center of scrollview depending on snappingBehaviour.
            CGFloat checkingXPosition = originalFinalXPosition;
            CGFloat boundsOffset = 0.0f;
            if (self.snappingBehaviour == KMHorizontalTableViewSnappingBehaviourLeft)
            {
                checkingXPosition = originalFinalXPosition;
                boundsOffset = 0.0f;
            }
            else if (self.snappingBehaviour == KMHorizontalTableViewSnappingBehaviourRight)
            {
                checkingXPosition = originalFinalXPosition + self.frame.size.width - cellWidth;
                boundsOffset = self.frame.size.width - cellWidth;
            }
            else if (self.snappingBehaviour == KMHorizontalTableViewSnappingBehaviourCenter)
            {
                checkingXPosition = originalFinalXPosition + self.center.x;
                boundsOffset = self.center.x - cellWidth/2;
            }
            
            // Snap to either the front or back of the cell.
            if (cumulativeXPosition < checkingXPosition && cumulativeXPosition+(cellWidth/2) > checkingXPosition)
            {
                targetContentOffset->x = cumulativeXPosition - boundsOffset;
            }
            else if (cumulativeXPosition+(cellWidth/2) <= checkingXPosition && cumulativeXPosition+cellWidth > checkingXPosition)
            {
                targetContentOffset->x = cumulativeXPosition + cellWidth - boundsOffset;
            }
            
            cumulativeXPosition += cellWidth;
        }
    }
}

#pragma mark - UITableView Matching Methods

- (void)reloadData
{
    [self.visibleCells removeAllObjects];
    [self setupVisibleCells];
}

@end
