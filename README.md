# Slack Delta

Determine who was added or removed from an org sicne the last time this was
run.  A nice way to find out what is new in an org without having to scan it
manually.


## Getting Started

Get your API key from slack and set the environment variable SLACK_TOKEN.
With that set run the scanner:

```bazaar
> bundle exec slack_diff org_name
```
