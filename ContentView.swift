//
//  ContentView.swift
//  Simplidoro
//
//  Created by Rodin Shokravi on 2021-07-24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var minutes = 25
    @State var seconds: Int = 0
    @State var timerIsPaused: Bool = true
    var sessions = [15, 20, 25]
    @State private var selectedSession = 3
    @State var played = true

    @State var timer: Timer? = nil
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        VStack(spacing: 100) {
            
            Spacer()
            
            ZStack {
                Capsule()
                    .scale(0.9)
                    .foregroundColor(Color(#colorLiteral(red: 0.9212803841, green: 0.9210105538, blue: 1, alpha: 1)))
                    .shadow(color: Color(#colorLiteral(red: 0.7562670708, green: 0.7536618114, blue: 0.9305456281, alpha: 1)), radius: 4, x: 4, y: 4)
                    .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 7, x: -4, y: -4)
                
                Text(seconds < 10 ? "\(minutes):0\(seconds)" : "\(minutes):\(seconds)")
                    .padding(.horizontal, 20)
                    .font(.system(size: 120))
                    .foregroundColor(Color(#colorLiteral(red: 0.4541738629, green: 0.3957255185, blue: 0.9001517892, alpha: 1)))
                
            }
            .offset(y: 60)
            
            Spacer()
            
            VStack (spacing: 100){
                HStack(spacing: 50) {
                    Button(action:{
                        print("RESTART")
                        restartTimer()
                    }){
                        Image(systemName: "clock.arrow.circlepath")
                            .padding(.all, 10.5)
                            .foregroundColor(Color(timerIsPaused ? #colorLiteral(red: 0.4541738629, green: 0.3957255185, blue: 0.9001517892, alpha: 1) : #colorLiteral(red: 0.7629006505, green: 0.7488624454, blue: 0.8890359402, alpha: 1)))
                            .font(.title)
                    }
                    .padding(.all)
                    .background(
                        Circle()
                            .scale(timerIsPaused ? 1.3 : 1.1)
                            .foregroundColor(Color(#colorLiteral(red: 0.9212803841, green: 0.9210105538, blue: 1, alpha: 1)))
                            .shadow(color: Color(#colorLiteral(red: 0.7562670708, green: 0.7536618114, blue: 0.9305456281, alpha: 1)), radius: 4, x: 4, y: 4)
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 7, x: -4, y: -4)
                    )
                    
                    Button(action:{
                        self.startTimer()
                        print("START")
                    }){
                        Image(systemName: "play.fill")
                            .padding(.all, 13)
                            .foregroundColor(Color(timerIsPaused ? #colorLiteral(red: 0.4541738629, green: 0.3957255185, blue: 0.9001517892, alpha: 1) : #colorLiteral(red: 0.7629006505, green: 0.7488624454, blue: 0.8890359402, alpha: 1)))
                            .font(.title)
                    }
                    .padding(.all)
                    .background(
                        Circle()
                            .scale(timerIsPaused ? 1.3 : 1.1)
                            .foregroundColor(Color(#colorLiteral(red: 0.9212803841, green: 0.9210105538, blue: 1, alpha: 1)))
                            .shadow(color: Color(#colorLiteral(red: 0.7562670708, green: 0.7536618114, blue: 0.9305456281, alpha: 1)), radius: 4, x: 4, y: 4)
                            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 7, x: -4, y: -4)
                    )
                    
                }
                .offset(x: 0, y: 40)
                .disabled(timerIsPaused == false)
                
                Button(action:{
                    print("STOP")
                    self.stopTimer()
                }){
                    Image(systemName: "stop.fill")
                        .foregroundColor(Color(timerIsPaused ? #colorLiteral(red: 0.7629006505, green: 0.7488624454, blue: 0.8890359402, alpha: 1) : #colorLiteral(red: 0.4541738629, green: 0.3957255185, blue: 0.9001517892, alpha: 1)))
                        .padding(.all, 14)
                        .font(.title)
                }
                .padding(.all)
                .background(
                    Circle()
                        .scale(timerIsPaused ? 1.2 : 1.3)
                        .foregroundColor(Color(#colorLiteral(red: 0.9212803841, green: 0.9210105538, blue: 1, alpha: 1)))
                        .shadow(color: Color(#colorLiteral(red: 0.7562670708, green: 0.7536618114, blue: 0.9305456281, alpha: 1)), radius: 4, x: 4, y: 4)
                        .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 7, x: -4, y: -4)
                )
                .disabled(timerIsPaused == true)
                .offset(y: -20)
                
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
        .background(Color(#colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 1, alpha: 1)))
        .ignoresSafeArea()
        .animation(
            Animation.easeInOut(duration: 0.75)
        )
    }

    func startTimer(){
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            
            if self.minutes == 0 && self.seconds == 0 {
                stopTimer()
                AudioServicesPlayAlertSound(SystemSoundID(1322))
            }
            else if self.seconds == 0 {
                self.seconds = 59
                self.minutes = self.minutes - 1
            }
            else { self.seconds = self.seconds - 1 }
        }
    }
    
    func add(_ value: Int) {
        var a = value
        return a += 1
    }
    
    func subtract(_ value: Int) {
        var a = value
        return a -= 1
    }

    func stopTimer(){
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
    }

    func restartTimer(){
        minutes = 25
        seconds = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
