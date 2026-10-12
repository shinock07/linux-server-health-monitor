# Linux Server Health Monitor

A Bash-based Linux administration project that monitors essential server health metrics, checks service availability, generates timestamped reports, and tracks overall system health using severity levels.

## Features

- **CPU monitoring:** Checks system load against the available CPU count.
- **Memory monitoring:** Warns when memory usage reaches 85%.
- **Disk monitoring:** Warns at 70% root disk usage and reports critical status at 85%.
- **Service monitoring:** Checks whether the Nginx service is active using `systemctl`.
- **Severity management:** Maintains the highest severity encountered during a monitoring run.
- **Report generation:** Saves timestamped health reports for later review.
- **Failure handling:** Detects report-directory and report-file creation failures.
- **Syntax validation:** Uses Bash syntax checking before execution.

## Technologies

- Linux
- Bash scripting
- `awk`, `free`, `df`, `date`, and `nproc`
- `systemctl`
- Standard Linux file and process management tools

## Project Structure

```text
linux-server-health-monitor/
├── health-check.sh
├── severity-test.sh
├── report-test.sh
├── README.md
├── reports/
└── screenshots/
```

## Requirements

- A Linux environment with Bash.
- `awk`, `free`, `df`, `date`, and `nproc`.
- systemd and systemctl for service monitoring.
- Nginx installed if you want to monitor the Nginx service.

## Usage

Validate the script syntax:

```bash
bash -n health-check.sh
```

Run the health monitor:

```bash
bash health-check.sh
```

Check the exit status:

```bash
echo $?
```

List generated reports:

```bash
ls -lt reports/
```

Run the severity test:

```bash
bash severity-test.sh
```

## Severity Levels

| Status | Severity |
|---|---:|
| OK | 0 |
| WARNING | 1 |
| CRITICAL | 2 |
| UNKNOWN | 3 |

The overall status should preserve the highest severity detected during a monitoring run, rather than allowing a later healthy check to erase an earlier critical result.

## Failure Handling

The monitoring script checks whether it can create the report directory and report file. A report initialization failure exits with status code `3`.

## Validation Results

The following checks have been performed in the development environment:

- Bash syntax validation returned exit code `0`.
- CPU, memory, disk, and Nginx checks completed successfully.
- The health report displayed `OVERALL STATUS: OK` under the tested conditions.
- Severity tests confirmed that lower-severity statuses do not override higher-severity statuses.
- An invalid report-directory test returned exit code `3`.

## Future Improvements

- Add configurable thresholds.
- Support command-line options and custom service names.
- Integrate scheduled execution using cron or systemd timers.
- Add log rotation and report retention.
- Send alerts when critical thresholds are reached.

## Learning Outcomes

This project demonstrates practical Linux administration, Bash functions, conditional statements, exit codes, system monitoring, file handling, error handling, and basic testing.

## Disclaimer

This project is intended for learning and portfolio demonstration. Test it in a suitable environment before using it to monitor production servers.
