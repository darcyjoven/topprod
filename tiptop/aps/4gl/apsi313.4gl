# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsi313.4gl
# Descriptions...: 產品結構資料維護作業
# Date & Author..: FUN-850114 07/12/20 BY yiting
# Modify ........: FUN-840209 08/05/19 BY DUKE  ADD bmb29=' '
# Modify.........: FUN-860060 08/06/23 by duke
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50022 11/05/17 By Mandy---GP5.25 追版-------------str---
# Modify.........: FUN-9C0022 09/12/08 By Mandy vom14(展元件需求)及vom15(客供料)欄位從畫面上隱藏掉,暫不提供此功能
# Modify.........: No.FUN-B50022 11/05/17 By Mandy---GP5.25 追版-------------end---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmo01       LIKE vmo_file.vmo01,   #FUN-850114
    g_vmo01_t     LIKE vmo_file.vmo01,
    g_vmo       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                      vmo03         LIKE vmo_file.vmo03,
                      vmo02         LIKE vmo_file.vmo02,
                      #vmo11         LIKE vmo_file.vmo11, #FUN-860060
                      vmo13         LIKE vmo_file.vmo13,
                      vmo14         LIKE vmo_file.vmo14,
                      vmo15         LIKE vmo_file.vmo15 ,
                      vmo16         LIKE vmo_file.vmo16,
                      vmo17         LIKE vmo_file.vmo17,
                      vmo18         LIKE vmo_file.vmo18
                    END RECORD,
    g_vmo_t     RECORD                 #程式變數 (舊值)
                      vmo03         LIKE vmo_file.vmo03,
                      vmo02         LIKE vmo_file.vmo02,
                      #vmo11         LIKE vmo_file.vmo11, #FUN-860060
                      vmo13         LIKE vmo_file.vmo13,
                      vmo14         LIKE vmo_file.vmo14,
                      vmo15         LIKE vmo_file.vmo15 ,
                      vmo16         LIKE vmo_file.vmo16,
                      vmo17         LIKE vmo_file.vmo17,
                      vmo18         LIKE vmo_file.vmo18
                    END RECORD,
    g_wc,g_sql      string,  #No.FUN-580092 HCN
    g_wc2           string,  #No.FUN-580092 HCN
    g_argv1         LIKE vmo_file.vmo01,
    g_rec_b         LIKE type_file.num5,     #單身筆數             #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE g_msg          LIKE ze_file.ze03      #No.FUN-690010 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
 
    LET g_argv1 = ARG_VAL(1)
    LET g_vmo01 = g_argv1
 
    OPEN WINDOW i313_w WITH FORM "aps/42f/apsi313"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    CALL cl_set_comp_visible("vmo14,vmo15",FALSE) #FUN-9C0022 add
 
    IF NOT cl_null(g_argv1) THEN
       CALL i313_q()
       #CALL i313_b()   #FUN-860060
    END IF
 
    CALL i313_menu()
 
    CLOSE WINDOW i313_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i313_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                              #清除畫面
 
    IF cl_null(g_argv1) THEN
    INITIALIZE g_vmo01 TO NULL
        CONSTRUCT BY NAME g_wc ON vmo01   #螢幕上取單頭條件
 
           #No.FUN-580031 --start--     HCN
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
           #No.FUN-580031 --end--       HCN
 
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
              CALL cl_qbe_list() RETURNING lc_qbe_sn
              CALL cl_qbe_display_condition(lc_qbe_sn)
           #No.FUN-580031 --end--       HCN
        END CONSTRUCT
    ELSE
        DISPLAY g_argv1 TO vmo01
        LET g_wc = " vmo01 ='",g_argv1,"'"
    END IF
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bmbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bmbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bmbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmbuser', 'bmbgrup')
    #End:FUN-980030
 
    IF cl_null(g_argv1) THEN  
       CONSTRUCT g_wc2 ON vmo03,vmo02,vmo13,
                          vmo14,vmo15,vmo16,vmo17,vmo18
            FROM s_vmo[1].vmo03,s_vmo[1].vmo02,
                 s_vmo[1].vmo13,
                 s_vmo[1].vmo14,s_vmo[1].vmo15,s_vmo[1].vmo16,
                 s_vmo[1].vmo17,s_vmo[1].vmo18
 
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
 
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
    ELSE
        LET g_wc2 = " 1=1"
    END IF
    IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE vmo01 FROM vmo_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1 "
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE vmo01 ",
                   "  FROM bmb_file, vmo_file ",
                   " WHERE bmb01 = vmo01 ",
                   "   AND bmb02 = vmo03 ",
                   "   AND bmb03 = vmo02 ",
                   #"   AND bmb29 = ' '   ",  #FUN-840209   #FUN-860060 MARK
                   "   AND ", g_wc  CLIPPED,
                   "   AND ", g_wc2 CLIPPED,
                   " ORDER BY 1 "
    END IF
 
    PREPARE i313_prepare FROM g_sql
    DECLARE i313_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i313_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(unique vmo01) FROM vmo_file,bmb_file ",
                 "WHERE ",g_wc CLIPPED,
                 "  AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                 "  AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
                 "  AND bmb01=vmo01",
                 "  AND bmb02=vmo03",
                 "  AND bmb03=vmo02"
                 #"  AND bmb29=' '  "  #FUN-840209   #FUN-860060  MARK
    ELSE
        LET g_sql="SELECT COUNT(unique vmo01) FROM vmo_file,bmb_file ",
                  "WHERE ",g_wc  CLIPPED,
                  "  AND ",g_wc2 CLIPPED,
                  "  AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                  "  AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
                  "  AND bmb01=vmo01",
                  "  AND bmb02=vmo03",
                  "  AND bmb03=vmo02"
                  #"  AND bmb29=' '  " #FUN-840209  #FUN-860060 MARK
    END IF
    PREPARE i313_precount FROM g_sql
    DECLARE i313_count CURSOR FOR i313_precount
END FUNCTION
 
FUNCTION i313_menu()
 
   WHILE TRUE
      CALL i313_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i313_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i313_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-6A0163-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_vmo01 IS NOT NULL THEN
                 LET g_doc.column1 = "vmo01"
                 LET g_doc.value1 = g_vmo01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0163-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i313_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL i313_cs()                     #取得查詢條件
    IF INT_FLAG THEN                   #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i313_cs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_vmo TO NULL
    ELSE
       CALL i313_fetch('F')            #讀出TEMP第一筆並顯示
       OPEN i313_count
       FETCH i313_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i313_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i313_cs INTO g_vmo01
        WHEN 'P' FETCH PREVIOUS i313_cs INTO g_vmo01
        WHEN 'F' FETCH FIRST    i313_cs INTO g_vmo01
        WHEN 'L' FETCH LAST     i313_cs INTO g_vmo01
        WHEN '/'
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR l_abso
 
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
             FETCH ABSOLUTE l_abso i313_cs INTO g_vmo01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vmo01,SQLCA.sqlcode,0)
        INITIALIZE  g_vmo01 TO NULL  
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i313_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i313_show()
DEFINE  l_ima02  LIKE ima_file.ima02
    LET g_vmo01_t = g_vmo01               #保存單頭舊值
    SELECT ima02 INTO l_ima02 FROM ima_file
     WHERE ima01 = g_vmo01
    DISPLAY g_vmo01,l_ima02 TO FORMONLY.vmo01,FORMONLY.ima02  #顯示單頭值
    CALL i313_b_fill(g_wc2)                   #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i313_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用    #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否    #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態      #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,       #可新增否      #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5        #可刪除否      #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_vmo01 IS NULL  THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
 
    UPDATE  bma_file set bmadate=sysdate  where bma01=g_vmo01  #FUN-860060 進入單身時修改ima_file之異動日期
 
    LET g_forupd_sql =
        "SELECT ",
        "       vmo03,vmo02, ",
        "       vmo13,vmo14,vmo15,vmo16,vmo17,vmo18 ",
        "  FROM vmo_file",
        " WHERE vmo01 = ?  AND vmo03 = ? AND vmo02  = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i313_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_vmo WITHOUT DEFAULTS FROM s_vmo.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
 
                BEGIN WORK
                LET g_vmo_t.* = g_vmo[l_ac].*  #BACKUP
 
                OPEN i313_bcl USING g_vmo01,g_vmo_t.vmo03,g_vmo_t.vmo02
                IF STATUS THEN
                   CALL cl_err("OPEN i313_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i313_bcl INTO g_vmo_t.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      LET g_vmo_t.*=g_vmo[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER FIELD vmo13
            IF NOT cl_null(g_vmo[l_ac].vmo13) THEN
               IF g_vmo[l_ac].vmo13 NOT MATCHES '[01]' THEN
                  NEXT FIELD vmo13
               END IF
            END IF
 
        BEFORE FIELD vmo14
            IF cl_null(g_vmo[l_ac].vmo14) THEN
               LET g_vmo[l_ac].vmo14='1'
               DISPLAY g_vmo[l_ac].vmo14 TO vmo14
            END IF
 
        BEFORE FIELD vmo15
            IF cl_null(g_vmo[l_ac].vmo15 ) THEN
               LET g_vmo[l_ac].vmo15 ='0'
               DISPLAY g_vmo[l_ac].vmo15 TO vmo15
            END IF
 
        BEFORE FIELD vmo16
            IF cl_null(g_vmo[l_ac].vmo16) THEN
               LET g_vmo[l_ac].vmo16='0'
               DISPLAY g_vmo[l_ac].vmo16 TO vmo16
            END IF
 
 
        AFTER FIELD vmo14
            IF NOT cl_null(g_vmo[l_ac].vmo14)  THEN
               IF g_vmo[l_ac].vmo14 NOT MATCHES '[01]' THEN
                  NEXT FIELD vmo14
               END IF
            END IF
        AFTER FIELD vmo15
            IF NOT cl_null(g_vmo[l_ac].vmo15 ) THEN
               IF g_vmo[l_ac].vmo15  NOT MATCHES '[01]' THEN
                  NEXT FIELD vmo15
               END IF
            END IF
        AFTER FIELD vmo16
            IF NOT cl_null(g_vmo[l_ac].vmo16) THEN
               IF g_vmo[l_ac].vmo16 NOT MATCHES '[01]' THEN
                  NEXT FIELD vmo16
               END IF
            END IF
        #FUN-840209------ADD-------BEGIN----
        AFTER FIELD vmo18
            IF NOT cl_null(g_vmo[l_ac].vmo18) and g_vmo[l_ac].vmo18<0 THEN
               CALL cl_err('','aps-406',0)
               NEXT FIELD vmo18
            END IF 
 
        #FUN-840209------ADD-------END-----
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vmo_t.vmo02) AND NOT cl_null(g_vmo_t.vmo03) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM vmo_file
                WHERE vmo01 = g_vmo01
                  AND vmo02 = g_vmo_t.vmo02
                  AND vmo03 = g_vmo_t.vmo03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","vmo_file",g_vmo01,g_vmo_t.vmo02,SQLCA.sqlcode,"","",1) # Fun-660095
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
 
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
 
            END IF
 
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vmo[l_ac].* = g_vmo_t.*
               CLOSE i313_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vmo[l_ac].vmo03,-263,1)
               LET g_vmo[l_ac].* = g_vmo_t.*
            ELSE
                UPDATE vmo_file SET 
                                    vmo13= g_vmo[l_ac].vmo13,
                                    vmo14= g_vmo[l_ac].vmo14,
                                    vmo15= g_vmo[l_ac].vmo15,
                                    vmo16= g_vmo[l_ac].vmo16,
                                    vmo17= g_vmo[l_ac].vmo17,
                                    vmo18= g_vmo[l_ac].vmo18
                WHERE vmo01 = g_vmo01
                  AND vmo03 = g_vmo_t.vmo03
                  AND vmo02 = g_vmo_t.vmo02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","vmo_file",g_vmo01,g_vmo_t.vmo03,SQLCA.sqlcode,"","ins 'vmo_file'",1) # Fun-660095
                  LET g_vmo[l_ac].* = g_vmo_t.*
                  ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_vmo[l_ac].* = g_vmo_t.*
               END IF
               CLOSE i313_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i313_bcl
            COMMIT WORK
 
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
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
      
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE i313_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i313_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(500)
    l_flag          LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)
 
    LET g_sql =
        "SELECT vmo03,vmo02,vmo13, ",
        "       vmo14,vmo15,vmo16,vmo17,vmo18 ",
        " FROM vmo_file,bmb_file",
        " WHERE vmo01 ='",g_vmo01,"'",
        "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
        "   AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
        "   AND bmb01 = vmo01 ",
        "   AND bmb02 = vmo03 ",
        "   AND bmb03 = vmo02  ",
        #"   AND bmb29 = ' '   ", #FUN-840209   #FUN-860060 MARK
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 4,5,6,7 "
    PREPARE i313_pb FROM g_sql
    DECLARE vmo_file_cs CURSOR FOR i313_pb
 
    CALL g_vmo.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH vmo_file_cs INTO g_vmo[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_vmo.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i313_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vmo TO s_vmo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i313_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i313_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i313_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i313_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i313_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0163  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-B50022
