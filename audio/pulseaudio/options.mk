# $NetBSD: options.mk,v 1.9 2018/07/25 12:15:59 adam Exp $

PKG_OPTIONS_VAR=	PKG_OPTIONS.pulseaudio
PKG_SUPPORTED_OPTIONS=	avahi fftw gsettings x11
PKG_SUGGESTED_OPTIONS=	avahi x11
PLIST_VARS+=		${PKG_SUPPORTED_OPTIONS}

.include "../../mk/bsd.options.mk"

.if !empty(PKG_OPTIONS:Mavahi)
.include "../../net/avahi/buildlink3.mk"
PLIST.avahi=		yes
.else
CONFIGURE_ARGS+=	--disable-avahi
.endif

.if !empty(PKG_OPTIONS:Mgsettings)
PLIST.gsettings=	yes
CONFIGURE_ARGS+=	--enable-gsettings
.else
CONFIGURE_ARGS+=	--disable-gsettings
.endif

.if !empty(PKG_OPTIONS:Mfftw)
CONFIGURE_ARGS+=	--with-fftw
PLIST.fftw=		yes

.include "../../lang/python/pyversion.mk"
# manually replace since check_interpreter detests /usr/bin/env
REPLACE_INTERPRETER+=	pulse_py
REPLACE.pulse_py.old=	.*/usr/bin/env python[^ ]*
REPLACE.pulse_py.new=	${PYTHONBIN}
REPLACE_FILES.pulse_py=	src/utils/qpaeq

.include "../../math/fftwf/buildlink3.mk"
.include "../../sysutils/py-dbus/buildlink3.mk"
.include "../../x11/py-qt4/buildlink3.mk"
.include "../../x11/py-sip/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-fftw
.endif

.if !empty(PKG_OPTIONS:Mx11)
.include "../../x11/libICE/buildlink3.mk"
.include "../../x11/libSM/buildlink3.mk"
.include "../../x11/libX11/buildlink3.mk"
.include "../../x11/libXtst/buildlink3.mk"
.include "../../x11/xorgproto/buildlink3.mk"
PLIST.x11=		yes
.else
CONFIGURE_ARGS+=	--disable-x11
.endif
