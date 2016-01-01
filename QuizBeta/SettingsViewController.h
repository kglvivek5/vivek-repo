//
//  SettingsViewController.h
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 27/12/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

- (BOOL) loadCoreDataFromJSONFile: filePath inManagedObjectContext: managedObjectContext;

@end
