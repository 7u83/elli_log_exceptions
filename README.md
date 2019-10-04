elli_log_exceptions
=====

[Elli](https://github.com/elli-lib/elli) middleware that will log exceptions at a configurable log level and with or without the full stacktrace:

```erlang
ElliOpts = [{callback, elli_middleware},
            {callback_args, [{mods, [{elli_log_exceptions, elli_log_exceptions:config([])},
                                     ...]}]},
            {port, 3000}],

ElliChildSpec = #{id => elli_handler,
                  start => {elli, start_link, [ElliOpts]},
                  restart => permanent,
                  type => worker,
                  modules => [elli_log_exceptions]},
```

`elli_log_exceptions:config/1` takes a proplist of options:

* `level`: The logger level to log the exception (example, `{level, error}`).
* `include_stacktrace`: If true the log will include the stacktrace from the exception.
