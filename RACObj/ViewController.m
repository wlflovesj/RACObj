//
//  ViewController.m
//  RACObj
//
//  Created by 王龙飞 on 2019/11/11.
//  Copyright © 2019 王龙飞. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>

@interface ViewController ()


@property (assign, nonatomic) NSInteger time;
@property(nonatomic,strong)UIButton *button;
@property(strong, nonatomic)RACDisposable *dispoable;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initButton];
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        return nil;
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        
    }];
//    [self.testTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    RACSignal *keyWillShowNotification = [[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillShowNotification object:nil] map:^id _Nullable(NSNotification * _Nullable value) {
        NSDictionary* userInfo = [value userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        return [NSNumber numberWithFloat:[aValue CGRectValue].size.height];
      
    }] ;
    @weakify(self)
    [[[[[[NSNotificationCenter.defaultCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil] map:^id _Nullable(NSNotification * _Nullable value) {
        return [NSNumber numberWithInt:0];
    }] merge:keyWillShowNotification] takeUntil:self.rac_willDeallocSignal] distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        
       
        NSLog(@"%@",x);
    }];
    
  
    [self blockFunc:^NSInteger(NSInteger d) {
        NSLog(@"%ld",(long)d);
        return 5;
    }];

    // Do any additional setup after loading the view.
    
   
}
-(void)blockFunc:(NSInteger(^)(NSInteger d))block{
    block(1);
}


-(void)initButton{
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(100, 200, 200, 30);
    self.button.backgroundColor = UIColor.brownColor;
    [self.button setTintColor:UIColor.cyanColor];
    [self.button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    @weakify(self)
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.enabled = false;
        self.time = 50;
        self.dispoable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            self.time --;
            NSString * title = self.time > 0 ?[NSString stringWithFormat:@"请等待%ld秒后重试",(long)self.time] : @"获取验证码";
            self.button.enabled = (self.time == 0) ? YES : NO;
            [self.button setTitle:title forState:UIControlStateNormal];
            if (self.time == 0) {
                [self.dispoable dispose];
            }
        }];
        
    }];
}

@end
