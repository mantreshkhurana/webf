package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    flutterEngine.getPlugins().add(new io.flutter.plugins.connectivity.ConnectivityPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.deviceinfo.DeviceInfoPlugin());
    flutterEngine.getPlugins().add(new com.taobao.kraken.KrakenSDKPlugin());
      xyz.luan.audioplayers.AudioplayersPlugin.registerWith(shimPluginRegistry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.camera.CameraPlugin());
    flutterEngine.getPlugins().add(new com.lyokone.location.LocationPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.videoplayer.VideoPlayerPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.webviewflutter.WebViewFlutterPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
  }
}