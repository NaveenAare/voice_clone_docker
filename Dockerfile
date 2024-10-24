ARG BASE=nvidia/cuda:11.8.0-base-ubuntu22.04
FROM ${BASE}

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends gcc g++ make python3 python3-dev python3-pip python3-venv python3-wheel espeak-ng libsndfile1-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install llvmlite --ignore-installed

RUN pip3 install torch torchaudio --extra-index-url https://download.pytorch.org/whl/cu118

RUN rm -rf /root/.cache/pip

WORKDIR /root

RUN git clone https://github.com/NaveenAare/voice_cloneing.git/root/voice_cloneing

WORKDIR /root/voice_cloneing

RUN python3 -m venv /opt/myenv
ENV VIRTUAL_ENV=/opt/myenv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install --upgrade pip setuptools wheel cython
RUN pip install -r requirements.txt

RUN pip install --upgrade spacy
RUN pip install spacy --prefer-binary
RUN pip install spacy==3.5.0
RUN pip install coqpit
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN pip install -r requirements.txt

RUN make install || echo "Makefile not found or 'install' target missing."

RUN pip install flask gunicorn

RUN touch /root/voice_cloneing/access.log /root/voice_cloneing/error.log

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--access-logfile", "/root/voice_cloneing/access.log", "--error-logfile", "/root/voice_cloneing/error.log"]
