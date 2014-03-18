# SMReactiveRestKit

[![Pod Version](http://cocoapod-badges.herokuapp.com/v/SMReactiveRestKit/badge.png)](http://cocoadocs.org/docsets/SMReactiveRestKit)
[![Pod Platform](http://cocoapod-badges.herokuapp.com/p/SMReactiveRestKit/badge.png)](http://cocoadocs.org/docsets/SMReactiveRestKit)

SMReactiveRestKit brings all the power of [RestKit](https://github.com/RestKit/RestKit) into [ReactiveCocoa](https://github.com/RestKit/RestKit) world. It wraps RKObjectManager into a signal that can be subscribed to.


## Usage

Base use:

```  objective-c
RKObjectManager* objectManager;
[[objectManager rac_getPath:@"yourPath" parameters:@{@"param1":@"value1"} ]
				subscribeNext:^(RKMappingResult* mapping) {
         			if (mapping) {
             			NSLog(@"%@",mapping);
         			}
     			}
];

```
You can also send a multipart dictionary to your server and map back the result, see examples and documentation for more detailed info.

To run the example project; clone the repo, and run `pod install` from the Example directory first.

Contributions are REALLY welcome!

## Installation

SMReactiveRestKit is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile 

   	pod 'SMReactiveRestKit'

It will also automatically import pods for RestKit, ReactiveCocoa and libextobjc/EXTScope

## Author

Stefano Mondino, stefano.mondino.dev@gmail.com

## License

SMReactiveRestKit is available under the MIT license. See the LICENSE file for more info.
