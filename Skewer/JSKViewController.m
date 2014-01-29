//
//  JSKViewController.m
//  Skewer
//
//  Created by Joshua Kaden on 1/29/14.
//  Copyright (c) 2014 Chadford Software. All rights reserved.
//

#import "JSKViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface JSKViewController () {
    UIView *_containerView;
    UIView *_redView;
    CGFloat _redWidth;
    CGFloat _redHeight;
    UIView *_guideView;
    UISlider *_anchorXSlider;
    CGFloat _anchorX;
    UILabel *_anchorLabel;
    UISlider *_positionXSlider;
    CGFloat _positionX;
    UILabel *_positionLabel;
    UISlider *_angleSlider;
    CGFloat _angle;
    UILabel *_angleLabel;
    UILabel *_redLabel;
}

- (void)anchorXSliderValueChanged:(id)sender;
- (void)positionXSliderValueChanged:(id)sender;
- (void)angleSliderValueChanged:(id)sender;
- (NSString *)buildAnchorLabelText;
- (NSString *)buildPositionLabelText;
- (NSString *)buildAngleLabelText;

- (void)fold;

@end

@implementation JSKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    _redWidth = 200.0;
    _redHeight = 200.0;
    
    _containerView = ({
        CGPoint t_origin = CGPointMake(CGRectGetMidX(self.view.bounds) - (_redWidth / 2.0), CGRectGetMidY(self.view.bounds) - (_redHeight / 2.0) - 80.0);
        CGRect t_frame = CGRectMake(t_origin.x, t_origin.y, _redWidth, _redHeight);
        UIView *t_view = [[UIView alloc] initWithFrame:t_frame];
        [self.view addSubview:t_view];
        t_view;
    });
    
    _redView = ({
        CGRect t_frame = CGRectMake(0.0, 0.0, _redWidth, _redHeight);
        UIView *t_view = [[UIView alloc] initWithFrame:t_frame];
        t_view.backgroundColor = [UIColor redColor];
        t_view.alpha = 0.5;
        [_containerView addSubview:t_view];
        t_view;
    });
    
    _redLabel = ({
        UILabel *t_label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, _redView.bounds.size.width, _redView.bounds.size.height)];
        t_label.text = NSLocalizedString(@"abc", @"abc");
        t_label.font = [UIFont fontWithName:@"GillSans" size:70.0];
        t_label.textAlignment = NSTextAlignmentCenter;
        [_redView addSubview:t_label];
        t_label;
    });
    
    _guideView = ({
        UIView *t_view = [[UIView alloc] initWithFrame:_redView.frame];
        t_view.layer.borderWidth = 1.0;
        [_containerView addSubview:t_view];
        t_view;
    });
    
    _anchorXSlider = ({
        CGRect t_frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y + _containerView.frame.size.height + 50.0, _containerView.frame.size.width, 50.0);
        UISlider *t_slider = [[UISlider alloc] initWithFrame:t_frame];
        t_slider.maximumValue = 1.5;
        t_slider.minimumValue = -0.5;
        t_slider.value = 0.5;
        _anchorX = 0.5;
        [t_slider addTarget:self action:@selector(anchorXSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:t_slider];
        t_slider;
    });
    
    _anchorLabel = ({
        CGRect t_frame = CGRectMake(_anchorXSlider.frame.origin.x, _anchorXSlider.frame.origin.y - 20.0, _anchorXSlider.frame.size.width, 20.0);
        UILabel *t_label = [[UILabel alloc] initWithFrame:t_frame];
        t_label.text = [self buildAnchorLabelText];
        [self.view addSubview:t_label];
        t_label;
    });
    
    _positionXSlider = ({
        CGRect t_frame = CGRectMake(_anchorXSlider.frame.origin.x, _anchorXSlider.frame.origin.y + _anchorXSlider.frame.size.height + 20.0, _anchorXSlider.frame.size.width, 50.0);
        UISlider *t_slider = [[UISlider alloc] initWithFrame:t_frame];
        t_slider.maximumValue = _redWidth + (_redWidth / 2.0);
        t_slider.minimumValue = (_redWidth / 2.0) * -1.0;
        t_slider.value = CGRectGetMidX(_containerView.bounds);
        _positionX = t_slider.value;
        [t_slider addTarget:self action:@selector(positionXSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:t_slider];
        t_slider;
    });
    
    _positionLabel = ({
        CGRect t_frame = CGRectMake(_positionXSlider.frame.origin.x, _positionXSlider.frame.origin.y - 20.0, _positionXSlider.frame.size.width, 20.0);
        UILabel *t_label = [[UILabel alloc] initWithFrame:t_frame];
        t_label.text = [self buildPositionLabelText];
        [self.view addSubview:t_label];
        t_label;
    });
    
    _angleSlider = ({
        CGRect t_frame = CGRectMake(_positionXSlider.frame.origin.x, _positionXSlider.frame.origin.y + _positionXSlider.frame.size.height + 20.0, _positionXSlider.frame.size.width, 50.0);
        UISlider *t_slider = [[UISlider alloc] initWithFrame:t_frame];
        t_slider.maximumValue = 360.0;
        t_slider.minimumValue = -180.0;
        t_slider.value = 0.0;
        _angle = t_slider.value;
        [t_slider addTarget:self action:@selector(angleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:t_slider];
        t_slider;
    });
    
    _angleLabel = ({
        CGRect t_frame = CGRectMake(_angleSlider.frame.origin.x, _angleSlider.frame.origin.y - 20.0, _angleSlider.frame.size.width, 20.0);
        UILabel *t_label = [[UILabel alloc] initWithFrame:t_frame];
        t_label.text = [self buildAngleLabelText];
        [self.view addSubview:t_label];
        t_label;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fold
{
    CALayer *t_redLayer = _redView.layer;
    
    t_redLayer.position = CGPointMake(_positionX, CGRectGetMidY(_containerView.bounds));
    [t_redLayer setAnchorPoint:CGPointMake(_anchorX, t_redLayer.anchorPoint.y)];
    
    CATransform3D t_redTransform = CATransform3DIdentity;
    t_redTransform.m34 = -0.002;
    t_redTransform = CATransform3DRotate(t_redTransform, _angle * M_PI / 180.0, 0.0, 1.0, 0.0);
    t_redLayer.transform = t_redTransform;
}

- (void)goButtonTapped:(id)sender
{
    [self fold];
}

- (void)anchorXSliderValueChanged:(id)sender
{
    _anchorX = _anchorXSlider.value;
    _anchorLabel.text = [self buildAnchorLabelText];
    [self fold];
}

- (NSString *)buildAnchorLabelText
{
    return [NSString stringWithFormat:@"anchor X: %f", _anchorX];
}

- (void)positionXSliderValueChanged:(id)sender
{
    _positionX = _positionXSlider.value;
    _positionLabel.text = [self buildPositionLabelText];
    [self fold];
}

- (NSString *)buildPositionLabelText
{
    return [NSString stringWithFormat:@"position X: %f", _positionX];
}

- (void)angleSliderValueChanged:(id)sender
{
    _angle = _angleSlider.value;
    _angleLabel.text = [self buildAngleLabelText];
    [self fold];
}

- (NSString *)buildAngleLabelText
{
    return [NSString stringWithFormat:@"angle: %f", _angle];
}

@end
