# getPhoto
使用Photos库获取手机图片，支持多选，之前项目中所用三方过时了，自写自用

info.plist 中添加以下
相机权限： Privacy - Camera Usage Description 是否允许此App使用你的相机？

相册权限： Privacy - Photo Library Usage Description 是否允许此App访问你的媒体资料库？

允许应用程序获取框架库内语言：Localized resources can be mixed YES


用了MBProgressHUD 如果程序有问题添加四种框架文件
Photos.framework
coreGraphics.framework
Foundation.framework
UIKit.framework

其实不加也是可以得，至于系统自动加了哪些我也不清楚。其实我不喜欢直接用MBProgressHUD，Demo中用用，不喜欢就删了。

ViewController.h中就是用法了。简单的很。后续看情况加功能，先这样。

