# instagram_stories.py
# Description: Automatically downloads Instagram stories from all followed accounts
# and organizes them into folders by username.
#
# Dependencies:
#   - instaloader (installed via pipx: pipx install instaloader)
#   - A saved instaloader session (run: instaloader --load-cookies brave)
#
# Usage:
#   "/Users/asaelx/Library/Application Support/pipx/venvs/instaloader/bin/python" ~/.scripts/instagram_stories.py

import instaloader
import os

# Base directory where stories will be saved
# Existing username folders will be reused; new ones will be created automatically
BASE_DIR = os.path.expanduser("~/Pictures/Insta")

# Initialize Instaloader with custom settings
L = instaloader.Instaloader(
    dirname_pattern=os.path.join(BASE_DIR, "{target}"),  # Save into ~/Pictures/Insta/username/
    save_metadata=False,                                  # Skip .json.xz metadata files
    download_video_thumbnails=False,                      # Skip .jpg thumbnails for video stories
)

# Load the saved session (created during initial login with --load-cookies brave)
L.load_session_from_file("realnerdo")

# Fetch the profile of the logged-in account
profile = instaloader.Profile.from_username(L.context, "realnerdo")

# Loop through every account we follow and download their current stories
for followee in profile.get_followees():
    print(f"Checking stories for: {followee.username}")
    try:
        L.download_stories(
            userids=[followee.userid],
            filename_target=followee.username  # Use username as the folder name
        )
    except KeyError as e:
        # Some accounts have reels-based stories that cause a bug in instaloader
        # Skip them and continue with the next account
        print(f"  Skipping {followee.username} due to known instaloader bug: {e}")
    except Exception as e:
        # Catch any other unexpected errors so the script keeps running
        print(f"  Error downloading stories for {followee.username}: {e}")
