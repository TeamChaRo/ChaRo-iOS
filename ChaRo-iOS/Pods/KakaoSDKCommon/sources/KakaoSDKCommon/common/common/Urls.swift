//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

public class Hosts {
    public static let shared = Hosts()
    
    public let kapi : String
    public let dapi : String
    public let auth : String
    public let kauth : String
    public let talkAuth : String
    public let channel : String
    public let talkLink : String
    public let talkLinkVersion : String
    public let sharerLink : String
    
    public init(kapi: String = "kapi.kakao.com",
                dapi: String = "dapi.kakao.com",
                auth: String = "auth.kakao.com",
                kauth: String = "kauth.kakao.com",
                talkAuth: String = "kakaokompassauth",
                channel: String = "pf.kakao.com",
                talkLink: String = "kakaolink",
                talkLinkVersion: String = "kakaotalk-5.9.7",
                sharerLink: String  = "sharer.kakao.com")
    {
        self.kapi = kapi
        self.dapi = dapi
        self.auth = auth
        self.kauth = kauth
        self.talkAuth = talkAuth
        self.channel = channel
        self.talkLink = talkLink
        self.talkLinkVersion = talkLinkVersion
        self.sharerLink = sharerLink
    }
}

public enum HostType {
    case Kapi
    case Dapi
    case Auth
    case Kauth
    case TalkAuth
    case Channel
    case Navi
    case NaviInstall
    case TalkLink
    case TalkLinkVersion
    case SharerLink
    
    public var host: String {
        switch self {
        case .Kapi:
            return "https://\(KakaoSDK.shared.hosts().kapi)"
        case .Dapi:
            return "https://\(KakaoSDK.shared.hosts().dapi)"
        case .Auth:
            return "https://\(KakaoSDK.shared.hosts().auth)"
        case .Kauth:
            return "https://\(KakaoSDK.shared.hosts().kauth)"
        case .TalkAuth:
            return "\(KakaoSDK.shared.hosts().talkAuth)://"
        case .Channel:
            return "https://\(KakaoSDK.shared.hosts().channel)"
        case .Navi:
            return "kakaonavi-sdk://"
        case .NaviInstall:
            return "https://kakaonavi.kakao.com"
        case .TalkLink:
            return "\(KakaoSDK.shared.hosts().talkLink)://"
        case .TalkLinkVersion:
            return "\(KakaoSDK.shared.hosts().talkLinkVersion)://"
        case .SharerLink:
            return "https://\(KakaoSDK.shared.hosts().sharerLink)"
        }
    }
}

public class Paths {
    //kauth
    public static let authAuthorize = "/oauth/authorize"
    public static let authToken = "/oauth/token"
    public static let authAgt = "/api/agt"
    
    public static let authTalk = "authorize"
    
    //kakao accounts
    public static let kakaoAccountsLogin = "/sdks/page"
    
    //user
    public static let signup = "/v1/user/signup"
    public static var userMe = "/v2/user/me"
    public static let userUpdateProfile = "/v1/user/update_profile"
    public static let userAccessTokenInfo = "/v1/user/access_token_info"
    public static let userLogout = "/v1/user/logout"
    public static let userUnlink = "/v1/user/unlink"
    public static let userShippingAddress = "/v1/user/shipping_address"
    public static let userServiceTerms = "/v1/user/service/terms"
    public static let userScopes = "/v2/user/scopes"
    public static let userRevokeScopes = "/v2/user/revoke/scopes"
    
    //talk
    public static let talkProfile = "/v1/api/talk/profile"
    public static let customMemo = "/v2/api/talk/memo/send"
    public static let defaultMemo = "/v2/api/talk/memo/default/send"
    public static let scrapMemo = "/v2/api/talk/memo/scrap/send"    
    public static let channels = "/v1/api/talk/channels"
    
    public static let friends = "/v1/api/talk/friends"
    
    public static let customMessage = "/v1/api/talk/friends/message/send"
    public static let defaultMessage = "/v1/api/talk/friends/message/default/send"
    public static let scrapMessage = "/v1/api/talk/friends/message/scrap/send"
    
    //friend
    public static let selectFriends = "/v1/friends/sdk"
    public static let userScpoes = "/v2/user/scopes/sdk"
    
    public static let selectChats = "/v1/api/talk/chat/list/sdk"
    public static let selectChatMembers = "/v1/api/talk/members/sdk"
    
    //story
    public static let isStoryUser = "/v1/api/story/isstoryuser"
    public static let storyProfile = "/v1/api/story/profile"
    public static let storyLinkInfo = "/v1/api/story/linkinfo"
    
    public static let myStory = "/v1/api/story/mystory"
    public static let myStories = "/v1/api/story/mystories"
    public static let deleteMyStory = "/v1/api/story/delete/mystory"
    
    public static let postNote = "/v1/api/story/post/note"
    public static let postLink = "/v1/api/story/post/link"
    public static let postPhoto = "/v1/api/story/post/photo"
    
    public static let uploadMulti = "/v1/api/story/upload/multi"
    
    //channel
    public static let channel = ""
    
    //kakaonavi
    public static let navigateDestination = "navigate"
    public static let webNaviInstall = "/launch/index.do"
    
    //kakaolink
    public static let talkLink = "send"
    public static let talkLinkVersion = "send"
    
    public static let shareCustomValidate = "/v2/api/kakaolink/talk/template/validate"
    public static let shareScrapValidate = "/v2/api/kakaolink/talk/template/scrap"
    public static let shareDefalutValidate = "/v2/api/kakaolink/talk/template/default"
    
    public static let sharerLink = "/talk/friends/picker/easylink"
    
    public static let shareImageUpload = "/v2/api/talk/message/image/upload"
    public static let shareImageScrap = "/v2/api/talk/message/image/scrap"
    
    //search
    public static let searchCafe = "/v2/search/cafe"
}

public class Urls {
    public static func compose(_ hostType:HostType = .Kapi, path:String) -> String {
        return "\(hostType.host)\(path)"
    }
}
