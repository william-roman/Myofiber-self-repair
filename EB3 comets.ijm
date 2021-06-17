Table.create("Summary Track Information");
run("Set Measurements...", "area mean min centroid center shape redirect=None decimal=3");

Exp_Dir = getDirectory("Folder with Experiments");
Exp_Dir_output = getDirectory("Folder for Output");

Experiments = getFileList(Exp_Dir);

rowIndex = 0;

for (i = 0; i < lengthOf(Experiments); i ++){

	//print("Analyzing experiment: " + Experiments[i]);
	Experiment_conditions = getFileList(Exp_Dir + Experiments[i]);
	Dir_Save_Exp = Exp_Dir_output + replace(Experiments[i],"/","\\");
	File.makeDirectory(Dir_Save_Exp);
	print(Dir_Save_Exp);
	for (j = 0; j < lengthOf(Experiment_conditions); j ++){
		
		//print("Looking at experiment " + Experiments[i] + " condition " + Experiment_conditions[j]);
		Cells = getFileList(Exp_Dir + Experiments[i] + Experiment_conditions[j]);
		Dir_Save_Condition = Dir_Save_Exp + replace(Experiment_conditions[j],"/","\\");
		File.makeDirectory(Dir_Save_Condition);
		print(Dir_Save_Condition);
		for (k = 0; k < lengthOf(Cells); k ++){

			//print("Looking at experiment " + Experiments[i] + " condition " + Experiment_conditions[j] + Cells[k]);
			Timing = getFileList(Exp_Dir + Experiments[i] + Experiment_conditions[j] + Cells[k]);
			Dir_Save_Cells = Dir_Save_Condition + replace(Cells[k],"/","\\");
			File.makeDirectory(Dir_Save_Cells);
			print(Dir_Save_Cells);
			for (h = 0; h < lengthOf(Timing); h ++){

				Table.create("Summary Track Information_byImage");
				
				Folder = Exp_Dir + Experiments[i] + Experiment_conditions[j] + Cells[k] + Timing[h];
				Dir_Save_Timing = Dir_Save_Cells + replace(Timing[h],"/","\\");
				File.makeDirectory(Dir_Save_Timing);
				print(Dir_Save_Timing);
				open(Folder + replace(Timing[h], "/","") + "_smoothed.tif");
				getPixelSize(unit, pixelWidth, pixelHeight);


					if (File.exists(Dir_Save_Timing + "Cell Outline.roi")) {
						roiManager("open", Dir_Save_Timing + "Cell Outline.roi");
						roiManager("Select", 0);
						waitForUser("Please inspect the current Outline.\nThen Click OK.");
						Dialog.create("Cell Selection Found");
						Dialog.addChoice("Is this the correct Cell Outline?", newArray("Yes", "No"));
						Dialog.show();
						Answer = Dialog.getChoice();
						if (Answer == "Yes"){
						}
						else {
							setTool("polygon");
							roiManager("Select", 1);
							roiManager("delete");
							waitForUser("Draw Cell Limits.\nThen Click OK.");
							roiManager("add");
							roiManager("Select", 0);
							roiManager("rename", "Cell Outline");
							roiManager("Save", Dir_Save_Timing + "Cell Outline.roi");
						}
					}
					else {
						setTool("polygon");
						waitForUser("Draw Cell Limits.\nThen Click OK.");
						roiManager("add");
						roiManager("Select", 0);
						roiManager("rename", "Cell Outline");
						roiManager("Save", Dir_Save_Timing + "Cell Outline.roi");
					}

					if (File.exists(Dir_Save_Timing + "Imaginary Injury.roi")) {
						roiManager("open", Dir_Save_Timing + "Imaginary Injury.roi");
						roiManager("Select", 1);
						waitForUser("Please inspect the current 'Injury'.\nThen Click OK.");
						Dialog.create("'Injury' Found");
						Dialog.addChoice("Is this the correct 'Injury'?", newArray("Yes", "No"));
						Dialog.show();
						Answer = Dialog.getChoice();
						if (Answer == "Yes"){
							roiManager("Measure");
							Injury_X = parseFloat(Table.get("X", 0, "Results"));
							Injury_Y = parseFloat(Table.get("Y", 0, "Results"));
							run("Close");
						}
						else {
							setTool("polygon");
							roiManager("Select", 1);
							roiManager("delete");
							waitForUser("Draw injury.\nThen Click OK.");
							roiManager("add");
							roiManager("Select", 1);
							roiManager("rename", "Injury");
							roiManager("Save", Dir_Save_Timing + "Imaginary Injury.roi");
							roiManager("Measure");
							Injury_X = parseFloat(Table.get("X", 0, "Results"));
							Injury_Y = parseFloat(Table.get("Y", 0, "Results"));
							run("Close");
						}
					}
					else {
						setTool("polygon");
						waitForUser("Draw imaginary injury.\nThen Click OK.");
						roiManager("add");
						roiManager("Select", 1);
						roiManager("rename", "Injury");
						roiManager("Measure");
						roiManager("Save", Dir_Save_Timing + "Imaginary Injury.roi");
						Injury_X = parseFloat(Table.get("X", 0, "Results"));
						Injury_Y = parseFloat(Table.get("Y", 0, "Results"));
						run("Close");
					}

					if (File.exists(Dir_Save_Timing + "Nuclei centroid.roi")) {
						roiManager("open", Dir_Save_Timing + "Nuclei centroid.roi");
						roiManager("Select", 2);
						waitForUser("Please inspect the current location.\nThen Click OK.");
						Dialog.create("Nuclei centroid found");
						Dialog.addChoice("Is this the correct Nuclei Centroid?", newArray("Yes", "No"));
						Dialog.show();
						Answer = Dialog.getChoice();
						if (Answer == "Yes"){
							roiManager("Measure");
							Nucleous_X = parseFloat(Table.get("X", 0, "Results"));
							Nucleous_Y = parseFloat(Table.get("Y", 0, "Results"));
							run("Close");
						}
						else {
							setTool("point");
							roiManager("Select", 2);
							roiManager("delete");
							waitForUser("Identify nuclei centroid.\nThen Click OK.");
							roiManager("add");
							roiManager("Select", 2);
							roiManager("rename", "Nuclei centroid");
							roiManager("Measure");
							Nucleous_X = parseFloat(Table.get("X", 0, "Results"));
							Nucleous_Y = parseFloat(Table.get("Y", 0, "Results"));
							run("Close");
							roiManager("Save", Dir_Save_Timing + "Nuclei centroid.roi");
						}
					}
					else {
						setTool("point");
						waitForUser("Identify nuclei centroid.\nThen Click OK.");
						roiManager("add");
						roiManager("Select", 2);
						roiManager("rename", "Nuclei centroid");
						roiManager("Measure");
						Nucleous_X = parseFloat(Table.get("X", 0, "Results"));
						Nucleous_Y = parseFloat(Table.get("Y", 0, "Results"));
						run("Close");
						roiManager("Save", Dir_Save_Timing + "Nuclei centroid.roi");
					}
					if (File.exists(Dir_Save_Timing + "Injury_bottom.roi")) {
						roiManager("open", Dir_Save_Timing + "Injury_bottom.roi");
						roiManager("Select", 3);
						waitForUser("Please inspect the current location.\nThen Click OK.");
						Dialog.create("Injury_bottom found");
						Dialog.addChoice("Is this the correct Injury_bottom?", newArray("Yes", "No"));
						Dialog.show();
						Answer = Dialog.getChoice();
						if (Answer == "Yes"){
							roiManager("Measure");
							Injury_bottom_X = parseFloat(Table.get("X", 0, "Results"));
							Injury_bottom_Y = parseFloat(Table.get("Y", 0, "Results"));
							run("Close");
						}
						else {
							setTool("point");
							roiManager("Select", 3);
							roiManager("delete");
							waitForUser("Identify Injury_bottom.\nThen Click OK.");
							roiManager("add");
							roiManager("Select", 3);
							roiManager("rename", "Injury_bottom");
							roiManager("Measure");
							Injury_bottom_X = parseFloat(Table.get("X", 0, "Results"));
							Injury_bottom_Y = parseFloat(Table.get("Y", 0, "Results"));
							run("Close");
							roiManager("Save", Dir_Save_Timing + "Injury_bottom.roi");
						}
					}
					else {
						setTool("point");
						waitForUser("Identify Injury_bottom.\nThen Click OK.");
						roiManager("add");
						roiManager("Select", 3);
						roiManager("rename", "Injury_bottom");
						roiManager("Measure");
						Injury_bottom_X = parseFloat(Table.get("X", 0, "Results"));
						Injury_bottom_Y = parseFloat(Table.get("Y", 0, "Results"));
						run("Close");
						roiManager("Save", Dir_Save_Timing + "Injury_bottom.roi");
					}
				//setTool("point");
				//waitForUser("Identify position of the nucleous\nThen click OK.");
				//roiManager("add");
				//roiManager("Select", 2);
				//roiManager("rename", "Nucleous");
				//roiManager("Measure");
				//Nucleous_X = Table.get("X", 0, "Results");
				//Nucleous_Y = Table.get("Y", 0, "Results");
				//run("Close");
				
				//print("Injury X = " + d2s(Injury_X,3));
				//print("Injury Y = " + d2s(Injury_Y,3));
				//print("Nuclei X = " + d2s(Nucleous_X,3));
				//print("Nuclei Y = " + d2s(Nucleous_Y,3));
				midpoint_x = ( Injury_X + Nucleous_X ) / 2;
				//print("Midpoint = " + d2s(midpoint_x,3));
				if (Nucleous_X > Injury_X) {
					mode = "A";
				}
				else if (Nucleous_X < Injury_X) {
					mode = "B";
				}
				//print("Mode = " + mode);

				
				print("Looking at experiment " + replace(Experiments[i], "/", "") + " condition " + replace(Experiment_conditions[j], "/", "") + " " + replace(Cells[k], "/", "") + " " + replace(Timing[h], "/", "") + " injury");
				run("Table... ", "open=[" + Folder + "Track statistics.csv]");
				//Table.rename("Track statistics.csv", "Track_Statistics");
				run("Table... ", "open=[" + Folder + "Spots in tracks statistics.csv]");
				//Table.rename("Spots in tracks statistics.csv", "Spot_Statistics");

				track_IDs = Table.getColumn("TRACK_ID", "Track statistics.csv");
				spot_track_IDs = Table.getColumn("TRACK_ID" , "Spots in tracks statistics.csv");
				Mean_speed_tracks = Table.getColumn("TRACK_MEAN_SPEED", "Track statistics.csv");
				Track_displacement = Table.getColumn("TRACK_DISPLACEMENT", "Track statistics.csv");
				
				Array.print(spot_track_IDs);
				ID_diffs = newArray(lengthOf(spot_track_IDs) - 1);
				Break_indexes = newArray(1);
				for (g = 0; g < lengthOf(spot_track_IDs) - 1; g ++){
					diff = spot_track_IDs[g + 1] - spot_track_IDs[g];
					if (diff != 0) {
						Break_indexes = Array.concat(Break_indexes, g + 1);
						ID_diffs[g] = 1;
					}
				}
				Array.print(Break_indexes);
				ID_diffs = Array.concat(1,ID_diffs);
				Array.print(ID_diffs);
				
				Direction = newArray(lengthOf(track_IDs));
				Initial_pos_x = newArray(lengthOf(track_IDs));
				Final_pos_x = newArray(lengthOf(track_IDs));
				Initial_pos_y = newArray(lengthOf(track_IDs));
				Final_pos_y = newArray(lengthOf(track_IDs));
				Nuclei_initial = newArray(lengthOf(track_IDs));
				Nuclei_final = newArray(lengthOf(track_IDs));
				Injury_initial = newArray(lengthOf(track_IDs));
				Injury_final = newArray(lengthOf(track_IDs));

				newImage("draw tracks", "8-bit black", 1600, 400, 1);
				DT = getImageID();
				
				for (g = 0; g < lengthOf(track_IDs) - 1; g ++ ){
					
					Track_initial_x = parseFloat(Table.get("POSITION_X", Break_indexes[g], "Spots in tracks statistics.csv"));
					Initial_pos_x[g] = Track_initial_x;
					//print("Track_initial_x = " + d2s(Track_initial_x,3));
					
					Track_initial_y = parseFloat(Table.get("POSITION_Y", Break_indexes[g], "Spots in tracks statistics.csv"));
					Initial_pos_y[g] = Track_initial_y;
					//print("Track_initial_x = " + d2s(Track_initial_y,3));
					
					Track_final_x = parseFloat(Table.get("POSITION_X", Break_indexes[g + 1] - 1, "Spots in tracks statistics.csv"));
					Final_pos_x[g] = Track_final_x;
					
					Track_final_y = parseFloat(Table.get("POSITION_Y", Break_indexes[g + 1] - 1, "Spots in tracks statistics.csv"));
					Final_pos_y[g] = Track_final_y;

					Nuclei_dist_initial = sqrt(pow(Track_initial_x - Nucleous_X, 2) + pow(Track_initial_y - Nucleous_Y, 2));
					//print("Nuclei dist initial = " + d2s(Nuclei_dist_initial,3));
					Nuclei_initial[g] = Nuclei_dist_initial;
					
					Injury_dist_initial = sqrt(pow(Track_initial_x - Injury_X, 2) + pow(Track_initial_y - Injury_Y, 2));
					Injury_initial[g] = Injury_dist_initial;

					Nuclei_dist_final = sqrt(pow(Track_final_x - Nucleous_X, 2) + pow(Track_final_y - Nucleous_Y, 2));
					Nuclei_final[g] = Nuclei_dist_final;
					
					Injury_dist_final = sqrt(pow(Track_final_x - Injury_X, 2) + pow(Track_final_y - Injury_Y, 2));
					Injury_final[g] = Injury_dist_final;

				if (mode == "A"){
					if (Injury_dist_final < Injury_dist_initial && Track_initial_x < Injury_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Injury 1 top";
							Direction[g] = "Towards Injury 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("red");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Injury 1 below";
							Direction[g] = "Towards Injury 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("blue");
							run("Add Selection...");
							}
					}
					else if (Injury_dist_final > Injury_dist_initial && Track_initial_x < Injury_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Injury 1 top";
							Direction[g] = "Towards Injury 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("green");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Injury 1 below";
							Direction[g] = "Away Injury 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("yellow");
							run("Add Selection...");
							}
					}
					else if (Injury_dist_final > Injury_dist_initial && Track_initial_x > Injury_X && Track_initial_x < midpoint_x){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Injury 2 top";
							Direction[g] = "Away Injury 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("magenta");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Injury 2 below";
							Direction[g] = "Away Injury 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("cyan");
							run("Add Selection...");
							}
					}
					else if (Injury_dist_final < Injury_dist_initial && Track_initial_x > Injury_X && Track_initial_x < midpoint_x){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Injury 2 top";
							Direction[g] = "Towards Injury 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("E59328");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Injury 2 below";
							Direction[g] = "Towards Injury 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("A328E5");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final < Nuclei_dist_initial && Track_initial_x > midpoint_x && Track_initial_x < Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 1 top";
							Direction[g] = "Towards Nuclei 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("3077B2");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 1 below";
							Direction[g] = "Towards Nuclei 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("7CB230");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final > Nuclei_dist_initial && Track_initial_x > midpoint_x && Track_initial_x < Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Nuclei 1 top";
							Direction[g] = "Away Nuclei 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("B26E30");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Nuclei 1 below";
							Direction[g] = "Away Nuclei 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("B23065");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final < Nuclei_dist_initial && Track_initial_x > Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 2 top";
							Direction[g] = "Towards Nuclei 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("9437DD");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 2 below";
							Direction[g] = "Towards Nuclei 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("37DDB2");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final > Nuclei_dist_initial && Track_initial_x > Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Nuclei 2 top";
							Direction[g] = "Away Nuclei 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("444DA0");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Nuclei 2 below";
							Direction[g] = "Away Nuclei 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("00A5B2");
							run("Add Selection...");	
						}
					}
				}
				else if (mode == "B"){
					if (Injury_dist_final < Injury_dist_initial && Track_initial_x > Injury_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Injury 1 top";
							Direction[g] = "Towards Injury 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("red");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Injury 1 below";
							Direction[g] = "Towards Injury 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("blue");
							run("Add Selection...");
							}
					}
					else if (Injury_dist_final > Injury_dist_initial && Track_initial_x > Injury_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Injury 1 top";
							Direction[g] = "Towards Injury 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("green");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Injury 1 below";
							Direction[g] = "Away Injury 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("yellow");
							run("Add Selection...");
							}
					}
					else if (Injury_dist_final > Injury_dist_initial && Track_initial_x < Injury_X && Track_initial_x > midpoint_x){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Injury 2 top";
							Direction[g] = "Away Injury 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("magenta");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Injury 2 below";
							Direction[g] = "Away Injury 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("cyan");
							run("Add Selection...");
							}
					}
					else if (Injury_dist_final < Injury_dist_initial && Track_initial_x < Injury_X && Track_initial_x > midpoint_x){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Injury 2 top";
							Direction[g] = "Towards Injury 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("E59328");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Injury 2 below";
							Direction[g] = "Towards Injury 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("A328E5");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final < Nuclei_dist_initial && Track_initial_x < midpoint_x && Track_initial_x > Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 1 top";
							Direction[g] = "Towards Nuclei 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("3077B2");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 1 below";
							Direction[g] = "Towards Nuclei 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("7CB230");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final > Nuclei_dist_initial && Track_initial_x < midpoint_x && Track_initial_x > Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Nuclei 1 top";
							Direction[g] = "Away Nuclei 1 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("B26E30");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Nuclei 1 below";
							Direction[g] = "Away Nuclei 1 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("B23065");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final < Nuclei_dist_initial && Track_initial_x < Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 2 top";
							Direction[g] = "Towards Nuclei 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("9437DD");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Towards Nuclei 2 below";
							Direction[g] = "Towards Nuclei 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("37DDB2");
							run("Add Selection...");
							}
					}
					else if (Nuclei_dist_final > Nuclei_dist_initial && Track_initial_x < Nucleous_X){
						if (Track_initial_y < Injury_bottom_Y){
							Direction_mt = "Away Nuclei 2 top";
							Direction[g] = "Away Nuclei 2 top";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("444DA0");
							run("Add Selection...");
							}
						else if (Track_initial_y > Injury_bottom_Y){
							Direction_mt = "Away Nuclei 2 below";
							Direction[g] = "Away Nuclei 2 below";
							makeArrow(Track_initial_x / pixelWidth, Track_initial_y / pixelHeight, Track_final_x / pixelWidth, Track_final_y / pixelHeight, "small");
							Roi.setStrokeColor("00A5B2");
							run("Add Selection...");
							
						}
					}
				}
				//print("Direction of MT is: " + Direction_mt);
				
				Table.set("Track_ID", rowIndex, track_IDs[g], "Summary Track Information");
				Table.set("Mean_Speed", rowIndex, Mean_speed_tracks[g], "Summary Track Information");
				Table.set("Displacement", rowIndex, Track_displacement[g], "Summary Track Information");
				Table.set("Inital_X", rowIndex, Track_initial_x, "Summary Track Information");
				Table.set("Inital_Y", rowIndex, Track_initial_y, "Summary Track Information");
				Table.set("Final_X", rowIndex, Track_final_x, "Summary Track Information");
				Table.set("Final_Y", rowIndex, Track_final_y, "Summary Track Information");
				Table.set("Nuclei_distance_initial", rowIndex, Nuclei_dist_initial, "Summary Track Information");
				Table.set("Nuclei_distance_final", rowIndex, Nuclei_dist_final, "Summary Track Information");
				Table.set("Injury_distance_initial", rowIndex, Injury_dist_initial, "Summary Track Information");
				Table.set("Injury_distance_final", rowIndex, Injury_dist_final, "Summary Track Information");
				Table.set("Direction", rowIndex, Direction_mt, "Summary Track Information");
				Table.set("Timing", rowIndex, replace(Timing[h], "/",""), "Summary Track Information");
				Table.set("Cell", rowIndex, replace(Cells[k], "/",""), "Summary Track Information");
				Table.set("Condition", rowIndex, replace(Experiment_conditions[j], "/",""), "Summary Track Information");
				Table.set("Experiment", rowIndex, replace(Experiments[i], "/",""), "Summary Track Information");

				rowIndex = rowIndex + 1;

				}

				Table.update("Summary Track Information");
				
				Table.setColumn("Track_ID", track_IDs, "Summary Track Information_byImage");
				Table.setColumn("Mean_Speed", Mean_speed_tracks, "Summary Track Information_byImage");
				Table.setColumn("Displacement", Track_displacement, "Summary Track Information_byImage");
				Table.setColumn("Inital_X", Initial_pos_x, "Summary Track Information_byImage");
				Table.setColumn("Inital_Y", Initial_pos_y, "Summary Track Information_byImage");
				Table.setColumn("Final_X", Final_pos_x, "Summary Track Information_byImage");
				Table.setColumn("Final_Y", Final_pos_y, "Summary Track Information_byImage");
				Table.setColumn("Nuclei_distance_initial", Nuclei_initial, "Summary Track Information_byImage");
				Table.setColumn("Nuclei_distance_final", Nuclei_final, "Summary Track Information_byImage");
				Table.setColumn("Injury_distance_initial", Injury_initial, "Summary Track Information_byImage");
				Table.setColumn("Injury_distance_final", Injury_final, "Summary Track Information_byImage");
				Table.setColumn("Direction", Direction, "Summary Track Information_byImage");
				saveAs("Results", Dir_Save_Timing + "Summary_Track_Info" + "_" + replace(Timing[h], "/","") + "_" + replace(Cells[k], "/","") + "_" + replace(Experiment_conditions[j], "/","") + "_" + replace(Experiments[i], "/","") + "_V3.csv");
				run("Close");

				selectImage(DT);
				saveAs("Tiff", Dir_Save_Timing + "draw tracks.tif");
				
				run("Close All");
				roiManager("reset");
				close("Spots in tracks statistics.csv");
				close("Track statistics.csv");

			}
		}
		
	}
}

selectWindow("Summary Track Information");
saveAs("Results", Exp_Dir_output + "Summary_Track_Info_all_V3.csv");