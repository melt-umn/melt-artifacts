FROM openjdk:11

ARG SILVER_BRANCH="feature/use-data-nonterminals"
ARG ABLEC_BRANCH="feature/use-remote-dec"
ARG EXTS_BRANCH="develop"

# get dependencies
RUN apt-get update && apt-get install -y --no-install-recommends make git gcc libc6-dev sudo ant libgc-dev
RUN mkdir -p ~/bin && rm -rf /var/lib/apt/lists/*
# add home bin directory to the path
ENV PATH=$PATH:/root/bin
# download silver
RUN git clone -b ${SILVER_BRANCH} https://github.com/melt-umn/silver.git
# get the latest jars
RUN cd silver && ./fetch-jars && ./deep-rebuild
# remove symbolic links if they exist then install silver to bin directory
RUN rm -f ~/bin/silver ~/bin/silver-custom && cd silver && ./support/bin/install-silver-bin
# download ableC
RUN git clone -b ${ABLEC_BRANCH} https://github.com/melt-umn/ableC.git

# Copy examples already cloned
# Only include the updated versions of the extensions
COPY example-language/ example-language/
COPY ableC-extensions-with-sharing/ extensions/

# Not updated to use sharing
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-string.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-vector.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-constructor.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-templating.git
# Not evaluated in the paper, but needed to build silver-ableC
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-refcount-closure.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-template-algebraic-data-types.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/silver-ableC.git

# setup silver-ableC
RUN cd extensions/silver-ableC && ./bootstrap-compile
#RUN cd extensions/silver-ableC && ./fetch-jars && ./self-compile
RUN cd extensions/silver-ableC && ./support/bin/install-silver-bin
# delete generated files to save space
RUN rm -rf silver/generated/*/

# get a nicer prompt
RUN echo  'export PS1="\[\e[3;34m\]tree-sharing:\W |- \[\e[m\]"' >> /root/.bashrc

ENTRYPOINT /bin/bash

