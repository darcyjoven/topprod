# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: aqci100.4gl
# Descriptions...: 一般檢驗水準樣本代碼資料建立作業
# Date & Author..: 96/09/16 By Star
# Date & Modify..: 03/07/16 By Wiky #No:7230 LET l_modify_flag = 'N' =>'Y'
#                : 新UI點多筆時無法UPDATE
# Modify.........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-550127 05/06/17 By kim 拿掉列印的按鍵
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.MOD-5B0185 05/11/22 By Rosayu 程式進入單身時自動將起始批量為0
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-710119 07/03/29 By Ray 畫面上增加筆數
# Modify.........: No.TQC-740144 07/04/24 By hongmei 控管qca01,qca04,qca05,qca06欄位不可為負數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A60132 10/07/19 By chenmoyan 鎖表語句不標準
# Modify.........: No.MOD-B80322 12/01/16 By Vampire 在AFTER FIELD qca03、AFTER INPUT裡要在判斷aqc-035
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_qca           DYNAMIC ARRAY OF RECORD
                    qca01         LIKE qca_file.qca01,
                    qca02         LIKE qca_file.qca02,
                    qca07         LIKE qca_file.qca07,
                    qca03         LIKE qca_file.qca03,
                    qca04         LIKE qca_file.qca04,
                    qca05         LIKE qca_file.qca05,
                    qca06         LIKE qca_file.qca06
                    END RECORD,
    g_qca_t         RECORD
                    qca01         LIKE qca_file.qca01,
                    qca02         LIKE qca_file.qca02,
                    qca07         LIKE qca_file.qca07,
                    qca03         LIKE qca_file.qca03,
                    qca04         LIKE qca_file.qca04,
                    qca05         LIKE qca_file.qca05,
                    qca06         LIKE qca_file.qca06
                    END RECORD,
    g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,            #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
DEFINE g_cnt          LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE g_forupd_sql   STRING                      #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_before_input_done   LIKE type_file.num5    #FUN-570109        #No.FUN-680104 SMALLINT


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

   OPEN WINDOW i100_w WITH FORM "aqc/42f/aqci100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i100_b_fill(g_wc2)
   CALL i100_menu()

   CLOSE WINDOW i100_w  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qca),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_q()
   CALL i100_b_askkey()
END FUNCTION
 
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,         #檢查重複用        #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態        #No.FUN-680104 VARCHAR(1)
    max_qca02       LIKE qca_file.qca02,
    l_allow_insert  LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)             #可新增否
    l_allow_delete  LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)              #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT qca01,qca02,qca07,qca03,qca04,qca05,qca06  ",
                       "  FROM qca_file ",
                       " WHERE qca01=? AND qca02=? AND qca03=? AND qca07=?", #TQC-A60132
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_qca WITHOUT DEFAULTS FROM s_qca.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_qca_t.* = g_qca[l_ac].*  #BACKUP
#No.FUN-570109 --start
                LET g_before_input_done = FALSE
                CALL i100_set_entry(p_cmd)
                CALL i100_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
#No.FUN-570109 --end
                OPEN i100_bcl USING g_qca_t.qca01,g_qca_t.qca02,
                                    g_qca_t.qca03,g_qca_t.qca07
                IF STATUS THEN
                   CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i100_bcl INTO g_qca[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_qca_t.qca01,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end
            INITIALIZE g_qca[l_ac].* TO NULL      #900423
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            LET g_qca_t.* = g_qca[l_ac].*         #新輸入資料
 
        AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i100_bcl
#           CALL g_qca.deleteElement(l_ac)
#           IF g_rec_b != 0 THEN
#              LET g_action_choice = "detail"
#              LET l_ac = l_ac_t
#           END IF
#           EXIT INPUT
         END IF
         #MOD-B80322 --- modify --- start ---
         SELECT COUNT(*) INTO l_cnt FROM qca_file
          WHERE g_qca[l_ac].qca02 BETWEEN qca01 AND qca02
            AND qca07=g_qca[l_ac].qca07
         IF l_cnt > 0 THEN
            NEXT FIELD qca02
         END IF
         #MOD-B80322 --- modify ---  end  ---
         INSERT INTO qca_file(qca01,qca02,qca03,qca04,qca05,
                               qca06,qca07)  #No.MOD-470041
                       VALUES(g_qca[l_ac].qca01,g_qca[l_ac].qca02,
                              g_qca[l_ac].qca03,g_qca[l_ac].qca04,
                              g_qca[l_ac].qca05,g_qca[l_ac].qca06,
                              g_qca[l_ac].qca07)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_qca[l_ac].qca01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("ins","qca_file",g_qca[l_ac].qca01,g_qca[l_ac].qca02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
         END IF
 
        BEFORE FIELD qca01
            #IF cl_null(g_qca[l_ac].qca01) OR g_qca[l_ac].qca01 = 0 THEN #MOD5B0185 mark
            IF cl_null(g_qca[l_ac].qca01) THEN  #MOD-5B0185 add
                SELECT max(qca02) INTO g_qca[l_ac].qca01
                  FROM qca_file
                IF g_qca[l_ac].qca01 = 999999 THEN
                   MESSAGE ' '
#                  EXIT WHILE  ##later to modify --leagh
                END IF
                LET g_qca[l_ac].qca01 = g_qca[l_ac].qca01 + 1
                IF cl_null(g_qca[l_ac].qca01) THEN
                    LET g_qca[l_ac].qca01 = 1
                END IF
            END IF
#No.TQC-740144 --Begin
        AFTER FIELD qca01
            IF g_qca[l_ac].qca01<0 THEN
               CALL cl_err('','afa1001',0)
               NEXT FIELD qca01
            END IF
#No.TQC-740144 ---End
        AFTER FIELD qca02
            IF NOT cl_null(g_qca[l_ac].qca02) THEN
               IF g_qca[l_ac].qca02 < g_qca[l_ac].qca01 THEN
                  NEXT FIELD qca02
               END IF
            END IF
#No.TQC-740144 ---Begin
        AFTER FIELD qca04                                                                                                           
            IF g_qca[l_ac].qca04<0 THEN
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qca04                                                                                                     
            END IF 
 
        AFTER FIELD qca05                                                                                                           
            IF g_qca[l_ac].qca05<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qca05                                                                                                     
            END IF                                                                                                                  
                                                                                                                                    
        AFTER FIELD qca06                                                                                                           
            IF g_qca[l_ac].qca06<0 THEN                                                                                             
               CALL cl_err('','afa1001',0)                                                                                          
               NEXT FIELD qca06                                                                                                     
            END IF
#No.TQC-740144 ---End
 
        AFTER FIELD qca07                        #check 序號是否重複
          IF NOT cl_null(g_qca[l_ac].qca07) THEN
            IF g_qca[l_ac].qca07 NOT MATCHES '[1234]' THEN
               NEXT FIELD qca07
            END IF
            IF g_qca_t.qca01 IS NULL OR
               ( NOT cl_null(g_qca[l_ac].qca01) AND
                 g_qca_t.qca01 !=g_qca[l_ac].qca01) THEN
               # check所輸入之數量是否有區間重疊
                SELECT COUNT(*) INTO l_cnt FROM qca_file
                 WHERE g_qca[l_ac].qca01 BETWEEN qca01 AND qca02
                   AND qca07=g_qca[l_ac].qca07
                IF l_cnt > 0 THEN
                   CALL cl_err(g_qca[l_ac].qca01,'aqc-035',1)
                   NEXT FIELD qca01
                END IF
            END IF
            IF g_qca_t.qca02 IS NULL OR
               ( NOT cl_null(g_qca[l_ac].qca02) AND
                 g_qca_t.qca02 !=g_qca[l_ac].qca02) THEN
               # check所輸入之數量是否有數量區間重疊
                SELECT COUNT(*) INTO l_cnt FROM qca_file
                 WHERE g_qca[l_ac].qca02 BETWEEN qca01 AND qca02
                   AND qca07=g_qca[l_ac].qca07
                IF l_cnt > 0 THEN
                   CALL cl_err(g_qca[l_ac].qca02,'aqc-035',1)
                   NEXT FIELD qca02
                END IF
            END IF
          END IF
 
        AFTER FIELD qca03                        #check 序號是否重複
          IF NOT cl_null(g_qca[l_ac].qca03) THEN
             IF g_qca[l_ac].qca01 != g_qca_t.qca01 OR
                g_qca[l_ac].qca02 != g_qca_t.qca02 OR
                g_qca[l_ac].qca03 != g_qca_t.qca03 OR
                g_qca[l_ac].qca07 != g_qca_t.qca07 OR
                g_qca_t.qca01 IS NULL OR
                g_qca_t.qca02 IS NULL OR
                g_qca_t.qca03 IS NULL OR
                g_qca_t.qca07 IS NULL THEN
                SELECT count(*) INTO l_n FROM qca_file
                   WHERE qca01 = g_qca[l_ac].qca01
                     AND qca02 = g_qca[l_ac].qca02
                     AND qca03 = g_qca[l_ac].qca03
                     AND qca07 = g_qca[l_ac].qca07
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_qca[l_ac].qca01 = g_qca_t.qca01
                   LET g_qca[l_ac].qca02 = g_qca_t.qca02
                   LET g_qca[l_ac].qca03 = g_qca_t.qca03
                   LET g_qca[l_ac].qca07 = g_qca_t.qca07
                   NEXT FIELD qca01
                END IF
                #MOD-B80322 --- modify --- start ---
                SELECT COUNT(*) INTO l_cnt FROM qca_file
                 WHERE g_qca[l_ac].qca02 BETWEEN qca01 AND qca02
                   AND qca07=g_qca[l_ac].qca07
                IF l_cnt > 0 THEN
                   CALL cl_err(g_qca[l_ac].qca02,'aqc-035',1)
                   NEXT FIELD qca02
                END IF
                #MOD-B80322 --- modify ---  end  ---
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_qca_t.qca01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qca_file
                 WHERE qca01 = g_qca_t.qca01
                   AND qca02 = g_qca_t.qca02
                   AND qca03 = g_qca_t.qca03
                   AND qca07 = g_qca_t.qca07
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qca_t.qca01,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("del","qca_file",g_qca_t.qca01,g_qca_t.qca02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
                MESSAGE "Delete OK"
                CLOSE i100_bcl
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qca[l_ac].* = g_qca_t.*
            CLOSE i100_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_qca[l_ac].qca01,-263,1)
             LET g_qca[l_ac].* = g_qca_t.*
         ELSE
             UPDATE qca_file SET
                    qca01 = g_qca[l_ac].qca01,
                    qca02 = g_qca[l_ac].qca02,
                    qca03 = g_qca[l_ac].qca03,
                    qca04 = g_qca[l_ac].qca04,
                    qca05 = g_qca[l_ac].qca05,
                    qca06 = g_qca[l_ac].qca06,
                    qca07 = g_qca[l_ac].qca07
              WHERE qca01 = g_qca_t.qca01
                AND qca02 = g_qca_t.qca02
                AND qca03 = g_qca_t.qca03
                AND qca07 = g_qca_t.qca07
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_qca[l_ac].qca01,SQLCA.sqlcode,0)   #No.FUN-660115
                CALL cl_err3("upd","qca_file",g_qca_t.qca01,g_qca_t.qca02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                LET g_qca[l_ac].* = g_qca_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i100_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qca[l_ac].* = g_qca_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qca.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               CALL i100_b_fill(g_wc2)     #MOD-B80322 add
               EXIT INPUT
            END IF
            #MOD-B80322 --- modify --- start ---
            SELECT COUNT(*) INTO l_cnt FROM qca_file
             WHERE g_qca[l_ac].qca02 BETWEEN qca01 AND qca02
               AND qca07=g_qca[l_ac].qca07
               AND qca01!=g_qca[l_ac].qca03
            IF l_cnt > 0 THEN
               CALL cl_err(g_qca[l_ac].qca02,'aqc-035',1)
               NEXT FIELD qca02
            END IF
            #MOD-B80322 --- modify ---  end  ---
            LET l_ac_t = l_ac
            CLOSE i100_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i100_b_askkey()
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qca01) AND l_ac > 1 THEN
                LET g_qca[l_ac].* = g_qca[l_ac-1].*
                NEXT FIELD qca01
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
 
 
        END INPUT
 
    CLOSE i100_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_b_askkey()
    CLEAR FORM
    CONSTRUCT g_wc2 ON qca01,qca02,qca07,qca03,qca04,qca05,qca06
            FROM s_qca[1].qca01,s_qca[1].qca02,
                 s_qca[1].qca07,s_qca[1].qca03,
                 s_qca[1].qca04,s_qca[1].qca05,
                 s_qca[1].qca06
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
    CALL i100_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2 STRING 
 
    LET g_sql = "SELECT qca01,qca02,qca07,qca03,qca04,qca05,qca06 ",
                 " FROM qca_file  ",
                 " WHERE ", p_wc2 CLIPPED,                     #單身
                 " ORDER BY 1"
 
    PREPARE i100_pb FROM g_sql
    DECLARE qca_curs CURSOR FOR i100_pb
 
    CALL g_qca.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH qca_curs INTO g_qca[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_qca.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qca TO s_qca.* ATTRIBUTE(COUNT=g_rec_b)
 
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
       #MOD-550127..............begin
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
       #MOD-550127..............end
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-570109 --start
FUNCTION i100_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("qca01,qca02,qca03,qca07",TRUE)
   END IF
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("qca01,qca02,qca03,qca07",FALSE)
   END IF
END FUNCTION
#No.FUN-570109 --end
#Patch....NO.TQC-610036 <001> #
