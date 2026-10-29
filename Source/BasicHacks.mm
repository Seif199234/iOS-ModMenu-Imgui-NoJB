#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#include "dobby.h"

// الصورة اللي هنعرضها (رخصة القيادة)
static UIImage *fakeImage = nil;

// دالة الهوك اللي هتعترض فريمات الكاميرا
static void (*orig_captureOutput)(id self, SEL _cmd, AVCaptureOutput *output, CMSampleBufferRef sampleBuffer, AVCaptureConnection *connection);

void new_captureOutput(id self, SEL _cmd, AVCaptureOutput *output, CMSampleBufferRef sampleBuffer, AVCaptureConnection *connection) {
    if (fakeImage) {
        // تحويل الصورة لـ PixelBuffer
        CGImageRef cgImage = fakeImage.CGImage;
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);
        
        CVPixelBufferRef pixelBuffer = NULL;
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, NULL, &pixelBuffer);
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        void *pxdata = CVPixelBufferGetBaseAddress(pixelBuffer);
        
        CGContextRef context = CGBitmapContextCreate(pxdata, width, height, 8, 4 * width, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
        
        CGContextRelease(context);
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        // هنا بنبعت الفريم المزيف بدل الحقيقي (محاكاة للبافر)
        // للتبسيط، الكود ده بيوقف البث الحقيقي وبيحاول يبعت الصورة
        return; 
    }
    
    // لو مفيش صورة، كمل بالكاميرا الأصلية
    orig_captureOutput(self, _cmd, output, sampleBuffer, connection);
}

// دالة التشغيل الأولى
__attribute__((constructor))
static void init() {
    NSLog(@"Potato Virtual Camera Injected!");
    
    // تحميل الصورة من فولدر التطبيق
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"license_photo" ofType:@"png"];
    if (imagePath) {
        fakeImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    if (fakeImage) {
        // عمل Hook لدالة استقبال الفريمات
        Class captureOutputClass = NSClassFromString(@"AVCaptureVideoDataOutput");
        SEL selector = NSSelectorFromString(@"setSampleBufferDelegate:queue:");
        
        if (captureOutputClass && [captureOutputClass instancesRespondToSelector:selector]) {
            Method method = class_getInstanceMethod(captureOutputClass, selector);
            if (method) {
                void *address = (void *)method_getImplementation(method);
                DobbyHook(address, (void *)new_captureOutput, (void **)&orig_captureOutput);
            }
        }
    }
}
