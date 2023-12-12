import HelloWorld (hello)
import Test.Hspec (Spec, it, shouldBe)
import Test.Hspec.Runner (configFastFail, defaultConfig, hspecWith)

main :: IO ()
main = hspecWith defaultConfig {configFastFail = True} specs

specs :: Spec
specs =
  it "hello" $
    hello `shouldBe` "Hello, World!"
