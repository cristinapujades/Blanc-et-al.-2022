#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "samples", value = "5") samples
#@ String (label = "name", value = "UserAveragedC") name

for (i = 1; i < samples+1; i++) {
	open(input + File.separator + name + "2E" + i + ".tif");
	open(input + File.separator + name + "1E" + i + ".tif");
	}
run("Merge Channels...", "c1=" + name + "2E1.tif c2=" + name + "2E2.tif c3=" + name + "2E3.tif c4=" + name + "2E4.tif c5=" + name + "2E5.tif create");
run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Channels (c)] frames=[Slices (z)]");
run("Z Project...", "projection=[Average Intensity] all");
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
saveAs("Tiff", output + File.separator + "SampleAveragedC2.tif");
run("Merge Channels...", "c1=" + name + "1E1.tif c2=" + name + "1E2.tif c3=" + name + "1E3.tif c4=" + name + "1E4.tif c5=" + name + "1E5.tif create");
run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Channels (c)] frames=[Slices (z)]");
run("Z Project...", "projection=[Average Intensity] all");
run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
saveAs("Tiff", output + File.separator + "SampleAveragedC1.tif");
close("*");
