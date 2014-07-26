function thumbToggle() {
    var path = this.src;

    var ext = "jpg";
    if ( path.substring(path.length -3) === ext ) {
        ext = "gif";
    }
    
    this.src = path.substring(0, path.length -3) + ext;
}

$('.video-thumbnail').mouseover(thumbToggle);
$('.video-thumbnail').mouseout(thumbToggle);
