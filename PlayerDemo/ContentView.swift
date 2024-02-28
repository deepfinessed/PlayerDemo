//
//  ContentView.swift
//  PlayerDemo
//
//  Created by Nathaniel Munger on 2/28/24.
//

import SwiftUI
import AVKit

let URLS = ["https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
            "https://cdn.jwplayer.com/manifests/pZxWPRg4.m3u8"]

func getVideoUrl(id: Int) async throws -> URL {
    let delay = Double.random(in: 0..<4);
    NSLog("Returning URL after %f seconds", delay);
    try await Task.sleep(nanoseconds: UInt64(delay) * NSEC_PER_SEC);
    
    return URL(string: URLS[id])!
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
                            
                        }
                    VideoPlayer(player: playerTwo)
                        .frame(width: proxy.size.width, height: proxy.size.width * 9 / 16)
                        .onAppear() {
                            playerTwo.isMuted = true
                        }
                }.task {
                    do {
                        let url = try await getVideoUrl(id: 0);
                        playerOne.replaceCurrentItem(with: AVPlayerItem(url: url));
                        playerOne.play()
                        
                    } catch {
                        NSLog("Error!");
                    }
                }.task {
                    do {
                        let url = try await getVideoUrl(id: 0);
                        playerTwo.replaceCurrentItem(with: AVPlayerItem(url: url));
                        playerTwo.play()
                        
                    } catch {
                        NSLog("Error!");
                    }
                }
            }
            Text("1. These players play out of sync. Please do your best to synchronize their start.")
            Text("2. If you accomplish this, and you would like a challenge, implement a toggle that swaps the players between the URL above and the URL with id 1, restarting playback each time.")
            Text("3. You need not consider buffering, but in the event that you wanted to be able to synchronize the players despite one of them buffering while the other does not, describe how you might do this")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
