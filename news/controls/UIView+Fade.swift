//
//  UIView+Fade
//  news
//
//  Created by Daniyar Salakhutdinov on 20.05.2018.
//  Copyright © 2018 Daniyar Salakhutdinov. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

extension UIView {
    
    func fadeInAnimated(completion: (() -> Void)? = nil) {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { finished in
            completion?()
        })
    }
    
    func fadeOutAnimated(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0
        }, completion: { finished in
            completion?()
        })
    }
}
