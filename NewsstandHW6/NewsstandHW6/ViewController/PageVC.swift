//
//  PageVC.swift
//  ECE564_HOMEWORK
//
//  Created by student on 2/11/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    
    var person: DukePerson?
    var addPage: Bool?
    
    lazy var subViewControllers: [UIViewController] = {
        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        destVC.person = person
        destVC.addPage = addPage
        let yogoCV = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YogoVC") as! YogoVC
        var subVC: [UIViewController] = [destVC]
        if person?.nextPage == "Reading" {
            subVC.append(yogoCV)
        }
           return subVC
       }()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)

        // Do any additional setup after loading the view.
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
           return subViewControllers.count
       }
    
   func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
       let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
       if currentIndex <= 0 {
           return nil
       }
       return subViewControllers[currentIndex - 1]
   }
       
   func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
       if currentIndex >= subViewControllers.count - 1 {
                  return nil
              }
              return subViewControllers[currentIndex + 1]
   }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    

}
