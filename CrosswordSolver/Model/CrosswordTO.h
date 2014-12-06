//
//  CrosswordTO.h
//  CrosswordSolver
//
//  Created by Kamil Czopek on 30.11.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrosswordTO : NSObject

@property (nonatomic) NSUInteger identifier;
@property (nonatomic) NSUInteger length;
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *definition;

@end
