# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmp310.4gl
# Descriptions...: 承認號碼整批維護作業
# Input parameter:
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy x,t_無用到,所以刪除
# Modify.........: No.FUN-4B0024 04/11/04 By Smapmin 料件編號開窗
# Modify.........: No.MOD-530368 05/03/26 By kim 機種查詢不work.
# Modify.........: No.MOD-530688 05/04/04 By Anney
# Modify..........: No.TQC-5A0063 05/10/19 By Rosayu 輸入承認文號即日其後會更新apmi254中的核准
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.CHI-690058 06/12/08 By pengu 整批承認時，不會insert至azv_file
# Modify.........: No.TQC-6C0224 07/04/09 By claire 由abmi310串出時,隱藏action
# Modify.........: No.TQC-750172 07/05/30 By rainy 由abmi310整批承認串出時，無法將資料帶出
# MOdify.........: No.CHI-790003 07/09/02 By Nicole 修正Insert Into pmh_file Error
# Modify.........: No.CHI-860042 08/07/17 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-980027 09/12/30 By baofei  Mark CURSOR p310_count 
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No.FUN-AB0062 10/11/23 By jan 新增'單身全部承認'action
# Modify.........: No.TQC-AC0154 10/12/14 By vealxu pmh24(VMI)沒給值，應該default='N'
# Modify.........: NO:MOD-BA0077 11/10/12 By johung p310_upd_bmj應一併回寫bnm_file/bnn_file
# Modify.........: NO:TQC-C20520 12/02/28 By lilingyu 單身資料承認後，廠牌料號等訊息沒有更新到pmh_file
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cn2           LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    g_bmj01         LIKE bmj_file.bmj01,   #類別代號 (假單頭)
    g_bmj01_t       LIKE bmj_file.bmj01,   #類別代號 (舊值)
    g_bmj02         LIKE bmj_file.bmj02,   #類別代號 (假單頭)
    g_bmj02_t       LIKE bmj_file.bmj02,   #類別代號 (舊值)
    g_bmj03         LIKE bmj_file.bmj03,   #類別代號 (假單頭)
    g_bmj03_t       LIKE bmj_file.bmj03,   #類別代號 (舊值)
    g_bmj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                bmj01b      LIKE bmj_file.bmj01,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                bmj10       LIKE bmj_file.bmj10,
                bmj11       LIKE bmj_file.bmj11,
                bmj02b      LIKE bmj_file.bmj02,
                bmj03b      LIKE bmj_file.bmj03,
                mse02       LIKE mse_file.mse02,
                pmc03       LIKE pmc_file.pmc03,
                bmj04       LIKE bmj_file.bmj04   #FUN-AB0062
   END RECORD,
 
    g_bmj_t         RECORD                 #程式變數 (舊值)
                bmj01b      LIKE bmj_file.bmj01,
                ima02       LIKE ima_file.ima02,
                ima021      LIKE ima_file.ima021,
                bmj10       LIKE bmj_file.bmj10,
                bmj11       LIKE bmj_file.bmj11,
                bmj02b      LIKE bmj_file.bmj02,
                bmj03b      LIKE bmj_file.bmj03,
                mse02       LIKE mse_file.mse02,
                pmc03       LIKE pmc_file.pmc03,
                bmj04       LIKE bmj_file.bmj04   #FUN-AB0062
   END RECORD,
 
    g_argv1         LIKE bmj_file.bmj01,
    g_wc,g_sql      string,  #No.FUN-580092 HCN
    g_ss            LIKE type_file.chr1,   #決定後續步驟    #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT     #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE   #No.FUN-680096 SMALLINT
  DEFINE g_flag     LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE g_bmj10      LIKE bmj_file.bmj10    #FUN-AB0062
DEFINE g_bmj11      LIKE bmj_file.bmj11    #FUN-AB0062

MAIN
 
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
 
    LET g_argv1 = ARG_VAL(1)              #料件編號
    LET g_bmj01 = NULL                     #清除鍵值
    LET g_bmj01_t = NULL
    LET g_bmj01 = g_argv1
    LET g_bmj11 = g_today   #FUN-AB0062
 
    LET p_row = 3 LET p_col = 20
 
    OPEN WINDOW p310_w AT p_row,p_col WITH FORM "abm/42f/abmp310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN
       LET g_flag = 'q'    #TQC-750172
       CALL p310_q()
    END IF
 
#    BEGIN WORK
#       UPDATE bmj_file set bmj99 = 
#    COMMIT WORK
 
     CALL p310_menu()
 
    CLOSE WINDOW p310_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION p310_curs()
    CLEAR FORM                             #清除畫面
   CALL g_bmj.clear()
    IF cl_null(g_argv1) THEN
       IF g_flag = 'q' THEN
           CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
           CONSTRUCT g_wc ON bmj01,bmj02,bmj03,bmj04 FROM bmj01,bmj02,bmj03,bmj04  #FUN-AB0062
            ON ACTION controlp   #FUN-4B0024
               IF INFIELD(bmj01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_bmj2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmj01
                  NEXT FIELD bmj01
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
 
 
           END CONSTRUCT
           LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmjuser', 'bmjgrup') #FUN-980030
       ELSE
           CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
           CONSTRUCT g_wc ON bmk03  FROM bmk03
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           END CONSTRUCT
       END IF
    ELSE
       LET g_wc = " bmj01 = '",g_argv1,"'"
       DISPLAY g_argv1 TO bmj01  #TQC-750172
    END IF
    IF INT_FLAG THEN RETURN END IF
    IF g_flag = 'q' THEN
       LET g_sql =
       "SELECT bmj01,ima02,ima021,bmj10,bmj11,bmj02,bmj03,'','',bmj04 ",  #FUN-AB0062
       " FROM bmj_file, ima_file ",
       " WHERE  bmj01 = ima01 ",
       "   AND  ( bmj08 != '3' OR bmj08 IS NULL)  AND ",g_wc CLIPPED
    ELSE
       LET g_sql =
       "SELECT bmj01,ima02,ima021,bmj10,bmj11,bmj02,bmj03,'','',bmj04 ",  #FUN-AB0062
        " FROM bmj_file,bmk_file,ima_file",
       " WHERE ", g_wc CLIPPED,
       "   AND bmj01 = bmk01 AND bmj01=ima01 ",
       "   AND ( bmj08 != '3' OR bmj08 IS NULL ) ",
 #      "   AND ( bmj02 !='' AND bmj02 !=' ' )",  #MOD-530368
 #      "   AND ( bmj03 !='' AND bmj03 !=' ' )"   #MOD-530368
        "   AND bmj02 IS NOT NULL ",  #MOD-530368
        "   AND bmj03 IS NOT NULL "   #MOD-530368
    END IF
    LET g_sql = g_sql CLIPPED, " ORDER BY bmj01"
    PREPARE p310_prepare FROM g_sql      #預備一下
    DECLARE p310_b_curs                  #宣告成可捲動的
        CURSOR WITH HOLD FOR p310_prepare
#TQC-980027---begin
#   IF g_flag = 'q' THEN
#      LET g_sql="SELECT COUNT(bmj01) FROM bmj_file",
#                " WHERE ",g_wc CLIPPED,
#                "   AND ( bmj08 != '3' OR bmj08 IS NULL ",
#                "   AND ( bmj02 !='' AND bmj02 !=' ' )",
#                "   AND ( bmj03 !='' AND bmj03 !=' ' )"
#   ELSE
#      LET g_sql="SELECT COUNT(bmj01) FROM bmj_file,bmk_file ",
#                " WHERE ",g_wc CLIPPED,
#                "   AND ( bmj08 != '3' OR bmj08 IS NULL ) ",
#                "   AND bmj01= bmk01 ",
#                "   AND ( bmj02 !='' AND bmj02 !=' ' )",
#                "   AND ( bmj03 !='' AND bmj03 !=' ' )"
#   END IF
#   PREPARE p310_precount FROM g_sql
#   DECLARE p310_count CURSOR FOR p310_precount
#TQC-980027---end
END FUNCTION
 
FUNCTION p310_menu()
 
 
   WHILE TRUE
     #TQC-6C0224-begin-add
      CALL cl_set_act_visible("query_by_item_no",TRUE)
      CALL cl_set_act_visible("query_by_model",TRUE)
      IF NOT cl_null(g_argv1) THEN
         CALL cl_set_act_visible("query_by_item_no",FALSE)
         CALL cl_set_act_visible("query_by_model",FALSE)
      END IF 
     #TQC-6C0224-end-add
 
      CALL p310_bp("G")
      CASE g_action_choice
 
         #@WHEN "料件查詢"
           WHEN "query_by_item_no"
               IF cl_chk_act_auth() THEN
                   LET g_flag = 'q'
                   CALL p310_q()
               END IF
 
         #@WHEN "機種查詢"
           WHEN "query_by_model"
               IF cl_chk_act_auth() THEN
                   LET g_flag = 'm'
                   CALL p310_q()
               END IF
          
         #FUN-AB0062--begin--add--------     
         #@WHEN "單身全部承認"
           WHEN "app_batch"
              IF cl_chk_act_auth() THEN
                 IF g_bmj.getlength() > 0 THEN
                    CALL p310_bat_app()
                 END IF
              END IF
         #FUN-AB0062--end--add---------
              
           WHEN "detail"
               IF cl_chk_act_auth() THEN
                   CALL p310_b()
                   LET g_action_choice = NULL
               ELSE
                  LET g_action_choice = NULL
               END IF
 
           WHEN "help"
                CALL cl_show_help()
 
           WHEN "exit"
                EXIT WHILE
 
           WHEN "controlg"     #KEY(CONTROL-G)
                CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p310_q()                       #Query 查詢
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL ui.Interface.refresh()
    CALL p310_curs()                    #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
       #INITIALIZE g_bmj01 TO NULL
        RETURN
    END IF
   #OPEN p310_count
   #FETCH p310_count INTO g_cnt
   #DISPLAY g_cnt TO FORMONLY.cnt
    CALL p310_b_fill(g_wc) #單身
END FUNCTION
 
#單身
FUNCTION p310_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用    #No.FUN-680096 SMALLINT
    l_modify_flag   LIKE type_file.chr1,     #單身更改否    #No.FUN-680096 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否    #No.FUN-680096 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,     #Esc結束INPUT ARRAY 否  #No.FUN-680096 SMALLINT
    p_cmd           LIKE type_file.chr1,     #處理狀態      #No.FUN-680096 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,  #可新增否      #No.FUN-680096 VARCHAR(80)
    l_insert        LIKE type_file.chr1,     #可新增否      #No.FUN-680096 VARCHAR(1)
    l_update        LIKE type_file.chr1,     #可更改否 (含取消)  #No.FUN-680096 VARCHAR(1)
    l_tot           LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    l_jump,i        LIKE type_file.num5,     #判斷是否跳過AFTER ROW的處理   #No.FUN-680096 SMALLINT
    l_allow_insert  LIKE type_file.num5,     #可新增否   #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否   #No.FUN-680096 SMALLINT
#--------No.CHI-690058 add
#DEFINE 
#   l_azv    RECORD LIKE azv_file.*,
#   l_bmj    RECORD LIKE bmj_file.*,
#   l_azv10  LIKE azv_file.azv10
#--------No.CHI-690058 end
 
 
    IF s_shut(0) THEN RETURN END IF
   #IF g_bmj01 IS NULL THEN    RETURN END IF
    LET l_insert='Y'
    LET l_update='Y'
 
    CALL cl_opmsg('b')
 
    LET l_ac_t = 0
 
    WHILE TRUE
       LET l_exit_sw = "y"                #正常結束,除非 ^N
       LET l_allow_insert = FALSE
       LET l_allow_delete = FALSE
 
       INPUT ARRAY g_bmj
             WITHOUT DEFAULTS
             FROM s_bmj.*
             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
           #LET l_n    = ARR_COUNT()
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac   = ARR_CURR()
            LET l_sl   = SCR_LINE()
            DISPLAY l_ac   TO FORMONLY.cn2
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_bmj_t.* = g_bmj[l_ac].*  #BACKUP
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
     ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmj[l_ac].* = g_bmj_t.*
              #CLOSE i020_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err('',-263,1)
               LET g_bmj[l_ac].* = g_bmj_t.*
            ELSE
                #TQC-5A0063 增加if判斷決定要不要更新bmj08=3
                IF NOT cl_null(g_bmj[l_ac].bmj10) AND NOT cl_null(g_bmj[l_ac].bmj11) THEN
#FUN-AB0062--begin--modify------------------------
                   CALL p310_upd_bmj(l_ac,g_bmj[l_ac].bmj10,g_bmj[l_ac].bmj11)
#                   UPDATE bmj_file SET bmj10   = g_bmj[l_ac].bmj10,
#                                       bmj11   = g_bmj[l_ac].bmj11,
#                                       bmj08   = '3',
#                                       bmjmodu = g_user,
#                                       bmjdate = g_today
#                   WHERE  bmj01=g_bmj[l_ac].bmj01b
#                     AND  bmj02=g_bmj[l_ac].bmj02b
#                     AND  bmj03=g_bmj[l_ac].bmj03b
#                #TQC-5A0063 add
#                   #-----------No.CHI-690058 add
#                    SELECT * INTO l_bmj.* FROM bmj_file
#                       WHERE  bmj01=g_bmj[l_ac].bmj01b
#                         AND  bmj02=g_bmj[l_ac].bmj02b
#                         AND  bmj03=g_bmj[l_ac].bmj03b
# 
#                    LET l_azv10 = cl_getmsg('abm-820',g_lang)
#                    LET l_azv.azv01 = l_bmj.bmj01
#                    LET l_azv.azv02 = l_bmj.bmj02
#                    LET l_azv.azv03 = l_bmj.bmj03
#                    LET l_azv.azv04 = l_bmj.bmj10
#                    LET l_azv.azv05 = l_bmj.bmj11
#                    LET l_azv.azv06 = l_bmj.bmj08
#                    LET l_azv.azv07 = g_user
#                    LET l_azv.azv08 = TODAY
#                    LET l_azv.azv09 = TIME
#                    LET l_azv.azv10 = l_azv10
# 
#                    #FUN-980001 add plant & legal 
#                    LET l_azv.azvplant = g_plant 
#                    LET l_azv.azvlegal = g_legal 
#                    #FUN-980001 end 
# 
#                    INSERT INTO azv_file VALUES(l_azv.*)
#                    IF SQLCA.sqlcode THEN
#                       CALL cl_err('ins_azv',SQLCA.sqlcode,1)
#                    END IF
#                   #-----------No.CHI-690058 end
#FUN-AB0062--end--modify--------------------------------
                ELSE
                  UPDATE bmj_file SET bmj10   = g_bmj[l_ac].bmj10,
                                      bmj11   = g_bmj[l_ac].bmj11,
                                      bmj08   = '2',   #FUN-AB0062
                                      bmjmodu = g_user,
                                      bmjdate = g_today
                   WHERE  bmj01=g_bmj[l_ac].bmj01b
                     AND  bmj02=g_bmj[l_ac].bmj02b
                     AND  bmj03=g_bmj[l_ac].bmj03b
                END IF
                #TQC-5A0063 end
                IF SQLCA.sqlcode THEN
              #     CALL cl_err(g_bmj[l_ac].bmj01b,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("upd","bmj_file",g_bmj[l_ac].bmj01b,g_bmj[l_ac].bmj02b,SQLCA.sqlcode,"","",0)    #No.TQC-660046
                    LET g_bmj[l_ac].* = g_bmj_t.*
                ELSE
                    #TQC-5A0063 add
                    IF NOT cl_null(g_bmj[l_ac].bmj10) AND NOT cl_null(g_bmj[l_ac].bmj11) THEN
                       CALL p310_ins_pmh(l_ac,g_bmj[l_ac].bmj11)  #FUN-A90062
                    END IF
                    #TQC-5A0063 end
                    MESSAGE 'UPDATE O.K'
                    CALL ui.Interface.refresh()
                    COMMIT WORK
                END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
 
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bmj[l_ac].* = g_bmj_t.*
               END IF
               ROLLBACK WORK
               EXIT INPUT
           END IF
           COMMIT WORK
 
       #ON ACTION CONTROLO                        #沿用所有欄位
       #    IF INFIELD(bmj10) AND l_ac > 1 THEN
       #        LET g_bmj[l_ac].bmj10 = g_bmj[l_ac-1].bmj10
       #        LET g_bmj[l_ac].bmj11 = g_bmj[l_ac-1].bmj11
       #        DISPLAY g_bmj[l_ac].* TO s_bmj[l_sl].*
       #        NEXT FIELD bmj10
       #    END IF
 
       #ON ACTION batch_update                    #沿用所有欄位
       #        FOR i = l_ac TO l_n
       #          #LET g_bmj[i].bmj10 = g_bmj[i-1].bmj10
       #          #LET g_bmj[i].bmj11 = g_bmj[i-1].bmj11
       #           LET g_bmj[i].bmj10 = g_bmj[l_ac].bmj10
       #           LET g_bmj[i].bmj11 = g_bmj[l_ac].bmj11
       #           UPDATE bmj_file SET  bmj10 = g_bmj[i].bmj10,
       #                                bmj11 = g_bmj[i].bmj11,
       #                                bmj08 = '3',
       #                                bmjmodu = g_user,
       #                                bmjdate = g_today
       #            WHERE  bmj01=g_bmj[l_ac].bmj01b
       #              AND  bmj02=g_bmj[l_ac].bmj02b
       #              AND  bmj03=g_bmj[l_ac].bmj03b
       #        END FOR
       #        CALL p310_b_fill(' 1=1 ')

        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      #FUN-AB0062--begin--add--------
      ON ACTION delete
         INITIALIZE g_bmj[l_ac].* TO NULL
         CALL g_bmj.deleteElement(l_ac)
         LET g_rec_b=g_rec_b - 1
      #FUN-AB0062--end--add----------
         
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
        IF l_exit_sw = "y" THEN
            EXIT WHILE                     #ESC 或 DEL 結束 INPUT
        ELSE
            CONTINUE WHILE                 #^N 結束 INPUT
        END IF
    END WHILE
 
    COMMIT WORK
END FUNCTION
 
#TQC-5A0063 add
FUNCTION p310_ins_pmh(p_ac,p_bmj11)                 #MODNO:6831 add   #FUN-A90062--add p_ac,p_bmj11
  DEFINE  l_cnt      LIKE type_file.num5,          #No.FUN-680096 SMALLINT
          l_pmh      RECORD LIKE pmh_file.*,
          l_pmh05    LIKE pmh_file.pmh05,
          l_pmh06    LIKE pmh_file.pmh06,
          l_pmc22    LIKE pmc_file.pmc22
  DEFINE  p_bmj11    LIKE bmj_file.bmj11    #FUN-A90062
  DEFINE  p_ac       LIKE type_file.num5    #FUN-A90062
 
     IF g_sma.sma102='N' THEN RETURN END IF
 
     SELECT pmc22 INTO l_pmc22 FROM pmc_file WHERE pmc01 = g_bmj[p_ac].bmj03b  #FUN-A90062 l_ac-->p_ac
 
     IF NOT cl_null(l_pmc22) THEN
        SELECT COUNT(*) INTO l_cnt FROM pmh_file
         WHERE pmh01 = g_bmj[p_ac].bmj01b         #FUN-A90062 l_ac-->p_ac
           AND pmh02 = g_bmj[p_ac].bmj03b         #FUN-A90062 l_ac-->p_ac
           AND pmh13 = l_pmc22
           AND pmh21 = " "                                             #CHI-860042                                                  
           AND pmh22 = '1'                                             #CHI-860042
           AND pmhacti = 'Y'                                           #CHI-910021
        IF l_cnt > 0 THEN
           LET l_pmh05 = '0'
          #LET l_pmh06 = g_bmj[l_ac].bmj11  #FUN-A90062
           LET l_pmh06 = p_bmj11            #FUN-A90062
           UPDATE pmh_file SET
                  pmh05 = l_pmh05,
                  pmh06 = l_pmh06,
                  pmhdate = g_today     #FUN-C40009 add
            WHERE pmh01 = g_bmj[p_ac].bmj01b   #FUN-A90062 l_ac-->p_ac
              AND pmh02 = g_bmj[p_ac].bmj03b   #FUN-A90062 l_ac-->p_ac
              AND pmh13 = l_pmc22
              AND pmh21 = " "                                             #CHI-860042                                               
              AND pmh22 = '1'                                             #CHI-860042
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       #      CALL cl_err('upd_pmh_err',sqlca.sqlcode,0) #No.TQC-660046
              CALL cl_err3("upd","pmh_file",g_bmj[p_ac].bmj01b,g_bmj[p_ac].bmj03b,SQLCA.sqlcode,"","upd_pmh_err",0)    #No.TQC-660046 #FUN-A90062 l_ac-->p_ac
              LET g_success = 'N'
           END IF
        ELSE
           LET l_pmh.pmh01 = g_bmj[p_ac].bmj01b   #FUN-A90062 l_ac-->p_ac
           LET l_pmh.pmh02 = g_bmj[p_ac].bmj03b   #FUN-A90062 l_ac-->p_ac
#          LET l_pmh.pmh04 = ''                   #TQC-C20520
           LET l_pmh.pmh04 = g_bmj[p_ac].bmj04    #TQC-C20520
           LET l_pmh.pmh07 = g_bmj[p_ac].bmj02b   #FUN-A90062 l_ac-->p_ac
           SELECT ima24 INTO l_pmh.pmh08 FROM ima_file
            WHERE ima01 = g_bmj[p_ac].bmj01b      #FUN-A90062 l_ac-->p_ac
           IF cl_null(l_pmh.pmh08) THEN LET l_pmh.pmh08 = 'Y' END IF
           LET l_pmh.pmh13 = l_pmc22
           IF g_aza.aza17 = l_pmh.pmh13 THEN   #本幣
              LET l_pmh.pmh14 = 1
           ELSE
              CALL s_curr3(l_pmh.pmh13,g_today,'S') RETURNING l_pmh.pmh14
           END IF
           LET l_pmh.pmh05 = '0'
           LET l_pmh.pmh06 = p_bmj11   #FUN-A90062
           #No.CHI-790003 START
           IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
           #No.CHI-790003 END  
           LET l_pmh.pmhoriu = g_user      #No.FUN-980030 10/01/04
           LET l_pmh.pmhorig = g_grup      #No.FUN-980030 10/01/04
           LET l_pmh.pmh25='N'   #No:FUN-AA0015
           LET l_pmh.pmhacti='Y'     #FUN-AB0062
           LET l_pmh.pmhuser=g_user  #FUN-AB0062
           LET l_pmh.pmhgrup=g_grup  #FUN-AB0062
           LET l_pmh.pmhdate=g_today #FUN-AB0062
           IF l_pmh.pmh21 IS NULL THEN LET l_pmh.pmh21 = ' ' END IF #FUN-AB0062
           IF l_pmh.pmh22 IS NULL THEN LET l_pmh.pmh22 = '1' END IF #FUN-AB0062
           IF l_pmh.pmh23 IS NULL THEN LET l_pmh.pmh23 = ' ' END IF #FUN-AB0062
           IF l_pmh.pmh24 IS NULL THEN LET l_pmh.pmh24 = 'N' END IF #TQC-AC0154 
           INSERT INTO pmh_file VALUES(l_pmh.*)
           IF SQLCA.sqlcode  THEN
              CALL cl_err('ins_pmh_err',sqlca.sqlcode,0) #No.TQC-660046
              CALL cl_err3("ins","pmh_file",l_pmh.pmh01,l_pmh.pmh02,SQLCA.sqlcode,"","ins_pmh_err",0)   #No.TQC-660046
              LET g_success = 'N'
           END IF
        END IF
     END IF
END FUNCTION
#TQC-5A0063 end
 
 
FUNCTION p310_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(200)
    i       LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
    CALL g_bmj.clear()
    LET g_cnt = 1
    FOREACH p310_b_curs INTO g_bmj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT mse02 INTO g_bmj[g_cnt].mse02  FROM mse_file
                 WHERE mse01 = g_bmj[g_cnt].bmj02b
        IF SQLCA.sqlcode THEN LET g_bmj[g_cnt].mse02 = ' ' END IF
        SELECT pmc03 INTO g_bmj[g_cnt].pmc03   FROM pmc_file
                 WHERE pmc01 = g_bmj[g_cnt].bmj03b
        IF SQLCA.sqlcode THEN LET g_bmj[g_cnt].pmc03 = ' ' END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_bmj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION p310_bp(p_ud)
    DEFINE p_ud    LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_bmj TO s_bmj.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION controlg
           LET g_action_choice="controlg"
           EXIT DISPLAY
        ON ACTION detail
           LET g_action_choice="detail"
           EXIT DISPLAY
 
      #@ON ACTION 料件查詢
        ON ACTION query_by_item_no
           LET g_action_choice="query_by_item_no"
           EXIT DISPLAY
 
      #@ON ACTION 機種查詢
        ON ACTION query_by_model
           LET g_action_choice="query_by_model"
           EXIT DISPLAY
 
      #FUN-AB0062--begin--add--------
        ON ACTION app_batch
           LET g_action_choice="app_batch"
           EXIT DISPLAY
      #FUN-AB0062--end--add-----------
           
        ON ACTION help
           LET g_action_choice="help"
           EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
           LET g_action_choice="exit"
           EXIT DISPLAY
 
       #No.MOD-530688  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530688  --end
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-AB0062--begin--add-------------------
FUNCTION p310_bat_app()
DEFINE i          LIKE type_file.num5
DEFINE l_bmj10_t  LIKE bmj_file.bmj10
DEFINE l_bmj11_t  LIKE bmj_file.bmj11
 
 
   OPEN WINDOW p310a_w AT p_row,p_col WITH FORM "abm/42f/abmp310a" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("abmp310a")
  
   CALL cl_opmsg('a')
   
   LET l_bmj11_t=' ' 
   DISPLAY g_bmj10,g_bmj11 TO FORMONLY.bmj10,FORMONLY.bmj11
 
   INPUT g_bmj10,g_bmj11 WITHOUT DEFAULTS FROM FORMONLY.bmj10,FORMONLY.bmj11
        
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
   IF INT_FLAG THEN 
       LET INT_FLAG = 0
       CLOSE WINDOW p310a_w
       RETURN 
   END IF
   CLOSE WINDOW p310a_w
   IF NOT cl_null(g_bmj11) AND NOT cl_null(g_bmj10) THEN
      FOR i=1 TO g_bmj.getlength()
         BEGIN WORK
         LET g_success = 'Y'
         IF cl_null(g_bmj[i].bmj10) OR cl_null(g_bmj[i].bmj11) THEN
            LET l_bmj10_t=g_bmj[i].bmj10
            LET l_bmj11_t=g_bmj[i].bmj11
            CALL p310_upd_bmj(i,g_bmj10,g_bmj11)
            IF g_success = 'Y' THEN 
               CALL p310_ins_pmh(i,g_bmj11)
            END IF
         END IF
         IF g_success = 'Y' THEN 
            COMMIT WORK 
         ELSE 
            LET g_bmj[i].bmj10=l_bmj10_t
            LET g_bmj[i].bmj11=l_bmj11_t
            ROLLBACK WORK 
         END IF
      END FOR
   END IF
      

END FUNCTION

FUNCTION p310_upd_bmj(p_ac,p_bmj10,p_bmj11)
   DEFINE p_ac      LIKE type_file.num5
   DEFINE p_bmj10   LIKE bmj_file.bmj10
   DEFINE p_bmj11   LIKE bmj_file.bmj11
   DEFINE 
       l_azv    RECORD LIKE azv_file.*,
       l_bmj    RECORD LIKE bmj_file.*,
       l_azv10  LIKE azv_file.azv10
   #MOD-BA0077 -- begin --
   DEFINE l_bnm01   LIKE bnm_file.bnm01,
          l_cnt     LIKE type_file.num5
   #MOD-BA0077 -- end --

   UPDATE bmj_file SET bmj10   = p_bmj10,
                       bmj11   = p_bmj11,
                       bmj08   = '3',
                       bmjmodu = g_user,
                       bmjdate = g_today
    WHERE  bmj01=g_bmj[p_ac].bmj01b
      AND  bmj02=g_bmj[p_ac].bmj02b
      AND  bmj03=g_bmj[p_ac].bmj03b
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('upd bmj',SQLCA.sqlcode,1)
   ELSE
      LET g_bmj[p_ac].bmj10=p_bmj10
      LET g_bmj[p_ac].bmj11=p_bmj11
   END IF
      
   SELECT * INTO l_bmj.* FROM bmj_file
    WHERE  bmj01=g_bmj[p_ac].bmj01b
      AND  bmj02=g_bmj[p_ac].bmj02b
      AND  bmj03=g_bmj[p_ac].bmj03b
 
   #MOD-BA0077 -- begin --
   SELECT DISTINCT bnm01 INTO l_bnm01
     FROM bnm_file,bnn_file
    WHERE bnm01 = bnn01
      AND bnm05 = l_bmj.bmj03
      AND bnn03 = l_bmj.bmj01
      AND bnn04 = l_bmj.bmj02
      AND bnm08 <> '9'  #CHI-C80041
   UPDATE bnn_file SET bnn06 = p_bmj10,
                       bnn10 = p_bmj11
   WHERE bnn01 = l_bnm01
     AND bnn03 = l_bmj.bmj01
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('upd bnn',SQLCA.sqlcode,1)
   END IF
   SELECT COUNT(*) INTO l_cnt FROM bmj_file
    WHERE bmj08 <> '3'
      AND bmj01 || bmj02 || bmj03
       IN (SELECT bnn03 || bnn04 || bnm05
             FROM bnm_file,bnn_file
            WHERE bnm01 = bnn01
              AND bnm01 = l_bnm01
              AND bnm08 <> '9'  )#CHI-C80041
   IF l_cnt = 0 THEN
      UPDATE bnm_file SET bnm06 = l_bmj.bmj08
       WHERE bnm01 = l_bnm01
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err('upd bnm',SQLCA.sqlcode,1)
      END IF
   END IF
   #MOD-BA0077 -- end --

   LET l_azv10 = cl_getmsg('abm-820',g_lang)
   LET l_azv.azv01 = l_bmj.bmj01
   LET l_azv.azv02 = l_bmj.bmj02
   LET l_azv.azv03 = l_bmj.bmj03
   LET l_azv.azv04 = l_bmj.bmj10
   LET l_azv.azv05 = l_bmj.bmj11
   LET l_azv.azv06 = l_bmj.bmj08
   LET l_azv.azv07 = g_user
   LET l_azv.azv08 = TODAY
   LET l_azv.azv09 = TIME
   LET l_azv.azv10 = l_azv10
   LET l_azv.azvplant = g_plant 
   LET l_azv.azvlegal = g_legal 
 
   INSERT INTO azv_file VALUES(l_azv.*)
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err('ins_azv',SQLCA.sqlcode,1)
   END IF
END FUNCTION
#FUN-AB0062--end--add----------------------

FUNCTION p310_out()
DEFINE
    l_i         LIKE type_file.num5,             #No.FUN-680096 SMALLINT
    sr              RECORD
                bmj01       LIKE bmj_file.bmj01,
                bmj02       LIKE bmj_file.bmj02,
                bmj03       LIKE bmj_file.bmj03,
                bmj04       LIKE bmj_file.bmj04,
                bmj05       LIKE bmj_file.bmj05,
                bmj06       LIKE bmj_file.bmj06,
                bmj07       LIKE bmj_file.bmj07,
                bmj08       LIKE bmj_file.bmj08,
                sts         LIKE aab_file.aab02,  #No.FUN-680096 VARCHAR(6)
                bmj09       LIKE bmj_file.bmj09,
                bmi02       LIKE bmi_file.bmi02,
                bmj10       LIKE bmj_file.bmj10,
                bmj11       LIKE bmj_file.bmj11,
                bmj12       LIKE bmj_file.bmj12,
                bmjacti     LIKE bmj_file.bmjacti #No.FUN-680096 VARCHAR(1)
    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
{
    IF g_wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
}
 
    CALL cl_wait()
    CALL cl_outnam('abmp310') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmp310'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
    LET g_sql="SELECT bmj01,bmj02,bmj03,bmj04,bmj05,bmj06,",
              " bmj07,bmj08,'',bmj09,'',",
              "       bmj10,bmj11,bmj12,bmjacti ",
              " FROM bmj_file "  # 組合出 SQL 指令
 
 
    PREPARE p310_p1 FROM g_sql                # uUNTIME 編譯
    DECLARE p310_curo                         # CURSOR
        CURSOR FOR p310_p1
 
    START REPORT p310_rep TO l_name
    LET g_pageno = 0
 
    FOREACH p310_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT p310_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p310_rep
 
    CLOSE p310_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p310_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_chr           LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    l_tot           LIKE type_file.num20_6,  #No.FUN-680096 DECIMAL(20,6)
    l_page          LIKE type_file.num5,     #No.FUN-680096 SMALLINT
    sr              RECORD
                bmj01       LIKE bmj_file.bmj01,
                bmj02       LIKE bmj_file.bmj02,
                bmj03       LIKE bmj_file.bmj03,
                bmj04       LIKE bmj_file.bmj04,
                bmj05       LIKE bmj_file.bmj05,
                bmj06       LIKE bmj_file.bmj06,
                bmj07       LIKE bmj_file.bmj07,
                bmj08       LIKE bmj_file.bmj08,
                sts         LIKE aab_file.aab02, #No.FUN-680096 VARCHAR(6)
                bmj09       LIKE bmj_file.bmj09,
                bmi02       LIKE bmi_file.bmi02,
                bmj10       LIKE bmj_file.bmj10,
                bmj11       LIKE bmj_file.bmj11,
                bmj12       LIKE bmj_file.bmj12,
                bmjacti     LIKE bmj_file.bmjacti #No.FUN-680096 VARCHAR(1)
    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmj01
 
    FORMAT
        PAGE HEADER
                        LET l_page = 0
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.bmj01  #類別代號
            IF l_page >0
            THEN
               SKIP TO TOP OF PAGE
            END IF
            LET l_tot =0
 
        ON EVERY ROW
            IF sr.bmjacti MATCHES "[Nn]"
            THEN
                   LET l_chr = '*'
            ELSE
                   LET l_chr = ' '
            END IF
        PRINT sr.bmj01,' ',sr.bmj02,' ',sr.bmj03,' ',sr.bmj04,' ',sr.bmj05,
              sr.bmj06,' ',sr.bmj07,' ',sr.bmj08,' ',sr.bmj09,' ',sr.bmj10,
              sr.bmj11,' ',sr.bmj12
 
        AFTER GROUP OF sr.bmj01  #類別代號
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
                        LET l_page = 1
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#Patch....NO.TQC-610035 <001> #
