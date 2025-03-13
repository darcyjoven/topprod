# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
#
# Pattern name...: atmi181.4gl
# Descriptions...: 車輛暫停使用記錄維護作業
# Date & Author..: 03/12/04 By hawk
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,調整報表
# Modify.........: No.FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: NO.FUN-660104 06/06/16 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680120 06/09/01 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/07/18 By mike 報表格式修改為p_query
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_oby           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        oby01       LIKE oby_file.oby01,   #車輛代號
        oby02       LIKE oby_file.oby02,   #起始日期
        oby03       LIKE oby_file.oby03,   #起始時間
        oby04       LIKE oby_file.oby04,   #截至日期
        oby05       LIKE oby_file.oby05,   #截至時間
        oby06       LIKE oby_file.oby06    #備注
                    END RECORD,
    g_oby_t         RECORD                 #程式變數 (舊值)
        oby01       LIKE oby_file.oby01,   #車輛代號
        oby02       LIKE oby_file.oby02,   #起始日期
        oby03       LIKE oby_file.oby03,   #起始時間
        oby04       LIKE oby_file.oby04,   #截至日期
        oby05       LIKE oby_file.oby05,   #截至時間
        oby06       LIKE oby_file.oby06    #備注
                    END RECORD,
     g_wc2,g_sql     string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5              #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5             #No.FUN-680120 SMALLINT  #count/index for any purpose
DEFINE   g_before_input_done LIKE type_file.num5         #No.FUN-680120 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5             #No.FUN-680120 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    LET p_row = 4 LET p_col = 14
    OPEN WINDOW i181_w AT p_row,p_col WITH FORM "atm/42f/atmi181"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i181_b_fill(g_wc2)
    CALL i181_menu()
    CLOSE WINDOW i181_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i181_menu()
 DEFINE   l_cmd   STRING    #No.FUN-780056 
   WHILE TRUE
      CALL i181_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i181_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i181_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i181_out()                                    #No.FUN-780056
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF         #No.FUN-780056
               LET l_cmd = 'p_query "atmi181" "',g_wc2 CLIPPED,'"'  #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                               #No.FUN-780056
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i181_q()
   CALL i181_b_askkey()
END FUNCTION
 
FUNCTION i181_b()
DEFINE
    l_ac_t          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    l_no            LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    l_allow_insert  LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)              #可新增否
    l_allow_delete  LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)              #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT oby01,oby02,oby03,oby04,oby05,oby06 ",
                       "  FROM oby_file  WHERE oby01=? AND oby02=?  ",
                       "   AND oby03=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i181_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
 
    LET l_ac_t=0
    INPUT ARRAY g_oby WITHOUT DEFAULTS FROM s_oby.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
        LET p_cmd=' '
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
 
        IF g_rec_b >=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_oby_t.* = g_oby[l_ac].*  #BACKUP
#No.FUN-570109 --start
           LET g_before_input_done = FALSE
           CALL i181_set_entry(p_cmd)
           CALL i181_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
#No.FUN-570109 --end
           OPEN i181_bcl USING g_oby_t.oby01,g_oby_t.oby02,g_oby_t.oby03
           IF STATUS THEN
              CALL cl_err("OPEN i181_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE
              FETCH i181_bcl INTO g_oby[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_oby_t.oby01,SQLCA.sqlcode,1)
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
            CALL i181_set_entry(p_cmd)
            CALL i181_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end
            INITIALIZE g_oby[l_ac].* TO NULL
            LET g_oby_t.* = g_oby[l_ac].*
            LET g_oby[l_ac].oby03 = '0000'
            LET g_oby[l_ac].oby05 = '2359'
            LET g_oby[l_ac].oby02 = g_today
            LET g_oby[l_ac].oby04 = g_today
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oby01
 
    AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i181_bcl
              CANCEL INSERT
           END IF
           IF g_oby[l_ac].oby01 IS NOT NULL THEN
              CALL i181_oby01()
              IF NOT cl_null(g_errno) THEN
                   CALL cl_err('oby01:',g_errno,0)
                   LET g_oby[l_ac].oby01 = g_oby_t.oby01
                   NEXT FIELD oby01
               END IF
               CALL i181_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_oby[l_ac].* = g_oby_t.*
                  NEXT FIELD oby02
               END IF
           END IF
           INSERT INTO oby_file(oby01,oby02,oby03,oby04,oby05,
                                oby06,obyuser,obydate,obyoriu,obyorig)
           VALUES(g_oby[l_ac].oby01,g_oby[l_ac].oby02,
                  g_oby[l_ac].oby03,g_oby[l_ac].oby04,
                  g_oby[l_ac].oby05,g_oby[l_ac].oby06,
                  g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_oby[l_ac].oby01,SQLCA.sqlcode,0)  #No.FUN-660104
              CALL cl_err3("ins","oby_file",g_oby[l_ac].oby01,"",
                            SQLCA.sqlcode,"","",1)  #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
      AFTER FIELD oby01
          IF NOT cl_null(g_oby[l_ac].oby01) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_oby[l_ac].oby01 != g_oby_t.oby01) THEN
               CALL i181_oby01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('oby01:',g_errno,0)
                  LET g_oby[l_ac].oby01 = g_oby_t.oby01
                  NEXT FIELD oby01
               END IF
            END IF
          END IF
 
     AFTER FIELD oby03
          IF NOT cl_null(g_oby[l_ac].oby03) THEN
            IF (g_oby[l_ac].oby03 NOT MATCHES '[0-2][0-9][0-5][0-9]') OR
               (g_oby[l_ac].oby03 > '2359') THEN
               CALL cl_err('','axd-014',0) NEXT FIELD oby03
            END IF
 
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
              (g_oby[l_ac].oby01 != g_oby_t.oby01 OR
               g_oby[l_ac].oby02 != g_oby_t.oby02 OR
               g_oby[l_ac].oby03 != g_oby_t.oby03)) THEN
              SELECT COUNT(*) INTO l_no FROM oby_file
               WHERE oby01 = g_oby[l_ac].oby01
                 AND oby02 = g_oby[l_ac].oby02
                 AND oby03=g_oby[l_ac].oby03
              IF l_no >0 THEN
                  CALL cl_err('','axd-013',0)
                  NEXT FIELD oby01
              END IF
            END IF
          END IF
 
    AFTER FIELD oby04
          IF NOT cl_null(g_oby[l_ac].oby04) THEN
            IF g_oby[l_ac].oby02 > g_oby[l_ac].oby04 THEN
                 CALL cl_err('','axd-014',0)
                 NEXT FIELD oby02
            END IF
          END IF
 
 
    AFTER FIELD oby05
          IF NOT cl_null(g_oby[l_ac].oby05) THEN
            IF (g_oby[l_ac].oby05 NOT MATCHES '[0-2][0-9][0-5][0-9]')OR
               (g_oby[l_ac].oby05 > '2359') THEN
                 CALL cl_err('','axd-014',0) NEXT FIELD oby05
            END IF
 
            IF (g_oby[l_ac].oby02 = g_oby[l_ac].oby04 AND
                g_oby[l_ac].oby03 >=g_oby[l_ac].oby05) THEN
                 CALL cl_err('','axd-014',0)
                 NEXT FIELD oby02
            END IF
 
            CALL i181_check()                #判斷時間是否有誤或重復
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD oby02
            END IF
          END IF
 
     BEFORE DELETE                            #是否取消單身
            IF g_oby_t.oby01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM oby_file 
                WHERE  oby01 = g_oby_t.oby01
                  AND  oby02 = g_oby_t.oby02
                  AND  oby03 = g_oby_t.oby03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_oby_t.oby01,SQLCA.sqlcode,0)  #No.FUN-660104
                  CALL cl_err3("del","oby_file",g_oby_t.oby01,"",
                                SQLCA.sqlcode,"","",1)  #No.FUN-660104
                  LET l_ac_t=l_ac
                  EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_oby[l_ac].* = g_oby_t.*
              CLOSE i181_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF g_oby[l_ac].oby01 IS NOT NULL THEN
              CALL i181_oby01()
              IF NOT cl_null(g_errno) THEN
                   CALL cl_err('oby01:',g_errno,0)
                   LET g_oby[l_ac].oby01 = g_oby_t.oby01
                   NEXT FIELD oby01
               END IF
               CALL i181_check()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_oby[l_ac].* = g_oby_t.*
                  NEXT FIELD oby02
               END IF
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_oby[l_ac].oby01,-263,0)
              LET g_oby[l_ac].* = g_oby_t.*
           ELSE
              UPDATE oby_file
                 SET oby01=g_oby[l_ac].oby01,oby02=g_oby[l_ac].oby02,
                     oby03=g_oby[l_ac].oby03,oby04=g_oby[l_ac].oby04,
                     oby05=g_oby[l_ac].oby05,oby06=g_oby[l_ac].oby06,
                     obymodu=g_user,obydate=g_today
               WHERE CURRENT OF i181_bcl
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_oby[l_ac].oby01,SQLCA.sqlcode,0)  #No.FUN-660104
                 CALL cl_err3("upd","oby_file",g_oby[l_ac].oby01,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
 
                 LET g_oby[l_ac].* = g_oby_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
         AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30033 mark
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_oby[l_ac].* = g_oby_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_oby.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i181_bcl                # 新增
               ROLLBACK WORK                 # 新增
               EXIT INPUT
             END IF
             LET l_ac_t = l_ac #FUN-D30033 add
             CLOSE i181_bcl                # 新增
             COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i181_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(oby01) AND l_ac > 1 THEN
                LET g_oby[l_ac].* = g_oby[l_ac-1].*
                NEXT FIELD oby01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
             IF INFIELD(oby01) THEN
             #     CALL q_obw01(10,10,g_oby[l_ac].oby01)
             #          RETURNING g_oby[l_ac].oby01
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obw01"
                   LET g_qryparam.default1 = g_oby[l_ac].oby01
                   CALL cl_create_qry() RETURNING g_oby[l_ac].oby01
                   NEXT FIELD oby01
             END IF
 
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
 
    CLOSE i181_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i181_oby01()
  DEFINE  l_obw01      LIKE obw_file.obw01,
          l_obwacti    LIKE obw_file.obwacti
 
     LET g_errno = ' '
     SELECT obw01,obwacti INTO l_obw01,l_obwacti
       FROM obw_file
      WHERE obw01=g_oby[l_ac].oby01
 
     CASE
         WHEN SQLCA.sqlcode =100       LET g_errno='axd-010'
         WHEN l_obwacti MATCHES '[nN]' LET g_errno = '9028'
         OTHERWISE LET g_errno=SQLCA.sqlcode USING '------'
     END CASE
END FUNCTION
 
FUNCTION i181_check()
 DEFINE  l_old         RECORD
                       oby02       LIKE oby_file.oby02,
                       oby03       LIKE oby_file.oby03,
                       oby04       LIKE oby_file.oby04,
                       oby05       LIKE oby_file.oby05
                       END RECORD,
         l_sql         LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(200)
         l_date        LIKE type_file.dat,              #No.FUN-680120 DATE
         l_btime       LIKE type_file.num20,            #No.FUN-680120 DEC(20)
         l_etime       LIKE type_file.num20,            #No.FUN-680120 DEC(20)
         l_btime_old   LIKE type_file.num20,            #No.FUN-680120 DEC(20) 
         l_etime_old   LIKE type_file.num20,            #No.FUN-680120 DEC(20)
         l_hour        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
         l_min         LIKE type_file.num5              #No.FUN-680120 SMALLINT
 
    LET g_errno = ''
    LET l_date  =  "2000/01/01"
    SELECT oby01  INTO  g_oby[l_ac].oby01 
      FROM oby_file
     WHERE  oby01 = g_oby_t.oby01
       AND  oby02 = g_oby_t.oby02
       AND  oby03 = g_oby_t.oby03
    LET l_sql = "SELECT oby02,oby03,oby04,oby05 FROM oby_file",
                " WHERE oby01  = '",g_oby[l_ac].oby01,"'",
                "   AND oby01 != '",g_oby_t.oby01,"' AND oby02 != '",g_oby_t.oby02,"' AND oby03 != '",g_oby_t.oby03,"'"
    PREPARE check_prepare FROM l_sql
    IF SQLCA.sqlcode THEN
       LET g_errno = SQLCA.sqlcode USING '-------' RETURN
    END IF
    DECLARE check_cs SCROLL CURSOR FOR check_prepare
    OPEN check_cs
    FOREACH check_cs INTO l_old.*
      IF SQLCA.sqlcode = 0 THEN
         LET l_hour  = g_oby[l_ac].oby03[1,2]
         LET l_min   = g_oby[l_ac].oby03[3,4]
         LET l_btime = (g_oby[l_ac].oby02-l_date)*24*60+l_hour*60+l_min
 
         LET l_hour  = g_oby[l_ac].oby05[1,2]
         LET l_min   = g_oby[l_ac].oby05[3,4]
         LET l_etime = (g_oby[l_ac].oby04-l_date)*24*60+l_hour*60+l_min
 
         LET l_hour  = l_old.oby03[1,2]
         LET l_min   = l_old.oby03[3,4]
         LET l_btime_old =(l_old.oby02-l_date)*24*60+l_hour*60+l_min
 
         LET l_hour  = l_old.oby05[1,2]
         LET l_min   = l_old.oby05[3,4]
         LET l_etime_old =(l_old.oby04-l_date)*24*60+l_hour*60+l_min
 
         IF (l_btime>l_btime_old AND l_btime < l_etime_old) OR
            (l_etime>l_btime_old AND l_etime < l_etime_old) OR
            (l_btime_old>l_btime AND l_btime_old < l_etime) OR
            (l_etime_old>l_btime AND l_etime_old < l_etime) THEN
            LET g_errno = 'axd-020'
            RETURN
         END IF
      END IF
    END FOREACH
END FUNCTION
 
FUNCTION i181_b_askkey()
    CLEAR FORM
    CALL g_oby.clear()
    CONSTRUCT g_wc2 ON oby01,oby02,oby03,oby04,oby05,oby06
                  FROM s_oby[1].oby01,s_oby[1].oby02,s_oby[1].oby03,
                       s_oby[1].oby04,s_oby[1].oby05,s_oby[1].oby06
 
        #No.FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
             IF INFIELD(oby01) THEN
             #     CALL q_obw01(10,10,g_oby[l_ac].oby01)
             #          RETURNING g_oby[l_ac].oby01
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_obw01"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_oby[l_ac].oby01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_oby[1].oby01
                   NEXT FIELD oby01
             END IF
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('obyuser', 'obygrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i181_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i181_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000          #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT oby01,oby02,oby03,oby04,oby05,oby06,''",
        " FROM oby_file",
        " WHERE ", p_wc2 CLIPPED,
        " ORDER BY oby01,oby02,oby03"
    PREPARE i181_pb FROM g_sql
    DECLARE oby_curs CURSOR FOR i181_pb
 
    CALL g_oby.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" ATTRIBUTE(REVERSE)
    FOREACH oby_curs INTO g_oby[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oby.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)    #No.FUN-940135
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i181_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oby TO s_oby.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION close
         LET g_action_choice="exit"
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
 
#No.FUN-780056 -str
{
FUNCTION i181_out()
    DEFINE
        l_oby           RECORD LIKE oby_file.*,
        l_i             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)
         l_za05          LIKE za_file.za05  #MOD-4B0067
 
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM oby_file ",
              " WHERE ",g_wc2 CLIPPED,
              " ORDER BY oby01,oby02,oby03"
    PREPARE i181_p1 FROM g_sql
    DECLARE i181_co
         CURSOR FOR i181_p1
 
    CALL cl_outnam('atmi181') RETURNING l_name
    START REPORT i181_rep TO l_name
 
    FOREACH i181_co INTO l_oby.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i181_rep(l_oby.*)
    END FOREACH
 
    FINISH REPORT i181_rep
 
    CLOSE i181_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i181_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        sr RECORD LIKE oby_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.oby01,sr.oby02,sr.oby03
 
    FORMAT
     PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],
                  g_x[34],g_x[35],g_x[36]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 #MOD-4B0067(BEGIN)
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.oby01,
                  COLUMN g_c[32],sr.oby02,
                  COLUMN g_c[33],sr.oby03,
                  COLUMN g_c[34],sr.oby04,
                  COLUMN g_c[35],sr.oby05,
                  COLUMN g_c[36],sr.oby06
 
        AFTER GROUP OF sr.oby01
            PRINT ' '
 #MOD-4B0067(END)
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780056 -end
 
#No.FUN-570109 --start
FUNCTION i181_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("oby01,oby02,oby03",TRUE)
   END IF
END FUNCTION
 
FUNCTION i181_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("oby01,oby02,oby03",FALSE)
   END IF
END FUNCTION
#No.FUN-570109 --end
#Patch....NO.TQC-610037 <001> #
