
#@ File (label = "Classifier directory", style = "directory") class
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix
#@ String (label = "channels", value = "2") channels
#@ String (label = "Users", value = "4") users

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

for (i = 1; i < users+1; i++) {

  	print("Processing: " + input + File.separator + file);
  	open(file);
  	run("Split Channels");
  	
  	for (n = 1; n < channels+1; n++) {
  		selectWindow("C" + n + "-" + File.name);
		run("Trainable Weka Segmentation 3D");
		wait(3000);
		selectWindow("Trainable Weka Segmentation v3.3.2");
		call("trainableSegmentation.Weka_Segmentation.loadClassifier", class + File.separator + "CU" + i + ".model" )
		call("trainableSegmentation.Weka_Segmentation.getResult");
		selectWindow("Classified image");
		setThreshold(0, 0);
		run("Make Binary", "method=Huang background=Light black");
		saveAs("Tiff", output + File.separator + "User" + i + "C" + n + File.nameWithoutExtension + ".tif");
		close();
		selectWindow("Trainable Weka Segmentation v3.3.2");
		close();
		selectWindow("C" + n + "-" + File.name);
		close();
		call("java.lang.System.gc");
  	}
} 
}	