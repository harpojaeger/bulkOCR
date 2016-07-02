numfiles=`ls -l some_imgs | wc -l`
mogrify -identify -path cropped -gravity southeast -crop 1710x100+0+0 +repage some_imgs/* | awk -v n="$numfiles" '
BEGIN {
  i=1
  #n is 1 too big because ls | wc is weird.
  n--
}{
  printf ("%s (%u/%u)\n",$0,i,n)
  i++
}
'
cd cropped
numfiles=`ls -1 | wc -l`
n=1
echo "OCRing..."
for i in $( ls ); do
  tesseract $i ../txt/$i -psm 7 &> /dev/null
  printf "%s (%u/%u)\n" $i $n $numfiles
  ((n++))
done
echo "Done.\nCompiling data..."
grep -hv "^$" ../txt/* >> ../data.txt
echo "Done."
