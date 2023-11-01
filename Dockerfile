FROM vatlab/sos-notebook:latest

LABEL maintainer="Madhur Gupta <madhurgupta104@gmail.com>"

ENV BUCKET_NAME=madhurgupta104-bucket

ENV MOUNT_POINT=/home/jovyan/work

COPY ./.Rprofile /home/jovyan/.Rprofile

COPY ./custom-r-functions.R /home/jovyan/my-scripts/custom-r-functions.R

COPY ./mount-gcs.sh /home/jovyan/mount-gcs.sh

USER root

RUN chmod +x /home/jovyan/mount-gcs.sh

RUN export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s` && \
	echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list && \
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
	sudo apt-get update && \
	sudo apt-get install -y gcsfuse && \
	echo 'user_allow_other' > /etc/fuse.conf

RUN mamba install -c conda-forge r-quandl=2.11.0 -y

RUN pip install jupyterlab-sos==0.10.1

ENTRYPOINT ["/home/jovyan/mount-gcs.sh"]

USER jovyan

