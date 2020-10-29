FROM frekele/ant:1.10.1-jdk8u141

ARG SILVER_BRANCH="v0.4.4"
ARG ABLEC_BRANCH="v0.1.5"
ARG EXTS_BRANCH="ableC-0.1.5"
# TODO: sort out the release for this
ARG HALIDE_BRANCH="master"

# get dependencies
RUN apt-get update && apt-get install -y --no-install-recommends make git gcc libc6-dev sudo
RUN mkdir bin && rm -rf /var/lib/apt/lists/*
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
# download extensions
RUN mkdir extensions
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/silver-ableC.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-string.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-vector.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-constructor.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-closure.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-refcount-closure.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-templating.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-algebraic-data-types.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-template-algebraic-data-types.git
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-unification.git
RUN cd extensions && git clone -b ${HALIDE_BRANCH} https://github.com/melt-umn/ableC-halide.git
# setup silver-ableC
RUN cd extensions/silver-ableC && ./bootstrap-compile
#RUN cd extensions/silver-ableC && ./fetch-jars && ./self-compile
RUN cd extensions/silver-ableC && ./support/bin/install-silver-bin
# delete generated files to save space
RUN rm -rf silver/generated/*/

# get the sample projects
COPY examples/ examples/

# pre-build ableC-halide
RUN cd examples/ableC-halide && make build

# get a nicer prompt
RUN echo  'export PS1="\[\e[3;34m\]strategy-attributes:\W |- \[\e[m\]"' >> /root/.bashrc

ENTRYPOINT /bin/bash

