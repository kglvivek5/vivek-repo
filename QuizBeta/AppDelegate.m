//
//  AppDelegate.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 29/11/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import "AppDelegate.h"
#import "Question+CoreDataProperties.h"
#import "Answer+CoreDataProperties.h"
#import "SettingsViewController.h"
#import "HelperMethods.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext: self.managedObjectContext];
//    Answer *answer1 = [NSEntityDescription insertNewObjectForEntityForName:@"Answer" inManagedObjectContext:self.managedObjectContext];
//    Answer *answer2 = [NSEntityDescription insertNewObjectForEntityForName:@"Answer" inManagedObjectContext:self.managedObjectContext];
//    question.stem = @"What is Java?";
//    question.topic = @"JAVA";
//    
//    answer1.answerOption = @"It is a Language";
//    answer1.correctAnswer = @1;
//    
//    answer2.answerOption = @"It is the name of a Coffee";
//    answer2.correctAnswer = @0;
//    
//    [question addAnswersObject:answer1];
//    [question addAnswersObject:answer2];
//    NSError *error;
//    [self.managedObjectContext save:&error];
//
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:@"isFirstTimeLaunch"] == NO) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"json" inDirectory:@"Data"];
        [settings loadCoreDataFromJSONFile:filePath inManagedObjectContext:self.managedObjectContext];
        [userDefaults setObject:[HelperMethods getFileVersionInPath:filePath] forKey:FILE_VERSION];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:[[HelperMethods applicationDocumentsDirectory] stringByAppendingPathComponent:@"Questions.json"] error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
        /* if (filePath) {
            NSData *questionData = [[NSData alloc] initWithContentsOfFile:filePath];
            NSError *error;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:questionData options:0 error:&error];
            if (error) {
                NSLog(@"Something is wrong : %@",error.localizedDescription);
            } else {
                NSArray *questions = jsonData[@"questions"];
                for (NSDictionary *ques in questions) {
                    // Load Question object from JSON into Core data
                    NSDictionary *qDetails = [ques objectForKey:@"question"];
                    Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:self.managedObjectContext];
                    question.topic = [qDetails objectForKey:@"topic"];
                    question.stem = [qDetails objectForKey:@"stem"];
                    
                    // Load Answer object from JSON into Core data
                    NSArray *ansDetails = [ques objectForKey:@"answers"];
                    for (NSDictionary *aDetail in ansDetails) {
                        Answer *answer = [NSEntityDescription insertNewObjectForEntityForName:@"Answer" inManagedObjectContext:self.managedObjectContext];
                        answer.answerOption = [aDetail objectForKey:@"answerOption"];
                        answer.correctAnswer = [aDetail objectForKey:@"correctAnswer"];
                        [question addAnswersObject:answer];
                    }
                    NSError *error;
                    [self.managedObjectContext save:&error];
                }
            }
        } else {
            NSLog(@"File not found");
        } */
        [userDefaults setBool:YES forKey:@"isFirstTimeLaunch"];
        [userDefaults synchronize];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.edu.vivek.QuizBeta" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"QuizBeta" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"QuizBeta.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
