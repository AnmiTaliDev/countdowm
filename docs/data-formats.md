# Data formats

Export and import use the files described here. Dates are written as `YYYY-MM-DD`. Costs are plain decimal numbers with a dot.

## JSON

```json
{
  "version": 1,
  "reminderDays": 3,
  "subscriptions": [
    {
      "name": "Example",
      "cost": 9.99,
      "currency": "USD",
      "periodUnit": "month",
      "periodCount": 1,
      "nextChargeDate": "2026-11-05",
      "category": "streaming",
      "note": "",
      "serviceUrl": "",
      "color": 4284960932,
      "reminderDays": null
    }
  ]
}
```

- `periodUnit`: `day`, `week`, `month`, `year`.
- `periodCount`: whole number, 1 or more. A weekly subscription is `week` with count 1.
- `category`: `streaming`, `music`, `software`, `cloud`, `gaming`, `news`, `utilities`, `health`, `other`.
- `color`: 32-bit ARGB integer.
- `reminderDays` on a subscription: `null` uses the global value. The top-level `reminderDays` is the global value.

## CSV

The first row is a header. Columns:

```
name,cost,currency,period_unit,period_count,next_charge_date,category,note,service_url,color,reminder_days
```

Values follow the same rules as JSON. An empty `reminder_days` uses the global value. CSV files do not carry the global reminder setting. The delimiter is detected on import.

## Import

Import replaces all current subscriptions with the contents of the file. A file with an invalid entry is rejected as a whole and nothing is changed.
