ratings exporter for Netflix
============================

What
----

This service was born of my desire to quit Netflix but without having to lose all that info on what I've watched and what I've rated. To that end, I started investigating the [Netflix API](http://developer.netflix.com). While the API doesn't have exactly what I wanted (e.g. fetch all my rated movies), it was able supply enough functionality for me to fetch ratings for all the movies I had rented/streamed. Good enough, I suppose. Since collecting that information from Netflix takes time, I created a web service which would spawn <code>delayed_jobs</code> to do the work.

To get started with your own export, click the <em>Authorize</em> button above, fill in your Netflix credential (note: we use Netflix's OAuth API. See the next section for more details), and this service will be begin exporting your Netflix DVD and Instant rental queue data for you. Once all of the records have been exported, you'll be able to download the data as a blob of <code>json</code>.

Thanks to [Christopher Cotton](http://blog.christophercotton.com/) for answering my [Netflix OAuth question on Stack Overflow](http://stackoverflow.com/a/8516022/349423)!

<p>If you would like to help keep this service running, please donate!</p>
<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
<fieldset>
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="HMZ2WP3MK36QN">
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" class="btn large" style="width: 74px;">
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
</fieldset>
</form>


Secure
------

Our service is never given your Netflix credentials. We are using the [Netflix OAuth API](http://developer.netflix.com/docs/read/Security), which means you are only authorizing this web app to make requests on your behalf.

We do store a few pieces of Netflix OAuth data in your cookies, including your Netflix <code>user_id</code> so that you do not have to keep re-authorizing the web app if you want to use it more than once. When you are done using this service, you can click the sign out link in the toolbar and we'll flush that information from your cookies.

Your exported rating information is stored in our database for short, indeterminate amount of time, after which it is permanently expunged during recurring, routine maintenance.

This data is available to only you.

Good news, Bad news
-------------------

  <p>The bad news is that this service is only using one web dyno and one worker process. So, it is going to be slow. The good news is, this service is free!</p>
  <p>Even more good news, the code for this service is available on [Github](https://github.com/sorens/ratings_exporter). Feel free to inspect it to ensure that we're not doing anything untoward with your data.</p>
  <p><em>Update</em>We've updated the service to use batch requests so now you shouldn't encounter Netflix's request limit. However, there are still circumstances where requests for ratings return no results. If that happens, we detect that there are un-exported ratings and offer you a chance to download those remaining ratings individually by clicking the <em>Continue</em> button. If you would like to skip exporting those ratings, you can lick the <em>Ignore</em> and we'll let you download your data.</p>


Format of the JSON
------------------
<pre>
{
    "60010377": {
        "id": "60010377",
        "title": "Funny Girl",
        "year": "1968",
        "url": "http://api.netflix.com/catalog/titles/movies/60010377",
        "rating": "4.0",
        "type": "streamed",
        "viewed_date": "2011-12-05T09:03:48Z"
    },
    "70102614": {
        "id": "70102614",
        "title": "Dead Like Me: Season 1: \"Reaping Havoc\"",
        "year": "2003",
        "url": "http://api.netflix.com/catalog/titles/programs/70102614",
        "rating": "5.0",
        "type": "streamed",
        "viewed_date": "2009-04-03T17:20:30Z"
    }
}  
</pre>
<em>note: if we were unable to export a rating for a title due to an error, rating will be set to null. If you never set a rating on a particular title, we set the rating to 0.0.</em>
