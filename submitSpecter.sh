for i in $( gsutil ls gs://specter-dia/data | tail -n 5)
do
  if [[ $i == *.mzML ]]
    then
      gcloud dataproc jobs submit pyspark \
      /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/Specter_Spark.py \
      --cluster $1 \
      --bucket specter-dia \
      --files $i,gs://specter-dia/SpecTest/PC3_DDAPhosphoLibrary.redundant.blib \
      --properties='spark.executor.memory=3G,spark.driver.memory=40G' \
      --py-files /Users/mtrnka/Projects-Mine/SpectraNet/specter/Specter/sparse_nnls.py \
      --project specter1 \
      -- ${i#gs://specter-dia/data/} \
         PC3_DDAPhosphoLibrary.redundant.blib \
         0 start 10000 orbitrap 10
     gcloud compute ssh "$1-m" -- 'pwd > /test-files/execpath.txt; echo "$i" >> /test-files/execpath.txt'
  fi
done
