//
//  QuestionDetailViewController.h
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 19/12/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionDetailViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSString *topic;

@property (nonatomic) NSInteger qCount;

@end
