#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

processFolder(input);

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
	
  	print("Processing: " + input + File.separator + file);
  	open(file);
	setThreshold(65, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold2.4" + File.nameWithoutExtension + ".tif");
  	close("*");
  	open(file);
	setThreshold(128, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold3.4" + File.nameWithoutExtension + ".tif");
  	close("*");
  	open(file);
	setThreshold(192, 255);
	run("Convert to Mask", "method=Default background=Dark");
	run("Invert", "stack");
	saveAs("Tiff", output + File.separator + "Threshold4.4" + File.nameWithoutExtension + ".tif");
  	close("*");
	print("Saving to: " + output);
}
