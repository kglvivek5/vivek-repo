//
//  QuestionDetailViewController.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 19/12/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "Question+CoreDataProperties.h"
#import "Answer+CoreDataProperties.h"
#import "ScoreDisplayViewController.h"

@interface QuestionDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *questionStemLbl;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *optionBtns;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItemLbl;

@property (strong, nonatomic) Question *q; // to store the current question displayed
@property (strong, nonatomic) NSMutableArray *ansList, *correctAnsList; // to store the answer options currently displayed
@property (strong, nonatomic) NSMutableArray *questionList;

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)answerOptionTapped:(UIButton *)sender;

@property (nonatomic) int secondsLeft;
@property (strong, nonatomic) NSTimer *timer;

@property (nonatomic) int score; // to store the score

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *option1Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *option2Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *option3Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *option4Height;


@end

@implementation QuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"stem" ascending:YES];
    request.sortDescriptors = @[sort];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topic = %@",self.topic];
    request.predicate = predicate;
    NSArray *ques = [self.context executeFetchRequest:request error:&error];
    self.questionList = [ques mutableCopy];
    self.score = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self populateUI];
}

-(void)updateViewConstraints {
    [super updateViewConstraints];
    if ([UIScreen mainScreen].bounds.size.height == 736.0f) {
        self.option1Height.constant = 100;
        self.option2Height.constant = 100;
        self.option3Height.constant = 100;
        self.option4Height.constant = 100;
    } else if ([UIScreen mainScreen].bounds.size.height == 667.0f) {
        self.option1Height.constant = 100;
        self.option2Height.constant = 100;
        self.option3Height.constant = 100;
        self.option4Height.constant = 100;
    } else if ([UIScreen mainScreen].bounds.size.height == 480.0f) {
        self.option1Height.constant = 60;
        self.option2Height.constant = 60;
        self.option3Height.constant = 60;
        self.option4Height.constant = 60;
    } else {
        self.option1Height.constant = 75;
        self.option2Height.constant = 75;
        self.option3Height.constant = 75;
        self.option4Height.constant = 75;
    }
}

- (void)populateUI {
    [self populateBarButtonText];
    [self setOptionButtonsReadOnlyWithBoolValue:YES];
    int randNum = arc4random_uniform((int)[self.questionList count]);
    if ([self.questionList count] > 0) {
        self.q = self.questionList[randNum];
        self.questionStemLbl.text = self.q.stem;
        self.ansList = [[NSMutableArray alloc] init];
        self.correctAnsList = [[NSMutableArray alloc] init];
        for (Answer *ans in self.q.answers) {
            [self.ansList addObject:ans.answerOption];
            [self.correctAnsList addObject:ans.correctAnswer];
        }
        NSUInteger i = 0;
        for (UIButton *button in self.optionBtns) {
            [button setTitle:self.ansList[i] forState:UIControlStateNormal];
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            button.titleLabel.numberOfLines = 3;
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            button.tag = i;
            [button setBackgroundColor:[UIColor colorWithRed:155.0/255.0
                                                       green:252.0/255.0
                                                        blue:247.0/255.0
                                                       alpha:1.0]];
            i++;
        }
        [self.questionList removeObjectAtIndex:randNum];
    } else {
        [self performSegueWithIdentifier:@"displayScore" sender:self];
    }
    self.secondsLeft = 30;
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES];

}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"displayScore"] && [segue.destinationViewController isKindOfClass:[ScoreDisplayViewController class]]) {
        ScoreDisplayViewController *scoreVC = segue.destinationViewController;
        scoreVC.finalScore = self.score;
    }
}

- (void)updateTimer {
    int seconds;
    seconds = self.secondsLeft % 60;
    if (seconds == 0) {
        [self setOptionButtonsReadOnlyWithBoolValue:NO];
        [self.timer invalidate];
    }
    NSString *timeMessage = [NSString stringWithFormat:@"Time left : %02d seconds",seconds];
    self.navigationItem.title = timeMessage;
    self.secondsLeft--;
    
}

- (void)populateBarButtonText {
    if ([self.questionList count] > 1) {
        [self.nextBarButtonItemLbl setTitle:@"Next"];
    } else {
        [self.nextBarButtonItemLbl setTitle:@"End"];
    }
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    [self populateUI];
}

- (IBAction)answerOptionTapped:(UIButton *)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        NSUInteger index = [self.correctAnsList indexOfObject:@1];
        if (sender.tag == index) {
            [sender setBackgroundColor:[UIColor colorWithRed:5.0/255.0
                                                       green:198.0/255.0
                                                        blue:92.0/255.0
                                                       alpha:1.0]];
            [self setOptionButtonsReadOnlyWithBoolValue : NO];
            self.score += 10;
        } else {
            [sender setBackgroundColor:[UIColor colorWithRed:198.0/255.0
                                                       green:5.0/255.0
                                                        blue:14.0/255.0
                                                       alpha:1.0]];
            [self setOptionButtonsReadOnlyWithBoolValue : NO];
        }
    }
    
}

- (void) setOptionButtonsReadOnlyWithBoolValue : (BOOL) value {
    for (UIButton *button in self.optionBtns) {
        button.enabled = value;
    }
}

@end
