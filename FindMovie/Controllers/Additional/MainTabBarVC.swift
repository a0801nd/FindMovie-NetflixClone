import UIKit
class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: UpcomingVC())
        let vc3 = UINavigationController(rootViewController: SearchVC())
        let vc4 = UINavigationController(rootViewController: DownloadsVC())
    
        var homeImage = UIImage(named: "home")
        var upcomingImage = UIImage(named: "upcoming")
        var loupeImage = UIImage(named: "loupe")
        var downloadImage = UIImage(named: "download")
        
        homeImage = homeImage?.withRenderingMode(.alwaysOriginal)
        upcomingImage = upcomingImage?.withRenderingMode(.alwaysOriginal)
        loupeImage = loupeImage?.withRenderingMode(.alwaysOriginal)
        downloadImage = downloadImage?.withRenderingMode(.alwaysOriginal)
        
        vc1.tabBarItem.image = homeImage
        vc2.tabBarItem.image = upcomingImage
        vc3.tabBarItem.image = loupeImage
        vc4.tabBarItem.image = downloadImage
        
        vc1.title = "Home"
        vc2.title = "Upcoming"
        vc3.title = "Search"
        vc4.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }
}
