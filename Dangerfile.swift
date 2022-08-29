import Danger

let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let changelogChanged = allSourceFiles.contains("CHANGELOG.md")
let sourceChanges = allSourceFiles.first(where: { $0.hasPrefix("Sources") })

if !changelogChanged && sourceChanges != nil {
  warn("No CHANGELOG entry added.")
}
warn("DANGER IS ADDED")
message("This is a test message...")
//SwiftLint.lint(lintAllFiles: true)
//SwiftLint.lint(.all(directory: "SurveyApp"))
let filesToLint = allSourceFiles.filter { !$0.contains("Documentation/") }
SwiftLint.lint(.files(filesToLint))