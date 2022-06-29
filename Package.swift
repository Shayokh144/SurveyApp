// swift-tools-version:5.5
import Foundation
import PackageDescription

let package = Package(
     name: "SurveyApp-PRLinter",
     defaultLocalization: "en",
     products: [
       .library(name: "DangerDeps", type: .dynamic, targets: ["SurveyApp-PRLinter"])
     ],
     dependencies: [
         .package(url: "https://github.com/danger/swift.git", from: "3.12.3")
     ],
     targets: [
         .target(
             name: "SurveyApp-PRLinter",
             dependencies: [
                 .product(name: "Danger", package: "swift")
             ],
             path: "SurveyApp",
             sources: ["SurveyApp/src/utils/network/ReachabilityCenter.swift"]
         )
     ]
 )
