# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aqci101.4gl
# Descriptions...: 其他檢驗水準Ⅱ樣本代碼資料建立作業
# Date & Author..: 97/02/13 By Star
# Date & Modify..: 03/07/16 By Wiky #No:7230 LET l_modify_flag = 'N' =>'Y'
#                : 新UI點多筆時無法UPDATE
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-710119 07/03/29 By Ray 畫面上增加筆數
# Modify.........: No.TQC-740144 07/04/24 By hongmei 控管qch01,qch04,qch05,qch06 可為負數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A60132 10/07/19 By chenmoyan 鎖表語句不標準
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_qch           DYNAMIC ARRAY OF RECORD
                    qch01     LIKE qch_file.qch01,
                    qch02     LIKE qch_file.qch02,
                    qch07     LIKE qch_file.qch07,
                    qch03     LIKE qch_file.qch03,
                    qch04     LIKE qch_file.qch04,
                    qch05     LIKE qch_file.qch05,
                    qch06     LIKE qch_file.qch06
                    END RECORD,
    g_qch_t         RECORD
                    qch01     LIKE qch_file.qch01,
                    qch02     LIKE qch_file.qch02,
                    qch07     LIKE qch_file.qch07,
                    qch03     LIKE qch_file.qch03,
                    qch04     LIKE qch_file.qch04,
                    qch05     LIKE qch_file.qch05,
                    qch06     LIKE qch_file.qch06
                    END RECORD,
    g_wc2,g_sql     STRING,                 #No.FUN-580092 HCN  
    g_rec_b         LIKE type_file.num5,    #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_sl            LIKE type_file.num5     #No.FUN-680104 SMALLINT              #目前處理的SCREEN LINE
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680104 INTEGER

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0085

    OPEN WINDOW i101_w WITH FORM "aqc/42f/aqci101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_wc2 = ' 1=1'
    CALL i101_b_fill(g_wc2)
    CALL i101_menu()

    CLOSE WINDOW i101_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i101_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qch),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i101_q()
   CALL i101_b_askkey()
END FUNCTION
 
FUNCTION i101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,      #No.FUN-680104 VARCHAR(1) #可新增否
    l_allow_delete  LIKE type_file.chr1       #No.FUN-680104 VARCHAR(1) #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT qch01,qch02,qch07,qch03,qch04,qch05,qch06 FROM qch_file",
                       "  WHERE qch01=? AND qch02=? AND qch03=? AND qch07=? ",       #TQC-A60132
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_qch WITHOUT DEFAULTS FROM s_qch.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            # 03/07/16 By Wiky #No:7230 LET l_modify_flag = 'N' =>'Y'
            # 新UI點多筆時無法UPDATE
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_qch_t.* = g_qch[l_ac].*  #BACKUP
                OPEN i101_bcl USING g_qch_t.qch01,g_qch_t.qch02,
                                    g_qch_t.qch03,g_qch_t.qch07
                IF STATUS THEN
                   CALL cl_err("OPEN i101_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i101_bcl INTO g_qch[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_qch_t.qch01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qch[l_ac].* TO NULL      #900423
            LET g_qch_t.* = g_qch[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            DISPLAY g_qch[l_ac].* TO s_qch[l_sl].*
 
        AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i101_bcl
#           CALL g_qch.deleteElement(l_ac)
#           IF g_rec_b != 0 THEN
#              LET g_action_choice = "detail"
#              LET l_ac = l_ac_t
#           END IF
#           EXIT INPUT
         END IF
          INSERT INTO qch_file (qch01,qch02,qch03,qch04,qch05,qch06,qch07) #No.MOD-470041
              VALUES(g_qch[l_ac].qch01,g_qch[l_ac].qch02,g_qch[l_ac].qch03,
                     g_qch[l_ac].qch04,g_qch[l_ac].qch05,g_qch[l_ac].qch06,
                     g_qch[l_ac].qch07)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_qch[l_ac].qch01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("ins","qch_file",g_qch[l_ac].qch01,g_qch[l_ac].qch02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
         END IF
 
      { BEFORE FIELD qch01
            IF p_cmd = 'u' AND g_chkey = 'N' THEN
               NEXT FIELD qch04
            END IF }
 
        BEFORE FIELD qch01
            IF cl_null(g_qch[l_ac].qch01) OR g_qch[l_ac].qch01 = 0 THEN
                SELECT max(qch02) INTO g_qch[l_ac].qch01
                  FROM qch_file
                IF g_qch[l_ac].qch01 = 999999 THEN
                   MESSAGE ' '
#                  EXIT WHILE
                END IF
                LET g_qch[l_ac].qch01 = g_qch[l_ac].qch01 + 1
                IF cl_null(g_qch[l_ac].qch01) THEN
                    LET g_qch[l_ac].qch01 = 1
                END IF
                DISPLAY g_qch[l_ac].qch01 TO s_qch[l_sl].qch01
            END IF
 
#No.TQC-740144 --Begin                                                                                                              
        AFTER FIELD qch01                                                                                                           
            IF g_qch[l_ac].qch01<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qch01                                                                                                     
            END IF                                                                                                                  
#No.TQC-740144 ---End
 
        AFTER FIELD qch02
            IF g_qch[l_ac].qch02 < g_qch[l_ac].qch01 THEN
               NEXT FIELD qch02
            END IF
 
#No.TQC-740144 ---Begin                                                                                                             
        AFTER FIELD qch04                                                                                                           
            IF g_qch[l_ac].qch04<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qch04                                                                                                     
            END IF                                                                                                                  
                                                                                                                                    
        AFTER FIELD qch05                                                                                                           
            IF g_qch[l_ac].qch05<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qch05                                                                                                     
            END IF                                                                                                                  
                                                                                                                                    
        AFTER FIELD qch06                                                                                                           
            IF g_qch[l_ac].qch06<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qch06                                                                                                     
            END IF                                                                                                                  
#No.TQC-740144 ---End
 
        AFTER FIELD qch07                        #check 序號是否重複
          IF NOT cl_null(g_qch[l_ac].qch07) THEN
            IF g_qch[l_ac].qch07 NOT MATCHES '[1234]' THEN
               NEXT FIELD qch07
            END IF
          END IF
 
        AFTER FIELD qch03                        #check 序號是否重複
          IF g_qch[l_ac].qch03 IS NOT NULL THEN
            IF NOT g_qch[l_ac].qch03 IS NULL THEN
               IF g_qch[l_ac].qch01 != g_qch_t.qch01 OR
                  g_qch[l_ac].qch02 != g_qch_t.qch02 OR
                  g_qch[l_ac].qch03 != g_qch_t.qch03 OR
                  g_qch[l_ac].qch07 != g_qch_t.qch07 OR
                  g_qch_t.qch01 IS NULL OR
                  g_qch_t.qch02 IS NULL OR
                  g_qch_t.qch07 IS NULL OR
                  g_qch_t.qch03 IS NULL THEN
                  SELECT count(*) INTO l_n FROM qch_file
                   WHERE qch01 = g_qch[l_ac].qch01
                     AND qch02 = g_qch[l_ac].qch02
                     AND qch03 = g_qch[l_ac].qch03
                     AND qch07 = g_qch[l_ac].qch07
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_qch[l_ac].qch01 = g_qch_t.qch01
                     LET g_qch[l_ac].qch02 = g_qch_t.qch02
                     LET g_qch[l_ac].qch03 = g_qch_t.qch03
                     LET g_qch[l_ac].qch07 = g_qch_t.qch07
                     NEXT FIELD qch01
                  END IF
               END IF
            END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_qch_t.qch01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qch_file
                 WHERE qch01 = g_qch_t.qch01
                   AND qch02 = g_qch_t.qch02
                   AND qch03 = g_qch_t.qch03
                   AND qch07 = g_qch_t.qch07
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qch_t.qch01,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("del","qch_file",g_qch_t.qch01,g_qch_t.qch02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
                MESSAGE "Delete OK"
                CLOSE i101_bcl
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qch[l_ac].* = g_qch_t.*
            CLOSE i101_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_qch[l_ac].qch01,-263,1)
             LET g_qch[l_ac].* = g_qch_t.*
         ELSE
             UPDATE qch_file SET
                   qch01= g_qch[l_ac].qch01,
                   qch02= g_qch[l_ac].qch02,
                   qch03= g_qch[l_ac].qch03,
                   qch04= g_qch[l_ac].qch04,
                   qch05= g_qch[l_ac].qch05,
                   qch06= g_qch[l_ac].qch06,
                   qch07= g_qch[l_ac].qch07
             WHERE qch01 = g_qch_t.qch01
               AND qch02 = g_qch_t.qch02
               AND qch03 = g_qch_t.qch03
               AND qch07 = g_qch_t.qch07
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_qch[l_ac].qch01,SQLCA.sqlcode,0)   #No.FUN-660115
                CALL cl_err3("upd","qch_file",g_qch_t.qch01,g_qch_t.qch02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                LET g_qch[l_ac].* = g_qch_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i101_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qch[l_ac].* = g_qch_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qch.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i101_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i101_b_askkey()
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qch01) AND l_ac > 1 THEN
                LET g_qch[l_ac].* = g_qch[l_ac-1].*
                DISPLAY g_qch[l_ac].* TO s_qch[l_sl].*
                NEXT FIELD qch01
            END IF
 
        ON ACTION CONTROLP
 
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
 
    CLOSE i101_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_b_askkey()
    CLEAR FORM
   CALL g_qch.clear()
    CONSTRUCT g_wc2 ON qch01,qch02,qch07,qch03,qch04,qch05,qch06
            FROM s_qch[1].qch01,s_qch[1].qch02,
                 s_qch[1].qch07,s_qch[1].qch03,
                 s_qch[1].qch04,s_qch[1].qch05,
                 s_qch[1].qch06
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i101_b_fill(g_wc2)
END FUNCTION
 


FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP

    DEFINE p_wc2  STRING 
 
    LET g_sql = "SELECT qch01,qch02,qch07,qch03,qch04,qch05,qch06 FROM qch_file  ",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY qch07,qch01"     #No:7972
 
    PREPARE i101_pb FROM g_sql
    DECLARE qch_curs CURSOR FOR i101_pb
 
    CALL g_qch.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH qch_curs INTO g_qch[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_qch.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qch TO s_qch.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
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
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#Patch....NO.TQC-610036 <001> #
