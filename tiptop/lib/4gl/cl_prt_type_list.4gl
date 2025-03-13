# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: cl_prt_type_list.4gl
# Descriptions...: 列出符合屬性的zaa報表程式
# Date & Author..: 05/07/26 by saki
# Usage..........: CALL cl_prt_type_list("K","",30,"Y","","")
# Modify.........: No.FUN-590070 05/09/15 By CoCo 料件在zaa的屬性由'J'改成'N'
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
# Descriptions...: 根據傳入屬性值，將符合的zaa資料表列出
# Date & Author..: 2005/07/26 by saki
# Input Parameter: ps_type      欄位屬性(N:料件,K:單據,L:雙單位,M:BOM)
#                  ps_hidden    是否隱藏
#                  ps_length    定位點
#                  ps_popwin    是否開窗選擇
#                  ps_retain1   保留參數
#                  ps_retain2   保留參數
# Return Code....: void
 
FUNCTION cl_prt_type_list(ps_type,ps_hidden,ps_length,ps_popwin,ps_retain1,ps_retain2)
   DEFINE   ps_type       LIKE type_file.chr1             #No.FUN-690005  VARCHAR(1)
   DEFINE   ps_hidden     LIKE type_file.chr1             #No.FUN-690005  VARCHAR(1)
   DEFINE   ps_length     LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE   ps_popwin     LIKE type_file.chr1             #No.FUN-690005  VARCHAR(1)
   DEFINE   ps_retain1    LIKE type_file.chr1             #No.FUN-690005  VARCHAR(1)
   DEFINE   ps_retain2    LIKE type_file.chr1             #No.FUN-690005  VARCHAR(1)
   DEFINE   lr_zaa        DYNAMIC ARRAY OF RECORD
               sel        LIKE type_file.chr1,            #No.FUN-690005  VARCHAR(1)
               zaa01      LIKE zaa_file.zaa01,
               gaz03      LIKE gaz_file.gaz03
                          END RECORD
   DEFINE   li_cnt        LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   ls_sql        STRING
   DEFINE   li_i          LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   li_do         LIKE type_file.num5             #No.FUN-690005  SMALLINT
   DEFINE   lc_value      LIKE type_file.chr1000          #No.FUN-690005  VARCHAR(100)
   DEFINE   ls_msg        STRING
   DEFINE   li_result     LIKE type_file.num5          #No.FUN-690005 SMALLINT
   DEFINE   lc_att_name   LIKE ze_file.ze03
   DEFINE   lc_upd_name   LIKE ze_file.ze03
 
 
   LET ps_type = UPSHIFT(ps_type)
   LET ps_hidden = UPSHIFT(ps_hidden)
   LET ps_popwin = UPSHIFT(ps_popwin)
   IF (cl_null(ps_type)) OR ((ps_type = "L" OR ps_type = "M") AND cl_null(ps_hidden)) OR
     # ((ps_type = "J" OR ps_type = "K") AND cl_null(ps_length)) THEN #FUN-590070
      ((ps_type = "N" OR ps_type = "K") AND cl_null(ps_length)) THEN #FUN-590070
      RETURN
   END IF
   IF cl_null(ps_popwin) THEN
      LET ps_popwin = "Y"
   END IF
 
   IF ps_popwin = "Y" THEN
      OPEN WINDOW prt_list_w AT 1,1 WITH FORM "lib/42f/cl_prt_type_list"
      ATTRIBUTE(STYLE="lib")
 
      CALL cl_ui_locale("cl_prt_type_list")
 
      CALL lr_zaa.clear()
      LET li_cnt = 1
 
      LET ls_sql = "SELECT UNIQUE 'N',zaa01,'' FROM zaa_file",
                   " WHERE zaa14 = '",ps_type,"' AND zaa09 = '2'"
      PREPARE zaa_pre FROM ls_sql
      DECLARE zaa_cur CURSOR FOR zaa_pre
 
      FOREACH zaa_cur INTO lr_zaa[li_cnt].*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
 
         SELECT gaz03 INTO lr_zaa[li_cnt].gaz03 FROM gaz_file
          WHERE gaz01 = lr_zaa[li_cnt].zaa01 AND gaz02 = g_lang
         LET li_cnt = li_cnt + 1
         
         #No.TQC-630109 --start--
         IF li_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
         #No.TQC-630109 ---end---
      END FOREACH
      CALL lr_zaa.deleteElement(li_cnt)
 
      CASE ps_type
      #   WHEN "J" ### FUN-590070 ###
         WHEN "N"  ### FUN-590070 ###
            SELECT ze03 INTO lc_att_name FROM ze_file WHERE ze01 = "mfg1015" AND ze02 = g_lang
            SELECT ze03 INTO lc_upd_name FROM ze_file WHERE ze01 = "lib-256" AND ze02 = g_lang
            DISPLAY lc_att_name,lc_upd_name,ps_length TO FORMONLY.att_name,FORMONLY.upd_name,FORMONLY.upd_value
         WHEN "K"
            SELECT ze03 INTO lc_att_name FROM ze_file WHERE ze01 = "lib-258" AND ze02 = g_lang
            SELECT ze03 INTO lc_upd_name FROM ze_file WHERE ze01 = "lib-256" AND ze02 = g_lang
            DISPLAY lc_att_name,lc_upd_name,ps_length TO FORMONLY.att_name,FORMONLY.upd_name,FORMONLY.upd_value
         WHEN "L"
            SELECT ze03 INTO lc_att_name FROM ze_file WHERE ze01 = "lib-259" AND ze02 = g_lang
            SELECT ze03 INTO lc_upd_name FROM ze_file WHERE ze01 = "lib-257" AND ze02 = g_lang
            DISPLAY lc_att_name,lc_upd_name,ps_hidden TO FORMONLY.att_name,FORMONLY.upd_name,FORMONLY.upd_value
         WHEN "M"
            SELECT ze03 INTO lc_att_name FROM ze_file WHERE ze01 = "lib-260" AND ze02 = g_lang
            SELECT ze03 INTO lc_upd_name FROM ze_file WHERE ze01 = "lib-257" AND ze02 = g_lang
            DISPLAY lc_att_name,lc_upd_name,ps_hidden TO FORMONLY.att_name,FORMONLY.upd_name,FORMONLY.upd_value
      END CASE
 
 
      DISPLAY ARRAY lr_zaa TO s_zaa.*
         BEFORE DISPLAY
            EXIT DISPLAY
      END DISPLAY
 
      INPUT ARRAY lr_zaa WITHOUT DEFAULTS FROM s_zaa.*
         ATTRIBUTE(INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)
 
         BEFORE INPUT
            IF lr_zaa.getLength() <= 0 THEN
               MESSAGE "Have no matches data"
            END IF
 
         AFTER ROW
            CALL GET_FLDBUF(s_zaa.sel) RETURNING lr_zaa[ARR_CURR()].sel
 
         ON ACTION select_all
            FOR li_i = 1 TO lr_zaa.getLength()
                LET lr_zaa[li_i].sel = "Y"
            END FOR
 
         ON ACTION select_none
            FOR li_i = 1 TO lr_zaa.getLength()
                LET lr_zaa[li_i].sel = "N"
            END FOR
 
         ON ACTION accept
            LET li_do = TRUE
            EXIT INPUT
 
         #No.TQC-860016 --start--
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
         #No.TQC-860016 ---end---
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
      END IF
   ELSE
      LET li_do = TRUE
      FOR li_i = 1 TO lr_zaa.getLength()
          LET lr_zaa[li_i].sel = "Y"
      END FOR
   END IF
 
   IF li_do THEN
      LET ls_msg = NULL
      FOR li_i = 1 TO lr_zaa.getLength()
          IF lr_zaa[li_i].sel = "Y"  THEN
             CASE ps_type
              #  WHEN "J"  ### FUN-590070 ###
                WHEN "N"   ### FUN-590070 ###
                   LET lc_value = ps_length
                WHEN "K"
                   LET lc_value = ps_length
                WHEN "L"
                   LET lc_value = ps_hidden
                WHEN "M"
                   LET lc_value = ps_hidden
             END CASE
             CALL cl_prt_update_zaa(lr_zaa[li_i].zaa01,ps_type,lc_value) RETURNING li_result
             IF (NOT li_result) THEN
                IF cl_null(ls_msg) THEN
                   LET ls_msg = lr_zaa[li_i].zaa01 CLIPPED
                ELSE
                   LET ls_msg = ls_msg,",",lr_zaa[li_i].zaa01 CLIPPED
                END IF
             END IF
             IF (NOT cl_null(ls_msg)) THEN
                CALL cl_err(ls_msg,"azz-255",1)
             END IF
          END IF
      END FOR
   END IF
 
   CLOSE WINDOW prt_list_w
END FUNCTION
 
 
# Descriptions...: 根據特殊的欄位屬性更新zaa的資料
# Date & Author..: 2005/07/26 by saki
# Input Parameter: ps_zaa01     報表程式代碼
#                  ps_zaa14     欄位屬性
#                  pc_value     是否隱藏或長度
# Return Code....: li_result    TRUE/FALSE
# Usage..........: CALL cl_prt_update_zaa("aapr121","J",30)
 
FUNCTION cl_prt_update_zaa(ps_zaa01,ps_zaa14,pc_value)
   DEFINE   ps_zaa01   LIKE zaa_file.zaa01
   DEFINE   ps_zaa14   LIKE zaa_file.zaa14
   DEFINE   pc_value   LIKE type_file.chr1000          #No.FUN-690005  VARCHAR(100)
   DEFINE   lc_zaa05   LIKE zaa_file.zaa05
   DEFINE   lc_zaa06   LIKE zaa_file.zaa06
   DEFINE   li_result  LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
 
   IF cl_null(ps_zaa01) OR cl_null(ps_zaa14) OR cl_null(pc_value) THEN
      RETURN
   END IF
 
   LET li_result = TRUE
   CASE ps_zaa14
     # WHEN "J"  ### FUN-590070 ###
      WHEN "N"  ### FUN-590070 ###
         LET lc_zaa05 = pc_value CLIPPED
         UPDATE zaa_file SET zaa05 = lc_zaa05
          WHERE zaa01 = ps_zaa01 AND zaa14 = ps_zaa14 AND zaa09 = "2"
         IF SQLCA.sqlcode THEN
            LET li_result = FALSE
         END IF
      WHEN "K"
         LET lc_zaa05 = pc_value CLIPPED
         UPDATE zaa_file SET zaa05 = lc_zaa05
          WHERE zaa01 = ps_zaa01 AND zaa14 = ps_zaa14 AND zaa09 = "2"
         IF SQLCA.sqlcode THEN
            LET li_result = FALSE
         END IF
      WHEN "L"
         LET lc_zaa06 = pc_value CLIPPED
         UPDATE zaa_file SET zaa06 = lc_zaa06
          WHERE zaa01 = ps_zaa01 AND zaa14 = ps_zaa14 AND zaa09 = "2"
         IF SQLCA.sqlcode THEN
            LET li_result = FALSE
         END IF
      WHEN "M"
         LET lc_zaa06 = pc_value CLIPPED
         UPDATE zaa_file SET zaa06 = lc_zaa06
          WHERE zaa01 = ps_zaa01 AND zaa14 = ps_zaa14 AND zaa09 = "2"
         IF SQLCA.sqlcode THEN
            LET li_result = FALSE
         END IF
   END CASE
 
   RETURN li_result
END FUNCTION
