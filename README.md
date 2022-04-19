Forensic Chrome Extension Download Helper
=========================================

Synopsis
--------

```
download-crx.pl [--zip|-z] <extension id or extension URL> […]
download-crx.pl --extract|-x <file> […]
download-crx.pl [--extract|-x] <file>.crx […]
download-crx.pl [--extract|-x] ./<path to file> […]
download-crx.pl [--extract|-x] ../<path to file> […]
download-crx.pl [--extract|-x] /<path to file> […]
```


Description
-----------

This little helper tool downloads `.crx` files from the [Google Chrome
Webstore](https://chrome.google.com/webstore/) from the commandline
and optionally dumps the contained ZIP archive (i.e. strips the CRX
binary headers).

Supported are the [version 2][2] and [version 3][3] of the CRX file
format.

[2]: https://www.dre.vanderbilt.edu/~schmidt/android/android-4.0/external/chromium/chrome/common/extensions/docs/crx.html
[3]: https://github.com/ahwayakchih/crx3/blob/master/lib/crx3.proto

It was written for the purpose of downloading Google Chrome Extensions
outside the browser and making it available in a format easy to handle
for forensic analyses.


Parameters
----------

The script requires one or more parameters, which can be either:

* An extension ID,
* A Google Chrome Webstore Extension URL,
* A local file in CRX format.

If given an extension ID or a Google Chrome Webstore Extension URL, it
will fetch that extension's CRX file from the Google Chrome Webstore.

If given an existing local file, it will only dump the contained ZIP
archive.


Options
-------

* `-z`, `--zip`: Also dump the contained ZIP archive.

* `-x`, `--extract`: Take the parameter as file name of a CRX format
  file and dump its contained ZIP archive.


Credits
-------

* https://github.com/acvetkov/download-crx for the general approach
  and download URLs. (To avoid any license issues, the same license as
  this project has been chosen even though only the contents of three
  variables and a general idea has been taken from its code.)
  
* https://www.dre.vanderbilt.edu/~schmidt/android/android-4.0/external/chromium/chrome/common/extensions/docs/crx.html
  for the description of the CRX v2 file format.

* https://github.com/ahwayakchih/crx3/blob/master/lib/crx3.proto 
  for the description of the CRX v3 file format.


Author, Copyright and License
-----------------------------

### Author

This software was written by Axel Beckert <axel@ethz.ch>.

### Copyright

2022 Axel Beckert  
2022 ETH Zürich IT Security Center

### License

Permission to use, copy, modify, and/or distribute this software for
any purpose with or without fee is hereby granted, provided that the
above copyright notice and this permission notice appear in all
copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.

(This is the [ISC License](https://spdx.org/licenses/ISC).)
