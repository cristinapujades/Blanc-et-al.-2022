// This macro quantify the volume of each slices (in the 3 body axis) of each binary stack (dorsal view) of a folder 
// the begining and end slices need to be adjusted because the 3D object counter doesnt allow empty slices to be quantified
// it outputs an excel sheet with the volume of the signal of each slice in micrometer cube stacked in column, the file are named (body axis)(file name).xls

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
  
  	name="[Data]";
	run("New... ", "name="+name+" type=Table");
	name2="[Data2]";
	run("New... ", "name="+name2+" type=Table");
	name3="[Data3]";
	run("New... ", "name="+name3+" type=Table");
	f=name;
	g=name2;
	h=name3;
  	
  	open(file);
	z="Reslice of "+ File.nameWithoutExtension;
	selectWindow(file);
	
	run("Reslice [/]...", "output=1.192 start=Left");
	for (i = 55; i <= 400; i++) {
    	setSlice(i);
  		run("Z Project...", "start=i stop=i projection=[Max Intensity]");
  		run("RGB Color");
		run("8-bit");
  		run("3D Objects Counter", "threshold=80 slice=1 min.=0 max.=999252588 statistics summary");
  		selectWindow("Results");
  		Volume = 0;
  		for (n=0; n < nResults; n++) {
      		Volume += (getResult("Volume (micron^3)",n)*1); 
    	}
  	print(f, Volume);
 	print(Volume);
  	Table.deleteRows(0, nResults);
  	selectWindow("MAX_"+z);
  	close();
  	selectWindow(z);	
	}
	selectWindow(z);
	close();
	
	selectWindow(file);
	for (i = 50; i <= 170; i++) {
    	setSlice(i);
  		run("Z Project...", "start=i stop=i projection=[Max Intensity]");
  		run("RGB Color");
		run("8-bit");
  		run("3D Objects Counter", "threshold=80 slice=1 min.=0 max.=999506736 statistics summary");
  		selectWindow("Results");
  		Volume = 0;
  		for (n=0; n < nResults; n++) {
      		Volume += (getResult("Volume (micron^3)",n)*1); 
    	}
  	print(g, Volume);
 	print(Volume);
  	Table.deleteRows(0, nResults);
  	selectWindow("MAX_"+ file);
  	close();
	}
	
	selectWindow(file);
	run("Reslice [/]...", "output=1.192 start=Top");
	for (i = 55; i <= 250; i++) {
    	setSlice(i);
  		run("Z Project...", "start=i stop=i projection=[Max Intensity]");
  		run("RGB Color");
		run("8-bit");
  		run("3D Objects Counter", "threshold=80 slice=1 min.=0 max.=999252588 statistics summary");
  		selectWindow("Results");
  		Volume = 0;
  		for (n=0; n < nResults; n++) {
      		Volume += (getResult("Volume (micron^3)",n)*1); 
    	}
  	print(h, Volume);
 	print(Volume);
  	Table.deleteRows(0, nResults);
  	selectWindow("MAX_"+z);
  	close();
  	selectWindow(z);
	}
	selectWindow(z);
	close();
	
	print("Saving to: " + output);
	selectWindow("Data");
	saveAs("Text", output + File.separator + "AP" + File.nameWithoutExtension + ".xls");
	run("Close");
	selectWindow("Data2");
	saveAs("Text", output + File.separator + "DV" + File.nameWithoutExtension + ".xls");
	run("Close");
	selectWindow("Data3");
	saveAs("Text", output + File.separator + "LML" + File.nameWithoutExtension + ".xls");
	run("Close");
}
