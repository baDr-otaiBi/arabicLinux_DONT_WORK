#!/bin/bash
# ===================================================================
# برنامج إدارة المستخدمين
# ===================================================================
#
# الوصف: هذا البرنامج يوفر نظام بسيط لإدارة المستخدمين في التوزيعة
#         ويشمل عمليات إضافة وحذف وعرض معلومات المستخدمين
#
# الاستخدام: ./إدارة_المستخدمين.sh [الأمر] [اسم_المستخدم]
#
# ===================================================================

# ===================================================================
# الإعدادات
# ===================================================================

# مسار قاعدة بيانات المستخدمين
masar_almustakhdimin="$HOME/.مستخدمون_عرب"

# إنشاء المسار إذا لم يكن موجوداً
mkdir -p "$masar_almustakhdimin"

# ===================================================================
# الدوال المساعدة
# ===================================================================

# دالة عرض رسالة
earad_risalah() {
    local alnaw="$1"
    local alrisalah="$2"
    
    case "$alnaw" in
        "معلومات")
            echo "[معلومات] $alrisalah"
            ;;
        "نجاح")
            echo "[نجاح] $alrisalah"
            ;;
        "خطأ")
            echo "[خطأ] $alrisalah"
            ;;
        "تحذير")
            echo "[تحذير] $alrisalah"
            ;;
    esac
}

# دالة عرض المساعدة
earad_almusaeadah() {
    echo "═══════════════════════════════════════════════════════════"
    echo "           برنامج إدارة المستخدمين"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "الاستخدام:"
    echo "  $0 [الأمر] [اسم_المستخدم]"
    echo ""
    echo "الأوامر المتاحة:"
    echo ""
    echo "  إضافة | add [اسم_المستخدم]"
    echo "    - إضافة مستخدم جديد للنظام"
    echo ""
    echo "  حذف | delete [اسم_المستخدم]"
    echo "    - حذف مستخدم من النظام"
    echo ""
    echo "  معلومات | info [اسم_المستخدم]"
    echo "    - عرض معلومات المستخدم"
    echo ""
    echo "  قائمة | list"
    echo "    - عرض قائمة جميع المستخدمين"
    echo ""
    echo "  مساعدة | help"
    echo "    - عرض هذه الرسالة"
    echo ""
}

# ===================================================================
# دوال العمليات
# ===================================================================

# دالة إضافة مستخدم
idafat_mustakhdim() {
    local ism_almustakhdim="$1"
    
    if [ -z "$ism_almustakhdim" ]; then
        earad_risalah "خطأ" "يجب تحديد اسم المستخدم"
        return 1
    fi
    
    # التحقق من وجود المستخدم
    if [ -f "$masar_almustakhdimin/$ism_almustakhdim.conf" ]; then
        earad_risalah "خطأ" "المستخدم '$ism_almustakhdim' موجود بالفعل"
        return 1
    fi
    
    earad_risalah "معلومات" "جاري إضافة المستخدم: $ism_almustakhdim"
    
    # إنشاء ملف معلومات المستخدم
    cat > "$masar_almustakhdimin/$ism_almustakhdim.conf" << EOF
# ملف معلومات المستخدم
# المستخدم: $ism_almustakhdim

ism_almustakhdim="$ism_almustakhdim"
tarikh_alinsha="$(date '+%Y-%m-%d %H:%M:%S')"
almajmueat="مستخدمون"
alsalahiat="عادي"
alhalah="نشط"

# نهاية الملف
EOF
    
    # إنشاء مجلد المستخدم
    mkdir -p "$masar_almustakhdimin/مجلدات/$ism_almustakhdim"
    
    earad_risalah "نجاح" "تم إضافة المستخدم '$ism_almustakhdim' بنجاح"
    echo "  المجلد الشخصي: $masar_almustakhdimin/مجلدات/$ism_almustakhdim"
}

# دالة حذف مستخدم
hadf_mustakhdim() {
    local ism_almustakhdim="$1"
    
    if [ -z "$ism_almustakhdim" ]; then
        earad_risalah "خطأ" "يجب تحديد اسم المستخدم"
        return 1
    fi
    
    # التحقق من وجود المستخدم
    if [ ! -f "$masar_almustakhdimin/$ism_almustakhdim.conf" ]; then
        earad_risalah "خطأ" "المستخدم '$ism_almustakhdim' غير موجود"
        return 1
    fi
    
    earad_risalah "معلومات" "جاري حذف المستخدم: $ism_almustakhdim"
    
    # حذف ملف المستخدم
    rm -f "$masar_almustakhdimin/$ism_almustakhdim.conf"
    
    # حذف مجلد المستخدم (اختياري)
    if [ -d "$masar_almustakhdimin/مجلدات/$ism_almustakhdim" ]; then
        rm -rf "$masar_almustakhdimin/مجلدات/$ism_almustakhdim"
    fi
    
    earad_risalah "نجاح" "تم حذف المستخدم '$ism_almustakhdim' بنجاح"
}

# دالة عرض معلومات المستخدم
earad_maelumat_almustakhdim() {
    local ism_almustakhdim="$1"
    
    if [ -z "$ism_almustakhdim" ]; then
        earad_risalah "خطأ" "يجب تحديد اسم المستخدم"
        return 1
    fi
    
    # التحقق من وجود المستخدم
    if [ ! -f "$masar_almustakhdimin/$ism_almustakhdim.conf" ]; then
        earad_risalah "خطأ" "المستخدم '$ism_almustakhdim' غير موجود"
        return 1
    fi
    
    earad_risalah "معلومات" "معلومات المستخدم: $ism_almustakhdim"
    echo ""
    
    # تحميل معلومات المستخدم
    source "$masar_almustakhdimin/$ism_almustakhdim.conf"
    
    echo "  اسم المستخدم: $ism_almustakhdim"
    echo "  تاريخ الإنشاء: $tarikh_alinsha"
    echo "  المجموعة: $almajmueat"
    echo "  الصلاحيات: $alsalahiat"
    echo "  الحالة: $alhalah"
    echo ""
}

# دالة عرض قائمة المستخدمين
earad_qaeimah_almustakhdimin() {
    earad_risalah "معلومات" "قائمة المستخدمين في النظام:"
    echo ""
    
    local eadad=0
    
    # البحث عن ملفات المستخدمين
    for milaf in "$masar_almustakhdimin"/*.conf; do
        if [ -f "$milaf" ]; then
            source "$milaf"
            echo "  $ism_almustakhdim - $almajmueat ($alhalah)"
            ((eadad++))
        fi
    done
    
    if [ $eadad -eq 0 ]; then
        echo "  لا يوجد مستخدمون في النظام"
    else
        echo ""
        echo "  إجمالي المستخدمين: $eadad"
    fi
    echo ""
}

# ===================================================================
# البرنامج الرئيسي
# ===================================================================

albarnami_alrayisiu() {
    local alamr="$1"
    local almueamil="$2"
    
    case "$alamr" in
        "إضافة"|"add")
            idafat_mustakhdim "$almueamil"
            ;;
        "حذف"|"delete")
            hadf_mustakhdim "$almueamil"
            ;;
        "معلومات"|"info")
            earad_maelumat_almustakhdim "$almueamil"
            ;;
        "قائمة"|"list")
            earad_qaeimah_almustakhdimin
            ;;
        "مساعدة"|"help"|"")
            earad_almusaeadah
            ;;
        *)
            earad_risalah "خطأ" "أمر غير معروف: $alamr"
            echo ""
            earad_almusaeadah
            return 1
            ;;
    esac
}

# ===================================================================
# تشغيل البرنامج
# ===================================================================

albarnami_alrayisiu "$@"

# ===================================================================
# نهاية البرنامج
# ===================================================================
