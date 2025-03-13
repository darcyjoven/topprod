# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: asms500.4gl
# Descriptions...: 日關帳設定作業
# Date & Author..: 06/02/21 FUN-620048 By TSD.miki
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳套權限修改
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   g_smp    RECORD LIKE smp_file.*,
   g_smp_t  RECORD LIKE smp_file.*,
   g_smq    DYNAMIC ARRAY OF RECORD LIKE smq_file.*,
   g_smq_t  RECORD LIKE smq_file.*,
   g_rec_b  LIKE type_file.num10, #No.FUN-690010  INTEGER,     #單身筆數
   l_ac     LIKE type_file.num5,      #目前處理的ARRAY CNT   #No.FUN-690010 SMALLINT
   g_cnt    LIKE type_file.num10                                                   #No.FUN-690010 INTEGER
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_forupd_sql   STRING     #SELECT ... FOR UPDATE SQL
DEFINE   g_sql          STRING     #SELECT ... FOR UPDATE SQL
 
MAIN
    OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ASM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time
 
    OPEN WINDOW s500_w WITH FORM "asm/42f/asms500" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL s500_q()
    LET g_action_choice=""
    CALL s500_menu()
    CLOSE WINDOW s500_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

 
FUNCTION s500_menu()
    MENU "" 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END        
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL s500_u()
         END IF
      ON ACTION detail
         LET g_action_choice="detail"
         IF cl_chk_act_auth() THEN
            IF g_smp.smp07='Y' THEN
               CALL s500_b()
            ELSE
               CALL cl_err('','TSD0006',1)
            END IF
         END IF
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
      ON ACTION about
         CALL cl_about()
      ON ACTION controlg
         CALL cl_cmdask()
         LET g_action_choice = "exit"
         CONTINUE MENU
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE 
         LET g_action_choice = "exit"
         EXIT MENU
    END MENU
END FUNCTION
 
#查詢資料
FUNCTION s500_q()
    CALL cl_opmsg('q')
    INITIALIZE g_smp.* TO NULL
    SELECT * INTO g_smp.* FROM smp_file WHERE smp00=0
    IF STATUS = 100 THEN
       BEGIN WORK
       LET g_smp.smp00 = 0
       LET g_smp.smp01='N'
       LET g_smp.smp02='N'
       LET g_smp.smp03='N'
       LET g_smp.smp04='N'
       LET g_smp.smp05='N'
       LET g_smp.smp06='N'
       LET g_smp.smp07='N'
       INSERT INTO smp_file VALUES (g_smp.*)
       IF SQLCA.sqlcode THEN
#         CALL cl_err('ins smp',SQLCA.sqlcode,1)   #No.FUN-660138
          CALL cl_err3("ins","smp_file",g_smp.smp00,g_smp.smp01,SQLCA.sqlcode,"","ins smp",1) #No.FUN-660138
          ROLLBACK WORK   RETURN
       ELSE
          COMMIT WORK
       END IF
    END IF
    CALL s500_display()
    CALL s500_b_fill() #單身
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION s500_display()
    DISPLAY BY NAME
       g_smp.smp01,g_smp.smp011,g_smp.smp02,g_smp.smp021,
       g_smp.smp03,g_smp.smp031,g_smp.smp04,g_smp.smp041,
       g_smp.smp05,g_smp.smp051,g_smp.smp06,g_smp.smp061,
       g_smp.smp07
END FUNCTION
 
FUNCTION s500_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
 
    LET l_sql = "SELECT * FROM smq_file ORDER BY smq01"
    PREPARE s500_pb FROM l_sql
    DECLARE s500_bcs CURSOR WITH HOLD FOR s500_pb    #BODY CURSOR
        
    CALL g_smq.clear()              #單身 ARRAY 乾洗
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH s500_bcs INTO g_smq[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_smq.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY ARRAY g_smq TO s_smq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
       EXIT DISPLAY 
      #NO.FUN-6B0031--BEGIN                                                                                                               
       ON ACTION CONTROLS                                                                                                          
          CALL cl_set_head_visible("","AUTO")                                                                                      
      #NO.FUN-6B0031--END  
 
      #MOD-860081------add-----str---
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
       
       ON ACTION about         
          CALL cl_about()      
       
       ON ACTION controlg      
          CALL cl_cmdask()     
       
       ON ACTION help          
          CALL cl_show_help()  
      #MOD-860081------add-----end---
 
    END DISPLAY  
END FUNCTION
 
FUNCTION s500_u()
    MESSAGE ""

    LET g_sql = " SELECT * FROM smp_file WHERE smp00= ? FOR UPDATE "
    LET g_sql=cl_forupd_sql(g_sql)

    DECLARE s500_cl CURSOR FROM g_sql      # LOCK CURSOR
    BEGIN WORK
    OPEN s500_cl USING g_smp.smp00
    IF STATUS THEN
       CALL cl_err("OPEN s500_cl:", STATUS, 1)
       RETURN
    END IF
    FETCH s500_cl INTO g_smp.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err('FETCH s500_cl:',SQLCA.sqlcode,1)
       RETURN
    END IF
    WHILE TRUE
       LET g_smp_t.* = g_smp.*
       CALL s500_i()
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          LET g_smp.* = g_smp_t.*
          CALL s500_display()
          EXIT WHILE
       END IF
       UPDATE smp_file SET * = g_smp.* WHERE smp00=0
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#         CALL cl_err('upd smp: ',SQLCA.SQLCODE,0)   #No.FUN-660138
          CALL cl_err3("upd","smp_file","","",SQLCA.sqlcode,"","upd smp:",0) #No.FUN-660138
          CONTINUE WHILE
       END IF
#      UNLOCK TABLE smp_file
       EXIT WHILE
    END WHILE
    CLOSE s500_cl
    COMMIT WORK
    IF g_smp.smp07='Y' THEN
       CALL s500_b()
    END IF
END FUNCTION
 
FUNCTION s500_i()              #單頭
 
    CALL s500_display()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_smp.smp01,g_smp.smp011,g_smp.smp02,g_smp.smp021,
                    g_smp.smp03,g_smp.smp031,g_smp.smp04,g_smp.smp041,
                    g_smp.smp05,g_smp.smp051,g_smp.smp06,g_smp.smp061,
                    g_smp.smp07   WITHOUT DEFAULTS 
        
         BEFORE INPUT
            CALL s500_set_entry()
            CALL s500_set_no_entry()
 
         ON CHANGE smp01           #庫存日關帳
            CALL s500_set_entry()
            CALL s500_set_no_entry()
 
         AFTER FIELD smp011
            IF g_smp.smp011 IS NULL OR g_smp.smp011 <= 0 THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp011
            END IF
 
         ON CHANGE smp02           #應付日關帳
            CALL s500_set_entry()
            CALL s500_set_no_entry()
 
         AFTER FIELD smp021
            IF g_smp.smp021 IS NULL OR g_smp.smp021 <= 0 THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp021
            END IF
 
         ON CHANGE smp03           #應收日關帳
            CALL s500_set_entry()
            CALL s500_set_no_entry()
 
         AFTER FIELD smp031
            IF g_smp.smp031 IS NULL OR g_smp.smp031 <= 0 THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp031
            END IF
 
         ON CHANGE smp04           #票據日關帳
            CALL s500_set_entry()
            CALL s500_set_no_entry()
 
         AFTER FIELD smp041
            IF g_smp.smp041 IS NULL OR g_smp.smp041 <= 0 THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp041
            END IF
 
         ON CHANGE smp05           #固資財簽日關帳
            CALL s500_set_entry()
            CALL s500_set_no_entry()
 
         AFTER FIELD smp051
            IF g_smp.smp051 IS NULL OR g_smp.smp051 <= 0 THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp051
            END IF
 
         ON CHANGE smp06           #固資稅簽日關帳
            CALL s500_set_entry()
            CALL s500_set_no_entry()
 
         AFTER FIELD smp061
            IF g_smp.smp061 IS NULL OR g_smp.smp061 <= 0 THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp061
            END IF
 
         AFTER INPUT   #總檢一次
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               EXIT INPUT
            END IF
            IF g_smp.smp01='Y' AND                  #庫存日關帳
               (g_smp.smp011 IS NULL OR g_smp.smp011 <= 0) THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp011
            END IF
            IF g_smp.smp02='Y' AND                  #應付日關帳
               (g_smp.smp021 IS NULL OR g_smp.smp021 <= 0) THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp021
            END IF
            IF g_smp.smp03='Y' AND                  #應收日關帳
               (g_smp.smp031 IS NULL OR g_smp.smp031 <= 0) THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp031
            END IF
            IF g_smp.smp04='Y' AND                  #票據日關帳
               (g_smp.smp041 IS NULL OR g_smp.smp041 <= 0) THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp041
            END IF
            IF g_smp.smp05='Y' AND                  #固資財簽日關帳
               (g_smp.smp051 IS NULL OR g_smp.smp051 <= 0) THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp051
            END IF
            IF g_smp.smp06='Y' AND                  #固資稅簽日關帳
               (g_smp.smp061 IS NULL OR g_smp.smp061 <= 0) THEN
               CALL cl_err('','aap-022',0)
               NEXT FIELD smp061
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask() 
      
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT INPUT
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help  
            CALL cl_show_help()
    END INPUT
END FUNCTION
 
FUNCTION s500_b()
DEFINE li_chk_bookno  LIKE type_file.num5   #No.FUN-690010 SMALLINT   #No.FUN-670006
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_cnt           LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_aaa02         LIKE aaa_file.aaa02,
    l_aaaacti       LIKE aaa_file.aaaacti,
    l_allow_insert  LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1   #No.FUN-690010  VARCHAR(01)               #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET g_forupd_sql = " SELECT smq01,smq02,smq03 ",
                       "   FROM smq_file ",
                       "  WHERE smq01= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE s500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_smq WITHOUT DEFAULTS FROM s_smq.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
           IF g_rec_b>=l_ac THEN
              LET p_cmd = 'u'                                                                                                      
              BEGIN WORK
              LET g_smq_t.* = g_smq[l_ac].*  #BACKUP
              OPEN s500_bcl USING g_smq_t.smq01
              IF STATUS THEN
                 CALL cl_err("OPEN s500_bcl:", STATUS, 1)
                 LET l_lock_sw = 'Y' 
              ELSE  
                 FETCH s500_bcl INTO g_smq[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_smq_t.smq01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_smq[l_ac].* TO NULL    
           LET g_smq_t.* = g_smq[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD smq01
 
        AFTER FIELD smq01                        #帳別
           IF g_smq[l_ac].smq01 != g_smq_t.smq01 OR
              (NOT cl_null(g_smq[l_ac].smq01) AND cl_null(g_smq_t.smq01)) THEN
              LET g_errno = NULL
              SELECT count(*) INTO l_cnt FROM smq_file
               WHERE smq01 = g_smq[l_ac].smq01
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_smq[l_ac].smq01 = g_smq_t.smq01
                 NEXT FIELD smq01
              END IF
              #No.FUN-670006--begin
              CALL s_check_bookno(g_smq[l_ac].smq01,g_user,g_plant) 
                  RETURNING li_chk_bookno
              IF (NOT li_chk_bookno) THEN
                  NEXT FIELD smq01
              END IF 
              #No.FUN-670006--end
              SELECT aaa02,aaaacti INTO l_aaa02,l_aaaacti FROM aaa_file
               WHERE aaa01 = g_smq[l_ac].smq01
              IF SQLCA.SQLCODE THEN LET g_errno = STATUS END IF
              IF l_aaaacti != 'Y' THEN LET g_errno = '9028' END IF
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_smq[l_ac].smq01,g_errno,0)
                 NEXT FIELD smq01
              ELSE
                 LET g_smq[l_ac].smq02 = l_aaa02
                 DISPLAY BY NAME g_smq[l_ac].smq02
              END IF
           END IF
 
        AFTER FIELD smq03
           IF g_smq[l_ac].smq03 IS NULL OR g_smq[l_ac].smq03 <= 0 THEN
              CALL cl_err('','aap-022',0)
              NEXT FIELD smq03
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF NOT cl_null(g_smq_t.smq01) THEN
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM smq_file 
               WHERE smq01 = g_smq_t.smq01
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                CALL cl_err(g_smq_t.smq01,SQLCA.sqlcode,0)   #No.FUN-660138
                 CALL cl_err3("del","smq_file",g_smq_t.smq01,"",SQLCA.sqlcode,"","",0) #No.FUN-660138
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              COMMIT WORK
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_smq[l_ac].* = g_smq_t.*
              CLOSE s500_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_smq[l_ac].smq01,-263,1)
              LET g_smq[l_ac].* = g_smq_t.*
           ELSE
              UPDATE smq_file SET * = g_smq[l_ac].*
               WHERE smq01= g_smq_t.smq01
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                CALL cl_err(g_smq[l_ac].smq01,SQLCA.sqlcode,0)   #No.FUN-660138
                 CALL cl_err3("upd","smq_file",g_smq_t.smq01,"",SQLCA.sqlcode,"","",0) #No.FUN-660138
                 LET g_smq[l_ac].* = g_smq_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_smq[l_ac].* = g_smq_t.*
              #FUN-D40030---add---str---
              ELSE
                 CALL g_smq.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
#                   LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030---add---end---
              END IF
              CLOSE s500_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           CLOSE s500_bcl
           COMMIT WORK
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE s500_bcl
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_smq[l_ac].smq01) THEN
              IF g_smq[l_ac].smq03 IS NULL OR g_smq[l_ac].smq03 <= 0 THEN
                 CALL cl_err('','aap-022',0)
                 CANCEL INSERT
              END IF
           END IF
           INSERT INTO smq_file VALUES(g_smq[l_ac].*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#             CALL cl_err(g_smq[l_ac].smq01,SQLCA.sqlcode,0)   #No.FUN-660138
              CALL cl_err3("ins","smq_file",g_smq[l_ac].smq01,g_smq[l_ac].smq02,SQLCA.sqlcode,"","",0) #No.FUN-660138
              CALL g_smq.deleteElement(l_ac)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b = g_rec_b + 1
           END IF
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(smq01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aaa"
                    CALL cl_create_qry() RETURNING g_smq[l_ac].smq01
                    DISPLAY BY NAME g_smq[l_ac].smq01
                    NEXT FIELD smq01
               OTHERWISE EXIT CASE
           END CASE
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(smq01) AND l_ac > 1 THEN
              LET g_smq[l_ac].* = g_smq[l_ac-1].*
              NEXT FIELD smq01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
    END INPUT
 
    CLOSE s500_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION s500_set_entry()
 
    IF g_smp.smp01='Y' THEN CALL cl_set_comp_entry("smp011",TRUE) END IF
    IF g_smp.smp02='Y' THEN CALL cl_set_comp_entry("smp021",TRUE) END IF
    IF g_smp.smp03='Y' THEN CALL cl_set_comp_entry("smp031",TRUE) END IF
    IF g_smp.smp04='Y' THEN CALL cl_set_comp_entry("smp041",TRUE) END IF
    IF g_smp.smp05='Y' THEN CALL cl_set_comp_entry("smp051",TRUE) END IF
    IF g_smp.smp06='Y' THEN CALL cl_set_comp_entry("smp061",TRUE) END IF
END FUNCTION
 
FUNCTION s500_set_no_entry()
 
    IF g_smp.smp01!='Y' THEN CALL cl_set_comp_entry("smp011",FALSE) END IF
    IF g_smp.smp02!='Y' THEN CALL cl_set_comp_entry("smp021",FALSE) END IF
    IF g_smp.smp03!='Y' THEN CALL cl_set_comp_entry("smp031",FALSE) END IF
    IF g_smp.smp04!='Y' THEN CALL cl_set_comp_entry("smp041",FALSE) END IF
    IF g_smp.smp05!='Y' THEN CALL cl_set_comp_entry("smp051",FALSE) END IF
    IF g_smp.smp06!='Y' THEN CALL cl_set_comp_entry("smp061",FALSE) END IF
END FUNCTION
