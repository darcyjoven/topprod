# Prog. Version..: '5.10.05-08.12.18(00000)'     #
# Pattern name...: apsi200.4gl
# Descriptions...: 產品結構資料維護作業
# Date & Author..: 03/03/31 By Kammy
# Modify.........: No:FUN-4B0037 04/11/10 By ching add is_issue,is_cnsn,is_altod
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No:FUN-6A0163 06/11/06 By jamie 新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/08 By Joe 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
#                                                <代葉美英修改>
# Modify.........: No.FUN-720043 07/03/27 By Mandy APS相關調整
# Modify.........: No.TQC-750013 07/05/04 By Mandy 1.當單身修改時,應可以選擇跳至任一欄位,而非一定要跳至固定欄位   
#                                                  2.p_aprio 此欄位不用了,直接用欄位隱藏的方式,畫面/程式其它地方不調整
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_out_pid       LIKE aps_bmb.out_pid, #FUN-720043
    g_out_pid_t     LIKE aps_bmb.out_pid,
    g_aps_bmb_rowid LIKE type_file.chr18,   #No.FUN-690010 INT
    g_aps_bmb       DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                      seq_txt          LIKE aps_bmb.seq_txt,
                      in_pid           LIKE aps_bmb.in_pid,
                      p_aprio          LIKE aps_bmb.p_aprio,
                      g_acode          LIKE aps_bmb.g_acode,
                      is_used          LIKE aps_bmb.is_used,
                      is_sub_p         LIKE aps_bmb.is_sub_p,
                      is_issue         LIKE aps_bmb.is_issue,
                      is_cnsn          LIKE aps_bmb.is_cnsn ,
                      is_altod         LIKE aps_bmb.is_altod,
                      cret_typ         LIKE aps_bmb.cret_typ,
                      al_ratio         LIKE aps_bmb.al_ratio
                    END RECORD,
    g_aps_bmb_t     RECORD                 #程式變數 (舊值)
                      seq_txt          LIKE aps_bmb.seq_txt,
                      in_pid           LIKE aps_bmb.in_pid,
                      p_aprio          LIKE aps_bmb.p_aprio,
                      g_acode          LIKE aps_bmb.g_acode,
                      is_used          LIKE aps_bmb.is_used,
                      is_sub_p         LIKE aps_bmb.is_sub_p,
                      is_issue         LIKE aps_bmb.is_issue,
                      is_cnsn          LIKE aps_bmb.is_cnsn ,
                      is_altod         LIKE aps_bmb.is_altod,
                      cret_typ         LIKE aps_bmb.cret_typ,
                      al_ratio         LIKE aps_bmb.al_ratio
                    END RECORD,
    g_wc,g_sql      string,  #No:FUN-580092 HCN
    g_wc2           string,  #No:FUN-580092 HCN
    g_argv1         LIKE aps_bmb.out_pid,
    g_rec_b         LIKE type_file.num5,     #單身筆數             #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT

#主程式開始
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_cnt          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE g_msg          LIKE ze_file.ze03      #No.FUN-690010 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER

MAIN
DEFINE
    l_time              LIKE type_file.chr8,   #計算被使用時間     #No.FUN-690010 VARCHAR(8)
    p_row,p_col         LIKE type_file.num5    #No.FUN-690010 SMALLINT

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,l_time,1) RETURNING l_time #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
 
    LET g_argv1 =  ARG_VAL(1)
    LET g_out_pid = ARG_VAL(1)

    LET p_row = 4 LET p_col = 15
    OPEN WINDOW i200_w AT p_row,p_col WITH FORM "aps/42f/apsi200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    CALL i200_def_form()  #TQC-750013 add
 
    IF NOT cl_null(g_argv1) THEN
       CALL i200_q()
       CALL i200_b()
    END IF

    CALL i200_menu()

    CLOSE WINDOW i200_w                 #結束畫面
    CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818
       RETURNING l_time

END MAIN

#QBE 查詢資料
FUNCTION i200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
    CLEAR FORM                              #清除畫面

    IF cl_null(g_argv1) THEN
   INITIALIZE g_out_pid TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON out_pid   #螢幕上取單頭條件
           #No:FUN-580031 --start--     HCN
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
           #No:FUN-580031 --end--       HCN

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION about         #MOD-4C0121
              CALL cl_about()      #MOD-4C0121
          
           ON ACTION help          #MOD-4C0121
              CALL cl_show_help()  #MOD-4C0121
          
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
 
           #No:FUN-580031 --start--     HCN
           ON ACTION qbe_select
              CALL cl_qbe_list() RETURNING lc_qbe_sn
              CALL cl_qbe_display_condition(lc_qbe_sn)
           #No:FUN-580031 --end--       HCN
        END CONSTRUCT
    ELSE
        DISPLAY g_argv1 TO out_pid
        LET g_wc = " out_pid ='",g_argv1,"'"
    END IF

    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND bmbuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND bmbgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND bmbgrup IN ",cl_chk_tgrup_list()
    END IF

    IF cl_null(g_argv1) THEN  
       CONSTRUCT g_wc2 ON seq_txt,in_pid,p_aprio,g_acode,is_used,is_sub_p,
                          is_issue,is_cnsn,is_altod,cret_typ,al_ratio
            FROM s_aps[1].seq_txt,s_aps[1].in_pid,s_aps[1].p_aprio,
                 s_aps[1].g_acode,s_aps[1].is_used,s_aps[1].is_sub_p,
                 s_aps[1].is_issue,s_aps[1].is_cnsn,s_aps[1].is_altod,
                 s_aps[1].cret_typ,s_aps[1].al_ratio

         #No:FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
	   CALL cl_qbe_display_condition(lc_qbe_sn)
         #No:FUN-580031 --end--       HCN

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
        
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
        
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
	 #No:FUN-580031 --start--     HCN
         ON ACTION qbe_save
	    CALL cl_qbe_save()
	 #No:FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
        LET g_wc2 = " 1=1"
    END IF
    IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE out_pid  FROM aps_bmb ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1 "
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE out_pid ",
                   "  FROM bmb_file, aps_bmb ",
                   " WHERE bmb01 = out_pid ",
                   "   AND bmb02 = seq_txt ",
                   "   AND bmb03 = in_pid ",
                   "   AND ", g_wc  CLIPPED,
                   "   AND ", g_wc2 CLIPPED,
                   " ORDER BY 1 "
    END IF

    PREPARE i200_prepare FROM g_sql
    DECLARE i200_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i200_prepare

    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(unique out_pid) FROM aps_bmb,bmb_file ",
                 "WHERE ",g_wc CLIPPED,
                 "  AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                 "  AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
                 "  AND bmb01=out_pid",
                 "  AND bmb02=seq_txt",
                 "  AND bmb03=in_pid"
    ELSE
        LET g_sql="SELECT COUNT(unique out_pid) FROM aps_bmb,bmb_file ",
                  "WHERE ",g_wc  CLIPPED,
                  "  AND ",g_wc2 CLIPPED,
                  "  AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
                  "  AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
                  "  AND bmb01=out_pid",
                  "  AND bmb02=seq_txt",
                  "  AND bmb03=in_pid"
    END IF
    PREPARE i200_precount FROM g_sql
    DECLARE i200_count CURSOR FOR i200_precount
END FUNCTION

FUNCTION i200_menu()

   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No:FUN-6A0163-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_out_pid IS NOT NULL THEN
                 LET g_doc.column1 = "out_pid"
                 LET g_doc.value1 = g_out_pid
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6A0163-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION i200_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL i200_cs()                     #取得查詢條件
    IF INT_FLAG THEN                   #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN i200_cs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_aps_bmb TO NULL
    ELSE
       CALL i200_fetch('F')            #讀出TEMP第一筆並顯示
       OPEN i200_count
       FETCH i200_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-690010 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     i200_cs INTO g_out_pid
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_out_pid
        WHEN 'F' FETCH FIRST    i200_cs INTO g_out_pid
        WHEN 'L' FETCH LAST     i200_cs INTO g_out_pid
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
             FETCH ABSOLUTE l_abso i200_cs INTO g_out_pid
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_out_pid,SQLCA.sqlcode,0)
        INITIALIZE  g_out_pid TO NULL          ##TQC-6B0105
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
    CALL i200_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION i200_show()
DEFINE  l_ima02  LIKE ima_file.ima02
    LET g_out_pid_t = g_out_pid               #保存單頭舊值
    SELECT ima02 INTO l_ima02 FROM ima_file
     WHERE ima01 = g_out_pid
    DISPLAY g_out_pid,l_ima02 TO FORMONLY.out_pid,FORMONLY.ima02  #顯示單頭值
    CALL i200_b_fill(g_wc2)                   #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

#單身
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用    #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否    #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態      #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,       #可新增否      #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5        #可刪除否      #No.FUN-690010 SMALLINT

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_out_pid IS NULL  THEN
       RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql =
        "SELECT ",
        "       seq_txt,in_pid,p_aprio,g_acode,is_used, ",
        "       is_sub_p,is_issue,is_cnsn,is_altod,cret_typ,al_ratio ",
        "  FROM aps_bmb",
        " WHERE out_pid = ?  AND seq_txt = ? AND in_pid  = ?  FOR UPDATE NOWAIT"
    DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = FALSE
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_aps_bmb WITHOUT DEFAULTS FROM s_aps.*
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
                LET g_aps_bmb_t.* = g_aps_bmb[l_ac].*  #BACKUP

                OPEN i200_bcl USING g_out_pid,g_aps_bmb_t.seq_txt,g_aps_bmb_t.in_pid
                IF STATUS THEN
                   CALL cl_err("OPEN i200_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i200_bcl INTO g_aps_bmb_t.*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      LET g_aps_bmb_t.*=g_aps_bmb[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD seq_txt #TQC-750013 mark

        AFTER FIELD is_used
            IF NOT cl_null(g_aps_bmb[l_ac].is_used) THEN
               IF g_aps_bmb[l_ac].is_used NOT MATCHES '[01]' THEN
                  NEXT FIELD is_used
               END IF
            END IF

        AFTER FIELD is_sub_p
            IF NOT cl_null(g_aps_bmb[l_ac].is_sub_p) THEN
               IF g_aps_bmb[l_ac].is_sub_p NOT MATCHES '[01]' THEN
                  NEXT FIELD is_sub_p
               END IF
            END IF

        BEFORE FIELD is_issue
            IF cl_null(g_aps_bmb[l_ac].is_issue) THEN
               LET g_aps_bmb[l_ac].is_issue='1'
               DISPLAY g_aps_bmb[l_ac].is_issue TO is_issue
            END IF

        BEFORE FIELD is_cnsn
            IF cl_null(g_aps_bmb[l_ac].is_cnsn ) THEN
               LET g_aps_bmb[l_ac].is_cnsn ='0'
               DISPLAY g_aps_bmb[l_ac].is_cnsn TO is_cnsn
            END IF

        BEFORE FIELD is_altod
            IF cl_null(g_aps_bmb[l_ac].is_altod) THEN
               LET g_aps_bmb[l_ac].is_altod='0'
               DISPLAY g_aps_bmb[l_ac].is_altod TO is_altod
            END IF


        AFTER FIELD is_issue
            IF NOT cl_null(g_aps_bmb[l_ac].is_issue)  THEN
               IF g_aps_bmb[l_ac].is_issue NOT MATCHES '[01]' THEN
                  NEXT FIELD is_issue
               END IF
            END IF
        AFTER FIELD is_cnsn
            IF NOT cl_null(g_aps_bmb[l_ac].is_cnsn ) THEN
               IF g_aps_bmb[l_ac].is_cnsn  NOT MATCHES '[01]' THEN
                  NEXT FIELD is_cnsn
               END IF
            END IF
        AFTER FIELD is_altod
            IF NOT cl_null(g_aps_bmb[l_ac].is_altod) THEN
               IF g_aps_bmb[l_ac].is_altod NOT MATCHES '[01]' THEN
                  NEXT FIELD is_altod
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_aps_bmb_t.in_pid) THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF

               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM aps_bmb
                WHERE out_pid = g_out_pid
                  AND in_pid  = g_aps_bmb_t.in_pid
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","aps_bmb",g_out_pid,g_aps_bmb_t.in_pid,SQLCA.sqlcode,"","",1) # Fun-660095
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
               LET g_aps_bmb[l_ac].* = g_aps_bmb_t.*
               CLOSE i200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aps_bmb[l_ac].in_pid,-263,1)
               LET g_aps_bmb[l_ac].* = g_aps_bmb_t.*
            ELSE
               UPDATE aps_bmb SET p_aprio = g_aps_bmb[l_ac].p_aprio,
                                  g_acode = g_aps_bmb[l_ac].g_acode,
                                  is_used = g_aps_bmb[l_ac].is_used,
                                  is_sub_p= g_aps_bmb[l_ac].is_sub_p,
                                  is_issue= g_aps_bmb[l_ac].is_issue,
                                  is_cnsn = g_aps_bmb[l_ac].is_cnsn,
                                  is_altod= g_aps_bmb[l_ac].is_altod,
                                  cret_typ= g_aps_bmb[l_ac].cret_typ,
                                  al_ratio= g_aps_bmb[l_ac].al_ratio
                WHERE out_pid = g_out_pid
                  AND seq_txt = g_aps_bmb_t.seq_txt
                  AND in_pid  = g_aps_bmb_t.in_pid
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","aps_bmb",g_out_pid,g_aps_bmb_t.in_pid,SQLCA.sqlcode,"","ins 'aps_bmb'",1) # Fun-660095
                  LET g_aps_bmb[l_ac].* = g_aps_bmb_t.*
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
                  LET g_aps_bmb[l_ac].* = g_aps_bmb_t.*
               END IF
               CLOSE i200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i200_bcl
            COMMIT WORK

        ON ACTION CONTROLZ
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

    CLOSE i200_bcl
    COMMIT WORK

END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(500)
    l_flag          LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)

    LET g_sql =
        "SELECT seq_txt,in_pid,p_aprio,g_acode,is_used,is_sub_p, ",
        "       is_issue,is_cnsn,is_altod,cret_typ,al_ratio ",
        " FROM aps_bmb,bmb_file",
        " WHERE out_pid ='",g_out_pid,"'",
        "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
        "   AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)",
        "   AND bmb01 = out_pid ",
        "   AND bmb02 = seq_txt ",
        "   AND bmb03 = in_pid  ",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 4,5,6,7 "
    PREPARE i200_pb FROM g_sql
    DECLARE aps_bmb_cs CURSOR FOR i200_pb
 
    CALL g_aps_bmb.clear()

    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH aps_bmb_cs INTO g_aps_bmb[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_aps_bmb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aps_bmb TO s_aps.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL i200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL i200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL i200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last
         CALL i200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         CALL i200_def_form()     #TQC-750013 add

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

      ON ACTION related_document                #No:FUN-6A0163  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i200_def_form()
   CALL cl_set_comp_visible("p_aprio",FALSE) #TQC-750013 p_aprio 此欄位不用了
END FUNCTION
