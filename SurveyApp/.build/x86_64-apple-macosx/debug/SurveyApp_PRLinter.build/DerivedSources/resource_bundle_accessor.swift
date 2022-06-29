import class Foundation.Bundle

extension Foundation.Bundle {
    static var module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("ModularSlothCreator-PRLinter_SurveyApp-PRLinter.bundle").path
        let buildPath = "/Users/nimble/Documents/MyProjects/github/surveyapp/SurveyApp/SurveyApp/.build/x86_64-apple-macosx/debug/ModularSlothCreator-PRLinter_SurveyApp-PRLinter.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}