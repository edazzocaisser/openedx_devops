#!/bin/sh
#------------------------------------------------------------------------------
# written by:   mcdaniel
#               https://lawrencemcdaniel.com
#
# date:         mar-2022
#
# usage:        Re-runs the Cookiecutter for this repository.
#------------------------------------------------------------------------------

GITHUB_REPO="gh:lpm0073/cookiecutter-openedx-devops"
GITHUB_BRANCH="main"
OUTPUT_FOLDER="../"

cookiecutter --checkout $GITHUB_BRANCH \
             --output-dir $OUTPUT_FOLDER \
             --overwrite-if-exists \
             --no-input \
             $GITHUB_REPO \
             global_platform_name=mrionline \
             global_platform_region=global \
             global_aws_region=us-east-2 \
             global_account_id=621672204142 \
             global_root_domain=mrionline.com \
             global_aws_route53_hosted_zone_id=Z0476367ACNR8F3YFZX \
             environment_name=dev \
             environment_subdomain=dev
