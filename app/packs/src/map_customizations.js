$(() => {
  // Customize hashtag ordering
  $("#awesome-map").on("ready.decidim", (_e, map) => {
    const hashtagCompare = (a, b) => {
      // console.log("compare", a, b)
      if(a.toLowerCase().startsWith("#metropoli")) {
        a = ` ${a}`
      }
      if(b.toLowerCase().startsWith("#metropoli")) {
        b = ` ${b}`
      }
      return a.localeCompare(b);
    };

    // order hashtags with "metropoli" first, then alphabetically
    window.AwesomeMap.controls.onHashtag = (hashtag, $div) => {
      // console.log("hashtag added", hashtag)
      let $last = $div.contents("label:last");
      if($last.prev("label").length) {
        // move the label to order it alphabetically
        $div.contents("label").each((_idx, el) => {
          if(hashtagCompare($(el).text(), $last.text()) > 0) {
            $(el).before($last);
            return false;
          }
        });
      }
    };
  });
});
