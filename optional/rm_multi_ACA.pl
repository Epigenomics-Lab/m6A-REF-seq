#! perl -w

use Getopt::Long;
GetOptions("f=s" => \$fasta,"s=s" => \$site) or die ("Invalid arguments.\n");
open (F1, "$fasta") || die "Cant open file: $!";
open (F2, "$site") || die "Cant open file: $!";

while($id=<F1>,$seq=<F1>){
	$id=~s/\s+$//;
	$id=~s/\>//;
	$id2=(split/\s+/,$id)[0];
	$seq=~s/\s+$//;
	$seq=~tr /atcg/ATCG/;
	$hash{$id2}=$seq;
}

while(<F2>){
	s/\s+$//;
	($chr,$loc,$label)=(split/\s+/,$_)[0,1,2];
	if($label eq "+"){
		$new=substr($hash{$chr},$loc-8,15);
		if($new=~/(AC)+ACA/){
			next;
		}elsif($new=~/ACA(AC)+/){
			next;
		}elsif($new=~/ACA(CA)+/){
			next;
		}elsif($new=~/(ACA)+[ATCG]*ACA/){
			next;
		}elsif($new=~/ACA[ATCG]*(ACA)+/){
			next;
		}else{
			print "$_\n";
		}
	}else{
		$new=substr($hash{$chr},$loc-8,15);
		$re=reverse($new);
		$re=~tr /ATGC/TACG/;
		if($re=~/(AC)+ACA/){
			next;   
		}elsif($re=~/ACA(AC)+/){
			next;
		}elsif($re=~/ACA(CA)+/){
			next;
		}elsif($re=~/(ACA)+[ATCG]*ACA/){
			next;
		}elsif($re=~/ACA[ATCG]*(ACA)+/){
			next;
		}else{
			print "$_\n";
		}
	}
}

close F1;
close F2;
