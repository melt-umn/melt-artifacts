FROM frekele/ant:1.10.1-jdk8u141

ARG SILVER_BRANCH="feature/implicit-monads"

# get dependencies
RUN apt-get update && apt-get install -y --no-install-recommends make git gcc libc6-dev sudo
RUN mkdir bin && rm -rf /var/lib/apt/lists/*
# download silver
RUN git clone -b ${SILVER_BRANCH} https://github.com/melt-umn/silver.git
# get the latest jars
RUN cd silver && ./update && ./deep-rebuild
# remove symbolic links if they exist then install silver to bin directory
RUN rm -f ~/bin/silver ~/bin/silver-custom && cd silver && ./support/bin/install-silver-bin

# get the sample projects
# Dont get sample projects use mounted version on your own file system
#RUN git clone -b ${SAMPLE_PROJECT_BRANCH} https://github.com/melt-umn/ableC-sample-projects.git

# add home bin directory to the path
ENV PATH=$PATH:/root/bin
# get a nicer prompt
RUN echo  'export PS1="implicit-monads:\W > "' >> /root/.bashrc

ENTRYPOINT /bin/bash

