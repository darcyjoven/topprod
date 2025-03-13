# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aemi115.4gl
# Descriptions...: 人員工種資料維護作業
# Date & Author..: 04/09/24 by Carrier
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/23 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0050 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0029 06/11/17 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780037 07/06/29 By sherry 報表格式修改為p_query 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_trw01          LIKE trw_file.trw01,
    g_trw02          LIKE trw_file.trw02,
    g_trx            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variatpss)
        trx02        LIKE trx_file.trx02,
        gen02        LIKE gen_file.gen02,
        trx03        LIKE trx_file.trx03
                     END RECORD,
    g_trx_t          RECORD                 #程式變數 (舊值)
        trx02        LIKE trx_file.trx02,
        gen02        LIKE gen_file.gen02,
        trx03        LIKE trx_file.trx03
                     END RECORD,
   #g_wc,g_wc2,g_sql VARCHAR(300),    #TQC-630166
    g_wc,g_wc2,g_sql STRING,       #TQC-630166
    g_rec_b          LIKE type_file.num5,      #單身筆數             #No.FUN-680072 SMALLINT
    l_ac             LIKE type_file.num5       #目前處理的ARRAY CNT  #No.FUN-680072 SMALLINT
DEFINE   p_row,p_col         LIKE type_file.num5                     #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5                     #No.FUN-680072 SMALLINT
 
DEFINE   g_forupd_sql        STRING        #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt               LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_chr               LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE   g_i                 LIKE type_file.num5          #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg               LIKE ze_file.ze03           #No.FUN-680072CHAR(72)
DEFINE   g_row_count         LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_curs_index        LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_jump              LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   mi_no_ask           LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037     
 
#主程式開始
MAIN
# DEFINE      l_time    LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
    LET g_forupd_sql = "SELECT trw01,trw02 FROM trw_file WHERE trw01 = ? AND trw02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i115_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i115_w AT p_row,p_col WITH FORM "aem/42f/aemi115"
         ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL g_x.clear()
 
 
    CALL i115_menu()
 
    CLOSE WINDOW i115_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i115_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                                   #清除畫面
    CALL g_trx.clear()
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0029
 
   INITIALIZE g_trw01 TO NULL    #No.FUN-750051
   INITIALIZE g_trw02 TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON trw01,trw02        # 螢幕上取單頭條件
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(trw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_trw"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO trw01
                  NEXT FIELD trw01
          END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND trwuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND trwgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND trwgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('trwuser', 'trwgrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON trx02,trx03
               FROM s_trx[1].trx02,s_trx[1].trx03
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(trx02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO trx02
                  NEXT FIELD trx02
          END CASE
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT trw01,trw02 FROM trw_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY trw01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE trw01,trw02 ",
                   "  FROM trw_file, trx_file ",
                   " WHERE trw01 = trx01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY trw01"
    END IF
 
    PREPARE i115_prepare FROM g_sql
    DECLARE i115_cs                         #SCROLL CURSOR
     SCROLL CURSOR WITH HOLD FOR i115_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(UNIQUE trw01) FROM trw_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(UNIQUE trw01) FROM trw_file,trx_file ",
                  " WHERE trw01=trx01 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i115_precount FROM g_sql
    DECLARE i115_count CURSOR FOR i115_precount
 
END FUNCTION
 
#中文的MENU
FUNCTION i115_menu()
 
   WHILE TRUE
      CALL i115_bp("G")
      CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i115_q()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i115_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
           #No.FUN-780037---Begin  
           #  CALL i115_out()
              IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
              LET l_cmd = 'p_query "aemi115" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'               
              CALL cl_cmdrun(l_cmd)    
           #No.FUN-780037---End  
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No.FUN-6B0050-------add--------str----
        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_trw01 IS NOT NULL THEN
               LET g_doc.column1 = "trw01"
               LET g_doc.column2 = "trw02"
               LET g_doc.value1 = g_trw01
               LET g_doc.value2 = g_trw02
               CALL cl_doc()
            END IF 
         END IF
        #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i115_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_trw01 TO NULL               #No.FUN-6B0050
    INITIALIZE g_trw02 TO NULL               #No.FUN-6B0050
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_trx.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL i115_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_trw01 TO NULL
        INITIALIZE g_trw02 TO NULL
        RETURN
    END IF
 
    OPEN i115_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_trw01 TO NULL
        INITIALIZE g_trw02 TO NULL
    ELSE
        OPEN i115_count
        FETCH i115_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i115_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i115_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i115_cs INTO g_trw01,g_trw02
        WHEN 'P' FETCH PREVIOUS i115_cs INTO g_trw01,g_trw02
        WHEN 'F' FETCH FIRST    i115_cs INTO g_trw01,g_trw02
        WHEN 'L' FETCH LAST     i115_cs INTO g_trw01,g_trw02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######trw for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
             END IF
             FETCH ABSOLUTE g_jump i115_cs INTO g_trw01,g_trw02
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_trw01,SQLCA.sqlcode,0)
       INITIALIZE g_trw01 TO NULL  #TQC-6B0105
       INITIALIZE g_trw02 TO NULL  #TQC-6B0105
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
 
    CALL i115_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i115_show()
    DISPLAY g_trw01,g_trw02 TO trw01,trw02         # 顯示單頭值
    CALL i115_b_fill(g_wc2)                        #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i115_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重復用        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,     #檢查重復用        #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否          #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_trw01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT trx02,'',trx03 ",
                       "  FROM trx_file  ",
                       " WHERE trx01=? AND trx02=? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i115_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_trx WITHOUT DEFAULTS FROM s_trx.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
 
            BEGIN WORK
            OPEN i115_cl USING g_trw01,g_trw02
            IF STATUS THEN
               CALL cl_err('OPEN i115_cl:',STATUS,1)
               CLOSE i115_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i115_cl INTO g_trw01,g_trw02      # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_trw01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i115_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_trx_t.* = g_trx[l_ac].*  #BACKUP
               OPEN i115_b_cl USING g_trw01,g_trx_t.trx02
               IF STATUS THEN
                  CALL cl_err('OPEN i115_b_cl:', STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i115_b_cl INTO g_trx[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_trx_t.trx02,SQLCA.sqlcode,1)
                      LET l_lock_sw = 'Y'
                  END IF
               END IF
               CALL i115_trx02('d')
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_trx[l_ac].* TO NULL      #900423
            LET g_trx_t.* = g_trx[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD trx02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO trx_file(trx01,trx02,trx03)
            VALUES(g_trw01,g_trx[l_ac].trx02,g_trx[l_ac].trx03)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_trx[l_ac].trx02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("ins","trx_file",g_trw01,g_trx[l_ac].trx02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        AFTER FIELD trx02
            IF NOT cl_null(g_trx[l_ac].trx02) THEN
               IF g_trx[l_ac].trx02 != g_trx_t.trx02
                  OR g_trx_t.trx02 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM trx_file
                   WHERE trx01 = g_trw01
                     AND trx02 = g_trx[l_ac].trx02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_trx[l_ac].trx02 = g_trx_t.trx02
                     NEXT FIELD trx02
                  ELSE
                     CALL i115_trx02('a')
                     IF NOT cl_null(g_errno)  THEN
                        CALL cl_err(g_trx[l_ac].trx02,g_errno,0)
                        NEXT FIELD trx02
                     END IF
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_trx_t.trx02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM trx_file
                 WHERE trx01 = g_trw01
                   AND trx02 = g_trx_t.trx02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_trx_t.trx02,SQLCA.sqlcode,0)   #No.FUN-660092
                    CALL cl_err3("del","trx_file",g_trw01,g_trx_t.trx02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_trx[l_ac].* = g_trx_t.*
               CLOSE i115_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_trx[l_ac].trx02,-263,1)
               LET g_trx[l_ac].* = g_trx_t.*
            ELSE
               UPDATE trx_file
                  SET trx02 = g_trx[l_ac].trx02,
                      trx03 = g_trx[l_ac].trx03
                WHERE CURRENT OF i115_b_cl
               IF SQLCA.sqlcode OR STATUS=100 THEN
#                  CALL cl_err(g_trx[l_ac].trx02,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("upd","trx_file",g_trx[l_ac].trx02,g_trx[l_ac].trx03,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   LET g_trx[l_ac].* = g_trx_t.*
                   CLOSE i115_b_cl
                  ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_trx[l_ac].* = g_trx_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_trx.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--

               END IF
               CLOSE i115_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i115_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i115_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(trx02) AND l_ac > 1 THEN
                LET g_trx[l_ac].* = g_trx[l_ac-1].*
                NEXT FIELD trx02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
 
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(trx02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gen"
                   LET g_qryparam.default1 = g_trx[l_ac].trx02
                   CALL cl_create_qry() RETURNING g_trx[l_ac].trx02
                   NEXT FIELD trx02
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
        END INPUT
 
    CLOSE i115_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i115_b_askkey()
DEFINE
    #l_wc2           VARCHAR(200)#TQC-630166
     l_wc2           STRING   #TQC-630166
 
    CONSTRUCT l_wc2 ON trx02,trx03
            FROM s_trx[1].trx02,s_trx[1].trx03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(trx02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO trx02
                  NEXT FIELD trx02
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i115_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i115_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    #p_wc2           VARCHAR(200)#TQC-630166
     p_wc2           STRING   #TQC-630166
 
    LET g_sql = "SELECT trx02,gen02,trx03 ",
                "  FROM trx_file LEFT OUTER JOIN gen_file ON trx_file.trx02 = gen_file.gen01 ",
                " WHERE trx01 ='",g_trw01,"'",
                "  AND ",p_wc2 CLIPPED,
                " ORDER BY trx02 "
    PREPARE i115_pb FROM g_sql
    DECLARE trx_cs CURSOR FOR i115_pb
 
    #單身 ARRAY 乾洗
    CALL g_trx.clear()
    LET g_cnt = 1
    FOREACH trx_cs INTO g_trx[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_trx.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i115_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_trx TO s_trx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i115_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###trw in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######trw in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i115_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###trw in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######trw in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i115_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###trw in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######trw in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i115_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###trw in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######trw in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i115_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###trw in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######trw in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i115_trx02(p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file
   WHERE gen01 = g_trx[l_ac].trx02
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
       WHEN l_genacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_trx[l_ac].gen02 = l_gen02
  END IF
END FUNCTION
 
#No.FUN-780037---Begin
{FUNCTION i115_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680072 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680072 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,  #No.FUN-680072 VARCHAR(40)
        l_chr           LIKE type_file.chr1,     #No.FUN-680072 VARCHAR(1)
    sr              RECORD
        trw01       LIKE trw_file.trw01,
        trw02       LIKE trw_file.trw02,
        trx02       LIKE trx_file.trx02,
        gen02       LIKE gen_file.gen02,
        trx03       LIKE trx_file.trx03
                    END RECORD
 
 
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('aemi115') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT trw01,trw02,trx02,gen02,trx03 ",    # 組合出 SQL 指令
              "  FROM trw_file LEFT OUTER JOIN trx_file LEFT OUTER JOIN gen_file ON trx_file.trx02=gen_file.gen01 ON trw_file.trw01=trx_file.trx01  ",
              " WHERE  ",
              "   AND ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY trw01,trx02"
    PREPARE i115_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i115_co CURSOR FOR i115_p1
 
    START REPORT i115_rep TO l_name
 
    FOREACH i115_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
           END IF
        OUTPUT TO REPORT i115_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i115_rep
 
    CLOSE i115_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i115_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680072 VARCHAR(1)    
        l_chr           LIKE type_file.chr1,           #No.FUN-680072 VARCHAR(1)
        sr              RECORD
            trw01       LIKE trw_file.trw01,
            trw02       LIKE trw_file.trw02,
            trx02       LIKE trx_file.trx02,
            gen02       LIKE gen_file.gen02,
            trx03       LIKE trx_file.trx03
                        END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.trw01,sr.trx02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<', "/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31], g_x[32], g_x[33], g_x[34], g_x[35]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.trw01,
                  COLUMN g_c[32],sr.trw02,
                  COLUMN g_c[33],sr.trx02,
                  COLUMN g_c[34],sr.gen02,
                  COLUMN g_c[35],sr.trx03
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc2,'trw01,trx02,trx03')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
	       #        PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
	       #        PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
	       #       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
               CALL cl_prt_pos_wc(g_sql)
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-780037---End
