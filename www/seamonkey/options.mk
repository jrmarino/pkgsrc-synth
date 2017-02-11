# $NetBSD: options.mk,v 1.35 2017/02/11 12:12:25 abs Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.seamonkey

PKG_OPTIONS_REQUIRED_GROUPS=	gtk
PKG_OPTIONS_GROUP.gtk=		gtk2 gtk3
PKG_SUPPORTED_OPTIONS=	alsa dbus debug mozilla-jemalloc
PKG_SUPPORTED_OPTIONS+=	mozilla-lightning webrtc mozilla-chatzilla pulseaudio

PLIST_VARS+=	debug gnome jemalloc

PKG_SUGGESTED_OPTIONS=	gtk2

PKG_SUGGESTED_OPTIONS.Linux+=	mozilla-jemalloc
PKG_SUGGESTED_OPTIONS.SunOS+=	mozilla-jemalloc

# On NetBSD/amd64 6.99.21 libxul.so is invalid when --enable-webrtc is set.
.if (${OPSYS} == "FreeBSD") || (${OPSYS} == "Linux") || (${OPSYS} == "OpenBSD")
PKG_SUGGESTED_OPTIONS+=	webrtc
.endif

.if ${OPSYS} == "Linux"
PKG_SUGGESTED_OPTIONS+=	alsa dbus
.else
PKG_SUGGESTED_OPTIONS+=	dbus pulseaudio
.endif

.include "../../mk/bsd.options.mk"

PLIST_VARS+=		gtk3
.if !empty(PKG_OPTIONS:Mgtk2)
CONFIGURE_ARGS+=	--enable-default-toolkit=cairo-gtk2
.include "../../x11/gtk2/buildlink3.mk"
PLIST.gtk3=		no
.endif

.if !empty(PKG_OPTIONS:Mgtk3)
CONFIGURE_ARGS+=	--enable-default-toolkit=cairo-gtk3
.include "../../x11/gtk3/buildlink3.mk"
PLIST.gtk3=		yes
.endif

.if !empty(PKG_OPTIONS:Malsa)
CONFIGURE_ARGS+=	--enable-alsa
.include "../../audio/alsa-lib/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--disable-alsa
.endif

.if !empty(PKG_OPTIONS:Mdbus)
.include "../../sysutils/dbus-glib/buildlink3.mk"
CONFIGURE_ARGS+=        --enable-dbus
.else
CONFIGURE_ARGS+=        --disable-dbus
.endif

.if !empty(PKG_OPTIONS:Mmozilla-chatzilla)
PLIST_SRC+=		PLIST.chatzilla
CONFIGURE_ARGS+=	--enable-extensions=default,irc
XPI_FILES+=		${WRKSRC}/${OBJDIR}/dist/xpi-stage/chatzilla*.xpi
XPI_FILES+=		${WRKSRC}/${OBJDIR}/dist/xpi-stage/quitter*.xpi
.endif

.if !empty(PKG_OPTIONS:Mmozilla-jemalloc)
PLIST.jemalloc=		yes
CONFIGURE_ARGS+=	--enable-jemalloc
.else
CONFIGURE_ARGS+=	--disable-jemalloc
.endif

.if !empty(PKG_OPTIONS:Mdebug)
CONFIGURE_ARGS+=	--enable-debug --enable-debug-symbols
CONFIGURE_ARGS+=	--disable-install-strip
PLIST.debug=		yes
.else
CONFIGURE_ARGS+=	--disable-debug --disable-debug-symbols
CONFIGURE_ARGS+=	--enable-install-strip
.endif

.if !empty(PKG_OPTIONS:Mmozilla-lightning)
CONFIGURE_ARGS+=	--enable-calendar
PLIST_SRC+=		PLIST.lightning
XPI_FILES+=		${WRKSRC}/${OBJDIR}/dist/xpi-stage/gdata-provider*.xpi
XPI_FILES+=		${WRKSRC}/${OBJDIR}/dist/xpi-stage/lightning*.xpi
XPI_FILES+=		${WRKSRC}/${OBJDIR}/dist/xpi-stage/quitter*.xpi
.else
CONFIGURE_ARGS+=	--disable-calendar
.endif

.if !empty(PKG_OPTIONS:Mpulseaudio)
.include "../../audio/pulseaudio/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-pulseaudio
.else
CONFIGURE_ARGS+=	--disable-pulseaudio
.endif

PLIST_VARS+=            webrtc
.if !empty(PKG_OPTIONS:Mwebrtc)
.include "../../graphics/libv4l/buildlink3.mk"
CONFIGURE_ARGS+=	--enable-webrtc
.else
CONFIGURE_ARGS+=	--disable-webrtc
.endif
