//
//  PageViewVC.swift
//  MyVelib
//
//  Created by etudiant-06 on 30/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import UIKit

class PageViewVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        
        let p0 = (self.storyboard?.instantiateViewController(withIdentifier: "page0"))! as! MainVC
        p0.screenType = .home
        
        let p1 = (self.storyboard?.instantiateViewController(withIdentifier: "page0"))! as! MainVC
        p1.screenType = .work
        
        let p2 = (self.storyboard?.instantiateViewController(withIdentifier: "page0"))! as! MainVC
        p2.screenType = .geoloc
        
        pages = [p0, p1, p2]
        setViewControllers([p0], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

    }

    // Fonction pour renvoyer le ViewController situé AVANT le controller actuel. Renvoi Nil si
    // c'est le premier
    
    // recupère l'index du controller actuel dans le tableau
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == 0 {
            return nil
        }
        else {
            return pages[currentIndex-1]
        }
    }
    
    // Renvoi le ViewController situé APRES le controller actuel. Renvoi Nil si c'est le dernier.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        
        if currentIndex == pages.count-1 {
            return nil
        }
        else {
            return pages[currentIndex+1]
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }
}
