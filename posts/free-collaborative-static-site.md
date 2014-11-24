In the last post, I explained why we chose to go with the static site generator [Nikola](http://getnikola.com/) for the Govlab 6109.  I didn't talk about how we actually collaboratively build and deploy a static site, though.  So without further ado...

# How to use GitHub to collaboratively build, edit, and freely deploy your organization's blog

For my [personal blog](http://johnkrauss.com), I use a static site generator and Github pages for free deployment.  When it came to setting up a static site generated blog for the Govlab 6109, I hoped to use a similar system.  Unfortunately, in a collaborative environment with differing technical backgrounds, not everyone might be willing to install `git`, `python`, and the various libraries necessary to pull down the static site and edit its raw entries.

The workflow of a static site for a non-technical person is actually pretty difficult, and the learning curve relatively steep -- especially compared to a mainline CMS, with which many people are already familiar.

## The benefits of a regular CMS

* Individual user accounts & authentication, allowing everyone to have their own drafts/works in progress before live deployment
* In-browser editing
* Easy generation of metadata
* Immediate preview of how your post will look in the site

As much as I'd love it if everyone learned git and a solid local text editor, this ain't gonna happen -- especially when there are so many ways to avoid doing that and still publish a blog ([hello?](http://tumblr.com/)).

Fortunately, GitHub provides quite respectable in-browser editing of Markdown, including previews, and can theoretically (through branches or forks) handle individual user accounts and authentication.

As an added advantage, pushes to production naturally map to the pull request system, which means that the editing process is integral to deployment.

Metadata generation (the addition of timestamps for the post, the author's name, and tags) is tricky, since we can't customize the interface Github provides.  However, if we go with a static site builder that we have control over, we can fork the code and modify it as we wish to spare the end-user automatable annotation.

An immmediate preview of how the post looks can be difficult -- the build process for a static site only takes a few seconds, but you need a server somewhere with the static site generator itself already installed.  Installing one from scratch, even programmatically, could take a minute.  This would be unacceptably slow.  However, with clever use of caching and/or containers, it should be possible to isolate the build to "just the build" and not the requirements -- and that's only takes a few seconds.

## Actually building it

So we've got a neat idea, and it seems like it should be possible.  How can it really be done?

While Github provides a built-in static site deployment through [Jekyll](http://jekyllrb.com), we wanted to be able to fully customize the code that builds our site.  This means that we also have to supply our own continuous integration (CI), which can pick up on changes to the code and rebuild the site.  We can still take advantage of Github's free hosting by having our CI server push the built site to a `gh-pages` branch.

I chose [Shippable](https://www.shippable.com/) for continuous integration, although YMMV.  Whichever CI you choose, make sure that it's possible to cache the app that's building the static pages.  For us, that meant creating a special [Docker container](https://registry.hub.docker.com/u/thegovlab/6109/) and using it as the base for all of our Shippable builds.  This turned the 30-40 second lag from building all the requirements for Nikola before building the site into just 1-2 seconds to grab the Docker container and 1-2 seconds to build the site.  Shippable is quite cheap, but you'll need to supply your own box to do the actual build -- if you've got a spare VPS or EC2 instance capable of running Docker, that will do fine.

Next up is providing everyone a copy of the site that they can work on, and their own preview of their work.  While this would seem to be a natural use of Github's fork feature, this doesn't work because their forked version couldn't be accessed by the CI without mucking about with their settings and keys.  Ugly.  Github also doesn't allow you to fork your own repo.  Even if you fake this process by creating a blank repo and pushing the existing code to that blank repo, the pull interface system won't recognize that the two repos are related.  What to do?

1. Create a separate branch in the main repo for each user
2. Create "fake forks" by creating blank repos named "<blog>.<user>"
3. Have people edit their posts on their own branch, but when they commit, have the CI push their changes to `gh-pages` on their "fake fork"

This allows each person to have a special preview url (for example, http://<project>.github.io/<blog>.<user>, if the main blog URL is https://<project>.github.io/<blog>) thanks to the "fake fork" that the CI pushes to.  However, they can still use the Github pull request system to request merges into `master` for the real blog deploy.  No one ever touches the "fake forks".

The workflow for a user looks like this:

<!--
[User creates post{bg:wheat}]-CI->[Deploys to personal preview{bg:steelblue}],
[User creates post{bg:wheat}]-User->[Edits{bg:wheat}],
[Edits{bg:wheat}]-User->[Pull request{bg:wheat}],
[Pull request{bg:wheat}]-Editor>[Comments{bg:violet}],
[Pull request{bg:wheat}]-Editor->[Merges{bg:violet}],
[Merges{bg:violet}]-CI>[Deploys to production{bg:steelblue}],
[Comments{bg:violet}]-User->[Edits{bg:wheat}],
[Edits{bg:wheat}]-CI->[Deploys to personal preview{bg:steelblue},
-->
![Workflow](http://www.yuml.me/c7f52c99)

For three users, the deploy process looks like this:

<!--
[https:⁄⁄github.com⁄org⁄blog|REPO{bg:tomato}]-[james|BRANCH{bg:thistle}]
[https:⁄⁄github.com⁄org⁄blog|REPO{bg:tomato}]-[debbie|BRANCH{bg:thistle}]
[https:⁄⁄github.com⁄org⁄blog|REPO{bg:tomato}]-[sally|BRANCH{bg:thistle}]
[https:⁄⁄github.com⁄org⁄blog|REPO{bg:tomato}]-[master|BRANCH{bg:violet}]
[https:⁄⁄github.com⁄org⁄blog|REPO{bg:tomato}]-[gh-pages|BRANCH{bg:thistle}]
[master|BRANCH]->[Continuous Integration|debbie|sally|master|james{bg:seagreen}]
[sally|BRANCH]->[Continuous Integration{bg:seagreen}]
[debbie|BRANCH]->[Continuous Integration{bg:seagreen}]
[james|BRANCH]->[Continuous Integration{bg:seagreen}]
[https:⁄⁄github.com⁄org⁄blog.sally|REPO (fake fork){bg:salmon}]-[gh-pages |BRANCH{bg:thistle}]
[https:⁄⁄github.com⁄org⁄blog.debbie|REPO (fake fork){bg:salmon}]-[gh-pages  |BRANCH{bg:thistle}]
[https:⁄⁄github.com⁄org⁄blog.james|REPO (fake fork){bg:salmon}]-[gh-pages   |BRANCH{bg:thistle}]
[Continuous Integration]->[gh-pages|BRANCH]
[Continuous Integration]->[gh-pages |BRANCH]
[Continuous Integration]->[gh-pages  |BRANCH]
[Continuous Integration]->[gh-pages   |BRANCH]
[gh-pages   |BRANCH]-.->[https:⁄⁄org.github.io⁄blog.james|PREVIEW BLOG{bg:skyblue}]
[gh-pages|BRANCH]-.->[https:⁄⁄org.github.io⁄blog|PRODUCTION BLOG{bg:steelblue}]
[gh-pages |BRANCH]-.->[https:⁄⁄org.github.io⁄blog.sally|PREVIEW BLOG{bg:skyblue}]
[gh-pages  |BRANCH]-.->[https:⁄⁄org.github.io⁄blog.debbie|PREVIEW BLOG{bg:skyblue}]
-->
![Deploy process](http://www.yuml.me/f0383a0e)

Each user has their own branch on the main repo, in addition to a "fake fork" repository with its own `gh-pages` branch so they can preview their own work.

Our `shippabe.yml` is [customized](https://github.com/GovLab/6109/blob/master/shippable.yml#L13) to push each special branch to the appropriate "fake fork" repo.

`$(test $BRANCH == master) && git remote set-url origin git@github.com:GovLab/6109.git || git remote set-url origin git@github.com:GovLab/6109.$BRANCH.git`

Our Nikola `conf.py` is [customized](https://github.com/GovLab/6109/blob/master/conf.py#L28) to provide the correct home URL for each user preview.

```
if GITHUB_SOURCE_BRANCH == 'master':
SITE_URL = "http://govlab.github.io/6109/"
else:
SITE_URL = "http://govlab.github.io/6109.{}/".format(GITHUB_SOURCE_BRANCH)
```
