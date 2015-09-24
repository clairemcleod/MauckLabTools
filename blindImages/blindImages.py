#blindImages.py: renames and reorganizes images for blinded image analysis.
#Claire McLeod, cm.mcleod@gmail.com, last updated 2015-09-23
#
#Currently supports .tif/.tiff, .png, and .jpg; you can add more file extensions in line 36
#When run, will move all images in 'basePath' to two subfolders: blindedImages and originalImages.
#Matching info is contained in matchedFilenames.csv.
#At a later date, you can add additional files to basePath and re-run.
#If blindingNotes exists, numbering will not be duplicated and code will begin where it left off.
#
#Inputs: none,  processes images in current working directory
#Outputs:
#   images in blindedImages, orginalImages;
#   matchedFilenames.csv:contains original filename with blinded ID #
#   nameList.csv:contains original filenames of images already blinded
#   assignList.txt: contains floats ordered randomly without replacement

import os
import glob
import shutil
import csv
import numpy as np

basePath=os.getcwd()
Nmin=1 #minimum number used as blinded ID
Nmax=500 #maximum number used as blinded ID

#don't change anything below here (except for different file extensions if needed)
os.chdir(basePath)
print ("Blinding Files in: " + basePath)
blindPath=os.path.join(basePath, 'blindedImages')
origPath=os.path.join(basePath, 'originalImages')
blindingNotesPath=os.path.join(basePath, 'blindingNotes')
nameList=[]

#create a list of all of the images in basePath	
types = ('*.jpg', '.tif', '*.tif', '*.png')
fileList = []
for files in types:
	fileList.extend(glob.glob(files))

def copyFile(src, dest):
    try:
        shutil.copy(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print('Error: %s' % e)
    # eg. source or destination doesn't exist
    except IOError as e:
        print('Error: %s' % e.strerror)

def moveFile(src, dest):
    try:
        shutil.move(src, dest)
    # eg. src and dest are the same file
    except shutil.Error as e:
        print('Error: %s' % e)
    # eg. source or destination doesn't exist
    except IOError as e:
        print('Error: %s' % e.strerror)

#establish or locate the list of numbers to assign       
if os.path.exists(blindingNotesPath):
    print ('Reading existing blinding notes.')
    
    #read in existing blindingNotes
    numAssignments=np.loadtxt( os.path.bind(blindingNotesPath, 'assignList.txt'))
    nameList=np.ndarray.tolist(np.genfromtxt( os.path.bind(blindingNotesPath, 'listNames.csv'), delimiter=None, dtype=None))
    assignIndex=len(nameList)
    print ('Begining blinding from index:')
    print (assignIndex)
    
if not os.path.exists(blindingNotesPath):
    print ('Initializing folders.')
    os.makedirs(blindingNotesPath)
    #create list of numbers to assign
    numAssignments=np.random.choice(range(Nmin,Nmax), Nmax-Nmin, replace=False)
    np.savetxt(os.path.join(blindingNotesPath, 'assignList.txt') , numAssignments)
    assignIndex=0
		
#rename/relocate images
for imgName in fileList:
    
    randNum=numAssignments[assignIndex]
    print (assignIndex)
    blindID=str(int(randNum)).zfill(3)
    assignIndex=assignIndex+1
    
    #make directories if they don't exist
    if not os.path.exists(origPath):
        os.makedirs(origPath)
    if not os.path.exists(blindPath):
        os.makedirs(blindPath)

    #copy the original image to blindedImages folder (blinded name)
    fileName, fileExtension = os.path.splitext(imgName)
    blindName=os.path.join(blindPath, blindID + fileExtension)
    copyFile(imgName, blindName)
    nameList.append(imgName)

    #move the original image to separate folder (name unchanged)      
    moveName=os.path.join(origPath, imgName)
    moveFile(imgName, moveName)
    
#update blindingNotes with exported csvs
a=np.asarray(nameList)
filesMatched=np.vstack((a,numAssignments[0:assignIndex])).T
np.set_printoptions(threshold=np.inf, linewidth=np.inf)  # turn off summarization, line-wrapping

with open( os.path.join(blindingNotesPath, 'matchedFilenames.csv') , 'w',newline='') as csvfile:
    listwriter=csv.writer(csvfile, delimiter=',')
    for item in filesMatched:
        listwriter.writerow(item)
 
with open(os.path.join(blindingNotesPath, 'listNames.csv'), 'w', newline='') as csvfile:
    listwriter=csv.writer(csvfile, delimiter=',')
    for item in nameList:
        listwriter.writerow([item])

print ("Done.")