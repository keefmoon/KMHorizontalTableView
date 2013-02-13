//
//  KMIndexPath.m
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import "KMIndexPath.h"

@implementation KMIndexPath

- (id)initWithRowSection:(NSInteger)rowSection columnSection:(NSInteger)columnSection row:(NSInteger)row andColumn:(NSInteger)column;
{
    self = [super init];
    if (self) {
        
        _rowSection = rowSection;
        _columnSection = columnSection;
        _row = row;
        _column = column;
    }
    return self;
}

+ (KMIndexPath *)indexPathWithRowSection:(NSInteger)rowSection columnSection:(NSInteger)columnSection row:(NSInteger)row andColumn:(NSInteger)column
{
    return [[KMIndexPath alloc] initWithRowSection:rowSection columnSection:columnSection row:row andColumn:column];
}

+ (KMIndexPath *)indexPathWithIndexPath:(KMIndexPath *)indexPath
{
    return [KMIndexPath indexPathWithRowSection:indexPath.rowSection columnSection:indexPath.columnSection row:indexPath.row andColumn:indexPath.column];
}

@end
