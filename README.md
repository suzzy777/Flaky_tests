## Project Title:
Fixing Python Flaky Tests 

## Project Description:
This project is to test if some previously detected python order dependent tests are still order dependent at latest version, if so, then apply previously ipflakies generated patches and check if the patches work or not. Since iPFlakies is an automated tool, it is necessary to check the effectiveness of the patches it generates. Lastly, if the patches work, then automatically push the changes to the forked repository on GitHub, prompt to open a pull request and generate a commit message in markdown format for GitHub.

## How to Use the Project:	
    
### Setup:
## Running [ `latestfindOD.sh` ](https://github.com/suzzy777/Flaky_tests/blob/master/latestfindOD.sh)
The scripts are written in shell. Operating system needed to run is Unix.

Before running the script, user will need to install csvkit and hub using the following    commands: 

` sudo apt-get install csvkit`

 `sudo apt-get install hub`

Also, to connect GitHub to local machine, to able to fork repositories, commit and push changes we need to use the following commands: 
 
`git config --global user.name "<your_github_username>"`

`git config --global user.email "<your_github_email>"`

User can skip this part if they do not want to fork, push or commit on GitHub.

The ipflakies_result folder has to be in the same directory as the automatically cloned projects by the script. They both should be in the home directory, github projects are cloned into the home directory. Since iPFlakies is an automated tool, it is necessary to check the effectiveness of the patches it generates. This contains the previous ipflakies generated patches which can be downloaded from here: 
[Patches folder link]( https://drive.google.com/drive/folders/1u0TsD_PjaXZ-aqrwNKAkZR8B7LZ5bKtj?usp=sharing ).

After a while, the script will ask for the user’s GitHub username and password at the time of executing the command ‘hub fork’, it can be skipped by pressing enter, then it will skip forking the repository and pushing the changes on GitHub. If user did not do git config at the beginning like mentioned above, but gives username and password while using hub fork, the repository will be forked, files can be added, but committing changes will not be possible without credentials. 

The script will ask for username again to create a remote repository with that name, but it won’t be able to create anything if GitHub credentials were not given in the previous stages. 

### Input csv file for the script: 

The script will ask for an input file name first, then the name of the file it will generate with the new md5checksum column inserted. 

To test on all the 393 tests:

Enter input file name: [ `Patches.csv` ](https://drive.google.com/file/d/1_PhVR5Zl8aH_9Xhz-35XO78EoWLqXG4B/view?usp=sharing)

Enter name of the new file that will be created with md5checksum added column: `<your_given_file_name>.csv`

To test on a few projects as it takes a long time to run 393 tests:

Enter input file name: [ `smalldataset.csv` ](https://drive.google.com/file/d/1-KjbTO3ROMwHHY6DyK5xG7gjPXcdi_HM/view?usp=sharing)

Enter input file with md5schecksum name: `<your_given_file_name>.csv`

Keep the input csv file in the same directory as the script. 

### Run: 

Run the following command to run the script and save it in a logfile:

`bash latestfindOD.sh |& tee <logfilename>.log`

# Examples: 

Here is an example of when we run the script on `smalldataset.csv`: 
- User can extract the entire folder in the `home` directory and run the files as instructed above: https://drive.google.com/file/d/15RTB8nJ-7kD0zy8t-S1LTpRmqLakI9os/view?usp=sharing

Breakdown of the files: 
- input csv file: https://drive.google.com/file/d/1-KjbTO3ROMwHHY6DyK5xG7gjPXcdi_HM/view?usp=sharing
- output md5checksum added csv file: https://drive.google.com/file/d/1C4xmUAC_EcXIt-v1Xq_0o13p9d5idNAe/view?usp=sharing
- input patches folder:  https://drive.google.com/drive/folders/1u0TsD_PjaXZ-aqrwNKAkZR8B7LZ5bKtj?usp=sharing
- output log file of [ `latestfindOD.sh` ](https://github.com/suzzy777/Flaky_tests/blob/master/latestfindOD.sh) : https://drive.google.com/file/d/1IVo2PsuqDugiLmu6ju0XMY8m5-ZnhS2V/view?usp=sharing
- output csv file of [ `automated.sh` ](https://github.com/suzzy777/Flaky_tests/blob/master/automated.sh) : https://drive.google.com/file/d/11n3qzgTcyw-sV6YdsNkmKMmA9RwCmTL4/view?usp=sharing
- output folders: https://drive.google.com/file/d/1mT4cBFiCKQXRn3AggjmgOBirb9RXR0L8/view?usp=sharing
#### Demo video (GitHub credentials were given before): https://drive.google.com/file/d/1ZoEzNru27XKKZnG56-zmbaw7GtEWQJXb/view?usp=sharing

## Details of the Script:

1.	First it takes input of the input csv file which contains information about order dependent flaky tests, their polluter, cleaner, patch and creates an md5checksum for each row – which will give each OD (Order Dependent) test, polluter, cleaner, patch group some unique md5hecksum value. It creates a new csv file with the added md5sha for all the tests.  
2.	By parsing the csv file, we get the GitHub repository links of the projects with flaky tests and clone the projects from GitHub in our local machine.
3.	Then it installs the dependencies using requirements.txt files given in each project. The requirements.txt files are sometimes named differently such as test_requirements.txt, requirements-dev.txt etc. 
4.	Next, it performs pytest twice, first to check if the OD test fails or passes in isolation and then to check if it passes or fails when its run after its polluter/state-setter. 
5.	Then it checks if the tests are still order dependent at the latest version by checking the following conditions:
-	If it was previously labelled as a victim and it currently passes in isolation but fails when run after a polluter, it’s order dependent and a victim.
-	If it was previously labelled as a brittle and it currently fails in isolation but passes when run after state-setter, it’s order dependent and a brittle. 
6.	If it is still order dependent, then it will go on to patch the OD test and run the pytests again to check if the test is still OD or not, if not then it means the patch worked. 
7.	Next, if patch worked, then it will go on to fork the repository to the user’s account, create a new branch for each push and commit changes – it will prompt to compare and create pull request. 
8.	It will also output a commit message in GitHub markdown format in the log file. User can copy and paste it in GitHub.
9.	Lastly, the changes made by the patch is reversed at the end and the OD file goes back to the state before patching.

## Output: 

The output of the script can be seen in the log file created, we can also output the before and after patch information (pytest pass or fail) for both in isolation and running after dependent test in a simpler manner in a csv file by running the `automate.sh` file. The script has to be in the same directory as the cloned projects. Run the following command: 
`bash automate.sh |& tee <newcsvfilename>.csv`
It will ask user to input file name, user has to give the previously created md5checksum added file name.
The <newcsvfilename>.csv will have the before and after patch information.
   
 


[Google Sheet link]( https://docs.google.com/spreadsheets/d/1HwpPlm0sNNivqnh-S0sTxHW4u6hKiWlVLhzX-wpHHd4/edit#gid=1402605759 )
