module.exports = {
  github: {
    release: true,
    releaseName: "v${version}",
  },
  npm: {
    publish: false,
  },
  git: {
    tag: true,
    commit: true,
    commitMessage: "chore(release): release ${version}",
  },
  plugins: {
    "@release-it/bumper": {
      in: "package.json",
      out: "src/version.json",
    },
  },
};
