//
//  SKWWebRTCStatsReport.mm
//  SkyWay
//
//  Created by Naoto Takahashi on 2023/02/27.
//  Copyright © 2023 NTT Communications. All rights reserved.
//

#import "SKWWebRTCStatsReport+Internal.h"
#import "NSString+StdString.h"
#import "WebRTC/WebRTC.h"

@implementation SKWWebRTCStatsReport

-(id _Nonnull)initWithNativeReport:(skyway::model::WebRTCStatsReport)report {
      if(self = [super init]) {
          _id = [NSString stringForStdString:report.id];
          _type = [NSString stringForStdString:report.type];
          NSMutableDictionary<NSString*, NSObject*>* params = [NSMutableDictionary dictionary];
          for(const auto& param : report.params) {
              NSString* key = [NSString stringForStdString:param.first];
              NSObject* data = nil;
              switch(param.second.type()) {
                  case nlohmann::detail::value_t::string:
                      data = [NSString stringForStdString:param.second.get<std::string>()];
                      break;
                  case nlohmann::detail::value_t::boolean:
                      data = [NSNumber numberWithBool:param.second.get<bool>()];
                      break;
                  case nlohmann::detail::value_t::number_integer:
                      data = [NSNumber numberWithInt:param.second.get<int>()];
                      break;
                  case nlohmann::detail::value_t::number_unsigned:
                      data = [NSNumber numberWithUnsignedInt:param.second.get<uint32_t>()];
                      break;
                  case nlohmann::detail::value_t::number_float:
                      data = [NSNumber numberWithFloat:param.second.get<float>()];
                      break;
                  case nlohmann::detail::value_t::object:
                  case nlohmann::json::value_t::array:{}
                      data = [[NSString stringForStdString:param.second.dump()] dataUsingEncoding:NSUTF8StringEncoding];
                      break;
                  case nlohmann::detail::value_t::null:
                  case nlohmann::detail::value_t::discarded:
                      break;
              }
              params[key] = data;
          }
          _params = params;
      }
      return self;
}

@end

