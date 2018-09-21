using System;
using UnityEngine;
using UnityEditor;

namespace Syng {

    public static class Builds {

        private static bool GetArgument(string name, out string value) {
		    string[] args = Environment.GetCommandLineArgs();
            for (int i = 0; i < args.Length; i++) {
                if (!args[i].Contains(name)) {
                    continue;
                }
                value = args[i + 1];
                return true;
            }

            value = string.Empty;
            return false;
        }

        [MenuItem("Syng/Build")]
        public static void Build() {
            string buildPath;
            if (!GetArgument("syngBuildPath", out buildPath)) {
                Debug.Log("Missing syngBuildPath from command line arguments");
                return;
            }

            Debug.Log($"Build to {buildPath}");
            string[] levels = {"Assets/Scenes/Test.unity"};
            BuildPipeline.BuildPlayer(levels,
                                      buildPath,
                                      BuildTarget.iOS,
                                      BuildOptions.Development);
        }
    }
}
