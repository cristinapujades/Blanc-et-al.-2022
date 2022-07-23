#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "Samples", value = "5") samples
#@ String (label = "Users", value = "4") users
#@ String (label = "Reference signal channel", value = "1") ref_chan
#@ String (label = "Experimental signal channel", value = "2") exp_chan
#@ String (label = "Output Channel Number", value = "3") output_chan

items =	newArray("Add", "Subtract", "Multiply", "Divide", "AND", "OR", "XOR", "Min", "Max", "Average", "Difference", "Copy" , "Transparent-zero");

Dialog.create("Image Calculator");
	Dialog.addRadioButtonGroup("Select Funtion desired:", items, 3, 4, "Subtract");
Dialog.show();

calc=Dialog.getRadioButton();
func = calc + "create stack";

for (n = 1; n < samples+1; n++) {
		
		for (i = 1; i < users+1; i++) {
				
				r = ref_chan;
				e = exp_chan;
				o = output_chan;
				
				open(input + File.separator + "User" + i + "C" + r + "E" + n + ".tif");
				open(input + File.separator + "User" + i + "C" + e + "E" + n + ".tif");
				imageCalculator(func, "User" + i + "C" + e + "E" + n + ".tif", "User" + i + "C" + r +"E" + n + ".tif");
				saveAs("Tiff", output + File.separator + "User" + i + "C" + o + "E" + n + ".tif");
				close("*");
			}
		}