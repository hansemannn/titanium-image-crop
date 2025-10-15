# Titanium Image Cropping Tool

An easy to crop images to different scales. Based on the awesome [TOCropViewController](https://github.com/TimOliver/TOCropViewController) library. Currently iOS only (!)

<img src="./example.png" height="600" alt="Example Screenshot" />
<img src="./IMG_0827.PNG" height="600" alt="Example Screenshot rounded cropping" />

## Requirements

- [x] Titanium SDK 12.0.0+

## Methods

### `showCropDialog`

#### Parameters

- `image` (String, Ti.Blob, Ti.File)
- `croppingStyle` 'circular' or 'default' (String) in not set 'default' is selected

- `aspectRatio` A dictionary {x, y} to describe the aspect ratio. Note: Prior to v3.0.0,
you could also apply a preset, but these have been removed in the native library.

## Events

- `done`
  - Attributes: `image` (Ti.Blob, if finished cropping), `cancel` (`true` if cancelled, `false` if completetd)
- `close`

## Notes

- If opening the image crop dialog from a modal window, please set the `modalStyle: Ti.UI.iOS.MODAL_PRESENTATION_OVER_CURRENT_FULL_SCREEN` property (thanks to [designbymind](https://github.com/designbymind)!)

## Example

```js
import ImageCrop from 'ti.imagecrop';

ImageCrop.addEventListener('done', event => {
  if (event.cancel) {
    return;
  }

  win.add(Ti.UI.createImageView({ height: 400, image: event.image }));
});

ImageCrop.addEventListener('close', event => {
  // Open other windows after the close has been triggered
  // to prevent transition glitches
});

const win = Ti.UI.createWindow({
  backgroundColor: '#fff'
});

const btn = Ti.UI.createButton({
  title: 'Show crop dialog'
});

btn.addEventListener('click', () => {
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
