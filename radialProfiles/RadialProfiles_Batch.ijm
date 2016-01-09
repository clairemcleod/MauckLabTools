function listExtension(dir, ext) {
//Returns list of files in dir that end with the ext extension
    list = getFileList(dir);
    listTemp=newArray(list.length);
    q=0;
     for (i=0; i<list.length; i++) {
        if (endsWith(list[i], ext)){
           listTemp[q]=list[i];
            q++;
        }
    }
   
    listFiles=Array.slice(listTemp, 0, q);
    return listFiles;
}   

function processProfile(imgTitle, baseX, baseY, nAngles, lineLength, Rcolumn){
//Returns vector of nAngles intensity profile(s) emanating from (baseX, baseY)
//This vector will later need to be reshaped; right now the profiles from 0 to
//2*pi are stored sequentially.
//imgTitle is the handle for an open single color image
//Rcolumn controls the column the vector is stored in for ultimate export to csv
	
    //establish vectors to track profiles
    len=lineLength*nAngles;
    trackProfile=newArray(len);

    //define the endpoints for drawing the profile lines, centered at (0,0)
    angles = newArray(nAngles);
    endX = newArray(nAngles);
    endY = newArray(nAngles);
   
    for (i=0; i<nAngles; i++){
        angles[i] = i*(2*PI/nAngles);
        endX[i]=cos((angles[i]))*lineLength;
        endY[i]=sin((angles[i]))*lineLength;
    }

    
    for  (j=0; j<nAngles; j++){   
        //identify profile endpoints
        x1=baseX;
        y1=baseY;
        x2=baseX+endX[j];
        y2=baseY+endY[j];
       
        //draw line between points   
        selectWindow(imgTitle);
        makeLine(x1, y1, x2, y2);
       
        // enter profile into trackProfile array
        profile = getProfile();
          for (i=0; i<lineLength; i++){
            ind=j*lineLength+i;
                 trackProfile[ind]=profile[i];
        }
    }   
    return trackProfile;   
}


// parameters to set
nAngles=20; // number of profiles to collect
lineLength=1000;  // number pixels in profile

dir1 = getDirectory("Choose Source Directory ");
list = getFileList(dir1);
dir2 = dir1+"RadialProfiles"+File.separator;
File.makeDirectory(dir2);
dir3 = dir2+"ProfileMetadata"+File.separator;
File.makeDirectory(dir3);

tifList=listExtension(dir1, ".tif");

for(n=0; n<tifList.length; n++){
    tifName=tifList[n];
    open(tifName);

    run("Stack to Images");

    //user selection of cell center
    setTool("point");
    waitForUser("Click cell center, then press ok");

     getSelectionCoordinates(x, y);

    //profile processing
    run("Clear Results");
    imgTitleBase=getTitle();
   
    imgTitle1=substring(imgTitleBase, 0, lengthOf(imgTitleBase)-4) + "0001";
    imgTitle2=substring(imgTitleBase, 0, lengthOf(imgTitleBase)-4) + "0002";
    imgTitle3=substring(imgTitleBase, 0, lengthOf(imgTitleBase)-4) + "0003";

    Ch1=processProfile(imgTitle1, x[0], y[0], nAngles, lineLength,1);
    Ch2=processProfile(imgTitle2, x[0], y[0], nAngles, lineLength,2);
    Ch3=processProfile(imgTitle3, x[0], y[0], nAngles, lineLength,3);

    //export profiles
    Array.show("Results", Ch1, Ch2, Ch3);
    csv_name=replace(tifName,".tif",".csv");
    path = dir2+csv_name;
    saveAs("Results", path);

    // export profile metadata
    run("Clear Results");
    pathMeta = dir3+replace(tifName,".tif","_metadata.csv");
    arrayTitles=newArray("Code Version", "Path","Image", "Channel1", "Channel2", "Channel3", "Cell X Coord", "Cell Y Coord", "nAngles", "Profile Length - px");
    arrayVals=newArray("RadialProfiles_Batch.ijm; edit 11-02-2015", dir2, tifName, "DAPI", "Green", "Red", x[0], y[0], nAngles, lineLength);
    Array.show("Results", arrayTitles, arrayVals);
    saveAs("Results", pathMeta);
    run("Clear Results");
   
    run("Close All");
}
