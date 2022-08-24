echo emulation of pipeline
echo initiating...

json=$(curl -X POST -H 'Content-Type: application/json' -d '{"username":"my_username","password":"my_password"}' -c cookiesFile -ik http://localhost:7272/allure-docker-service/login)
token=$(echo $json | grep -o '"access_token":"[^"]*' | grep -o '[^"]*$')
curl -X GET http://localhost:7272/allure-docker-service/clean-results -b cookiesFile -ik
rm ../../../target/allure-results/*

echo compiling maven projects
mvn clean test
mvn -f second-repo/pom.xml clean test


echo copying results of first maven project
cp ./target/allure-results/* ../../../target/allure-results
cp ./second-repo/target/allure-results/* ../../../target/allure-results



echo generating report
curl -X GET http://localhost:7272/allure-docker-service/generate-report -b cookiesFile -ik


