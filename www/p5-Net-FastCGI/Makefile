# $NetBSD: Makefile,v 1.15 2018/08/22 09:47:48 wiz Exp $

DISTNAME=	Net-FastCGI-0.14
PKGNAME=	p5-${DISTNAME}
PKGREVISION=	5
CATEGORIES=	www perl5 net
MASTER_SITES=	${MASTER_SITE_PERL_CPAN:=Net/}

MAINTAINER=	pkgsrc-users@NetBSD.org
HOMEPAGE=	http://search.cpan.org/dist/Net-FastCGI/
COMMENT=	Perl 5 module to build and parse FastCGI messages
LICENSE=	${PERL5_LICENSE}

USE_LANGUAGES=	# empty
MAKE_ENV+=	PERL_USE_UNSAFE_INC=1
PERL5_PACKLIST=	auto/Net/FastCGI/.packlist

BUILD_DEPENDS+=	p5-Test-Exception-[0-9]*:../../devel/p5-Test-Exception
BUILD_DEPENDS+=	p5-Test-HexString-[0-9]*:../../devel/p5-Test-HexString

.include "../../lang/perl5/module.mk"
.include "../../mk/bsd.pkg.mk"
