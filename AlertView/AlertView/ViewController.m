//
//  ViewController.m
//  AlertView
//

//

#import "ViewController.h"
#import "YAAlertStyleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
     YAAlertStyleView *view1 = [YAAlertStyleView showAlertWithTitle:@"哈哈哈" message:@"属地化是" perferStyle:(YAAlertViewStyleAlert) cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] clickBlock:^(NSInteger buttonIndex) {
        NSLog(@"%@", [NSString stringWithFormat:@"点击了%ld",buttonIndex]);
    }];
    
    [view1 setButtonTitleColor:[UIColor redColor] forState:UIControlStateNormal atIndex:0];
    
    YAAlertStyleView *view2 = [YAAlertStyleView showAlertWithTitle:@"哈哈哈" message:@"属地化是" perferStyle:(YAAlertViewStyleActionSheet) cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] clickBlock:^(NSInteger buttonIndex) {
        NSLog(@"%@", [NSString stringWithFormat:@"点击了%ld",buttonIndex]);
    }];
    
    view2.cancelBtnBgColor = [UIColor redColor];
    view2.cancelBtnTitleColor = [UIColor whiteColor];
    
    [view2 setButtonTitleColor:[UIColor purpleColor] forState:UIControlStateNormal atIndex:0];
}
@end
