//
//  Crossword+CoreData_CRUD.m
//  CrosswordSolver
//
//  Created by Kamil Czopek on 04.12.2014.
//  Copyright (c) 2014 Kamil Czopek. All rights reserved.
//

#import "Crossword+CoreData_CRUD.h"

@implementation Crossword (CoreData_CRUD)

+ (Crossword *)crosswordWithCrosswordTO:(CrosswordTO*)crosswordTO inManagedObjectContext:(NSManagedObjectContext *)context
{
    Crossword *crossword = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Crossword"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %ld", crosswordTO.identifier];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    }
    else if ([matches count]) {
        crossword = [matches firstObject];
        crossword.length = crosswordTO.length;
        crossword.word = crosswordTO.word;
        crossword.definition = crosswordTO.definition?crosswordTO.definition:@"";
    }
    else {
        NSLog(@"Creating new crossword");
        crossword = [NSEntityDescription insertNewObjectForEntityForName:@"Crossword" inManagedObjectContext:context];
        
        crossword.identifier = crosswordTO.identifier;
        crossword.length = crosswordTO.length;
        crossword.word = crosswordTO.word;
        crossword.definition = crosswordTO.definition?crosswordTO.definition:@"";
    }
    
    return crossword;
}

+ (NSArray*)loadCrosswordsFromCrosswordsTOArray:(NSArray *)crosswordTOsArray intoManagedObjectContext:(NSManagedObjectContext *)context
{
    // TODO: Do optimize this method so that it doesn't perform that many db fetches !!!
    NSMutableArray *crosswords = [[NSMutableArray alloc] init];
    for (CrosswordTO *crosswordTO in crosswordTOsArray){
        Crossword *crossword = [self crosswordWithCrosswordTO:crosswordTO inManagedObjectContext:context];
        [crosswords addObject:crossword];
    }
    
    NSError *error;
    [context save:&error];
    
    return crosswords;
}

@end
