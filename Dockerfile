FROM --platform=linux/x86_64 gcc:12

# Install build-essential (includes g++, gcc, make, etc.)
RUN apt-get update && \
    apt-get install -y emacs locales bsdmainutils bc gdb lldb && \
    sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    conda clean -afy

# Configure bioconda channels
RUN conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge

# Accept ToS for Anaconda channels
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Install specific version of kmer-jellyfish
RUN conda install -y kmer-jellyfish=1.1.12

RUN conda install -y kmc

WORKDIR /code
