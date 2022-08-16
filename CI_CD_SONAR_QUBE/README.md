# HOMEWORK_CI_CD_SONAR_QUBE_9_2_(VITKIN_K_N)


#### *ВЫПОЛНЕНИЕ*
- *Создаём новый проект:My_Sonar_Projeckt*
- *Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)*
```
bash-5.0# PATH=/sonar-scanner/bin:$PATH
bash-5.0# export PATH
```
- *Проверяем sonar-scanner --version*
```
bash-5.0# sonar-scanner --version
INFO: Scanner configuration file: /sonar-scanner/conf/sonar-scanner.properties
INFO: Project root configuration file: /opt/sonarqube/sonar-project.properties
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-43-generic amd64

```
- *Запускаем анализатор против кода из директории example с дополнительным ключом -Dsonar.coverage.exclusions=fail.py*
```
bash-5.0# sonar-scanner   -Dsonar.projectKey=My_Sonar_Projeckt   -Dsonar.sources=.   -Dsonar.host.url=http://localhost:9000   -Dsonar.login=04f99851f3dc89c3925ef41797e2ce463f423bae -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /sonar-scanner/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-43-generic amd64
INFO: User cache: /root/.sonar/cache
INFO: Scanner configuration file: /sonar-scanner/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: Analyzing on SonarQube server 8.7.1
INFO: Default locale: "en_US", source code encoding: "UTF-8" (analysis is platform dependent)
INFO: Load global settings
INFO: Load global settings (done) | time=76ms
INFO: Server id: BF41A1F2-AYKiOrtuaLLhHRsQe_3R
INFO: User cache: /root/.sonar/cache
INFO: Load/download plugins
INFO: Load plugins index
INFO: Load plugins index (done) | time=42ms
INFO: Load/download plugins (done) | time=117ms
INFO: Process project properties
INFO: Process project properties (done) | time=8ms
INFO: Execute project builders
INFO: Execute project builders (done) | time=1ms
INFO: Project key: My_Sonar_Projeckt
INFO: Base dir: /example
INFO: Working dir: /example/.scannerwork
INFO: Load project settings for component key: 'My_Sonar_Projeckt'
INFO: Load project settings for component key: 'My_Sonar_Projeckt' (done) | time=14ms
INFO: Load quality profiles
INFO: Load quality profiles (done) | time=47ms
INFO: Load active rules
INFO: Load active rules (done) | time=1384ms
WARN: SCM provider autodetection failed. Please use "sonar.scm.provider" to define SCM of your project, or disable the SCM Sensor in the project settings.
INFO: Indexing files...
INFO: Project configuration:
INFO:   Excluded sources for coverage: fail.py
INFO: 1 file indexed
INFO: Quality profile for py: Sonar way
INFO: ------------- Run sensors on module My_Sonar_Projeckt
INFO: Load metrics repository
INFO: Load metrics repository (done) | time=27ms
INFO: Sensor Python Sensor [python]
INFO: Starting global symbols computation
INFO: 1 source files to be analyzed
INFO: Load project repositories
INFO: Load project repositories (done) | time=18ms
INFO: 1/1 source files have been analyzed
INFO: Starting rules execution
INFO: 1 source files to be analyzed
INFO: Sensor Python Sensor [python] (done) | time=6839ms
INFO: 1/1 source files have been analyzed
INFO: Sensor Cobertura Sensor for Python coverage [python]
INFO: Sensor Cobertura Sensor for Python coverage [python] (done) | time=11ms
INFO: Sensor PythonXUnitSensor [python]
INFO: Sensor PythonXUnitSensor [python] (done) | time=1ms
INFO: Sensor CSS Rules [cssfamily]
INFO: No CSS, PHP, HTML or VueJS files are found in the project. CSS analysis is skipped.
INFO: Sensor CSS Rules [cssfamily] (done) | time=1ms
INFO: Sensor JaCoCo XML Report Importer [jacoco]
INFO: 'sonar.coverage.jacoco.xmlReportPaths' is not defined. Using default locations: target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml
INFO: No report imported, no coverage information will be imported by JaCoCo XML Report Importer
INFO: Sensor JaCoCo XML Report Importer [jacoco] (done) | time=5ms
INFO: Sensor C# Properties [csharp]
INFO: Sensor C# Properties [csharp] (done) | time=1ms
INFO: Sensor JavaXmlSensor [java]
INFO: Sensor JavaXmlSensor [java] (done) | time=2ms
INFO: Sensor HTML [web]
INFO: Sensor HTML [web] (done) | time=3ms
INFO: Sensor VB.NET Properties [vbnet]
INFO: Sensor VB.NET Properties [vbnet] (done) | time=1ms
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=0ms
INFO: SCM Publisher No SCM system was detected. You can use the 'sonar.scm.provider' property to explicitly specify it.
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=14ms
INFO: Analysis report generated in 87ms, dir size=92 KB
INFO: Analysis report compressed in 24ms, zip size=13 KB
INFO: Analysis report uploaded in 19ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://localhost:9000/dashboard?id=My_Sonar_Projeckt
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://localhost:9000/api/ce/task?id=AYKnjiZGHvqE7ueBmuPi
INFO: Analysis total time: 10.057 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 11.106s
INFO: Final Memory: 7M/30M
INFO: ------------------------------------------------------------------------
bash-5.0# 
```
- *Смотрим результат в интерфейсе*
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/37.png )

![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/36.png )

#### *Знакомство с Nexus*
- *Выполняем  docker run -d -p 8081:8081 --name nexus sonatype/nexus3*

```
konstantin@konstantin-forever:~$ docker run -d -p 8081:8081 --name nexus sonatype/nexus3
7482c7d43f29295a5e0315bffa501fff61ca4d858cf107280c4589d2b7ebb77d
konstantin@konstantin-forever:~$ docker logs -f nexus
...
```
- *Проверяем готовность сервиса через бразуер*
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/38.png )
- *Узнаём пароль от admin через docker exec -it nexus /bin/bash*
```
konstantin@konstantin-forever:~$ docker exec -it nexus /bin/bash
bash-4.4$ cat nexus-data/admin.password 
2ebac9f7-fc83-4d79-bbdd-9afa9ad72158bash-4.4$ 
```
- *репозиторий maven-public загружаем артефакт с GAV параметрами:groupId: netology. artifactId: java. version: 8_282. classifier: distrib. type: tar.gz*
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/39.png )
- *В него же загружаем такой же артефакт, но с version: 8_102*
![](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/IMAGES/40.png )
![Файл maven-metadata.xml для артефекта в XML.](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/CI_CD_SONAR_QUBE/example/maven-metadata.xml)
- *Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)*
- *Проверяем mvn --version*
```
bash-4.4$ PATH=/apache-maven-3.8.6/bin:$PATH
bash-4.4$ export PATH
bash-4.4$ mvn --version
Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /apache-maven-3.8.6
Java version: 1.8.0_342, vendor: Red Hat, Inc., runtime: /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.342.b07-2.el8_6.x86_64/jre
Default locale: en_US, platform encoding: ANSI_X3.4-1968
OS name: "linux", version: "5.15.0-43-generic", arch: "amd64", family: "unix"
```
- *Забираем директорию mvn_ с pom*
```
konstantin@konstantin-forever:~/DEVOPS_COURSE/TASK_9_2$ docker cp /home/konstantin/DEVOPS_COURSE/TASK_9_2/mvn_ nexus:/
```

```
bash-4.4$ cd /mvn_
bash-4.4$ mvn package

```
![Файл pom.xml для артефекта в XML(Исправленный).](https://github.com/VitkinKN/HOMEWORKNETOLOGY/blob/master/CI_CD_SONAR_QUBE/mvn/pom.xml)

___
