//
//  NumberPickerViewController.h
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 04/03/16.
//  Copyright © 2016 Lakshmi Narasimma KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberPickerViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
