#!/usr/bin/env bash
CONDA_ENV_YAML_GSC_LOC="gs://specter-dia/SpecterEnv.yml"
CONDA_ENV_YAML_PATH="/root/SpecterEnv.yml"
echo "Downloading conda environment at $CONDA_ENV_YAML_GSC_LOC to $CONDA_ENV_YAML_PATH ... "
gsutil -m cp -r $CONDA_ENV_YAML_GSC_LOC $CONDA_ENV_YAML_PATH
gsutil -m cp -r gs://dataproc-initialization-actions/conda/bootstrap-conda.sh .
gsutil -m cp -r gs://dataproc-initialization-actions/conda/install-conda-env.sh .

chmod 755 ./*conda*.sh
chmod 755 $CONDA_ENV_YAML_PATH

# Install Miniconda / conda
./bootstrap-conda.sh
# Create / Update conda environment via conda yaml
CONDA_ENV_YAML=$CONDA_ENV_YAML_PATH ./install-conda-env.sh

cd /usr/local/share
git clone "https://github.com/mtrnka/Specter.git"
cd /usr/local/share/Specter
chmod 755 *
ln -s /usr/local/share/Specter/*.py /usr/local/bin
ln -s /usr/local/share/Specter/*.R /usr/local/bin
ln -s /usr/local/share/Specter/*.sh /usr/local/bin

export PYSPARK_DRIVER_PYTHON="/opt/conda/bin/python"
export PYSPARK_PYTHON="/opt/conda/bin/python"

Rscript -e 'install.packages(c("kza", "pracma", "moments", "data.table"), dependencies=T, repos="http://cran.cnr.berkeley.edu")'

wget -O /opt/conda/lib/python2.7/site-packages/pymzml/obo/psi-ms-4.1.26.obo \
	http://data.bioontology.org/ontologies/MS/submissions/116/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb

mkdir /specter-output

