//
//  KMIndexPath.h
//  HorizontalTableViewExample
//
//  Created by Keith Moon on 24/11/2012.
//  Copyright (c) 2012 Keith Moon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMIndexPath : NSObject

@property (nonatomic, assign) NSInteger rowSection;
@property (nonatomic, assign) NSInteger columnSection;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

- (id)initWithRowSection:(NSInteger)rowSection columnSection:(NSInteger)columnSection row:(NSInteger)row andColumn:(NSInteger)column;
+ (KMIndexPath *)indexPathWithRowSection:(NSInteger)rowSection columnSection:(NSInteger)columnSection row:(NSInteger)row andColumn:(NSInteger)column;
+ (KMIndexPath *)indexPathWithIndexPath:(KMIndexPath *)indexPath;

@end
