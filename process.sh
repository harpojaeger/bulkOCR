calc(){ awk "BEGIN { print $*}"; }
int(){ awk "BEGIN { print int($1)}"; }
width=`tput cols`
height=`tput lines`
updatebar ()
{
#First param: current number.  Second: total.
prop=`calc $1/$2`
percentage=`calc 100*$prop`
percentage=`int $percentage`
header="item $1/$2 ($percentage%) "
headerlength=${#header}
totalbarlength=`calc $width-$headerlength-2`
barlength=`calc $totalbarlength*$prop`
barchars=`int $barlength`
bar="for i in `seq 1 $barchars`; do printf \#; done;"
thebar=`eval $bar`
echo "$header $thebar\r\c"
}

cd all_imgs
mogrify -identify -path ../cropped -gravity southeast -crop 1710x100+0+0 *
cd ../cropped
numfiles=`ls -1 | wc -l`
n=1
Echo "OCRing..."
for i in $( ls ); do
tesseract $i $i &> /dev/null
#cat $i.txt >> data.txt
read -r FIRSTLINE < $i.txt
echo $FIRSTLINE >> ~/Desktop/CF\ camera\ photos/data.txt
rm $i.txt
updatebar $n $numfiles
((n++))
done
echo "\nDone."