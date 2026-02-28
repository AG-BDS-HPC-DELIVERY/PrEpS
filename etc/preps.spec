%define checkout %{preps_checkout}

Name: preps
Version: 2026.2.1
%define rel 1
Release: %{rel}%{?dist}
Summary: PrEpS (Prolog/Epilog for Slurm)
License: Unclear
BuildArch: noarch
Group: System Environment/Base

%global preps_source_dir %{name}-%{checkout}
%global preps_rel_prefix etc/slurm/preps
%global _prefix /%{preps_rel_prefix}
%global debug_package %{nil}

Source:		%{preps_source_dir}.tar.gz

%description
PrEpS (Prolog/Epilog for Slurm) is a comprehensive but extensible framework for
performing Prolog/Epilog execution inside the Slurm workload scheduler.

#############################################################################

%prep
%setup -n %{preps_source_dir}

%build
sed -i -e 's+PREPS_LOGDIR="${PREPS_PREFIX}/var/log"+PREPS_LOGDIR="/var/log"+g' bin/preps
sed -i -e 's+PREPS_CONFIGFILE="${PREPS_CONFIGDIR}/config.sh"+PREPS_CONFIGFILE="/etc/preps"+g' bin/preps
sed -i -e 's+export PREPS_PRIVILEGED_USERS="putigny1 tallet1"+export PREPS_PRIVILEGED_USERS=""+g' etc/config.sh

%install
install -D -m644 etc/config.sh %{buildroot}/etc/preps

# PRePs is currently installed at /etc/slurm/preps. Let's respect that for the time being
find libexec -type d -exec install -d -m755 {} %{buildroot}%{_prefix}/{} \;
find libexec -type f -exec install -m644 {} %{buildroot}%{_prefix}/{} \;
mkdir -m755 %{buildroot}%{_prefix}/bin
install -D -m755 bin/* %{buildroot}%{_prefix}/bin

%files
%defattr(-,root,root,0755)
%{_bindir}
%{_libexecdir}
%config(noreplace) %{_sysconfdir}/preps
#############################################################################

%pre

%post

%preun

%postun
