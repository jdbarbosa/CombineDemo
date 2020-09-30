//
//  SceneSpec.swift
//  CombineDemoTests
//
//  Created by João Barbosa on 29/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import Nimble
import Quick

@testable import CombineDemo

final class SceneSpec: QuickSpec {

    override func spec() {
        describe("Scene creation") {
            describe("View Controllers") {
                let appContext = AppContext.mock()
                let factory = CombineDemoSceneFactory(context: appContext)
                context("Movie List") {
                    let scene = MovieListScene()
                    it("A view controller should be created from its Scene, in the SceneFactory") {
                        let viewController = factory.create(scene)
                        expect(viewController).toNot(beNil())
                        expect(viewController).to(beAKindOf(MovieListViewController.self))
                    }
                    it("The Scene's router should have the expected type") {
                        let router = scene.router(factory, appContext)
                        expect(router).toNot(beNil())
                        expect(router).to(beAKindOf(MovieListRouter.self))
                    }
                }
                context("Movie Detail") {
                    let scene = MovieDetailScene(movieId: 123)
                    it("A view controller should be created from its Scene, in the SceneFactory") {
                        let viewController = factory.create(scene)
                        expect(viewController).toNot(beNil())
                        expect(viewController).to(beAKindOf(MovieDetailViewController.self))
                    }
                    it("The Scene's router should have the expected type") {
                        let router = scene.router(factory, appContext)
                        expect(router).toNot(beNil())
                        expect(router).to(beAKindOf(MovieDetailRouter.self))
                    }
                }
            }
        }
    }
}

extension AppContext {

    /// A mock AppContext for testing purposes
    public static func mock() -> AppContext {
        let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first!
        return AppContext(appRouter: AppRouter(window: window))
    }
}


