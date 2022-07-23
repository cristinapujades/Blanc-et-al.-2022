

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ String (label = "channels", value = "2") channels

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
	run("Split Channels");
	for (i = 1; i < channels+1; i++) {

 		selectWindow("C" + i + "-" + file);
  		saveAs("tiff", output + File.separator + "C" + i + file);
		close();
	}
	print("Saving to: " + output);
	
}
