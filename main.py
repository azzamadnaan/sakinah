import flet as ft
import requests
import base64

def main(page: ft.Page):
    page.title = "سكينة - Sakinah"
    page.rtl = True
    page.theme_mode = ft.ThemeMode.LIGHT
    page.bgcolor = "#FFFFFF"
    page.padding = 0

    # نظام الألوان الجديد المستوحى من المواصفات
    PRIMARY_COLOR = "#FFB6D9"  # وردي فاتح
    ACCENT_COLOR = "#E31B6D"   # وردي عميق
    TEXT_COLOR = "#333333"     # رمادي غامق للنصوص
    BG_SECONDARY = "#F5F5F5"   # رمادي فاتح للخلفيات

    # عناصر الشات الخاصة بالذكاء الاصطناعي (Gemini API)
    chat_messages = ft.Column(scroll=ft.ScrollMode.AUTO, expand=True)
    
    # 🔑 حقل إدخال مفتاح الـ API الذي ستقوم بوضعه هنا أو داخل التطبيق
    api_key_input = ft.TextField(
        label="AQ.Ab8RN6L3pAaZ-E1NOnd01dX4Bk_HY9EorAWAiguBfHQCNjrqqQ",
        password=True,
        can_reveal_password=True,
        border_color=PRIMARY_COLOR,
        text_size=13,
        bgcolor="#FFFFFF"
    )
    
    user_input = ft.TextField(
        label="اطرح سؤالاً إسلامياً أو استفساراً...",
        expand=True,
        border_color=PRIMARY_COLOR,
        multiline=True,
        max_lines=2
    )

    # عداد التسبيح
    tasbih_count = ft.Ref[ft.Text]()
    counter_value = [33]
    current_dhikr = ft.Ref[ft.Text]()
    dhikr_list = ["سبحان الله", "الحمد لله", "الله أكبر", "لا إله إلا الله"]
    dhikr_index = [0]

    def change_dhikr(e):
        dhikr_index[0] = (dhikr_index[0] + 1) % len(dhikr_list)
        current_dhikr.current.value = dhikr_list[dhikr_index[0]]
        counter_value[0] = 33
        tasbih_count.current.value = str(counter_value[0])
        page.update()

    def increment_tasbih(e):
        counter_value[0] += 1
        tasbih_count.current.value = str(counter_value[0])
        page.update()

    def decrement_tasbih(e):
        if counter_value[0] > 0:
            counter_value[0] -= 1
            tasbih_count.current.value = str(counter_value[0])
            page.update()

    # دالة إرسال الطلب الفعلي لـ Gemini API
    def send_ai_message(e):
        api_key = api_key_input.value.strip()
        message = user_input.value.strip()

        if not api_key:
            page.snack_bar = ft.SnackBar(ft.Text("الرجاء إدخال مفتاح الـ API في الحقل المخصص أولاً!"), bgcolor=ft.colors.RED_400)
            page.snack_bar.open = True
            page.update()
            return

        if not message:
            return

        # إضافة رسالة المستخدم للشات
        chat_messages.controls.append(
            ft.Row([ft.Container(content=ft.Text(message, color="#FFFFFF"), bgcolor=ACCENT_COLOR, padding=12, border_radius=10, max_width=280)], alignment=ft.MainAxisAlignment.END)
        )
        user_input.value = ""
        page.update()

        try:
            # ربط الـ API الحقيقي لـ Google Gemini
            url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"
            headers = {"Content-Type": "application/json"}
            payload = {
                "contents": [{
                    "parts": [{"text": "أنت مساعد إسلامي ذكي لتطبيق سكينة. أجب على السؤال التالي بناءً على الكتاب والسنة بشكل دقيق: " + message}]
                }]
            }
            
            response = requests.post(url, json=payload, headers=headers)
            if response.status_code == 200:
                res_data = response.json()
                reply = res_data["candidates"][0]["content"]["parts"][0]["text"]
            else:
                reply = f"خطأ في الاتصال بالخادم (كود: {response.status_code}). تأكد من صحة مفتاح الـ API."
        except Exception as ex:
            reply = f"حدث خطأ في الشبكة: {str(ex)}"

        # إضافة رد الذكاء الاصطناعي للشات
        chat_messages.controls.append(
            ft.Row([ft.Container(content=ft.Text(reply, color=TEXT_COLOR), bgcolor=BG_SECONDARY, padding=12, border_radius=10, max_width=280)], alignment=ft.MainAxisAlignment.START)
        )
        page.update()

    # شاشات التطبيق المختلفة
    home_view = ft.Column([
        ft.Text("السلام عليكم ورحمة الله وبركاته 🌙", size=20, weight=ft.FontWeight.BOLD, color=ACCENT_COLOR),
        ft.Container(
            content=ft.Column([
                ft.Text("أوقات الصلاة اليومية", weight=ft.FontWeight.BOLD, color=TEXT_COLOR),
                ft.Text("الفجر: 4:30 ص  |  الظهر: 12:00 م  |  العصر: 3:30 م | المغرب: 6:15 م", size=13, color="#666666")
            ]),
            bgcolor=BG_SECONDARY, padding=15, border_radius=10
        ),
        ft.Divider(),
        ft.Text("دعاء اليوم:", weight=ft.FontWeight.BOLD, color=TEXT_COLOR),
        ft.Text("«رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ»", italic=True, color=ACCENT_COLOR)
    ], spacing=15, padding=20)

    tasbih_view = ft.Column([
        ft.Text("التسبيح الرقمي", size=20, weight=ft.FontWeight.BOLD, color=ACCENT_COLOR),
        ft.Container(
            content=ft.Column([
                ft.Text(ref=current_dhikr, value="سبحان الله", size=22, weight=ft.FontWeight.BOLD, color=TEXT_COLOR),
                ft.Text(ref=tasbih_count, value="33", size=50, weight=ft.FontWeight.BOLD, color=ACCENT_COLOR),
                ft.Row([
                    ft.ElevatedButton("طرح (-1)", on_click=decrement_tasbih, bgcolor=BG_SECONDARY),
                    ft.ElevatedButton("إضافة (+1)", on_click=increment_tasbih, bgcolor=PRIMARY_COLOR, color=TEXT_COLOR),
                ], alignment=ft.MainAxisAlignment.CENTER),
                ft.TextButton("تغيير الذكر", on_click=change_dhikr)
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
            padding=30, bgcolor=BG_SECONDARY, border_radius=15, alignment=ft.alignment.center
        )
    ], alignment=ft.MainAxisAlignment.CENTER, horizontal_alignment=ft.CrossAxisAlignment.CENTER, padding=20)

    ai_view = ft.Column([
        ft.Text("المساعد الإسلامي الذكي (Gemini API)", size=18, weight=ft.FontWeight.BOLD, color=ACCENT_COLOR),
        api_key_input,
        ft.Container(content=chat_messages, expand=True, bgcolor=BG_SECONDARY, padding=10, border_radius=10),
        ft.Row([user_input, ft.IconButton(icon=ft.icons.SEND, icon_color=ACCENT_COLOR, on_click=send_ai_message)])
    ], expand=True, padding=20)

    # شاشة تحليل الصور (دعم كشف الوضعيات والدعم المحلي)
    vision_result = ft.Text("لم يتم تحليل أي صورة بعد.", color=TEXT_COLOR)
    
    def simulate_image_analysis(e):
        vision_result.value = "جاري تحليل الصورة عبر نموذج الذكاء الاصطناعي المحلي... النتيجة: تم كشف وضعية (السجود) بدقة 94%."
        page.update()

    vision_view = ft.Column([
        ft.Text("كشف وضعيات الصلاة من الصور", size=18, weight=ft.FontWeight.BOLD, color=ACCENT_COLOR),
        ft.Text("هنا يتم فحص وضعيات الركوع والسجود عبر معالجة الصور بالذكاء الاصطناعي.", size=13, color="#666666"),
        ft.ElevatedButton("اختر صورة أو التقط صورة للتحليل", icon=ft.icons.CAMERA_ALT, bgcolor=PRIMARY_COLOR, color=TEXT_COLOR, on_click=simulate_image_analysis),
        ft.Container(content=vision_result, padding=15, bgcolor=BG_SECONDARY, border_radius=10, margin=ft.margin.only(top=10))
    ], padding=20)

    body_container = ft.Container(content=home_view, expand=True)

    def navigation_change(e):
        index = e.control.selected_index
        if index == 0:
            body_container.content = home_view
        elif index == 1:
            body_container.content = tasbih_view
        elif index == 2:
            body_container.content = ai_view
        elif index == 3:
            body_container.content = vision_view
        page.update()

    page.navigation_bar = ft.NavigationBar(
        destinations=[
            ft.NavigationDestination(icon=ft.icons.HOME, label="الرئيسية"),
            ft.NavigationDestination(icon=ft.icons.FORMAT_LIST_BULLETED, label="التسبيح"),
            ft.NavigationDestination(icon=ft.icons.SMART_TOY, label="المساعد"),
            ft.NavigationDestination(icon=ft.icons.CAMERA, label="تحليل الصور"),
        ],
        selected_index=0,
        on_change=navigation_change,
        bgcolor=BG_SECONDARY
    )

    page.add(body_container)

ft.app(target=main)
  
