# **OpenCV**

## 函数

### *findContours*

https://blog.csdn.net/eric_e/article/details/79591025

 ```c++
findContours( InputOutputArray image,
                OutputArrayOfArrays contours, 
                OutputArray hierarchy, 
                int mode,
                int method, 
                Point offset=Point()); 
 ```

​    **第一个参数**：image，单通道图像矩阵，**可以是灰度图**，但更常用的是二值图像，一般是经过Canny、拉普拉斯等边缘检测算子处理过的二值图像；



**第二个参数**：contours，定义为

```c++
vector<vector<Point>> contours
```

**是一个向量，并且是一个双重向量,向量内每个元素保存了一组由连续的Point点构成的点的集合的向量，每一组Point点集就是一个轮廓。有多少轮廓，向量contours就有多少元素。**



**第三个参数**：hierarchy，定义为**“vector<Vec4i> hierarchy”**，先来看一下Vec4i的定义：                  

```
  typedef    Vec<int, 4>   Vec4i;  
```

​           Vec4i是Vec<int,4>的别名，定义了一个“**向量内****每一个元素包含了4个int型变量**”的向量。



​           所以从定义上看，hierarchy也是一个向量，向量内每个元素保存了一个包含4个int整型的数组。

​           向量hiararchy内的元素和轮廓向量contours内的元素是一一对应的，向量的容量相同。

​           hierarchy向量内每一个元素的4个int型变量——hierarchy[i][0] ~hierarchy[i][3]，分别表示第

​        i个轮廓的**后****一个轮廓、前一个轮廓、父轮廓、内嵌轮廓的索引编号**。如果当前轮廓没有对应的后一个

​        轮廓、前一个轮廓、父轮廓或内嵌轮廓的话，则hierarchy[i][0] ~hierarchy[i][3]的相应位被设置为

​        默认值-1。



第四个参数：int型的mode，定义轮廓的检索模式：



​           取值一：CV_RETR_EXTERNAL**只检测最外围轮廓**，包含在外围轮廓内的内围轮廓被忽略



​           取值二：CV_RETR_LIST   检测所有的轮廓，包括内围、外围轮廓，但是检测到的轮廓不建立等级关

​                  系，彼此之间独立，没有等级关系，这就意味着**这个检索模式下不存在父轮廓或内嵌轮廓**，

​                  所以hierarchy向量内所有元素的第3、第4个分量都会被置为-1，具体下文会讲到



​           取值三：CV_RETR_CCOMP  检测所有的轮廓，但所有轮廓只建立两个等级关系，外围为顶层，若外围

​                  内的内围轮廓还包含了其他的轮廓信息，则内围内的所有轮廓均归属于顶层



​           取值四：CV_RETR_TREE， 检测所有轮廓，所有轮廓建立一个等级树结构。外层轮廓包含内层轮廓，内

​                   层轮廓还可以继续包含内嵌轮廓。



第五个参数：int型的method，定义轮廓的近似方法：



​           取值一：CV_CHAIN_APPROX_NONE 保存物体边界上所有连续的轮廓点到contours向量内



​           取值二：CV_CHAIN_APPROX_SIMPLE **仅保存轮廓的拐点信息**，把所有轮廓拐点处的点保存入contours

​                   向量内，拐点与拐点之间直线段上的信息点不予保留



​           取值三和四：CV_CHAIN_APPROX_TC89_L1，CV_CHAIN_APPROX_TC89_KCOS使用teh-Chinl chain 近

​                   似算法



第六个参数：Point偏移量，所有的轮廓信息相对于原始图像对应点的偏移量，**相当于在每一个检测出的轮廓点上加**

​            **上该偏移量**，**并且Point还可以是负值**！



### split()、merge()

```c
void split(const Mat& src, Mat* mvbegin) 
void split(InputArray m, OutputArrayOfArrays mv) 
void merge(const Mat* mv, size_t count, OutputArray dst) 
void merge(InputArrayOfArrays mv, OutputArray dst)
    
例：
static Mat m_frHLS, m_HLS[3];
split(m_frHLS, m_HLS);
```



### *Sobel,Scharr,Laplace,Canny*

#### 1.Sobel

```cpp
def Sobel(src,ddepth,dx,dy,dst=None,ksize=None,scale=None,delta=None,borderType=None)
    
例：
Sobel(m_HLS[1], m_frGradL, m_HLS[1].depth(), 1, 0);//求解L通道打梯度值
Sobel(m_HLS[2], m_frGradS, m_HLS[2].depth(), 1, 0);//求解S通道打梯度值
```

ddepth:图像的颜色深度，针对不同的输入图像，输出目标图像有不同的深度，具体组合如下： 
- 若src.depth() = CV_8U, 取ddepth =-1/CV_16S/CV_32F/CV_64F 
- 若src.depth() = CV_16U/CV_16S, 取ddepth =-1/CV_32F/CV_64F 
- 若src.depth() = CV_32F, 取ddepth =-1/CV_32F/CV_64F 
- 若src.depth() = CV_64F, 取ddepth = -1/CV_64F 
dx:int类型的，表示x方向的差分阶数，1或0 
dy:int类型的，表示y方向的差分阶数，1或0 
kSize：模板大小，前面虽然提到过，不过对于Sobel算子这里要补充下，这里的取值为1，3，5，7，当不输入的时候，默认为3。特殊的，当kSize = 1的时候，采用的模板为1*3或者3*1 而非平时的那些格式。



#### 2.Scharr

```c
def Scharr(src, ddepth, dx, dy, dst=None, scale=None, delta=None, borderType=None) 
```

会看到参数和Sobel算子一致，不过，该函数与Sobel的区别在于，Scharr仅作用于大小为3的内核。**具有和sobel算子一样的速度，但结果更为精确**



#### 3.Laplace

```c
def Laplacian(src,ddepth,dst=None,ksize=None,scale=None,delta=None,borderType=None) 
```

**scale**：Double类型的，计算拉普拉斯可选比例因子，有默认值1 
**delta**：加到输出像素的值，默认为0 
**borderType**：边界模式。默认值BORDER_DEFAULT

Laplace其实利用Sobel算子的运算，它通过Sobel算子运算出图像在x方向和y方向的导数，来得到我们载入图像的拉普拉斯变换结果。 



#### 4.Canny

```c
def Canny(image,threshold1,threshold2,edges=None,apertureSize=None,L2gradient=None)
```



threshold1：int类型的，低阈值 
threshold2：int类型的，高阈值 
edeges：单通道存储边缘的输出图像 
apertureSize：Sobel算子内核(kSize)大小 
L2gradiend：Bool类型的，为真表示使用更精确的L2范数进行计算(两个方向的倒数的平方再开放），为假表示用L1范数(直接将两个方向导数的绝对值相加）



### *threshold*

```c
double threshold(InputArray src, 
    OutputArray dst,
    double thresh, 
    double maxval, 
    int type);
```

对数组元素进行固定阈值操作；并且该函数可以对多通道的数组用固定的阈值进行二值化；通常用于将灰度图像转换为二值化的图像；用于消除噪声，即滤除值过小或过大的像素；函数支持几种类型的阈值处理，由函数中的type参数决定；



- 第三个参数，double thresh，进行二值化的阈值；

- 第四个参数，double maxval，最大值，一般与THRESH_BINARY或者THRESH_BINARY_INV阈值类型一起使用；

- 第五个参数，int type，阈值的类型；

| type | 阈值类型枚举      |                                                              |
| :--- | ----------------- | ------------------------------------------------------------ |
|      | THRESH_BINARY     | 正向二值化,如果当前的像素值大于设置的阈值(thresh)，则将该点的像素值设置为maxval；否则，将该点的像素值设置为0； |
|      | THRESH_BINARY_INV | 反向二值化，如果当前的像素值大于设置的阈值(thresh)，则将该点的像素值设置为0；否则，将该点的像素值设置为maxval； |
|      | THRESH_TRUNC      | 如果当前的像素值大于设置的阈值(thresh)，则将该点的像素值设置为threshold；否则，将该点的像素值不变； |
|      | THRESH_TRUNC      | 如果当前的像素值大于设置的阈值(thresh)，则将该点的像素值设置为threshold；否则，将该点的像素值不变； |
|      | THRESH_TOZERO     | 如果当前的像素值大于设置的阈值(thresh)，则将该点的像素值不变；否则，将该点的像素值设置为0； |
|      | THRESH_TOZERO_INV | 如果当前的像素值大于设置的阈值(thresh)，则将该点的像素值设置为0；否则，将该点的像素值不变； |



### *VideoCapture类*

https://blog.csdn.net/weicao1990/article/details/53379881

#### 1.VideoCapture类的构造函数：

```cpp
C++: VideoCapture::VideoCapture();
C++: VideoCapture::VideoCapture(const string& filename);
C++: VideoCapture::VideoCapture(int device);
```


功能：创建一个VideoCapture类的实例，如果传入对应的参数，可以直接打开视频文件或者要调用的摄像头。

参数:
filename – 打开的视频文件名。
device – 打开的视频捕获设备id ，如果只有一个摄像头可以填0，表示打开默认的摄像头。 



#### 2.::open

```
C++: bool VideoCapture::open(const string& filename);
C++: bool VideoCapture::open(int device);
```


功能：打开一个视频文件或者打开一个捕获视频的设备（也就是摄像头）

参数: 
filename – 打开的视频文件名。
device – 打开的视频捕获设备id ，如果只有一个摄像头可以填0，表示打开默认的摄像头。

通过对VideoCapture类的构造函数和open函数分析，可以发现opencv读入视频的方法一般有如下两种。比如读取当前目录下名为"dog.avi"的视频文件，那么这两种写法分别如下。

(1)先实例化再初始化：

```
VideoCapture capture;

capture.open("dog.avi");
```

(2)在实例化的同时进行初始化：

```
VideoCapture capture(;"dog.avi");
```



#### 3.::isOpened

C++: bool VideoCapture::isOpened();
功能：判断视频读取或者摄像头调用是否成功，成功则返回true。



#### 4.::release

C++: void VideoCapture::release();
功能：关闭视频文件或者摄像头。



#### 5.::grab

C++: bool VideoCapture::grab();
功能：从视频文件或捕获设备中抓取下一个帧，假如调用成功返回true。（细节请参考opencv文档说明）



#### 6.::retrieve

C++: bool VideoCapture::retrieve(Mat& image, int channel=0);
功能：解码并且返回刚刚抓取的视频帧，假如没有视频帧被捕获（相机没有连接或者视频文件中没有更多的帧）将返回false。



#### 7.::read

```c++
C++: VideoCapture& VideoCapture::operator>>(Mat& image);
C++: bool VideoCapture::read(Mat& image);
```


功能：该函数结合VideoCapture::grab()和VideoCapture::retrieve()其中之一被调用，用于捕获、解码和返回下一个视频帧这是一个最方便的函数对于读取视频文件或者捕获数据从解码和返回刚刚捕获的帧，假如没有视频帧被捕获（相机没有连接或者视频文件中没有更多的帧）将返回false。

从上面的API中我们会发现获取视频帧可以有多种方法 ：

```c++
// 方法一 
capture.read(frame); 

// 方法二 
capture.grab(); 

// 方法三
capture.retrieve(frame); 

// 方法四
capture >> frame;
```



#### 8.::get

C++: double VideoCapture::get(int propId);
功能：一个视频有很多属性，比如：帧率、总帧数、尺寸、格式等，VideoCapture的get方法可以获取这些属性。

参数：属性的ID。

属性的ID可以是下面的之一：

CV_CAP_PROP_POS_MSEC Current position of the video file in milliseconds or video capture timestamp.
CV_CAP_PROP_POS_FRAMES 0-based index of the frame to be decoded/captured next.
CV_CAP_PROP_POS_AVI_RATIO Relative position of the video file: 0 - start of the film, 1 - end of the film.
CV_CAP_PROP_FRAME_WIDTH Width of the frames in the video stream.
CV_CAP_PROP_FRAME_HEIGHT Height of the frames in the video stream.
CV_CAP_PROP_FPS Frame rate.
CV_CAP_PROP_FOURCC 4-character code of codec.
CV_CAP_PROP_FRAME_COUNT Number of frames in the video file.
CV_CAP_PROP_FORMAT Format of the Mat objects returned by retrieve() .
CV_CAP_PROP_MODE Backend-specific value indicating the current capture mode.
CV_CAP_PROP_BRIGHTNESS Brightness of the image (only for cameras).
CV_CAP_PROP_CONTRAST Contrast of the image (only for cameras).
CV_CAP_PROP_SATURATION Saturation of the image (only for cameras).
CV_CAP_PROP_HUE Hue of the image (only for cameras).
CV_CAP_PROP_GAIN Gain of the image (only for cameras).
CV_CAP_PROP_EXPOSURE Exposure (only for cameras).
CV_CAP_PROP_CONVERT_RGB Boolean flags indicating whether images should be converted to RGB.
CV_CAP_PROP_WHITE_BALANCE Currently not supported
CV_CAP_PROP_RECTIFICATION Rectification flag for stereo cameras (note: only supported by DC1394 v 2.x backend currently)
Note: 如果查询的视频属性是VideoCapture类不支持的，将会返回0。



#### 9.::set

C++: bool VideoCapture::set(int propertyId, double value)

功能：设置VideoCapture类的属性，设置成功返回ture,失败返回false。

参数：第一个是属性ID，第二个是该属性要设置的值。

属性ID如下：

CV_CAP_PROP_POS_MSEC Current position of the video file in milliseconds.
CV_CAP_PROP_POS_FRAMES 0-based index of the frame to be decoded/captured next.
CV_CAP_PROP_POS_AVI_RATIO Relative position of the video file: 0 - start of the film, 1 - end of the film.
CV_CAP_PROP_FRAME_WIDTH Width of the frames in the video stream.
CV_CAP_PROP_FRAME_HEIGHT Height of the frames in the video stream.
CV_CAP_PROP_FPS Frame rate.
CV_CAP_PROP_FOURCC 4-character code of codec.
CV_CAP_PROP_FRAME_COUNT Number of frames in the video file.
CV_CAP_PROP_FORMAT Format of the Mat objects returned by retrieve() .
CV_CAP_PROP_MODE Backend-specific value indicating the current capture mode.
CV_CAP_PROP_BRIGHTNESS Brightness of the image (only for cameras).
CV_CAP_PROP_CONTRAST Contrast of the image (only for cameras).
CV_CAP_PROP_SATURATION Saturation of the image (only for cameras).
CV_CAP_PROP_HUE Hue of the image (only for cameras).
CV_CAP_PROP_GAIN Gain of the image (only for cameras).
CV_CAP_PROP_EXPOSURE Exposure (only for cameras).
CV_CAP_PROP_CONVERT_RGB Boolean flags indicating whether images should be converted to RGB.
CV_CAP_PROP_WHITE_BALANCE Currently unsupported
CV_CAP_PROP_RECTIFICATION Rectification flag for stereo cameras (note: only supported by DC1394 v 2.x backend currently)
    至此，视频捕获类VideoCapture的API介绍完了，下面是一个应用示例：
```c
#include <iostream>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

int main(int argc,char* argv[])
{
    cv::VideoCapture capture(argv[1]);
    if(!capture.isOpened())

{
    std::cout<<"video not open."<<std::endl;
    return 1;
}
//获取当前视频帧率
double rate = capture.get(CV_CAP_PROP_FPS);
//当前视频帧
cv::Mat frame;
//每一帧之间的延时
//与视频的帧率相对应
int delay = 1000/rate;
bool stop(false);
while(!stop)
{
    if(!capture.read(frame))
    {
        std::cout<<"no video frame"<<std::endl;
        break;
     }
 
    //此处为添加对视频的每一帧的操作方法
    int frame_num = capture.get(CV_CAP_PROP_POS_FRAMES);
    std::cout<<"Frame Num : "<<frame_num<<std::endl;
    if(frame_num==20)
    {
        capture.set(CV_CAP_PROP_POS_FRAMES,10);
    }
 
    cv::imshow("video",frame);
    //引入延时
    //也可通过按键停止
    if(cv::waitKey(delay)>0)
    stop = true;
}

//关闭视频，手动调用析构函数（非必须）
capture.release();
return 0;

}
```

 

### *VideoWriter类*

VideoWriter类的一个常用构造方式如下：

```cpp
VideoWriter(const string& filename, int fourcc, double fps,Size frameSize, bool isColor=true);
```

其中fourcc代表了所使用的编码方式，如果输入-1，则会在运行时候弹出选择对话框，可以选择编码器：

![img](https://img-blog.csdn.net/20180612114010379?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzQyMTg5MzY4/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

filename 输出视频文件名。
 fourcc为 四个字符用来表示压缩帧的codec 例如：
CV_FOURCC('P','I','M','1') = MPEG-1 codec
CV_FOURCC('M','J','P','G') = motion-jpeg codec
CV_FOURCC('M', 'P', '4', '2') = MPEG-4.2 codec
CV_FOURCC('D', 'I', 'V', '3') = MPEG-4.3 codec
CV_FOURCC('D', 'I', 'V', 'X') = MPEG-4 codec
CV_FOURCC('U', '2', '6', '3') = H263 codec
CV_FOURCC('I', '2', '6', '3') = H263I codec
CV_FOURCC('F', 'L', 'V', '1') = FLV1 codec

若编码器代号为 -1，则运行时会弹出一个编码器选择框.

fps 被创建视频流的帧率。
frame_size 保存视频的宽和高。
isColor如果非零，编 码器将希望得到彩色帧并进行编码；否则，是灰度帧（只有在Windows下支持这个标志）。
备注：

生成文件占用空间最小的编码方式是MPEG-4.2 codec。在VideoWriter类的构造函数参数为CV_FOURCC('M', 'P', '4', '2') 。

最大的是MPEG-1 codec，对应在VideoWriter类的构造函数参数为CV_FOURCC('P','I','M','1') ，所占磁盘空间是前者的5.7倍。所以如果需要24小时全天候录制监控，可以优先使用MPEG-4.2的编解码方式。




## 图像知识

### 1.HLS图像

色相Hue

饱和度Saturation

亮度Lightness



### 2.图像处理基本步骤

取得图像数据 —— 将图像进行平滑处理 —— 进行边缘检测，阈值分析 —— 进行形态学的操作 —— 获取某些特征点 —— 分析数据



在OpenCV中，边缘检测的方法有以下几种： 
Sobel 
Scharr 
Laplace 
Canny 
其中前三种的边缘检测是带方向的



## ROS  OpenCV

### ROS：OpenCV的常用头文件解释

### 1.#include<cv_bridge/cv_bridge.h>
#include<cv_bridge/cv_bridge.h>
cv_bridge类：这个类中提供的API主要功能是将图像从sensor_msgs/Image类型转化成cv::Mat类型。

API：

#### cv_bidge::CvImage类：

cv_bridge中提供的数据结构，里面包括OpenCV中的cv::Mat类型的图像信息，图像编码方式，ROS头文件等等。要得到cv::Mat类型的 图像，只需要定义一个对象然后给出对象中的成员object.image即可，或者指针CvImagePtr，ptr->image。

#### cv_bridge::toCvCopy()方法：
参数是ROS下的sensor_msgs/ImageConstPtr，和图像压缩类型（例如：sensor_msgs::image_encodings::RGB8）。其功能是实 现复制图像信息这样，得到副本，这样我们可以从副本的CvImage中提取cv::Mat类型的图像进行处理。核心！

#### cv_bridge::toCvShare()方法：
参数同上，但是这个函数只是共享指针地址。ROS是不予许直接对图像格式的消息进行操作的。

#### 2.#include<image_transport/image_transport.h> 
image_transport类：图像传输类，其功能和ROS中的Publisher和Subscriber差不多，但是不同的是这个类在发布和订阅图片消息的同时还附带这摄像头的信息。相比较之下，   在ROS中传送图片信息，使用image_transport类要高效的多。同时，这个类可以以不同的图像压缩形式传输图像例如JPG/PNG等等，也可以添加插件定义传输数据的压缩模式。

API：

#### image_transport::ImageTransport类：
这个类成员可以定义某个话题的图像类型的发布器和订阅器（类似ros的句柄）。

#### image_transport::Publisher类：
这个类定义了image_transport中的发布器。

#### image_transport::Subsciber类：
这个类定义了image_transport中的订阅器。



## 实例

### 形态学边界提取

https://blog.csdn.net/dcrmg/article/details/52089538 

Opencv中函数getStructuringElement()可以生成形态学操作中用到的核，函数原型：

```c++
Mat getStructuringElement(int shape, //核的形状  0：矩形  1：十字交叉形  2： 椭圆 
						  Size ksize,//核大小
						  Point anchor=Point(-1,-1) //核中心位置，默认位于形状中心处
						  );
```

矩形、十字交叉形和椭圆形的区别可以通过输出矩阵对比一下：

```c++
#include "core/core.hpp"
#include "highgui/highgui.hpp"
#include "imgproc/imgproc.hpp"
#include <iostream>

using namespace cv;

int main(int argc,char *argv[])
{
	Mat elementRect,elementCross,elementEllipse;
	elementRect=getStructuringElement(MORPH_RECT,Size(3,3),Point(-1,-1));
	elementCross=getStructuringElement(MORPH_CROSS,Size(3,3),Point(-1,-1));
	elementEllipse=getStructuringElement(MORPH_ELLIPSE,Size(3,5),Point(-1,-1));

std::cout<<"3*3矩形核："<<std::endl<<elementRect<<std::endl;
std::cout<<"3*3十字叉形核："<<std::endl<<elementCross<<std::endl;
std::cout<<"3*3椭圆形核："<<std::endl<<elementEllipse<<std::endl;
system("pause");

}
```

输出：

![img](https://img-blog.csdn.net/20160801223052142?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

膨胀从字面上理解就知道是对图像胀大的操作，使图像中的物体的轮廓向外发散，体积变大；

腐蚀从字面上理解就知道是对图像缩小的操作，腐蚀了就意味着图像中物体的边界被侵蚀了，轮廓向内收缩，体积变小了。

要注意的是这里的膨胀和腐蚀的概念是针对图像中高亮区域而言的（二值图像中对应像素值255，白色），变大和缩小也是针对图像中高亮的部分。

所以对图像执行膨胀，对高亮区域是胀大，面积增大，对暗区域相当于是腐蚀，面积缩小。



下边的小程序利用形态学的膨胀和腐蚀操作提取边界。

```c++
#include "core/core.hpp"
#include "highgui/highgui.hpp"
#include "imgproc/imgproc.hpp"

using namespace cv;

int main(int argc,char *argv[])
{
	Mat image,imageGray,imageDilate,imageErode,imageBorder;
	image=imread(argv[1]);
	resize(image,image,Size(400,400));
	cvtColor(image,imageGray,CV_RGB2GRAY);

//enum { MORPH_RECT=0, MORPH_CROSS=1, MORPH_ELLIPSE=2 };
Mat element=getStructuringElement(1,Size(3,3),Point(-1,-1));
dilate(imageGray,imageDilate,element,Point(-1,-1));
erode(imageGray,imageErode,element,Point(-1,-1));
imageBorder=imageDilate-imageErode;
imshow("Source image",image);
imshow("Dilate",imageDilate);
imshow("Erode",imageErode);
imshow("Border",imageBorder);	
waitKey();

}
```

![img](https://img-blog.csdn.net/20160801224449511?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![img](https://img-blog.csdn.net/20160801224456168?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![img](https://img-blog.csdn.net/20160801224500930?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

![img](https://img-blog.csdn.net/20160801224505684?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)



### opencv3/C++基于颜色的目标跟踪

https://blog.csdn.net/akadiao/article/details/78881026



### 形态学变换 morphologyEx函数

https://blog.csdn.net/keen_zuxwang/article/details/72768092



### 仿射变换与透视变换

https://www.cnblogs.com/wyuzl/p/7745106.html

仿射变换(affine transform)与透视变换(perspective transform)在图像还原、图像局部变化处理方面有重要意义。通常，在2D平面中，仿射变换的应用较多，而在3D平面中，透视变换又有了自己的一席之地。两种变换原理相似，结果也类似，可针对不同的场合使用适当的变换。

仿射变换和透视变换的数学原理不需深究，其计算方法为坐标向量和变换矩阵的乘积，换言之就是矩阵运算。在应用层面，仿射变换是图像基于3个固定顶点的变换，如图所示：

![img](https://images2017.cnblogs.com/blog/960571/201710/960571-20171027203714820-8131839.png)

同理，透视变换是图像基于4个固定顶点的变换，如图所示：

![img](https://pic3.zhimg.com/v2-1cb9c5539fa00b0a06aa0a2a367f4d42_b.png)

```cpp
void warpAffine(InputArray src, OutputArray dst, InputArray M, Size dsize, int flags=INTER_LINEAR, int borderMode=BORDER_CONSTANT, const Scalar& borderValue=Scalar())
```

与

```cpp
void warpPerspective(InputArray src, OutputArray dst, InputArray M, Size dsize, int flags=INTER_LINEAR, int borderMode=BORDER_CONSTANT, const Scalar& borderValue=Scalar())
```

两种变换函数形式完全相同，因此以仿射变换函数为例：

```text
void warpAffine(InputArray src, OutputArray dst, InputArray M, Size dsize, int flags=INTER_LINEAR, int borderMode=BORDER_CONSTANT, const Scalar& borderValue=Scalar())
```

参数InputArray src：输入变换前图像

参数OutputArray dst：输出变换后图像，需要初始化一个空矩阵用来保存结果，不用设定矩阵尺寸

参数InputArray M：变换矩阵，用另一个函数getAffineTransform()计算

参数Size dsize：设置输出图像大小

参数int flags=INTER_LINEAR：设置插值方式，默认方式为线性插值

后两个参数不常用，在此不赘述

关于生成变换矩阵InputArray M的函数getAffineTransform()：

```text
Mat getAffineTransform(const Point2f* src, const Point2f* dst)
```

参数const Point2f* src：原图的三个固定顶点

参数const Point2f* dst：目标图像的三个固定顶点

返回值：Mat型变换矩阵，可直接用于warpAffine()函数

注意，顶点数组长度超过3个，则会自动以前3个为变换顶点；数组可用Point2f[]或Point2f*表示

示例代码如下：

```cpp
	//读取原图
	Mat I = imread("..//img.jpg");
	//设置空矩阵用于保存目标图像
	Mat dst;
	//设置原图变换顶点
	Point2f AffinePoints0[3] = { Point2f(100, 50), Point2f(100, 390), Point2f(600, 50) };
	//设置目标图像变换顶点
	Point2f AffinePoints1[3] = { Point2f(200, 100), Point2f(200, 330), Point2f(500, 50) };
	//计算变换矩阵
	Mat Trans = getAffineTransform(AffinePoints0, AffinePoints1);
	//矩阵仿射变换
	warpAffine(I, dst, Trans, Size(I.cols, I.rows));
	//分别显示变换先后图像进行对比
	imshow("src", I);
	imshow("dst", dst);
	waitKey();
```

同理，透视变换与仿射变换函数类似：

```text
void warpPerspective(InputArray src, OutputArray dst, InputArray M, Size dsize, int flags=INTER_LINEAR, int borderMode=BORDER_CONSTANT, const Scalar& borderValue=Scalar())
```

生成变换矩阵函数为：

```text
Mat getPerspectiveTransform(const Point2f* src, const Point2f* dst)
```

注意，透视变换顶点为4个

两种变换完整代码及结果比较：

```cpp
#include <iostream>
#include <opencv.hpp>
using namespace std;
using namespace cv;

Mat AffineTrans(Mat src, Point2f* scrPoints, Point2f* dstPoints)
{
	Mat dst;
	Mat Trans = getAffineTransform(scrPoints, dstPoints);
	warpAffine(src, dst, Trans, Size(src.cols, src.rows), CV_INTER_CUBIC);
	return dst;
}

Mat PerspectiveTrans(Mat src, Point2f* scrPoints, Point2f* dstPoints)
{
	Mat dst;
	Mat Trans = getPerspectiveTransform(scrPoints, dstPoints);
	warpPerspective(src, dst, Trans, Size(src.cols, src.rows), CV_INTER_CUBIC);
	return dst;
}

void main()
{
	Mat I = imread("..//img.jpg");	//700*438

	Point2f AffinePoints0[4] = { Point2f(100, 50), Point2f(100, 390), Point2f(600, 50), Point2f(600, 390) };
	Point2f AffinePoints1[4] = { Point2f(200, 100), Point2f(200, 330), Point2f(500, 50), Point2f(600, 390) };
	Mat dst_affine = AffineTrans(I, AffinePoints0, AffinePoints1);
	Mat dst_perspective = PerspectiveTrans(I, AffinePoints0, AffinePoints1);

	for (int i = 0; i < 4; i++)
	{
		circle(I, AffinePoints0[i], 2, Scalar(0, 0, 255), 2);
		circle(dst_affine, AffinePoints1[i], 2, Scalar(0, 0, 255), 2);
		circle(dst_perspective, AffinePoints1[i], 2, Scalar(0, 0, 255), 2);
	}

	imshow("origin", I);
	imshow("affine", dst_affine);
	imshow("perspective", dst_perspective);
	waitKey();
}
```

结果如图：

![960571-20171027203735336-1092886630](/home/chris/桌面/960571-20171027203735336-1092886630.png)