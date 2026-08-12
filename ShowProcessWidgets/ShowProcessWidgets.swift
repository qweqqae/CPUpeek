import WidgetKit
import SwiftUI

func getCPUName() -> String {
    let appGroupID = "group.com.byebakov.CPUpeek"
    if let defaults = UserDefaults(suiteName: appGroupID), defaults.bool(forKey: "isLarpEnabled") {
        let larpCPU = defaults.string(forKey: "larpCPU") ?? "M4 Max"
        if !larpCPU.isEmpty { return larpCPU }
    }

    var size = 0
    if sysctlbyname("machdep.cpu.brand_string", nil, &size, nil, 0) == 0 && size > 1 {
        var machine = [CChar](repeating: 0, count: size)
        if sysctlbyname("machdep.cpu.brand_string", &machine, &size, nil, 0) == 0 {
            let cpu = String(cString: machine).trimmingCharacters(in: .whitespacesAndNewlines)
            if !cpu.isEmpty {
                return cpu.replacingOccurrences(of: "Apple ", with: "")
            }
        }
    }
    
    var chipSize = 0
    if sysctlbyname("hw.chip_model", nil, &chipSize, nil, 0) == 0 && chipSize > 1 {
        var chipMachine = [CChar](repeating: 0, count: chipSize)
        if sysctlbyname("hw.chip_model", &chipMachine, &chipSize, nil, 0) == 0 {
            let chip = String(cString: chipMachine).trimmingCharacters(in: .whitespacesAndNewlines)
            if !chip.isEmpty {
                return chip.replacingOccurrences(of: "Apple ", with: "")
            }
        }
    }
    
    return "Apple Silicon"
}

func getMacModelName() -> String {
    let appGroupID = "group.com.byebakov.CPUpeek"
    if let defaults = UserDefaults(suiteName: appGroupID), defaults.bool(forKey: "isLarpEnabled") {
        let larpModel = defaults.string(forKey: "larpModel") ?? "Macbook Pro"
        if !larpModel.isEmpty { return larpModel }
    }

    var size = 0
    if sysctlbyname("hw.model", nil, &size, nil, 0) == 0 && size > 1 {
        var machine = [CChar](repeating: 0, count: size)
        if sysctlbyname("hw.model", &machine, &size, nil, 0) == 0 {
            let model = String(cString: machine).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if model.contains("MacBookAir") { return "Macbook Air" }
            if model.contains("MacBookPro") { return "Macbook Pro" }
            if model.contains("Macmini") { return "Mac mini" }
            if model.contains("MacPro") { return "Mac Pro" }
            if model.contains("MacStudio") { return "Mac Studio" }
            if model.contains("iMac") { return "iMac" }
            
            let knownModels: [String: String] = [
                "Mac14,2": "Macbook Air", "Mac14,15": "Macbook Air", "Mac15,12": "Macbook Air", "Mac15,13": "Macbook Air",
                "Mac14,5": "Macbook Pro", "Mac14,6": "Macbook Pro", "Mac14,9": "Macbook Pro", "Mac14,10": "Macbook Pro",
                "Mac15,3": "Macbook Pro", "Mac15,6": "Macbook Pro", "Mac15,7": "Macbook Pro", "Mac15,8": "Macbook Pro",
                "Mac14,3": "Mac mini", "Mac14,12": "Mac mini", "Mac16,10": "Mac mini", "Mac16,11": "Mac mini",
                "Mac13,1": "Mac Studio", "Mac13,2": "Mac Studio", "Mac14,13": "Mac Studio", "Mac14,14": "Mac Studio",
                "Mac14,8": "Mac Pro", "Mac15,4": "iMac", "Mac15,5": "iMac"
            ]
            return knownModels[model] ?? "Macbook Air"
        }
    }
    return "Macbook Air"
}

func getCustomWidgetText() -> String {
    let appGroupID = "group.com.byebakov.CPUpeek"
    if let defaults = UserDefaults(suiteName: appGroupID) {
        return defaults.string(forKey: "customWidgetText") ?? ""
    }
    return ""
}

func getCustomWidgetFont() -> Font {
    let appGroupID = "group.com.byebakov.CPUpeek"
    let fontStyle = UserDefaults(suiteName: appGroupID)?.string(forKey: "customWidgetFont") ?? "Standard"
    
    switch fontStyle {
    case "Monospaced":
        return .system(size: 15, weight: .medium, design: .monospaced)
    case "Rounded":
        return .system(size: 15, weight: .medium, design: .rounded)
    case "Serif":
        return .system(size: 15, weight: .medium, design: .serif)
    default:
        return .system(size: 15, weight: .medium, design: .default)
    }
}

struct SimpleProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry { SimpleEntry(date: Date()) }
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) { completion(SimpleEntry(date: Date())) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CPUWidgetView: View {
    let cpuName = getCPUName()
    let modelName = getMacModelName()
    let customText = getCustomWidgetText()
    let customFont = getCustomWidgetFont()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white.opacity(0.14))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "cpu.fill")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Text("MAC")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Circle()
                        .fill(Color.green)
                        .frame(width: 6, height: 6)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white.opacity(0.12)))
            }
            
            Spacer(minLength: 6)
            
            Text(modelName)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .lineLimit(1)
            
            Spacer(minLength: 10)
            
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("CPU")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.65))
                        .tracking(0.5)
                    
                    Text(cpuName)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                }
                
                if !customText.isEmpty {
                    Spacer()
                    
                    Text(customText)
                        .font(customFont)
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding(14)
    }
}

@main
struct ShowProcessWidgets: Widget {
    let kind: String = "CPUWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SimpleProvider()) { _ in
            CPUWidgetView()
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("CPU Peek")
        .description("Displays your Mac model and CPU chip.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
