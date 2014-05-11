// image rollover for our thumbnails with spinner
function genId (file) {
    var x = file.length;
    while((file.substring(x,x-1)) != "."){ x--; } clipend = x;
    while((file.substring(x,x-1)) != "/"){ x--; } clipstart = x;
    return file.substring(clipend-1,clipstart);
}

var overlay = "/images/spinner.gif";
function thumbToggle() {
    var path = this.src;

    var ext = "jpg";
    var id = "ID"+genId(path);
    var ov = document.getElementById(id);
    if ( path.substring(path.length -3) == ext ) {
        ext = "gif";
        // show animation
        if ( ov ) {
            ov.style.display = 'inline';
        } else {
            ov = new Image();
            ov.src = overlay;
            ov.id = id;
            ov.className = 'thumbnail-spinner';
            var myDiv = this.parentNode;
            myDiv.insertBefore(ov, myDiv.firstChild);
        }
        
    } else {
        // leave animation
        if ( ov ) ov.style.display = 'none';
    }
    this.src = path.substring(0, path.length -3) + ext;
}

$('.video-thumbnail').mouseover(thumbToggle);
$('.video-thumbnail').mouseout(thumbToggle);
