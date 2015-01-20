use Text::WagnerFischer qw(distance);
#use Spreadsheet::ParseExcel;


#Establish directories
	$dataDir = "//Amsgnas1/sginternal/Scripts/AB_CDR_SCRIPT";		#folder location on SGG NAS
	$cloneInDir = "$dataDir/CLONE_AB";
	$refDir = "$dataDir/REFERENCE_AB";
	$outDir = "$dataDir/OUTPUT_AB";

	@cloneArray = <$cloneInDir/*.txt>;					# Create Array of files from CLONE_AB folder
	@referenceArray = <$refDir/*.txt>;					# Create Array of files from REFERENCE_AB folder


#main
print "Antibody Script\n\n";
UserInput();
checkCDR3();

	






#User input (selection of clone, reference and output file)
sub UserInput {
	
	print "Select clone vquest file:\n\n";
	populateCloneArray();
	$input= <STDIN>;
	print "\n";

	$cloneFile = $cloneArray[$input];


	print "Select reference vquest file:\n\n";
	populateReferenceArray();
	$refput= <STDIN>;
	print "\n";

	$refFile = $referenceArray[$refput];


	print "Enter identifier for output file\n:";
	$output= <STDIN>;
	chomp $output;
	$outFile= "$outDir/$output";
}








#Display list of files in CLONE_AB folder, removing leading directory information
sub populateCloneArray {

	for($i=0;$i<=$#cloneArray;$i++) 
		{
		my $file = $cloneArray[$i];
		$file =~ s/\/\/Amsgnas1\/sginternal\/Scripts\/AB_CDR_SCRIPT\/CLONE_AB\///;
			print"$i\)\t$file\n";
		}
	print "\n";
}




#Display list of files in REFERENCE_AB folder, removing leading directory information
sub populateReferenceArray {
	
	for($i=0;$i<=$#referenceArray;$i++)
		{
		my $file = $referenceArray[$i];
		$file =~ s/\/\/Amsgnas1\/sginternal\/Scripts\/AB_CDR_SCRIPT\/REFERENCE_AB\///;
		print"$i\)\t$file\n";
	}
	print "\n";
}





	
	
	
sub checkCDR3 {	
	
	open REFERENCE, "<$refFile" or die "Can't open reference file";	
	@ref= <REFERENCE>;
	shift @ref;						#remove header line
	close REFERENCE;

	open CLONE, "<$cloneFile" or die "Can't open clone file";
	@clones= <CLONE>;
	shift @clones;						#remove header line
	close CLONE;

	open OUTFILE, ">$outFile.xls" or die $!;
	print OUTFILE "Functionality\tCLONE_ID\tCLONE_cdr1\tCLONE_cdr2\tCLONE_cdr3\tREF_ID\tREF_cdr1\tREF_cdr2\tREF_cdr3\tCDR1_WFS\tCDR2_WFS\tCDR3_WFS\tSEQUENCE\n";
	

foreach (@clones) {

	$CDRmin=100000;
	$minr="";
	
	chomp;

	($id,$functional,$cdr1,$cdr2,$cdr3,$seq)=(split /\t/);
	$cCDR = $cdr1 . $cdr2 . $cdr3 . $cdr3;
	
	#Establish min CDR distance
		foreach $r (@ref) {
		chomp $r;
		
		($rid,$rcdr1,$rcdr2,$rcdr3)=(split /\t/,$r);
		$rCDR = $rcdr1 . $rcdr2 . $rcdr3 . $rcdr3;
		
		$d= distance($cCDR,$rCDR);
		
		if ($d<$CDRmin) {
		
			$CDRmin= $d;
			$minr = $r;
			
			$CDR1min = distance($cdr1,$rcdr1);
			$CDR2min = distance($cdr2,$rcdr2);
			$CDR3min = distance($cdr3,$rcdr3);
			}
		}
	
		($rid,$rcdr1,$rcdr2,$rcdr3)=(split /\t/,$minr);	
	
	print OUTFILE "$functional\t$id\t$cdr1\t$cdr2\t$cdr3\t$rid\t$rcdr1\t$rcdr2\t$rcdr3\t$CDR1min\t$CDR2min\t$CDR3min\t$seq\n";
	}
close OUTFILE;
}

