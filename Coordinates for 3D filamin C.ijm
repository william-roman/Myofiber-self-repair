waitForUser("Before continuing, make sure you have:\n - The mask of the fiber.\n - The ROIS of the injury in the ROI manager.\n - The original image of the Injury Signal.");
Output = getDirectory("get Directory Output");
waitForUser("Select mask image.");
Stack.getDimensions(width, height, channels, slices, frames);
getVoxelSize(width, height, depth, unit);
F = File.open(Output + "Cell Boundary_Slice_All.txt");
print(F, "X\tY\tSlice");
for (i = 1; i <= slices; i ++){
	setSlice(i);
	run("Create Selection");
	//run("Fit Spline");
	run("Interpolate", "interval=1");
	Roi.getCoordinates(x,y);
	for (j = 0; j < lengthOf(x); j ++){
		print(F, d2s(x[j]*width,2) + "\t" + d2s(y[j]*width,2) + "\t" + d2s(i*depth,2));
	}
}
File.close(F);
D = File.open(Output + "Injury_Coordinates.txt");
print(D, "X\tY\tSlice\tNumber");
waitForUser("Select Original Image");
Number_of_Injury = roiManager("count");
for (i = 0; i < Number_of_Injury; i ++){
	roiManager("select",i);
	Slice = getSliceNumber();
	//run("Interpolate", "interval=1");
	Roi.getCoordinates(x, y);
	for (j = 0; j < lengthOf(x); j ++){
		print(D, d2s(x[j]*width,2) + "\t" + d2s(y[j]*width,2) + "\t" + d2s(Slice*depth,2) + "\t" + d2s(i,2));
	}
}
File.close(D);
