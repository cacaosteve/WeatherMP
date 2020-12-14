import UIKit
import OAuthSwift
import Alamofire
import SwiftKeychainWrapper

struct GraphResponseMe: Codable {
    let id, name: String?
}

class ViewController: UIViewController, UINavigationControllerDelegate {
    var count = 0
    var oauthswift: OAuthSwift? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if count == 0 {
            count += 1
            doAuth()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0.0
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }
    
    private func presentAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func doAuth() {
        let oauthswift = OAuth2Swift(
            consumerKey: "732008171068255",
            consumerSecret: "7d090ca45feef4e4820822f268efc0ce",
            authorizeUrl: "https://www.facebook.com/v9.0/dialog/oauth",
            accessTokenUrl: "https://www.facebook.com/v9.0/dialog/oauth/access_token",
            responseType: "token"
        )
        
        self.oauthswift = oauthswift;
        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
    
        guard let rwURL = URL(string: "fb732008171068255://authorize") else { return }
        oauthswift.authorize(withCallbackURL: rwURL, scope: "", state: "state123abc") { (result) in
            switch result {
                
            case .success((let credential, let response, let parameters)):
                print("credential")
                print(credential)
                print("response")
                print(response ?? "")
                print("parameters")
                print(parameters)
                //SecItemAdd(parameters as CFDictionary, nil)
                let accessString = parameters["access_token"] as! String
                KeychainWrapper.standard.set(accessString, forKey: "access_token")
                self.loadUserID()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadUserID() {
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "access_token")
        
        let request = AF.request("https://graph.facebook.com/me?fields=id,name&access_token=\(retrievedString!)")
        
        let decoder = JSONDecoder()
        
        request.responseDecodable(of: GraphResponseMe.self, decoder: decoder) { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                print("id")
                UserDefaults.standard.setValue(value.id, forKeyPath: "id")
                print(value.id ?? "")
                print("name")
                print(value.name ?? "")
                UserDefaults.standard.setValue(value.name, forKeyPath: "name")
            case .failure( _):
                print("failure")
            }
        }
    }
}
