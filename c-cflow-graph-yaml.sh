echo "create "$1".yaml start."
find $2 -name "*.[ch]" | xargs cflow -m $1  2> /dev/null | sed -r '/^\s*(pr_[^\(]+|printk|ssize_t|loff_t)\(\)/d' | perl -pe 's/^(\s*)([^\(]+)\(\)(?:$|\s+<.* at ([^>]+)>.*$)/\1\2:\n\1    file: \3/' > open.yaml
echo "create "$1".yaml end."
