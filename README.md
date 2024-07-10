# pageupx_printer

A new Flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Prevent Default Android Behavior When Scanning NFC
Android has a default behavior when scanning NFC tags, especially when they contain a URL. It will automatically open the URL in the phone's default browser. We do not necessarily want this behavior to occur in our application. Therefore, we will see how to disable it:

1) Modify the AndroidManifest.xml file
```xml
<activity ... >
   ...
   <intent-filter>
      <action android:name="android.nfc.action.TECH_DISCOVERED" />
      <category android:name="android.intent.category.DEFAULT" />
   </intent-filter>
   <meta-data
      android:name="android.nfc.action.TECH_DISCOVERED"
      android:resource="@xml/nfc_tech_filter"/>
</activity>
```

2) In the android resource folder, create a file named  `nfc_tech_filter.xml` (res/xml/nfc_tech_filter.xml)
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:xliff="urn:oasis:names:tc:xliff:document:1.2">
    <tech-list>
        <tech>android.nfc.tech.IsoDep</tech>
        <tech>android.nfc.tech.NfcA</tech>
        <tech>android.nfc.tech.NfcB</tech>
        <tech>android.nfc.tech.NfcF</tech>
        <tech>android.nfc.tech.NfcV</tech>
        <tech>android.nfc.tech.Ndef</tech>
        <tech>android.nfc.tech.NdefFormatable</tech>
        <tech>android.nfc.tech.MifareClassic</tech>
        <tech>android.nfc.tech.MifareUltralight</tech>
    </tech-list>
</resources>
```


Next, you need to modify two methods in our MainActivity:
```kotlin
override fun onResume() {
    super.onResume()
    val adapter: NfcAdapter = NfcAdapter.getDefaultAdapter(this)
    val pendingIntent: PendingIntent = PendingIntent.getActivity(
            this, 0, Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 0)
    adapter.enableForegroundDispatch(this, pendingIntent, null, null)
}
override fun onPause() {
    super.onPause()
    val adapter: NfcAdapter? = NfcAdapter.getDefaultAdapter(this)
    adapter?.disableForegroundDispatch(this)
}
```

Sources : 
https://github.com/nfcim/flutter_nfc_kit/issues/17