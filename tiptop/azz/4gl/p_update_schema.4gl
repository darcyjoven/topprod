# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: p_update_schema.4gl
# Descriptions...: Update legal & plant code for Schema
# Date & Author..: 12/01/18 By Jay
# Modify.........: No.FUN-BB0150 12/01/18 By Jay
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

import os
 
DATABASE ds

#FUN-BB0150
 
GLOBALS "../../config/top.global" 

DEFINE g_plant_list        DYNAMIC ARRAY OF RECORD
          azw02_old           LIKE azw_file.azw02,
          azw01_old           LIKE azw_file.azw01,
          azw05_old           LIKE azw_file.azw05,
          azw02_new           LIKE azw_file.azw02,
          azw01_new           LIKE azw_file.azw01,
          azw05_new           LIKE azw_file.azw05,
          azw09_new           LIKE azw_file.azw09,
          has_update          LIKE type_file.chr1        
                           END RECORD
DEFINE g_plant_list_t      RECORD
          azw02_old           LIKE azw_file.azw02,
          azw01_old           LIKE azw_file.azw01,
          azw05_old           LIKE azw_file.azw05,
          azw02_new           LIKE azw_file.azw02,
          azw01_new           LIKE azw_file.azw01,
          azw05_new           LIKE azw_file.azw05,
          azw09_new           LIKE azw_file.azw09,
          has_update          LIKE type_file.chr1        
                           END RECORD
DEFINE g_log_ch            base.Channel    
DEFINE g_today_str         STRING
DEFINE g_tmpdir            STRING
DEFINE g_telog             STRING
DEFINE g_rec_b             LIKE type_file.num5
DEFINE l_ac                LIKE type_file.num5
   
MAIN
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW p_update_schema_w WITH FORM "azz/42f/p_update_schema" 
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL p_update_schema_menu()

   CLOSE WINDOW p_update_schema_w                           # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    # 計算使用時間 (退出使間) 
         
END MAIN

FUNCTION p_update_schema_menu()
   WHILE TRUE
      CALL p_update_schema_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_update_schema_b()
            END IF

         WHEN "update_value"
            IF cl_chk_act_auth() THEN
               #確認要執行營運中心代碼Update作業
               IF p_create_schema_conf("azz1199") THEN
                  LET g_telog = NULL
                  DISPLAY NULL TO telog
                  CALL p_update_schema_value()
               END IF
            END IF

         WHEN "exit"
            EXIT WHILE

      END CASE
   END WHILE
END FUNCTION

FUNCTION p_update_schema_bp(p_ud)
   DEFINE p_ud            LIKE type_file.chr1          # CHAR(1)
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_has_update    LIKE type_file.chr1
   
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
       RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_plant_list TO s_plant.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         
      ON ACTION detail                 # B.單身
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION EXIT
         LET g_action_choice = "exit"
         EXIT DISPLAY

      ON ACTION update_value
         IF g_plant_list.getLength() = 0 THEN
            #提醒使用者需輸入新/舊營運中心的對應關係
            CALL p_create_schema_info("azz1195", NULL) 
            CONTINUE DISPLAY
         END IF
         
         LET l_has_update = "Y"
         FOR l_i = 1 TO g_plant_list.getLength()
             IF g_plant_list[l_i].has_update = "N" THEN
                LET l_has_update = "N"
                EXIT FOR
             END IF
         END FOR

         IF l_has_update = "Y" THEN
            #已無營運中心代碼需要Update
            CALL p_create_schema_info("azz1200", NULL) 
            CONTINUE DISPLAY
         END IF

         IF g_plant_list.getLength() > 0 AND l_has_update = "N" THEN
            LET g_action_choice="update_value"
            EXIT DISPLAY
         END IF
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION help                   # H.說明
         CALL cl_show_help()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         
      AFTER DISPLAY
         CONTINUE DISPLAY
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p_update_schema_b()
   DEFINE l_sql          STRING
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_allow_insert LIKE type_file.num5     # 可否新增          # SMALLINT
   DEFINE l_allow_delete LIKE type_file.num5     # 可否刪除          # SMALLINT
   DEFINE p_cmd          LIKE type_file.chr1
   DEFINE l_ac_t         LIKE type_file.num5     #FUN-D30034 Add 
   
   CALL cl_opmsg('b')

   IF s_shut(0) THEN
      RETURN
   END IF
   LET g_action_choice = ""
   
   LET l_sql = "SELECT COUNT(*) FROM azw_file ", 
               "  WHERE azw01 = ? "
   PREPARE update_b_azw01_pre FROM l_sql
 
   MESSAGE ''

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_plant_list WITHOUT DEFAULTS FROM s_plant.*
      ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_entry("azw02_old, azw05_old, azw02_new, azw05_new, azw09_new, has_update", FALSE)
         
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         IF g_rec_b >= l_ac THEN
            LET p_cmd = 'u'
            LET g_plant_list_t.* = g_plant_list[l_ac].*  #BACKUP
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
          LET p_cmd='a'
          INITIALIZE g_plant_list[l_ac].* TO NULL
          LET g_plant_list_t.* = g_plant_list[l_ac].*    #新輸入資料
          CALL cl_show_fld_cont()

      ON ACTION controlp 
         CASE
            WHEN INFIELD(azw01_old)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw16"
               LET g_qryparam.default1 = g_plant_list[l_ac].azw01_old
               LET g_qryparam.arg1     = g_plant_list[l_ac].azw02_old
               CALL cl_create_qry() 
                  RETURNING g_plant_list[l_ac].azw01_old, g_plant_list[l_ac].azw02_old, g_plant_list[l_ac].azw05_old

               DISPLAY g_plant_list[l_ac].azw01_old TO azw01_old
               DISPLAY g_plant_list[l_ac].azw02_old TO azw02_old
               DISPLAY g_plant_list[l_ac].azw05_old TO azw05_old
               NEXT FIELD azw01_old
            WHEN INFIELD(azw01_new)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw16"
               LET g_qryparam.default1 = g_plant_list[l_ac].azw01_new
               LET g_qryparam.arg1     = g_plant_list[l_ac].azw02_new
               CALL cl_create_qry() 
                  RETURNING g_plant_list[l_ac].azw01_new, g_plant_list[l_ac].azw02_new, g_plant_list[l_ac].azw05_new

               DISPLAY g_plant_list[l_ac].azw01_new TO azw01_new
               DISPLAY g_plant_list[l_ac].azw02_new TO azw02_new
               DISPLAY g_plant_list[l_ac].azw05_new TO azw05_new
               NEXT FIELD azw01_new
         END CASE

      AFTER FIELD azw01_old
         #檢查所輸入營運中心,是不是屬於此筆要建立schema的營運中心名稱
         IF NOT cl_null(g_plant_list[l_ac].azw01_old) THEN
            EXECUTE update_b_azw01_pre 
              USING g_plant_list[l_ac].azw01_old 
              INTO l_cnt
              
            IF l_cnt = 0 THEN
               CALL cl_err_msg("", "aoo-254", g_plant_list[l_ac].azw01_old , 10)
               LET g_plant_list[l_ac].azw01_old = ""
               DISPLAY g_plant_list[l_ac].azw01_old TO azw01_old
               NEXT FIELD azw01_old
            ELSE
               SELECT azw02, azw05 INTO g_plant_list[l_ac].azw02_old, g_plant_list[l_ac].azw05_old
                 FROM azw_file 
                 WHERE azw01 = g_plant_list[l_ac].azw01_old 
               DISPLAY g_plant_list[l_ac].azw02_old TO azw02_old
               DISPLAY g_plant_list[l_ac].azw05_old TO azw05_old
            END IF
         END IF

      AFTER FIELD azw01_new
         #檢查所輸入營運中心,是不是屬於此筆要建立schema的營運中心名稱
         IF NOT cl_null(g_plant_list[l_ac].azw01_new) THEN
            EXECUTE update_b_azw01_pre 
              USING g_plant_list[l_ac].azw01_new 
              INTO l_cnt
              
            IF l_cnt = 0 THEN
               CALL cl_err_msg("", "aoo-254", g_plant_list[l_ac].azw01_new , 10)
               LET g_plant_list[l_ac].azw01_new = ""
               DISPLAY g_plant_list[l_ac].azw01_new TO azw01_new
               NEXT FIELD azw01_new
            ELSE
               SELECT azw02, azw05, azw09 
                 INTO g_plant_list[l_ac].azw02_new, g_plant_list[l_ac].azw05_new, g_plant_list[l_ac].azw09_new
                 FROM azw_file 
                 WHERE azw01 = g_plant_list[l_ac].azw01_new 
               DISPLAY g_plant_list[l_ac].azw02_new TO azw02_new
               DISPLAY g_plant_list[l_ac].azw05_new TO azw05_new
               DISPLAY g_plant_list[l_ac].azw09_new TO azw09_new
               LET g_plant_list[l_ac].has_update = "N"
               DISPLAY g_plant_list[l_ac].has_update TO has_update
            END IF
         END IF

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         ELSE
            LET g_rec_b = g_rec_b + 1
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_plant_list_t.azw01_new IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
         END IF
          
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_plant_list[l_ac].* = g_plant_list_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_plant_list.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 Add
           
      ON ACTION help                             # H.說明
         CALL cl_show_help()
           
     #FUN-D30034---Mark----Str 
     #ON ACTION exit                             # Esc.結束
     #   LET g_action_choice = "exit"
     #   EXIT INPUT
     #FUN-D30034---Mark----End           
 
      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION about      
         CALL cl_about() 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT  

      ON ACTION locale
         CALL cl_dynamic_locale()
         
   END INPUT

END FUNCTION  

FUNCTION p_update_schema_value()
   DEFINE l_log_file    STRING
   DEFINE l_log_path    STRING
   DEFINE l_schema      STRING
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_azw05       LIKE azw_file.azw05
   DEFINE l_msg         STRING
   DEFINE l_log_ch base.Channel,
          l_log STRING,
          l_str_buf base.StringBuffer
          
   #因為呼叫p_create_schema.p_create_schema_default_value()時,
   #會將執行過程寫入log,所以這裡先指定要寫的log路徑
   #指定檔名:檔名組成為今日日期+時間+"_update_value.log",如:120221_1114_update_value.log
   LET g_today_str = TODAY USING "yymmdd"
   LET g_today_str = g_today_str, "_", CURRENT HOUR TO MINUTE
   LET g_today_str = cl_replace_str(g_today_str, ":", "")

   #log檔放在$TOP/tmp底下
   LET g_tmpdir = os.Path.join(FGL_GETENV("TOP"), "tmp")
   LET l_log_file = g_today_str, "_update_value.log"
   LET l_log_path = os.Path.join(g_tmpdir, l_log_file)
   LET g_log_ch = base.Channel.create()
   CALL g_log_ch.openFile(l_log_path, "w") 
   CALL g_log_ch.writeLine(l_log_path)

   CALL cl_progress_bar(g_plant_list.getLength()) #5個流程
   
   #依序處理需Update的schema,下面處理將以g_plant_list.azw05_new(schema)為主
   #不以g_plant_list.azw01_new(營運中心代碼)為主
   #方便在做update_all_table時不用一個一個營運中心去掃全schema table,以增進效能
   FOR l_i = 1 TO g_plant_list.getLength()
      #如果是Update 實體DB的營運中心代碼,多增加Update參數、設定檔之營運中心
      SELECT COUNT(*) INTO l_cnt FROM azw_file WHERE azw05 = azw06 AND azw01 = g_plant_list[l_i].azw01_new
      IF SQLCA.SQLCODE THEN
         LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
         CALL g_log_ch.writeLine(l_msg)
         LET l_msg = l_azw05,":update default vaule(azw01) is failed."
      ELSE   
         CALL cl_progressing("Step " || l_i || ":" || g_plant_list[l_i].azw01_new || "begin update value.")
         IF l_cnt > 0 AND g_plant_list[l_i].has_update = "N" THEN 
            #如果為實體DB才做Update參數、設定檔之營運中心
            CALL p_update_schema_parameter_table(g_plant_list[l_i].azw01_new, g_plant_list[l_i].azw05_new, g_plant_list[l_i].azw09_new)
         END IF
         #因為Update方式以g_plant_list.azw05_new(schema)為主
         #有可能在上面已經先做過Update了,因此不在重覆做
         #例如在做DSV1-1營運中心時,在update_all_table()中,會順便做DSV1-2,DSV1-3的Update
         IF g_plant_list[l_i].has_update = "N" THEN
            CALL p_update_schema_all_table(g_plant_list[l_i].azw01_new, g_plant_list[l_i].azw05_new, g_plant_list[l_i].azw09_new)
         END IF
      END IF
   END FOR

   #將執行過程紀錄顯示在UI上
   LET l_str_buf = base.StringBuffer.create()
   LET l_log_ch = base.Channel.create()
   CALL l_log_ch.openFile(l_log_path, "r")
      
   WHILE TRUE
      LET l_log = l_log_ch.readLine()
      
      IF l_log_ch.isEof() THEN
         EXIT WHILE
      END IF
      
      LET l_log = l_log,"\n"
      CALL l_str_buf.append(l_log)
   END WHILE

   LET g_telog = l_str_buf.toString()   
   DISPLAY g_telog TO telog
   CALL l_str_buf.clear()
   CALL l_log_ch.close()
   
   CALL p_create_schema_info("azz1011", l_log_path)
   
END FUNCTION

#[
# Descriptions...: 將相關參數或設定檔資料表之營運中心代碼欄位Update成新的營運中心代碼(azw01)
# Date & Author..: 2011/07/21 by Jay
# Input Parameter: none
# Return Code....: 
# Memo...........:
# Modify.........:
#
#]
PRIVATE FUNCTION p_update_schema_parameter_table(p_azw01, p_azw05, p_azw09)
   DEFINE p_azw01    LIKE azw_file.azw01
   DEFINE p_azw05    LIKE azw_file.azw05
   DEFINE p_azw09    LIKE azw_file.azw09
   DEFINE l_msg      STRING
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_length   LIKE type_file.num5 
   DEFINE l_upd_sql  STRING
   DEFINE l_update_target DYNAMIC ARRAY OF RECORD   #記錄需update的資料表和欄位名稱
              table_name LIKE sch_file.sch01,                                
              field_name LIKE sch_file.sch02,
              pk_name    STRING                     #記錄此table pk欄位,若有二個欄位以上用|隔開,如"aaa00|aaa01|aaa02"
              END RECORD
   DEFINE l_gao05    LIKE gao_file.gao05  

   #將這個部份的log資料直接紀錄在today_update_value.log中,例如100119_update_value.log
   CALL g_log_ch.writeLine("")
   CALL g_log_ch.writeLine("#----------------------- (" || CURRENT YEAR TO SECOND || ") --------------------------#")   
   LET l_msg = p_azw05, ":update default vaule(azw01) data for parameter_table"
   CALL g_log_ch.writeLine(l_msg)
   DISPLAY l_msg
      
   CALL l_update_target.clear()
   
   LET l_update_target[1].table_name = "oaz_file"
   LET l_update_target[1].field_name = "oaz02p"
   LET l_update_target[1].pk_name = "oaz00"
   
   LET l_update_target[2].table_name = "ooz_file"
   LET l_update_target[2].field_name = "ooz02p"
   LET l_update_target[2].pk_name = "ooz00"
   
   LET l_update_target[3].table_name = "apz_file"
   LET l_update_target[3].field_name = "apz02p"
   LET l_update_target[3].pk_name = "apz00"
   
   LET l_update_target[4].table_name = "apz_file"
   LET l_update_target[4].field_name = "apz04p"
   LET l_update_target[4].pk_name = "apz00"
   
   LET l_update_target[5].table_name = "nmz_file"
   LET l_update_target[5].field_name = "nmz02p"
   LET l_update_target[5].pk_name = "nmz00"
   
   LET l_update_target[6].table_name = "imd_file" 
   LET l_update_target[6].field_name = "imd20" 
   LET l_update_target[6].pk_name = "imd01" 
   
   LET l_update_target[7].table_name = "sma_file"
   LET l_update_target[7].field_name = "sma87"
   LET l_update_target[7].pk_name = "sma00"
   
   LET l_update_target[8].table_name = "faa_file"
   LET l_update_target[8].field_name = "faa02p"
   LET l_update_target[8].pk_name = "faa00"
   
   LET l_update_target[9].table_name = "ccz_file"
   LET l_update_target[9].field_name = "ccz11"
   LET l_update_target[9].pk_name = "ccz00"

   LET l_update_target[10].table_name = "apg_file"
   LET l_update_target[10].field_name = "apg03"
   LET l_update_target[10].pk_name = "apg01|apg02"

   LET l_update_target[11].table_name = "oma_file"
   LET l_update_target[11].field_name = "oma66"
   LET l_update_target[11].pk_name = "oma01"

   LET l_update_target[12].table_name = "apa_file"
   LET l_update_target[12].field_name = "apa100"
   LET l_update_target[12].pk_name = "apa01"
   
   #準備做欄位的Update
   LET l_length = l_update_target.getLength()

   #找出新schema的營運中心代碼 
   FOR l_i = 1 TO l_length
       LET l_upd_sql = "UPDATE ", s_dbstring(p_azw05), l_update_target[l_i].table_name,
                       " SET ", l_update_target[l_i].field_name, " = '", p_azw01 CLIPPED, "'"

       #執行UPDATE程序
       TRY
          IF p_azw05 <> p_azw09 CLIPPED THEN
             CALL g_log_ch.writeLine("")
             CALL g_log_ch.writeLine("SELECT gao05 FROM gao_file WHERE zta01 = " || l_update_target[l_i].table_name)
             SELECT gao05 INTO l_gao05 FROM gao_file
               WHERE gao01 = 
                 (SELECT zta03 FROM zta_file 
                    WHERE zta02 = 'ds' AND zta01 = l_update_target[l_i].table_name)
             CALL g_log_ch.writeLine("SELECT OK")
             IF l_gao05 = "Y" THEN
                CALL g_log_ch.writeLine("gao05 = 'Y'")
                CONTINUE FOR
             END IF
          END IF
          
          CALL g_log_ch.writeLine(l_upd_sql)
          EXECUTE IMMEDIATE l_upd_sql
          CALL g_log_ch.writeLine("UPDATE OK")
       CATCH
          LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
          CALL g_log_ch.writeLine(l_msg)
       END TRY  
   END FOR
   LET l_msg = p_azw05,":update default vaule(azw01) for parameter_table finish."
   
   CALL g_log_ch.writeLine(l_msg)
   CALL g_log_ch.writeLine("#------------------------------------------------------------------------------#")   
   CALL g_log_ch.writeLine("")
   DISPLAY l_msg

END FUNCTION  

#[
# Descriptions...: 將xxxlegal和xxxplant欄位的資料表Update成新的schema法人和營運中心資料
# Date & Author..: 2011/09/30 by Jay
# Input Parameter: p_azw01  營運中心代碼
#                  p_azw05  實體DB
#                  p_azw09  法人DB
# Return Code....: none
# Memo...........:
# Modify.........:
#
#]
PRIVATE FUNCTION p_update_schema_all_table(p_azw01, p_azw05, p_azw09)
   DEFINE p_azw01           LIKE azw_file.azw01
   DEFINE p_azw05           LIKE azw_file.azw05
   DEFINE p_azw09           LIKE azw_file.azw09
   DEFINE l_msg             STRING
   DEFINE l_sql             STRING
   DEFINE l_upd_sql         STRING
   DEFINE l_sch01           LIKE sch_file.sch01
   DEFINE l_sch02_legal     LIKE sch_file.sch02
   DEFINE l_sch02_plant     LIKE sch_file.sch02
   DEFINE l_i               LIKE type_file.num5

   #此段SQL語法是一次找出每個table的xxxlegal和xxxplant欄位名稱,避免一直呼叫db
   #括號中第一段是找有xxxlegal欄位名稱的table
   #     第二段是找有xxxplant欄位名稱的table
   #最後再將有xxxlegal欄位名稱為主要sql, 將二段sql語法LEFT OUTER JOIN在一起(這裡是定義成有xxxplant一定也要有xxxlegal)
   #就可以找出每個table是只有xxxlegal欄位,或是xxxlegal和xxxplant二個欄位都有
   LET l_sql = "SELECT l_sch01, l_sch02, p_sch02 FROM ", 
               "  ((SELECT l.sch01 AS l_sch01, l.sch02 AS l_sch02 FROM sch_file l WHERE l.sch02 LIKE '%legal') ",
               "    LEFT OUTER JOIN ",
               "   (SELECT p.sch01 AS p_sch01, p.sch02 AS p_sch02 FROM sch_file p WHERE p.sch02 LIKE '%plant') ",
               "    ON l_sch01 = p_sch01) "
   
   #如果要建立的schema不為法人DB,就需要過濾掉財務模組的table
   #不需要Update這個table的Legal & Plant 的值
   #因為後面也會把這些財務模組table drop掉,create synonym到法人DB
   IF p_azw05 <> p_azw09 CLIPPED THEN         	  
      LET l_sql = l_sql, " WHERE l_sch01 NOT IN ", 
                         "   (SELECT zta01 FROM zta_file ", 
                         "      WHERE zta02 = 'ds' AND zta03 IN (", cl_get_finance_in(), ") ", 
                         "        AND zta07 = 'T' AND zta09 <> 'Z') "
   END IF
   
   LET l_sql = l_sql, " ORDER BY l_sch01 "
   
   PREPARE update_all_table_pre FROM l_sql
   DECLARE update_all_table_curs CURSOR FOR update_all_table_pre

   #將這個部份的log資料直接紀錄在today_update_value.log中,例如100119_update_value.log
   CALL g_log_ch.writeLine("")
   CALL g_log_ch.writeLine("#----------------------- (" || CURRENT YEAR TO SECOND || ") --------------------------#")
   LET l_msg = p_azw05, ":update xxxlegal and xxxplant vaule data for all_table."
   CALL g_log_ch.writeLine(l_msg)
   
   OPEN update_all_table_curs 
   IF STATUS THEN
      CALL cl_err("OPEN update_all_table_curs:", STATUS, 1)
      CLOSE update_all_table_curs
      LET l_msg = "Update failed. OPEN update_all_table_curs:", STATUS
      CALL g_log_ch.writeLine(l_msg)
      CALL g_log_ch.writeLine("#------------------------------------------------------------------------------#")
      RETURN
   END IF

   #準備Update 新schema的xxxlegal和xxxplant欄位資料
   FOREACH update_all_table_curs INTO l_sch01, l_sch02_legal, l_sch02_plant
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:', SQLCA.SQLCODE, 1)    
         CLOSE update_all_table_curs
         LET l_msg = "FOREACH:", SQLCA.SQLCODE
         CALL g_log_ch.writeLine(l_msg)
      END IF

      FOR l_i = 1 TO g_plant_list.getLength()
          IF g_plant_list[l_i].azw05_new = p_azw05 THEN
             LET l_upd_sql = "UPDATE ", s_dbstring(p_azw05), l_sch01,
                      "  SET ", l_sch02_legal, " = '", g_plant_list[l_i].azw02_new CLIPPED, "'"

             IF cl_null(l_sch02_plant) THEN
                LET l_upd_sql = l_upd_sql, "  WHERE ", l_sch02_legal, " = '", g_plant_list[l_i].azw02_old, "'"
             ELSE
                LET l_upd_sql = l_upd_sql, ", ", l_sch02_plant, " = '", g_plant_list[l_i].azw01_new CLIPPED, "'"
                LET l_upd_sql = l_upd_sql, "  WHERE ", l_sch02_plant, " = '", g_plant_list[l_i].azw01_old CLIPPED, "'"
             END IF

             #執行UPDATE程序
             TRY
                CALL g_log_ch.writeLine(l_upd_sql)
                EXECUTE IMMEDIATE l_upd_sql
                CALL g_log_ch.writeLine("UPDATE OK")
             CATCH
                LET l_msg = "ERROR:SQLCODE=",SQLCA.SQLCODE,",SQLERRD[2]=",SQLCA.SQLERRD[2]
                CALL g_log_ch.writeLine(l_msg)
             END TRY
             LET g_plant_list[l_i].has_update = "Y"

             #假如這個table只有xxxlegal欄位,那update只要做一次就可以了
             IF cl_null(l_sch02_plant) THEN
                EXIT FOR
             END IF  
          END IF
      END FOR
   END FOREACH
   CLOSE update_all_table_curs

   LET l_msg = p_azw05,":update default vaule(azw01) for all_table finish."
   
   CALL g_log_ch.writeLine(l_msg)
   CALL g_log_ch.writeLine("#------------------------------------------------------------------------------#")   
   CALL g_log_ch.writeLine("")
END FUNCTION  
