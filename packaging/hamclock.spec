Name:           hamclock
Version:        4.32
Release:        1%{?dist}
Summary:        Portable space weather, propagation and telemetry dashboard for radio amateurs
License:        MIT
URL:            https://hamclock.hamradio.my
Group:          Applications/Engineering

Requires:       libX11
Provides:       esphamclock = %{version}-%{release}
Obsoletes:      esphamclock < %{version}-%{release}

%description
9M2PJU HamClock (Open HamClock - OHB Edition) is a dashboard suite for
amateur radio operators providing VOACAP propagation modeling, live SDO/NOAA space
weather, satellite tracking, ADIF log broadcasting, and rotator/radio CAT control.

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/bin
mkdir -p $RPM_BUILD_ROOT/usr/lib/hamclock
mkdir -p $RPM_BUILD_ROOT/usr/share/applications
mkdir -p $RPM_BUILD_ROOT/usr/share/icons/hicolor/128x128/apps
mkdir -p $RPM_BUILD_ROOT/usr/share/man/man1

cp %{_sourcedir}/hamclock-launcher.sh $RPM_BUILD_ROOT/usr/bin/hamclock
chmod 755 $RPM_BUILD_ROOT/usr/bin/hamclock

for f in %{_sourcedir}/hamclock-*; do
  if [ -f "$f" ] && [ "$(basename "$f")" != "hamclock-launcher.sh" ]; then
    cp "$f" $RPM_BUILD_ROOT/usr/lib/hamclock/
    chmod 755 $RPM_BUILD_ROOT/usr/lib/hamclock/$(basename "$f")
  fi
done

if [ -f %{_sourcedir}/hamclock.desktop ]; then
  cp %{_sourcedir}/hamclock.desktop $RPM_BUILD_ROOT/usr/share/applications/
fi
if [ -f %{_sourcedir}/hamclock.png ]; then
  cp %{_sourcedir}/hamclock.png $RPM_BUILD_ROOT/usr/share/icons/hicolor/128x128/apps/
fi
if [ -f %{_sourcedir}/hamclock.1 ]; then
  gzip -c %{_sourcedir}/hamclock.1 > $RPM_BUILD_ROOT/usr/share/man/man1/hamclock.1.gz
fi

%files
/usr/bin/hamclock
/usr/lib/hamclock/*
/usr/share/applications/hamclock.desktop
/usr/share/icons/hicolor/128x128/apps/hamclock.png
/usr/share/man/man1/hamclock.1.gz

%changelog
* Sun Aug 16 2026 9M2PJU <9m2pju@hamradio.my> - 4.32-1
- Initial RPM release with Open HamClock Backend (OHB) and multi-resolution support.
