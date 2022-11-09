//
//  ContentView.swift
//  Animation App
//
//  Created by Arvid Axelsson on 2022-11-09.
//

import SwiftUI

struct GradientBackground : ViewModifier {
    
    @State private var animateGradient = false
    
    func body(content: Content) -> some View {
        content
            .background(
                
                LinearGradient(colors: [.orange, .red, .purple],
                               startPoint: animateGradient ? .topLeading : .bottomLeading,
                               endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .onAppear {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
                
            )
    }
    
}

extension View {
    
    func gradientBackground () -> some View {
        modifier(GradientBackground())
    }
    
}

struct MovingCircles : View {
    
    @State private var scale = 0.2
    @State private var animate = false
    
    var body : some View {
        
        VStack {
            ZStack {
                
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 210, height: 210)
                    .scaleEffect(scale)
                    .animation(Animation.easeOut(duration: 2.0).repeatForever(autoreverses: true), value: animate)
                
                Circle()
                    .fill(.white.opacity(0.5))
                    .frame(width: 170, height: 170)
                    .scaleEffect(scale)
                    .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)
                
                Circle()
                    .fill(.red.opacity(0.5))
                    .frame(width: 120, height: 120)
                    .shadow(color: Color(.systemGray5), radius: 5)
                    .scaleEffect(scale)
                    .animation(.linear(duration: 0.9), value: scale)
                
            }
            .gradientBackground()
            
            Button("Animate!") {
                self.animate.toggle()
                self.scale = self.animate ? 1.0 : 0.2
            }
            .buttonStyle(.borderedProminent)
        }
        
    }
    
}

struct PictureView : View {
    
    @State private var scale = false
    @State private var fade = false
    
    var body : some View {
        
        Image("heavyidle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .scaleEffect(scale ? 0.5 : 1.0)
            .opacity(fade ? 0.5 : 1.0)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.scale.toggle()
                    self.fade.toggle()
                }
            }
        
    }
    
}

struct EmojiFaces : View {
    
    let emojis = ["😎", "😵", "🫠", "🤓", "🙂", "🥹"]
    
    var body : some View {
        
        TimelineView(.periodic(from: .now, by: 0.7)) { timeline in
            
            let randomEmoji = emojis.randomElement() ?? ""
            
            HStack {
                Text("\(timeline.date)")
                    .font(.caption2)
                    .padding()
                
                Spacer()
                
                Text(randomEmoji)
                    .font(.largeTitle)
                    .scaleEffect(2.0)
            }
            .padding()
            
        }
        
    }
    
}

struct WaterDrop : Shape {
    
    var height: Int
    
    private var heightAsDouble: Double
    
    var animatableData: Double {
        get { return heightAsDouble }
        set { heightAsDouble = newValue }
    }
    
    init (height: Int) {
        self.height = height
        self.heightAsDouble = Double(height)
    }
    
    func path (in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.width/2, y: 0))
        
        path.addQuadCurve(to: CGPoint(x: rect.width/2, y: CGFloat(heightAsDouble)),
                          control: CGPoint(x: rect.width, y: CGFloat(heightAsDouble)))
        
        path.addQuadCurve(to: CGPoint(x: rect.width/2, y: 0),
                          control: CGPoint(x: 0, y: heightAsDouble))
        
        path.closeSubpath()
                  
        return path
    }
    
}

struct AsCardView : ViewModifier {
    func body(content: Content) -> some View {
        
        HStack {
            Spacer()
            content
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .listRowSeparator(.hidden)
    }
}

extension View {
    func asCardView() -> some View {
        modifier(AsCardView())
    }
}

struct ContentView: View {
    var body: some View {
        
        NavigationStack {
            List {
                MovingCircles()
                    .asCardView()
                
                PictureView()
                    .asCardView()
                
                EmojiFaces()
                    .asCardView()
                
                TimelineView(.periodic(from: .now, by: 0.5)) { timeline in
                    
                    let randomHeight = Int.random(in: 100...150)
                    
                    
                    WaterDrop(height: randomHeight)
                        .fill(
                            LinearGradient(colors: [.white, .blue],
                                           startPoint: .topLeading,
                                           endPoint: .bottom)
                        )
                        .animation(.default, value: randomHeight)
                }
                .frame(width: 150, height: 150)
                .asCardView()
                
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Let's animate, mfs!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
