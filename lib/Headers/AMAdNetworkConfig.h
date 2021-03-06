/*
 
 AdNetwork.h
 
 Copyright 2009 AdMob, Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

*/

#import <Foundation/Foundation.h>
#import "AMDelegateProtocol.h"

#define AMAdNetworkConfigKeyType      @"type"
#define AMAdNetworkConfigKeyNID       @"nid"
#define AMAdNetworkConfigKeyName      @"nname"
#define AMAdNetworkConfigKeyWeight    @"weight"
#define AMAdNetworkConfigKeyPriority  @"priority"
#define AMAdNetworkConfigKeyCred      @"key"

@class AMError;
@class AMAdNetworkRegistry;

@interface AMAdNetworkConfig : NSObject {
  NSInteger networkType;
  NSString *nid;
  NSString *networkName;
  double trafficPercentage;
  NSInteger priority;
  NSDictionary *credentials;
  Class adapterClass;
}

- (id)initWithDictionary:(NSDictionary *)adNetConfigDict
       adNetworkRegistry:(AMAdNetworkRegistry *)registry
                   error:(AMError **)error;

@property (nonatomic,readonly) NSInteger networkType;
@property (nonatomic,readonly) NSString *nid;
@property (nonatomic,readonly) NSString *networkName;
@property (nonatomic,readonly) double trafficPercentage;
@property (nonatomic,readonly) NSInteger priority;
@property (nonatomic,readonly) NSDictionary *credentials;
@property (nonatomic,readonly) NSString *pubId;
@property (nonatomic,readonly) Class adapterClass;

@end
