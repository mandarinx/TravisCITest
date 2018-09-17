using NUnit.Framework;
using Assert = UnityEngine.Assertions.Assert;

public class TestEditor {

    [Test]
    public void TestEditorSimplePasses() {
        Assert.IsTrue(true, "True is true");
    }
}
