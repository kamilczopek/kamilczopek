//
//  Crossword.h
//  CrosswordSolver
//
//  Created by Kamil Czopek on 04.12.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Crossword : NSManagedObject

@property (nonatomic) int64_t identifier;
@property (nonatomic) int64_t length;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * definition;

@end
