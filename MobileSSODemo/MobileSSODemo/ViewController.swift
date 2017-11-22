//
//  ViewController.swift
//  MobileSSODemo
//
//  Created by Antti Laitinen on 21/02/2017.
//  Copyright © 2017 VaultIT. All rights reserved.
//

import UIKit
import MobileSSOFramework
import Alamofire

class ViewController: UIViewController {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var loggedInAsHeader: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var sessionStatusHeader: UILabel!
    @IBOutlet weak var sessionStatusLabel: UILabel!
    @IBOutlet weak var demoEffectLabel: UILabel!
    
    // MARK: Properties
    
    var photo: UIImage? {
        didSet {
            photoView.image = photo
        }
    }
    
    var photoDownloading: Bool = false
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfileUI()
        loginButton.isHidden = true
        
        VITSessionManager.shared.addDelegate(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didResumeSession(session: VITSession) {
        updateProfileUI()
    }
    
    func didLoseSession() {
        updateProfileUI()
    }
    
    func didCompleteLogin(session: VITSession) {
        updateProfileUI()
    }
    
    func didRefreshSession(session: VITSession) {
        updateProfileUI()
    }
    
    func didLogout() {
        photo = nil
        updateProfileUI()
    }
    
    func didLoseNetworkConnectionForSession(session: VITSession) {
        updateProfileUI()
    }
    
    func didRegainNetworkConnectionForSession(session: VITSession) {
        updateProfileUI()
    }
    
    // MARK: Private
    
    private func updateProfileUI() {
        if !VITSessionManager.shared.initialized {
            view.subviews.forEach({$0.alpha = 0})
            return
        }
        
        view.subviews.forEach({$0.alpha = 1})
        
        let session = VITSessionManager.shared.currentSession
        let authorized = session?.isAuthorized ?? false
        let online = session?.isOnline ?? false
        
        nameLabel.text = session?.idTokenPayload?.name
        loginButton.isHidden = authorized
        logoutButton.isHidden = !authorized
        loggedInAsHeader.isHidden = !authorized
        sessionStatusHeader.isHidden = !authorized
        sessionStatusLabel.isHidden = !authorized
        demoEffectLabel.isHidden = demoEffectLabel.isHidden || !authorized
        
        if online {
            sessionStatusLabel.text = "ONLINE"
            sessionStatusLabel.textColor = UIColor.green
        }
        else {
            sessionStatusLabel.text = "OFFLINE"
            sessionStatusLabel.textColor = UIColor.red
        }
        
        if !photoDownloading && VITSessionManager.shared.initialized {
            let qvarnUrl = URL(string: "https://nordic-eid2.qvarnlabs.net")!
            
            if let existingSession = session, let personResourceId = existingSession.idTokenPayload?.personResourceId {
                let url = qvarnUrl.appendingPathComponent("persons").appendingPathComponent(personResourceId).appendingPathComponent("photo")
                photoDownloading = true
                
                Alamofire.request(url, headers: ["Authorization": "Bearer \(existingSession.accessToken)"])
                    .response { response in
                        if response.response?.statusCode == 200 {
                            if let data = response.data {
                                self.photo = UIImage(data: data)
                                self.demoEffectLabel.isHidden = true
                            }
                        }
                        
                        if self.photo == nil {
                            self.photo = #imageLiteral(resourceName: "ProfileDownloadErrorPicture")
                            self.demoEffectLabel.isHidden = false
                            print("Photo download failed! :(")
                        }
                        
                        self.photoDownloading = false
                    }
            }
            else {
                self.photoView.image = nil
            }
        }
    }
    
    // MARK: IBActions
    
    @IBAction func didClickLogin(_ sender: UIButton) {
        VITSessionManager.shared.presentLogin(in: self) { session, error in
            if let error = error {
                print(error)
            }
            else {
                print("Login succesful!")
            }
        }
    }
    
    @IBAction func didClickLogout(_ sender: UIButton) {
        guard let session = VITSessionManager.shared.currentSession else {
            didLogout()
            return
        }
        
        if !session.isOnline {
            let alert = UIAlertController(title: "Offline error", message: "Logout needs online access and you are offline.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            VITSessionManager.shared.logout(in: self)
        }
    }
    
    @IBAction func didClickSessionCheck(_ sender: Any) {
        VITSessionManager.shared.presentSessionCheck(in: self) { session, error in
            if session != nil {
                print("Session was found with session check!")
            }
        }
    }
    
}

extension ViewController: VITSessionManagerDelegate {
    
    func initialized(session: VITSession?) {
        if session != nil {
            print("Session was initialized automatically!")
        }
    }
    
}

