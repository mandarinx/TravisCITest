using System;
using System.IO;
using UnityEngine;
using UnityEditor;

namespace Syng {

    public static class Builds {

        [MenuItem("Syng/Build")]
        public static void Build() {
//            string srcFolder = Environment.GetEnvironmentVariable("SRC_FOLDER");
            string prjName = Environment.GetEnvironmentVariable("UNITYCI_PROJECT_NAME");
            Console.WriteLine($"Source folder: {Application.dataPath}");
            Console.WriteLine($"Project name: {prjName}");

            string[] levels = {"Assets/Scenes/Test.unity"};
            string targetFolder = Path.Combine(Application.dataPath, "Builds", prjName);
            Console.WriteLine($"Target folder: {targetFolder}");

            BuildPipeline.BuildPlayer(levels,
                                      targetFolder,
                                      BuildTarget.iOS,
                                      BuildOptions.Development);
        }
    }
}
