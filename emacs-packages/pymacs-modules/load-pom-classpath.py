#import file
from Pymacs import pymacs
import commands, os, sys

emacs = pymacs.lisp

interactions = {}

savedClassPaths = {}

def findPom(path):
    path, tail = os.path.split(path)
    while len(path) > 1:
        files = os.listdir(path)
        for file in files:
            if file == "pom.xml":
                return True, path
        path, tail = os.path.split(path)
    print "Error couldn't find pom.xml in path above:", os.getcwd()
    return False, ''

def getSaved(path):
    path, tail = os.path.split(path)
    while len(path) > 1:
        if savedClassPaths.has_key(path):
            return (True, path, savedClassPaths.get(path))
        path, tail = os.path.split(path)

    return (False, '', '')

def callMaven(pomPath):
    os.chdir(pomPath)
    status, output = commands.getstatusoutput("mvn dependency:build-classpath")
    if status != 0:
        print "Error: Couldn't run mvn dependency:build-classpath.  See Error output below."
        print output
    CLASSPATH_START = "[INFO] Dependencies classpath:"
    CLASSPATH_END = "[INFO]"
    start = output.find(CLASSPATH_START) + len(CLASSPATH_START) + 1
    end = output.find(CLASSPATH_END, start) - 1
    classpath = output[start:end]
    savedClassPaths[pomPath] = classpath
    return classpath

def getClasspath(path):
    found, pomPath, classpath = getSaved(path)
    if not found:
        found, pomPath = findPom(path)
        if found:
            classpath = callMaven(pomPath)

    return classpath

def getSourcepath(path):
    found, pomPath, classpath = getSaved(path)
    if not found:
        found, pomPath = findPom(path)

    return os.path.join(pomPath, "src/main/java")
                
def main():
    print "classpath:", getClasspath("/shared/sparker/repos/watch/loader/src/main/java/com/tuc/watch/loader/processors/updater/WatchUpdater.java")
    print "classpath:", getClasspath("/shared/sparker/repos/watch/loader/src/main/java/com/tuc/watch/loader/processors/validator/WatchValidator.java")
    print "classpath:", getClasspath("/shared/sparker/repos/watch/base/src/main/java/com/tuc/watch/base/dao/IndicDao.java")
    print "sourcepath:", getSourcepath("/shared/sparker/repos/watch/loader/src/main/java/com/tuc/watch/loader/processors")
    
if __name__ == "__main__":
    main()
