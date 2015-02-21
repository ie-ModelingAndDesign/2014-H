//
//  GameViewController.swift
//  modelling
//
//  Created by 小渡広和 on 2014/11/26.
//  Copyright (c) 2014年 odo. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)

            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, SceneEscapeProtocol {

    var skView: SKView?
    //    let myAddButton: UIButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton

    override func viewDidLoad() {
        super.viewDidLoad()

        // skViewを設定します。
        self.skView = self.view as? SKView
        skView!.showsFPS = true
        skView!.showsNodeCount = true
        skView!.ignoresSiblingOrder = true

        goTitle()
    }

    func goGame() {
        let gameScene = GameScene(size: CGSizeMake(1024, 768))
        gameScene.delegate_escape = self
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.skView!.presentScene(gameScene)

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = skView.frame.size
            skView.presentScene(scene)
        }
    }

    func goTitle() {
        let titleScene = TitleScene(size: CGSizeMake(1024, 768))
        titleScene.delegate_escape = self
        titleScene.scaleMode = SKSceneScaleMode.AspectFill
        self.skView!.presentScene(titleScene)
    }

    func goScore() {
        let scoreScene = ScoreScene(size: CGSizeMake(1024, 768))
        scoreScene.delegate_escape = self
        scoreScene.scaleMode = SKSceneScaleMode.AspectFill
        self.skView!.presentScene(scoreScene)
    }

    // デリゲートメソッドの記述。
    func sceneEscape(scene: SKScene) {
        if scene.isKindOfClass(GameScene) {
            goScore()
        }
        if scene.isKindOfClass(TitleScene) {
            goGame()
        }
        if scene.isKindOfClass(ScoreScene) {
            goTitle()
        }
    }

    func sceneEscape2(scene: SKScene) {
        if scene.isKindOfClass(GameScene) {
            goScore()
        }
        if scene.isKindOfClass(TitleScene) {
            goGame()
        }
        if scene.isKindOfClass(ScoreScene) {
            goTitle()
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}