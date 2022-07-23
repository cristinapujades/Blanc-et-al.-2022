#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "samples", value = "5") samples
#@ String (label = "users", value = "4") users



for (n = 1; n < samples+1; n++) {

	for (i = 1; i < users+1; i++) {
		open(input + File.separator + "User" + i + "C1E"+ n + ".tif");
		open(input + File.separator + "User" + i + "C2E"+ n + ".tif");
	}
	run("Merge Channels...", "c1=User1C1E" + n + ".tif c2=User2C1E" + n + ".tif c3=User3C1E" + n + ".tif c4=User4C1E" + n + ".tif create");
	run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Channels (c)] frames=[Slices (z)]");
	run("Z Project...", "projection=[Average Intensity] all");
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	saveAs("Tiff", output + File.separator + "UserAveragedC1E" + n + ".tif");
	close();
	run("Merge Channels...", "c1=User1C2E" + n + ".tif c2=User2C2E" + n + ".tif c3=User3C2E" + n + ".tif c4=User4C2E" + n + ".tif create");
	run("Re-order Hyperstack ...", "channels=[Frames (t)] slices=[Channels (c)] frames=[Slices (z)]");
	run("Z Project...", "projection=[Average Intensity] all");
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	saveAs("Tiff", output + File.separator + "UserAveragedC2E" + n + ".tif");
	close("*");
}
