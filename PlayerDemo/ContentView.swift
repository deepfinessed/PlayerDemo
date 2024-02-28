//
//  ContentView.swift
//  PlayerDemo
//
//  Created by Nathaniel Munger on 2/28/24.
//

import SwiftUI
import AVKit

func getVideoUrl() async throws -> URL {
    let delay = Double.random(in: 0..<4);
    NSLog("Returning URL after %f seconds", delay);
    try await Task.sleep(nanoseconds: UInt64(delay) * NSEC_PER_SEC);
    return URL(string: "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")!
}

struct ContentView: View {
    @State var playerOne: AVPlayer = AVPlayer();
    @State var playerTwo: AVPlayer = AVPlayer();
    
    
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                VStack {
                    VideoPlayer(player: playerOne)
                        .frame(width: proxy.size.width, height: proxy.size.width * 9 / 16)
                        .onAppear() {
                            
                            
                            
                            
                            playerOne.isMuted = true
                            playerOne.seek(to: CMTime(seconds: 30, preferredTimescale: 1000))
                            playerOne.play()
                        }
                    VideoPlayer(player: playerTwo)
                        .frame(width: proxy.size.width, height: proxy.size.width * 9 / 16)
                        .onAppear() {
                            playerTwo.isMuted = true
                            playerTwo.seek(to: CMTime(seconds: 30, preferredTimescale: 1000))
                            playerTwo.play()
                        }
                }.task {
                    do {
                        let url = try await getVideoUrl();
                        playerOne.replaceCurrentItem(with: AVPlayerItem(url: url));
                        playerOne.play()
                        
                    } catch {
                        NSLog("Error!");
                    }
                }.task {
                    do {
                        let url = try await getVideoUrl();
                        playerTwo.replaceCurrentItem(with: AVPlayerItem(url: url));
                        playerTwo.play()
                        
                    } catch {
                        NSLog("Error!");
                    }
                }
            }
            
            Text("These players play out of sync. Please do your best to synchronize them.")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
