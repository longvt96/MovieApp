//
//  Combine+Multipart.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

import Alamofire
import Combine

//extension Reactive where Base: SessionManager {
//    func upload(to url: URLConvertible,
//                method: HTTPMethod = .post,
//                headers: HTTPHeaders = [:],
//                data: @escaping (MultipartFormData) -> Void) -> Observable<UploadRequest> {
//        return Observable.create { observer in
//            self.base.upload(multipartFormData: data,
//                             to: url,
//                             method: method,
//                             headers: headers,
//                             encodingCompletion: { (result: SessionManager.MultipartFormDataEncodingResult) in
//                                switch result {
//                                case .failure(let error):
//                                    observer.onError(error)
//                                case .success(let request, _, _):
//                                    observer.onNext(request)
//                                    observer.onCompleted()
//                                }
//            })
//            
//            return Disposables.create()
//        }
//    }
//}
