$NetBSD: patch-salt_utils_network.py,v 1.3 2016/09/19 13:34:37 jperkin Exp $

Use sockstat(1) on NetBSD

--- salt/utils/network.py.orig	2016-08-26 18:55:37.000000000 +0000
+++ salt/utils/network.py
@@ -1086,6 +1086,8 @@ def _remotes_on(port, which_end):
             return _sunos_remotes_on(port, which_end)
         if salt.utils.is_freebsd():
             return _freebsd_remotes_on(port, which_end)
+        if salt.utils.is_netbsd():
+            return _netbsd_remotes_on(port, which_end)
         if salt.utils.is_openbsd():
             return _openbsd_remotes_on(port, which_end)
         if salt.utils.is_windows():
@@ -1208,6 +1210,65 @@ def _freebsd_remotes_on(port, which_end)
     return remotes
 
 
+def _netbsd_remotes_on(port, which_end):
+    '''
+    Returns set of ipv4 host addresses of remote established connections
+    on local tcp port port.
+
+    Parses output of shell 'sockstat' (FreeBSD)
+    to get connections
+
+    $ sudo sockstat -4
+    USER    COMMAND     PID     FD  PROTO  LOCAL ADDRESS    FOREIGN ADDRESS
+    root    python2.7   1456    29  tcp4   *.4505           *.*
+    root    python2.7   1445    17  tcp4   *.4506           *.*
+    root    python2.7   1294    14  tcp4   127.0.0.1.11813  127.0.0.1.4505
+    root    python2.7   1294    41  tcp4   127.0.0.1.61115  127.0.0.1.4506
+
+    $ sudo sockstat -4 -c -p 4506
+    USER    COMMAND     PID     FD  PROTO  LOCAL ADDRESS    FOREIGN ADDRESS
+    root    python2.7   1294    41  tcp4   127.0.0.1.61115  127.0.0.1.4506
+    '''
+
+    port = int(port)
+    remotes = set()
+
+    try:
+        cmd = shlex.split('sockstat -4 -c -p {0}'.format(port))
+        data = subprocess.check_output(cmd)  # pylint: disable=minimum-python-version
+    except subprocess.CalledProcessError as ex:
+        log.error('Failed "sockstat" with returncode = {0}'.format(ex.returncode))
+        raise
+
+    lines = salt.utils.to_str(data).split('\n')
+
+    for line in lines:
+        chunks = line.split()
+        if not chunks:
+            continue
+        # ['root', 'python2.7', '1456', '37', 'tcp4',
+        #  '127.0.0.1.4505-', '127.0.0.1.55703']
+        #print chunks
+        if 'COMMAND' in chunks[1]:
+            continue  # ignore header
+        if len(chunks) < 2:
+            continue
+        local = chunks[5].split('.')
+        lport = local.pop()
+        lhost = '.'.join(local)
+        remote = chunks[6].split('.')
+        rport = remote.pop()
+        rhost = '.'.join(remote)
+        if which_end == 'local' and int(lport) != port:  # ignore if local port not port
+            continue
+        if which_end == 'remote' and int(rport) != port:  # ignore if remote port not port
+            continue
+
+        remotes.add(rhost)
+
+    return remotes
+
+
 def _openbsd_remotes_on(port, which_end):
     '''
     OpenBSD specific helper function.
