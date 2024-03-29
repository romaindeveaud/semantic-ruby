%define name link-grammar
%define version 4.4.1
%define release 1

Summary: A Natural Language Parser based on Link Grammar Theory

Name: %{name}
Version: %{version}
Release: %{release}
Group: System Environment/Libraries
License: LGPL

Source: %{name}-%{version}.tar.gz
Buildroot: /var/tmp/%{name}-%{version}-%{release}-root
URL: http://www.link.cs.cmu.edu/link/

#Requires: 
#BuildRequires: 

%description
The Link Grammar Parser is a natural language parser based on 
link grammar theories of natural language. 

%package devel
Summary: Support files necessary to compile applications with link-grammar.
Group: Development/Libraries
Requires: link-grammar

%description devel
Libraries, headers, and support files necessary to compile applications using link-grammar.

%prep

%setup

%build
%ifarch alpha
  MYARCH_FLAGS="--host=alpha-redhat-linux"
%endif

if [ ! -f configure ]; then
CFLAGS="$RPM_OPT_FLAGS" ./autogen.sh --prefix=%{_prefix}
fi
CFLAGS="$RPM_OPT_FLAGS" ./configure --prefix=%{_prefix} 

if [ "$SMP" != "" ]; then
  (%__make "MAKE=%__make -k -j $SMP"; exit 0)
  %__make
else
%__make
fi

%install
if [ -d $RPM_BUILD_ROOT ]; then rm -r $RPM_BUILD_ROOT; fi
%__make DESTDIR=$RPM_BUILD_ROOT install
find $RPM_BUILD_ROOT/%{_libdir} -name \*.la -exec rm -f \{\} \;

%files
%defattr(644,root,root,755)
%doc LICENSE README
%attr(755,root,root)%{_bindir}/*
%{_libdir}/lib*.so*
%{_datadir}/link-grammar/*

%files devel
%defattr(644,root,root,755)
%{_libdir}/*.a
%{_libdir}/pkgconfig/link-grammar.pc
%{_includedir}/link-grammar/*

%clean
%__rm -r $RPM_BUILD_ROOT

%changelog
* Sat Feb 5 2005 Dom Lachowicz <cinamod@hotmail.com>
- Initial version
