//
//  InstructionsPageController.swift
//  Ticker_FinalProject
//
//  Created by Fernando Alquicira on 8/30/17.
//  Copyright © 2017 Fernando Alquicira. All rights reserved.
//

import UIKit

class InstructionsPageController: UIPageViewController, UIPageViewControllerDataSource {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.callController(string: "pageOne"), self.callController(string: "pageTwo"), self.callController(string: "pageThree") ]
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self as? UIPageViewControllerDelegate
        
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    

    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }

//    func arrayOfControllers()-> [UIViewController]{
//
//        return [self.callController(string: "pageOne"), self.callController(string: "pageTwo"),self.callController(string: "pageThree")]
//        
//    }
    
    func callController(string: String)-> UIViewController{
        
        return UIStoryboard(name: "Main", bundle: nil)
        .instantiateViewController(withIdentifier: "\(string)")
        
    }
    
    

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
