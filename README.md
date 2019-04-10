# Deactivation Handler

### Supports AI Admin in deactivating former Staff in Podio. Finds existing People items in Podio by item_id and updates fields according to our deactivated condition (https://docs.google.com/document/d/1VH5OiVzGhBtM5Y64i5trNfOQ7RNsCqLMTRO7KjO1Cec/edit?usp=sharing).

## Setup

### Make sure you have the following variables
### PODIO_CLIENT_ID
### PODIO_CLIENT_SECRET
### PODIO_USERNAME (cannot be the AI admin account)
### PODIO_PW

## Notes
This command line tool requires manual intervention / monitoring because of the way our [third-floor app](https://github.com/advocacyinstitute/third-floor) handles item_changes in Podio.

The first file that needs to be run is `bin/deactivate_relationship_fields.rb`
This will deactivate a first set of fields in Podio. As a result of these changes, other processes are kicked off via webhooks in our third-floor app to ensure consistency across item relationships and workspaces.

The next set of fields that are necessary to complete deactivation are stored in `bin/deactivate_active_fields.rb` and this file should only be run once the process of deactivating the first set of fields is complete. In order to know when the process is complete, it is necessary to look at the `third-floor-prodution` Heroku logs. This is necessary because fields such as "Active" and "Reason" must have values in order to properly remove the association of a recently deactivated person from a personal staff office or central staff office. Only once these association removal has completed should those field values be removed to complete the deactivation of that person in Podio.
