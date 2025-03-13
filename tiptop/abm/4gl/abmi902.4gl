# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi902.4gl
# Descriptions...: ECR說明維護作業
# Date & Author..: 92/05/15 By David
# Modify.........: 92/11/04 By Apple
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510033 05/01/20 By Mandy 報表轉XML
# Modify.........: No.FUN-550032 05/05/20 By wujie 單據編號加大
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 結束位置調整
# Modify.........: No.MOD-650015 06/06/13 By douzh cl_err----->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0002 06/10/20 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720060 07/03/02 By Judy 復制功能無效
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780039 07/07/12 By xiaofeizhu將報表改為p_query格式輸出 
# Modify.........: No.TQC-890006 08/09/02 By alex 以cl_replace_str取代FOR置換字串 
# Modify.........: No.TQC-8C0045 08/12/23 By clover DISPLAY NAME錯誤修正
# Modify.........: No.TQC-920056 09/02/20 By xiaofeizhu 復制功能不能輸入不存在的ECR單號
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmr           RECORD
                       bmr01  LIKE bmr_file.bmr01
                    END RECORD,
    g_bmr_t         RECORD
                       bmr01  LIKE bmr_file.bmr01
                    END RECORD,
    g_bmr01_t       LIKE bmr_file.bmr01,   #
    g_bms           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bms02       LIKE bms_file.bms02,   #行序
        bms03       LIKE bms_file.bms03    #重要備註
                    END RECORD,
    g_bms_t         RECORD                 #程式變數 (舊值)
        bms02       LIKE bms_file.bms02,   #行序
        bms03       LIKE bms_file.bms03    #重要備註
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,               #TQC-630166
    g_flag          LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,      #單身筆數      #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5       #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE g_curs_index LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE g_jump       LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE g_no_ask    LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_bmr.bmr01  = ARG_VAL(1)           #主件編號
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #TQC-890006 
 
    LET g_forupd_sql = "SELECT * FROM bmr_file WHERE bmr01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i902_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i902_w WITH FORM "abm/42f/abmi902"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_bmr.bmr01 IS NOT NULL AND  g_bmr.bmr01 != ' ' THEN
       LET g_flag = 'Y'
       CALL i902_q()
       CALL i902_b()
    ELSE
       LET g_flag = 'N'
    END IF
 
    CALL i902_menu()
    CLOSE WINDOW i902_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0060
END MAIN
 
FUNCTION i902_cs()     #QBE 查詢資料
 
   DEFINE  lc_qbe_sN    LIKE gbm_file.gbm01    #No.FUN-580031  HCN
   DEFINE  l_i,l_j      LIKE type_file.num5    #No.FUN-680096 SMALLINT
  #DEFINE  l_buf        LIKE type_file.chr1000 #TQC-890006
 
   CLEAR FORM                             #清除畫面
   CALL g_bms.clear()
 
   IF g_flag = 'N' THEN
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
      INITIALIZE g_bmr.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON bms01               # 螢幕上取單頭條件
 
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
      LET g_wc = " bmr01 ='",g_bmr.bmr01,"'"
      LET g_wc2= " bms01 ='",g_bmr.bmr01,"'"
   END IF
 
   IF INT_FLAG THEN RETURN END IF
 
   ### 將bms 轉換為bmr     #TQC-890006
   #IF g_flag = 'N' THEN
   #   LET l_buf=g_wc
   #   LET l_j=length(l_buf)
   #   FOR l_i=1 TO l_j
   #      IF l_buf[l_i,l_i+4]='bms01' THEN
   #            LET l_buf[l_i,l_i+4]='bmr01'
   #      END IF
   #   END FOR
   #   LET g_wc  = l_buf
   #END IF
   LET g_wc = cl_replace_str(g_wc,"bms01","bmr01")
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND bmruser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND bmrgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND bmrgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmruser', 'bmrgrup')
   #End:FUN-980030
 
   IF g_flag = 'N' THEN
      # 螢幕上取單身條件
 
      CONSTRUCT g_wc2 ON bms02,bms03 FROM s_bms[1].bms02,s_bms[1].bms03
 
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
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = " SELECT  bmr01 FROM bmr_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER bY 1"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT bmr01 ",
                  "  FROM bmr_file, bms_file ",
                   " WHERE bmr01 = bms01 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER bY 1"
   END IF
 
   PREPARE i902_prepare FROM g_sql
   DECLARE i902_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i902_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM bmr_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(distinct bmr01) FROM bmr_file,bms_file WHERE ",
                 "bmr01=bms01 ",
                 " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i902_precount FROM g_sql
   DECLARE i902_count CURSOR FOR i902_precount
END FUNCTION
 
 
FUNCTION i902_menu()
 
   WHILE TRUE
      CALL i902_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i902_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i902_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i902_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
#              CALL i902_out()                                                                 #FUN-780039
#              LET l_cmd='p_query',' ','abmi902',' ','0%'                                      #FUN-780039                                                         
#              CALL cl_cmdrun(l_cmd)                                                           #FUN-780039
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                                  #FUN-780039                          
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                                #FUN-780039                          
               LET g_msg = 'p_query "abmi902" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'        #FUN-780039                          
               CALL cl_cmdrun(g_msg)                                                           #FUN-780039 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bms),'','')
            END IF
 
         #No.FUN-6A0002-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bmr.bmr01 IS NOT NULL THEN
                 LET g_doc.column1 = "bmr01"
                 LET g_doc.value1 = g_bmr.bmr01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0002-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i902_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bms.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i902_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmr.* TO NULL
        RETURN
    END IF
    OPEN i902_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmr.* TO NULL
    ELSE
        OPEN i902_count
        FETCH i902_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i902_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i902_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1      #處理方式    #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i902_cs INTO g_bmr.bmr01
        WHEN 'P' FETCH PREVIOUS i902_cs INTO g_bmr.bmr01
        WHEN 'F' FETCH FIRST    i902_cs INTO g_bmr.bmr01
        WHEN 'L' FETCH LAST     i902_cs INTO g_bmr.bmr01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i902_cs INTO g_bmr.bmr01
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmr.bmr01 CLIPPED
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmr.* TO NULL  #TQC-6B0105
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
    SELECT bmr01,bmruser,bmrgrup
           INTO g_bmr.* ,g_data_owner,g_data_group FROM bmr_file WHERE bmr01 = g_bmr.bmr01
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmr.bmr01 CLIPPED
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bmr_file",g_msg,"",SQLCA.sqlcode,"","",1)# TQC-660046
        INITIALIZE g_bmr.* TO NULL
        RETURN
    END IF
    CALL i902_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i902_show()
    LET g_bmr_t.* = g_bmr.*                #保存單頭舊值
    DISPLAY g_bmr.bmr01 TO bms01     # 顯示單頭值
    CALL i902_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i902_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態     #No.FUN-680096 VARCHAR(1)
    l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入   #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否     #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否     #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmr.bmr01 IS NULL OR g_bmr.bmr01 = ' '
    THEN RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT bms02,bms03 FROM bms_file ",
                        " WHERE bms01= ? AND bms02= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i902_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bms WITHOUT DEFAULTS FROM s_bms.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
               #CKP
               LET p_cmd='u'
               LET g_bms_t.* = g_bms[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN i902_bcl USING g_bmr.bmr01,g_bms_t.bms02
                IF STATUS THEN
                    CALL cl_err("OPEN i902_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i902_bcl INTO g_bms[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bms_t.bms02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD bms02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bms_file(bms01,bms02,bms03,bmsplant,bmslegal) ##FUN-980001------ add plant & legal 
            VALUES(g_bmr.bmr01,
                   g_bms[l_ac].bms02,g_bms[l_ac].bms03,g_plant,g_legal) ##FUN-980001------ add plant & legal 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bms[l_ac].bms02,SQLCA.sqlcode,0) #No.TQC-660046
               CALL cl_err3("ins","bms_file",g_bmr.bmr01,g_bms[l_ac].bms02,SQLCA.sqlcode,"","",1) # TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bms[l_ac].* TO NULL      #900423
            LET g_bms_t.* = g_bms[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bms02
 
        BEFORE FIELD bms02                        #default 序號
            IF g_bms[l_ac].bms02 IS NULL OR
               g_bms[l_ac].bms02 = 0 THEN
                SELECT max(bms02)+1
                   INTO g_bms[l_ac].bms02
                   FROM bms_file
                   WHERE bms01 = g_bmr.bmr01
                IF g_bms[l_ac].bms02 IS NULL THEN
                    LET g_bms[l_ac].bms02 = 1
                END IF
            END IF
 
        AFTER FIELD bms02                        #check 序號是否重複
            IF NOT cl_null(g_bms[l_ac].bms02) THEN
                IF g_bms[l_ac].bms02 != g_bms_t.bms02 OR
                   g_bms_t.bms02 IS NULL THEN
                    SELECT count(*)
                        INTO l_n
                        FROM bms_file
                        WHERE bms01 = g_bmr.bmr01 AND
                              bms02 = g_bms[l_ac].bms02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_bms[l_ac].bms02 = g_bms_t.bms02
                        NEXT FIELD bms02
                    END IF
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bms_t.bms02 > 0 AND
               g_bms_t.bms02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM bms_file WHERE bms01 = g_bmr.bmr01
                                       AND bms02 = g_bms_t.bms02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bms_t.bms02,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","bms_file",g_bms_t.bms02,"",SQLCA.sqlcode,"","",1) # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bms[l_ac].* = g_bms_t.*
               CLOSE i902_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bms[l_ac].bms02,-263,1)
                LET g_bms[l_ac].* = g_bms_t.*
            ELSE
                UPDATE bms_file SET
                   bms02 = g_bms[l_ac].bms02,
                   bms03 = g_bms[l_ac].bms03
                 WHERE bms01=g_bmr.bmr01
                   AND bms02=g_bms_t.bms02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bms[l_ac].bms02,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bms_file",g_bmr.bmr01,g_bms_t.bms02,SQLCA.sqlcode,"","",1) # TQC-660046
                    LET g_bms[l_ac].* = g_bms_t.*
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
               #CKP
               IF p_cmd='u' THEN
                  LET g_bms[l_ac].* = g_bms_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bms.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i902_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #LET g_bms_t.* = g_bms[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i902_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i902_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bms02) AND l_ac > 1 THEN
                LET g_bms[l_ac].* = g_bms[l_ac-1].*
                DISPLAY g_bms[l_ac].* TO s_bms[l_sl].*
                NEXT FIELD bms02
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
    CLOSE i902_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i902_b_askkey()
DEFINE
    l_wc2           STRING    #TQC-630166
 
    CONSTRUCT l_wc2 ON bms02,bms03
            FROM s_bms[1].bms02,s_bms[1].bms03
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i902_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i902_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING,    #TQC-630166
    l_flag          LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    LET g_sql = " SELECT bms02,bms03 FROM bms_file",
                 " WHERE bms01 ='",g_bmr.bmr01,"' ",
                   " AND ", p_wc2 CLIPPED,
                 " ORDER BY 1"
    PREPARE i902_pb FROM g_sql
    DECLARE bms_cs CURSOR FOR i902_pb
 
    CALL g_bms.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH bms_cs INTO g_bms[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    #CKP
    CALL g_bms.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i902_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bms TO s_bms.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i902_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i902_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i902_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i902_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i902_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0002  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i902_copy()
DEFINE
    l_newno,l_oldno LIKE bmr_file.bmr01 #己存在,欲copy單身的廠商編號
DEFINE  li_result  LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmr.bmr01 IS NULL
       THEN CALL cl_err('',-400,0)
            RETURN
    END IF
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    INPUT l_newno FROM bms01   #TQC-720060
#No.FUN-550032--begin
    BEFORE INPUT
       CALL cl_set_docno_format("bms01")
#No.FUN-550032--end
 
        AFTER FIELD bms01  #TQC-720060
            IF cl_null(l_newno) THEN
                NEXT FIELD bms01  #TQC-720060
            END IF
            CALL s_check_no("abm",l_newno,"","1","bmr_file","bmr01","") RETURNING li_result,l_newno  #No.TQC-920056
            SELECT count(*) INTO g_cnt                                            
              FROM bmr_file #檢查廠商編號是否存在  
#            WHERE bms01 = l_newno  #TQC-720060                                                      #No.TQC-920056 Mark
             WHERE bmr01 = l_newno                                                                   #No.TQC-920056
#TQC-720060.....begin mark
           #IF g_cnt = 0
           #   THEN CALL cl_err(l_newno,'mfg3001',0)
           #        NEXT FIELD bmr01
           #END IF
#TQC-720060.....end mark
 
#No.TQC-920056--Begin             
             IF g_cnt = 0 THEN
#               CALL cl_err(l_newno,'mfg3001',0)                                                     #No.TQC-920056 Mark
                CALL cl_err(l_newno,'mfg2008',0)                                                     #No.TQC-920056
                   NEXT FIELD bms01
             END IF
#No.TQC-920056--end
 
            SELECT count(*) INTO g_cnt FROM bms_file #檢查是否己有單身資料
                   WHERE bms01 = l_newno
            IF g_cnt > 0
#              THEN CALL cl_err('','mfg3003',0)                                                      #No.TQC-920056 Mark
               THEN CALL cl_err('','mfg5008',0)                                                      #No.TQC-920056
                    NEXT FIELD bms01  #TQC-720060
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG
       THEN LET INT_FLAG = 0
            #DISPLAY BY NAME g_bmr.bmr01
            DISPLAY g_bmr.bmr01 TO bms01  #TQC-8C0045
#No.FUN-500032--begin
       ROLLBACK WORK
#No.FUN-500032--end
            RETURN
    END IF
 
#TQC-720060.....begin
    DROP TABLE y
    SELECT * FROM bmr_file
        WHERE bmr01 = g_bmr.bmr01
        INTO TEMP y
    UPDATE y
        SET bmr01 = l_newno
    INSERT INTO bmr_file
        SELECT * FROM y
#TQC-720060.....end
    DROP TABLE x
    SELECT * FROM bms_file         #單身複製
        WHERE bms01=g_bmr.bmr01
        INTO TEMP x
    IF SQLCA.sqlcode THEN 
#       CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("ins","x",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1) # TQC-660046
        RETURN
    END IF
    UPDATE x
        SET bms01=l_newno
    INSERT INTO bms_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN 
#       CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("ins","bms_file",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1) # TQC-660046        
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_bmr.bmr01
    SELECT bmr01 INTO g_bmr.bmr01
               FROM bmr_file
               WHERE bmr01 = l_newno
    CALL i902_b()
    LET g_bmr.bmr01=l_oldno
    #FUN-C30027---begin
    #SELECT bmr01 INTO g_bmr.bmr01
    #           FROM bmr_file  WHERE bmr01=l_oldno
    #CALL i902_show()
    #FUN-C30027---end
END FUNCTION
 
 
#No.FUN-780039--mark--begin--
{FUNCTION i902_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bms01       LIKE bms_file.bms01,   #簽核等級
        bms02       LIKE bms_file.bms02,   #行序號
        bms03       LIKE bms_file.bms03    #備註
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('abmi902') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bms01,bms02,bms03",
          " FROM bms_file, OUTER bmr_file ",
          " WHERE bms_file.bms01 = bmr_file.bmr01 AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED,
          " ORDER BY 1,2 "
    PREPARE i902_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i902_co                         # CURSOR
        CURSOR FOR i902_p1
 
    START REPORT i902_rep TO l_name
 
    FOREACH i902_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i902_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i902_rep
 
    CLOSE i902_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i902_rep(sr)                       
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
    l_i             LIKE type_file.num5,    #No.FUN-680096 SMALLINT
    sr              RECORD
        bms01       LIKE bms_file.bms01,    #簽核等級
        bms02       LIKE bms_file.bms02,
        bms03       LIKE bms_file.bms03
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bms01,sr.bms02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bms01
            PRINT COLUMN g_c[31],sr.bms01;
 
        ON EVERY ROW
            PRINT COLUMN g_c[32],sr.bms02 using '###&',
                  COLUMN g_c[33],sr.bms03 CLIPPED
 
        ON LAST ROW
            PRINT g_dash
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN#IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                    PRINT g_dash
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
            ELSE
                SKIP 2 LINE
            END IF
END REPORT }
#No.FUN-780039--mark--end
