//
//  SwipePhotosController.swift
//  SwipeMatch
//
//  Created by PhuongDo on 28/11/2023.
//

import UIKit

class SwipePhotosController: UIPageViewController,UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let yellowViewController = UIViewController()
        yellowViewController.view.backgroundColor = .yellow
        return yellowViewController
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let greenViewController = UIViewController()
        greenViewController.view.backgroundColor = .green
        return greenViewController
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        let redViewController = UIViewController()
        redViewController.view.backgroundColor = .red
        
        setViewControllers([redViewController], direction: .forward, animated: false)
        

        // Do any additional setup after loading the view.
    }
    

}
