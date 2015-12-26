//
//  Question+CoreDataProperties.h
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 29/11/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Question.h"

NS_ASSUME_NONNULL_BEGIN

@interface Question (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *topic;
@property (nullable, nonatomic, retain) NSString *stem;
@property (nullable, nonatomic, retain) NSSet<Answer *> *answers;

@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(Answer *)value;
- (void)removeAnswersObject:(Answer *)value;
- (void)addAnswers:(NSSet<Answer *> *)values;
- (void)removeAnswers:(NSSet<Answer *> *)values;

@end

NS_ASSUME_NONNULL_END
