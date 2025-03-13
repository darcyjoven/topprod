# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_per_free.4gl
# Descriptions...: 自由格式輸入設定
# Date & Author..: 05/05/21 alex
# Modify.........: No.FUN-560197 05/06/23 by saki 增加多單位顯示
# Modify.........: No.FUN-560243 05/06/28 by saki 增加多單位欄位-料件編號
# Modify.........: No.TQC-630256 06/03/27 by saki 修改多語言參照欄位的檢查
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE gc_sel          RECORD
         stle_show     LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
         amt_show      LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
         rate_show     LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
         rate_fld      STRING,
         text_show     LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
         itme_show     LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
         itme_tab      STRING,
         itme_fld      STRING,
         itme_relat    STRING,
         itme_eft      STRING,
         stle_fld      STRING,
         multi_unit    LIKE type_file.chr1,    #FUN-680135  VARCHAR(1)  #No.FUN-560197 --start--
         qty2_fld      STRING,
         unit2_fld     STRING,
         rate2_fld     STRING,
         qty1_fld      STRING,
         unit1_fld     STRING,
         rate1_fld     STRING,
         unit_fld      STRING,   #No.FUN-560197 ---end---
         itemno_fld    STRING    #No.FUN-560243
                   END RECORD
DEFINE gs_style        STRING
 
FUNCTION p_per_free(ls_style)
 
   DEFINE ls_style     STRING
   DEFINE lc_gaq01     LIKE gaq_file.gaq01
   DEFINE li_count     LIKE type_file.num5   #FUN-680135 SMALLINT
 
   LET gs_style = ls_style.trim()
 
   OPEN WINDOW p_per_free_w WITH FORM "azz/42f/p_per_free"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_per_free")
   CALL p_per_free_setting()
 
   INPUT BY NAME gc_sel.* WITHOUT DEFAULTS ATTRIBUTE (UNBUFFERED)
 
      ON CHANGE stle_show
         IF gc_sel.stle_show = "N" THEN
            LET gc_sel.amt_show  = "N"
            LET gc_sel.rate_show = "N"
            LET gc_sel.rate_fld  = ""
            LET gc_sel.text_show = "N"
            LET gc_sel.itme_show = "N"
            LET gc_sel.itme_tab  = ""
            LET gc_sel.itme_fld  = ""
            LET gc_sel.itme_relat= ""
            LET gc_sel.itme_eft  = ""
         END IF
 
      ON CHANGE amt_show
         IF gc_sel.amt_show = "Y" THEN
            LET gc_sel.stle_show = "Y"
            IF gc_sel.text_show = "Y" OR gc_sel.itme_show = "Y" THEN
               CALL cl_err(" ","azz-117",1)
               LET gc_sel.text_show = "N" LET gc_sel.itme_show = "N"
               LET gc_sel.itme_tab = ""
               LET gc_sel.itme_fld = ""
               LET gc_sel.itme_relat = ""
               LET gc_sel.itme_eft = ""
            END IF
         END IF
 
      ON CHANGE rate_show
         IF gc_sel.rate_show = "N" THEN
            LET gc_sel.rate_fld  = ""
         ELSE
            LET gc_sel.stle_show = "Y"
            IF gc_sel.text_show = "Y" OR gc_sel.itme_show = "Y" THEN
               CALL cl_err(" ","azz-117",1)
               LET gc_sel.text_show = "N" LET gc_sel.itme_show = "N"
               LET gc_sel.itme_tab = ""
               LET gc_sel.itme_fld = ""
               LET gc_sel.itme_relat = ""
               LET gc_sel.itme_eft = ""
            END IF
         END IF
 
      ON CHANGE text_show
         IF gc_sel.text_show = "Y" THEN
            LET gc_sel.stle_show = "Y"
            IF gc_sel.amt_show = "Y" OR gc_sel.rate_show = "Y" OR gc_sel.itme_show = "Y" THEN
               CALL cl_err(" ","azz-117",1)
               LET gc_sel.amt_show = "N"
               LET gc_sel.rate_show = "N"
               LET gc_sel.rate_fld = ""
               LET gc_sel.itme_show = "N"
               LET gc_sel.itme_tab = ""
               LET gc_sel.itme_fld = ""
               LET gc_sel.itme_relat = ""
               LET gc_sel.itme_eft = ""
               LET gc_sel.stle_fld = ""
            END IF
         END IF
 
      AFTER FIELD rate_fld
         LET lc_gaq01 = gc_sel.rate_fld
         LET li_count = 0
         IF NOT cl_null(gc_sel.rate_fld) THEN
            SELECT count(*) INTO li_count FROM gaq_file WHERE gaq01=lc_gaq01
            IF SQLCA.SQLCODE OR li_count <= 1 THEN
               CALL cl_err(gc_sel.rate_fld,"azz-116",1)
               NEXT FIELD rate_fld
            END IF
            LET gc_sel.stle_show = "Y"
            LET gc_sel.rate_show = "Y"
         END IF
 
      ON CHANGE itme_show
         IF gc_sel.itme_show = "N" THEN
            LET gc_sel.itme_tab  = ""
            LET gc_sel.itme_fld  = ""
            LET gc_sel.itme_relat= ""
            LET gc_sel.itme_eft  = ""
         ELSE
            LET gc_sel.stle_show = "Y"
            IF gc_sel.amt_show = "Y" OR gc_sel.rate_show = "Y" OR gc_sel.text_show = "Y" THEN
               CALL cl_err(" ","azz-117",1)
               LET gc_sel.amt_show = "N"
               LET gc_sel.rate_show = "N"
               LET gc_sel.rate_fld = ""
               LET gc_sel.text_show = "N"
               LET gc_sel.stle_fld = ""
            END IF
         END IF
 
      AFTER FIELD itme_tab
         IF NOT cl_null(gc_sel.itme_tab) THEN
            LET gc_sel.itme_show = "Y"
            LET gc_sel.stle_show = "Y"
            IF gc_sel.amt_show = "Y" OR gc_sel.rate_show = "Y" OR gc_sel.text_show = "Y" THEN
               CALL cl_err(" ","azz-117",1)
               LET gc_sel.amt_show = "N"
               LET gc_sel.rate_show = "N"
               LET gc_sel.rate_fld = ""
               LET gc_sel.text_show = "N"
               LET gc_sel.stle_fld = ""
            END IF
         END IF
 
      AFTER FIELD itme_fld
         LET lc_gaq01 = gc_sel.itme_fld          #No.TQC-630256
         IF NOT cl_null(gc_sel.itme_fld) THEN
            SELECT count(*) INTO li_count FROM gaq_file WHERE gaq01=lc_gaq01
            IF SQLCA.SQLCODE OR li_count <= 1 THEN
               CALL cl_err(gc_sel.itme_fld,"azz-116",1)
               NEXT FIELD itme_fld
            END IF
            LET gc_sel.itme_show = "Y"
            LET gc_sel.stle_show = "Y"
            IF gc_sel.amt_show = "Y" OR gc_sel.rate_show = "Y" OR gc_sel.text_show = "Y" THEN
               CALL cl_err(" ","azz-117",1)
               LET gc_sel.amt_show = "N"
               LET gc_sel.rate_show = "N"
               LET gc_sel.rate_fld = ""
               LET gc_sel.text_show = "N"
               LET gc_sel.stle_fld = ""
            END IF
         END IF
 
      AFTER FIELD itme_relat
         IF NOT cl_null(gc_sel.itme_relat) THEN
            LET gc_sel.itme_show = "Y"
            LET gc_sel.stle_show = "Y"
            IF gc_sel.amt_show = "Y" OR gc_sel.rate_show = "Y" OR gc_sel.text_show = "Y" THEN
               CALL cl_err(" ","azz-117",1)
               LET gc_sel.amt_show = "N"
               LET gc_sel.rate_show = "N"
               LET gc_sel.rate_fld = ""
               LET gc_sel.text_show = "N"
               LET gc_sel.stle_fld = ""
            END IF
         END IF
 
      AFTER FIELD itme_eft
         LET lc_gaq01 = gc_sel.itme_eft
         LET li_count = 0
         IF NOT cl_null(gc_sel.itme_eft) THEN
            SELECT count(*) INTO li_count FROM gaq_file WHERE gaq01=lc_gaq01
            IF SQLCA.SQLCODE OR li_count <= 1 THEN
               CALL cl_err(gc_sel.itme_eft,"azz-116",1)
            END IF
         END IF
 
      #No.FUN-560197 --start--
      AFTER FIELD multi_unit
         IF gc_sel.multi_unit = "Y" THEN
            LET gc_sel.stle_show = "Y"
         ELSE
            LET gc_sel.qty2_fld = ""
            LET gc_sel.unit2_fld = ""
            LET gc_sel.rate2_fld = ""
            LET gc_sel.qty1_fld = ""
            LET gc_sel.unit1_fld = ""
            LET gc_sel.rate1_fld = ""
            LET gc_sel.unit_fld = ""
            LET gc_sel.itemno_fld = ""
         END IF
 
      AFTER INPUT
         IF gc_sel.multi_unit = "Y" THEN
            IF cl_null(gc_sel.qty2_fld) THEN
               NEXT FIELD qty2_fld
            END IF
            IF cl_null(gc_sel.unit2_fld) THEN
               NEXT FIELD unit2_fld
            END IF
            IF cl_null(gc_sel.rate2_fld) THEN
               NEXT FIELD rate2_fld
            END IF
            IF cl_null(gc_sel.qty1_fld) THEN
               NEXT FIELD qty1_fld
            END IF
            IF cl_null(gc_sel.unit1_fld) THEN
               NEXT FIELD unit1_fld
            END IF
            IF cl_null(gc_sel.rate1_fld) THEN
               NEXT FIELD rate1_fld
            END IF
            IF cl_null(gc_sel.unit_fld) THEN
               NEXT FIELD unit_fld
            END IF
            IF cl_null(gc_sel.itemno_fld) THEN
               NEXT FIELD itemno_fld
            END IF
         END IF
      #No.FUN-560197 ---end---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   CLOSE WINDOW p_per_free_w
   IF INT_FLAG THEN
      LET INT_FLAG=FALSE
      RETURN ls_style.trim()
   ELSE
      CALL p_per_free_result()
      LET ls_style = gs_style.trim()
      RETURN ls_style
   END IF
 
END FUNCTION
 
 
FUNCTION p_per_free_setting()
 
   DEFINE li_count     LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE li_count2    LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE ls_style     STRING
   DEFINE ls_cutted    STRING
 
   LET gc_sel.stle_show = "N" 
   LET gc_sel.rate_show = "N" 
   LET gc_sel.rate_fld  = ""
   LET gc_sel.text_show = "N" 
   LET gc_sel.amt_show  = "N" 
   LET gc_sel.itme_show = "N" 
   LET gc_sel.stle_fld  = "" 
   LET gc_sel.itme_tab  = "" 
   LET gc_sel.itme_fld  = ""
   LET gc_sel.itme_relat= "" 
   LET gc_sel.itme_eft  = "" 
   #No.FUN-560197 --start--
   LET gc_sel.multi_unit = "N"
   LET gc_sel.qty2_fld = ""
   LET gc_sel.unit2_fld = ""
   LET gc_sel.rate2_fld = ""
   LET gc_sel.qty1_fld = ""
   LET gc_sel.unit1_fld = ""
   LET gc_sel.rate1_fld = ""
   LET gc_sel.unit_fld = ""
   #No.FUN-560197 ---end---
   LET gc_sel.itemno_fld = ""                 #No.FUN-560243
 
   IF gs_style.getLength() = 0 THEN RETURN END IF
   LET ls_style = gs_style.trim()
 
   LET li_count = ls_style.getIndexOf("rate(",1)
   IF li_count THEN
      LET gc_sel.stle_show = "Y"
      LET gc_sel.rate_show = "Y"
      LET ls_cutted = ls_style.subString(li_count+5,ls_style.getIndexOf(")",li_count+5)-1)
      LET gc_sel.rate_fld = ls_cutted.trim()
      LET ls_style = ls_style.subString(1,li_count-1),
                     ls_style.subString(ls_style.getIndexOf(")",li_count+5)+1,ls_style.getLength())
   END IF
   CALL p_per_free_kp(ls_style) RETURNING ls_style
display '1->',ls_style
 
   LET li_count = ls_style.getIndexOf("show_fd_desc",1) 
   IF li_count THEN
      LET gc_sel.stle_show = "Y"
      LET gc_sel.text_show = "Y"
      LET ls_style = ls_style.subString(1,li_count-1),
                     ls_style.subString(li_count+12,ls_style.getLength())
   END IF
   CALL p_per_free_kp(ls_style) RETURNING ls_style
display '2->',ls_style
 
   LET li_count = ls_style.getIndexOf("amt",1) 
   IF li_count THEN
      LET gc_sel.stle_show = "Y"
      LET gc_sel.amt_show = "Y"
      LET ls_style = ls_style.subString(1,li_count-1),
                     ls_style.subString(li_count+3,ls_style.getLength())
   END IF
   CALL p_per_free_kp(ls_style) RETURNING ls_style
display '3->',ls_style
 
   LET li_count = ls_style.getIndexOf("show_itme(",1) 
   IF li_count THEN
      LET gc_sel.stle_show = "Y"
      LET gc_sel.itme_show = "Y"
      LET ls_cutted = ls_style.subString(li_count+10,ls_style.getIndexOf(")",li_count+10)-1)
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.itme_tab = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.itme_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.itme_relat = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET gc_sel.itme_eft = ls_cutted.trim()
      LET ls_style = ls_style.subString(1,li_count-1),
                     ls_style.subString(ls_style.getIndexOf(")",li_count+10)+1,ls_style.getLength())
   END IF
   CALL p_per_free_kp(ls_style) RETURNING ls_style
display '4->',ls_style
 
   #No.FUN-560197 --start--
   LET li_count = ls_style.getIndexOf("multi_unit(",1)
   IF li_count THEN
      LET gc_sel.stle_show = "Y"
      LET gc_sel.multi_unit = "Y"
      LET ls_cutted = ls_style.subString(li_count+11,ls_style.getIndexOf(")",li_count+11)-1)
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.qty2_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.unit2_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.rate2_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.qty1_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.unit1_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.rate1_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET li_count2 = ls_cutted.getIndexOf(",",1)
      LET gc_sel.unit_fld = ls_cutted.subString(1,li_count2-1)
      LET ls_cutted = ls_cutted.subString(li_count2+1,ls_cutted.getLength())
      LET gc_sel.itemno_fld = ls_cutted.trim()                  #No.FUN-560243
      LET ls_style = ls_style.subString(1,li_count-1),
                     ls_style.subString(ls_style.getIndexOf(")",li_count+11)+1,ls_style.getLength())
   END IF
   CALL p_per_free_kp(ls_style) RETURNING ls_style
display '5->',ls_style
   #No.FUN-560197 ---end---
 
   LET gc_sel.stle_fld = ls_style.trim()
 
END FUNCTION
 
FUNCTION p_per_free_kp(ls_style)
 
   DEFINE ls_style  STRING
 
   LET ls_style = ls_style.trim()
   IF ls_style.subString(1,1) = "|" THEN
      LET ls_style=ls_style.subString(2,ls_style.getLength())
   END IF
   IF ls_style.subString(ls_style.getLength(),ls_style.getLength()) = "|" THEN
      LET ls_style=ls_style.subString(1,ls_style.getLength()-1)
   END IF
 
   RETURN ls_style
 
END FUNCTION
 
FUNCTION p_per_free_result()
 
   LET gs_style = ""
 
   IF gc_sel.stle_show = "N" THEN
      LET gs_style = ""
   ELSE
      IF gc_sel.rate_show = "Y" THEN
         LET gs_style = "rate(",gc_sel.rate_fld CLIPPED,")"
      END IF
      IF gc_sel.text_show = "Y" THEN
         IF gs_style.getLength() > 0 THEN
            LET gs_style = gs_style.trim(),"|show_fd_desc"
         ELSE
            LET gs_style = "show_fd_desc"
         END IF
      END IF
      IF gc_sel.amt_show = "Y" THEN
         IF gs_style.getLength() > 0 THEN
            LET gs_style = gs_style.trim(),"|amt"
         ELSE
            LET gs_style = "amt"
         END IF
      END IF
      IF gc_sel.itme_show = "Y" THEN
         IF gs_style.getLength() > 0 THEN
            LET gs_style = gs_style.trim(),"|show_itme(",gc_sel.itme_tab CLIPPED,",",gc_sel.itme_fld CLIPPED,",",gc_sel.itme_relat CLIPPED,")"
         ELSE
            LET gs_style = "show_itme(",gc_sel.itme_tab CLIPPED,",",gc_sel.itme_fld CLIPPED,",",gc_sel.itme_relat CLIPPED,",",gc_sel.itme_eft CLIPPED,")"
         END IF
      END IF
      #No.FUN-560197 --start--
      IF gc_sel.multi_unit = "Y" THEN
         IF gs_style.getLength() > 0 THEN
            LET gs_style = gs_style.trim(),"|multi_unit(",gc_sel.qty2_fld,",",gc_sel.unit2_fld,",",gc_sel.rate2_fld,",",gc_sel.qty1_fld,",",gc_sel.unit1_fld,",",gc_sel.rate1_fld,",",gc_sel.unit_fld,",",gc_sel.itemno_fld,")"
         ELSE
            LET gs_style = "multi_unit(",gc_sel.qty2_fld,",",gc_sel.unit2_fld,",",gc_sel.rate2_fld,",",gc_sel.qty1_fld,",",gc_sel.unit1_fld,",",gc_sel.rate1_fld,",",gc_sel.unit_fld,",",gc_sel.itemno_fld,")"
         END IF
      END IF
      #No.FUN-560197 ---end---
      IF NOT cl_null(gc_sel.stle_fld) THEN
         IF gs_style.getLength() > 0 THEN
            LET gs_style = gs_style.trim(),"|",gc_sel.stle_fld CLIPPED
         ELSE
            LET gs_style = gc_sel.stle_fld CLIPPED
         END IF
      END IF
      LET gs_style = gs_style.trim()
   END IF
 
   RETURN
 
END FUNCTION
