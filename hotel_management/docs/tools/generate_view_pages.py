from __future__ import annotations

import html
import subprocess
from pathlib import Path


MYSQL = r"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
DB_NAME = "hotel_management"
DB_USER = "root"
DB_PASSWORD = "123456"

ROOT = Path(r"D:\work\learning\DB_System\hotel_management")
OUTPUT_DIR = ROOT / "docs" / "assets" / "view_pages"

VIEWS = [
    ("v_room_inventory_overview", "客房库存总览视图"),
    ("v_room_daily_status", "客房日常状态视图"),
    ("v_booking_detail", "预订明细视图"),
    ("v_checkin_guest_detail", "入住客人明细视图"),
    ("v_bill_payment_summary", "账单支付汇总视图"),
    ("v_monthly_revenue_report", "月度营收统计视图"),
    ("v_employee_operation_summary", "员工业务汇总视图"),
    ("v_customer_value_profile", "客户价值画像视图"),
    ("v_housekeeping_task_detail", "客房清扫任务视图"),
    ("v_employee_performance_detail", "员工考核明细视图"),
]


def fetch_view_rows(view_name: str) -> tuple[list[str], list[list[str]]]:
    query = f"SELECT * FROM `{view_name}`;"
    result = subprocess.run(
        [
            MYSQL,
            "--default-character-set=utf8mb4",
            "-u",
            DB_USER,
            f"-p{DB_PASSWORD}",
            "-D",
            DB_NAME,
            "--batch",
            "--raw",
            "-e",
            query,
        ],
        check=True,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    lines = [line.rstrip("\n") for line in result.stdout.splitlines() if line.strip()]
    if not lines:
        return [], []
    headers = lines[0].split("\t")
    rows = [line.split("\t") for line in lines[1:]]
    return headers, rows


def render_table(headers: list[str], rows: list[list[str]]) -> str:
    thead = "".join(f"<th>{html.escape(col)}</th>" for col in headers)
    body_rows = []
    for row in rows:
        tds = "".join(f"<td>{html.escape(cell)}</td>" for cell in row)
        body_rows.append(f"<tr>{tds}</tr>")
    tbody = "\n".join(body_rows) if body_rows else "<tr><td colspan='99'>No data</td></tr>"
    return f"""
    <table>
      <thead>
        <tr>{thead}</tr>
      </thead>
      <tbody>
        {tbody}
      </tbody>
    </table>
    """


def build_html(view_name: str, title: str, headers: list[str], rows: list[list[str]]) -> str:
    count = len(rows)
    return f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{html.escape(title)}</title>
  <style>
    :root {{
      color-scheme: light;
      --bg: #f5f7fb;
      --panel: #ffffff;
      --text: #1f2937;
      --subtle: #6b7280;
      --line: #dbe2ea;
      --head: #eef4ff;
      --accent: #2563eb;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: "Microsoft YaHei", "PingFang SC", Arial, sans-serif;
      background: var(--bg);
      color: var(--text);
    }}
    .page {{
      width: min(1600px, calc(100vw - 32px));
      margin: 0 auto;
      padding: 28px 28px 32px;
    }}
    .hero {{
      display: flex;
      justify-content: space-between;
      align-items: end;
      gap: 24px;
      margin-bottom: 18px;
    }}
    .title {{
      margin: 0;
      font-size: 30px;
      line-height: 1.2;
    }}
    .meta {{
      display: flex;
      gap: 14px;
      flex-wrap: wrap;
      color: var(--subtle);
      font-size: 14px;
      margin-top: 10px;
    }}
    .badge {{
      border: 1px solid var(--line);
      background: var(--panel);
      border-radius: 8px;
      padding: 8px 12px;
      min-width: 120px;
    }}
    .table-wrap {{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 12px 24px rgba(15, 23, 42, 0.06);
    }}
    table {{
      width: 100%;
      border-collapse: collapse;
      table-layout: auto;
      font-size: 13px;
    }}
    thead th {{
      background: var(--head);
      color: #0f172a;
      text-align: left;
      padding: 12px 10px;
      border-bottom: 1px solid var(--line);
      white-space: nowrap;
    }}
    tbody td {{
      padding: 10px;
      border-bottom: 1px solid var(--line);
      vertical-align: top;
      word-break: break-word;
    }}
    tbody tr:nth-child(even) {{
      background: #fbfdff;
    }}
    .footnote {{
      margin-top: 12px;
      color: var(--subtle);
      font-size: 12px;
    }}
    .accent {{
      color: var(--accent);
      font-weight: 600;
    }}
  </style>
</head>
<body>
  <div class="page">
    <div class="hero">
      <div>
        <h1 class="title">{html.escape(title)}</h1>
        <div class="meta">
          <div class="badge">数据库：<span class="accent">{DB_NAME}</span></div>
          <div class="badge">视图名：<span class="accent">{html.escape(view_name)}</span></div>
          <div class="badge">记录数：<span class="accent">{count}</span></div>
        </div>
      </div>
    </div>
    <div class="table-wrap">
      {render_table(headers, rows)}
    </div>
    <div class="footnote">截图生成时间对应当前本地数据库中的演示数据，用于课程设计报告附图。</div>
  </div>
</body>
</html>
"""


def main() -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for view_name, title in VIEWS:
      headers, rows = fetch_view_rows(view_name)
      html_text = build_html(view_name, title, headers, rows)
      (OUTPUT_DIR / f"{view_name}.html").write_text(html_text, encoding="utf-8")
      print(f"generated {view_name}.html")


if __name__ == "__main__":
    main()
