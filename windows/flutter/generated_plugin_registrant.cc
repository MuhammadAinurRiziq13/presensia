//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dio_interceptor_plus/dio_interceptor_plus_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>
#include <geolocator_windows/geolocator_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  DioInterceptorPlusPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DioInterceptorPlusPluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  GeolocatorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GeolocatorWindows"));
}
