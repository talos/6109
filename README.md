# The Govlab 6109

6109 is the blOg (see it?) for the Govlab's geeks and wizards...

6109 is an experiment itself.  We're trying a static site generator, Nikola,
along with Github hosting and continuous integration to enable the
collaborative generation of a static site.

## How it works

All posts are written in Markdown and committed to the `posts` directory of
your special branch -- `john` if you're John, `arnaud` if you're Arnaud, and
`luis` if you're Luis.  To create a new post, either fetch your branch locally,
install the `requirements.txt`, and then:

`nikola new_post -f markdown`

or browse to the `posts` folder of your branch on GitHub and create a new file,
starting with:

```
<!-- 
.. title: <Your title here>
.. slug: <Your slug here>
.. date: YYYY-MM-DD HH:mm:SS UTC-05:00
.. tags: <your tags here>
.. link: 
.. description: 
.. type: text
-->

# Your title in Markdown

Your content in markdown
```

Arbitrary HTML is allowed, including scripts and iframes.  With great power
comes great responsibility! ;)

Once the commit is on your branch on GitHub, the CI service will pick it up.
You can check progress and logs for the CI, called Shippable,
[here](https://app.shippable.com/projects/5453a27844927f89db3e6eee).

Once it builds successfully, you can preview your blog by going to
https://govlab.github.io/6109.<your-branch>/ .  So, if you're John, your branch
preview is visible at [https://govlab.github.io/6109.john/]().

At that point, you'll want comments and feedback!  [Open a pull request]() for
your branch against master, and maybe ping someone to take a look.  Once you've
integrated their suggestions, if any, merge your PR against master.  This will
build the [main site]() and your glorious work will be visible to the world!

  [Open a pull request]: https://github.com/GovLab/6109/pulls
  [main site]: https://govlab.github.io/6109/
