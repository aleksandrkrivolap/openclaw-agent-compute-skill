"""Turn a category/amount_usd CSV into a Markdown artifact (Python stdlib only)."""

import argparse
import csv
from decimal import Decimal, InvalidOperation, localcontext
from pathlib import Path


def render(source):
    totals = {}
    count = 0
    with source.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames != ["category", "amount_usd"]:
            raise ValueError("expected header: category,amount_usd")
        for row in reader:
            category = (row["category"] or "").strip()
            if not category or None in row or row["amount_usd"] is None:
                raise ValueError(f"CSV line {reader.line_num}: malformed row")
            try:
                amount = Decimal(row["amount_usd"])
                if not amount.is_finite() or abs(amount) > Decimal("1000000000"):
                    raise ValueError("amount must be finite and at most 1 billion USD")
                if amount != amount.quantize(Decimal("0.01")):
                    raise ValueError("amount must have at most two decimal places")
            except (InvalidOperation, ValueError) as error:
                raise ValueError(f"CSV line {reader.line_num}: invalid amount_usd") from error
            # Integer cents keep aggregation exact, including negative adjustments.
            totals[category] = totals.get(category, 0) + int(amount * 100)
            count += 1

    def money(cents):
        sign = "-" if cents < 0 else ""
        return f"{sign}{abs(cents) // 100}.{abs(cents) % 100:02d}"

    lines = ["# CSV summary", "", f"Rows: {count}",
             f"Total (USD): {money(sum(totals.values()))}", "",
             "| Category | Amount (USD) |", "| --- | ---: |"]
    for category, cents in sorted(totals.items()):
        label = (category.replace("&", "&amp;").replace("<", "&lt;")
                 .replace(">", "&gt;").replace("\\", "&#92;")
                 .replace("|", "&#124;").replace("\r", " ").replace("\n", " "))
        lines.append(f"| {label} | {money(cents)} |")
    return "\n".join(lines) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    try:
        with localcontext() as context:
            context.prec = 40
            report = render(args.input)
        # Exclusive creation prevents accidentally overwriting an existing artifact.
        with args.output.open("x", encoding="utf-8", newline="\n") as handle:
            handle.write(report)
    except (ValueError, OSError) as error:
        parser.exit(1, f"error: {error}\n")


if __name__ == "__main__":
    main()
