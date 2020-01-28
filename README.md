# PSSpotlight (in development)

*Module to export and save the Spotlight images from Windows 10 into a user defined folder.*

The **PSSpotlight** module leverages the *[Configuration](https://www.powershellgallery.com/packages/Configuration/)* module to start with a default config, and also stores its configuration in a persistent way, while offers the possibilty for a user to change the configuration manually.

The defult configuration saves the pictures into the `MyPictures\SpotlightImages` folder using the `"$([Environment]::GetFolderPath('MyPictures'))\$($config.foldername)"` script and the JSON configuration to calculate the correct path at the first load of the module.
``` JSON
@{
    landscape = "landscape";
    portrait = "portrait";
    foldername = "SpotlightPictures";
    destination = $null
}
```

PSSpotlight has no problems with the Known Folder Move feature of OneDrive.

The saved pictures are named using their SHA265 hashes, and this way avoiding the duplications.

PSSpotlight is not chatty but adding a `-verbose` paramater it will tell you more detials.

Enjoy!
