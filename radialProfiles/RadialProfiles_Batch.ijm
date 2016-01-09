function listExtension(dir, ext) {
	list = getFileList(dir);
	listTemp=newArray(list.length);
	q=0;
     for (i=0; i<list.length; i++) {
        if (endsWith(list[i], ext)){
           listTemp[i]=list[i];
			q++;
		}
	}
	
	listFiles=Array.slice(listTemp, 0, q-1);
	return listFiles;
}	


dir1 = getDirectory("Choose Source Directory "); 
list = getFileList(dir1); 
dir2 = dir1+"RadialProfiles"+File.separator; 
File.makeDirectory(dir2); 
dir3 = dir2+"ProfileMetadata"+File.separator;
File.makeDirectory(dir3);

tifList=listExtension(dir1, ".tif");

for(n=1; n<tifList.length; n++){
	tifName=tifList[n];
	open(tifName);
	
	getCursorLoc(x, y, z, flags);
	waitForUser("Select cell center");  

	
	baseX=x;
	baseY=y;
	//makePoint(baseX, baseY);
	nAngles=1;
	numLines=nAngles;
	lineLength=500;
	len=lineLength*numLines;
	trackProfile=newArray(len);
	
	angles = newArray(nAngles);
	endX = newArray(nAngles);
	endY = newArray(nAngles);
	
	for (i=0; i<nAngles; i++){
		angles[i] = i*(2*PI/nAngles);
		endX[i]=cos((angles[i]))*lineLength;
		endY[i]=sin((angles[i]))*lineLength;
	}
	  
	for  (j=0; j<numLines; j++){	
		//identify profile endpoints
		x1=baseX;
		y1=baseY;
		x2=baseX+endX[j];
		y2=baseY+endY[j];
		
		//draw line between points	
		makeLine(x1, y1, x2, y2);
		
		// enter profile into trackProfile array
		profile = getProfile();
  		for (i=0; i<lineLength; i++){
			ind=j*lineLength+i;
     			trackProfile[ind]=profile[i];
		}
	}

	// export profiles via the results window
	for (k=0; k<len; k++)
		setResult("Value", k, trackProfile[k]);
	updateResults;
	csv_name=replace(tifName,".tif",".csv");
	path = dir2+csv_name;
	saveAs("Results", path);

	// export profile metadata
	
}
