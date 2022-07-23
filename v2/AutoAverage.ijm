#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "Samples", value = "5") samples
#@ String (label = "Users", value = "4") users
#@ String (label = "Number of channels", value = "2")channels
#@ String (label = "Input Files Name", value = "Threshold3.4UserAveragedC") name 

f = " ";
k = " ";

if (users>0){

	for (p = 1; p < channels+1; p++) {
		
		for (n = 1; n < samples+1; n++) {
			
			f = " ";
		
			for (i = 1; i < users+1; i++) {
				
				open(input + File.separator + "User" + i + "C" + p + "E"+ n + ".tif");	
				
				a = "c" + i + "=User" + i + "C" + p + "E" + n + ".tif ";
	
				f = f + " " + a;
				
			}

		run("Merge Channels...", f + " " + "create");
		run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Channels (c)] frames=[Slices (z)]");
		run("Z Project...", "projection=[Average Intensity] all");
		run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
		saveAs("Tiff", output + File.separator + "UserAveragedC" + p + "E" + n + ".tif");
		close();
		}
	}
	

}

else {
	
	for (p = 1; p < channels+1; p++){

		k = " ";
		
		for (n = 1; n < samples+1; n++) {
			
			
			open(input + File.separator + name + p + "E" + n + ".tif");
			run("RGB Color");
			run("8-bit");
			
			b = "c" + n + "=" + name + p + "E" + n + ".tif ";
	
			k = k + " " + b;
		}
		
		run("Merge Channels...", k + " " + "create");
		run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Channels (c)] frames=[Slices (z)]");
		run("Z Project...", "projection=[Average Intensity] all");
		run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
		saveAs("Tiff", output + File.separator + "SampleAveragedC" + p + ".tif");
		close();
		
	}
}
