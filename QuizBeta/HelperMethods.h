//
//  HelperMethods.h
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 31/12/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question+CoreDataProperties.h"
#import "Answer+CoreDataProperties.h"

@interface HelperMethods : NSObject

+ (NSNumber *) getFileVersionInPath : (NSString *)filePath;
+ (NSString *) applicationDocumentsDirectory;
+ (BOOL) cleanUpCoreDataWithContext : (NSManagedObjectContext *) context;

@end
