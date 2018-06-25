 Download add-on from https://chrome.google.com/webstore/detail/export-gitlab-issues/iahgcbndlpkfggeelckgeimfkbkcnjoc
 
 Authorize your GitLab account (OAuth) and the add-on will automatically show your projects and groups to export issues from. Just select a project/group, choose the status of the issues you want to export and click export to complete.
 
 Download the file in CSV format.
 
 cd Issue-migrate
 
 Run the following commands:
 
 sudo npm install -g
 
 githubCsvTools File.csv
 
 Give details for Github token, username and repo to which issues are to be migrated when prompted for.
