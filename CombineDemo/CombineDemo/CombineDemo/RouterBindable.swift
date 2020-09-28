//
//  RouterBindable.swift
//  CombineDemo
//
//  Created by João Barbosa on 23/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

/// Protocol that view models should implement to enable with Router capabilities
protocol RouterBindable {

    // This associatedtype defines the type of the router that the
    // implementer will use.
    associatedtype RouterType

    // The var that will hold the router implementation
    var router: RouterType! { get set }
}
