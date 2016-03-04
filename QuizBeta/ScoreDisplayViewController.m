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
    [self.scoreDisplayLabel setText:[NSString stringWithFormat:@"Congrats..!! Your Score is %i",self.finalScore]];
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
        // share to Facebook
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
        } else {
            NSLog(@"Twitter account is not available in your phone");
        }
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


@end
