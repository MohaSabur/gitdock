FROM debian:stable
WORKDIR /home/git
RUN apt update && apt install git  openssh-server sudo -y

RUN useradd -rm -d /home/git -s /bin/bash -g root -G sudo -u 1000 git
RUN addgroup git
RUN usermod git -aG git
RUN mkdir /home/git/.ssh
COPY authorized_keys /home/git/.ssh/authorized_keys
RUN chown -R git:git /home/git
COPY authorized_keys share/authorized_keys
RUN chown git:git /home/git/.ssh/authorized_keys
COPY createrepo /bin/createrepo
RUN chmod 755 /bin/createrepo
COPY authkeys /bin/authkeys
RUN chmod 755 /bin/authkeys
RUN git config --global user.email "GitDock@MohaSabur.git"
RUN git config --global user.name "GitDock"
RUN sudo -u git bash -c 'git config --global user.email "GitDock@MohaSabur.git"'
RUN sudo -u git bash -c 'git config --global user.name "GitDock"'
RUN git config --global receive.denyCurrentBranch updateInstead
RUN sudo -u git bash -c 'git config --global receive.denyCurrentBranch updateInstead'
RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
