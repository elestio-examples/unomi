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

## Installing the web tracker in a web page

Using the built-in tracker is pretty simple, simply add the following code to your HTML page :

    <script type="text/javascript" src="https://[CI_CD_DOMAIN]/tracker/unomi-web-tracker.min.js"></script>

This will only load the tracker. To initialize it use a snipper like the following code:

    <script type="text/javascript">
        (function () {
            const unomiTrackerTestConf = {
                "scope": "unomi-tracker-test",
                "site": {
                    "siteInfo": {
                        "siteID": "unomi-tracker-test"
                    }
                },
                "page": {
                    "pageInfo": {
                        "pageID": "unomi-tracker-test-page",
                        "pageName": document.title,
                        "pagePath": document.location.pathname,
                        "destinationURL": document.location.origin + document.location.pathname,
                        "language": "en",
                        "categories": [],
                        "tags": []
                    },
                    "attributes": {},
                    "consentTypes": []
                },
                "events:": [],
                "wemInitConfig": {
                    "contextServerUrl": document.location.origin,
                    "timeoutInMilliseconds": "1500",
                    "contextServerCookieName": "context-profile-id",
                    "activateWem": true,
                    "trackerSessionIdCookieName": "unomi-tracker-test-session-id",
                    "trackerProfileIdCookieName": "unomi-tracker-test-profile-id"
                }
            }

            // generate a new session
            if (unomiWebTracker.getCookie(unomiTrackerTestConf.wemInitConfig.trackerSessionIdCookieName) == null) {
                unomiWebTracker.setCookie(unomiTrackerTestConf.wemInitConfig.trackerSessionIdCookieName, unomiWebTracker.generateGuid(), 1);
            }

            // init tracker with our conf
            unomiWebTracker.initTracker(unomiTrackerTestConf);

            unomiWebTracker._registerCallback(() => {
                console.log("Unomi tracker test successfully loaded context", unomiWebTracker.getLoadedContext());
            }, 'Unomi tracker test callback example');

            // start the tracker
            unomiWebTracker.startTracker();
        })();
    </script>

## Creating a scope to collect the data

    curl --location --request POST 'https://[CI_CD_DOMAIN]/cxs/scopes' \
    -u karaf:[ADMIN_PASSWORD] \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "itemId": "unomi-tracker-test",
        "metadata": {
        "id": "unomi-tracker-test",
        "name": "Unomi tracker Test Scope"
        }
    }'

## To View All Events:

Before to view all events, reload at least 5 times your page.

    curl --location --request POST 'https://[CI_CD_DOMAIN]/cxs/events/search' \
    -u karaf:[ADMIN_PASSWORD] \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "sortby" : "timeStamp:desc",
        "condition" : {
        "type" : "matchAllCondition"
        }
    }'

# Notes

This quick start guide provides you with a foundation to explore Apache Unomi further. For detailed information, refer to the official <a href="https://unomi.apache.org/manual/latest/index.html" target="_blank">Apache Unomi documentation</a>.
