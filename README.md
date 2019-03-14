# Titanium Image Cropping Tool

An easy to crop images to different scales. Based on the awesome [TOCropViewController](https://github.com/TimOliver/TOCropViewController) library. Currently iOS only (!)

<img src="./screenshot.png" height="400" alt="Example Screenshot" />

## Requirements

- [x] Titanium SDK 8.0.0+ (this module  is 100 % Swift based)

## Methods

### `showCropDialog`

#### Parameters

- `image` (String, Ti.Blob, Ti.File)
- `aspectRatio` (either a dictionary {x, y}  of the ratio or one of the constants * below)

## Constants

- `ASPECT_RATIO_SQUARE`
- `ASPECT_RATIO_3x2`
- `ASPECT_RATIO_5x3`
- `ASPECT_RATIO_4x3`
- `ASPECT_RATIO_5x4`
- `ASPECT_RATIO_7x5`
- `ASPECT_RATIO_16x9`

## Events

- `done`
  - Attributes: `image` (Ti.Blob, if finished cropping), `cancel` (`true` if cancelled, `false` if completetd)

## Example

```js
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
    image: 'test.jpg'
  });
});

win.add(btn);
win.open();
```

## License

MIT

## Author

Hans Knöchel
