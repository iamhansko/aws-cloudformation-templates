#!/bin/bash
export AWS_REGION="us-east-1"
export S3_BUCKET="s3://xxxxxx-emrs3bucket-xxxxxx"
export EMR_VIRTUAL_CLUSTER_ID="xxxxxx"
export EMR_EXECUTION_ROLE_ARN="arn:aws:iam::xxxxxxxxxxxx:role/xxxxxx-EmrJobExecutionRole-xxxxxx"
export CLOUDWATCH_LOG_GROUP="/emr/on/eks"

JOB_NAME="taxidata"
EMR_EKS_RELEASE_LABEL="emr-6.10.0-latest" # Spark 3.3.1
SPARK_JOB_S3_PATH="${S3_BUCKET}/${EMR_VIRTUAL_CLUSTER_ID}/${JOB_NAME}"
SCRIPTS_S3_PATH="${SPARK_JOB_S3_PATH}/scripts"
INPUT_DATA_S3_PATH="${SPARK_JOB_S3_PATH}/input"
OUTPUT_DATA_S3_PATH="${SPARK_JOB_S3_PATH}/output"
echo ${SCRIPTS_S3_PATH}
aws s3 sync "./" ${SCRIPTS_S3_PATH}
mkdir -p "../input"
wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2022-01.parquet -O "../input/yellow_tripdata_2022-0.parquet"
max=20
for (( i=1; i <= $max; ++i ))
do
cp -rf "../input/yellow_tripdata_2022-0.parquet" "../input/yellow_tripdata_2022-${i}.parquet"
done
aws s3 sync "../input" ${INPUT_DATA_S3_PATH}
rm -rf "../input"
aws emr-containers start-job-run \
--virtual-cluster-id $EMR_VIRTUAL_CLUSTER_ID \
--name $JOB_NAME \
--region $AWS_REGION \
--execution-role-arn $EMR_EXECUTION_ROLE_ARN \
--release-label $EMR_EKS_RELEASE_LABEL \
--job-driver '{
  "sparkSubmitJobDriver": {
    "entryPoint": "$SCRIPTS_S3_PATH/pyspark-taxi-trip.py",
    "entryPointArguments": ["$INPUT_DATA_S3_PATH",
      "$OUTPUT_DATA_S3_PATH"
    ],
    "sparkSubmitParameters": "--conf spark.executor.instances=2"
  }
}' \
--configuration-overrides '{
  "applicationConfiguration": [
      {
        "classification": "spark-defaults",
        "properties": {
          "spark.driver.cores":"1",
          "spark.executor.cores":"1",
          "spark.driver.memory": "4g",
          "spark.executor.memory": "4g",
          "spark.kubernetes.driver.podTemplateFile":"$SCRIPTS_S3_PATH/driver-pod-template.yaml",
          "spark.kubernetes.executor.podTemplateFile":"$SCRIPTS_S3_PATH/executor-pod-template.yaml",
          "spark.local.dir":"/data1",
          "spark.kubernetes.submission.connectionTimeout": "60000000",
          "spark.kubernetes.submission.requestTimeout": "60000000",
          "spark.kubernetes.driver.connectionTimeout": "60000000",
          "spark.kubernetes.driver.requestTimeout": "60000000",
          "spark.kubernetes.executor.podNamePrefix":"$JOB_NAME",
          "spark.metrics.appStatusSource.enabled":"true"
        }
      }
    ],
  "monitoringConfiguration": {
    "persistentAppUI":"ENABLED",
    "cloudWatchMonitoringConfiguration": {
      "logGroupName":"$CLOUDWATCH_LOG_GROUP",
      "logStreamNamePrefix":"$JOB_NAME"
    },
    "s3MonitoringConfiguration": {
      "logUri":"${S3_BUCKET}/logs/"
    }
  }
}'