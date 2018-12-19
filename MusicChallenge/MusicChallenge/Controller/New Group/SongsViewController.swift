//
//  SongsViewController.swift
//  MusicChallenge
//
//  Created by Guilherme Vassallo on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class SongsViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate{
    
    @IBOutlet var setlistsCollectionView: UICollectionView!
    @IBOutlet var repertoireTableView: UITableView!
    @IBOutlet var addSetlistButton: UIBarButtonItem!
    @IBOutlet var addSongButton: UIBarButtonItem!
    
    private var pageController: UIPageViewController!
    private var arrVC:[UIViewController] = []
    private var currentPage: Int!
    
    lazy var vc1: SetlistsViewController = {
        
        
        let setListsStoryboard = UIStoryboard(name: "Setlists", bundle: nil)
        
        var viewController = setListsStoryboard.instantiateViewController(withIdentifier: "Setlists") as! SetlistsViewController
        //self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    // MARK: MARKET ViewController
    
    lazy var vc2: RepertoireViewController = {
        
        let repertoireStoryboard = UIStoryboard(name: "Repertoire", bundle: nil)
        
        var viewController = repertoireStoryboard.instantiateViewController(withIdentifier: "Repertoire") as! RepertoireViewController
        //self.addViewControllerAsChildViewController(childViewController: viewController)
        
        return viewController
    }()
    
    // MARK: GRAPH ViewController
    
    //    lazy var vc3: VC3 = {
    //
    //        var viewController = storyboard?.instantiateViewController(withIdentifier: "VC3") as! VC3
    //        //self.addViewControllerAsChildViewController(childViewController: viewController)
    //        return viewController
    //    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ssss()
        currentPage = 0
        createPageViewController()
        
        arrVC.append(vc1)
        arrVC.append(vc2)
        //    arrVC.append(vc3)
        
        
    }
    
    var segmentedControl: CustomSegmentedContrl!
    
    func ssss() {
        segmentedControl = CustomSegmentedContrl.init(frame: CGRect.init(x: 0, y: 25, width: self.view.frame.width, height: 45))
        //        segmentedControl
        
        segmentedControl.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        segmentedControl.commaSeperatedButtonTitles = "Setlists, Repertoire"
        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
        
        self.view.addSubview(segmentedControl)
        
        
        
        
    }
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        segmentedControl.selectedSegmentIndex = 2
    //    }
    
    
    //MARK: - CreatePagination
    
    private func createPageViewController() {
        
        pageController = UIPageViewController.init(transitionStyle: UIPageViewController.TransitionStyle.scroll, navigationOrientation: UIPageViewController.NavigationOrientation.horizontal, options: nil)
        
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self
        
        for svScroll in pageController.view.subviews as! [UIScrollView] {
            svScroll.delegate = self
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pageController.view.frame = CGRect(x: 0, y: self.segmentedControl.frame.maxY, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
        }
        
        //arrVC = [vc1, vc2, vc3]
        
        pageController.setViewControllers([vc1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
    }
    
    
    private func indexofviewController(viewController: UIViewController) -> Int {
        for i in 0..<arrVC.count {
            if(arrVC[i] == viewController) {
                return i
            }
        }
        return -1
    }
    
    
    //MARK: - Pagination Delegate Methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewController: viewController)
        print("index: ", index)
        if(index != -1) {
            index = index - 1
        }
        
        if(index < 0) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexofviewController(viewController: viewController)
        
        if(index != -1) {
            index = index + 1
        }
        
        if(index >= arrVC.count) {
            return nil
        }
        else {
            return arrVC[index]
        }
        
    }
    
    func pageViewController(_ pageViewController1: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(completed) {
            currentPage = arrVC.index(of: (pageViewController1.viewControllers?.last)!)
            // self.segmentedControl.selectedSegmentIndex = currentPage
            
            self.segmentedControl.updateSegmentedControlSegs(index: currentPage)
            
        }
        
    }
    
    
    /*
     
     private func addViewControllerAsChildViewController(childViewController: UIViewController) {
     
     addChildViewController(childViewController)
     
     view.addSubview(childViewController.view)
     childViewController.view.frame = CGRect.init(x: 0, y: 120, width: self.view.frame.width, height: self.view.frame.height)
     
     childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     
     childViewController.didMove(toParentViewController: self)
     
     }
     
     private func removeViewControllerAsChildViewController(childViewController: UIViewController) {
     
     childViewController.willMove(toParentViewController: nil)
     childViewController.view.removeFromSuperview()
     
     childViewController.removeFromParentViewController()
     
     }
     
     */
    
    @objc func onChangeOfSegment(_ sender: CustomSegmentedContrl) {
        
        let direction = currentPage < sender.selectedSegmentIndex ? UIPageViewController.NavigationDirection.forward : UIPageViewController.NavigationDirection.reverse
        
        let newView = arrVC[sender.selectedSegmentIndex]
        pageController.setViewControllers([newView], direction: direction, animated: true, completion: nil)
        
        currentPage = sender.selectedSegmentIndex

    }
    
    
    
    
    
    
    
}




//import UIKit
//
//class ViewController: UIViewController {
//
//    @IBOutlet var vwView: UIView!
//
//    @IBOutlet weak var segmentedControl: UISegmentedControl!
//    var view1: UIView!
//    var view2: UIView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view1 = SetlistsVC().view
//        view2 = RepertoireVC().view
//        segmentedControl.addSubview(view1)
//        segmentedControl.addSubview(view2)
//
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//
////    @IBAction func scSegmentedTapped(_ sender: Any) {
////
////        let getIndex = segmentedControl.selectedSegmentIndex
////
////        switch (getIndex) {
////        case 0:
////            segmentedControl.bringSubviewToFront(view1)
////        case 1:
////            segmentedControl.bringSubviewToFront(view2)
////        default:
////            print("no select")
////        }
////    }
//
//    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0 :
//                //primeira imagem
//            segmentedControl.bringSubviewToFront(view1)
//            print(sender.selectedSegmentIndex)
//            break
//        case 1:
//                //segunda
//            segmentedControl.bringSubviewToFront(view2)
//            print(sender.selectedSegmentIndex)
//            break
//        default:
//            print(sender.selectedSegmentIndex)
//            break
//        }
//
//    }
//
//
//
//}
