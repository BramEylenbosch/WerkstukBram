//
//  ContentView.swift
//  WerkstukBram
//
//  Created by ehb on 17/04/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        CameraView()
    }
}
struct CameraView: View{
    
    @StateObject var camera = CameraModel()
    var body: some View{
        ZStack{
            Color.black
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                
                if camera.isTaken{
                    
                    HStack{
                        Spacer()
                        Button(action: {}, label: {
                            
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing,10)
                    }
                }
                Spacer()
                
                HStack{
                    
                    if camera.isTaken{
                        
                        Button(action: {}, label: {
                            Text("save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical,10)
                                .padding(.horizontal,20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        
                        Spacer()
                    }
                    else{
                        Button(action: {camera.isTaken.toggle()}, label: {
                            
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white,lineWidth: 2)
                                    .frame(width: 75, height: 75)
                                
                            }
                        })
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear(perform: {
            camera.Check()
        })
    }
}
    
    class CameraModel: ObservableObject{
        
        @Published var isTaken = false
        
        @Published var session = AVCaptureSession()
        
        @Published var alert = false
        
        @Published var output = AVCapturePhotoOutput()
        
        func Check(){
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setUp()
                return
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (status) in
                    
                    if status{
                        self.setUp()
                    }
                }
            case .denied:
                self.alert.toggle()
                return
            default:
                return
            }
        }
        
        func setUp(){
            
            do{
                self.session.beginConfiguration()
                
                let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
                
                let input = try AVCaptureDeviceInput(device: device!)
                
                if self.session.canAddInput(input) {
                    self.session.addInput(input)
                }
                if self.session.canAddOutput(self.output) {
                    self.session.addOutput(self.output)
                }
                self.session.commitConfiguration()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    #Preview {
        ContentView()
    }
