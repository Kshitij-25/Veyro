/// Headers sent with every request to a public API. Public APIs ask clients
/// to identify themselves.
const Map<String, String> apiHeaders = {
  'User-Agent': 'FitnessTrakcer/0.1 (personal fitness tracker)',
  'Accept': 'application/json',
};

/// How long to wait for a public API before giving up.
const Duration apiTimeout = Duration(seconds: 20);
