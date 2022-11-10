
## SwiftUI同OC混编
### OC打开SwiftUI页面
1、创建OC主工程
2、添加Swift文件，此时会弹窗提醒自动创建一个桥接文件，点击确定，创建文件
![](https://img2022.cnblogs.com/blog/950551/202211/950551-20221110162620098-1783465844.png)
3、在SwiftUI文件中 创建被oc调用的控制器和方法 需要注意：注意Swift类和被调用的方法要使用@objc来修饰
```
@objc
class TestViewController: NSObject{
    @objc func createTestViewController() -> UIViewController{
        let vc = UIHostingController(rootView: SwiftUIView());
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}
```
4、创建桥接文件后，当我们创建了swift文件，就会自动生成一个"工程名称-Swift.h"的文件，然后手动在oc需要调用swift的控制器里引入这个头文件
比如 我的demo叫ObjcMixSwiftUI，那么就会自动生成一个ObjcMixSwiftUI-Swift.h的文件，这个文件导入时有时候不会自动提醒，手动填进去就行了 
按住ObjcMixSwiftUI-Swift.h进去到这个文件中，发现刚刚创建的TestViewController已经被转换成了对应的oc代码，接下来就可以向访问oc代码一样去调用该控制器了
```
    UIViewController *vc = [[TestViewController alloc] createTestViewController];
    [self.navigationController pushViewController:vc animated:YES];
```
需要注意的是"工程名称-Swift.h"这个文件如果你发现输入后找不到文件时，这个时候定位到target->build settings->搜索Interface Header看看搜索到的文件是否是你引入的-Swift.h文件，如果不是或者有中文的，可以修改名称后重新导入
5、点击按钮发现此时就可以正常的打开SwiftUI布局好的页面了
ObjcMixSwiftUI-Bridging-Header.h
```
#import "SwiftToObjcVC.h"
```

### SwiftUI打开OC页面
1、在主工程中创建OC文件SwiftToObjcVC，并且在桥接的.h文件中引入该文件，这样swift就可以找到oc页面
2、在swiftUI页面重新创建一个View并且继承UIViewControllerRepresentable协议，重新makeUIViewController 和 updateUIViewController方法，并且在makeUIViewController方法中创建刚刚创建OC控制器SwiftToObjcVC
```
struct MySwiftView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SwiftToObjcVC {
        let vc = SwiftToObjcVC()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SwiftToObjcVC, context: UIViewControllerRepresentableContext<MySwiftView>) {
        
    }
}
```
3、在需要地方引入MySwiftView就可以打开SwiftToObjcVC页面了
```
struct SwiftUIView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isPresented: Bool = false
    var body: some View {
        NavigationView{
            List{
                ForEach(0..<100) { index in
                    NavigationLink(destination: Text("详情页：\(index)")) {
                        Text("\(index)")
                            .frame(height: 40)
                    }
                    
                }
            }
            .navigationTitle("标题")
            .navigationBarBackButtonHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("返回值：\(value)") {}
                }
                
                
                ToolbarItem(placement: .bottomBar) {
                    Button("点击打开OC页面") {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                MySwiftView()
            }
        }
    }
}
```
4、此时就实现了oc和swiftui的相互调用了


## SwiftUI同OC传参
前面已经实现了OC和SwiftUI的互相调用，但是呢，这两个页面没法实现正常的参数传递，下面将开始介绍Coordinator，通过Coordinator作为委托的角色，实现oc到swift层的数据传递，最常见的就是swiftui调用oc的图片选择框架，选择完图片后，通过Coordinator将选中的图片传递给swiftui显示出来

本例就通过一个简单的例子来实现一下这个参数的传递过程
1、在oc控制器创建一个协议，并提供2个方法  一个方法用来传传递值参数 另外一个方法用来做点击返回的消息
```
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SwiftToObjcVCDelegate <NSObject>

/// 点击回调
-(void)onClick:(NSInteger)value;

/// 点击返回
-(void)onBackClick;

@end


@interface SwiftToObjcVC : UIViewController

@property (nonatomic,assign) id<SwiftToObjcVCDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
```
2、在刚刚创建的MySwiftView中实现makeCoordinator方法，并创建一个class Coordinator，遵循NSObject,SwiftToObjcVCDelegate两个协议
遵守SwiftToObjcVCDelegate，就会有onClick和onBackClick方法，此时，在oc中的点击事件和参数传递事件都可以在这两个方法中监听了
通过@Binding的方式将onClick 和 onBackClick事件的值传递给swiftui显示的代码中
```
struct MySwiftView: UIViewControllerRepresentable {
    @Binding var bValue: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    class Coordinator: NSObject,SwiftToObjcVCDelegate {
        var myview: MySwiftView
        init(_ myview: MySwiftView) {
            self.myview = myview
        }
        
        func onClick(_ value: Int) {
            print("点击事件\(value)")
            /// 把这个值传递出去
            myview.bValue = value
        }
        
        func onBackClick() {
            self.myview.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> SwiftToObjcVC {
        let vc = SwiftToObjcVC()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SwiftToObjcVC, context: UIViewControllerRepresentableContext<MySwiftView>) {
        
    }
}

struct SwiftUIView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isPresented: Bool = false
    @State private var value: Int = 0
    var body: some View {
        NavigationView{
            List{
                ForEach(0..<100) { index in
                    NavigationLink(destination: Text("详情页：\(index)")) {
                        Text("\(index)")
                            .frame(height: 40)
                    }
                    
                }
            }
            .navigationTitle("标题")
            .navigationBarBackButtonHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("返回值：\(value)") {}
                }
                
                
                ToolbarItem(placement: .bottomBar) {
                    Button("点击打开OC页面") {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                MySwiftView(bValue: $value)
            }
        }
    }
}

```
