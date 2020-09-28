//
//  SceneFactory.swift
//  CombineDemo
//
//  Created by João Barbosa on 22/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit

/// A SceneFactory is just a holder of the SceneFactoryContext and a proxy through a Scene and its worker that will create it.
protocol SceneFactory {

    /// Given a scene, attempt to create a UIViewController from it. The factory will use the last added worker for that
    /// identifier.
    func create(_ scene: Scene) -> UIViewController
}

final class CombineDemoSceneFactory: SceneFactory {

    private let context: AppContext

    init(context: AppContext) {
        self.context = context
    }

    func create(_ scene: Scene) -> UIViewController {
        return scene.make(factory: self, context: self.context)
    }
}
