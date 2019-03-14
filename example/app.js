const ImageCrop = require('ti.imagecrop')

ImageCrop.addEventListener('done', function (event) {
    if (event.cancel) return;
    win.add(Ti.UI.createImageView({ height: 400, image: event.image }));
});

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
    title: 'Show crop dialog'
});

btn.addEventListener('click', function () {
    ImageCrop.showCropDialog({
        doneButtonTitle: L('Done', 'Fertig'),
        cancelButtonTitle: L('Cancel', 'Abbrechen'),
        aspectRatio: ImageCrop.ASPECT_RATIO_SQUARE,
        image: 'example.jpg'
    });
});

win.add(btn);
win.open();