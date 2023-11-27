## Group Members
__________________

* Alvin Zhafif Afilla (2206046632)
* Muhammad Sean Arsha Galant (2206822963)
* Gregorius Samuel Hutahean (2206046701)
* Galih Ibrahim Kurniawan (2206046696)
* Muhammad Sakhran Thayyib AKA Duden (2206046790)

## Link to the APK
__________________

Temporarily blank until stage 2 is done

## Application description (name and function of the application).
__________________

### Midoku’s Story and Benefits

Keeping track of your reading progress can be a persistent challenge when delving into the world of books, especially in today’s digital age. This issue becomes even more pronounced with online books, manga, manhwa, and light novels, as they often receive sporadic updates, sometimes with significant gaps between new chapters. When you find yourself engrossed in multiple forms of literature simultaneously, it’s all too easy for your reading experiences to blur together, leaving you uncertain about what you’ve already perused.


In this increasingly interconnected world of literature, the need to remember where you last left off is a constant concern. As avid readers, you don’t want to start a book from the beginning just because you’ve lost your place. That’s where Midoku comes in — your reliable companion for effortlessly tracking your reading adventures. Whether your interests lie in manga, light novels, manhwa or any other genre, “Midoku” is purpose-built to ensure you never lose your reading progress again. Designed with readers in mind, it empowers you to manage your literary journeys with ease, making sure you’re always in control of your reading experience, anytime, anywhere.


— " Midoku " isn't just your run-of-the-mill reading companion; it's a versatile tool designed to enhance your literary journey in more ways than one. With a vast catalog boasting over 100 titles, you can effortlessly curate your personal reading list, marking the books you've devoured and tracking your progress down to the last chapter. But that's not all—here's where the magic happens.


What if you stumble upon a hidden gem that's not yet in our catalog? No need to fret! " Midoku " offers you the freedom to add any book, complete with all the relevant information, directly to your collection. This feature opens the door to a world of literary treasures that might be elusive or underappreciated, allowing you to share these newfound gems with your friends. There's a unique joy in introducing your buddies to a literary masterpiece that's yet to hit the mainstream.


But wait, there's more! We've implemented a tagging system that lets you describe the key aspects of each piece of literature. Whether you're craving heart-pounding action, heart-fluttering romance, or side-splitting comedy, our tags simplify your search for the perfect read. Looking for something that defies categorization? Users can even submit their own tags for review by our diligent admins, expanding the available list of tags and ensuring you find precisely what you're looking for in your literary adventures. With " Midoku ," your reading experience is not just organized; it's tailor-made to suit your every literary whim.


Each book is meticulously curated, accompanied by detailed plot descriptions that transport readers into the heart of the story. Whether you are a fan of gripping mysteries, heartwarming romances, mind-bending science fiction, or insightful non-fiction, Midoku has something for everyone. The plot descriptions provided on the website are not mere summaries but expertly crafted narratives that entice readers, giving them a glimpse into the intriguing twists and turns that await within the pages of each book. Exploring new literary adventures has never been more immersive and delightful.


Apart from your usual manga-reading sites, our site provides you with your very own personal space where you can exclusively read and store information about your collection. Thinking about tracking your own progress in reading through a handful of manga at a time? Or do you keep forgetting the name of a book and have to search for it painstakingly? Fear not! You can now seamlessly track your own progress for every manga encountered and search through them with minimum effort. This way, you won’t have to worry about losing progress on any manga or book ever again and admire your glorious collection with all the privacy you need. If the book or manga you’re looking for is not listed within our catalog, then you can easily add your desired piece of literature without restriction to your list. Feel the freedom of adding countless manga and books to your list and even share it among your friends if you wish to!


Made by you, and made for you.

### List of implemented modules with the distribution of work per member.
__________________
Pages and Important widgets to be implemented:

**Login Page:** The page that the user will be routed to when they access the application. They will input their login details on this page, which will then be sent to the Django project, where the user is authenticated and logged in. Users can also access the Registration Page from here


**Registration Page:** This is where users can register to the application, by filling in their desired username, desired password and their password confirmation. This information will be sent to the Django project using request.post, in which the backend will determine if the new user is valid (no one has that username yet and the password is secure) and will accept or reject the registration accordingly


**Catalog Page:** This is where all of the books in our catalogue will be shown and where the user is navigated to when they log in. Users can also view further details about any book on the catalogue by tapping on it, and also there will be an option when you click on the book you will add it to your personal collection in the collection page.


**Collection Page:** Where the user can view all of the book entries that they have added from the catalogue or they made a custom entry for. Users can view further detail regarding any book entry (such as any notes that they have written down regarding the bok, their rating, their review etc.) by tapping on them. Users can also, set their favourite entry, edit entries and access the create custom entry page from here. 


**Add Catalog Entry Page:** Users may add entries from the catalog page, in which case they will be navigated to this page, which will display the information regarding the book (title, author, image, description) along with a few input fields to input information regarding the entry (last chapter read, rating, review, notes)


**Add Custom Entry:** In this page users can add entries for books not found in the Catalogue page, here they have to fill out the details regarding the book (title, author, description, image link, tags) as well as the entry details (last chapter read, notes, review, rating). This data will be sent to the Django project, and if the data is valid then a BookEntry with that data will be created


**Other User Collection Page:** Similar to the collection page, but instead of showing the entries of the user that is logged in, it shows the collection of a different user. Users can only view the entries and add any entries they like from this other user’s collection to their own collection. They can’t edit entries nor set any entries as favourite, however admins (superusers and staff) may be able to delete entries if they deem that that entry is inappropriate (will mostly occur if users add an inappropriate custom entry).


**User List Page:** This where the user can view other users that are registered to the app, the user then can check out other user’s collection from here, thus rerouting the user to the Other User Collection Page


**Admin Page:** In the Admin Page, Admins can view other users collections, make other users as admin, delete other users from the application/database, as well as approve or reject Bookpost and Tag suggestions from users (that will be added to the database and appear in the catalog page when approved)


**Search Title Page:** The user can also search the catalog based on the title they want, the user will then be redirected into a new page with the books filtered based on what they had searched. If what they have searched does not exist then a notice with a blank page will be shown.


Distribution of Work:


* Muhammad Sean Arsha Galant: Catalogue Page, Admin Page(with Duden)


* Galih Ibrahim Kurniawan: Book entries Page, Other User Collection Page, Add Catalog Entry Function, Add Custom Entry Function 
  

* Alvin Zhafif Afilla: register & login


* Gregorius Samuel Hutahean: User Display Page


* Muhammad Sakhran Thayyib / Duden: Search Page, Admin Page(with Sean)

**Note:** Our group members may help/work on pages/modules/functions outside of what they have been assigned to, in which case their contribution will be acknowledged during presentation/an update to the README after stage 1
### User roles or actors in the application
__________________

Owner/Superuser - The Owner (or the Superuser) in our web application has the ability add and remove admins. The Owner/Superuser is also able to perform all the operations that admins and user can do.

Admin - The Admin is capable of accepting or rejecting tag (such as adding tags) and book (such as adding books to the catalog) requests. However, the admin is not capable of adding more admins into the web application.

User - The User is able to add books to their own list (which can be from the catalog or they can add all of the details of the book that they have read themselves), share their lists to other users, as well as add reviews and edit the last-read attribute to books in their list. They can also submit possible book tags or books for the catalog that the admins can accept or deny before adding them to the web application for other users to see publicly.

### Integration flow with the web service to connect to the web application created during the Midterm Project.
__________________
We will be utilising the Provider and the pbp_django_auth packages to facilitate transfer of data between our flutter app(Final Project) with our Django project(Midterm Project). Specifically, we will use the CookieRequest.get method to fetch data from our Django database, the CookieRequest.post method for registration or to save instances of BookEntries, TagPosts, BookPosts, etc. to our Django database and the CookieRequest.login method for authentication (such as logging in and saving the current user)


### Link to the report documents/sheets.
__________________

https://docs.google.com/spreadsheets/d/1qj96wXAVZJGXg9jvsCb3iM_aPbRxxIprww1FheIdtSo/edit#gid=0

### Link to Meeting Minutes
__________________
https://docs.google.com/document/d/1imXNmesgl2c_y6nTBjoqEtfVuPo_Bwlwjfar6pO7UQ4/edit?usp=sharing

