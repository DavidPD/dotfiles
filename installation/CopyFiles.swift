#!swift sh

import Files // @JohnSundell ~> 4.0.2
import Swiftline // @bow-swift ~> 0.5.3

class Installer {

    enum FileAction: String, CaseIterable {
        case skip = "Skip this file"
        case overwrite = "Overwrite this file"
        case skipAll = "Skip all remaining files"
        case overwriteAll = "Overwrite all remaining files"
        case cancel = "Cancel (all previous files will be canceled)"
    }

    static func install() {
        try! copyExampleConfigs(from: Folder.current.subfolder(at: "config"), to: Folder.home)
    }

    static func copyExampleConfigs(from source: Folder, to destination: Folder, ext: String = "example") {

        var filesToCopy : [File] = []
        var conflictingFiles : [File] = []
        var filesToDelete : [File] = []

        try! source.files
            .recursive
            .filter { $0.extension == ext }
            .forEach { file in
                let name = destinationFileName(for: file)
                if destination.containsFile(at: name) {
                    conflictingFiles.append(file)
                } else {
                    filesToCopy.append(file)
                }
            }

        if conflictingFiles.count > 0 {
            print("There are \(conflictingFiles.count) conflicting files".f.Red)
            conflictingFiles.forEach { file in
                print((file.name + " -> " + destinationFileName(for: file)).f.Yellow)
            }
        }

        var allRemainingAction: FileAction? = nil

        for file in conflictingFiles {
            let destinationFile = try! destination.file(at: destinationFileName(for: file))
            print((destinationFile.path + " Already exists").f.Red)
            let choice = allRemainingAction ?? choose(
                "What would you like to do? ".f.Red, type: FileAction.self) { settings in
                    for setting in FileAction.allCases {
                        settings.addChoice(setting.rawValue) { setting }
                    }
            }

            switch choice {
                case .overwriteAll:
                    allRemainingAction = .overwrite
                    fallthrough // still execute overwriting logic
                case .overwrite:
                    filesToDelete.append(destinationFile)
                    filesToCopy.append(file)
                    print(destinationFile.name + " will be deleted")
                case .skipAll:
                    allRemainingAction = .skip
                    fallthrough // still execute skipping logic
                case .skip:
                    print(destinationFile.name + " will be left as-is")
                case .cancel:
                    allRemainingAction = .cancel
            }

            if allRemainingAction == .cancel {
                break
            }
        }

        if allRemainingAction != .cancel {
            for destinationFile in filesToDelete {
                print(("Deleting " + destinationFile.name).f.Yellow)
                try! destinationFile.delete()
            }

            for file in filesToCopy {
                let name = destinationFileName(for: file)
                print(("Copying " + file.name + " to " + destination.path + name).f.Green)
                try! file.copy(to: destination).rename(to: name, keepExtension: false)
            }
        }

    }

    static func destinationFileName(for file: File) -> String {
        return "." + file.nameExcludingExtension
    }
}

Installer.install()
