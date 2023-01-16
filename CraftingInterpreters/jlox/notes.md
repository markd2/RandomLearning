javac com/borkware/lox/*.java com/borkware/tools/*.java
jar cfm splunge.jar manifest.mf com
java -jar splunge.jar

java -jar splunge.jar stuff.lox

# repl
javac com/borkware/lox/*.java com/borkware/tools/*.java && jar cfm splunge.jar manifest.mf com && java -jar splunge.jar

# stuff
javac com/borkware/lox/*.java com/borkware/tools/*.java && jar cfm splunge.jar manifest.mf com && java -jar splunge.jar stuff.lox

# simpler
javac com/borkware/lox/*.java com/borkware/tools/*.java && jar cfm splunge.jar manifest.mf com && java -jar splunge.jar stuff2.lox

# codegen
java com/borkware/tools/*.java com/borkware/lox

