import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.openURL) var openURL

    @AppStorage("isLarpEnabled", store: UserDefaults(suiteName: "group.com.byebakov.CPUpeek"))
    private var isLarpEnabled: Bool = false

    @AppStorage("larpModel", store: UserDefaults(suiteName: "group.com.byebakov.CPUpeek"))
    private var larpModel: String = "Macbook Pro"

    @AppStorage("larpCPU", store: UserDefaults(suiteName: "group.com.byebakov.CPUpeek"))
    private var larpCPU: String = "M4 Max"

    @AppStorage("customWidgetText", store: UserDefaults(suiteName: "group.com.byebakov.CPUpeek"))
    private var customWidgetText: String = ""

    @AppStorage("customWidgetFont", store: UserDefaults(suiteName: "group.com.byebakov.CPUpeek"))
    private var customWidgetFont: String = "Standard"

    let modelOptions = [
        "Macbook Air",
        "Macbook Pro",
        "Mac mini",
        "Mac Studio",
        "Mac Pro",
        "iMac"
    ]

    let cpuOptions = [
        "M1", "M1 Pro", "M1 Max", "M1 Ultra",
        "M2", "M2 Pro", "M2 Max", "M2 Ultra",
        "M3", "M3 Pro", "M3 Max", "M3 Ultra",
        "M4", "M4 Pro", "M4 Max",
        "M5", "M5 Pro", "M5 Max",
        "Intel Core 2 Duo",
        "Intel Core i3",
        "Intel Core i5",
        "Intel Core i7",
        "Intel Core i9",
        "Intel Xeon",
        "Intel Xeon W"
    ]

    let fontOptions = ["Standard", "Monospaced", "Rounded", "Serif"]

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "cpu.fill")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.white)
                }

                Text("CPU Peek")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Text("A simple desktop widget for tracking your Mac's CPU.")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)

                Button {
                    if let url = URL(string: "https://github.com/qweqqae/CPUpeek") {
                        openURL(url)
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Don’t forget to")
                            .foregroundColor(.white.opacity(0.6))
                        Text("star")
                            .foregroundColor(Color(red: 0.45, green: 0.65, blue: 1.0))
                        Text("on GitHub!")
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .font(.system(size: 11, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            .background(Capsule().fill(Color.white.opacity(0.03)))
                    )
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Medium Widget Text")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }

                HStack(spacing: 12) {
                    TextField("Custom text...", text: $customWidgetText)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                        .foregroundColor(.white)
                        .onChange(of: customWidgetText) {
                            WidgetCenter.shared.reloadAllTimelines()
                        }

                    Picker("", selection: $customWidgetFont) {
                        ForEach(fontOptions, id: \.self) { fontName in
                            Text(fontName).tag(fontName)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .onChange(of: customWidgetFont) {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.07), lineWidth: 1)
                    )
            )

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Larp My Mac")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()

                    Toggle("", isOn: $isLarpEnabled)
                        .toggleStyle(.switch)
                        .labelsHidden()
                        .onChange(of: isLarpEnabled) {
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                }

                if isLarpEnabled {
                    Divider()
                        .background(Color.white.opacity(0.08))

                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("MODEL")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white.opacity(0.5))

                            Picker("", selection: $larpModel) {
                                ForEach(modelOptions, id: \.self) { model in
                                    Text(model).tag(model)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .onChange(of: larpModel) {
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("CPU")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white.opacity(0.5))

                            Picker("", selection: $larpCPU) {
                                ForEach(cpuOptions, id: \.self) { cpu in
                                    Text(cpu).tag(cpu)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                            .onChange(of: larpCPU) {
                                WidgetCenter.shared.reloadAllTimelines()
                            }
                        }
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(isLarpEnabled ? Color.blue.opacity(0.4) : Color.white.opacity(0.07), lineWidth: 1)
                    )
            )

            HStack(spacing: 12) {
                CardView(
                    badgeColor: Color.white.opacity(0.08),
                    systemIcon: "curlybraces",
                    assetIcon: nil,
                    title: "Project Repo",
                    buttonTitle: "Open Repo",
                    buttonTextColor: .white
                ) {
                    if let url = URL(string: "https://github.com/qweqqae/CPUpeek") {
                        openURL(url)
                    }
                }

                CardView(
                    badgeColor: Color.green.opacity(0.15),
                    systemIcon: "person.fill",
                    assetIcon: "Github",
                    title: "Author Profile",
                    buttonTitle: "Open Profile",
                    buttonTextColor: Color(red: 0.4, green: 0.85, blue: 0.4)
                ) {
                    if let url = URL(string: "https://github.com/qweqqae") {
                        openURL(url)
                    }
                }
            }

            Spacer()
        }
        .padding(20)
        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 480, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .ignoresSafeArea()
    }
}

struct CardView: View {
    let badgeColor: Color
    let systemIcon: String
    let assetIcon: String?
    let title: String
    let buttonTitle: String
    let buttonTextColor: Color
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(badgeColor)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: systemIcon)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }

            Button(action: action) {
                HStack(spacing: 5) {
                    if let assetIcon = assetIcon {
                        Image(assetIcon)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 12, height: 12)
                            .foregroundColor(buttonTextColor)
                    } else {
                        Image(systemName: "arrow.up.right.square")
                            .font(.system(size: 11))
                            .foregroundColor(buttonTextColor)
                    }

                    Text(buttonTitle)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(buttonTextColor)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.04)))
                )
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }
}
