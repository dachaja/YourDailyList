name := "yourdailylist"

version := "1.0-SNAPSHOT"

libraryDependencies ++= Seq(
  javaJdbc,
  javaJpa.exclude("org.hibernate.javax.persistence", "hibernate-jpa-2.1-api"),
  "org.hibernate" % "hibernate-entitymanager" % "4.3.5.Final",
  cache
)     

play.Project.playJavaSettings
