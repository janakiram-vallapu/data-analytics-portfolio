from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, PageBreak, Table, TableStyle,
    KeepTogether, ListFlowable, ListItem
)
from pathlib import Path

OUT = Path(r"C:\Users\janakiram\Documents\Data_Analytics_Portfolio\EXCEL\Automation\outputs\SmartBiz_Pro_Interview_Preparation_Guide.pdf")
OUT.parent.mkdir(parents=True, exist_ok=True)

NAVY = colors.HexColor("#16324F")
TEAL = colors.HexColor("#1F7A8C")
LIGHT = colors.HexColor("#EEF4F6")
MID = colors.HexColor("#D9E5E8")
TEXT = colors.HexColor("#1D2730")
MUTED = colors.HexColor("#5A6872")

styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name="CoverTitle", parent=styles["Title"], fontName="Helvetica-Bold", fontSize=25, leading=30, textColor=colors.white, alignment=TA_CENTER, spaceAfter=10))
styles.add(ParagraphStyle(name="CoverSub", parent=styles["Normal"], fontName="Helvetica", fontSize=12, leading=17, textColor=colors.white, alignment=TA_CENTER))
styles.add(ParagraphStyle(name="H1x", parent=styles["Heading1"], fontName="Helvetica-Bold", fontSize=17, leading=21, textColor=NAVY, spaceBefore=4, spaceAfter=10))
styles.add(ParagraphStyle(name="H2x", parent=styles["Heading2"], fontName="Helvetica-Bold", fontSize=12, leading=15, textColor=TEAL, spaceBefore=9, spaceAfter=5))
styles.add(ParagraphStyle(name="Bodyx", parent=styles["BodyText"], fontName="Helvetica", fontSize=9.5, leading=13.3, textColor=TEXT, spaceAfter=6))
styles.add(ParagraphStyle(name="Smallx", parent=styles["BodyText"], fontName="Helvetica", fontSize=8.2, leading=11, textColor=MUTED, spaceAfter=4))
styles.add(ParagraphStyle(name="Answer", parent=styles["BodyText"], fontName="Helvetica", fontSize=9.2, leading=13, textColor=TEXT, leftIndent=8, rightIndent=5, spaceAfter=8))
styles.add(ParagraphStyle(name="Question", parent=styles["Heading3"], fontName="Helvetica-Bold", fontSize=10.2, leading=13, textColor=NAVY, spaceBefore=5, spaceAfter=3))
styles.add(ParagraphStyle(name="Callout", parent=styles["BodyText"], fontName="Helvetica-Bold", fontSize=10, leading=14, textColor=NAVY, leftIndent=9, rightIndent=9, spaceBefore=5, spaceAfter=5))

def footer(canvas, doc):
    canvas.saveState()
    canvas.setStrokeColor(MID)
    canvas.line(18*mm, 14*mm, 192*mm, 14*mm)
    canvas.setFont("Helvetica", 7.5)
    canvas.setFillColor(MUTED)
    canvas.drawString(18*mm, 9*mm, "SmartBiz Pro - Interview Preparation Guide")
    canvas.drawRightString(192*mm, 9*mm, f"Page {doc.page}")
    canvas.restoreState()

def bullets(items, level=0):
    return ListFlowable(
        [ListItem(Paragraph(x, styles["Bodyx"]), leftIndent=10) for x in items],
        bulletType="bullet", start="-", leftIndent=14 + level*8,
        bulletFontName="Helvetica", bulletFontSize=7, bulletColor=TEAL,
        spaceAfter=5
    )

def callout(text):
    t = Table([[Paragraph(text, styles["Callout"]) ]], colWidths=[170*mm])
    t.setStyle(TableStyle([
        ("BACKGROUND", (0,0), (-1,-1), LIGHT),
        ("BOX", (0,0), (-1,-1), 0.8, TEAL),
        ("LEFTPADDING", (0,0), (-1,-1), 5),
        ("RIGHTPADDING", (0,0), (-1,-1), 5),
        ("TOPPADDING", (0,0), (-1,-1), 5),
        ("BOTTOMPADDING", (0,0), (-1,-1), 5),
    ]))
    return t

def qa(q, a):
    return KeepTogether([Paragraph(q, styles["Question"]), Paragraph(a, styles["Answer"])])

doc = SimpleDocTemplate(str(OUT), pagesize=A4, rightMargin=18*mm, leftMargin=18*mm, topMargin=17*mm, bottomMargin=19*mm, title="SmartBiz Pro Interview Preparation Guide", author="Janaki Ram Vallapu")
story = []

# Cover
cover = Table([[
    Paragraph("SMARTBIZ PRO", styles["CoverTitle"]),
], [
    Paragraph("Excel VBA Business Automation System<br/>Interview Preparation Guide", styles["CoverSub"])
]], colWidths=[174*mm], rowHeights=[42*mm, 25*mm])
cover.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,-1), NAVY),
    ("VALIGN", (0,0), (-1,-1), "MIDDLE"),
    ("ALIGN", (0,0), (-1,-1), "CENTER"),
    ("LINEBELOW", (0,0), (-1,0), 4, TEAL),
]))
story += [Spacer(1, 28*mm), cover, Spacer(1, 15*mm)]
story.append(Paragraph("Prepared for Data Analyst, Excel, MIS, Reporting, and Automation interviews", ParagraphStyle(name="center", parent=styles["Bodyx"], alignment=TA_CENTER, fontSize=11, leading=16, textColor=NAVY)))
story.append(Spacer(1, 12*mm))
story.append(callout("Core message: SmartBiz Pro is not only a dashboard. It is an end-to-end, macro-enabled business application that connects master data, transactions, inventory, invoicing, reporting, and automation inside Excel."))
story.append(Spacer(1, 28*mm))
story.append(Paragraph("Janaki Ram Vallapu", ParagraphStyle(name="name", parent=styles["Bodyx"], alignment=TA_CENTER, fontName="Helvetica-Bold", fontSize=12, textColor=NAVY)))
story.append(PageBreak())

# Summary
story.append(Paragraph("1. How to Explain the Project", styles["H1x"]))
story.append(Paragraph("Start with the business problem, then explain the solution, your technical contribution, the workflow, and the outcome. Avoid beginning with a list of worksheets or VBA procedures.", styles["Bodyx"]))

story.append(Paragraph("60-second version", styles["H2x"]))
story.append(callout("SmartBiz Pro is an end-to-end Excel VBA business automation system that I developed for small-business operations. It manages products, customers, suppliers, purchases, sales, inventory, invoices, dashboards, and reports in one macro-enabled workbook. I used Excel Tables as structured data stores, VBA UserForms for controlled data entry, and macros to generate IDs, update stock after purchases and sales, display low-stock alerts, generate multi-item invoices, and export them as PDFs. I also built a KPI dashboard with PivotTables and PivotCharts and created one-click refresh and navigation. The project demonstrates how I can combine data management, business logic, automation, validation, and reporting in Excel."))

story.append(Paragraph("Two-to-three-minute version", styles["H2x"]))
for text in [
    "<b>Problem:</b> Small businesses often maintain customers, products, purchases, sales, and invoices in separate manual files. This creates duplicate work, inconsistent records, stock errors, and slow reporting.",
    "<b>Solution:</b> I built SmartBiz Pro as a single Excel VBA application. The HOME sheet acts as the navigation center, while UserForms handle controlled entry for customers, suppliers, products, purchases, and sales.",
    "<b>Data structure:</b> I stored master and transaction records in named Excel Tables. Products, customers, and suppliers act as master data. Purchase and sales tables act as transaction data. The inventory view is refreshed from the current product stock.",
    "<b>Automation:</b> VBA generates sequential IDs, validates required inputs, saves records, updates product stock, flags low or out-of-stock items, generates invoices from sales records, combines multiple products sharing one invoice number, and exports invoices as one-page PDFs.",
    "<b>Reporting:</b> The dashboard displays sales, customers, inventory value, stock alerts, purchases, invoice count, and paid purchases. PivotCharts show sales by product and purchases by supplier, with a macro-driven refresh workflow.",
    "<b>Result:</b> The project converts a manual spreadsheet process into a controlled business workflow and demonstrates Excel, VBA, UserForms, validation, data modeling, reporting, debugging, and user-focused design."
]:
    story.append(Paragraph(text, styles["Bodyx"]))

story.append(Paragraph("Best presentation sequence", styles["H2x"]))
story.append(bullets([
    "Business problem and target user",
    "Application architecture and data tables",
    "UserForms and validation",
    "Purchase-to-stock and sale-to-stock logic",
    "Invoice and PDF automation",
    "Dashboard and reporting",
    "Challenges, testing, and improvements"
]))
story.append(PageBreak())

# Architecture
story.append(Paragraph("2. Architecture and Workflow", styles["H1x"]))
data = [
    ["Layer", "Components", "Purpose"],
    ["Navigation", "HOME, User Guide, Report Center", "Provides a clear starting point and controlled access to modules."],
    ["Master data", "Products, Customers, Suppliers", "Maintains reusable business entities with generated IDs and status fields."],
    ["Transactions", "Purchases, Sales", "Records business activity and drives stock movement and financial totals."],
    ["Operations", "Inventory, alerts", "Shows current stock, reorder levels, stock status, pricing, and inventory value."],
    ["Documents", "Invoice, PDF export", "Combines invoice lines, customer data, totals, print setup, and PDF generation."],
    ["Analytics", "KPIs, PivotTables, PivotCharts", "Summarizes operational performance and refreshes from source tables."],
]
t = Table([[Paragraph(str(c), styles["Smallx"]) for c in row] for row in data], colWidths=[29*mm, 54*mm, 87*mm], repeatRows=1)
t.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), NAVY), ("TEXTCOLOR", (0,0), (-1,0), colors.white),
    ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"), ("VALIGN", (0,0), (-1,-1), "TOP"),
    ("GRID", (0,0), (-1,-1), 0.4, MID), ("ROWBACKGROUNDS", (0,1), (-1,-1), [colors.white, LIGHT]),
    ("LEFTPADDING", (0,0), (-1,-1), 5), ("RIGHTPADDING", (0,0), (-1,-1), 5),
    ("TOPPADDING", (0,0), (-1,-1), 5), ("BOTTOMPADDING", (0,0), (-1,-1), 5),
]))
story += [t, Spacer(1, 7*mm)]

story.append(Paragraph("Transaction logic", styles["H2x"]))
story.append(bullets([
    "Purchase saved -> purchase transaction recorded -> product Current Stock increases -> inventory refresh displays the new quantity and value.",
    "Sale saved -> one or more sales lines recorded under the same Invoice Number -> product Current Stock decreases -> stock status is recalculated.",
    "Invoice generated -> selected sales row supplies the Invoice Number -> all matching sales lines are loaded -> customer details and totals are displayed -> PDF export uses the configured print area.",
    "Dashboard refreshed -> inventory refresh runs -> PivotTables and charts refresh -> KPI formulas recalculate -> Dashboard opens."
]))

story.append(Paragraph("Key controls and validations", styles["H2x"]))
story.append(bullets([
    "Required-field checks before saving records",
    "Automatic sequential IDs and invoice numbers",
    "Active customer, supplier, and product selections",
    "Stock status classification using Current Stock and Reorder Level",
    "Selection validation before invoice generation",
    "One-page A4 invoice print area and export path checks"
]))

story.append(Paragraph("Honest limitations", styles["H2x"]))
story.append(bullets([
    "The invoice template currently supports up to 10 product lines.",
    "Payment status, payment method, and notes are not stored in the sales table, so those invoice fields remain blank.",
    "The solution is designed for desktop Excel because VBA does not run in Excel for the web.",
    "For a larger multi-user system, I would migrate the data layer to a database and add authentication, concurrency control, and audit reporting."
]))
story.append(PageBreak())

# Q&A 1
story.append(Paragraph("3. Interview Questions and Strong Answers", styles["H1x"]))
story.append(qa("1. Why did you build this project?", "I wanted to solve a realistic business problem rather than build only a static dashboard. Small businesses need connected workflows for master data, purchasing, sales, inventory, invoices, and reporting. SmartBiz Pro allowed me to demonstrate both analytical skills and process automation in one application."))
story.append(qa("2. Why did you choose Excel and VBA?", "Excel is widely used in small and medium businesses, but manual spreadsheets are error-prone. VBA allowed me to add controlled forms, validation, workflow logic, stock updates, document generation, and one-click refresh while keeping the solution accessible to Excel users."))
story.append(qa("3. How is the workbook structured?", "I separated it into master-data tables, transaction tables, operational views, and reporting layers. Products, customers, and suppliers are master data. Purchases and sales are transactions. Inventory is an operational view driven by product stock. Invoice, Dashboard, and Reports consume the structured data."))
story.append(qa("4. How did you maintain data consistency?", "I used named Excel Tables, generated IDs, controlled ComboBox selections, required-field validation, and a single save workflow for each transaction. VBA writes values into defined table columns and updates the related product stock as part of the same business process."))
story.append(qa("5. How does inventory update after a purchase?", "When a purchase is saved, the transaction is written to the purchase table. The macro locates the selected product by Product ID and increases its Current Stock by the purchase quantity. RefreshInventory then rebuilds the inventory view and recalculates stock status and stock value."))
story.append(qa("6. How does a sale affect stock?", "The sales form supports multiple items under one invoice number. After validation, each item is saved as a separate sales row and its quantity is deducted from the related product's Current Stock. The refreshed inventory then shows the revised quantity and stock status."))
story.append(qa("7. How are multi-item invoices handled?", "Every line in one transaction shares the same Invoice Number. When the user selects any sales row and generates an invoice, VBA finds all sales rows with that Invoice Number and loads them into the invoice item area. It then calculates subtotal, discount, tax, and grand total."))
story.append(qa("8. How did you generate the PDF?", "I configured a fixed invoice print area, A4 portrait layout, narrow margins, and one-page scaling. VBA uses ExportAsFixedFormat to save the invoice as a PDF in an Invoices folder, using the invoice number as the filename."))
story.append(PageBreak())

# Q&A 2
story.append(Paragraph("4. Technical and Behavioral Follow-ups", styles["H1x"]))
story.append(qa("9. How does the stock alert work?", "RefreshInventory compares Current Stock with Reorder Level. A quantity of zero or below is Out of Stock, a positive quantity at or below the reorder level is Low Stock, and a higher quantity is In Stock. The system counts these statuses and displays an alert message."))
story.append(qa("10. How does the Dashboard refresh?", "The refresh macro first refreshes inventory without showing a duplicate message. It then refreshes the workbook's PivotTables, recalculates the Dashboard formulas, activates the Dashboard sheet, and confirms completion. This keeps KPIs and charts synchronized with the source tables."))
story.append(qa("11. What was the most difficult part?", "The main challenge was connecting multiple workflows safely: purchases must increase stock, sales must decrease it, multi-item sales must share one invoice number, and invoices and dashboards must read the correct rows. I solved this by testing one module at a time, using stable table and control names, and validating each transition with sample records."))
story.append(qa("12. Describe an error you fixed.", "One UserForm initialization procedure accidentally contained controls belonging to a different form, which caused an Object Required error. I traced the failing event, restored the correct form and control names, replaced the initialization logic with the proper controls, compiled the VBA project, and retested the workflow."))
story.append(qa("13. How did you test the solution?", "I tested create and save operations for every master and transaction form, verified generated IDs, compared purchase and sales quantities with product stock, checked low-stock alerts, generated a multi-item invoice, exported the PDF, reopened the workbook with macros enabled, and confirmed every HOME navigation button."))
story.append(qa("14. What would you improve next?", "I would add editing and deletion with audit controls, store payment method and status in sales, support variable invoice lengths, add role-based access, create date-based dashboard filters, improve exception logging, and move the data layer to SQL for multi-user scale."))
story.append(qa("15. What did this project teach you?", "It taught me to think beyond individual formulas. I had to design data structures, user workflows, validation, business rules, debugging steps, reporting, documentation, and usability as one connected system."))

story.append(Paragraph("Questions you can ask the interviewer", styles["H2x"]))
story.append(bullets([
    "Which business processes currently depend most heavily on Excel?",
    "Does the team use VBA, Power Query, Power BI, SQL, or a combination for reporting automation?",
    "What data-quality or recurring-reporting problems would you want the successful candidate to improve first?"
]))
story.append(PageBreak())

# Cheat sheet
story.append(Paragraph("5. Final Interview Cheat Sheet", styles["H1x"]))
cheat = [
    ["Prompt", "Your key point"],
    ["What is it?", "An end-to-end Excel VBA application for business operations and reporting."],
    ["Main users", "Small-business operators who need one controlled workbook instead of disconnected manual files."],
    ["Core technologies", "Excel, VBA, UserForms, Excel Tables, structured formulas, PivotTables, PivotCharts, and PDF export."],
    ["Best feature", "Connected purchase, sales, inventory, invoice, and dashboard workflow."],
    ["Strongest technical point", "Multi-item transaction logic with stock updates and invoice grouping by Invoice Number."],
    ["Strongest business point", "Reduces duplicate entry, improves stock visibility, and accelerates invoice and KPI reporting."],
    ["Challenge", "Keeping form controls, tables, transaction logic, and downstream reporting synchronized."],
    ["Limitation", "Desktop Excel, 10 invoice lines, and payment fields not yet stored in sales."],
    ["Next version", "SQL backend, access control, audit log, editing workflows, dynamic invoices, and date filters."],
]
ct = Table([[Paragraph(str(c), styles["Smallx"]) for c in row] for row in cheat], colWidths=[42*mm, 128*mm], repeatRows=1)
ct.setStyle(TableStyle([
    ("BACKGROUND", (0,0), (-1,0), NAVY), ("TEXTCOLOR", (0,0), (-1,0), colors.white),
    ("FONTNAME", (0,0), (-1,0), "Helvetica-Bold"), ("VALIGN", (0,0), (-1,-1), "TOP"),
    ("GRID", (0,0), (-1,-1), 0.4, MID), ("ROWBACKGROUNDS", (0,1), (-1,-1), [colors.white, LIGHT]),
    ("LEFTPADDING", (0,0), (-1,-1), 5), ("RIGHTPADDING", (0,0), (-1,-1), 5),
    ("TOPPADDING", (0,0), (-1,-1), 5), ("BOTTOMPADDING", (0,0), (-1,-1), 5),
]))
story += [ct, Spacer(1, 8*mm)]
story.append(callout("Final advice: explain what you personally designed and tested. Use the workbook as evidence, but focus on the business logic and decisions. If you do not remember an exact VBA statement, explain the logic clearly instead of guessing."))

story.append(Paragraph("Before the interview", styles["H2x"]))
story.append(bullets([
    "Keep the workbook and GitHub repository ready, but do not depend on a live demo unless requested.",
    "Practice the 60-second explanation until it sounds natural rather than memorized.",
    "Be ready to explain one bug, one design decision, one limitation, and one future improvement.",
    "Review the table names, major macros, inventory rules, and invoice calculation once before the interview."
]))

doc.build(story, onFirstPage=footer, onLaterPages=footer)
print(OUT)
