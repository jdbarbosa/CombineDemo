//
//  ViewModelBindable.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

/// Protocol that subclassers should implement
/// to conform with MVVM design pattern
protocol ViewModelBindable {

    // This associatedtype defines the class of the view model that the
    // implementer will use.
    associatedtype ViewModelType

    // The var that will hold the view model implementation
    var viewModel: ViewModelType! { get set }
}
