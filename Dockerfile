
FROM tensorflow/tensorflow:1.2.0

#RUN pip install biopython
pip install biopython==1.73
#RUN pip install pyteomics
pip install pyteomics==3.5.1
#RUN pip install numba
pip install numba==0.42.0

#RUN pip install sigopt
pip install sigopt==3.6.2

COPY ./*sh /app/
COPY ./src /app/src
WORKDIR /app
