//
//  main.swift
//  pear
//  command line
//  Created by Pierre Segula on 6/4/22.
//

import Foundation

let arguments = CommandLine.arguments

if arguments.count < 2 {
    help()
    exit(0)
}

let arg: String = arguments[1]

switch arg {

case _ where arg.starts(with: "-i"):

    if arguments.count == 2 {
        print("Installing pearity login widget")
        LoginWindow.writeGlobalPlist()
    }

case _ where arg.starts(with: "-r"):

    if arguments.count == 2 {
        print("Removing pearity login widget")
        LoginWindow.removeGlobalPlist()
    }

default:
    help()
}

func help() {
    print("""

        🍐 pear

            -install
            -remove

    """)

}
