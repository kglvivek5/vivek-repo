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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
