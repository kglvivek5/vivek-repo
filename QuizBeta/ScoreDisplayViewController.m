//
//  ScoreDisplayViewController.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 20/02/16.
//  Copyright © 2016 Lakshmi Narasimma KG. All rights reserved.
//

#import "ScoreDisplayViewController.h"
#import <Social/Social.h>
#import <HTPressableButton.h>
#import <UIColor+HTColor.h>

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
    
    // To Topics button
    CGRect buttonRect = CGRectMake(150, 285, 150, 30);
    HTPressableButton *topicButton = [[HTPressableButton alloc] initWithFrame:buttonRect buttonStyle:HTPressableButtonStyleRounded];
    [topicButton setTitle:@"Topic Selection" forState:UIControlStateNormal];
    topicButton.buttonColor = [UIColor ht_greenSeaColor];
    topicButton.shadowColor = [UIColor ht_emeraldColor];
    [self.view addSubview:topicButton];
    // Auto Layout
    [topicButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topicButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topicButton
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:1]];
    [topicButton addTarget:self action:@selector(navigateToTopicSelection) forControlEvents:UIControlEventTouchUpInside];
    
    // Share button
    CGRect shareRect = CGRectMake(150, 325, 100, 30);
    HTPressableButton *shareButton = [[HTPressableButton alloc] initWithFrame:shareRect buttonStyle:HTPressableButtonStyleRounded];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    shareButton.buttonColor = [UIColor ht_greenSeaColor];
    shareButton.shadowColor = [UIColor ht_emeraldColor];
    [self.view addSubview:shareButton];
    // Auto Layout
    [shareButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:shareButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topicButton
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:1]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:shareButton
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:topicButton
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:20]];
    [shareButton addTarget:self action:@selector(shareToSocialMedia) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void) navigateToTopicSelection {
    [self performSegueWithIdentifier:@"displayHome" sender:self];
}

- (void) shareToSocialMedia {
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
