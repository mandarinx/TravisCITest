using System;
using UnityEditor;

namespace Syng {

    public static class Builds {

        [MenuItem("Syng/Build")]
        public static void Build() {
            string srcFolder = Environment.GetEnvironmentVariable("SRC_FOLDER");
            string prjName = Environment.GetEnvironmentVariable("PROJECT_NAME");
            Console.WriteLine($"Source folder: {srcFolder}");
            Console.WriteLine($"Project name: {prjName}");

            string[] levels = {"Assets/Scenes/Test.unity"};

            BuildPipeline.BuildPlayer(levels,
                                      srcFolder + "/Builds/" + prjName,
                                      BuildTarget.iOS,
                                      BuildOptions.Development);
        }
    }
}
