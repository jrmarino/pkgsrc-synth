$NetBSD: patch-netwerk_wifi_nsWifiScannerFreeBSD.cpp,v 1.1 2013/11/03 04:52:00 ryoon Exp $

--- netwerk/wifi/nsWifiScannerFreeBSD.cpp.orig	2013-09-14 15:17:47.000000000 +0000
+++ netwerk/wifi/nsWifiScannerFreeBSD.cpp
@@ -0,0 +1,172 @@
+/* This Source Code Form is subject to the terms of the Mozilla Public
+ * License, v. 2.0. If a copy of the MPL was not distributed with this
+ * file, You can obtain one at http://mozilla.org/MPL/2.0/. */
+
+// Developed by J.R. Oldroyd <fbsd@opal.com>, December 2012.
+
+// For FreeBSD we use the getifaddrs(3) to obtain the list of interfaces
+// and then check for those with an 802.11 media type and able to return
+// a list of stations. This is similar to ifconfig(8).
+
+#include <sys/types.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <net/if.h>
+#include <net/if_media.h>
+#include <net80211/ieee80211_ioctl.h>
+
+#include <ifaddrs.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "nsWifiAccessPoint.h"
+
+using namespace mozilla;
+
+static nsresult
+FreeBSDGetAccessPointData(nsCOMArray<nsWifiAccessPoint> &accessPoints)
+{
+  bool res = false;
+  char *dupn = NULL;
+  struct ifaddrs *ifal, *ifa;
+  unsigned len;
+
+  // get list of interfaces
+  if (getifaddrs(&ifal) < 0)
+    return NS_ERROR_FAILURE;
+
+  accessPoints.Clear();
+
+  // loop through the interfaces
+  for (ifa = ifal; ifa; ifa = ifa->ifa_next) {
+    int s;
+    struct ifreq ifr;
+    struct ifmediareq ifmr;
+    struct ieee80211req i802r;
+    char iscanbuf[32*1024], *vsr;
+
+    memset(&ifr, 0, sizeof(ifr));
+
+    // list can contain duplicates, so ignore those
+    if (dupn != NULL && strcmp(dupn, ifa->ifa_name) == 0)
+      continue;
+    dupn = ifa->ifa_name;
+
+    // store interface name in socket structure
+    strncpy(ifr.ifr_name, ifa->ifa_name, sizeof(ifr.ifr_name));
+    ifr.ifr_addr.sa_family = AF_LOCAL;
+
+    // open socket to interface
+    if ((s = socket(ifr.ifr_addr.sa_family, SOCK_DGRAM, 0)) < 0)
+      continue;
+
+    // clear interface media structure
+    (void) memset(&ifmr, 0, sizeof(ifmr));
+    (void) strncpy(ifmr.ifm_name, ifa->ifa_name, sizeof(ifmr.ifm_name));
+
+    // get interface media information
+    if (ioctl(s, SIOCGIFMEDIA, (caddr_t)&ifmr) < 0) {
+      close(s);
+      continue;
+    }
+
+    // check interface is a WiFi interface
+    if (IFM_TYPE(ifmr.ifm_active) != IFM_IEEE80211) {
+      close(s);
+      continue;
+    }
+
+    // perform WiFi scan
+    (void) memset(&i802r, 0, sizeof(i802r));
+    (void) strncpy(i802r.i_name, ifa->ifa_name, sizeof(i802r.i_name));
+    i802r.i_type = IEEE80211_IOC_SCAN_RESULTS;
+    i802r.i_data = iscanbuf;
+    i802r.i_len = sizeof(iscanbuf);
+    if (ioctl(s, SIOCG80211, &i802r) < 0) {
+      close(s);
+      continue;
+    }
+
+    // close socket
+    close(s);
+
+    // loop through WiFi networks and build geoloc-lookup structure
+    vsr = (char *) i802r.i_data;
+    len = i802r.i_len;
+    while (len >= sizeof(struct ieee80211req_scan_result)) {
+      struct ieee80211req_scan_result *isr;
+      char *id;
+      int idlen;
+      char ssid[IEEE80211_NWID_LEN+1];
+      nsWifiAccessPoint *ap;
+
+      isr = (struct ieee80211req_scan_result *) vsr;
+
+      // determine size of this entry
+      if (isr->isr_meshid_len) {
+        id = vsr + isr->isr_ie_off + isr->isr_ssid_len;
+        idlen = isr->isr_meshid_len;
+      }
+      else {
+        id = vsr + isr->isr_ie_off;
+        idlen = isr->isr_ssid_len;
+      }
+
+      // copy network data
+      strncpy(ssid, id, idlen);
+      ssid[idlen] = '\0';
+      ap = new nsWifiAccessPoint();
+      ap->setSSID(ssid, strlen(ssid));
+      ap->setMac(isr->isr_bssid);
+      ap->setSignal(isr->isr_rssi);
+      accessPoints.AppendObject(ap);
+      res = true;
+
+      // log the data
+      LOG(( "FreeBSD access point: "
+            "SSID: %s, MAC: %02x-%02x-%02x-%02x-%02x-%02x, "
+            "Strength: %d, Channel: %dMHz\n",
+            ssid, isr->isr_bssid[0], isr->isr_bssid[1], isr->isr_bssid[2],
+            isr->isr_bssid[3], isr->isr_bssid[4], isr->isr_bssid[5],
+            isr->isr_rssi, isr->isr_freq));
+
+      // increment pointers
+      len -= isr->isr_len;
+      vsr += isr->isr_len;
+    }
+  }
+
+  freeifaddrs(ifal);
+
+  return res ? NS_OK : NS_ERROR_FAILURE;
+}
+
+nsresult
+nsWifiMonitor::DoScan()
+{
+  // Regularly get the access point data.
+
+  nsCOMArray<nsWifiAccessPoint> lastAccessPoints;
+  nsCOMArray<nsWifiAccessPoint> accessPoints;
+
+  do {
+    nsresult rv = FreeBSDGetAccessPointData(accessPoints);
+    if (NS_FAILED(rv))
+      return rv;
+
+    bool accessPointsChanged = !AccessPointsEqual(accessPoints, lastAccessPoints);
+    ReplaceArray(lastAccessPoints, accessPoints);
+
+    rv = CallWifiListeners(lastAccessPoints, accessPointsChanged);
+    NS_ENSURE_SUCCESS(rv, rv);
+
+    // wait for some reasonable amount of time. pref?
+    LOG(("waiting on monitor\n"));
+
+    ReentrantMonitorAutoEnter mon(mReentrantMonitor);
+    mon.Wait(PR_SecondsToInterval(60));
+  }
+  while (mKeepGoing);
+
+  return NS_OK;
+}
