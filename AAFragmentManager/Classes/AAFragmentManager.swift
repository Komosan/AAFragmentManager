//
//  AAFragmentManager.swift
//  AAFragmentManager
//
//  Created by Engr. Ahsan Ali on 01/04/2017.
//  Copyright (c) 2017 AA-Creations. All rights reserved.
//

import UIKit


open class AAFragmentManager: UIView {
    
    var views: [UIViewController]?
    
    let transition: CATransition = CATransition()
    
    open private(set) var currentFragmentIndex: Int = -1
    
    open var historyIndex = [Int]()
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
    }
    
    open func setupFragments(_ childViews: [UIViewController], defaultIndex: Int = -1) {
        self.views = childViews
        initTranstion()
        if viewExists(defaultIndex) {
            replaceFragment(index: defaultIndex, shouldAnimate: false)
        }
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initTranstion() {
        
        transition.duration = 0.3
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionReveal
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
    }
    
    func viewExists(_ index: Int) -> Bool {
        return views?.indices.contains(index) ?? false
    }
    
    open func getFragment(_ index: Int) -> UIViewController? {
        if viewExists(index) {
            return views![index]
        }
        return nil
    }
    
    open func replaceFragment(index: Int, shouldAnimate animate: Bool = true, shouldFit fit: Bool = true, allowSameFragment sameFragment: Bool = false, isBack:Bool = false) {
        
        guard viewExists(index) else {
            return
        }
        
        if let view = views?[index].view {
            
            guard !(!sameFragment && currentFragmentIndex == index) else {
                return
            }
            
            for view in self.subviews {
                view.removeFromSuperview()
            }
            
            if animate {
                transition.subtype = currentFragmentIndex > index ? kCATransitionFromLeft : kCATransitionFromRight
                self.layer.add(transition, forKey: kCATransition)
            }
            else {
                self.layer.removeAnimation(forKey: kCATransition)
            }
            
            if isBack {
                historyIndex.removeLast()
            }else{
                historyIndex.append(currentFragmentIndex)
            }
            
            currentFragmentIndex = index
            
            view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
            let heightView = fit ? view : self
            view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: heightView.frame.height)
            self.addSubview(view)
            
        }
    }
    
    open func back(_ isAnimate:Bool = false){
        replaceFragment(index: historyIndex.last!, shouldAnimate: isAnimate, shouldFit: true, allowSameFragment: false, isBack: true)
    }
}
