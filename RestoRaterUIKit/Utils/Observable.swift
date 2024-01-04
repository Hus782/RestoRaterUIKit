//
//  Observable.swift
//  RestoRaterUIKit
//
//  Created by user249550 on 12/24/23.
//

import Foundation

//  A generic class that enables the creation of observable objects. This allows for the implementation of a simple data binding mechanism.
class Observable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
