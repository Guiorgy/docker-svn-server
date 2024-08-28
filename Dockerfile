FROM alpine:3.20.2

CMD [ "/usr/bin/svnserve", "--daemon", "--foreground", "--root", "/var/opt/svn" ]
EXPOSE 3690
HEALTHCHECK CMD netstat -ln | grep 3690 || exit 1
VOLUME [ "/var/opt/svn" ]
WORKDIR /var/opt/svn

ENV SVN_UID=2010

RUN apk add --no-cache \
	subversion==1.14.3-r2 \
	wget==1.24.5-r0 \
	&& addgroup \
		--gid $SVN_UID \
		svnserve \
	&& adduser \
		--no-create-home \
		--shell /sbin/nologin \
		--disabled-password \
		--ingroup svnserve \
		--uid $SVN_UID \
		svnserve \
	&& chown -R svnserve:svnserve /var/opt/svn

USER svnserve
