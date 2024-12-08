# Unomi CI/CD pipeline

<a href="https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/unomi"><img src="deploy-on-elestio.png" alt="Deploy on Elest.io" width="180px" /></a>

Deploy Unomi server with CI/CD on Elestio

<img src="unomi.png" style='width: 60%;'/>
<br/>
<br/>

# Once deployed ...

You can open Unomi UI here:

    URL: https://[CI_CD_DOMAIN]
    email: karaf
    password: [ADMIN_PASSWORD]

# Quick start

This document will help you quickly get started with basic operations such as creating profiles, sessions, and rules using cURL commands.

## Creating a New Profile

To create a new profile, execute the following command:

    curl -X POST https://[CI_CD_DOMAIN]/cxs/profiles/ \
    -u karaf:[ADMIN_PASSWORD] \
    -H "Content-Type: application/json" \
    -d '{
        "itemId": "10",
        "itemType": "profile",
        "version": null,
        "properties": {
            "firstName": "John",
            "lastName": "Smith"
        },
        "systemProperties": {},
        "segments": [],
        "scores": {},
        "mergedWith": null,
        "consents": {}
    }'

## View the Profile

Retrieve the profile details with this command:

    curl -X GET https://[CI_CD_DOMAIN]/cxs/profiles/10 \
    -u karaf:[ADMIN_PASSWORD]

## Creating a New Profile and Session

To create a new profile and session:

    curl -X POST https://[CI_CD_DOMAIN]/cxs/profiles/sessions/101 \
    -u karaf:[ADMIN_PASSWORD] \
    -H "Content-Type: application/json" \
    -d '{
        "itemId": "101",
        "itemType": "session",
        "scope": null,
        "version": 1,
        "profileId": "10",
        "profile": {
            "itemId": "10",
            "itemType": "profile",
            "version": null,
            "properties": {
                "firstName": "John",
                "lastName": "Smith"
            },
            "systemProperties": {},
            "segments": [],
            "scores": {},
            "mergedWith": null,
            "consents": {}
        },
        "properties": {},
        "systemProperties": {},
        "timeStamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
    }'

## View the Session

Retrieve all sessions associated with the profile:

    curl -X GET https://[CI_CD_DOMAIN]/cxs/profiles/10/sessions \
    -u karaf:[ADMIN_PASSWORD]

## Creating a New Rule

To create a new rule, such as an eligibility rule:

    curl -X POST https://[CI_CD_DOMAIN]/cxs/rules/ \
    -u karaf:[ADMIN_PASSWORD] \
    -H "Content-Type: application/json" \
    -d '{
        "metadata": {
            "id": "eligibilityRule",
            "name": "Example eligibility rule",
            "description": "Profile annualIncome < 12000"
        },
        "condition": {
            "parameterValues": {
                "subConditions": [
                    {
                        "parameterValues": {
                            "propertyName": "properties.annualIncome",
                            "comparisonOperator": "greaterThan",
                            "propertyValueInt": 12000
                        },
                        "type": "profilePropertyCondition"
                    },
                    {
                        "type": "profileUpdatedEventCondition",
                        "parameterValues": {}
                    }
                ],
                "operator": "and"
            },
            "type": "booleanCondition"
        },
        "actions": [
            {
                "parameterValues": {
                    "setPropertyName": "properties.eligibility",
                    "setPropertyValue": "yes"
                },
                "type": "setPropertyAction"
            }
        ]
    }'

## View the Rule

Retrieve the rule details:

    curl -X GET https://[CI_CD_DOMAIN]/cxs/rules/eligibilityRule/ \
    -u karaf:[ADMIN_PASSWORD]

# Notes

This quick start guide provides you with a foundation to explore Apache Unomi further. For detailed information, refer to the official <a href="https://unomi.apache.org/documentation.html" target="_blank">Apache Unomi documentation</a>.
