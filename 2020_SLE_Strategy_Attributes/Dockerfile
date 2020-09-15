FROM frekele/ant:1.10.1-jdk8u141

# Change these to tags after releases are finished
ARG SILVER_BRANCH="develop"
ARG ABLEC_BRANCH="develop"
ARG EXTS_BRANCH="develop"

# add home bin directory to the path
ENV PATH=$PATH:/root/bin
# get dependencies
RUN apt-get update && apt-get install -y --no-install-recommends make git gcc libc6-dev sudo \
  && rm -rf /var/lib/apt/lists/*
# Install Silver and ableC
RUN mkdir bin \
  && git clone -b ${SILVER_BRANCH} https://github.com/melt-umn/silver.git \
  && cd silver && ./update && ./deep-rebuild && ./support/bin/install-silver-bin && cd .. \
  && git clone -b ${ABLEC_BRANCH} https://github.com/melt-umn/ableC.git
# Install ableC extensions
RUN mkdir extensions \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/silver-ableC.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-string.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-vector.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-constructor.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-closure.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-refcount-closure.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-templating.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-algebraic-data-types.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-template-algebraic-data-types.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-unification.git \
  && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-halide.git
# Setup silver-ableC
RUN cd extensions/silver-ableC && ./bootstrap-compile && ./support/bin/install-silver-bin

# Get the sample projects
COPY examples/ examples/

# Get a nicer prompt
RUN echo  'export PS1="\[\e[3;34m\]strategy-attributes:\W |- \[\e[m\]"' >> /root/.bashrc

ENTRYPOINT /bin/bash
