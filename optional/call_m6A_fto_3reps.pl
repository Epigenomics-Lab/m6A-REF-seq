#! perl -w
# call high confidence m6A sites from 3 replicates
# usage: perl call_m6A_highconf.pl -r1 rep1_fpr_fisher -r2 rep2_fpr_fisher -r3 rep3_fpr_fisher -d 10 -f 0.5 -p 0.05 > m6A_highconf.txt 

use Getopt::Long;
GetOptions("r1=s" => \$rep1,"r2=s" => \$rep2,"r3=s" => \$rep3,"d=s" => \$dep, "f=s" => \$fpr, "p=s" => \$pvalue) or die ("Invalid arguments.\n");
open (F1, "$rep1") || die "Cant open file: $!";
open (F2, "$rep2") || die "Cant open file: $!";
open (F3, "$rep3") || die "Cant open file: $!";

while(<F1>){
        if($_!~/WARNING/){
        s/\s+$//;
        @tmp1=split/\s+/,$_;
        $line1=join("\t",$tmp1[0],$tmp1[1],$tmp1[2]);
        push @ids,$line1;
        if($tmp1[4]>=$dep && $tmp1[7]>=$dep && $tmp1[9]<=$fpr && $tmp1[10]<=$pvalue){
        $methy1{$line1}=$tmp1[8]-$tmp1[5];
        $num1{$line1}=join("\t",$tmp1[3],$tmp1[4],$tmp1[6],$tmp1[7]);
      }
}
}

while(<F2>){
        if($_!~/WARNING/){
        s/\s+$//;
        @tmp2=split/\s+/,$_;
        $line2=join("\t",$tmp2[0],$tmp2[1],$tmp2[2]);
        push @ids,$line2;
        if($tmp2[4]>=$dep && $tmp2[7]>=$dep && $tmp2[9]<=$fpr && $tmp2[10]<=$pvalue){
        $methy2{$line2}=$tmp2[8]-$tmp2[5];
        $num2{$line2}=join("\t",$tmp2[3],$tmp2[4],$tmp2[6],$tmp2[7]);
      }
}
}

while(<F3>){
        if($_!~/WARNING/){
        s/\s+$//;
        @tmp3=split/\s+/,$_;
        $line3=join("\t",$tmp3[0],$tmp3[1],$tmp3[2]);
        push @ids,$line3;
        if($tmp3[4]>=$dep && $tmp3[7]>=$dep && $tmp3[9]<=$fpr && $tmp3[10]<=$pvalue){
        $methy3{$line3}=$tmp3[8]-$tmp3[5];
        $num3{$line3}=join("\t",$tmp3[3],$tmp3[4],$tmp3[6],$tmp3[7]);
      }
}
}

undef %count;
@uniq_ids = grep { ++$count{ $_ } < 2; } @ids;

for $id(@uniq_ids){
	if(exists $methy1{$id} && exists $methy2{$id} && exists $methy3{$id}){
		@rep1=split/\s+/,$num1{$id};
		@rep2=split/\s+/,$num2{$id};
		@rep3=split/\s+/,$num3{$id};
		$methy=sprintf "%0.4f",($rep1[2]+$rep2[2]+$rep3[2])/($rep1[3]+$rep2[3]+$rep3[3])-($rep1[0]+$rep2[0]+$rep3[0])/($rep1[1]+$rep2[1]+$rep3[1]);
		print "$id\t$methy\n";
	}elsif(exists $methy1{$id} && exists $methy2{$id}){
		@rep1=split/\s+/,$num1{$id};
		@rep2=split/\s+/,$num2{$id};
		$methy=sprintf "%0.4f",($rep1[2]+$rep2[2])/($rep1[3]+$rep2[3])-($rep1[0]+$rep2[0])/($rep1[1]+$rep2[1]);
		print "$id\t$methy\n";
	}elsif(exists $methy1{$id} && exists $methy3{$id}){
		@rep1=split/\s+/,$num1{$id};
		@rep3=split/\s+/,$num3{$id};
		$methy=sprintf "%0.4f",($rep1[2]+$rep3[2])/($rep1[3]+$rep3[3])-($rep1[0]+$rep3[0])/($rep1[1]+$rep3[1]);
		print "$id\t$methy\n";
	}elsif(exists $methy3{$id} && exists $methy2{$id}){
		@rep3=split/\s+/,$num3{$id};
		@rep2=split/\s+/,$num2{$id};
		$methy=sprintf "%0.4f",($rep3[2]+$rep2[2])/($rep3[3]+$rep2[3])-($rep3[0]+$rep2[0])/($rep3[1]+$rep2[1]);
		print "$id\t$methy\n";
  }
}

close F1;
close F2;
close F3;
