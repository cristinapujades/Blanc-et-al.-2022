#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ String (label = "Number of Thresholds", value = "4")thrs

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

	for (x = 1; x < thrs; x++) {
		
		th = (x*(255/thrs)+5);


		  	print("Processing: " + input + File.separator + file);
		  	open(file);
			setThreshold(th, 255);
			run("Convert to Mask", "method=Default background=Dark");
			run("Invert", "stack");
			saveAs("Tiff", output + File.separator + "Threshold" + (x+1) + "." + thrs + File.nameWithoutExtension + ".tif");
		  	close("*");
			print("Saving to: " + output);
	}
}