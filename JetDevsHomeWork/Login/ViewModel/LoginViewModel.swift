//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by APPLE on 23/03/24.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    let emailSubject = BehaviorRelay<String?>(value: "")
    let passwordSubject = BehaviorRelay<String?>(value: "")
    let disposeBag = DisposeBag()
    let minPasswordCharacters = 6
    
    var isValidForm: Observable<Bool> {
       return Observable.combineLatest(emailSubject, passwordSubject) { email, password in
            guard email != nil && password != nil else {
                return false
            }
           return email!.validateEmail() && password!.count >= self.minPasswordCharacters
        }
    }
    
    func requestToLogin(email: String, password: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let parameters = ["email": email, "password": password]
        HTTPUtility.shared.requestData(from: .login, method: .POST, parameters: parameters) { result in
            switch result {
            case .success(let data):
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(json, nil)
                    } else {
                        completion(nil, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                    }
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
