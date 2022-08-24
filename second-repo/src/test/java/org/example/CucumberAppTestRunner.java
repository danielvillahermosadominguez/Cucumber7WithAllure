package org.example;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;
@RunWith(Cucumber.class)
@CucumberOptions(features = "src/test/resources/features",
        plugin = {"pretty",
                "json:target/jsonReports/features.json",
                "html:target/cucumber/features.html","io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm"})
public class CucumberAppTestRunner {
}
