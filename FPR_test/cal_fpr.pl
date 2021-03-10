#! perl -w
# calculate the false positive rate (fpr)
# usage:  perl cal_fpr.pl -i FTO-treated.mis.num -n mRNA.mis.num > fpr

use Getopt::Long;

GetOptions("i=s" => \$fto,"n=s" => \$mrna) or die ("Invalid arguments.\n");
open (F1, "$fto") || die "Cant open file: $!";
open (F2, "$mrna") || die "Cant open file: $!";

while(<F1>){
	s/\s+$//;
	@tmp1=split/\s+/,$_;
	$line1=join("\t",$tmp1[0],$tmp1[1],$tmp1[2]);
	$hash{$line1}=$tmp1[6];
	$hash2{$line1}=$tmp1[3] . "\t" . $tmp1[5];
}

while(<F2>){
	s/\s+$//;
	@tmp2=split/\s+/,$_;
	$line2=join("\t",$tmp2[0],$tmp2[1],$tmp2[2]);
	if(exists $hash{$line2}){
		if($tmp2[6]>0){
			$v=sprintf "%0.4f",$hash{$line2}/$tmp2[6];
			print "$line2\t$hash2{$line2}\t$hash{$line2}\t$tmp2[3]\t$tmp2[5]\t$tmp2[6]\t$v\n";
		}
	}
}

close F1;
close F2;
