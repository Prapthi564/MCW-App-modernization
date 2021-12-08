# Exercise 5: Setup CI/CD pipeline with GitHub Actions for the web app

Duration: 55 minutes

In this exercise, you will move the codebase to a GitHub Repo, create a staging environment in Azure App Service using App Service Deployment Slots, and finally connect the pieces with a CI/CD Pipeline built on GitHub Actions.

## Task 1: Moving the codebase to a GitHub repo

1. Login to [GitHub](https://github.com) with your account. Select the New button positioned on top of the repositories list. As an alternative you can [navigate to the new repository site here](https://github.com/new).

    ![GitHub.com Landing page is shown. New button to create a new repository is highlighted.](media/github-new-repo.png "GitHub new repo")

1. Type in `partsunlimited` **(1)** as your repository name. Select **Private (2)** to prevent public access to the repository. Select **Create repository (3)** to continue.

    ![Repository name is set to partsunlimited. Private access is selected. Create repository button is highlighted.](media/github-partsunlimited-repo.png "Create a new repository")

1. Select the **clipboard copy command** to copy the Git endpoint for your repository and paste the value into a text editor, such as Notepad.exe, for later reference.

    ![GitHub repository page is shown. Endpoint copy to clipboard button is highlighted.](media/github-endpoint-copy.png "Repository endpoint")

    We will use the Lab VM to execute some development tasks.

1. Right-click on the Windows Start Menu and select **Windows PowerShell (Admin)** to launch a terminal window.

    ![Start Menu context menu is open. Windows PowerShell (Admin) command is highlighted.](media/launch-powershell.png "Windows PowerShell")

1. The Parts Unlimited website's source code is already copied into the VM as part of the **Before the hands-on lab exercises**. Run the command below to navigate to the source code folder.

    ```powershell
    cd "C:\MCW\MCW-App-modernization-master\Hands-on lab\lab-files\src"
    ```

1. Run the following command to initialize a local Git repository.

    ```powershell
    git init
    ```

    ![PowerShell terminal is shown. Git init is highlighted and executed.](media/git-init.png "Git init")

1. Next, we will define the remote endpoint as an origin to our local repository. Replace `{YourEndpointURL}` with the endpoint URL you copied previously from GitHub. Run the final command in your PowerShell terminal.

    ```powershell
    git remote add origin {YourEndpointURL}
    ```

    ![PowerShell terminal is shown. Git remote add origin is highlighted and executed. ](media/git-remote-add.png "Git remote add")

1. Run the following commands to rename current branch to **Main** and add stage all the files for a git commit.

    ```powershell
    git branch -M main
    git add .
    ```

1. Before we commit our changes, we have to identify our git user name and e-mail. In the following command, replace `John Doe` with your name and `johndoe@example.com` with your e-mail address. Once ready, run the below commands in your PowerShell terminal.

    ```powershell
    git config --global user.name "John Doe"
    ```

    ```powershell
    git config --global user.email johndoe@example.com
    ```

1. We are ready to commit the source code to our local Git repository. Run the following command to continue.

    ```powershell
    git commit -m "Initial Commit"
    ```

1. Let's push our code to GitHub. Run the following command in your PowerShell terminal.

    ```powershell
    git push -u origin main
    ```

1. GitHub authentication screen will pop up. Select **Sign in with your browser (2)**. A new browser pop-up will appear with the GitHub login page.

    ![PowerShell terminal shows git push command and the GitHub Sign In experoence. Sign in with your browser button is highlighted.](media/github-sign-in.png "GitHub Sign In")

1. Fill-in your GitHub account credentials on the browser window to Sign-In.

1. On the **Authorize Git Credential Manager** screen select **Authorize GotCredentialManager**. This will give your local environment permission to push the code to GitHub.

    ![Authorize Git Credential Manager is open. Authorize GotCredentialManager buttin is highligted.](media/github-access.png "Authoriez Git Credential Manager")

1. Close the browser.

1. Go back to GitHub and observe the repository with the source code uploaded.

    ![GitHub shown with the partsunlimited repository populated with source code.](media/github-partsunlimited-repo-loaded.png "GitHub repository page")

## Task 2: Creating a staging deployment slot

1. Go back to your lab resource group, navigate to your `partsunlimited-web-{uniquesuffix}` **(2)** App Service resource. You can search for `partsunlimited-web` **(1)** to find your Web App and App Service Plan

   ![The search box for resources is filled in with partsunlimited-web. The partsunlimited-web-20 Azure App Service is highlighted in the list of resources in the hands-on-lab-SUFFIX resource group.](media/resource-group-appservice-resource.png "Resources")

1. Switch to the **Deployment slots (1)** tab and select **Add Slot (2)**.

    ![App Service Deployment Slots tab is open. Add slot button highlighted.](media/app-service-add-deployment-slot.png "Deployment slots")

1. Type in **staging** as the name **(1)** of the new slot. Select your app service name from the **Clone settings from (2)** dropdown list. This will ensure our web site configurations for the production environment are copied over to the staging environment as a starting point. Select **Add (3)** to add the new slot.

    ![Add a slot panel is open. Name is set staging. Partsunlimited-web-20 is selected for the clone settings from dropdown list. Add button is highlighted.](media/app-service-staging-slot.png "Adding deployment slot")

1. Once you receive the success message, close **(1)** the panel. Observe **(2)** the two environments we have for the App Service in the deployment slots list.

    ![Successfully created slot staging message is shown. The close button is highlighted. The current list of slots is presented.](media/app-service-staging-slot-added.png "Deployment slots")

### Task 3: Setting up CI/CD with GitHub Actions

1. Select your staging slot from the list of deployment slots.

    ![Deployment slots are listed. Staging slot named partsunlimited-web-20-staging is highlighted.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/app-service-staging-select.png)

2. From the toolbar menu, select **Get publish profile**. The publish profile is used to authenticate between GitHub and Azure.

    ![The staging app service slot screen displays with the Get publish profile button highlighted on the toolbar.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/retrieve_staging_publish_profile.png "Staging Publish Profile")

3. Open the downloaded file in a text editor. Keep this editor open.

4. In a web browser, return to the GitHub repository for this lab, and select the **Settings** tab.

    ![The GitHub repository web page displays with Settings highlighted in the toolbar.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/github_settings_tab.png "GitHub Repository Settings Menu")

5. From the left menu, select **Secrets**. Then, select **New repository secret**.

    ![The Secrets item is selected in the left menu and the New repository secret button is highlighted.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/github_repository_add_secret.png "New repository secret")

6. Enter the following values in the **New secret** form, then select **Add secret**.

    | Field | Value |
    |-------|-------|
    | Name  | AZURE_WEBAPP_PUBLISH_PROFILE |
    | Value | Copy and paste the contents of the downloaded publish profile open in the text editor. |

    ![The New secret form displays populated with the previous values. The Add secret button is highlighted.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/github_publish_profile_secret.png "Add Publish Profile Secret")

7. Select the **Actions** tab.

    ![The GitHub repository page displays with the Actions menu item highlighted.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/github_actions_menu.png "Actions Menu")

8. On the **Get started with GitHub Actions** screen, select the **set up a workflow yourself** link.

    ![The Get started with GitHub Actions screen displays with the set up a workflow yourself link highlighted.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/github_setupworkflowyourself.png "Set up a workflow yourself")

9. On the workflow editor screen, provide the file name **stagingdeploy.yml**. Commit your changes by selecting the Start Commit button.

    ![The workflow editor screen displays with the file name set to stagingdeploy.yml](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/github_workflownaming.png "Workflow naming")

10. Return the Web VM. Open a Command window. Execute the following code to pull your newly created GitHub stagingdeploy.yml file locally. You are going to update the file content with the template stagingdeploy.yml.

    ```cmd
        cd "C:\MCW\MCW-App-modernization-stage-2\Hands-on lab\lab-files\src"
        git pull
    ```

    ![The image shows successfully pulling down the new GitHub workflow.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/git-pull-workflow-file-locally.png "Pull Git Workflow")

11. Open Windows Explorer. Copy the solution template yml file `C:\MCW\MCW-App-modernization-stage-2\Hands-on lab\lab-files\workflow\stagingdeploy.yml` to `C:\MCW\MCW-App-modernization-stage-2\Hands-on lab\lab-files\src\.github\workflows\stagingdeploy.yml`.  You are going to replace the default GitHub workflow yml content.

12. Open the `stagingdeploy.yml` in Visual Studio Code. Replace the suffix value on lines 7 and 11 to match your lab.

    ![YML file is displayed with the suffix values highlighted.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/ymlreplacesuffix.png "YML file")

13. You have just updated the `partsunlimited` GitHub project. It is time to save and push your changes. Execute these commands in a Web VM Command window.

    ```cmd
        cd C:\MCW\MCW-App-modernization-main\stage-2\lab-files\src
        git add .
        git commit -am "Updated the stagingdeploy.yml with my changes"
        git push 
    ```

14. In GitHub, select **Actions**. The workflow will display as in progress.

    ![The GitHub action workflow displays as being in progress.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/github_action_in_progress.png "Workflow in progress")

15. Go back to your lab resource group on the Azure Portal, navigate to your `staging (partsunlimited-web-/staging)` **(2)** App Service resource. You can search for `staging` **(1)** to find your App Service (Slot) for staging.

    ![The search box for resources is filled in with staging. The staging (partsunlimited-web-{uniquesuffix}/staging) Azure App Service Deployment Slot is highlighted in the list of resources in the hands-on-lab-SUFFIX resource group.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/select-staging-app-service.png "Staging Resource")

16. Notice the dedicated web link for your staging slot. Select to navigate to the website to see the result of your successful deployment through the CI/CD pipeline.

    ![Staging slot for partsunlimited app service is open. URL endpoint for the deployment slot is highlighted.](https://github.com/CloudLabs-MCW/MCW-App-modernization/raw/stage-2/Hands-on%20lab/media/staging-slot-link.png "Staging public endpoint")

## Task 4: Pushing code changes to staging and production

1. Select the Start menu and search for **Visual Studio Code**. Select **Visual Studio Code** to run it.

    ![Start Menu is open. Visual Studio Code is typed in the search box. Visual Studio Code is highlighted from the list of search results.](media/vscode-start-menu.png "Visual Studio Code")

1. Open the **File (1)** menu and select **Open Folder... (2)**.

    ![File menu is open in Visual Studio Code. Open Folder... command is highlighted.](media/vscode-open-folder.png "Open Folder")

1. Navigate to `C:\MCW\MCW-App-modernization-master\Hands-on lab\lab-files\src` and select **Select Folder (1)**.

    ![Visual Studio Code Open Folder dialog is open. Folder path is set to C:\MCW\MCW-App-modernization-master\Hands-on lab\lab-files\src and Select Folder button is highlighted.](media/vscode-select-folder.png "Select Folder")

1. Select **Source Control (1)** tab in Visual Studio Code. Since we worked on the codebase in our repo in the virtual machine, the codebase in the repo on GitHub has changed. Open the **Views and more actions... (2)** menu and select **Pull (3)** to get the latest from the remote repository.

    ![Views and more actions... menu is open. Pull command is highlighted.](media/vscode-pull.png "GitHub Pull")

1. Now that our codebase has been updated, we are going to introduce a brand new change to Parts Unlimited's web site. In the Explorer window navigate to **src > PartsUnlimitedWebSite > Views > Home** and select **Index.cshtml (4)** for editing. Change the Title of the page **(5)** and save the file by using going to the File menu and selecting **Save**. Notice the underlying git repository detecting a change (6) in the codebase.

    ![Index.cshtml from src > PartsUnlimitedWebSite > Views > Home folder is open. Page Title is changed to New Home Page. One pending change in the source control is highlighted.](media/vscode-changing-source-code.png "Code editing in VSCode")

1. Select **Stage Changes (1)**. Type in a commit message **(2)** for the changes. Select **Commit (3)**.

    ![Stage changes button for index.cshtml is highlighted. Commit message is set to New Home Page Title. Commit button is highlighted.](media/vscode-stage-commit.png "GitHub Commit")

1. Open the **Views and more actions... (1)** menu and select **Push (2)** to push the changes to GitHub.

    ![Views and more actions... menu is open. Push command is highlighted.](media/vscode-push.png "GitHub Push")

1. Open the GitHub repository and observe the Actions page for the latest execution of the CI/CD Pipeline.

    ![PartsUnlimited repo is open. Actions page is shown. Successful CI/CD run for the new home page title is highlighted.](media/github-actions-success-commit.png "New commit build")

1. Navigate to the staging environment endpoint in your browser and observe the Title change.

    ![Parts Unlimited staging environment is open in a browser. New Home Page title is highlighted.](media/staging-code-changes.png "Parts Unlimited Staging Web Site")

Now that Parts Unlimited has a separate staging environment for their e-commerce site, they can push new source code and functionality to the repo that will automatically be built and deployed to their staging for testing.

## Task 5: Swap deployment slots to move changes in staging to production

Once Parts Unlimited is happy with the changes tested in their staging environment, they can swap the two environments and have changes go to production. Environment Swap happens very fast and can help Parts Unlimited pull back changes by switching back if needed.

1. Go back to your lab resource group, navigate to your `partsunlimited-web-{uniquesuffix}` **(2)** App Service resource. You can search for `partsunlimited-web` **(1)** to find your app service.

   ![The search box for resources is filled in with partsunlimited-web. The partsunlimited-web-20 Azure App Service is highlighted in the list of resources in the hands-on-lab-SUFFIX resource group.](media/resource-group-appservice-resource.png "Resources")

1. Switch to the **Deployment slots (1)** tab and select **Swap (2)**.

    ![App Service Deployment Slots tab is open. Swap button highlighted.](media/app-service-slot-swap.png "Deployment Slot Swap")

1. Select the **Swap** button to swap the staging slot with the production slow.

    ![Deployment Slot Swap dialog is open. Swap button is highlighted.](media/app-service-slot-swap-panel.png "Deployment Slot Swap")

1. Once you receive the success message, close the swap panel.

1. Visit both production and staging slot endpoints and observe how the Title change is moved to production.

    > Once you move your staging slot to production, your production slot is moved to staging as well. This means that your current staging slot does not have the latest changes you have pushed to the repo. You can trigger a manual CI/CD workflow execution to push the latest changes to staging.
    >
    > To run a CI/CD workflow manually, go to GitHub actions page **(1)** in your repository. Select the workflow **(2)** to run. Open the **Run workflow (3)** menu and select **Run workflow (4)**.
    >
    > ![GitHub Actions page is shown. Build and deploy ASP.Net Core app to Azure Web App - partsunlimited-web-20(staging) workflow is selected. Run workflow menu is open. Run workflow button is highlighted.](media/github-actions-manual-run.png "Manual workflow run")