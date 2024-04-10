#!/bin/bash
BUCKET=s3://skills-korea-2022-$(($RANDOM%10000))
aws s3 mb $BUCKET
aws s3 cp /opt/a.txt $BUCKET/a.txt
aws s3 cp /opt/b.txt $BUCKET/b.txt
aws s3 cp /opt/c.txt $BUCKET/c.txt