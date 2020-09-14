FROM frekele/ant:1.10.1-jdk8u141

# Change these to tags after releases are finished
ARG SILVER_BRANCH="develop"
ARG ABLEC_BRANCH="develop"
ARG EXTS_BRANCH="develop"
ARG OPT_DEMO_BRANCH="develop"
ARG LAMBDA_CALC_BRANCH="develop"
ARG REGEX_MATCH_BRANCH="develop"

# get dependencies
RUN apt-get update && apt-get install -y --no-install-recommends make git gcc libc6-dev sudo
RUN mkdir bin && rm -rf /var/lib/apt/lists/*
# add home bin directory to the path
ENV PATH=$PATH:/root/bin
# download silver
RUN git clone -b ${SILVER_BRANCH} https://github.com/melt-umn/silver.git
# get the latest jars
RUN cd silver && ./update && ./deep-rebuild
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
# setup silver-ableC
#RUN cd extensions/silver-ableC && ./bootstrap-compile
RUN cd extensions/silver-ableC && ./fetch-jars && ./self-compile
RUN cd extensions/silver-ableC && ./support/bin/install-silver-bin

# get the sample projects
RUN cd extensions && git clone -b ${EXTS_BRANCH} https://github.com/melt-umn/ableC-halide.git
RUN git clone -b ${OPT_DEMO_BRANCH} https://github.com/melt-umn/rewriting-optimization-demo.git
RUN git clone -b ${LAMBDA_CALC_BRANCH} https://github.com/melt-umn/rewriting-lambda-calculus.git
RUN git clone -b ${REGEX_MATCH_BRANCH} https://github.com/melt-umn/rewriting-regex-matching.git

# get a nicer prompt
RUN echo  'export PS1="\[\e[3;34m\]strategy-attributes:\W |- \[\e[m\]"' >> /root/.bashrc

ENTRYPOINT /bin/bash

