
//
//  go.swift
//  swiftgo
//
//  Created by Billy Lindeman on 6/7/14.
//  Copyright (c) 2014 lnd.mn. All rights reserved.
//
//  The purpose of this library is to implement features of go in the swift language
//  This is mostly for shits and giggles
//

import Foundation

//
//  Go
//  This is the equivalent of the go keyword in golang
//  It can be used as such thanks to trailing closures in swift
//
public func go (closure: ()->Void) {
    var queue = dispatch_get_global_queue(0, 0)    
    dispatch_async(queue, closure)
}

//
//  Channels
//  This is the implementation of channels in golang
//  We will make use of custom operators, optional structs, 
//  and dispatch_semaphores to send types through our channel
//
public struct chan<T> {
    var val: T?
    var semaphore: dispatch_semaphore_t
    
    init(_ val: T?) {
        semaphore = dispatch_semaphore_create(0)
        self.val = val
    }
}


prefix operator  <- {}
infix operator   <- {}

//Prefix function for channel operator <-c
//Should return value in pipe or block until it recieves
//a value
public prefix func <-<T> (inout channel: chan<T>) -> T?{
    dispatch_semaphore_wait(channel.semaphore, DISPATCH_TIME_FOREVER)
    
    if let v = channel.val {
        channel.val = nil
        return v
    }
    return nil
}

//Infix function for channel operator c <- 1
//Should write value to pipe or block until it can
public func <-<T> (inout channel: chan<T>, val: T){
    if !(channel.val? != nil) {
        channel.val = val
        dispatch_semaphore_signal(channel.semaphore)
        return;
    }
}



