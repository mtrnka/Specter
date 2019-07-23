for i in $( gsutil ls gs://specter-dia/data | head -n 25 | tail -n 3)
do
  if [[ $i == *.mzML ]]
    then
      gcloud dataproc jobs submit pyspark \
      /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/debug.py \
      --cluster $1 \
      --bucket specter-dia \
      --files $i,gs://specter-dia/SpecTest/PC3_DDAPhosphoLibrary.redundant.blib \
      --properties='spark.driver.memory=15G','spark.executor.memory=20G' \
      --py-files /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/sparse_nnls.py \
      --project specter1 \
      -- ${i#gs://specter-dia/data/} \
         PC3_DDAPhosphoLibrary.redundant.blib \
         0 start 20000 orbitrap 10
  fi
done
