#import "./UIKeyboardDockItem.h"
#import "./UIKeyboardDockItemButton.h"
#import <Cephei/HBPreferences.h>

static HBPreferences *preferences;

@interface UIKeyboardImpl : UIView
+(id)sharedInstance;
@end

@interface UIKeyboardDockView
@property (nonatomic, retain) UIKeyboardDockItem * centerDockItem;
@property (nonatomic, retain) UIKeyboardDockItem * leftDockItem;
-(void)_dockItemButtonWasTapped:(id)arg1 withEvent:(id)arg2 ;
-(UIKeyboardDockItem *)leftDockItem;
-(void)copyAction;
@end

UIKeyboardDockItem *centerItem;
UIKeyboardDockItemButton *centerItemButton;

%hook UIKeyboardDockView
-(void)setCenterDockItem:(UIKeyboardDockItem *)arg1 {
	if ([preferences boolForKey:@"enabled"]) {
		centerItem = [[%c(UIKeyboardDockItem) alloc] initWithImageName:@"paperclip" identifier:@"paperclip"];
		[centerItem.view addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
		%orig(centerItem);
	} else {
		%orig;
	}
}
%new
-(void)copyAction {
	if ([preferences boolForKey:@"customText"]) {
		[[%c(UIKeyboardImpl) sharedInstance] insertText:[preferences objectForKey:@"text"]];
		NSLog(@"pasted custom text");
	} else {
		UIPasteboard *pb = [UIPasteboard generalPasteboard];
		[[%c(UIKeyboardImpl) sharedInstance] insertText:[pb string]];
		NSLog(@"paste");
	}
}
-(id)_keyboardLongPressInteractionRegions {
	// Remove long press trackpad gesture thing when holding down on the gap between the emojy and dictation buttons
	if ([preferences boolForKey:@"enabled"]) {
		return nil;
	}
	return %orig;
}
%end

%ctor {
	preferences = [[HBPreferences alloc] initWithIdentifier:@"com.chr1s.copyKeyPrefs"];
}