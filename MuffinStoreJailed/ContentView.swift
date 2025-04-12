//
//  ContentView.swift
//  MuffinStoreJailed
//
//  Created by Mineek on 26/12/2024.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 4) {
            Text("MuffinStore")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
            
            Text("JAILED EDITION")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .tracking(5)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)
            
            Text("by @mineekdev")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical)
    }
}

struct FooterView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .symbolEffect(.pulse)
                
                Text("USE AT YOUR OWN RISK")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.yellow, .orange],
                                      startPoint: .leading,
                                      endPoint: .trailing)
                    )
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
                    .symbolEffect(.pulse)
            }
            
            Text("I am not responsible for any damage, data loss, or any other issues caused by using this tool.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct ModernTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .padding(.horizontal)
    }
}

struct ModernButton: View {
    var text: String
    var icon: String
    var color: Color = .blue
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(text)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
            )
            .foregroundColor(.white)
            .padding(.horizontal)
        }
    }
}

struct ContentView: View {
    @State var ipaTool: IPATool?
    
    @State var appleId: String = ""
    @State var password: String = ""
    @State var code: String = ""
    
    @State var isAuthenticated: Bool = false
    @State var isDowngrading: Bool = false
    
    @State var appLink: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground).opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                HeaderView()
                
                Spacer()
                
                if !isAuthenticated {
                    // Login View
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("App Store Authentication")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Your credentials will be sent directly to Apple.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.bottom)
                        
                        ModernTextField(icon: "envelope", placeholder: "Apple ID", text: $appleId)
                        ModernTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
                        ModernTextField(icon: "key", placeholder: "2FA Code (required)", text: $code)
                        
                        ModernButton(text: "Authenticate", icon: "person.badge.key", color: .blue) {
                            if appleId.isEmpty || password.isEmpty {
                                alertMessage = "Please enter your Apple ID and password"
                                showingAlert = true
                                return
                            }
                            
                            if code.isEmpty {
                                ipaTool = IPATool(appleId: appleId, password: password)
                                ipaTool?.authenticate(requestCode: true)
                                alertMessage = "Please check your Apple devices for a verification code"
                                showingAlert = true
                                return
                            }
                            
                            let finalPassword = password + code
                            ipaTool = IPATool(appleId: appleId, password: finalPassword)
                            let ret = ipaTool?.authenticate()
                            isAuthenticated = ret ?? false
                            
                            if !isAuthenticated {
                                alertMessage = "Authentication failed. Please check your credentials and try again."
                                showingAlert = true
                            }
                        }
                        
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.yellow)
                            Text("You WILL need to provide a 2FA code to successfully log in.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.tertiarySystemBackground))
                        )
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding()
                } else {
                    if isDowngrading {
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                                    .frame(width: 100, height: 100)
                                
                                Circle()
                                    .trim(from: 0, to: 0.7)
                                    .stroke(
                                        LinearGradient(colors: [.blue, .purple], 
                                                      startPoint: .leading, 
                                                      endPoint: .trailing),
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .frame(width: 100, height: 100)
                                    .rotationEffect(Angle(degrees: 270))
                                    .rotationEffect(Angle(degrees: isDowngrading ? 360 : 0))
                                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isDowngrading)
                                
                                Image(systemName: "arrow.down.app")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                            }
                            .padding(.bottom, 10)
                            
                            Text("Downgrading in Progress")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("The app is being downgraded. This may take a while depending on the app size.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            ModernButton(text: "Done (Exit App)", icon: "xmark.circle", color: .red) {
                                exit(0)
                            }
                            .padding(.top, 20)
                        }
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                        .padding()
                    } else {
                        VStack(spacing: 24) {
                            VStack(spacing: 8) {
                                Text("Downgrade an App")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Enter the App Store link of the app you want to downgrade")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.bottom)
                            
                            ModernTextField(icon: "link", placeholder: "App Store Link or ID", text: $appLink)
                            
                            ModernButton(text: "Start Downgrade", icon: "arrow.down.app.fill", color: .green) {
                                if appLink.isEmpty {
                                    alertMessage = "Please enter an App Store link"
                                    showingAlert = true
                                    return
                                }
                                
                                var appLinkParsed = appLink
                                appLinkParsed = appLinkParsed.components(separatedBy: "id").last ?? ""
                                for char in appLinkParsed {
                                    if !char.isNumber {
                                        appLinkParsed = String(appLinkParsed.prefix(upTo: appLinkParsed.firstIndex(of: char)!))
                                        break
                                    }
                                }
                                print("App ID: \(appLinkParsed)")
                                isDowngrading = true
                                downgradeApp(appId: appLinkParsed, ipaTool: ipaTool!)
                            }
                            
                            ModernButton(text: "Log Out & Exit", icon: "rectangle.portrait.and.arrow.right", color: .red) {
                                isAuthenticated = false
                                EncryptedKeychainWrapper.nuke()
                                EncryptedKeychainWrapper.generateAndStoreKey()
                                sleep(3)
                                exit(0)
                            }
                        }
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                        .padding()
                    }
                }
                
                Spacer()
                
                FooterView()
                    .padding(.bottom)
            }
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            isAuthenticated = EncryptedKeychainWrapper.hasAuthInfo()
            print("Found \(isAuthenticated ? "auth" : "no auth") info in keychain")
            if isAuthenticated {
                guard let authInfo = EncryptedKeychainWrapper.getAuthInfo() else {
                    print("Failed to get auth info from keychain, logging out")
                    isAuthenticated = false
                    EncryptedKeychainWrapper.nuke()
                    EncryptedKeychainWrapper.generateAndStoreKey()
                    return
                }
                appleId = authInfo["appleId"]! as! String
                password = authInfo["password"]! as! String
                ipaTool = IPATool(appleId: appleId, password: password)
                let ret = ipaTool?.authenticate()
                print("Re-authenticated \(ret! ? "successfully" : "unsuccessfully")")
            } else {
                print("No auth info found in keychain, setting up by generating a key in SEP")
                EncryptedKeychainWrapper.generateAndStoreKey()
            }
        }
    }
}

#Preview {
    ContentView()
}
