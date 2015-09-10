blindImages.py: renames and reorganizes images for blinded image analysis.

Currently supports .tif/.tiff, .png, and .jpg
When run, will move all images in 'basePath' to two subfolders: blindedImages and originalImages.
Records info to match de-identified inmage with original image in matchedFilenames.csv.
At a later date, you can add additional files to basePath and re-run.
If blindingNotes exists, numbering will not be duplicated and code will begin where it left off.

Inputs: none,  processes images in current working directory
Outputs:
   images in blindedImages, orginalImages;
   matchedFilenames.csv:contains original filename with blinded ID #
   nameList.csv:contains original filenames of images already blinded
   assignList.txt: contains floats ordered randomly without replacement

*** Instructions for to use blindImages.py.

1.	Get Python and the numpy package.
This is easily done with the (free) Anaconda Python distribution: https://store.continuum.io/cshop/anaconda/

2.	Save blindImages.py somewhere. For those using the default Anaconda installation, I recommend:
C:\Users\username\Anaconda\Scripts\

3.	Create a folder and put your images in it. This folder can be anywhere, including an external drive.

4.	Blind your initial image set.
  a.	Run windows command prompt (cmd.exe)
  b.	Change working directory to your folder
    ex) cd C:\Users\username\testImages\
  c.	Run blindImages.py
    ex) python C:\Users\username\Anaconda\Scripts\blindImages.py

  Depending on how you have your system PATH variable set up, you may be able to just use ‘python blindImages.py’
  
  You should now have 3 subfolders:
  
  \blindedImages\
  -	Your images with random-number filenames (e.g. 088.tif)
  
  \originalImages\
  -	Your images with their original filenames (e.g. Sample1A.tif)

  \blindingNotes\
  -	assignList.txt : the random number list that is used to rename the images
  -	matchedFilenames.csv : the original name/random number pairs
  -	listNames.csv : the original names only

5.	(optional) Add more images to your image set at a later time
  a.	You should still have the 3 subfolders, and the assignList.txt file. Put the new images in the main folder (not the subfolders).
  b.	Repeat step 3. Numbering will begin where it previously left off.
 
