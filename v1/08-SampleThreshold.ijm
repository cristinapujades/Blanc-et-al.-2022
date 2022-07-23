#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	
  	print("Processing: " + input + File.separator + file);
  	open(file);
	setThreshold(49, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold1.5" + File.nameWithoutExtension + ".tif");
  	close("*");
  	open(file);
	setThreshold(100, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold2.5" + File.nameWithoutExtension + ".tif");
  	close("*");
  	open(file);
	setThreshold(152, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold3.5" + File.nameWithoutExtension + ".tif");
  	close("*");
  	open(file);
	setThreshold(203, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold4.5" + File.nameWithoutExtension + ".tif");
  	close("*");
	print("Saving to: " + output);
	open(file);
	setThreshold(250, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold5.5" + File.nameWithoutExtension + ".tif");
  	close("*");
	print("Saving to: " + output);
}
