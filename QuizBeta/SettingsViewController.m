//
//  SettingsViewController.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 27/12/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import "SettingsViewController.h"
#import "Question+CoreDataProperties.h"
#import "Answer+CoreDataProperties.h"
#import "HelperMethods.h"

@interface SettingsViewController ()

- (IBAction)updateFileBtnPressed:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateFileBtnPressed:(UIButton *)sender {
    NSURL *dataURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/rt7cfry8m1od18d/Questions.json?dl=0"];
    [self getJSONDataAtURL:dataURL];
}

- (void) getJSONDataAtURL: (NSURL *) urlWithJSON {
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Download the file in background
        NSData *data = [NSData dataWithContentsOfURL:urlWithJSON];
        [self saveJSONWithData: data];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *alertMsg;
            if ([self isNewVersionFoundInFile:[HelperMethods applicationDocumentsDirectory]]) {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[HelperMethods getFileVersionInPath:[[HelperMethods applicationDocumentsDirectory] stringByAppendingPathComponent:QUESTIONS_FILE_NAME]] forKey:FILE_VERSION];
                [HelperMethods cleanUpCoreDataWithContext: self.context];
                [self loadCoreDataFromJSONFile: [[HelperMethods applicationDocumentsDirectory] stringByAppendingPathComponent:QUESTIONS_FILE_NAME] inManagedObjectContext: self.context];
                alertMsg = @"Check out the newly added questions!!!";
            } else {
                alertMsg = @"You already have the latest questions!!!";
            }
            [self.activityIndicator stopAnimating];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Question update status" message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}

- (void) saveJSONWithData: (NSData *) data {
    NSString *path = [[HelperMethods applicationDocumentsDirectory] stringByAppendingPathComponent:@"Questions.json"];
    NSError *error;
    BOOL success = [data writeToFile:path options:NSDataWritingAtomic error:&error];
    NSLog(@"Success :%d, Failure :%@",success, error);
}

- (BOOL) isNewVersionFoundInFile: (NSString *) filePath {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *versionNumber = [userDefaults objectForKey:FILE_VERSION];
    if ([versionNumber isEqualToNumber:[HelperMethods getFileVersionInPath:[filePath stringByAppendingPathComponent:@"Questions.json"]]]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) loadCoreDataFromJSONFile:(NSString *) filePath inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext {
    if (filePath) {
        NSData *questionData = [[NSData alloc] initWithContentsOfFile:filePath];
        NSError *error;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:questionData options:0 error:&error];
        if (error) {
            NSLog(@"Something is wrong : %@",error.localizedDescription);
            return NO;
        } else {
            NSArray *questions = jsonData[@"questions"];
            for (NSDictionary *ques in questions) {
                // Load Question object from JSON into Core data
                NSDictionary *qDetails = [ques objectForKey:@"question"];
                Question *question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:managedObjectContext];
                question.topic = [qDetails objectForKey:@"topic"];
                question.stem = [qDetails objectForKey:@"stem"];
                
                // Load Answer object from JSON into Core data
                NSArray *ansDetails = [ques objectForKey:@"answers"];
                for (NSDictionary *aDetail in ansDetails) {
                    Answer *answer = [NSEntityDescription insertNewObjectForEntityForName:@"Answer" inManagedObjectContext:managedObjectContext];
                    answer.answerOption = [aDetail objectForKey:@"answerOption"];
                    answer.correctAnswer = [aDetail objectForKey:@"correctAnswer"];
                    [question addAnswersObject:answer];
                }
                NSError *error;
                [managedObjectContext save:&error];
            }
            return YES;
        }
    } else {
        NSLog(@"File not found");
        return NO;
    }
}


@end
