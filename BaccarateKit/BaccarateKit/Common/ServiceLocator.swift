//
//  ServiceLocator.swift
//  BaccaratLiveStream
//
//  Created by Farmood on 5/9/23.
//
import UIKit
class ServiceLocator {
    static let sharedInstance = ServiceLocator()
    // MARK: Storyboards To Get Instance of Storyboard
    fileprivate func provideStoryboardWithName(_ storyBoardName: String) -> BaseStoryboard {
        return BaseStoryboard(name: storyBoardName)
    }
    func provideDashboardViewController() -> HomeVC {
        let vc: HomeVC = provideStoryboardWithName("Main").instantiateViewController("HomeVC")
        let presenter = DashboardPresenter(ui: vc, wireframe: ProjectWireframe())
        vc.eventHandler = presenter
        return vc
    }
    func provideGameRooViewController() -> GameRoomVC {
        let vc: GameRoomVC = provideStoryboardWithName("Main").instantiateViewController("GameRoomVC")
        let presenter = GameRoomPresenter(ui: vc, wireframe: ProjectWireframe())
        vc.eventHandler = presenter
        return vc
    }
    func provideRollingRulesVC() -> RollingRulesVC {
        let vc: RollingRulesVC = provideStoryboardWithName("Main").instantiateViewController("RollingRulesVC")
        return vc
    }
    func provideLimitInfoPopupVC() -> LimitInfoPopupVC {
        let vc: LimitInfoPopupVC = provideStoryboardWithName("Main").instantiateViewController("LimitInfoPopupVC")
        return vc
    }
    
}
