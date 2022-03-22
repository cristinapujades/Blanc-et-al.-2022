

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "samples", value = "5") samples

for (n = 1; n < samples+1; n++) {

		open("C2E" + n + ".tif");
		open("C1E" + n + ".tif");
		run("Merge Channels...", "c1=C1E"+ n + ".tif" + " c2=C2E" + n + ".tif" + " create");
		saveAs("Tiff", output + File.separator + "E" + n + ".tif");
		close("*");
	}