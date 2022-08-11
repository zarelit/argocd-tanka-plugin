# argocd-tanka-plugin

This is a Docker image which can be used as a sidecar for ArgoCD to enable [`tanka`](https://tanka.dev/) support.

## Requirements

This plugin currently requires a `jsonnetfile.json` file to be anywhere in the repository to be activated. It is yet to be determined, whether this overrides built-in `jsonnet` support integrated into ArgoCD.

## `vendor` support

`jsonnet-bundler` is used to install `vendor` directories anywhere in the repository, so that both top-level and environment-specific `vendor` directories are supported.

## Helm Charts support

This plugin will vendor charts in every directory in the repository where a `chartfile.yaml` is found.

## Usage

Step 1: add an extra container to ArgoCD Helm release:

``` js
{
  extraContainers: [
    {
      name: 'tanka-cmp',
      image: 'kurzdigital/argocd-tanka-plugin',
      securityContext: {
        runAsUser: 999,
      },
      volumeMounts: [
        {
          mountPath: '/var/run/argocd',
          name: 'var-files',
        },
        {
          mountPath: '/home/argocd/cmp-server/plugins',
          name: 'plugins',
        },
        {
          mountPath: '/tmp',
          name: 'cmp-tmp',
        },
      ],
    }
  ]
}
```

Step 2: add plugin configuration to your ArgoCD application:

``` yaml
spec:
  source:
    plugin:
      env:
      - name: TK_ENV
        value: default
      - name: EXTRA_ARGS
        value: --extra-options-you-need
```

### Environment variables

* TK_ENV: `tanka` environment to render
* EXTRA_ARGS: any extra arguments you'd like to put on the commandline of `tk`. Good candidates are top-level functions and external variables.

## Tips and tricks

You can re-use your `tanka` `$.config` object as top-level arguments in the plugin by setting `EXTRA_ARGS` environment variable to

``` jsonnet
std.join(" ", ["-A %s=%s" % [x, $.config[x]] for x in std.objectFields($.config)])
```
