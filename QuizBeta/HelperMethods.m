//
//  HelperMethods.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 31/12/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import "HelperMethods.h"

@implementation HelperMethods

+ (NSNumber *) getFileVersionInPath : (NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *versionData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!error) {
        NSNumber *versionNumber = versionData[@"version"];
        return versionNumber;
    } else {
        return nil;
    }
}

+ (NSString *) applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return (paths.count) ? paths[0] : nil;
}

+ (BOOL) cleanUpCoreDataWithContext : (NSManagedObjectContext *) context {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    NSArray *questions = [context executeFetchRequest:request error:&error];
    if (!error) {
        for (Question *q in questions) {
            [context deleteObject:q];
        }
        NSError *saveError;
        [context save:&saveError];
        if (!saveError) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}



@end
