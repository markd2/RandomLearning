javac com/borkware/lox/*.java com/borkware/tools/*.java
jar cfm splunge.jar manifest.mf com
java -jar splunge.jar

java -jar splunge.jar stuff.lox


javac com/borkware/lox/*.java com/borkware/tools/*.java && jar cfm splunge.jar manifest.mf com && java -jar splunge.jar stuff.lox

javac com/borkware/lox/*.java com/borkware/tools/*.java && jar cfm splunge.jar manifest.mf com && java -jar splunge.jar stuff.lox


java -cp splunge.jar com.borkware.tools.GenerateAst
javac com/borkware/lox/*.java com/borkware/tools/*.java && jar cfm splunge.jar manifest.mf com && java -cp splunge.jar com.borkware.tools.GenerateAst
