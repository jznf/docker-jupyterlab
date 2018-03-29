FROM ubuntu:16.04

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y wget vim bzip2 curl

RUN cd /tmp && curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh && \
        bash nodesource_setup.sh && apt-get install -y nodejs && nodejs -v

RUN useradd -m jlab

USER jlab

RUN cd ~/ && wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
        bash ~/Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/miniconda

ENV PATH /home/jlab/miniconda:$PATH

ENV PATH /home/jlab/miniconda/bin:$PATH

RUN conda update conda

RUN conda create --name jlab && conda info --envs && source activate jlab

ENV PATH /home/jlab/miniconda/envs/jlab/bin:$PATH

RUN source activate jlab && conda install -c conda-forge jupyterlab && \
        jupyter labextension install @jupyterlab/google-drive

RUN mkdir -p /home/jlab/jupyterlab

EXPOSE 8888

CMD jupyter lab --ip=* --port=8888 --no-browser --notebook-dir=/home/jlab/jupyterlab
