In the last post, I explained why we chose to go with the static site generator Nikola for the Govlab 6109.  I didn't talk about how we actually collaboratively build and deploy a static site, though.  So without further ado...

# How to use GitHub to collaboratively build, edit, and freely deploy your organization's blog

For my [personal blog](http://johnkrauss.com), I use a static site generator and Github pages for free deployment.  When it came to setting up a static site generated blog for the Govlab 6109, I hoped to use a similar system.  Unfortunately, in a collaborative environment with differing technical backgrounds, not everyone might be willing to install `git`, `python`, and the various libraries necessary to pull down the static site and edit its raw entries.

The workflow of a static site for a non-technical person is actually pretty difficult, and the learning curve relatively steep -- especially compared to a mainline CMS, with which many people are already familiar.

## The benefits of a regular CMS

* Individual user accounts & logins, allowing everyone to have their own drafts/works in progress before live deployment
* In-browser editing
* Easy generation of metadata
