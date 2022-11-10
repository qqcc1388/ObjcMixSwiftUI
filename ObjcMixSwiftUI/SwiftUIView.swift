//
//  SwiftUIView.swift
//  ObjcMixSwiftUI
//
//  Created by chenhao on 2022/11/10.
//

import SwiftUI

@objc
class TestViewController: NSObject{
    @objc func createTestViewController() -> UIViewController{
        let vc = UIHostingController(rootView: SwiftUIView());
        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}

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

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
