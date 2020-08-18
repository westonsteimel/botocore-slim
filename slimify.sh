#!/bin/bash

set -e

PIP_DOWNLOAD_CMD="pip download --no-deps --disable-pip-version-check"

mkdir -p dist

(
    cd dist

    if [[ -z "${BOTOCORE_VERSION}" ]]; then
        BOTOCORE_VERSION=$(pip search botocore | pcregrep -o1 -e "^botocore \((.*)\).*$")
    fi

    echo "slimming wheels for botocore version ${BOTOCORE_VERSION}"
    
    $PIP_DOWNLOAD_CMD botocore==${BOTOCORE_VERSION}

    for filename in ./*.whl
    do
        wheel unpack $filename
        (
            cd botocore-${BOTOCORE_VERSION}/botocore/data/
            rm -rf accessanalyzer \
                acm* \
                alexa* \
                amplify \
                app* \
                autoscaling \
                backup \
                batch \
                braket \
                budgets \
                ce \
                chime \
                cloud9 \
                clouddirectory \
                cloudhsm* \
                cloudsearch* \
                cloudtrail \
                code* \
                comprehend* \
                compute* \
                connect* \
                cur \
                data* \
                detective \
                devicefarm \
                directconnect \
                discovery \
                dlm \
                dms \
                ds \
                ebs \
                ec2* \
                elastic* \
                elb* \
                emr \
                es \
                firehose \
                fms \
                forecast* \
                frauddetector \
                fsx \
                gamelift \
                glacier \
                greengrass \
                groundstation \
                guardduty \
                health \
                honeycode \
                identitystore \
                imagebuilder \
                importexport \
                inspector \
                iot* \
                ivs \
                kafka \
                kendra \
                kinesis* \
                lex* \
                license-manager \
                lightsail \
                machinelearning \
                macie* \
                managedblockchain \
                marketplace* \
                media* \
                meteringmarketplace \
                mgh \
                migrationhub-config \
                mobile \
                mq \
                mturk \
                networkmanager \
                ops* \
                organizations \
                outposts \
                personalize* \
                pi \
                pinpoint* \
                polly \
                pricing \
                qldb* \
                quicksight \
                ram \
                rds* \
                rekognition \
                resource* \
                robomaker \
                route53* \
                sagemaker* \
                savingsplans \
                schemas \
                sdb \
                securityhub \
                serverlessrepo \
                service* \
                shield \
                sms* \
                snowball \
                sso* \
                storagegateway \
                sts \
                support \
                swf \
                synthetics \
                textract \
                transcribe \
                transfer \
                translate \
                waf* \
                work*
        )
        wheel pack botocore-${BOTOCORE_VERSION}

        rm -r botocore-${BOTOCORE_VERSION}
    done

    pip uninstall -y --disable-pip-version-check botocore
    pip install --disable-pip-version-check botocore -f .

    python -c "
import botocore
print(botocore.__version__)
"
)
