//
//  AppDelegate.swift
//  NantesPVB
//
//  Created by Simon Viaud on 17/05/2019.
//  Copyright © 2019 Simon Viaud. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    @objc var loadingView: UIView!
    @objc var connectedMember: Member?
    @objc var loadingLabel: UILabel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabbarController(tabbarController: ())
        self.window?.makeKeyAndVisible()
        
        //  Converted to Swift 5.1 by Swiftify v5.1.13244 - https://objectivec2swift.com/
        loadingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.window?.frame.size.width ?? 400, height: self.window?.frame.size.height ?? 400))
        loadingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loadingView.alpha = 0.0
        window?.addSubview(loadingView)
        
        let whiteView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: loadingView.frame.size.width, height: loadingView.frame.size.height))
        whiteView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        whiteView.alpha = 0.44
        whiteView.backgroundColor = UIColor.white
        loadingView.addSubview(whiteView)
        
        let grayView = UIView(frame: CGRect(x: (loadingView.frame.size.width - 250.0) / 2.0, y: (loadingView.frame.size.height - 100.0) / 2.0, width: 250.0, height: 100.0))
        grayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        grayView.backgroundColor = UIColor.white //kColorBgGray];
        grayView.layer.cornerRadius = 5
        grayView.layer.borderWidth = 1.0
        grayView.layer.borderColor = UIColor.lightGray.cgColor
        loadingView.addSubview(grayView)

        //  Converted to Swift 5.1 by Swiftify v5.1.13244 - https://objectivec2swift.com/
        grayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        grayView.backgroundColor = UIColor.white //kColorBgGray];
        grayView.layer.cornerRadius = 5
        grayView.layer.borderWidth = 1.0
        grayView.layer.borderColor = UIColor.lightGray.cgColor
        loadingView.addSubview(grayView)

        // Nom et prenom
        loadingLabel = UILabel(frame: CGRect(x: 5.0, y: 0.0, width: grayView.frame.size.width - 10.0, height: 60.0))
        loadingLabel!.autoresizingMask = .flexibleWidth
        loadingLabel!.backgroundColor = UIColor.clear
        loadingLabel!.textColor = UIColor.lightGray
        loadingLabel!.textAlignment = .center
        loadingLabel!.numberOfLines = 0
        loadingLabel!.font = UIFont.systemFont(ofSize: 15.0)
        grayView.addSubview(loadingLabel!)

        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = CGPoint(x: 118.0, y: 70.0)
        activityIndicatorView.startAnimating()
        grayView.addSubview(activityIndicatorView)

        updateData()

        return true
    }
    
    func updateData() {
        
        if let events = WSDatas.getEvents(), events.count > 0 {
            EventDao.insertEvents(events)
        }
        
        if let joints = WSDatas.getAppartenances(), joints.count > 0 {
            AppartenancesDAO.insertAppartenances(joints)
        }
        
        let members = WSDatas.getMembers() 
            print("Members called")
            MemberDao.insertMembers(members)
            print("Members saved")
        
        
    }

    func setConnectedMember(member: Member) {
        self.connectedMember = member
    }
    
    @objc func showLoadingView(_ messageParam: String?) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.loadingLabel?.text = messageParam
        loadingView.alpha = 1.0
        UIView.commitAnimations()
    }

    @objc func hideLoadingView() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        loadingView.alpha = 0.0
        UIView.commitAnimations()
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


/*

#define kColorYellow    [UIColor colorWithRed:240.0/255.0 green:193.0/255.0 blue:6.0/255.0 alpha:1.0]
#define kColorTitleGray [UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]
#define kColorTextGray  [UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]
#define kColorBgGray    [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]
#define kColorBgWhite   [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]

#define kColorSceance                   [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:221.0/255.0 alpha:1.0]
#define kColorDivers                    [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:68.0/255.0 alpha:1.0]
#define kColorRencontreEquipeComplete   [UIColor colorWithRed:85.0/255.0 green:170.0/255.0 blue:85.0/255.0 alpha:1.0]
#define kColorRencontreEquipeIncomplete [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:0.0/255.0 alpha:1.0]
#define kColorAnnule                    [UIColor colorWithRed:221.0/255.0 green:17.0/255.0 blue:34.0/255.0 alpha:1.0]
*/
