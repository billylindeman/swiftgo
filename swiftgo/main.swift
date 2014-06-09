//
//  main.swift
//  swiftgo
//
//  Created by Billy Lindeman on 6/7/14.
//  Copyright (c) 2014 lnd.mn. All rights reserved.
//

import Foundation

var channel = chan<Int>(nil)

go {
    while true {
        println("Goroutine 1 recieved: \(<-channel)");
    }
}



go {
    while true {
        let r = (Int(arc4random()))
        println("Goroutine 2 sent msg: \(r)")
        channel <- r
        usleep(1000000)
    }
}



while true {}