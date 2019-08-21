//
//  AuthenticationRepositoryRemoter.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 21.09.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import Foundation
import RxSwift
import WavesSDK
import DomainLayer

fileprivate enum Constants {
    #if DEBUG
    static let rootPath: String = "pincodes-ios-dev"
    #elseif TEST
    static let rootPath: String = "pincodes-ios-dev"
    #else
    static let rootPath: String = "pincodes-ios"
    #endif
}

final class AuthenticationRepositoryRemote: AuthenticationRepositoryProtocol {

    func registration(with id: String, keyForPassword: String, passcode: String) -> Observable<Bool> {
        if passcode.count == 0 {
            return Observable.error(AuthenticationRepositoryError.fail)
        }
        let passCodeDatabase = PassCodeDatabase()
        passCodeDatabase.id = id
        passCodeDatabase.keyForPassword = keyForPassword
        passCodeDatabase.passcode = passcode
        PassCodeDatabase.insertPassCodeDatabase(by: passCodeDatabase)
        return Observable.just(true)
        
//        if passcode.count == 0 {
//            return Observable.error(AuthenticationRepositoryError.fail)
//        }

//        return Observable.create { (observer) -> Disposable in
////            FirebaseApp.configure()
//            let database: DatabaseReference = Database.database().reference()
//
//            let disposable = database.child("\(Constants.rootPath)/\(id)/")
//                .rx
//                .removeValue()
//                .map { $0.child(passcode) }
//                .flatMap({ ref -> Observable<DatabaseReference> in
//
//                    ref.rx.setValue(keyForPassword)
//                })
//                .subscribe(onNext: { _ in
//                    observer.onNext(true)
//                    observer.onCompleted()
//                }, onError: { error in
//                    observer.onError(self.handlerError(error: error))
//                })
//
//            return Disposables.create([disposable])
//        }
    }

    func auth(with id: String, passcode: String) -> Observable<String> {
        let passCodeDatabase = PassCodeDatabase.getPassCodeDatabase(from: id)
        
        if let passCodeDatabase = passCodeDatabase {
            if passCodeDatabase.passcode == passcode {
                return Observable.just(passCodeDatabase.keyForPassword)
            }else {
                
                return Observable.error(AuthenticationRepositoryError.passcodeIncorrect)
                
            }
        }else {
            return Observable.error(AuthenticationRepositoryError.fail)
        }
        

//        return Observable.create { observer -> Disposable in
////            FirebaseApp.configure()
//            let database: DatabaseReference = Database.database()
//                .reference()
//                .child(Constants.rootPath)
//                .child(id)
//
//            let value = self.lastTry(database: database)
//                .flatMap({ nTry -> Observable<String> in
//
//                    let changeLastTry = self.changeLastTry(database: database, nTry: nTry + 1)
//                    let inputTry = self.inputPasscode(database: database,
//                                                      passcode: passcode,
//                                                      nTry: nTry + 1)
//
//                    return Observable.zip([changeLastTry, inputTry])
//                        .flatMap { _ -> Observable<String> in
//                            self.keyForPassword(database: database, passcode: passcode)
//                                .flatMap { keyForPassword -> Observable<String> in
//                                    self.registration(with: id, keyForPassword: keyForPassword, passcode: passcode).map { _ in keyForPassword }
//                                }
//                        }
//                })
//                .catchError({ (error) -> Observable<String> in
//                    return Observable.error(self.handlerError(error: error))
//                })
//                .bind(to: observer)
//
//            return Disposables.create([value])
//        }
    }

    func changePasscode(with id: String, oldPasscode: String, passcode: String) -> Observable<Bool> {
        
        let passCodeDatabase = PassCodeDatabase.getPassCodeDatabase(from: id)
        if let passCodeDatabase = passCodeDatabase {
            if passCodeDatabase.passcode == oldPasscode {
                PassCodeDatabase.updatePassCode(passcode: passcode)
                return Observable.just(true)
            }else {
                return Observable.error(AuthenticationRepositoryError.passcodeIncorrect)
            }
        }else {
            return Observable.error(AuthenticationRepositoryError.fail)
        }
        
        
//        return auth(with: id, passcode: oldPasscode)
//            .flatMap { [weak self] keyForPassword -> Observable<Bool> in
//                guard let self = self else { return Observable.empty() }
//                return self.registration(with: id, keyForPassword: keyForPassword, passcode: passcode)
//            }
    }

    private func handlerError(error: Error) -> Error {
        if error is AuthenticationRepositoryError {
            return error
        } else {
            return NetworkError.error(by: error)
        }
    }

    private func lastTry(database: DatabaseReference) -> Observable<Int> {
        return database
            .child("lastTry")
            .rx
            .value
            .map({ value -> Int in
                if let value = value as? Int {
                    return value
                } else {
                    return 0
                }
            })
    }

    private func inputPasscode(database: DatabaseReference, passcode: String, nTry: Int) -> Observable<DatabaseReference> {
        return database
            .child("try/try\(nTry)")
            .rx
            .setValue(passcode)
            .catchError { error -> Observable<DatabaseReference> in
                if let error = error as NSError?, error.permissionDenied {
                    return Observable.error(AuthenticationRepositoryError.passcodeIncorrect)
                }
                return Observable.error(NetworkError.error(by: error))
            }
    }

    private func changeLastTry(database: DatabaseReference, nTry: Int) -> Observable<DatabaseReference> {
        return database
            .child("lastTry")
            .rx
            .setValue(nTry)
            .catchError { error -> Observable<DatabaseReference> in
                if let error = error as NSError?, error.permissionDenied {
                    return Observable.error(AuthenticationRepositoryError.attemptsEnded)
                }
                return Observable.error(NetworkError.error(by: error))
            }
    }

    private func keyForPassword(database: DatabaseReference, passcode: String) -> Observable<String> {
        return database
            .child(passcode)
            .rx
            .value
            .flatMap { value -> Observable<String> in
                if let value = value as? String {
                    print(value)
                    return Observable.just(value)
                } else {
                    return Observable.error(AuthenticationRepositoryError.passcodeIncorrect)
                }
            }
    }
}

private extension NSError {
    var authError: AuthErrorCode? {
        return AuthErrorCode(rawValue: code)
    }

    var firebaseError: NSError? {
        if domain == "com.firebase" {
            return NSError(domain: domain, code: code, userInfo: userInfo)
        }
        return nil
    }

    var permissionDenied: Bool {
        return firebaseError?.code == 1
    }
}


import RealmSwift
class PassCodeDatabase: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var keyForPassword: String = ""
    @objc dynamic var passcode: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension PassCodeDatabase {
    
    private class func getDB() -> Realm {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/PassCodeDB.realm")
        /// 传入路径会自动创建数据库
        let defaultRealm = try! Realm(fileURL: URL.init(string: dbPath)!)
        return defaultRealm
    }
    
    //增
    public class func insertPassCodeDatabase(by passCodeDatabase : PassCodeDatabase) -> Void {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.add(passCodeDatabase)
        }
        print(defaultRealm.configuration.fileURL ?? "")
    }
    
    //删
    public class func deletePassCodeDatabase(student : PassCodeDatabase) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            defaultRealm.delete(student)
        }
    }
    
    //改手势密码
    public class func updatePassCode(passcode : String) {
        let defaultRealm = self.getDB()
        try! defaultRealm.write {
            let students = defaultRealm.objects(PassCodeDatabase.self)
            students.setValue(passcode, forKey: "passcode")
        }
    }
    
    //查
    public class func getPassCodeDatabases() -> Results<PassCodeDatabase> {
        let defaultRealm = self.getDB()
        return defaultRealm.objects(PassCodeDatabase.self)
    }
    
    /// 获取 指定id (主键) 的 PassCodeDatabase
    public class func getPassCodeDatabase(from id : String) -> PassCodeDatabase? {
        let defaultRealm = self.getDB()
        return defaultRealm.object(ofType: PassCodeDatabase.self, forPrimaryKey: id)
    }
    
}
