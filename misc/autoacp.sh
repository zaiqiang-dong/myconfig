git add .
if [ $# -eq 0 ]
then
	read -p "input commit info:"  commitinfo
	git commit -m "$commitinfo"
else
	commitinfo=$@
	git commit -m "$commitinfo"
fi
git push
