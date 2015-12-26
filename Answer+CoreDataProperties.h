//
//  Answer+CoreDataProperties.h
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 29/11/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Answer.h"

NS_ASSUME_NONNULL_BEGIN

@interface Answer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *answerOption;
@property (nullable, nonatomic, retain) NSNumber *correctAnswer;
@property (nullable, nonatomic, retain) Question *question;

@end

NS_ASSUME_NONNULL_END
