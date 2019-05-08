#find cscope file to cscope.files
find . -name "*.java" > ./cscope.files
find . -name "*.cpp" >> ./cscope.files
find . -name "*.h" >> ./cscope.files
ctags -R
cscope -Rbqk;
