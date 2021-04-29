printenv

for file in tests/src/*.{res,resi}; do
  output="$(dirname $file)/expected/$(basename $file).txt"
  ./rescript-editor-analysis.exe test $file &> $output
  # CI
  echo "inside loop now"
  echo $RUNNER_OS
  if [ "$RUNNER_OS" == "Windows" ]; then
    echo "sedding..."
    sed -i "s/\r\n/\n/g" $output
  fi
done

./testmore.exe > helloworld.txt
./testfile.exe > helloworld2.txt
./testfile2.exe > helloworld3.txt

echo "cat basetest.txt"
cat -A basetest.txt
echo "------"
echo "cat basetest.txt > pipetest.txt then cat"
cat basetest.txt > pipetest.txt
cat -A pipetest.txt
echo "------"
echo "cat helloworld.txt"
cat -A helloworld.txt
echo "------"
echo "cat helloworld2.txt"
cat -A helloworld2.txt
echo "------"
echo "cat helloworld3.txt"
cat -A helloworld3.txt
echo "------"

# echo "dox2unix helloworld.txt"
# dos2unix helloworld.txt
# echo "------"
# echo "dox2unix helloworld2.txt"
# dos2unix helloworld2.txt
# echo "------"
# echo "dox2unix helloworld3.txt"
# dos2unix helloworld3.txt
# echo "------"
# echo "========all done!========="

warningYellow='\033[0;33m'
successGreen='\033[0;32m'
reset='\033[0m'

diff=$(git ls-files --modified tests/src/expected)
if [[ $diff = "" ]]; then
  printf "${successGreen}✅ No unstaged tests difference.${reset}\n"
else
  printf "${warningYellow}⚠️ There are unstaged differences in tests/! Did you break a test?\n${diff}\n${reset}"
  git --no-pager diff --word-diff-regex=. tests/src/expected/Auto.res.txt
  exit 1
fi
