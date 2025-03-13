# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_type_upd.4gl
# Descriptions...: 欄位型態維護作業
# Date & Author..: 06/08/11 rainy
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-820045 08/02/22 By yiting 加上schema欄位型態及長度
# Modify.........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gaq     DYNAMIC ARRAY OF RECORD 
            gaq01          LIKE gaq_file.gaq01,   #欄位代碼 
            gaq03          LIKE gaq_file.gaq03,   #欄位名稱
            ztb04          LIKE ztb_file.ztb04,   #NO.FUN-820045
            length         LIKE ztb_file.ztb08,   #NO.FUN-820045
            gaq07          LIKE gaq_file.gaq07,   #欄位屬性  
            gck02          LIKE gck_file.gck02,   #屬性簡稱
            gck03          LIKE gck_file.gck03    #no.FUN-820045
                      END RECORD,
         g_gaq_t           RECORD 
            gaq01          LIKE gaq_file.gaq01,   #欄位代碼 
            gaq03          LIKE gaq_file.gaq03,   #欄位名稱
            ztb04          LIKE ztb_file.ztb04,   #no.FUN-820045
            length         LIKE ztb_file.ztb08,   #no.FUN-820045
            gaq07          LIKE gaq_file.gaq07,   #欄位屬性  
            gck02          LIKE gck_file.gck02,   #屬性簡稱
            gck03          LIKE gck_file.gck03    #no.FUN-820045
                      END RECORD,
         g_wc2             STRING,
         g_sql             STRING,
         g_rec_b           LIKE type_file.num5,   # 單身筆數              #No.FUN-680135 SMALLINT
         l_ac              LIKE type_file.num5,   # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
         l_sl              LIKE type_file.num5    # 目前處理的SCREEN LINE #No.FUN-680135 SMALLINT
DEFINE   p_row             LIKE type_file.num5,   #No.FUN-680135 SMALLINT
         p_col             LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE   g_cnt             LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_forupd_sql      STRING
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
MAIN
#     DEFINEl_time   LIKE type_file.chr8                #No.FUN-6A0096
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)                  # 計算使用時間 (進入時間  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW p_type_upd_w AT p_row,p_col WITH FORM "azz/42f/p_type_upd"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
 
   CALL p_type_upd_menu()
 
   CLOSE WINDOW p_type_upd_w         # 結束畫面
 
   CALL  cl_used(g_prog,g_time,2)     # 計算使用時間 (退出使間  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
END MAIN
 
FUNCTION p_type_upd_menu()
 
   WHILE TRUE
      CALL p_type_upd_bp("G")
      CASE g_action_choice
 
      WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL p_type_upd_q()
         END IF
 
      WHEN "detail"                            # "B.單身"
         IF cl_chk_act_auth() THEN
            CALL p_type_upd_b()
         ELSE
            LET g_action_choice = " "
         END IF
 
      WHEN "help"
         CALL cl_show_help()
 
      WHEN "exit"
         EXIT WHILE
 
      WHEN "controlg"
         CALL cl_cmdask()
 
      WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gaq),'','')
            END IF
 
       WHEN "showlog"           
         IF cl_chk_act_auth() THEN
            CALL cl_show_log("p_type_upd")
         END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION p_type_upd_q()
 
   CALL p_type_upd_b_askkey()
 
END FUNCTION
 
FUNCTION p_type_upd_b()
   DEFINE l_ac_t          LIKE type_file.num5,    # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT SMALLINT
          l_n             LIKE type_file.num5,    # 檢查重複用        #No.FUN-680135 SMALLINT
          l_modify_flag   LIKE type_file.chr1,    # 單身更改否        #No.FUN-680135 VARCHAR(1)
          l_lock_sw       LIKE type_file.chr1,    # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
          l_exit_sw       LIKE type_file.chr1,    # Esc結束INPUT ARRAY 否 #No.FUN-680135 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,    # 處理狀態          #No.FUN-680135 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,    # 可否新增          #No.FUN-680135 SMALLINT
          l_allow_delete  LIKE type_file.num5,    # 可否刪除          #No.FUN-680135 SMALLINT
          l_jump          LIKE type_file.num5,    # 判斷是否跳過AFTER ROW的處理 #No.FUN-680135 SMALLINT
          l_cnt           LIKE type_file.num5     #No.FUN-680135      SMALLINT
   DEFINE ls_msg_o        STRING
   DEFINE ls_msg_n        STRING
   DEFINE l_sch01         LIKE sch_file.sch01     #FUN-A90024
   
   CALL cl_opmsg('b')
 
   IF s_shut(0) THEN 
      RETURN 
   END IF
 
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   #LET g_forupd_sql = " SELECT gaq01,gaq03,gaq07,'' ",  
   LET g_forupd_sql = " SELECT gaq01,gaq03,'','',gaq07,'','' ",    #no.FUN-820045
                        " FROM gaq_file  WHERE gaq01 = ? ",
                         " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_type_upd_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gaq WITHOUT DEFAULTS FROM s_gaq.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW= FALSE, DELETE ROW= FALSE,
                APPEND ROW= FALSE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gaq_t.* = g_gaq[l_ac].*  #BACKUP
            
            OPEN p_type_upd_bcl USING g_gaq_t.gaq01
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN p_type_upd_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_type_upd_bcl INTO g_gaq[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_type_upd_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  #SELECT gck02 INTO g_gaq[l_ac].gck02
                  SELECT gck02,gck03 INTO g_gaq[l_ac].gck02,g_gaq[l_ac].gck03  #no.FUN-820045
                    FROM gck_file
                   WHERE gck01 = g_gaq[l_ac].gaq07 
                   
                  #---FUN-A90024---start-----
                  #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
                  #目前統一用sch_file紀錄TIPTOP資料結構
                  ##no.FUN-820045 start--
                  #SELECT lower(data_type),to_char(decode(data_precision,null,data_length,data_precision),'9999.99')
                  #  INTO g_gaq[l_ac].ztb04,g_gaq[l_ac].length
                  #  FROM all_tab_columns
                  # WHERE lower(owner)='ds'
                  #   AND lower(column_name)=g_gaq[l_ac].gaq01
                  SELECT sch01 INTO l_sch01 FROM sch_file
                      WHERE sch02 = g_gaq[l_ac].gaq01
                  CALL cl_get_column_info('ds', l_sch01, g_gaq[l_ac].gaq01) 
                      RETURNING g_gaq[l_ac].ztb04,g_gaq[l_ac].length
                  #---FUN-A90024---end-------
                  IF g_gaq[l_ac].ztb04 = 'varchar2' THEN 
                      LET g_gaq[l_ac].length = g_gaq[l_ac].length USING '####'
                  END IF
                  DISPLAY BY NAME g_gaq[l_ac].ztb04
                  DISPLAY BY NAME g_gaq[l_ac].length
                  #no.FUN-820045 end---- 
               END IF
            END IF
            CALL cl_show_fld_cont()          
         END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gaq[l_ac].* TO NULL      
          LET g_gaq_t.* = g_gaq[l_ac].*         #新輸入資料
         
          DISPLAY g_gaq[l_ac].* TO s_gaq[l_sl].* 
          CALL cl_show_fld_cont()               
 
      AFTER FIELD gaq07
        IF NOT cl_null(g_gaq[l_ac].gaq07) THEN
         SELECT count(*) INTO l_cnt FROM gck_file
          WHERE gck01 = g_gaq[l_ac].gaq07
          IF l_cnt = 0 THEN
             CALL cl_err(g_gaq[l_ac].gaq07,'azz-130',0)
             LET g_gaq[l_ac].gaq07 = g_gaq_t.gaq07
             DISPLAY BY NAME g_gaq[l_ac].gaq07
             NEXT FIELD gaq07
          END IF
          #SELECT gck02 INTO g_gaq[l_ac].gck02
          SELECT gck02,gck03 INTO g_gaq[l_ac].gck02,g_gaq[l_ac].gck03 #no.FUN-820045
            FROM gck_file
           WHERE gck01 = g_gaq[l_ac].gaq07 
          DISPLAY BY NAME g_gaq[l_ac].gck02
        END IF
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(gaq07)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gck"
             CALL cl_create_qry() RETURNING g_gaq[l_ac].gaq07,g_gaq[l_ac].gck02
             DISPLAY BY NAME g_gaq[l_ac].gaq07,g_gaq[l_ac].gck02
             NEXT FIELD gaq07
         OTHERWISE EXIT CASE
         END CASE
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gaq[l_ac].* = g_gaq_t.*
             CLOSE p_type_upd_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gaq[l_ac].gaq01,-263,1)
             LET g_gaq[l_ac].* = g_gaq_t.*
          ELSE
             UPDATE gaq_file SET gaq07 = g_gaq[l_ac].gaq07
              WHERE gaq01 = g_gaq_t.gaq01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gaq_file",g_gaq_t.gaq01,"",SQLCA.sqlcode,"","",0)   
                LET g_gaq[l_ac].* = g_gaq_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE p_type_upd_bcl
                COMMIT WORK 
                LET ls_msg_n = g_gaq[l_ac].gaq01 CLIPPED,"",g_gaq[l_ac].gaq03 CLIPPED,"",g_gaq[l_ac].gaq07 CLIPPED
                LET ls_msg_o = g_gaq_t.gaq01 CLIPPED,"",g_gaq_t.gaq03 CLIPPED,"",g_gaq_t.gaq07 CLIPPED
                #CALL cl_log("p_type_upd","U",ls_msg_n,ls_msg_o)    
             END IF
          END IF
         #CALL cl_generate_sch('',g_gaq[l_ac].gaq01)
 
      AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gaq[l_ac].* = g_gaq_t.*
             END IF
             CLOSE p_type_upd_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac
          CLOSE p_type_upd_bcl
          COMMIT WORK
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()
      
   END INPUT
 
   CLOSE p_type_upd_bcl
   COMMIT WORK 
 
END FUNCTION
 
FUNCTION p_type_upd_b_askkey()
 
   CLEAR FORM
   CALL g_gaq.clear()
 
   CONSTRUCT g_wc2 ON gaq01,gaq03,gaq07  
        FROM s_gaq[1].gaq01,s_gaq[1].gaq03,s_gaq[1].gaq07
     ON ACTION CONTROLP
     CASE
       WHEN INFIELD(gaq07)
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_gck"
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO gaq07
         NEXT FIELD gaq07
       OTHERWISE EXIT CASE
       END CASE
   
 
       IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT CONSTRUCT
       END IF
#No.TQC-860017 start
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
#TQC-860017 end
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   CALL p_type_upd_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_type_upd_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(1000)
   DEFINE l_length   LIKE type_file.num20_6    #no.FUN-820045
   DEFINE l_scale    LIKE type_file.num5       #no.FUN-820045
   DEFINE l_sch01    LIKE sch_file.sch01       #FUN-A90024
   DEFINE l_ztb08    base.stringtokenizer      #FUN-A90024
   DEFINE l_i        LIKE type_file.num5       #FUN-A90024
   DEFINE l_ztb08_t  LIKE type_file.num5       #FUN-A90024
 
 
   #LET g_sql = "SELECT gaq01,gaq03,gaq07,'' ", 
   LET g_sql = "SELECT gaq01,gaq03,'','',gaq07,'','' ",   #NO.FUN-820045
               "  FROM gaq_file",
               " WHERE ", p_wc2 CLIPPED,                #單身
               "   AND gaq02 = 0",              #只抓繁中的資料顯示
               " ORDER BY gaq01 "
 
   PREPARE p_type_upd_pb FROM g_sql
   DECLARE gaq_curs CURSOR FOR p_type_upd_pb
 
   CALL g_gaq.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH gaq_curs INTO g_gaq[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach:',SQLCA.SQLCODE,1)
         EXIT FOREACH
      END IF
      #no.FUN-820045 start--
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構
      #SELECT lower(data_type),to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),
      #       data_scale
      #  INTO g_gaq[g_cnt].ztb04,l_length,l_scale
      #  FROM all_tab_columns
      # WHERE lower(owner)='ds'
      #   AND lower(column_name)=g_gaq[g_cnt].gaq01
      SELECT sch01 INTO l_sch01 FROM sch_file
          WHERE sch02 = g_gaq[g_cnt].gaq01
      CALL cl_get_column_info('ds', l_sch01, g_gaq[g_cnt].gaq01) 
          RETURNING g_gaq[g_cnt].ztb04, g_gaq[g_cnt].length
      IF g_gaq[g_cnt].ztb04 = 'number' THEN
         LET l_ztb08 = base.StringTokenizer.create(g_gaq[g_cnt].length, ",")
         LET l_i = 0
         WHILE l_ztb08.hasMoreTokens()
             LET l_ztb08_t = l_ztb08.nextToken()
             CASE l_i
                 WHEN 0
                     LET l_length = l_ztb08_t
                 WHEN 1
                     LET l_scale = l_ztb08_t
             END CASE
             LET l_i = l_i + 1
         END WHILE
         CALL p_type_upd_gettype(g_cnt,g_gaq[g_cnt].ztb04,l_length,l_scale)
      END IF
      #---FUN-A90024---end-------
      IF g_gaq[g_cnt].ztb04 = 'varchar2' OR g_gaq[g_cnt].ztb04 = 'date' THEN
         LET g_gaq[g_cnt].length = g_gaq[g_cnt].length USING '####'
      END IF
      #CALL p_type_upd_gettype(g_cnt,g_gaq[g_cnt].ztb04,l_length,l_scale)  #FUN-750034   #FUN-A90024 mark因上面已利用cl_get_column_info()方式不再需要在這裡再做一次
      #no.FUN-820045 end---- 
      #SELECT gck02 INTO g_gaq[g_cnt].gck02
      SELECT gck02,gck03 INTO g_gaq[g_cnt].gck02,g_gaq[g_cnt].gck03  #no.FUN-820045
        FROM gck_file
       WHERE gck01 = g_gaq[g_cnt].gaq07 
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      
   END FOREACH
   CALL g_gaq.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn  
 
   LET g_cnt=0
 
END FUNCTION
 
 
FUNCTION p_type_upd_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gaq TO s_gaq.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()      
 
      ON ACTION query                  # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail                 # B.單身
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION help                   # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       
 
 
      ON ACTION exit                   # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
  
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg    
         CALL cl_cmdask()     
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
     #ON ACTION showlog                          
     #   LET g_action_choice = "showlog"
     #   EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#NO.FUN-820045 start--------------------------------------
FUNCTION p_type_upd_gettype(p_cnt,l_type,l_length,l_scale)
  DEFINE p_cnt LIKE type_file.num5
  DEFINE l_length   LIKE type_file.num20_6
  DEFINE l_length1  LIKE type_file.chr20
  DEFINE l_type     LIKE ztb_file.ztb03
  DEFINE l_sql      STRING
  DEFINE g_err      STRING
  DEFINE i          LIKE type_file.num5,
       l_scale       LIKE type_file.num5
  
 
         CASE WHEN l_type = 'varchar2'
                   LET l_length1=l_length USING "####"
                   LET g_gaq[p_cnt].length = l_length1 CLIPPED
              WHEN l_type = 'number'
                   LET l_length1=l_length USING "####"
                   LET g_gaq[p_cnt].length=l_length1 CLIPPED
                   LET l_length1=l_scale 
                   IF l_length1<>'0' THEN
                      LET g_gaq[p_cnt].length = g_gaq[p_cnt].length CLIPPED,',',l_length1 CLIPPED
                   END IF
         END CASE
END FUNCTION
 
 
