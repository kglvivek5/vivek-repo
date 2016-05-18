//
//  NumberPickerViewController.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 04/03/16.
//  Copyright © 2016 Lakshmi Narasimma KG. All rights reserved.
//

#import "NumberPickerViewController.h"
#import "QuestionDetailViewController.h"
#import "Question+CoreDataProperties.h"
#import "Answer+CoreDataProperties.h"
#import <HTPressableButton.h>
#import <UIColor+HTColor.h>

@interface NumberPickerViewController ()

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic) NSInteger qCount; // gets the total number of question using Core data fetch request
@property (nonatomic) NSInteger selectedQCount; // to store the selected value in the picker

@end

@implementation NumberPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"stem" ascending:YES];
    request.sortDescriptors = @[sort];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topic = %@",self.topic];
    request.predicate = predicate;
    NSArray *ques = [self.context executeFetchRequest:request error:&error];
    self.qCount = [ques count];
    
    CGRect frame = CGRectMake(30, 450, 260, 50);
    HTPressableButton *customButton = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRounded];
    [customButton setTitle:@"Start" forState:UIControlStateNormal];
    customButton.buttonColor = [UIColor ht_midnightBlueColor];
    customButton.shadowColor = [UIColor ht_belizeHoleColor];
    [self.view addSubview:customButton];
    customButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDict = @{@"buttonView":customButton,@"pickerView":self.picker};
    NSArray *pos_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pickerView]-40-[buttonView]" options:0 metrics:nil views:viewDict];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:customButton
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.picker
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:1]];
    [self.view addConstraints:pos_V];
    [customButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Function to handle the button click for the custom button

- (void)buttonClicked {
    [self performSegueWithIdentifier:@"toQuestionDetail" sender:self];
}

#pragma mark - UIPicker Datasource methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.qCount;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld",(row+1)];
}

#pragma mark - UIPicker Delegate Methods

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedQCount = row + 1;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[QuestionDetailViewController class]]) {
        QuestionDetailViewController *qdvc = segue.destinationViewController;
        qdvc.context = self.context;
        qdvc.topic = self.topic;
        // Lazy instantiation for selectedQCount to handle scenario where user do not select any value in picker
        if (!self.selectedQCount) {
            NSInteger row = [self.picker selectedRowInComponent:0];
            qdvc.qCount = row + 1;
        } else {
            qdvc.qCount = self.selectedQCount;
        }
        
    }
}


@end
