#include "CPKRootListController.h"
#import <objc/runtime.h>

@implementation CPKRootListController

-(void)loadView {
	[super loadView];
    // Dismiss keyboard when background is tapped
	((UITableView *)[self table]).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

-(void)_returnKeyPressed:(id)arg1 {
	// Dismiss keyboard when return key pressed
	[self.view endEditing:YES];
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)respring {
	[HBRespringController respring];
}

-(void)discord {
	NSURL *discord = [NSURL URLWithString:@"https://discord.gg/zHN7yuGqYr"];
	[[UIApplication sharedApplication] openURL:discord options:@{} completionHandler:nil];
}

-(void)paypal {
	NSURL *paypal = [NSURL URLWithString:@"https://paypal.me/chr1sdev"];
	[[UIApplication sharedApplication] openURL:paypal options:@{} completionHandler:nil];
}

@end
