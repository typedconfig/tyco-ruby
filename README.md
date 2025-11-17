## Tyco Ruby Binding

Ruby wrapper over `libtyco_c` that exposes `Tyco.load_file` / `Tyco.load_string` returning hashes/arrays matching the canonical JSON output.

### Prerequisites

1. Build the C library:
   ```bash
   cd ../tyco-c
   cmake -S . -B build
   cmake --build build
   ```
2. Ensure `LD_LIBRARY_PATH` (Linux) includes `../tyco-c/build` when running Ruby code that loads the extension.

### Build & Test

```bash
cd tyco-ruby
ruby ext/tyco_ext/extconf.rb
make -C ext/tyco_ext
bundle exec rake test    # or: LD_LIBRARY_PATH=../tyco-c/build rake test
```

## Quick Start

Each binding ships the canonical configuration under `tyco/example.tyco`
([view on GitHub](https://github.com/typedconfig/tyco-ruby/blob/main/tyco/example.tyco)).
Load it to mirror the Python README example:

```ruby
require_relative 'lib/tyco'

config = Tyco.load_file('tyco/example.tyco')

timezone = config['timezone']
puts "timezone=#{timezone}"

applications = config['Application']
hosts = config['Host']
primary_app = applications.first
puts "primary service -> #{primary_app['service']} (#{primary_app['command']})"

backup_host = hosts[1]
puts "host #{backup_host['hostname']} cores=#{backup_host['cores']}"
```

### Example Tyco File

```
tyco/example.tyco
```

```tyco
str timezone: UTC  # this is a global config setting

Application:       # schema defined first, followed by instance creation
  str service:
  str profile:
  str command: start_app {service}.{profile} -p {port.number}
  Host host:
  Port port: Port(http_web)  # reference to Port instance defined below
  - service: webserver, profile: primary, host: Host(prod-01-us)
  - service: webserver, profile: backup,  host: Host(prod-02-us)
  - service: database,  profile: mysql,   host: Host(prod-02-us), port: Port(http_mysql)

Host:
 *str hostname:  # star character (*) used as reference primary key
  int cores:
  bool hyperthreaded: true
  str os: Debian
  - prod-01-us, cores: 64, hyperthreaded: false
  - prod-02-us, cores: 32, os: Fedora

Port:
 *str name:
  int number:
  - http_web,   80  # can skip field keys when obvious
  - http_mysql, 3306
```
