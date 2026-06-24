from __future__ import annotations

import math
import subprocess
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


MYSQL = r"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
DB_NAME = "hotel_management"
DB_USER = "root"
DB_PASSWORD = "123456"
FONT_PATH = r"C:\Windows\Fonts\msyh.ttc"

ROOT = Path(r"D:\work\learning\DB_System\hotel_management")
OUTPUT_DIR = ROOT / "docs" / "assets" / "view_screenshots"

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


def shorten(text: str, limit: int = 24) -> str:
    if text is None:
        return ""
    text = str(text).replace("\r", " ").replace("\n", " ")
    return text if len(text) <= limit else text[: limit - 1] + "…"


def render_png(view_name: str, title: str, headers: list[str], rows: list[list[str]]) -> None:
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    title_font = ImageFont.truetype(FONT_PATH, 30)
    meta_font = ImageFont.truetype(FONT_PATH, 16)
    head_font = ImageFont.truetype(FONT_PATH, 16)
    cell_font = ImageFont.truetype(FONT_PATH, 14)

    draw_probe = ImageDraw.Draw(Image.new("RGB", (10, 10), "white"))
    clipped_headers = [shorten(col, 20) for col in headers]
    clipped_rows = [[shorten(cell, 28) for cell in row] for row in rows]

    col_widths: list[int] = []
    for idx, header in enumerate(clipped_headers):
        width = draw_probe.textbbox((0, 0), header, font=head_font)[2] + 30
        for row in clipped_rows:
            if idx < len(row):
                cell_width = draw_probe.textbbox((0, 0), row[idx], font=cell_font)[2] + 24
                width = max(width, cell_width)
        col_widths.append(min(max(width, 120), 260))

    table_width = sum(col_widths)
    page_width = min(max(table_width + 48, 1200), 2200)
    if table_width + 48 > page_width:
        scale = (page_width - 48) / table_width
        col_widths = [max(100, math.floor(width * scale)) for width in col_widths]
        table_width = sum(col_widths)

    header_h = 44
    row_h = 36
    top_h = 110
    footer_h = 38
    page_height = top_h + header_h + row_h * max(1, len(clipped_rows)) + footer_h + 24

    img = Image.new("RGB", (page_width, page_height), "#f5f7fb")
    draw = ImageDraw.Draw(img)

    draw.text((24, 24), title, fill="#111827", font=title_font)
    draw.text((24, 68), f"数据库: {DB_NAME}    视图: {view_name}    记录数: {len(rows)}", fill="#4b5563", font=meta_font)

    left = 24
    top = 104
    draw.rounded_rectangle((left, top, left + table_width, top + header_h + row_h * max(1, len(clipped_rows))), radius=8, fill="#ffffff", outline="#dbe2ea")

    x = left
    for idx, header in enumerate(clipped_headers):
        draw.rectangle((x, top, x + col_widths[idx], top + header_h), fill="#eaf1ff", outline="#dbe2ea")
        draw.text((x + 10, top + 11), header, fill="#0f172a", font=head_font)
        x += col_widths[idx]

    if not clipped_rows:
        draw.text((left + 12, top + header_h + 10), "No data", fill="#6b7280", font=cell_font)
    else:
        for row_index, row in enumerate(clipped_rows):
            y1 = top + header_h + row_index * row_h
            y2 = y1 + row_h
            fill = "#ffffff" if row_index % 2 == 0 else "#fbfdff"
            draw.rectangle((left, y1, left + table_width, y2), fill=fill, outline="#eef2f7")
            x = left
            for col_index, cell in enumerate(row):
                draw.text((x + 10, y1 + 9), cell, fill="#1f2937", font=cell_font)
                x += col_widths[col_index]

    draw.text((24, page_height - 28), "当前截图由本地 hotel_management 数据库的演示数据自动生成。", fill="#6b7280", font=meta_font)
    img.save(OUTPUT_DIR / f"{view_name}.png")


def main() -> None:
    for view_name, title in VIEWS:
        headers, rows = fetch_view_rows(view_name)
        render_png(view_name, title, headers, rows)
        print(f"generated {view_name}.png")


if __name__ == "__main__":
    main()
