//
//  RemoteNotificationDeepLink.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/27/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

let RemoteNotificationDeepLinkAppSectionKey: String = "Direction"
let RemoteNotificationDeepLinkAppTokenKey: String = "DeepLinkToken"

class RemoteNotificationDeepLink: NSObject {
    var article : String = ""
    var token: String = ""
    class func create(userInfo: [String: String]) -> RemoteNotificationDeepLink?
    {
        let info = userInfo as NSDictionary
        let articleID = info[RemoteNotificationDeepLinkAppSectionKey] as! String
        let tokenStr = info[RemoteNotificationDeepLinkAppTokenKey] as! String
        var ret : RemoteNotificationDeepLink? = nil
        if !articleID.isEmpty
        {
            ret = RemoteNotificationDeepLinkArticle(articleStr: articleID, token: tokenStr)
        }
        return ret
    }
    
    private override init()
    {
        self.article = ""
        self.token = ""
        super.init()
    }
    
    init(articleStr: String, token: String)
    {
        self.article = articleStr
        self.token = token
        super.init()
    }
    
    final func trigger()
    {
        DispatchQueue.main.async {
            //NSLog("Triggering Deep Link - %@", self)
            self.triggerImp()
                { (passedData) in
                    // do nothing
            }
        }
    }
    
    func triggerImp(completion: ((AnyObject?)->(Void)))
    {
        
        completion(nil)
    }
    
}

class RemoteNotificationDeepLinkArticle : RemoteNotificationDeepLink
{
    var articleID : String!
    var tokenStr: String!
    
    override init(articleStr: String, token: String)
    {
        super.init(articleStr: articleStr, token: token)
        self.articleID = articleStr
        self.tokenStr = token
    }
    
    override func triggerImp(completion: ((AnyObject?)->(Void)))
    {
        super.triggerImp()
            { (passedData) in
                // Handle Deep Link Data to present the Article passed through
                
//                var canRedirect = true
//                if UIUtils.getObjectFromUserDefault(KEYS.USER_SIGNUP_INFO) != nil {
//                    let user = (UIUtils.getObjectFromUserDefault(KEYS.USER_SIGNUP_INFO) as? User)!
//                    if !(user.token == "" || user.token == nil) {
//                        canRedirect = false
//                    }
//
//                }
                
//                if !canRedirect {
//                    completion(nil)
//                    return
//                }
                
                if self.articleID == "resetpass"
                {
//                    let vc = UIUtils.viewControllerWithIndentifier(identifier: "ResetPasswordViewController", storyboardName: "Authen") as! ResetPasswordViewController
//                    vc.deepLinkToken = token
//                    let nav = UINavigationController(rootViewController: vc)
//                    nav.isNavigationBarHidden = true
//                    AppDelegate.shareInstance.setRootViewController(nav)
                    
                } else if self.articleID == "approvecode" {
//                    let vc = UIUtils.viewControllerWithIndentifier(identifier: "InputApproveCodeViewController", storyboardName: "Authen") as! InputApproveCodeViewController
//                    vc.deepLinkToken = token
//                    let nav = UINavigationController(rootViewController: vc)
//                    nav.isNavigationBarHidden = true
//                    
//                    AppDelegate.shareInstance.setRootViewController(nav)
                }
                completion(nil)
        }
    }
    
}
