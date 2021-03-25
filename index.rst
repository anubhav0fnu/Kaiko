
Migrating tf1.2 code to tf2.0
*****************************

.. code-block::

    docker build -f Dockerfile_tf2 -t kaiko2:0.0 .

.. code-block::
   :name: Spin up a Kaiko container

    docker run --name test_kaiko2_container \
    -v $PWD:/app:rw \
    -v /mnt/anub229_msshare/anubhav/storage/:/app/storage:rw \
    -v /mnt/anub229_msshare/anubhav/storage/data/set_of_Dataset_IDs/stegen1/inference:/app/decode_output \
    -it kaiko2:0.0 /bin/bash

    docker run --name tf2_container \
    -v $PWD:/app:rw \
    -v /mnt/anub229_msshare/anubhav/storage/:/app/storage:rw \
    -v /mnt/anub229_msshare/anubhav/storage/data/set_of_Dataset_IDs/stegen1/inference:/app/decode_output \
    -it tensorflow/tensorflow:latest /bin/bash


.. code-block::
   :name: Converts the mzml(xml-based) file to mgf(test-based)

    mzml_dir=/app/storage/data/set_of_Dataset_IDs/stegen1/test/mzml/
    out_dir=/app/storage/data/set_of_Dataset_IDs/stegen1/test/mgf

    python3.8 /app/tool/mzml2kaiko.py --mzml_dir $mzml_dir  --out_dir $out_dir


.. code-block::
   :name: Prepare Training data


    python mzml2kaiko.py --mzml_dir $mzml_dir  --out_dir $out_dir

.. code-block::
   :name: Run Test/inference(Flag: multi_decode) Triggers!

    mgf_dir=/app/storage/data/set_of_Dataset_IDs/stegen1/test
    train_dir=/app/model
    decode_path=/app/decode_output

    python src/kaiko_main.py
    --mgf_dir $mgf_dir
    --train_dir $train_dir
    --multi_decode
    --decode_path $decode_path
    --beam_search
    --beam_size 5



Training:

.. code-block::
   :name: Start Training (Flag: multi_train) Triggers!

    mgf_dir=/app/storage/data/kaiko_data/Original_mgf/
    train_dir=/app/model

    python /app/src/kaiko_main.py \
    --mgf_dir $mgf_dir \
    --train_dir $train_dir \
    --multi_train \
    --learning_rate 0.0001 \
    --epoch_stop 100 \
    --lastindex 2 \
    --data_format mgf

    python /app/kaiko2/kaiko_main.py \
    --mgf_dir $mgf_dir \
    --train_dir $train_dir \
    --multi_train \
    --learning_rate 0.0001 \
    --epoch_stop 100 \
    --lastindex 2 \
    --data_format mgf