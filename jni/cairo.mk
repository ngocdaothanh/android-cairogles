LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LIBCAIRO_SRC = \
         cairogles/src/cairo-analysis-surface.c            \
         cairogles/src/cairo-arc.c                         \
         cairogles/src/cairo-array.c                       \
         cairogles/src/cairo-atomic.c                      \
         cairogles/src/cairo-base64-stream.c               \
         cairogles/src/cairo-base85-stream.c               \
         cairogles/src/cairo-bentley-ottmann.c             \
         cairogles/src/cairo-bentley-ottmann-rectangular.c \
         cairogles/src/cairo-bentley-ottmann-rectilinear.c \
         cairogles/src/cairo-bentley-ottmann.c             \
         cairogles/src/cairo-botor-scan-converter.c        \
         cairogles/src/cairo-boxes-intersect.c             \
         cairogles/src/cairo-boxes.c                       \
         cairogles/src/cairo.c                             \
         cairogles/src/cairo-cache.c                       \
         cairogles/src/cairo-cff-subset.c                  \
         cairogles/src/cairo-clip-boxes.c                  \
         cairogles/src/cairo-clip-polygon.c                \
         cairogles/src/cairo-clip-region.c                 \
         cairogles/src/cairo-clip-surface.c                \
         cairogles/src/cairo-clip-tor-scan-converter.c     \
         cairogles/src/cairo-clip.c                        \
         cairogles/src/cairo-color.c                       \
         cairogles/src/cairo-composite-rectangles.c        \
         cairogles/src/cairo-compositor.c                  \
         cairogles/src/cairo-contour.c                     \
         cairogles/src/cairo-damage.c                      \
         cairogles/src/cairo-debug.c                       \
         cairogles/src/cairo-default-context.c             \
         cairogles/src/cairo-deflate-stream.c              \
         cairogles/src/cairo-device.c                      \
         cairogles/src/cairo-error.c                       \
         cairogles/src/cairo-fallback-compositor.c         \
         cairogles/src/cairo-fixed.c                       \
         cairogles/src/cairo-font-face-twin-data.c         \
         cairogles/src/cairo-font-face-twin.c              \
         cairogles/src/cairo-font-face.c                   \
         cairogles/src/cairo-font-options.c                \
         cairogles/src/cairo-freed-pool.c                  \
         cairogles/src/cairo-freelist.c                    \
         cairogles/src/cairo-ft-font.c                     \
         cairogles/src/cairo-gstate.c                      \
         cairogles/src/cairo-egl-context.c                 \
         cairogles/src/cairo-gl-composite.c                \
         cairogles/src/cairo-gl-info.c                     \
         cairogles/src/cairo-gl-shaders.c                  \
         cairogles/src/cairo-gl-surface.c                  \
         cairogles/src/cairo-gl-device.c                   \
         cairogles/src/cairo-gl-glyphs.c                   \
         cairogles/src/cairo-gl-hairline-stroke.c          \
         cairogles/src/cairo-gl-msaa-compositor.c          \
         cairogles/src/cairo-gl-source.c                   \
         cairogles/src/cairo-gl-traps-compositor.c         \
         cairogles/src/cairo-gl-operand.c                  \
         cairogles/src/cairo-gl-spans-compositor.c         \
         cairogles/src/cairo-gl-dispatch.c                 \
         cairogles/src/cairo-gl-gradient.c                 \
         cairogles/src/cairo-hash.c                        \
         cairogles/src/cairo-hull.c                        \
         cairogles/src/cairo-image-compositor.c            \
         cairogles/src/cairo-image-info.c                  \
         cairogles/src/cairo-image-source.c                \
         cairogles/src/cairo-image-surface.c               \
         cairogles/src/cairo-lzw.c                         \
         cairogles/src/cairo-mask-compositor.c             \
         cairogles/src/cairo-matrix.c                      \
         cairogles/src/cairo-mesh-pattern-rasterizer.c     \
         cairogles/src/cairo-misc.c                        \
         cairogles/src/cairo-mono-scan-converter.c         \
         cairogles/src/cairo-mutex.c                       \
         cairogles/src/cairo-no-compositor.c               \
         cairogles/src/cairo-observer.c                    \
         cairogles/src/cairo-output-stream.c               \
         cairogles/src/cairo-paginated-surface.c           \
         cairogles/src/cairo-path-bounds.c                 \
         cairogles/src/cairo-path-fill.c                   \
         cairogles/src/cairo-path-fixed.c                  \
         cairogles/src/cairo-path-in-fill.c                \
         cairogles/src/cairo-path-stroke-boxes.c           \
         cairogles/src/cairo-path-stroke-polygon.c         \
         cairogles/src/cairo-path-stroke-traps.c           \
         cairogles/src/cairo-path-stroke-tristrip.c        \
         cairogles/src/cairo-path-stroke.c                 \
         cairogles/src/cairo-path.c                        \
         cairogles/src/cairo-pattern.c                     \
         cairogles/src/cairo-pen.c                         \
         cairogles/src/cairo-png.c                         \
         cairogles/src/cairo-polygon-intersect.c           \
         cairogles/src/cairo-polygon-reduce.c              \
         cairogles/src/cairo-polygon.c                     \
         cairogles/src/cairo-raster-source-pattern.c       \
         cairogles/src/cairo-recording-surface.c           \
         cairogles/src/cairo-rectangle.c                   \
         cairogles/src/cairo-rectangular-scan-converter.c  \
         cairogles/src/cairo-region.c                      \
         cairogles/src/cairo-rtree.c                       \
         cairogles/src/cairo-scaled-font-subsets.c         \
         cairogles/src/cairo-scaled-font.c                 \
         cairogles/src/cairo-shape-mask-compositor.c       \
         cairogles/src/cairo-slope.c                       \
         cairogles/src/cairo-spans-compositor.c            \
         cairogles/src/cairo-spans.c                       \
         cairogles/src/cairo-spline.c                      \
         cairogles/src/cairo-stroke-dash.c                 \
         cairogles/src/cairo-stroke-style.c                \
         cairogles/src/cairo-surface-clipper.c             \
         cairogles/src/cairo-surface-fallback.c            \
         cairogles/src/cairo-surface-observer.c            \
         cairogles/src/cairo-surface-offset.c              \
         cairogles/src/cairo-surface-snapshot.c            \
         cairogles/src/cairo-surface-subsurface.c          \
         cairogles/src/cairo-surface-wrapper.c             \
         cairogles/src/cairo-surface.c                     \
         cairogles/src/cairo-tee-surface.c                 \
         cairogles/src/cairo-time.c                        \
         cairogles/src/cairo-tor-scan-converter.c          \
         cairogles/src/cairo-tor22-scan-converter.c        \
         cairogles/src/cairo-toy-font-face.c               \
         cairogles/src/cairo-traps-compositor.c            \
         cairogles/src/cairo-traps.c                       \
         cairogles/src/cairo-tristrip.c                    \
         cairogles/src/cairo-truetype-subset.c             \
         cairogles/src/cairo-type1-fallback.c              \
         cairogles/src/cairo-type1-glyph-names.c           \
         cairogles/src/cairo-type1-subset.c                \
         cairogles/src/cairo-type3-glyph-surface.c         \
         cairogles/src/cairo-unicode.c                     \
         cairogles/src/cairo-user-font.c                   \
         cairogles/src/cairo-version.c                     \
         cairogles/src/cairo-wideint.c

LIBCAIRO_CFLAGS:=                                                            \
    -DPACKAGE_VERSION="\"android-cairogles\""                                \
    -DPACKAGE_BUGREPORT="\"https://github.com/SRA-SiliconValley/cairogles\"" \
    -DCAIRO_NO_MUTEX=1                                                       \
    -DHAVE_STDINT_H                                                          \
    -DHAVE_UINT64_T                                                          \
    -DCAIRO_HAS_GLESV2_SURFACE=1                                             \
    -DCAIRO_HAS_EGL_FUNCTIONS=1                                              \
    -Ijni/cairogles -Ijni/cairogles/src -Ijni/cairo-extra                    \
    -include "cairo-version.h"                                               \
    -Wno-missing-field-initializers -Wno-attributes

LOCAL_MODULE    := libcairogles
LOCAL_CFLAGS    := $(LIBCAIRO_CFLAGS)
LOCAL_LDFLAGS   := -lz
LOCAL_SRC_FILES := $(LIBCAIRO_SRC)
LOCAL_STATIC_LIBRARIES := cpufeatures

include $(BUILD_STATIC_LIBRARY)
