#!/bin/bash
blib="gs://specter-dia/blibs/PC3_insilicoLib_A.blib"

while IFS= read -r line;
#for i in $( gsutil ls gs://specter-dia/data | head -n 35)
do
  if [[ $line == *.mzML ]]
    then
      gcloud dataproc jobs submit pyspark \
      /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/Specter_Spark.py \
      --cluster $1 \
      --bucket specter-dia \
      --files $line,$blib \
      --properties=\
'spark.executor.memory=27G',\
'spark.executor.memoryOverhead=2G',\
'spark.executor.cores=4',\
'spark.driver.memory=27G',\
'spark.driver.cores=4',\
'spark.default.parallelism=120'\
      --py-files /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/sparse_nnls.py \
      --project specter1 \
      -- ${line#gs://specter-dia/data/} \
         ${blib#gs://specter-dia/blibs/} \
         22000 end 5000 orbitrap 10 False

      gcloud dataproc jobs submit pyspark \
      /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/Specter_Spark.py \
      --cluster $1 \
      --bucket specter-dia \
      --files $line,$blib \
      --properties=\
'spark.executor.memory=27G',\
'spark.executor.memoryOverhead=2G',\
'spark.executor.cores=4',\
'spark.driver.memory=27G',\
'spark.driver.cores=8',\
'spark.default.parallelism=120'\
      --py-files /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/sparse_nnls.py \
      --project specter1 \
      -- ${line#gs://specter-dia/data/} \
         ${blib#gs://specter-dia/blibs/} \
         22001 start 5000 orbitrap 10 True
  fi
done < "$2"
