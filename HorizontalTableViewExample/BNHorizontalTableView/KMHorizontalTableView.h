//
//  KMHorizontalTableView.h
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMHorizontalTableViewCell.h"
#import "KMIndexPath.h"

typedef enum KMHorizontalTableViewSnappingBehaviour {
    KMHorizontalTableViewSnappingBehaviourNone,
    KMHorizontalTableViewSnappingBehaviourLeft,
    KMHorizontalTableViewSnappingBehaviourCenter,
    KMHorizontalTableViewSnappingBehaviourRight
} KMHorizontalTableViewSnappingBehaviour;

@protocol KMHorizontalTableViewDelegate;
@protocol KMHorizontalTableViewDataSource;

@interface KMHorizontalTableView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) id <KMHorizontalTableViewDelegate> tableViewDelegate;
@property (nonatomic, assign) id <KMHorizontalTableViewDataSource> tableViewDataSource;
@property (nonatomic, assign) KMHorizontalTableViewSnappingBehaviour snappingBehaviour;
@property (nonatomic, retain) KMIndexPath *parentIndexPath;
@property (nonatomic, assign) CGFloat rowHeight;

- (KMHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)reuseIdentifier;
- (void)reloadData;

@end

@protocol KMHorizontalTableViewDataSource <NSObject>

@required

- (NSInteger)horizontalTableView:(KMHorizontalTableView *)horizontalTableView numberOfColumnsInSection:(NSInteger)section;

- (KMHorizontalTableViewCell *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView cellForColumnAtIndexPath:(KMIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(KMHorizontalTableView *)horizontalTableView;

- (NSString *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView titleForHeaderInSection:(NSInteger)section;

- (NSString *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView titleForFooterInSection:(NSInteger)section;

- (BOOL)horizontalTableView:(KMHorizontalTableView *)horizontalTableView canEditColumnAtIndexPath:(KMIndexPath *)indexPath;

- (BOOL)horizontalTableView:(KMHorizontalTableView *)horizontalTableView canMoveColumnAtIndexPath:(KMIndexPath *)indexPath;

- (NSArray *)sectionIndexTitlesForTableView:(KMHorizontalTableView *)horizontalTableView;

- (NSInteger)horizontalTableView:(KMHorizontalTableView *)horizontalTableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forColumnAtIndexPath:(KMIndexPath *)indexPath;

- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView moveColumnAtIndexPath:(KMIndexPath *)sourceIndexPath toIndexPath:(KMIndexPath *)destinationIndexPath;

@end

@protocol KMHorizontalTableViewDelegate <NSObject>

@optional

// Display customization

- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView willDisplayCell:(KMHorizontalTableViewCell *)cell forRowAtIndexPath:(KMIndexPath *)indexPath;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView didEndDisplayingCell:(KMHorizontalTableViewCell *)cell forRowAtIndexPath:(KMIndexPath*)indexPath;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;

// Variable height support

- (CGFloat)horizontalTableView:(KMHorizontalTableView *)horizontalTableView widthForRowAtIndexPath:(KMIndexPath *)indexPath;
- (CGFloat)horizontalTableView:(KMHorizontalTableView *)horizontalTableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)horizontalTableView:(KMHorizontalTableView *)horizontalTableView heightForFooterInSection:(NSInteger)section;

// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
- (UIView *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// Accessories (disclosures).

//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath NS_DEPRECATED_IOS(2_0, 3_0);
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)horizontalTableView:(KMHorizontalTableView *)horizontalTableView shouldHighlightRowAtIndexPath:(KMIndexPath *)indexPath;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView didHighlightRowAtIndexPath:(KMIndexPath *)indexPath;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView didUnhighlightRowAtIndexPath:(KMIndexPath *)indexPath;

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (KMIndexPath *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView willSelectRowAtIndexPath:(KMIndexPath *)indexPath;
- (KMIndexPath *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView willDeselectRowAtIndexPath:(KMIndexPath *)indexPath;
// Called after the user changes the selection.
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView didSelectRowAtIndexPath:(KMIndexPath *)indexPath;
- (void)horizontalTableView:(KMHorizontalTableView *)horizontalTableView didDeselectRowAtIndexPath:(KMIndexPath *)indexPath;

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
//- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
//- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (KMIndexPath *)horizontalTableView:(KMHorizontalTableView *)horizontalTableView targetIndexPathForMoveFromRowAtIndexPath:(KMIndexPath *)sourceIndexPath toProposedIndexPath:(KMIndexPath *)proposedDestinationIndexPath;

// Indentation

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies

// Copy/Paste.  All three methods must be implemented by the delegate.

//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;

@end
