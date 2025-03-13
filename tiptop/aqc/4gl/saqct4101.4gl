# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: saqct4101.4gl
# Descriptions...: DATE CODE 維護作業
# Date & Author..: 99/05/17 By Iceman 
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/31 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-920287 09/02/23 By claire (1) DELETE 錯誤
#                                                   (2)單身重查功能鍵無法使用,應不需要此功能 
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_qci2          RECORD LIKE qci_file.*,     
    g_qcf           RECORD LIKE qcf_file.*,     
    g_pnl           RECORD LIKE pnl_file.*,     
    g_qci           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    qci02       LIKE qci_file.qci02
                    END RECORD,
    g_qci_t         RECORD                
                    qci02       LIKE qci_file.qci02
                    END RECORD,
              tm  RECORD	
                    wc      LIKE type_file.chr1000      #No.FUN-680104  VARCHAR(300)
                    END RECORD,
       g_argv1             LIKE type_file.chr1,         #No.FUN-680104  VARCHAR(01)
       g_sw                LIKE type_file.chr1,         #No.FUN-680104  VARCHAR(01)
       g_wc,g_wc2,g_sql    STRING,                      #No.FUN-580092 HCN        #No.FUN-680104 
       g_seq           LIKE type_file.num5,             #No.FUN-680104 SMALLINT
       g_rec_b         LIKE type_file.num5,             #單身筆數        #No.FUN-680104 SMALLINT
       l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
 
DEFINE g_forupd_sql    STRING                           #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_before_input_done  LIKE type_file.num5           #No.FUN-680104 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10             #No.FUN-680104 INTEGER
FUNCTION saqct4101(p_argv1)
#     DEFINE   l_time LIKE type_file.chr8         #No.FUN-6A0085
     DEFINE    l_sql      LIKE type_file.chr1000,              #No.FUN-680104 VARCHAR(400)
               p_argv1    LIKE qcf_file.qcf01 
 
   WHENEVER ERROR CONTINUE
    IF p_argv1 IS NULL OR p_argv1 = ' ' THEN 
       RETURN
    END IF
    LET g_sw = 'Y'
    LET g_qcf.qcf01  = p_argv1
 
    OPEN WINDOW t4101_w AT 10,21 WITH FORM "aqc/42f/aqct4101" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aqct4101")
 
    DISPLAY BY NAME g_qcf.qcf01 
 
    CALL t4101_b_fill("") 
    CALL t4101_b()
    CLOSE WINDOW t4101_w
 
END FUNCTION
 
   
FUNCTION t4101_b()
DEFINE
    l_str           LIKE type_file.chr1000,            #No.FUN-680104 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n,l_k         LIKE type_file.num5,               #檢查重複用        #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否        #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,               #處理狀態          #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,               #可新增否          #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                #可刪除否          #No.FUN-680104 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_qcf.qcf01 IS NULL OR g_qcf.qcf01 = ' ' THEN 
       RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT qci02 FROM qci_file ",
                       " WHERE qci01= ? AND qci02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t4101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_qci WITHOUT DEFAULTS FROM s_qci.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
               LET g_qci_t.* = g_qci[l_ac].*  #BACKUP
 
               OPEN t4101_bcl USING g_qcf.qcf01, g_qci_t.qci02 
               IF STATUS THEN
                  CALL cl_err("OPEN t4101_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t4101_bcl INTO g_qci[l_ac].* 
                  IF SQLCA.sqlcode THEN
                    CALL cl_err(g_qci_t.qci02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                  END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_qci[l_ac].* TO NULL      #900423
           #LET g_qci_t.* = g_qci[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO qci_file(qci01,qci02, #No.MOD-470041
                         qciplant,qcilegal)    #FUN-980007 
                 VALUES(g_qcf.qcf01,g_qci[l_ac].qci02,
                         g_plant,g_legal)      #FUN-980007
            IF STATUS THEN
#              CALL cl_err(g_qci[l_ac].qci02,SQLCA.sqlcode,0)  #No.FUN-660115
               CALL cl_err3("ins","qci_file",g_qcf.qcf01,g_qci[l_ac].qci02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
            END IF
 
        AFTER FIELD qci02
          IF NOT cl_null(g_qci[l_ac].qci02) THEN
             IF g_qci[l_ac].qci02 != g_qci_t.qci02 
                OR cl_null(g_qci_t.qci02) THEN
                SELECT COUNT(*) INTO l_n FROM qci_file
                 WHERE qci01 = g_qcf.qcf01
                   AND qci02 = g_qci[l_ac].qci02
                IF l_n > 0 THEN 
                    CALL cl_err (g_qci[l_ac].qci02,-239,0)
                    LET g_qci[l_ac].qci02 = g_qci_t.qci02
                    NEXT FIELD qci02
                END IF
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
          #  IF g_qci_t.qci02 > 0 AND   #MOD-920287 mark
             IF g_qci_t.qci02 IS NOT NULL THEN   #MOD-920287  add IF
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM qci_file
                 WHERE qci01 = g_qcf.qcf01 
                   AND qci02 = g_qci_t.qci02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qci_t.qci02,SQLCA.sqlcode,0)  #No.FUN-660115
                   CALL cl_err3("del","qci_file",g_qcf.qcf01,g_qci_t.qci02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                MESSAGE "Delete Ok"
                CLOSE t4101_bcl
                COMMIT WORK
            END IF   
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_qci[l_ac].* = g_qci_t.*
               CLOSE t4101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_qci[l_ac].qci02,-263,1)
               LET g_qci[l_ac].* = g_qci_t.*
            ELSE
               UPDATE qci_file SET qci02 = g_qci[l_ac].qci02 
                WHERE qci01=g_qcf.qcf01 
                  AND qci02=g_qci_t.qci02 
               IF STATUS THEN
#                  CALL cl_err(g_qci[l_ac].qci02,STATUS,0)  #No.FUN-660115
                   CALL cl_err3("upd","qci_file",g_qcf.qcf01,g_qci_t.qci02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   LET g_qci[l_ac].* = g_qci_t.*
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac     
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qci[l_ac].* = g_qci_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qci.deleteElement(l_ac)
            #FUN-D30034--add--end--
               END IF
               CLOSE t4101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t4101_bcl
            COMMIT WORK
 
        #ON ACTION CONTROLN    #MOD-920287 mark
        # EXIT INPUT           #MOD-920287 mark
 
        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
         CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     
     END INPUT
 
     CLOSE t4101_bcl
     COMMIT WORK
 
END FUNCTION
   
   
FUNCTION t4101_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000        #No.FUN-680104 VARCHAR(200)
 
    LET g_sql = "SELECT qci02 FROM  qci_file ",
                " WHERE qci01 = '",g_qcf.qcf01,"'" 
 
    PREPARE t4101_pb FROM g_sql
    DECLARE qci_curs  CURSOR WITH HOLD FOR t4101_pb
 
    CALL g_qci.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH qci_curs INTO g_qci[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_qci.deleteElement(g_cnt)
    LET g_rec_b =g_cnt-1               #告訴I.單身筆數
 
END FUNCTION
 
{   
FUNCTION t4101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qci TO s_qci.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
   ON ACTION accept
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
   ON ACTION locale
      CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
}
