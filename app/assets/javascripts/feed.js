function doFeed() {
FB.ui(
      {
       method: 'feed',
       name: 'The Facebook SDK for Javascript',
       caption: 'Bringing Facebook to the desktop and mobile web',
       description: (
          'A small JavaScript library that allows you to harness ' +
          'the power of Facebook, bringing the user\'s identity, ' +
          'social graph and distribution power to your site.'
       ),
       link: 'https://developers.facebook.com/docs/reference/javascript/',
       picture: 'http://www.fbrell.com/public/f8.jpg'
      },
      function(response) {
        if (response && response.post_id) {
          alert('Post was published.');
        } else {
          alert('Post was not published.');
        }
      }
    );
}
