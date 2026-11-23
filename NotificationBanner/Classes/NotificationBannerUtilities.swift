/*
 
 The MIT License (MIT)
 Copyright (c) 2017-2018 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import UIKit

class NotificationBannerUtilities: NSObject {

    /// The active window scene, falling back to any foreground scene
    class var activeWindowScene: UIWindowScene? {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            return scenes.first { $0.activationState == .foregroundActive }
                ?? scenes.first { $0.activationState == .foregroundInactive }
                ?? scenes.first
        }
        return nil
    }

    /// The key window resolved through the active scene. `UIApplication.keyWindow` is deprecated
    /// and can return nil on recent iOS versions.
    class var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            if let scene = activeWindowScene,
               let window = scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first {
                return window
            }
        }
        return UIApplication.shared.delegate?.window ?? nil
    }

    /// The current interface orientation, resolved through the active scene
    class var interfaceOrientation: UIInterfaceOrientation {
        if #available(iOS 13.0, *), let scene = activeWindowScene {
            return scene.interfaceOrientation
        }
        return UIApplication.shared.statusBarOrientation
    }

    class func isNotchFeaturedIPhone() -> Bool {
        return (keyWindow?.safeAreaInsets.bottom ?? 0.0) > 0.0
    }

    class func hasDynamicIsland() -> Bool {
        return (keyWindow?.safeAreaInsets.top ?? 0.0) > 50.0
    }

    /// The height of the status bar area, resolved through the active scene
    class var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let height = activeWindowScene?.statusBarManager?.statusBarFrame.height ?? 0
            if height > 0 { return height }
            return keyWindow?.safeAreaInsets.top ?? 0
        }
        return UIApplication.shared.statusBarFrame.height
    }

}
