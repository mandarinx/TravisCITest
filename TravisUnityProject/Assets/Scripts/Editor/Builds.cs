using System;
using System.IO;
using UnityEngine;
using UnityEditor;

namespace Syng {

    public static class Builds {

        [MenuItem("Syng/Build")]
        public static void Build() {
            string prjName = Environment.GetEnvironmentVariable("UNITY_PROJECT_NAME");
            string targetFolder = Path.GetFullPath(Path.Combine(Application.dataPath, "../../Builds/iOS"));
            Console.WriteLine($"Project name: {prjName}");
            Console.WriteLine($"Target folder: {targetFolder}");

            string[] levels = {"Assets/Scenes/Test.unity"};

            BuildPipeline.BuildPlayer(levels,
                                      targetFolder,
                                      BuildTarget.iOS,
                                      BuildOptions.Development);
        }
    }
}
