# Hugo Encryptor

**Hugo-Encryptor** is a tool to protect your [Hugo](https://gohugo.io) posts. It uses AES-128-GCM to encrypt the contents of your posts, and inserts a snippet of `<script>` code to verify whether the password is correct in readers' browser. Without a correct key, nobody can decrypt your private posts.

[中文文档](./README-zh_CN.md)

[DEMO](https://0n0.fun/post/2019/03/this-is-hugo-encryptor/)

## Installation

Using Docker, you should mount the `public` directory into the container. However, you still have to copy the shortcode snippet and decrypt.js into your blog directory (see below).

```bash
sudo docker run -v ./public:/public -it --rm sievelau/hugo_encryptor
```

If not using Docker, follow these steps. Environmental dependence: Python3

Python dependencies:

- pycryptodome
- beautifulsoup4
- lxml

### Step 0: Clone this repo

```bash
git clone https://github.com/sieveLau/hugo_encryptor.git
cd hugo_encryptor
chmod +x hugo-encryptor.py
```

### Step 1: Install python dependencies

#### Method 1: using pip

```bash
pip install -r requirements.txt
```

#### Method 2: using system package manager

For some OS such as Archlinux, the pip approach will generate an error: `error: externally-managed-environment`. On those systems, use the package manager to install the requirements. For example, using Archlinux's pacman:

```bash
pacman -S python-pycryptodome python-beautifulsoup4 python-lxml
```

### Step 2: Create a symlink (Optional)

If you want to execute `hugo-encryptor.py` without entering the full path to it, you need to make a symlink to it inside one of the directories of your PATH env.

For example, if `~/.local/bin` is in your PATH, and in Step 1 you cloned the repo into `~/hugo_encryptor`, you can use the following command to achieve the goal:

```bash
ln -sf ~/hugo_encryptor/hugo-encryptor.py ~/.local/bin/
```

### Step 3: Copy the shortcode snippet and decrypt.js into your blog:

In order to use the shortcode `{{% hugo-encryptor %}}` in your posts, you have to copy the `hugo-encryptor.html` (in `shortcodes` folder) into your blog's `layouts/shortcodes` folder.

And copy the [decrypt.js](decrypt.js) into your blog's `static` folder, so it will be copied by hugo into your website's root directory. If you want to use cdn, see [Tips and Tricks](#cdn)

## Usage

### Step 1: Wrap the text you want to encrypt with the tag `hugo-encryptor`

**Notice: Some texts are required before you actually start the encrypting part, with a tag `<!--more-->` placed in the middle of them. Those characters will be parsed by hugo as excerpt, so excerpt won't leak your contents**

Example:

```markdown
---
title: "An Encrypted Post"
---

some text here.

<!--more-->

{{% hugo-encryptor "PASSWORD" %}}

# You cannot see me unless you've got the password!

This is the content you want to encrypt!

{{% /hugo-encryptor %}}
```

**Do remember to close the `hugo-encryptor` shortcode tag (i.e. `{{% /hugo-encrpytor %}}`).**

### Step 2: Generate your site as usual

It may be something like:

    $ hugo

> Notice: You may remove the `public/` directory before re-generate it, see [#15](https://github.com/Li4n0/hugo_encryptor/issues/15#issuecomment-826044272) for details.

But I'd recommend you using the hugo command line option `--cleanDestinationDir` to clean the output directory and make a clean generation:

```bash
hugo --cleanDestinationDir
```

### Step 3: Get the encryption done!

If you have made a symlink as described in Step 2, you can just call the `hugo-encryptor.py` at the **root directory** of your blog. If you haven't, you have to specify the path to `hugo-encryptor.py`.

For example, the blog is in `~/hugo`, then you should:

```bash
cd ~/hugo
hugo-encrpytor.py
```

Remember to cd into your blog directory first! If everything goes right, you will see a few lines telling you the paths of the files being encrypted.

Then all the private posts in your `public` directory would be encrypted thoroughly, congrats!

## Configuration

Though **Hugo-Encryptor** can run without any configurations, if you like, you can configure it (hmm.. slightly).

```toml
[params]
  hugoEncryptorLanguage = "zh-cn"     # within ["zh-cn", "zh-cn"]
```

### Style

**Hugo-Encryptor** has no css but has left some class name for you to design your own style. Take a look at [shortcodes/hugo-encryptor.html](shortcodes/hugo-encryptor.html) ;-)

## Notice

- Do remember to keep the source code of your encrypted posts private. Never push your blog directory into a public repository.

- Every time when you generate your site, you should run `hugo-encryptor.py` again to encrypt the posts which you want to keep private.

## Tips and Tricks

### CDN

In [decrypt.js line 102](https://github.com/sieveLau/hugo_encryptor/blob/master/hugo-encryptor.py#L102), change `src="/decrypt.js"` to something like `src="https://cdn.jsdelivr.net/gh/sieveLau/hugo_encryptor@master/decrypt.js"`.
