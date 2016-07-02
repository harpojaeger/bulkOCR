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

numfiles=`ls -l some_imgs | wc -l`
mogrify -identify -path cropped -gravity southeast -crop 1710x100+0+0 +repage some_imgs/* | awk -v n="$numfiles" '
BEGIN {
  print "Hello world."
  i=1
  #n is 1 too big because ls | wc is weird.
  n--
}{
  printf ("%s (%u/%u) \n",$0,i,n)
  i++
}
'
cd cropped
numfiles=`ls -1 | wc -l`
n=1
echo "OCRing..."
for i in $( ls ); do
  tesseract $i ../txt/$i -psm 7 &> /dev/null
  
  
  updatebar $n $numfiles
  ((n++))
done
echo "\nCompiling data..."
grep -hv "^$" ../txt/* >> ../data.txt
echo "Done."
