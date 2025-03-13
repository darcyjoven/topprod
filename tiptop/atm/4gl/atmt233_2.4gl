# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmt233_2.4gl
# Descriptions...: 提案費用資料維護作業
# Date & Author..: 2006/01/13 By Elva
# Modify         : No.FUN-590083 06/03/31 By Alexstar 新增多語言資料顯示功能
# Modify.........: No.FUN-660104 06/06/19 By cl   Error Message  調整
# Modify.........: No.FUN-680120 06/09/01 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0217 06/12/30 By Rayven 取消費用資料維護按鈕中的查詢按鈕
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-940184 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_tqy           RECORD LIKE tqy_file.*,     
    g_tqy_t         RECORD LIKE tqy_file.*,    
    g_tsb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          tsb02      LIKE tsb_file.tsb02,
                          tsb04      LIKE tsb_file.tsb04,
                          tqa02_a    LIKE tqa_file.tqa02,
                          tsb05      LIKE tsb_file.tsb05,
                          oaj02      LIKE oaj_file.oaj02,
                          tsb06      LIKE tsb_file.tsb06,
                          tsb08      LIKE tsb_file.tsb08,
                          tqa02_b    LIKE tqa_file.tqa02,
                          tsb09      LIKE tsb_file.tsb09,
                          tqa02_c    LIKE tqa_file.tqa02,
                          tsb10      LIKE tsb_file.tsb10,
                          tqa02_d    LIKE tqa_file.tqa02,
                          tsb11      LIKE tsb_file.tsb11,
                          tsb12      LIKE tsb_file.tsb12,
                          tsb13      LIKE tsb_file.tsb13
                    END RECORD,
    g_tsb_t         RECORD                 #程式變數 (舊值)
                          tsb02      LIKE tsb_file.tsb02,
                          tsb04      LIKE tsb_file.tsb04,
                          tqa02_a    LIKE tqa_file.tqa02,
                          tsb05      LIKE tsb_file.tsb05,
                          oaj02      LIKE oaj_file.oaj02,
                          tsb06      LIKE tsb_file.tsb06,
                          tsb08      LIKE tsb_file.tsb08,
                          tqa02_b    LIKE tqa_file.tqa02,
                          tsb09      LIKE tsb_file.tsb09,
                          tqa02_c    LIKE tqa_file.tqa02,
                          tsb10      LIKE tsb_file.tsb10,
                          tqa02_d    LIKE tqa_file.tqa02,
                          tsb11      LIKE tsb_file.tsb11,
                          tsb12      LIKE tsb_file.tsb12,
                          tsb13      LIKE tsb_file.tsb13
                    END RECORD,
    g_argv1         LIKE tqy_file.tqy01,
    g_argv2         LIKE tqy_file.tqy02,
    g_wc,g_wc2,g_sql    LIKE type_file.chr1000,    #No.FUN-680120 VARCHAR(300)
    g_flag,g_flag2  LIKE type_file.chr1,           #No.FUN-680120 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-680120 SMALLINT
    l_sl            LIKE type_file.num5             #No.FUN-680120 SMALLINT   #目前處理的SCREEN LINE
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
FUNCTION t233_2_detail(p_tqy01,p_tqy02)
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6B0014
   DEFINE p_tqy01   LIKE tqy_file.tqy01,
          p_tqy02   LIKE tqy_file.tqy02
 
   IF cl_null(p_tqy01) THEN RETURN END IF
 
   LET g_argv1 = p_tqy01
   LET g_argv2 = p_tqy02
 
   WHENEVER ERROR CALL cl_err_msg_log
 
 
   LET g_forupd_sql = "SELECT * FROM tqy_file WHERE tqy01=? AND tqy02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t233_2_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 10
 
   OPEN WINDOW t233_2_w AT  p_row,p_col         #顯示畫面
        WITH FORM "atm/42f/atmt233_8"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL t233_2_q()
   END IF
 
   CALL t233_2_menu()
 
   CLOSE WINDOW t233_2_w                 #結束畫面
 
END FUNCTION
 
#QBE 查詢資料
FUNCTION t233_2_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_tsb.clear()
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
   IF cl_null(g_argv1) THEN
   INITIALIZE g_tqy.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON tqy01,tqy02,tqy03
         ON IDLE g_idle_seconds
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #BUG-4C0121
            CALL cl_about()      #BUG-4C0121
 
         ON ACTION help          #BUG-4C0121
            CALL cl_show_help()  #BUG-4C0121
 
         ON ACTION controlg      #BUG-4C0121
            CALL cl_cmdask()     #BUG-4C0121
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON tsb02,tsb04,tsb05,tsb06,tsb08,  
                         tsb09,tsb10,tsb11,tsb12,tsb13
         FROM s_tsb[1].tsb02,s_tsb[1].tsb04,
              s_tsb[1].tsb05,s_tsb[1].tsb06,
              s_tsb[1].tsb08,s_tsb[1].tsb09,
              s_tsb[1].tsb10,s_tsb[1].tsb11,
              s_tsb[1].tsb12,s_tsb[1].tsb13
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(tsb05) # 費用代碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oaj"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tsb05
                    NEXT FIELD tsb05
            END CASE
               
         ON ACTION about         #BUG-4C0121
            CALL cl_about()      #BUG-4C0121
 
         ON ACTION help          #BUG-4C0121
            CALL cl_show_help()  #BUG-4C0121
 
         ON ACTION controlg      #BUG-4C0121
            CALL cl_cmdask()     #BUG-4C0121
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " tqy01 ='",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc CLIPPED, " AND tqy02 ='",g_argv2,"'"
      END IF
      LET g_wc2 = " 1=1"
   END IF
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  tqy01,tqy02 FROM tqy_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tqy02"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE tqy01,tqy02",
                  "  FROM tqy_file, tsb_file ",
                  " WHERE tqy01 = tsb01 AND tqy02 = tsb02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tqy02"
   END IF
 
   PREPARE t233_2_prepare FROM g_sql
   DECLARE t233_2_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t233_2_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM tqy_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT UNIQUE COUNT(*) ",
                " FROM tqy_file,tsb_file WHERE ",
                " tqy01=tsb01 AND tqy02=tsb02",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t233_2_precount FROM g_sql
   DECLARE t233_2_count CURSOR FOR t233_2_precount
 
END FUNCTION
 
FUNCTION t233_2_menu()
 
   WHILE TRUE
      CALL t233_2_bp("G")
      CASE g_action_choice
#No.TQC-6C0217 --start-- mark
#        WHEN "query" 
#           IF cl_chk_act_auth() THEN
#              CALL t233_2_q()
#           END IF
#No.TQC-6C0217 --end--
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t233_2_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tsb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t233_2_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tsb.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t233_2_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_tqy.* TO NULL
       RETURN
    END IF
    OPEN t233_2_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_tqy.* TO NULL
    ELSE
       OPEN t233_2_count
       FETCH t233_2_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t233_2_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t233_2_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t233_2_cs INTO g_tqy.tqy01,
                                           g_tqy.tqy02
      WHEN 'P' FETCH PREVIOUS t233_2_cs INTO g_tqy.tqy01,
                                           g_tqy.tqy02
      WHEN 'F' FETCH FIRST    t233_2_cs INTO g_tqy.tqy01,
                                           g_tqy.tqy02
      WHEN 'L' FETCH LAST     t233_2_cs INTO g_tqy.tqy01,
                                           g_tqy.tqy02
      WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
                 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
           FETCH ABSOLUTE g_jump t233_2_cs INTO g_tqy.tqy01,
                                                             g_tqy.tqy02
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_tqy.tqy01 CLIPPED,'+',g_tqy.tqy02 
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_tqy.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_tqy.* FROM tqy_file WHERE tqy01 = g_tqy.tqy01 AND tqy02 = g_tqy.tqy02
    IF SQLCA.sqlcode THEN
        LET g_msg=g_tqy.tqy01 CLIPPED,'+',g_tqy.tqy02
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #FUN-660104
        CALL cl_err3("sel","tqy_file","","",SQLCA.sqlcode,"","",0)    #FUN-660104
        INITIALIZE g_tqy.* TO NULL
        RETURN
    END IF
    CALL t233_2_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t233_2_show()
   DEFINE l_sql     LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(1000)
          l_dbs     LIKE type_file.chr21,            #No.FUN-680120 VARCHAR(21)
          l_occ02   LIKE occ_file.occ02
 
   #FUN-A50102--mark--str--
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01=g_tqy.tqy36
   #FUN-A50102--mark--end--
 
  #LET l_sql="SELECT occ02 FROM ",l_dbs CLIPPED,".occ_file", #TQC-940184   
  #LET l_sql="SELECT occ02 FROM ",s_dbstring(l_dbs CLIPPED),"occ_file", #TQC-940184
  LET l_sql="SELECT occ02 FROM ",cl_get_target_table( g_tqy.tqy36, 'occ_file' ), #FUN-A50102  
             " WHERE occ01='",g_tqy.tqy03 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_tqy.tqy36) RETURNING l_sql #FUN-A50102
   PREPARE show_pre FROM l_sql
   EXECUTE show_pre INTO l_occ02
 
   LET g_tqy_t.* = g_tqy.*                #保存單頭舊值
 
   DISPLAY BY NAME g_tqy.tqy01,g_tqy.tqy02,g_tqy.tqy03,
                   g_tqy.tqy14
   DISPLAY l_occ02 TO FORMONLY.occ02
    
   CALL t233_2_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()                    #FUN-590083
 
END FUNCTION
 
#單身
FUNCTION t233_2_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680120 SMALLINT
          l_min           LIKE type_file.num5,                #No.FUN-680120 SMALLINT     
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680120 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680120 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
          l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
          l_tqx07         LIKE tqx_file.tqx07
 
   LET g_action_choice = ""
   IF s_shut(0)  THEN RETURN END IF
   IF g_tqy.tqy01 IS NULL THEN
      RETURN
   END IF
   SELECT tqx07 INTO l_tqx07
     FROM tqx_file
    WHERE tqx01=g_tqy.tqy01
   IF l_tqx07 != '1' THEN
      CALL cl_err(g_tqy.tqy01, 'atm-046', 0)
      RETURN
   END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT tsb02,tsb04,'',tsb05,'',tsb06,tsb08, ",
                      "'',tsb09,'',tsb10,'',tsb11,tsb12,tsb13 ",
                      "  FROM tsb_file",
                      "  WHERE tsb01 = ? AND tsb02 = ?  ",
                      "   AND tsb03 = ?",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t233_2_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_ac=1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_tsb WITHOUT DEFAULTS FROM s_tsb.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_tsb_t.* = g_tsb[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN t233_2_bcl USING g_tqy.tqy01,g_tsb_t.tsb02,
                                  g_tqy.tqy02
            IF STATUS THEN
               CALL cl_err("OPEN t233_2_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t233_2_bcl INTO g_tsb[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_tsb_t.tsb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT tqa02 INTO g_tsb[l_ac].tqa02_a
                 FROM tqa_file
                WHERE tqa01 = g_tsb[l_ac].tsb04
                      AND tqa03='1'
                      AND tqaacti='Y'
               IF SQLCA.sqlcode THEN
                  LET g_tsb[l_ac].tqa02_a='' 
               END IF
               SELECT tqa02 INTO g_tsb[l_ac].tqa02_b
                 FROM tqa_file
                WHERE tqa01 = g_tsb[l_ac].tsb08
                  AND tqa03='8'
                  AND tqaacti='Y'
               IF SQLCA.sqlcode THEN 
                  LET g_tsb[l_ac].tqa02_b='' 
               END IF
               SELECT tqa02 INTO g_tsb[l_ac].tqa02_c
                 FROM tqa_file
                WHERE tqa01 = g_tsb[l_ac].tsb09
                  AND tqa03='7'
                  AND tqaacti='Y'
               IF SQLCA.sqlcode THEN 
                  LET g_tsb[l_ac].tqa02_c=''
               END IF
               SELECT tqa02 INTO g_tsb[l_ac].tqa02_d FROM tqa_file
                WHERE tqa01 = g_tsb[l_ac].tsb10
                  AND tqa03 = '16'
                  AND tqaacti='Y'
               IF SQLCA.sqlcode THEN 
                  LET g_tsb[l_ac].tqa02_d=''
               END IF
               #費用代碼
               SELECT  oaj02 INTO  g_tsb[l_ac].oaj02
                 FROM  oaj_file
                WHERE  oaj01=g_tsb[l_ac].tsb05
                  AND  oajacti='Y'
               IF SQLCA.sqlcode THEN 
                  LET g_tsb[l_ac].oaj02='' 
               END IF    
            END IF
            CALL cl_show_fld_cont()                    #FUN-590083
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO tsb_file(tsb01,tsb02,tsb03,tsb04,
                                 tsb05,tsb06,tsb08,
                                 tsb09,tsb10,tsb11,tsb12,tsb13,
                                 tsbplant,tsblegal) #FUN-980009
         VALUES(g_tqy.tqy01,g_tsb[l_ac].tsb02,
                g_tqy.tqy02,g_tsb[l_ac].tsb04,
                g_tsb[l_ac].tsb05,g_tsb[l_ac].tsb06,
                g_tsb[l_ac].tsb08,
                g_tsb[l_ac].tsb09,g_tsb[l_ac].tsb10,
                g_tsb[l_ac].tsb11,g_tsb[l_ac].tsb12,
                g_tsb[l_ac].tsb13,
                g_plant,g_legal)   #FUN-980009
         IF SQLCA.sqlcode THEN
         #  CALL cl_err(g_tsb[l_ac].tsb02,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("ins","tsb_file",g_tsb[l_ac].tsb02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            ROLLBACK WORK
            CANCEL INSERT
         ELSE
            COMMIT WORK
            MESSAGE 'INSERT O.K'
            CALL t233_2_sum()
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE INSERT
         LET p_cmd = 'a'
         LET l_n = ARR_COUNT()
         INITIALIZE g_tsb[l_ac].* TO NULL      #900423
       # LET g_tsb[l_ac].tsb10=0
         LET g_tsb_t.* = g_tsb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()                    #FUN-590083
         NEXT FIELD tsb02 
 
      BEFORE FIELD tsb02
         IF g_tsb[l_ac].tsb02 IS NULL OR g_tsb[l_ac].tsb02 = 0 THEN           
            SELECT max(tsb02)+1 INTO g_tsb[l_ac].tsb02                        
              FROM tsb_file WHERE tsb01 = g_tqy.tqy01  
               AND tsb03 = g_tqy.tqy02                     
            IF g_tsb[l_ac].tsb02 IS NULL THEN                                 
               LET g_tsb[l_ac].tsb02 = 1                                      
            END IF                                                            
         END IF   
           
      AFTER FIELD tsb02         
         IF g_tsb[l_ac].tsb02 != g_tsb_t.tsb02 OR                          
            g_tsb_t.tsb02 IS NULL THEN                                     
            SELECT count(*) INTO l_n FROM tsb_file                         
             WHERE tsb01 = g_tqy.tqy01 
               AND tsb02 = g_tsb[l_ac].tsb02
               AND tsb03 = g_tqy.tqy02
            IF l_n > 0 THEN                                                
               CALL cl_err('',-239,0)
               NEXT FIELD tsb02                     
            END IF    
         END IF
 
      AFTER FIELD tsb04        
         IF NOT cl_null(g_tsb[l_ac].tsb04) THEN
            SELECT tqa02 INTO g_tsb[l_ac].tqa02_a FROM tqa_file
             WHERE tqa01 = g_tsb[l_ac].tsb04
               AND tqa03='1'
               AND tqaacti='Y'
            DISPLAY g_tsb[l_ac].tqa02_a TO FORMONLY.tqa02_a
            IF SQLCA.sqlcode THEN
            #  CALL cl_err('sel tqa','100',0)   #No.FUN-660104
               CALL cl_err3("sel","tqa_file",g_tsb[l_ac].tsb04,"","100","","sel tqa",1)   #No.FUN-660104
               NEXT FIELD tsb04
            END IF
         END IF
 
      AFTER FIELD tsb05  # 費用代碼
         IF NOT cl_null(g_tsb[l_ac].tsb05) THEN
            SELECT  oaj02 INTO g_tsb[l_ac].oaj02
              FROM  oaj_file
             WHERE  oaj01=g_tsb[l_ac].tsb05
               AND  oajacti='Y'
            IF SQLCA.sqlcode THEN
            #  CALL cl_err('sel oaj_file','100',0)   #No.FUN-660104
               CALL cl_err3("sel","oaj_file",g_tsb[l_ac].tsb05,"","100","","sel oaj_file",1)   #No.FUN-660104
               NEXT FIELD tsb05
            END IF
         END IF
      
      AFTER FIELD tsb06
         IF NOT cl_null(g_tsb[l_ac].tsb06) THEN
            IF g_tsb[l_ac].tsb06 <= 0 THEN
               CALL cl_err('','atm-370',0)
               NEXT FIELD tsb06
            END IF
         END IF
         
      AFTER FIELD tsb08   #費用支付對象
         IF NOT cl_null(g_tsb[l_ac].tsb08) THEN
            SELECT tqa02 INTO g_tsb[l_ac].tqa02_b FROM tqa_file
             WHERE tqa01 = g_tsb[l_ac].tsb08
               AND tqa03 = '8'
               AND tqaacti='Y'
            DISPLAY g_tsb[l_ac].tqa02_b TO FORMONLY.tqa02_b
            IF SQLCA.sqlcode THEN
            #  CALL cl_err('sel tqa','100',0)   #No.FUN-660104
               CALL cl_err3("sel","tqa_file",g_tsb[l_ac].tsb08,"","100","","sel tqa",1)   #No.FUN-660104
               NEXT FIELD tsb08
            END IF
         END IF
 
      AFTER FIELD tsb09   #費用支付方式
         IF NOT cl_null(g_tsb[l_ac].tsb09) THEN
            SELECT tqa02 INTO g_tsb[l_ac].tqa02_c FROM tqa_file
             WHERE tqa01 = g_tsb[l_ac].tsb09
               AND tqa03 = '7'
               AND tqaacti='Y'
            DISPLAY g_tsb[l_ac].tqa02_c TO FORMONLY.tqa02_c
            IF SQLCA.sqlcode THEN
            #  CALL cl_err('sel tqa','100',0)   #No.FUN-660104
               CALL cl_err3("sel","tqa_file",g_tsb[l_ac].tsb09,"","100","","sel tqa",1)   #No.FUN-660104
               NEXT FIELD tsb09
            END IF
         END IF
           
      AFTER FIELD tsb10  
         IF NOT cl_null(g_tsb[l_ac].tsb10) THEN
            SELECT tqa02 INTO g_tsb[l_ac].tqa02_d FROM tqa_file
             WHERE tqa01 = g_tsb[l_ac].tsb10
               AND tqa03 = '16'
               AND tqaacti='Y'
            DISPLAY g_tsb[l_ac].tqa02_d TO FORMONLY.tqa02_d
            IF SQLCA.sqlcode THEN
            #  CALL cl_err('sel tqa','100',0)   #No.FUN-660104
               CALL cl_err3("sel","tqa_file",g_tsb[l_ac].tsb10,"","100","","sel tqa",1)   #No.FUN-660104
               NEXT FIELD tsb10
            END IF
         END IF
         
      AFTER FIELD tsb11         
         IF NOT cl_null(g_tsb[l_ac].tsb11) AND 
            NOT cl_null(g_tsb[l_ac].tsb12) THEN
            IF g_tsb[l_ac].tsb12<g_tsb[l_ac].tsb11 THEN
               CALL cl_err('','mfg5067',0)
               NEXT FIELD tsb11
            END IF
         END IF
         
      AFTER FIELD tsb12
         IF NOT cl_null(g_tsb[l_ac].tsb11) AND 
            NOT cl_null(g_tsb[l_ac].tsb12) THEN
            IF g_tsb[l_ac].tsb12<g_tsb[l_ac].tsb11 THEN
               CALL cl_err('','mfg5067',0)
               NEXT FIELD tsb12
            END IF
         END IF
          
      BEFORE DELETE                            #是否取消單身
         IF g_tsb_t.tsb04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM tsb_file
             WHERE tsb01  = g_tqy.tqy01 
               AND tsb02  = g_tsb_t.tsb02
               AND tsb03  = g_tqy.tqy02
                       
            IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_tsb_t.tsb04,SQLCA.sqlcode,0)   #No.FUN-660104
               CALL cl_err3("del","tsb_file",g_tsb_t.tsb04,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
               ROLLBACK WORK
               CANCEL DELETE
            END IF
	    COMMIT WORK
            CALL t233_2_sum()
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_tsb[l_ac].* = g_tsb_t.*
            CLOSE t233_2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_tsb[l_ac].tsb04,-263,1)
            LET g_tsb[l_ac].* = g_tsb_t.*
         ELSE
            UPDATE tsb_file SET tsb02 = g_tsb[l_ac].tsb02,
                                   tsb04 = g_tsb[l_ac].tsb04,
                                   tsb05 = g_tsb[l_ac].tsb05,
                                   tsb06 = g_tsb[l_ac].tsb06,
                                   tsb08 = g_tsb[l_ac].tsb08,
                                   tsb09 = g_tsb[l_ac].tsb09,
                                   tsb10 = g_tsb[l_ac].tsb10,
                                   tsb11 = g_tsb[l_ac].tsb11,
                                   tsb12 = g_tsb[l_ac].tsb12,
                                   tsb13 = g_tsb[l_ac].tsb13
             WHERE tsb01 = g_tqy.tqy01 
               AND tsb02 = g_tsb_t.tsb02
               AND tsb03 = g_tqy.tqy02 
             IF SQLCA.sqlcode THEN
             #  CALL cl_err(g_tsb[l_ac].tsb02,SQLCA.sqlcode,0)   #No.FUN-660104
                CALL cl_err3("upd","tsb_file",g_tsb[l_ac].tsb02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                LET g_tsb[l_ac].* = g_tsb_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
		COMMIT WORK
                CALL t233_2_sum()
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30033 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #CKP
             IF p_cmd='u' THEN
                LET g_tsb[l_ac].* = g_tsb_t.*  
             #FUN-D30033--add--begin--
             ELSE
                CALL g_tsb.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end----
             END IF
             CLOSE t233_2_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30033 add
          #CKP
          #LET g_tsb_t.* = g_tsb[l_ac].*          # 900423
          CLOSE t233_2_bcl
          COMMIT WORK
 
       ON ACTION CONTROLP
          CASE 
             WHEN INFIELD(tsb04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tqa1"
                  LET g_qryparam.default1 = g_tsb[l_ac].tsb04
                  LET g_qryparam.arg1  ='1'
                  CALL cl_create_qry() RETURNING g_tsb[l_ac].tsb04
                  DISPLAY BY NAME  g_tsb[l_ac].tsb04
                  NEXT FIELD tsb04
             WHEN INFIELD(tsb05) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_oaj"
                  LET g_qryparam.default1 = g_tsb[l_ac].tsb05
                  LET g_qryparam.where = " oajacti = 'Y' "
                  CALL cl_create_qry() RETURNING g_tsb[l_ac].tsb05
                  DISPLAY BY NAME  g_tsb[l_ac].tsb05
                  NEXT FIELD tsb05   
             WHEN INFIELD(tsb08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tqa1"
                  LET g_qryparam.default1 = g_tsb[l_ac].tsb08
                  LET g_qryparam.arg1  ='8'
                  CALL cl_create_qry() RETURNING g_tsb[l_ac].tsb08
                  DISPLAY BY NAME g_tsb[l_ac].tsb08
                  NEXT FIELD tsb08
             WHEN INFIELD(tsb09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tqa1"
                  LET g_qryparam.default1 = g_tsb[l_ac].tsb09
                  LET g_qryparam.arg1  ='7'
                  CALL cl_create_qry() RETURNING g_tsb[l_ac].tsb09
                  DISPLAY BY NAME g_tsb[l_ac].tsb09
                  NEXT FIELD tsb09
              WHEN INFIELD(tsb10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_tqa1"
                  LET g_qryparam.default1 = g_tsb[l_ac].tsb10
                  LET g_qryparam.arg1  ='16'
                  CALL cl_create_qry() RETURNING g_tsb[l_ac].tsb10
                  DISPLAY BY NAME g_tsb[l_ac].tsb10
                  NEXT FIELD tsb10
          END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(tsb03) AND l_ac > 1 THEN
             LET g_tsb[l_ac].* = g_tsb[l_ac-1].*
             NEXT FIELD tsb02
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #BUG-4C0121
          CALL cl_about()      #BUG-4C0121
 
       ON ACTION help          #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
 
#No.FUN-6B0031--Begin                                                           
       ON ACTION CONTROLS                                                      
          CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
    END INPUT
 
   #MARK BY ELVA 是否將此門店費用信息復制到其他門店
  { SELECT MIN(tsb02) INTO l_min FROM tsb_file
     WHERE tsb01=g_tqy.tqy01
    IF g_tqy.tqy02=l_min THEN
       IF cl_confirm('atm-023') THEN
          CALL t233_2_copy()
       END IF
    END IF   }
 
    CLOSE t233_2_bcl
    COMMIT WORK
 
END FUNCTION
 
#計算費用合計
FUNCTION t233_2_sum()
   DEFINE l_tqx17 LIKE tqx_file.tqx17
 
   SELECT SUM(tsb06) INTO g_tqy.tqy14
     FROM tsb_file
    WHERE tsb01=g_tqy.tqy01
      AND tsb03=g_tqy.tqy02
   IF SQLCA.SQLCODE THEN
      LET g_tqy.tqy14=0
   END IF
   UPDATE tqy_file SET tqy14=g_tqy.tqy14
    WHERE tqy01=g_tqy.tqy01
      AND tqy02=g_tqy.tqy02
 
   DISPLAY BY NAME g_tqy.tqy14
 
   SELECT SUM(tqy14) INTO l_tqx17
     FROM tqy_file
    WHERE tqy01=g_tqy.tqy01
    #  AND tqy02=g_tqy.tqy02
   IF SQLCA.SQLCODE THEN
      LET l_tqx17=0
   END IF
   UPDATE tqx_file SET tqx17=l_tqx17
    WHERE tqx01=g_tqy.tqy01
 
END FUNCTION
{
FUNCTION t233_2_copy()
   DEFINE l_tsb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                         tsb02      LIKE tsb_file.tsb02,
                         tsb04      LIKE tsb_file.tsb04,
                         tsb05      LIKE tsb_file.tsb05,
                         tsb06      LIKE tsb_file.tsb06,
                         tsb08      LIKE tsb_file.tsb08,
                         tsb09      LIKE tsb_file.tsb09,
                         tsb10      LIKE tsb_file.tsb10,
                         tsb11      LIKE tsb_file.tsb11,
                         tsb12      LIKE tsb_file.tsb12,
                         tsb13      LIKE tsb_file.tsb13
                      END RECORD,
          l_tqy02 LIKE tqy_file.tqy02
 
   LET g_sql = "SELECT tqy02 FROM tqy_file",
               " WHERE tqy01 ='",g_tqy.tqy01,"'",
               "   AND tqy02!='",g_tqy.tqy02,"'"
   PREPARE t233_2_pb1 FROM g_sql
   DECLARE tsb_cs1 CURSOR FOR t233_2_pb1 
 
   CALL g_tsb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH tsb_cs1 INTO l_tqy02
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      ELSE
         LET g_sql = "SELECT tsb02,tsb04,tsb05,tsb06,",
                     "       tsb08,tsb09,tsb10,tsb11,",
                     "       tsb12,tsb13",
                     "  FROM tsb_file",
                     " WHERE tsb01 ='",g_tqy.tqy01,"'",
                     "   AND tsb03 ='",g_tqy.tqy02,"' "
         PREPARE t233_2_pb2 FROM g_sql
         DECLARE tsb_cs2                       #SCROLL CURSOR
         CURSOR FOR t233_2_pb2
 
         CALL l_tsb.clear()
         LET g_cnt = 1
         LET g_rec_b = 0
         FOREACH tsb_cs2 INTO l_tsb[g_cnt].*   #單身 ARRAY 填充
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            ELSE
               INSERT INTO tsb_file (tsb01,tsb02,tsb03,tsb04,
                                     tsb05,tsb06,tsb08,tsb09,
                                     tsb10,tsb11,tsb12,tsb13,
                                     tsbplant,tsblegal) #FUN-980009
               VALUES(g_tqy.tqy01,l_tsb[g_cnt].tsb02,l_tqy02,
                      l_tsb[g_cnt].tsb04,
                      l_tsb[g_cnt].tsb05,l_tsb[g_cnt].tsb06,
                      l_tsb[g_cnt].tsb08,l_tsb[g_cnt].tsb09,
                      l_tsb[g_cnt].tsb10,l_tsb[g_cnt].tsb11,
                      l_tsb[g_cnt].tsb12,l_tsb[g_cnt].tsb13,
                      g_plant,g_legal) #FUN-980009
               IF SQLCA.sqlcode THEN
               #  CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660104
                  CALL cl_err3("ins","tsb_file",g_tqy.tqy01,l_tsb[g_cnt].tsb02,SQLCA.sqlcode,"","",1)   #No.FUN-660104
               ELSE
                  LET g_cnt=g_cnt+1
                  MESSAGE 'INSERT O.K'
               END IF
            END IF
         END FOREACH
      END IF
   END FOREACH
   CALL t233_2_b_fill('1=1')
END FUNCTION }
 
FUNCTION t233_2_b_askkey()
   DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON tsb02,tsb04,tsb05,tsb06,tsb08,
                      tsb09,tsb10,tsb11,tsb12,tsb13
      FROM s_tsb[1].tsb02,s_tsb[1].tsb04,
           s_tsb[1].tsb05,s_tsb[1].tsb06,
           s_tsb[1].tsb08,s_tsb[1].tsb09,
           s_tsb[1].tsb10,s_tsb[1].tsb11,
           s_tsb[1].tsb12,s_tsb[1].tsb13
         
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
  
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL t233_2_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t233_2_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
   LET g_sql ="SELECT tsb02,tsb04,'',tsb05,'',tsb06,tsb08,'',",
              "       tsb09,'',tsb10,'',tsb11,tsb12,tsb13",
              "  FROM tsb_file",
              " WHERE tsb01 ='",g_tqy.tqy01,"'",
              "   AND tsb03 ='",g_tqy.tqy02,"'", 
              "   AND ", p_wc2 CLIPPED,                     #單身
              " ORDER BY tsb02"
   PREPARE t233_2_pb FROM g_sql
   DECLARE tsb_cs                       #SCROLL CURSOR
      CURSOR FOR t233_2_pb
 
   CALL g_tsb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH tsb_cs INTO g_tsb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT tqa02 INTO g_tsb[g_cnt].tqa02_a
        FROM tqa_file
       WHERE tqa01 = g_tsb[g_cnt].tsb04
         AND tqa03='1'
         AND tqaacti='Y'
      IF SQLCA.sqlcode THEN
         LET g_tsb[g_cnt].tqa02_a='' 
      END IF
      SELECT tqa02 INTO g_tsb[g_cnt].tqa02_b
        FROM tqa_file
       WHERE tqa01 = g_tsb[g_cnt].tsb08
         AND tqa03='8'
         AND tqaacti='Y'
      IF SQLCA.sqlcode THEN 
         LET g_tsb[g_cnt].tqa02_b='' 
      END IF
      SELECT tqa02 INTO g_tsb[g_cnt].tqa02_c
        FROM tqa_file
       WHERE tqa01 = g_tsb[g_cnt].tsb09
         AND tqa03='7'
         AND tqaacti='Y'
      IF SQLCA.sqlcode THEN 
         LET g_tsb[g_cnt].tqa02_c=''
      END IF
      SELECT tqa02 INTO g_tsb[g_cnt].tqa02_d
        FROM tqa_file
       WHERE tqa01 = g_tsb[g_cnt].tsb10
         AND tqa03='16'
         AND tqaacti='Y'
      IF SQLCA.sqlcode THEN 
         LET g_tsb[g_cnt].tqa02_d=''
      END IF
      #費用代碼
      SELECT  oaj02 INTO  g_tsb[g_cnt].oaj02
        FROM  oaj_file
       WHERE  oaj01=g_tsb[g_cnt].tsb05
         AND  oajacti='Y'
      IF SQLCA.sqlcode THEN 
         LET g_tsb[g_cnt].oaj02='' 
      END IF    
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
   END FOREACH
   #CKP
   CALL g_tsb.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t233_2_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tsb TO s_tsb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         CALL cl_show_fld_cont()                    #FUN-590083
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
#No.TQC-6C0217 --start-- mark
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#No.TQC-6C0217 --end--
 
      ON ACTION first
         CALL t233_2_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION previous
         CALL t233_2_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION jump
         CALL t233_2_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION next
         CALL t233_2_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION last
         CALL t233_2_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #FUN-590083 ---start---
      AFTER DISPLAY
         CONTINUE DISPLAY
      #FUN-590083 ---end---
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t233_2_bp_refresh()
   DISPLAY ARRAY g_tsb TO s_tsb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
   
   END DISPLAY
END FUNCTION
