dotnet pack --configuration Release --output D:\CSharpProjects\LibStores
dotnet nuget add source ./ --name MyLocalFeed 
git add .;git commit -m "update";git push