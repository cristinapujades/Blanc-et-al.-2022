
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "samples", value = "5") samples
#@ String (label = "Users", value = "4") users

for (n = 1; n < samples+1; n++) {

	for (i = 1; i < users+1; i++) {

		open(input + File.separator + "User" + i + "C2E" + n + ".tif");
		open(input + File.separator + "User" + i + "C1E" + n + ".tif");
		imageCalculator("Subtract create stack", "User" + i + "C1E" + n + ".tif", "User" + i + "C2E" + n + ".tif");
		saveAs("Tiff", output + File.separator + "User" + i + "C1E" + n + ".tif");
		close("*");
	}
}