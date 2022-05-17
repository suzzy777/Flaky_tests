# Flaky_tests

## Project Title:
Fixing Python Flaky Tests 

## Project Description:
This project is to test if some previously detected python order dependent tests are still order dependent at latest version, if so, then apply previously ipflakies generated patches and check if the patches work or not. Since iPFlakies is an automated tool, it is necessary to check the effectiveness of the patches it generates. Lastly, if the patches work, then automatically push the changes to the forked repository on GitHub, prompt to open a pull request and generate a commit message in markdown format for GitHub.

## How to Use the Project:


The script is written in shell. Operating system needed to run is Unix.

Before running the script, you might need to install csvkit and hub using the following commands: 

\` sudo apt-get install csvkit\`
 \`sudo apt-get install hub\`

The ipflakies_result folder has to be in the same directory as the automatically cloned projects by the script. By default, github projects are cloned into the home directory. Since iPFlakies is an automated tool, it is necessary to check the effectiveness of the patches it generates. This contains the previous ipflakies generated patches which can be downloaded from here: 
[Patches folder link](https://drive.google.com/drive/folders/1u0TsD_PjaXZ-aqrwNKAkZR8B7LZ5bKtj?usp=sharing).
The script might ask for the user’s GitHub credentials (username and password) at the beginning of the run. It can be skipped by pressing enter. It will ask for the user’s GitHub username again at the time of executing the command ‘hub fork’, it can be skipped by pressing enter, then it will skip forking the repository and pushing the commit in GitHub.

### Input csv file for the script: 

The script will ask for an input file name first, then the name of the file it will generate with the new md5checksum column inserted. 

To test on all of the 393 tests:
Insert input file name: Patches.csv
Insert input file with md5schecksum name: <your_given_file_name>.csv 
To test on a few projects:
Insert input file name: smalldataset.csv
Insert input file with md5schecksum name: <your_given_file_name>.csv 

Keep the input csv file in the same directory as the script. 

### Run: 

Run the following command to run the script and save it in a logfile to get the commit message:

\`bash latestfindOD.sh | & tee <logfilename>.log\`

## Details of the Script:

1.	First it takes input of the user’s GitHub credentials in order to connect to GitHub and do activities such as git push, commit, etc.       
2.	Then it is taking the input csv file which contains information about order dependent flaky tests, their polluter, cleaner, patch and creates an md5sha for each row – which will give each OD test, polluter, cleaner, patch some unique md5hecksum value. It creates a new csv file with the added md5sha for all the tests.  
3.	By parsing the csv file, we get the GitHub repository links of the projects with flaky tests and clone the projects from GitHub in our local machine.
4.	Then it installs the dependencies by installing the requirements.txt files given in each project. The requirements.txt files are sometimes named differently such as test_requirements.txt, requirements-dev.txt etc. 
5.	Next, it performs pytest twice, first to check if the od test fails or passes in isolation and then to check if it passes or fails when its run after the polluter/state-setter. 
6.	Then it checks if the tests are still order dependent at the latest version by checking the following conditions:
a.	If it was previously labelled as a victim and it currently passes in isolation but fails when run after a polluter, it’s order dependent and a victim.
b.	If it was previously labelled as a brittle and it currently fails in isolation but passes when run after state-setter, it’s order dependent and a brittle. 
7.	If it is still order dependent, then it will go on to patch the od test and run the pytests again to check if the od test is still or not, if not then it means the patch worked. 
8.	Next, if patch worked, then it will go on to fork the repository to the user’s account, create a new branch for each push and commit changes – it will prompt to compare and create pull request. 
9.	It will also output a commit message in the GitHub markdown format in the log file. User can copy and paste it in GitHub.

## Output: 

The output of the script can be seen in the log file created, we can also output the before and after patch information (pytest pass or fail) for both in isolation and running after dependent test in a simpler manner in a csv file by running the \`auto.sh\` file. The script has to be in the same directory as the cloned projects. Run the following command: 
\`bash auto.sh |& tee <newcsvfilename>.csv\`
The newcsvfilename.csv will have the before and after patch information.

![image](https://user-images.githubusercontent.com/71781751/168710135-88abd28a-10b0-4940-a40c-494dd89068ed.png)
