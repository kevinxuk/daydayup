#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""生成孩子家务零花钱打卡表 Excel 文件（2026年9-12月）— 转置版：任务为行，日期为列"""

from openpyxl import Workbook
from openpyxl.styles import Font, Alignment, PatternFill, Border, Side
from openpyxl.utils import get_column_letter
import calendar

# ──────────────────────── 配置 ────────────────────────
OUTPUT_PATH = r"C:\Users\Administrator\.qoderworkcn\workspace\mrmv15mnxp6whu24\outputs\孩子家务零花钱打卡表_2026年8-12月_v2.xlsx"

MONTHS = [
    (8, 2026, "2026年8月"),
    (9, 2026, "2026年9月"),
    (10, 2026, "2026年10月"),
    (11, 2026, "2026年11月"),
    (12, 2026, "2026年12月"),
]

QUOTE_BY_MONTH = {
    8: "🌞 暑假尾声，收心准备，新学期加油！",
    9: "✨ 新学期，新习惯，每天进步一点点！",
    10: "🍂 秋高气爽，劳动最光荣，坚持就是胜利！",
    11: "🌸 期中将近，勤奋学习，快乐成长！",
    12: "⛄ 岁末将至，收获满满，迎接新的一年！",
}

# (分组名, 任务名, 金额, 是否仅周末)
TASKS = [
    ("🌅 晨间", "按时起床、叠好被子", "+1元", False),
    ("🌅 晨间", "整理床铺", "+0.5元", False),
    ("🌅 晨间", "吃早餐（不催促）", "+0.5元", False),
    ("🌅 晨间", "准备当天上学用品", "+0.5元", False),
    ("🏠 家务", "摆碗筷、收拾餐桌", "+1元", False),
    ("🏠 家务", "扫地/拖地（自己房间）", "+1元", False),
    ("🏠 家务", "倒垃圾（分类）", "+0.5元", False),
    ("🏠 家务", "擦桌子", "+0.5元", False),
    ("🏠 家务", "整理玩具/书籍", "+0.5元", False),
    ("🏠 家务", "周末：洗菜/择菜/洗袜子等", "+1~3元", True),
    ("📚 学习", "按时完成作业（无催促）", "+2元", False),
    ("📚 学习", "主动复习/预习", "+1元", False),
    ("📚 学习", "课外阅读30分钟", "+1元", False),
    ("📚 学习", "练字/书法练习", "+1元", False),
    ("📚 学习", "完成额外练习题", "+1元/套", False),
    ("📚 学习", "整理书包/学习资料", "+0.5元", False),
    ("📚 学习", "背单词/古诗词（10个）", "+0.5元", False),
    ("🏃 运动", "跳绳100下", "+1元", False),
    ("🏃 运动", "跑步/慢跑800米", "+1.5元", False),
    ("🏃 运动", "仰卧起坐30个", "+1元", False),
    ("🏃 运动", "坐位体前屈练习", "+0.5元", False),
    ("🏃 运动", "立定跳远练习", "+0.5元", False),
    ("🏃 运动", "开合跳/高抬腿（5分钟）", "+1元", False),
    ("🏃 运动", "球类运动（篮球/足球/乒乓球等）", "+1.5元", False),
]

# 分组颜色映射
GROUP_FILLS = {
    "🌅 晨间": PatternFill("solid", fgColor="FFF9E6"),   # 浅黄
    "🏠 家务": PatternFill("solid", fgColor="E8F4FD"),   # 浅蓝
    "📚 学习": PatternFill("solid", fgColor="E8F8F5"),   # 浅绿
    "🏃 运动": PatternFill("solid", fgColor="E8F8E8"),   # 浅绿（运动）
}

CHECKBOX = "☐"
WEEKDAY_CN = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]

thin = Side(style="thin", color="BBBBBB")
medium = Side(style="medium", color="888888")
thick = Side(style="thick", color="555555")

thin_border = Border(left=thin, right=thin, top=thin, bottom=thin)
cell_border = Border(left=thin, right=thin, top=thin, bottom=thin)
outer_left = Border(left=medium, right=thin, top=thin, bottom=thin)
outer_right = Border(left=thin, right=medium, top=thin, bottom=thin)
outer_top = Border(left=thin, right=thin, top=medium, bottom=thin)
outer_bottom = Border(left=thin, right=thin, top=thin, bottom=medium)
corner_tl = Border(left=medium, right=thin, top=medium, bottom=thin)
corner_tr = Border(left=thin, right=medium, top=medium, bottom=thin)
corner_bl = Border(left=medium, right=thin, top=thin, bottom=medium)
corner_br = Border(left=thin, right=medium, top=thin, bottom=medium)
full_outer = Border(left=medium, right=medium, top=medium, bottom=medium)

fill_title = PatternFill("solid", fgColor="FFF9E6")
fill_group_header = PatternFill("solid", fgColor="F0F0F0")
fill_weekend_header = PatternFill("solid", fgColor="FFE8E8")
fill_header = PatternFill("solid", fgColor="F8F8F8")

font_title = Font(name="微软雅黑", size=15, bold=True, color="333333")
font_info = Font(name="微软雅黑", size=10, color="555555")
font_group_label = Font(name="微软雅黑", size=10, bold=True, color="1a5276")
font_task = Font(name="微软雅黑", size=9, color="333333")
font_amount = Font(name="微软雅黑", size=8, color="888888")
font_day_header = Font(name="微软雅黑", size=8, bold=True, color="444444")
font_weekday_header = Font(name="微软雅黑", size=8, color="666666")
font_weekend_header = Font(name="微软雅黑", size=8, bold=True, color="c0392b")
font_total = Font(name="微软雅黑", size=10, bold=True, color="c0392b")
font_summary_label = Font(name="微软雅黑", size=11, bold=True, color="333333")
font_summary_value = Font(name="微软雅黑", size=11, color="555555")
font_quote = Font(name="微软雅黑", size=9, italic=True, color="888888")

align_center = Alignment(horizontal="center", vertical="center", wrap_text=True)
align_left = Alignment(horizontal="left", vertical="center", wrap_text=True)
align_right = Alignment(horizontal="right", vertical="center", wrap_text=True)


def set_col_widths(ws, num_days):
    """设置列宽：任务名列窄，日期列窄，合计列适中"""
    ws.column_dimensions["A"].width = 2   # 边距
    ws.column_dimensions["B"].width = 3.5  # 任务名
    ws.column_dimensions["C"].width = 3.5  # 金额
    for d in range(1, num_days + 1):
        ws.column_dimensions[get_column_letter(3 + d)].width = 2.8
    # 合计列
    total_col_letter = get_column_letter(3 + num_days + 1)
    ws.column_dimensions[total_col_letter].width = 4.5


def write_title_block(ws, month_num, year, num_days):
    """顶部标题、信息栏、激励语"""
    total_col = 3 + num_days + 1  # A空白 + B任务 + C金额 + 日期列 + T合计

    title_text = f"🌟 {year}年{month_num}月 · 家务零花钱打卡表 🌟"
    ws.merge_cells(start_row=1, start_column=1, end_row=1, end_column=total_col)
    cell = ws.cell(row=1, column=1, value=title_text)
    cell.font = font_title
    cell.fill = fill_title
    cell.alignment = align_center
    ws.row_dimensions[1].height = 30

    # 信息栏
    ws.merge_cells(start_row=2, start_column=1, end_row=2, end_column=5)
    ws.cell(row=2, column=1, value="班级：__________").font = font_info
    ws.cell(row=2, column=1).alignment = align_left
    ws.merge_cells(start_row=2, start_column=6, end_row=2, end_column=10)
    ws.cell(row=2, column=6, value="姓名：__________").font = font_info
    ws.cell(row=2, column=6).alignment = align_left
    ws.merge_cells(start_row=2, start_column=11, end_row=2, end_column=16)
    ws.cell(row=2, column=11, value=f"月份：{year}年{month_num}月").font = font_info
    ws.cell(row=2, column=11).alignment = align_left
    ws.merge_cells(start_row=2, start_column=17, end_row=2, end_column=total_col)
    ws.cell(row=2, column=17, value="家长签名：__________").font = font_info
    ws.cell(row=2, column=17).alignment = align_left
    ws.row_dimensions[2].height = 20

    # 激励语
    quote = QUOTE_BY_MONTH.get(month_num, "加油，你是最棒的！")
    ws.merge_cells(start_row=3, start_column=1, end_row=3, end_column=total_col)
    cell = ws.cell(row=3, column=1, value=quote)
    cell.font = font_quote
    cell.alignment = align_center
    ws.row_dimensions[3].height = 16

    # 空行
    ws.row_dimensions[4].height = 4


def write_header_rows(ws, year, month):
    """写入表头：星期行 + 日期行"""
    num_days = calendar.monthrange(year, month)[1]
    total_col = 3 + num_days + 1
    total_col_letter = get_column_letter(total_col)

    # 第5行：星期行
    ws.cell(row=5, column=1, value="").border = cell_border
    ws.cell(row=5, column=2, value="任务").font = Font(name="微软雅黑", size=9, bold=True, color="444444")
    ws.cell(row=5, column=2).alignment = align_center
    ws.cell(row=5, column=2).fill = fill_header
    ws.cell(row=5, column=2).border = cell_border
    ws.cell(row=5, column=3, value="金额").font = Font(name="微软雅黑", size=9, bold=True, color="444444")
    ws.cell(row=5, column=3).alignment = align_center
    ws.cell(row=5, column=3).fill = fill_header
    ws.cell(row=5, column=3).border = cell_border

    for day in range(1, num_days + 1):
        dt_col = 3 + day
        dt = __import__('datetime').date(year, month, day)
        weekday_idx = dt.weekday()
        is_weekend = weekday_idx >= 5

        cell = ws.cell(row=5, column=dt_col, value=WEEKDAY_CN[weekday_idx])
        cell.font = font_weekend_header if is_weekend else font_weekday_header
        cell.alignment = align_center
        cell.fill = fill_weekend_header if is_weekend else fill_header
        cell.border = cell_border

    # 合计列标题
    cell_total_title = ws.cell(row=5, column=total_col, value="合计")
    cell_total_title.font = Font(name="微软雅黑", size=9, bold=True, color="c0392b")
    cell_total_title.alignment = align_center
    cell_total_title.fill = fill_header
    cell_total_title.border = full_outer

    # 第6行：日期行
    ws.cell(row=6, column=1, value="").border = cell_border
    ws.cell(row=6, column=2, value="").border = cell_border
    ws.cell(row=6, column=3, value="").border = cell_border

    for day in range(1, num_days + 1):
        dt_col = 3 + day
        dt = __import__('datetime').date(year, month, day)
        is_weekend = dt.weekday() >= 5

        cell = ws.cell(row=6, column=dt_col, value=day)
        cell.font = font_weekend_header if is_weekend else font_day_header
        cell.alignment = align_center
        cell.fill = fill_weekend_header if is_weekend else fill_header
        cell.border = cell_border

    # 合计列
    ws.cell(row=6, column=total_col, value="").border = full_outer

    ws.row_dimensions[5].height = 18
    ws.row_dimensions[6].height = 20


def write_task_rows(ws, year, month):
    """写入任务行（转置版：每行一个任务，每列一天）"""
    num_days = calendar.monthrange(year, month)[1]
    total_col = 3 + num_days + 1
    total_col_letter = get_column_letter(total_col)

    # 当前行指针
    current_row = 7
    prev_group = None
    group_start_row = None

    for idx, (group, name, amount, weekend_only) in enumerate(TASKS):
        # 新分组开始：写入分组标题行
        if group != prev_group:
            if prev_group is not None:
                # 上一个分组结束，无需特别处理
                pass
            group_start_row = current_row
            prev_group = group

            # 分组标题行
            ws.merge_cells(start_row=current_row, start_column=2, end_row=current_row, end_column=3)
            cell = ws.cell(row=current_row, column=2, value=group)
            cell.font = font_group_label
            cell.fill = GROUP_FILLS.get(group, fill_group_header)
            cell.alignment = align_center
            cell.border = full_outer
            ws.cell(row=current_row, column=1, value="").border = full_outer
            ws.cell(row=current_row, column=1).fill = GROUP_FILLS.get(group, fill_group_header)

            # 日期列
            for day in range(1, num_days + 1):
                dt_col = 3 + day
                dt = __import__('datetime').date(year, month, day)
                is_weekend = dt.weekday() >= 5
                cell_day = ws.cell(row=current_row, column=dt_col, value="")
                cell_day.fill = fill_weekend_header if is_weekend else fill_header
                cell_day.border = cell_border

            # 合计列
            cell_ttl = ws.cell(row=current_row, column=total_col, value="")
            cell_ttl.border = full_outer
            ws.row_dimensions[current_row].height = 18
            current_row += 1

        # 任务行（单行：任务名 + 金额同行）
        group_fill = GROUP_FILLS.get(group, fill_group_header)
        task_fill = group_fill
        if weekend_only:
            # 周末专用任务：非周末日方框浅灰
            task_fill = PatternFill("solid", fgColor="F5F5F5")

        # B列：任务名（左对齐）
        cell_name = ws.cell(row=current_row, column=2, value=name)
        cell_name.font = font_task
        cell_name.alignment = Alignment(horizontal="left", vertical="center", wrap_text=False)
        cell_name.fill = group_fill
        cell_name.border = cell_border
        ws.cell(row=current_row, column=1, value="").border = cell_border
        ws.cell(row=current_row, column=1).fill = group_fill

        # C列：金额（居中，灰色小字）
        cell_amt = ws.cell(row=current_row, column=3, value=amount)
        cell_amt.font = font_amount
        cell_amt.alignment = align_center
        cell_amt.fill = group_fill
        cell_amt.border = cell_border

        # 每天一个方框
        for day in range(1, num_days + 1):
            dt_col = 3 + day
            dt = __import__('datetime').date(year, month, day)
            is_weekend = dt.weekday() >= 5

            # 周末专用任务且当天非周末：浅灰方框
            day_fill = task_fill
            if weekend_only and not is_weekend:
                day_fill = PatternFill("solid", fgColor="F5F5F5")

            cell = ws.cell(row=current_row, column=dt_col, value=CHECKBOX)
            cell.font = Font(name="Segoe UI Symbol", size=11, color="333333")
            cell.alignment = align_center
            cell.fill = day_fill
            cell.border = cell_border

        # 合计列
        cell_total = ws.cell(row=current_row, column=total_col, value="")
        cell_total.font = font_total
        cell_total.alignment = align_center
        cell_total.fill = group_fill
        cell_total.border = full_outer

        ws.row_dimensions[current_row].height = 18
        current_row += 1


def write_summary(ws, year, month, last_task_row):
    """底部结算栏"""
    summary_start = last_task_row + 2
    ws.merge_cells(start_row=summary_start, start_column=1, end_row=summary_start, end_column=5)
    ws.cell(row=summary_start, column=1, value="📊 本月结算").font = font_summary_label
    ws.row_dimensions[summary_start].height = 20

    labels = ["本月累计收入", "本月最大单日", "结余"]
    for i, label in enumerate(labels):
        r = summary_start + 1 + i
        ws.merge_cells(start_row=r, start_column=1, end_row=r, end_column=3)
        cell = ws.cell(row=r, column=1, value=f"{label}：")
        cell.font = font_summary_label
        cell.alignment = align_left
        ws.merge_cells(start_row=r, start_column=4, end_row=r, end_column=7)
        cell_val = ws.cell(row=r, column=4, value="")
        cell_val.font = font_summary_value
        cell_val.border = Border(bottom=thin)
        cell_val.alignment = align_left
        ws.row_dimensions[r].height = 18

    # 家长评语
    r_comment = summary_start + 4
    ws.merge_cells(start_row=r_comment, start_column=1, end_row=r_comment, end_column=4)
    ws.cell(row=r_comment, column=1, value="💬 家长评语：").font = font_summary_label
    ws.cell(row=r_comment, column=1).alignment = align_left
    ws.merge_cells(start_row=r_comment + 1, start_column=1, end_row=r_comment + 3, end_column=20)
    cell2 = ws.cell(row=r_comment + 1, column=1, value="")
    cell2.border = thin_border
    cell2.alignment = Alignment(horizontal="left", vertical="top", wrap_text=True)
    ws.row_dimensions[r_comment].height = 18
    ws.row_dimensions[r_comment + 1].height = 26
    ws.row_dimensions[r_comment + 2].height = 26
    ws.row_dimensions[r_comment + 3].height = 26


def setup_print(ws, num_days):
    """A4 横向打印设置"""
    total_col = 3 + num_days + 1
    ws.page_setup.orientation = "landscape"
    ws.page_setup.paperSize = 9  # A4
    ws.page_setup.fitToPage = True
    ws.page_setup.fitToWidth = 1
    ws.page_setup.fitToHeight = 1
    ws.print_area = f"A1:{get_column_letter(total_col)}{ws.max_row}"
    ws.page_margins.left = 0.4
    ws.page_margins.right = 0.4
    ws.page_margins.top = 0.5
    ws.page_margins.bottom = 0.5
    ws.print_options.gridLines = False


def create_sheet(ws, year, month, month_label):
    ws.title = month_label
    num_days = calendar.monthrange(year, month)[1]
    set_col_widths(ws, num_days)
    write_title_block(ws, month, year, num_days)
    write_header_rows(ws, year, month)
    write_task_rows(ws, year, month)

    # 计算最后一行
    last_task_row = 7 + len(TASKS) * 2 + len(set(t for t, *_ in TASKS))  # 大致估算
    # 更准确：找到最后写入的任务行
    import openpyxl
    last_task_row = 6
    for row in ws.iter_rows(min_row=7, max_row=ws.max_row):
        if any(c.value for c in row):
            last_task_row = max(last_task_row, row[0].row)

    write_summary(ws, year, month, last_task_row)
    setup_print(ws, num_days)
    ws.freeze_panes = "D7"  # 冻结任务列和金额列


def main():
    wb = Workbook()
    wb.remove(wb.active)

    for month, year, label in MONTHS:
        ws = wb.create_sheet()
        create_sheet(ws, year, month, label)

    wb.save(OUTPUT_PATH)
    print(f"✅ 文件已保存至：{OUTPUT_PATH}")


if __name__ == "__main__":
    main()
