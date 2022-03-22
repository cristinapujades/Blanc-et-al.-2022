#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

name="[Data]";
run("New... ", "name="+name+" type=Table");
name2="[Data2]";
run("New... ", "name="+name2+" type=Table");
name3="[Data3]";
run("New... ", "name="+name3+" type=Table");
name4="[Data4]";
run("New... ", "name="+name4+" type=Table");
f=name;
g=name2;
h=name3;
k=name4;

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
  	print("Processing: " + input + File.separator + file);
  	open(file);

	selectWindow(file);
	run("3D Objects Counter", "threshold=200 slice=86 min.=10 max.=124662375 statistics summary");
 	selectWindow("Results");
 	Volume = 0;
  	for (n=0; n < nResults; n++)
    	{
       Volume += (getResult("Volume (micron^3)",n)*1); 
    	}
    print(f, Volume);
 	print(Volume);
  	Table.deleteRows(0, nResults);

  	selectWindow(file);
	run("3D Objects Counter", "threshold=150 slice=86 min.=10 max.=124662375 statistics summary");
 	selectWindow("Results");
 	Volume = 0;
  	for (n=0; n < nResults; n++)
    	{
       Volume += (getResult("Volume (micron^3)",n)*1); 
    	}
    print(g, Volume);
 	print(Volume);
  	Table.deleteRows(0, nResults);

  	selectWindow(file);
	run("3D Objects Counter", "threshold=100 slice=86 min.=10 max.=124662375 statistics summary");
 	selectWindow("Results");
 	Volume = 0;
  	for (n=0; n < nResults; n++)
    	{
       Volume += (getResult("Volume (micron^3)",n)*1); 
    	}
    print(h, Volume);
 	print(Volume);
  	Table.deleteRows(0, nResults);

  	selectWindow(file);
	run("3D Objects Counter", "threshold=60 slice=86 min.=10 max.=124662375 statistics summary");
 	selectWindow("Results");
 	Volume = 0;
  	for (n=0; n < nResults; n++)
    	{
       Volume += (getResult("Volume (micron^3)",n)*1); 
    	}
    print(k, Volume);
 	print(Volume);
  	Table.deleteRows(0, nResults);
  	selectWindow(file);
  	close("*");
}
	selectWindow("Data");
	saveAs("Text", output + File.separator + "1-4" + ".xls");
	run("Close");
	selectWindow("Data2");
	saveAs("Text", output + File.separator + "2-4" + ".xls");
	run("Close");
	selectWindow("Data3");
	saveAs("Text", output + File.separator + "3-4" + ".xls");
	run("Close");
	selectWindow("Data4");
	saveAs("Text", output + File.separator + "4-4" + ".xls");
	run("Close");