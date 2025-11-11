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

### Usage

```ruby
require_relative 'lib/tyco'

data = Tyco.load_file('../tyco-test-suite/inputs/simple1.tyco')
puts data['project'] # => "demo"
```ruby
require_relative 'lib/tyco'

# Parse a Tyco configuration file
context = Tyco.load_file('config.tyco')

# Access global configuration values
globals = context['globals']
environment = globals['environment']
debug = globals['debug']
timeout = globals['timeout']

# Get all instances as hashes
objects = context['objects']
databases = objects['Database'] # Array of Database instances
servers = objects['Server']     # Array of Server instances

# Access individual instance fields
primary_db = databases[0]
db_host = primary_db['host']
db_port = primary_db['port']
```
