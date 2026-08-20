import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#endif

public class StorageUtilityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
      let messenger = registrar.messenger()
    #else
      let messenger = registrar.messenger
    #endif
    let channel = FlutterMethodChannel(
      name: "plugins.deephow.com/storage_utility", binaryMessenger: messenger)
    let instance = StorageUtilityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    let path: String? = (args?["path"] as? String) ??
      NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

    switch call.method {
    case "getFreeBytes":
      return result(getFreeBytes(path: path))
    case "getTotalBytes":
      return result(getTotalBytes(path: path))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func getFreeBytes(path: String?) -> Int64? {
    if #available(iOS 11.0, *) {
      guard let path,
        let freeBytes = try? URL(fileURLWithPath: path).resourceValues(forKeys: [
          .volumeAvailableCapacityForImportantUsageKey
        ]).volumeAvailableCapacityForImportantUsage
      else { return nil }
      return freeBytes
    } else {
      guard let path,
        let attributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
        let freeBytes = (attributes[.systemFreeSize] as? NSNumber)?.int64Value
      else { return nil }
      return freeBytes
    }
  }

  func getTotalBytes(path: String?) -> Int64? {
    guard let path,
      let attributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
      let totalBytes = (attributes[.systemSize] as? NSNumber)?.int64Value
    else { return nil }
    return totalBytes
  }
}
