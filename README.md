killbill-catalog-ruby-plugin
============================

Plugin to highlight the use of the CatalogPluginApi from a ruby plugin.

Release builds are available on [Maven Central](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22org.kill-bill.billing.plugin.ruby%22%20AND%20a%3A%22killbill-catalog-ruby-plugin%22) with coordinates `org.kill-bill.billing.plugin.ruby:killbill-catalog-ruby-plugin`.

Kill Bill compatibility
-----------------------

| Plugin version | Kill Bill version |
| -------------: | ----------------: |
| 0.1.y          | 0.16.z            |
| 0.2.y          | 0.18.z            |

Usage
-----

You can verify Kill Bill can load up the demo Gold plan by creating a subscription:

```
curl -v
     -u admin:password
     -H "X-Killbill-ApiKey: bob"
     -H "X-Killbill-ApiSecret: lazar"
     -H "Content-Type: application/json"
     -H "X-Killbill-CreatedBy: demo"
     -X POST
     --data-binary '{"accountId":"486a9a5f-b896-40c0-845a-a8c042992a32","productName":"Gold","productCategory":"BASE","billingPeriod":"MONTHLY","priceList":"DEFAULT"}'
     "http://127.0.0.1:8080/1.0/kb/subscriptions"
```
