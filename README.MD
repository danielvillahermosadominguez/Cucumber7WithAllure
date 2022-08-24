# Example of project with Cucumber 7.x and Allure
This is an simple example to configurate a maven project with:
- Junit 5.x
- Cucumber 7.x
- Allure


## POM.XML and dependencies

### versions of libraries

``` xml
   <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <junit.jupiter.version>5.9.0-M1</junit.jupiter.version>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <cucumber.version>7.3.4</cucumber.version>
        <allure.cucumber7.version>2.19.0</allure.cucumber7.version>
        <cucumber.reporting.version>5.7.2</cucumber.reporting.version>
        <maven.surefire.plugin.version>3.0.0-M7</maven.surefire.plugin.version>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
        <aspectj.version>1.9.6</aspectj.version>
        <slf4j.version>1.6.1</slf4j.version>
    </properties>
```

### Junit Jupiter 5.x

Out version to configurate will be Junit Jupiter 5.x. and Cucumber needs compatibility with Junit 4.x so we will need the
``` xml
 <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter-api</artifactId>
      <version>${junit.jupiter.version}</version>
      <scope>test</scope>
  </dependency>
  <dependency>
      <groupId>org.junit.vintage</groupId>
      <artifactId>junit-vintage-engine</artifactId>
      <version>${junit.jupiter.version}</version>
   </dependency>
```
### Cucumber 7
With Cucumber we will be able to execute cucumber Scenarios and with cucumber-junit, we could have
results in format of junit for this kind of tests.

``` xml
  <dependency>
      <groupId>io.cucumber</groupId>
      <artifactId>cucumber-java</artifactId>
      <version>${cucumber.version}</version>
      <scope>test</scope>
    </dependency>

    <dependency>
      <groupId>io.cucumber</groupId>
      <artifactId>cucumber-junit</artifactId>
      <version>${cucumber.version}</version>
      <scope>test</scope>
    </dependency>
```

### Allure

This library allows us to adapt the output of junit and cucumber to allure
You will ned slf4j to avoid errors.

``` xml
   <dependency>
      <groupId>io.qameta.allure</groupId>
      <artifactId>allure-cucumber7-jvm</artifactId>
      <version>${allure.cucumber7.version}</version>
    </dependency>
     <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
            <version>${slf4j.version}</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-simple</artifactId>
            <version>${slf4j.version}</version>
        </dependency>
```
In addition, if you would want to include in your Allure report other Junit tests (Unit tests for example) you will need
the following dependency. In this case, you will see, if you use cucumber, you will see repeated steps. For every step, you
will have in the report a Unit test, part of having the cucumber scenarios.
``` xml
   <dependency> 
            <groupId>io.qameta.allure</groupId>
            <artifactId>allure-junit5</artifactId>
            <version>2.19.0</version>
        </dependency>
```
### Cucumber Reporting
An additional html report could be net.masterthought. This is not necessary for the integration with allure.
``` xml
 <dependency>
    <groupId>net.masterthought</groupId>
    <artifactId>cucumber-reporting</artifactId>
    <version>${cucumber.reporting.version}</version>
</dependency>
```

## POM.XML and pluggins
# Configuration of the surefire plugin
We are going to configurate several things:

* the output folder for the files which are input for Allure: "allure-results"
* aspectjweaver (AOP) 
* Enabling the autodetection for junit jupiter

``` xml
 <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>${maven.surefire.plugin.version}</version>
                <configuration>
                    <includes>
                        <include>**/*.java</include>
                    </includes>
                    <testFailureIgnore>true</testFailureIgnore>
                    <systemPropertyVariables>
                        <allure.results.directory>${project.build.directory}/allure-results</allure.results.directory>
                    </systemPropertyVariables>
                    <argLine>
                        -javaagent:"${settings.localRepository}/org/aspectj/aspectjweaver/${aspectj.version}/aspectjweaver-${aspectj.version}.jar"
                    </argLine>
                    <systemProperties>
                        <property>
                            <name>junit.jupiter.extensions.autodetection.enabled</name>
                            <value>true</value>
                        </property>
                    </systemProperties>
                </configuration>
                <dependencies>
                    <dependency>
                        <groupId>org.aspectj</groupId>
                        <artifactId>aspectjweaver</artifactId>
                        <version>${aspectj.version}</version>
                    </dependency>
                </dependencies>
            </plugin>
```
# Jacoco plugin for coverage
This is not necessary for the configuration of allure but it offers us a good reporting for coverage
``` xml
 <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>0.8.8</version>
                <executions>
                    <execution>
                        <id>coverage-initialize</id>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>coverage-report</id>
                        <goals>
                            <goal>report</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
```
## Folder structure for Cucumber
For this example we will use the following structure in the test folder:
``` 
+ test
  + java
    + org.example
      + AppTest.java => A simple dummy unit test in junit 5.x
      + CucumberAppTestRunner.java => The runner for cucumber
      + StepDefsDummyExample.java => the specification code for Cucumber Feature
    + resoures
      + features
        + example.feature => a simple dummy feature with cucumber
```
### The Cucumber Runner

It is necessary to create a specific runner for Cucumber and configurate it for Allure.
You can see the runner is based on Junit4. So, we need to look for compatibility with Junit 5 with the
library junit-vintage
In addition, we need to include the "glue" which is the path where cucumber can find the features, the
plugin for the report html that is generated by cucumber by default.

We have also to include the allure plugin in the configuration. In this case: io.qmeta.allure.cucumber7jvn.AllureCucumber7vm

``` java
@RunWith(Cucumber.class)
@CucumberOptions(features = "src/test/resources/features",
        plugin = {"pretty",
                "json:target/jsonReports/features.json",
                "html:target/cucumber/features.html","io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm"})
public class CucumberAppTestRunner {
}
```
### The Feature Steps
TBD

# Generating and using Allure with the example
## Step 1. Install Allure
For Windows, first of all you will need to install scoop in your operative system. You have the help in this URL:
https://github.com/ScoopInstaller/Install#for-admin%20for%20details

``` cmd
scoop install allure
```

In Ubuntu you only have to:
```
sudo apt-get install -y allure
```
## Step 2. compile and pass the tests
You don't need to execute until the goal "install" (with the goal test is enough), but with install you could generate 
the cucumber html report (an additional) and the report for coverage with Jaccoco. You can see this reports in the folder
"target"
```
mvn install
```
* target/cucumber/feature.html <= default html report for cucumber
* target/.. => ERROR: No funciona la cobertura, revisar
* tartet/allure-results => todo el input para allure
* 
## Step 3. Execute Allure
``` cmd
allure serve
```
# How to structure the epics
In our example, one of the thing we want to do is to use Allure as a source of documentation of Features. 
For this, we need to use @tags of cucumber in the features. With this tags we could categorize the specification in
* highLevel documentation with the @highlevel
* lowlevel documentation with the @lowlevel
* And we could use another categories to filter the information, for example for capabilities.
NOTE: It is important, to take into account the tags must be in lowercase always. In other way, it won't work.

# Using Allure Docker Service and Allure Docker Service UI
## Preparing the environment
In this respository we have a folder with Allure Docker service. This image works with the 2.17.2 version
of allure but we want it works with 2.19 which includes a new feature : filter with tags. Basically, when
you search in the user interface, you could use the following expresion to filter by tags:
```
tags:tag1,tag2,tag3
```
In this filter you need to have into account two things:
* tags must be always in lower case. In other case, allure will ignore it. 
* wen you write several tags, you are using an "and". For example in the example above would be "tag1 and tag2 and tag3"

One of the thing you could do is to use allure docker service. You have the information here:
https://github.com/fescobar/allure-docker-service
https://github.com/fescobar/allure-docker-service-ui

First of all, we need to use the docker composer file: allure-docker-service/docker-custom/Dockerfile.bionic-custom.yml
This is a docker file with the version of allure changed by 2.19.0. You'll need to build the image:
In the folder allure-docker-service:
```
 -- The first time, you will need to rebuild the image
 sudo docker compose -f docker-compose-dev.yml up --build
 -- After, you don't need to build. You can use
 sudo docker compose -f docker-compose-dev.yml up
```
In this case, you will be able to access to the:
* API:http://localhost:7272/allure-docker-service/
* GUI:http://localhost:7474/allure-docker-service-ui/projects/default
In the local machine will be created a folder in ../target/allure-results

The results of the allure must be included in this folder and you could:
a) use the allure-docker-service-ui and in the "default" project click on: "Generate Report"
b) use the api and call the endpoint: /generate-report with the parameter project_id = default

## Simulating a pipeline with the script "updateAllure.sh"
This is an example to simulate a pipeline.
This script do the following actions:
* clean the folder where the results have to be located
* call the api to clean internally the folder with the results
* generate the results in target/allure-results
* copy the results to the folder which is expected by allure docker service
* call the API to generate the report

We are using always the default project for this example.