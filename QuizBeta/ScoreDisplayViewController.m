//
//  ScoreDisplayViewController.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 20/02/16.
//  Copyright © 2016 Lakshmi Narasimma KG. All rights reserved.
//

#import "ScoreDisplayViewController.h"

@interface ScoreDisplayViewController ()

@property (strong, nonatomic) IBOutlet UILabel *scoreDisplayLabel;

- (IBAction)topicSelectionTapped:(UIButton *)sender;

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


@end
