ImageQuick
==========

ImageQuick is simple image viewer.

Usage
-----

    imagequick [filename|directory|url]
      Opens image or directory or images in Atom/RSS feed.
    imagequick -S<session_name> [filename|directory|url]
      Restores/saves session <session_name>.

Shortcuts
---------

* **Arrow keys, Page Up, Page Down, Spacebar**: basic navigation
* **N, J**: next item
* **B, K, SHIFT + N**: previous item
* **Home or End**: first or last item
* **\+ or -**: zoom in or out
* **W or H**: fit to width or height
* **Period**: zoom to fill
* **/**: zoom to fit
* **Asterisk**: original zoom (1x)
* **O**: change orientation
* **Enter**: enter directory or show single or multiple items
* **Control + F, Apostrophe**: filter items
* **Backspace**: show all items (disable filter) or go to parent directory
* **C**: copy URL
* **Escape, Q**: exit

Examples
--------
Open single image.

    imagequick image.png

Browse directory and save session as 'default'.

    imagequick -sdefault MyPictures

Next time you can just run

    imagequick -sdefault

to resume browsing from the last time.

Browse Flickr gallery.

    imagequick -sflickr 'http://api.flickr.com/services/feeds/photos_public.gne?format=rss2'

Browse Daily Deviations on deviantART.

    imagequick -sdeviant 'http://backend.deviantart.com/rss.xml?q=special%3Add&type=deviation&offset=0'

