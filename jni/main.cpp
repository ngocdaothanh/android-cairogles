#include <android/native_window.h>
#include <android/log.h>
#include <android_native_app_glue.h>

#include <EGL/egl.h>
#include <GLES/gl.h>

#include <cairo-gl.h>

#include <math.h>
#include <stdlib.h>

#define LOG_TAG "android-cairogles"
#define LOGI(...)   __android_log_print(ANDROID_LOG_INFO,  LOG_TAG, __VA_ARGS__)
#define LOGE(...)   __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

android_app* gApp;
bool         gAnimating;

EGLDisplay gEglDisplay;
EGLContext gEglContext;
EGLSurface gEglSurface;

cairo_device_t*  gCairoDevice;
cairo_surface_t* gWindowSurface;

static void drawFrame()
{
  static long tick = 0;
  tick++;

  cairo_t* cr = cairo_create(gWindowSurface);

  /* Normalize our canvas size to make our lives easier */
  int w = cairo_gl_surface_get_width(gWindowSurface);
  int h = cairo_gl_surface_get_height(gWindowSurface);
  cairo_scale(cr, w, h);

  /* Draw the big X */
  double position = (tick%30)*(1.0/30);
  cairo_set_source_rgba (cr, 0.5, 0.5, 0.5, 0.7);
  cairo_move_to (cr, 0.1, position);
  cairo_line_to (cr, 0.9, 1.0-position);
  cairo_move_to (cr, 0.9, position);
  cairo_line_to (cr, 0.1, 1.0-position);
  cairo_set_line_width (cr, 0.1);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND);
  cairo_stroke (cr);

  /* Draw three color squares */
  cairo_rectangle (cr, 0, 0,0.5, 0.5);
  cairo_set_source_rgba (cr, 1, 0, 0, 0.50);
  cairo_fill (cr);

  cairo_rectangle (cr, 0, 0.5, 0.5, 0.5);
  cairo_set_source_rgba (cr, 0, 1, 0, 0.50);
  cairo_fill (cr);

  cairo_rectangle (cr, 0.5, 0, 0.5, 0.5);
  cairo_set_source_rgba (cr, 0, 0, 1, 0.50);
  cairo_fill (cr);

  /* Draw a more complicated path */
  cairo_set_line_width (cr, 0.04);
  cairo_scale(cr, 0.5, 0.5);
  cairo_translate(cr, 0.5, 1.0);
  cairo_set_source_rgba (cr, 1.0, 0.2, 0.0, 0.5);
  cairo_move_to (cr, 0.25, 0.25);
  cairo_line_to (cr, 0.5, 0.375);
  cairo_rel_line_to (cr, 0.25, -0.125);
  cairo_arc (cr, 0.5, 0.5, 0.25 * sqrt(2), -0.25 * M_PI, 0.25 * M_PI);
  cairo_rel_curve_to (cr, -0.25, -0.125, -0.25, 0.125, -0.5, 0);
  cairo_close_path (cr);
  cairo_set_line_cap(cr, CAIRO_LINE_CAP_BUTT);
  cairo_stroke (cr);

  cairo_surface_flush(gWindowSurface);
  cairo_gl_surface_swapbuffers(gWindowSurface);
  //eglSwapBuffers(gEglDisplay, gEglSurface);
}

// Run on the game thread
static void* gameLoop(void* arg) {
  ANativeWindow* window = gApp->window;

  int windowWidth  = ANativeWindow_getWidth(window);
  int windowHeight = ANativeWindow_getHeight(window);
  LOGI("Window: %d x %d", windowWidth, windowHeight);

  const EGLint configAttribs[] = {
    EGL_SURFACE_TYPE,    EGL_WINDOW_BIT,      // window surface instead of pixmap or pbuffer surface
    EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,  // configure for opengl es 2
    EGL_STENCIL_SIZE,    8,
    EGL_RED_SIZE,        8,
    EGL_GREEN_SIZE,      8,
    EGL_BLUE_SIZE,       8,
    EGL_ALPHA_SIZE,      8,
    EGL_SAMPLES,         4, // 4x msaa
    EGL_SAMPLE_BUFFERS,  1, // must be 1
    EGL_NONE
  };

  const EGLint contextAttribs[] = {
    EGL_CONTEXT_CLIENT_VERSION, 2,
    EGL_NONE
  };

  const EGLint surfaceAttribs[] = {
    EGL_RENDER_BUFFER, EGL_BACK_BUFFER,
    EGL_NONE
  };

  gEglDisplay = eglGetDisplay(EGL_DEFAULT_DISPLAY);
  eglInitialize(gEglDisplay, NULL, NULL);

  EGLConfig config;
  EGLint numConfigs;
  if (!eglChooseConfig(gEglDisplay, configAttribs, &config, 1, &numConfigs)) {
    LOGI("Cannot choose config");
    exit(-1);
  }
  if (numConfigs != 1) {
    LOGI("Did not get exactly one config = %d\n", numConfigs);
    exit(-1);
  }

  EGLint format;
  eglGetConfigAttrib(gEglDisplay, config, EGL_NATIVE_VISUAL_ID, &format);
  ANativeWindow_setBuffersGeometry(window, 0, 0, format);

  gEglSurface = eglCreateWindowSurface(gEglDisplay, config, window, surfaceAttribs);
  //gEglSurface = eglCreateWindowSurface(gEglDisplay, config, window, NULL);
  gEglContext = eglCreateContext(gEglDisplay, config, EGL_NO_CONTEXT, contextAttribs);

  if (!eglMakeCurrent(gEglDisplay, gEglSurface, gEglSurface, gEglContext)) {
    LOGI("Unable to eglMakeCurrent");
    exit(-1);
  }

  putenv("CAIRO_GL_COMPOSITOR=msaa");
  gCairoDevice   = cairo_egl_device_create(gEglDisplay, gEglContext);
  gWindowSurface = cairo_gl_surface_create_for_egl(gCairoDevice, gEglSurface, windowWidth, windowHeight);
  cairo_gl_device_set_thread_aware(gCairoDevice, false);

  int surfaceWidth  = cairo_gl_surface_get_width(gWindowSurface);
  int surfaceHeight = cairo_gl_surface_get_height(gWindowSurface);
  LOGI("Surface: %d x %d", surfaceWidth, surfaceHeight);

  if (!eglMakeCurrent(gEglDisplay, gEglSurface, gEglSurface, gEglContext)) {
    LOGI("Unable to eglMakeCurrent");
    exit(-1);
  }

  glViewport(0, 0, windowWidth, windowHeight);
  while (1) {
    if (gApp->window != NULL && gAnimating) {
      drawFrame();

      // TODO: throttle FPS to reduce CPU consumption
    }
  }

  return NULL;
}

/**
 * Process the next main command.
 */
static void engine_handle_cmd(struct android_app* app, int32_t cmd) {
  switch (cmd) {
    case APP_CMD_SAVE_STATE:
      // The system has asked us to save our current state.  Do so.
      break;

    case APP_CMD_INIT_WINDOW:
      // The window is being shown, get it ready.
      if (app->window != NULL) {
        //gameLoop(NULL);

        pthread_t t;
        pthread_create(&t, NULL, &gameLoop, NULL);
      }
      break;

    case APP_CMD_TERM_WINDOW:
      // The window is being hidden or closed, clean it up.
      //engine_term_display(engine);
      break;

    case APP_CMD_GAINED_FOCUS:
      break;

    case APP_CMD_LOST_FOCUS:
      break;
  }
}

/**
 * Process the next input event.
 */
static int32_t engine_handle_input(android_app* app, AInputEvent* event) {
  return 0;
}

/**
 * This is the main entry point of a native application that is using
 * android_native_app_glue.  It runs in its own thread, with its own
 * event loop for receiving input events and doing other things.
 */
void android_main(android_app* app) {
  gApp = app;

  // Make sure glue isn't stripped.
  app_dummy();

  app->onAppCmd = engine_handle_cmd;
  app->onInputEvent = engine_handle_input;

  if (app->savedState != NULL) {
    // We are starting with a previous saved state; restore from it.
  }

  gAnimating = true;
  while (1) {
    // Read all pending events.
    int ident;
    int events;
    struct android_poll_source* source;

    // If not animating, we will block forever waiting for events.
    // If animating, we loop until all events are read, then continue
    // to draw the next frame of animation.
    while ((ident=ALooper_pollAll(gAnimating ? 0 : -1, NULL, &events, (void**)&source)) >= 0) {
      // Process this event.
      if (source != NULL) {
        source->process(app, source);
      }

      // Check if we are exiting.
      if (app->destroyRequested != 0) {
        gAnimating = false;
        return;
      }
    }
  }
}
