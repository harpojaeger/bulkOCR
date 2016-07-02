calc(){ awk "BEGIN { print "$*"}"; }
int(){ awk "BEGIN { print int($1)}"; }
updatebar ()
{
width=`tput cols`
height=`tput lines`
header="item $1/$2 "
headerlength=${#header}
totalbarlength=`calc $width-$headerlength-2`
prop=`calc $1/$2`
barlength=`calc $totalbarlength*$prop`
barchars=`int $barlength`

bar="for i in `seq 1 $barchars`; do printf r; done;"
thebar=`eval $bar`
echo "$header $thebar\r\c"
}

for i in `seq 1 50`;
        do
                updatebar $i 50
             	sleep .05
        done   
echo "\nDone."