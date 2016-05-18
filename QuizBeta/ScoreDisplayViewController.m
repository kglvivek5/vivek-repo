//
//  ScoreDisplayViewController.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 20/02/16.
//  Copyright © 2016 Lakshmi Narasimma KG. All rights reserved.
//

#import "ScoreDisplayViewController.h"
#import <Social/Social.h>


@interface ScoreDisplayViewController ()

@property (strong, nonatomic) IBOutlet UILabel *scoreDisplayLabel;

- (IBAction)topicSelectionTapped:(UIButton *)sender;

- (IBAction)shareOptions:(UIButton *)sender;

@property (nonatomic) float scorePercentage;

@end

@implementation ScoreDisplayViewController

@synthesize finalScore;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scorePercentage = 100.0f * self.finalScore / self.totalQuestions;
    [self.scoreDisplayLabel setText:[NSString stringWithFormat:@"Congrats..!! Your Score is %0.2f %%",self.scorePercentage]];
}


- (IBAction)topicSelectionTapped:(UIButton *)sender {
    [self performSegueWithIdentifier:@"displayHome" sender:self];
}

- (IBAction)shareOptions:(UIButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Share the Score to your Friends!!" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // do nothing;
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *fbpost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [fbpost setInitialText:[NSString stringWithFormat:@"Hey there..I was %0.2f %% correct in tech quiz",self.scorePercentage]];
            [self presentViewController:fbpost animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You are not logged onto Facebook" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // do nothing
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweet setInitialText:[NSString stringWithFormat:@"Hey there..I was %0.2f %% correct in tech quiz..",self.scorePercentage]];
            [self presentViewController:tweet animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You are not logged onto Twitter" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // do nothing
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


@end
