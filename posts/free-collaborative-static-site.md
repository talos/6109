In the last post, I explained why we chose to go with the static site generator [Nikola](http://getnikola.com/) for the Govlab 6109.  I didn't talk about how we actually collaboratively build and deploy a static site, though.  So without further ado...

# How to use GitHub to collaboratively build, edit, and freely deploy your organization's blog

For my [personal blog](http://johnkrauss.com), I use a static site generator and Github pages for free deployment.  When it came to setting up a static site generated blog for the Govlab 6109, I hoped to use a similar system.  Unfortunately, in a collaborative environment with differing technical backgrounds, not everyone might be willing to install `git`, `python`, and the various libraries necessary to pull down the static site and edit its raw entries.

The workflow of a static site for a non-technical person is actually pretty difficult, and the learning curve relatively steep -- especially compared to a mainline CMS, with which many people are already familiar.

## The benefits of a regular CMS

* Individual user accounts & authentication, allowing everyone to have their own drafts/works in progress before live deployment
* In-browser editing
* Easy generation of metadata

As much as I'd love it if everyone learned git and a solid local text editor, this ain't gonna happen -- especially when there are so many ways to avoid doing that and still publish a blog ([hello?](http://tumblr.com/)).

Fortunately, GitHub provides quite respectable in-browser editing of Markdown, including previews, and can theoretically (through branches or forks) handle individual user accounts and authentication.

As an added advantage, pushes to production naturally map to the pull request system, which means that the editing process is integral to deployment.

Metadata generation (the addition of timestamps for the post, the author's name, and tags) is tricky, since we can't customize the interface Github provides.  However, if we go with a static site builder that we have control over, we can fork the code and modify it as we wish to spare the end-user automatable annotation.

## Actually building it

So we've got a neat idea, and it seems like it should be possible.  How can it really be done?

While Github provides a built-in static site deployment through [Jekyll](http://jekyllrb.com), we wanted to be able to fully customize the code that builds our site.  This means that we also have to supply our own continuous integration, which can pick up on changes to the code and rebuild the site.  We can still take advantage of Github's free hosting by pushing to a `gh-pages` branch.
