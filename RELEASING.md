# Releasing

1. Update `lib/swiftner/version.rb` accordingly and run `bundle install` to update the Gemfile.lock.
1. Update `CHANGELOG.md` to reflect the changes since last release. This means moving everyhing from the unrealesed section to an appropriate version section.
1. Commit changes.
1. Tag the release: `git tag -s vVERSION`
1. Push changes: `git push && git push --tags`
1. Build and publish:
    ```bash
    gem build swiftner.gemspe
    gem push swiftner-VERSION.gem
    ```
1. Add a new GitHub release using the content from new version section of `CHANGELOG.md` as the content.
1. Announce the new release, say "thank you" to the contributors.
