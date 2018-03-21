# Repo Fingerprinter

This repo demonstrates a process for fingerprinting a private GitHub repository, such that accidental public copies can be found.

## Methodology

### Fingerprinting

An easy way to find a GitHub repository is to search for a unique string in that repository's code. We leverage this by generating such a string for the repository.

For simplicity's sake, we use an **unsigned** JWT, saved in `.fingerprint`. The payload consists of

```json
{
  "host": "github.com",
  "owner": "<name of user or organization>",
  "repo": "<name of repository>"
}
```

As it is possible for the owner or name of a repository to change, there may be multiple fingerprints in `.fingerprint`, one on each line.

#### Alternatives

An even simpler alternative would be to Base64 encode the remote repository URL, without the use of JWTs at all. JWTs were originally chosen because they offer a signing mechanism, but upon further examination, no use case for signing could be thought of. The use of a structured format, such as JWTs, also allows for metadata and versioning, which a scalar or opaque fingerprint does not.

The use of a non-random token also has value in that fingerprints can be consistently regenerated. A possible disadvantage is that it allows an outsider to easily identify the source repository, though this would likely already be possible using the contents of the repository.

### Searching

A code search is conducted using the raw encoded payload portion of the JWT fingerprint. We are unable to search for the entire JWT, as it exceeds GitHub's search string limit of 128 characters.

## Security

It is important to note that this does **not** prevent a malicious attacker from copying a repository and going unnoticed, as the `.fingerprint` file could simply be deleted in the copy, or the copy kept private. This serves only as a means of detecting **accidental public copies**.

## Demo

### Generating fingerprint

Running `fingerprint.rb` will append a fingerprint for this repository, based on the remotes detected in Git.

```
eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJob3N0IjoiZ2l0aHViLmNvbSIsIm93bmVyIjoic2FtYm9zdG9jayIsInJlcG8iOiJyZXBvLWZpbmdlcnByaW50ZXIifQ.
```

### Searching for fingerprint

Running `search.rb` with the appropriate credentials filled in (username, password, & two-factor authentication token) will search for repositories matching this repository's fingerprint. This will turn up the following results:

```
https://github.com/sambostock/repo-fingerprinter-sentinel
https://github.com/sambostock/repo-fingerprinter
```
