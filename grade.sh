CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

if [[ -f "student-submission/ListExamples.java" ]]
then 
    echo "Correct file exists"
else 
    echo "The correct file doesn't exist. Put code in ListExamples.java"
    exit
fi

cp student-submission/ListExamples.java ./

CLASS_CHECKER=`grep "class ListExamples" ListExamples.java`

if [[ $CLASS_CHECKER == "" ]]
then 
    echo "Must have a class ListExamples"
    exit
fi

FILTER_CHECKER=`grep "static List<String> filter(List<String>" ListExamples.java`

if [[ $FILTER_CHECKER == "" ]]
then 
    echo "filter method signature is wrong"
    exit
fi

MERGE_CHECKER=`grep "static List<String> merge(List<String>" ListExamples.java`

if [[ $MERGE_CHECKER == "" ]]
then 
    echo "merge method signature is wrong"
    exit
fi

javac -cp $CPATH *.java

if [[ $? -eq 0 ]]
then
    echo "Compiled successfully"
else 
    echo "Your program didn't compile."
    exit
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > grader.txt
TEST_OUTPUT=`grep "Tests run: " grader.txt`

echo ""

if [[ $TEST_OUTPUT == "" ]]
then 
    echo "YAY! You get 100%"
    exit
fi

echo $TEST_OUTPUT