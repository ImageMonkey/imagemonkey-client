> # Because training a ML model is easy - finding a good image dataset is hard.


ImageMonkey is a free, public open source image validation service. With all the great machine learning frameworks available it's pretty easy to train pre-trained Machine Learning models with your own image dataset. However, in order to do so you need a lot of images. And that's usually the point where it get's tricky. You either have to create the training images yourself or scrape them together from various datasources. ImageMonkey aims to solve this problem, by providing a platform where users can drop their photos, tag them with a label, and put them into public domain. 

![Alt Text](https://github.com/bbernhard/imagemonkey-client/raw/master/demo/animation.gif)

## Requirements ##
* Qt 5.9.1

## Build instructions ##
* clone repository 
* make sure that `_EXECUTIONTARGET_` in `imagemonkey_client.pro` file is set to `PRODUCTION` (if you want to use the imagemonkey.io instance). 
* run `qmake` and deploy to Android/iOs
