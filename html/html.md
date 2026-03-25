# <!DOCTYPE html> :- 
	- Tells the browser: this is HTML5
	- Always at the top
	
2# <html lang="en">

	- Root of the page
	- lang="en" → important for accessibility & SEO
#  <head>

	- Contains meta info (not visible on page)

# Important tags inside:

	- <meta charset="UTF-8">: Supports all characters (including emojis, symbols)
	- <meta name="viewport"...>: Makes your site responsive on mobile
	- <title>: Shows in browser tab
4	- <body>: Everything visible to users Text, images, buttons, etc.

Example: 
	<!DOCTYPE html>
	<html lang="en">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>My First Page</title>
	</head>
	<body>

	    <h1>Hello World</h1>
	    <p>This is my first HTML page.</p>

	</body>
	</html>
	


# Headings (<h1> to <h6>)
	<h1>Main Title</h1>
	<h2>Section Title</h2>
	<h3>Subsection</h3>
### Rules:
	<h1> → only one per page
	Use headings in order (don’t jump randomly)
	Helps with SEO + structure
# Paragraph (<p>): 
	<p>This is a paragraph of text.</p>
	Used for normal text content

### Text Formatting Tags
	Bold (important text):  <strong>Important text</strong>
	Use instead of <b> (more semantic)

	Italic (emphasis): <em>Emphasized text</em>
	Use instead of <i>

	Line Break: <p>Hello<br>World</p>
	Moves text to next line (no new paragraph)

	Horizontal Line: <hr>
	Creates a section divider

## Example:
	<h1>My Blog</h1>

	<p>This is my <strong>first blog</strong>.</p>

	<h2>About Me</h2>
	<p>I am learning <em>HTML</em>.</p>

	<hr>

	<p>Thank you for visiting.</p>
	
# Links & Images
	Links (<a> tag): <a href="https://google.com">Go to Google</a>

### Types of Links
	External link: <a href="https://example.com">Visit Website</a>
	Open in new tab: <a href="https://example.com" arget="_blank">Open in new tab</a>

	Internal link (same project): <a href="about.html">About Page</a>
	
	Images (<img> tag): <img src="image.jpg" alt="Description of image">

	Example: <img src="cat.jpg" alt="A cute cat sitting">

### Example (Links + Images)
	<h1>My Website</h1>

	<p>Visit my favorite site:</p>
	<a href="https://google.com" target="_blank">Google</a>

	<hr>

	<h2>My Image</h2>
	<img src="cat.jpg" alt="A cute cat">
	
	
	

# Unordered List (<ul>)

	 Bullet points

	<ul>
	  <li>Apple</li>
	  <li>Banana</li>
	  <li>Mango</li>
	</ul>
# Ordered List (<ol>)

	 Numbered list

	<ol>
	  <li>Wake up</li>
	  <li>Study HTML</li>
	  <li>Practice</li>
	</ol>
# List Item (<li>)
	Used inside <ul> or <ol>
	Represents each item

	<ul>
	  <li>Item</li>
	</ul>
# Example
	<h2>My Hobbies</h2>

	<ul>
	  <li>Watching movies</li>
	  <li>Coding</li>
	  <li>Playing games</li>
	</ul>

	<h2>Daily Routine</h2>

	<ol>
	  <li>Wake up</li>
	  <li>Go to college</li>
	  <li>Practice coding</li>
	</ol>

# Layout (div + semantic tags)

### <div> (Generic Container)
	<div>
	  <h2>Section</h2>
	  <p>Content here</p>
	</div>
	
### Semantic Tags (VERY IMPORTANT)


	<header>: Top section (logo, title)

	<header>
	  <h1>My Website</h1>
	</header>
	<nav>: Navigation links

	<nav>
	  <a href="#">Home</a>
	  <a href="#">About</a>
	</nav>
	
	<main>: Main content

	<main>
	  <p>This is main content</p>
	</main>
	
	<section>: Grouping related content

	<section>
	  <h2>About</h2>
	  <p>Info here</p>
	</section>
	
	<footer>: Bottom of page

	<footer>
	  <p>© 2026 My Website</p>
	</footer>
	
### Example
	<body>

	  <header>
	    <h1>My Website</h1>
	  </header>

	  <nav>
	    <a href="#">Home</a>
	    <a href="#">About</a>
	  </nav>

	  <main>

	    <section>
	      <h2>About Me</h2>
	      <p>I am learning HTML</p>
	    </section>

	    <section>
	      <h2>My Goals</h2>
	      <p>Become a developer</p>
	    </section>

	  </main>

	  <footer>
	    <p>© 2026 My Website</p>
	  </footer>

	</body>
