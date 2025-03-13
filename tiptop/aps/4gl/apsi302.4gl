# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsi302.4gl
# Descriptions...: 週行事曆資料維護作業
# Date & Author..: No.FUN-4B0037 04/11/10 By ching
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-720043 07/03/19 By Mandy APS相關調整程式內所有apswcm改成vmc_file
# Modify.........: NO.FUN-850114 07/12/25 BY yiting apsi205-->apsi302.4gl
# Modify.........: NO.FUN-890130 08/09/30 BY DUKE 工作模式設定開窗
# Modify.........: No.FUN-8A0004 08/10/03 by duke q_vma02 --> q_vma03
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80181 11/08/30 By Abby apsi302單身刪除或週行事曆編號改變時,需check 週行事曆編號[vmc01]
#                                                 (1)在apsi303 的週行事曆[vmd02]未被使用,若有被使用則show提示且無法刪除或改變
#                                                 (2)在apsi321 的週行事曆[vmj02]未被使用,若有被使用則show提示且無法刪除或改變
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables) #FUN-720043程式內所有apswcm改成vmc_file
        vmc01            LIKE vmc_file.vmc01,   #FUN-850114
        vmc02            LIKE vmc_file.vmc02,
        vmc03            LIKE vmc_file.vmc03,
        vmc04            LIKE vmc_file.vmc04,
        vmc05            LIKE vmc_file.vmc05,
        vmc06            LIKE vmc_file.vmc06,
        vmc07            LIKE vmc_file.vmc07,
        vmc08            LIKE vmc_file.vmc08
                         END RECORD,
    g_vmc_t         RECORD                 #程式變數 (舊值)
        vmc01            LIKE vmc_file.vmc01,
        vmc02            LIKE vmc_file.vmc02,
        vmc03            LIKE vmc_file.vmc03,
        vmc04            LIKE vmc_file.vmc04,
        vmc05            LIKE vmc_file.vmc05,
        vmc06            LIKE vmc_file.vmc06,
        vmc07            LIKE vmc_file.vmc07,
        vmc08            LIKE vmc_file.vmc08
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    l_vma021        LIKE type_file.chr8,
    l_vma031        LIKE type_file.chr8,
    l_vma02         LIKE vma_file.vma02,
    l_vma03         LIKE vma_file.vma03,
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-690010 SMALLINT    # 目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-570110  #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
 
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
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW i302_w WITH FORM "aps/42f/apsi302"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i302_b_fill(g_wc2)
    CALL i302_menu()
    CLOSE WINDOW i302_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i302_menu()
 
   WHILE TRUE
      CALL i302_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i302_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i302_b()
            ELSE
               LET g_action_choice = NULL
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
 
FUNCTION i302_q()
   CALL i302_b_askkey()
END FUNCTION
 
FUNCTION i302_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #No.FUN-690010CHAR(01),
    l_allow_delete  LIKE type_file.chr1    #No.FUN-690010CHAR(01)
DEFINE l_cnt        LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT vmc01, " ,
                       " vmc02, vmc03, vmc04, vmc05,  ",
                       " vmc06, vmc07, vmc08 ",
                       " FROM vmc_file ",
                       "WHERE vmc01 = ?  FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i302_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_vmc WITHOUT DEFAULTS FROM s_vmc.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET g_vmc_t.* = g_vmc[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
#No.FUN-570110--begin
               LET g_before_input_done = FALSE
               CALL i302_set_entry_b(p_cmd)
               CALL i302_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110--end
               LET g_vmc_t.* = g_vmc[l_ac].*  #BACKUP
               BEGIN WORK
               OPEN i302_bcl USING g_vmc_t.vmc01
               IF STATUS THEN
                  CALL cl_err("OPEN i302_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i302_bcl INTO g_vmc[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD vmc01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i302_set_entry_b(p_cmd)
            CALL i302_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end
            INITIALIZE g_vmc[l_ac].* TO NULL
            LET g_vmc_t.* = g_vmc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vmc01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO vmc_file(
                            vmc01, #No.MOD-470041
                            vmc02,
                            vmc03,
                            vmc04,
                            vmc05,
                            vmc06,
                            vmc07,
                            vmc08)
             VALUES(
                    g_vmc[l_ac].vmc01,
                    g_vmc[l_ac].vmc02,
                    g_vmc[l_ac].vmc03,
                    g_vmc[l_ac].vmc04,
                    g_vmc[l_ac].vmc05,
                    g_vmc[l_ac].vmc06,
                    g_vmc[l_ac].vmc07,
                    g_vmc[l_ac].vmc08)
 
         IF SQLCA.sqlcode THEN
  #           CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
             CALL cl_err3("ins","vmc_file",g_vmc[l_ac].vmc01,"",SQLCA.sqlcode,"","",1) # FUN-660095
             LET g_vmc[l_ac].* = g_vmc_t.*
             DISPLAY g_vmc[l_ac].* TO s_vmc[l_sl].*
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
        AFTER FIELD vmc01                #check 編號是否重複
            IF NOT cl_null(g_vmc[l_ac].vmc01) THEN
               IF (g_vmc_t.vmc01 != g_vmc[l_ac].vmc01 )  OR
                  p_cmd='a' THEN
                   SELECT count(*) INTO l_n FROM vmc_file
                    WHERE vmc01 = g_vmc[l_ac].vmc01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_vmc[l_ac].vmc01 = g_vmc_t.vmc01
                       DISPLAY g_vmc[l_ac].vmc01 TO s_vmc[l_sl].vmc01
                       NEXT FIELD vmc01
                   END IF
                  #FUN-B80181 add str---
                   SELECT count(*) INTO l_n FROM vmd_file
                    WHERE vmd02 = g_vmc_t.vmc01
                   IF l_n > 0 THEN
                       CALL cl_err('','aps-808',0)
                       LET g_vmc[l_ac].vmc01 = g_vmc_t.vmc01
                       NEXT FIELD vmc01
                   END IF
                   SELECT count(*) INTO l_n FROM vmj_file
                    WHERE vmj02 = g_vmc_t.vmc01
                   IF l_n > 0 THEN
                       CALL cl_err('','aps-809',0)
                       LET g_vmc[l_ac].vmc01 = g_vmc_t.vmc01
                       NEXT FIELD vmc01
                   END IF
                  #FUN-B80181 add end---
               END IF
            END IF
 
        AFTER FIELD vmc02
            LET l_cnt = 0
            IF NOT cl_null(g_vmc[l_ac].vmc02) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmc[l_ac].vmc02
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmc02
               END IF
            END IF
            #FUN-8A0004  vmc02不得空白
            IF cl_null(g_vmc[l_ac].vmc02) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD vmc02
            END IF
 
        AFTER FIELD vmc03
            LET l_cnt = 0
            IF NOT cl_null(g_vmc[l_ac].vmc03) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmc[l_ac].vmc03
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmc03
               END IF
            END IF
            #FUN-8A0004  vmc03不得空白
            IF cl_null(g_vmc[l_ac].vmc03) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD vmc03
            END IF
 
 
        AFTER FIELD vmc04
            LET l_cnt = 0
            IF NOT cl_null(g_vmc[l_ac].vmc04) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmc[l_ac].vmc04
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmc04
               END IF
            END IF
            #FUN-8A0004  vmc04不得空白
            IF cl_null(g_vmc[l_ac].vmc04) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD vmc04
            END IF
 
 
        AFTER FIELD vmc05
            LET l_cnt = 0
            IF NOT cl_null(g_vmc[l_ac].vmc05) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmc[l_ac].vmc05
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmc05
               END IF
            END IF
            #FUN-8A0004  vmc05不得空白
            IF cl_null(g_vmc[l_ac].vmc05) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD vmc05
            END IF
 
 
        AFTER FIELD vmc06
            LET l_cnt = 0
            IF NOT cl_null(g_vmc[l_ac].vmc06) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmc[l_ac].vmc06
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmc06
               END IF
            END IF
            #FUN-8A0004  vmc06不得空白
            IF cl_null(g_vmc[l_ac].vmc06) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD vmc06
            END IF
 
 
        AFTER FIELD vmc07
            LET l_cnt = 0
            IF NOT cl_null(g_vmc[l_ac].vmc07) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmc[l_ac].vmc07
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmc07
               END IF
            END IF
            #FUN-8A0004  vmc07不得空白
            IF cl_null(g_vmc[l_ac].vmc07) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD vmc07
            END IF
 
 
        AFTER FIELD vmc08
            LET l_cnt = 0
            IF NOT cl_null(g_vmc[l_ac].vmc08) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmc[l_ac].vmc08
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmc08
               END IF
            END IF
            #FUN-8A0004  vmc08不得空白
            IF cl_null(g_vmc[l_ac].vmc08) THEN
               NEXT FIELD vmc08
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vmc_t.vmc01) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               #FUN-B80181 add str---
                SELECT count(*) INTO l_n FROM vmd_file
                 WHERE vmd02 = g_vmc_t.vmc01
                IF l_n > 0 THEN
                    CALL cl_err('','aps-808',0)
                    LET g_vmc[l_ac].vmc01 = g_vmc_t.vmc01
                    CANCEL DELETE
                END IF
                SELECT count(*) INTO l_n FROM vmj_file
                 WHERE vmj02 = g_vmc_t.vmc01
                IF l_n > 0 THEN
                    CALL cl_err('','aps-809',0)
                    LET g_vmc[l_ac].vmc01 = g_vmc_t.vmc01
                    CANCEL DELETE
                END IF
               #FUN-B80181 add end---
                DELETE FROM vmc_file
                 WHERE vmc01 = g_vmc_t.vmc01
                IF SQLCA.sqlcode THEN
  #                 CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
                   CALL cl_err3("del","vmc_file",g_vmc_t.vmc01,"",SQLCA.sqlcode,"","",1) # FUN-660095
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i302_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_vmc[l_ac].* = g_vmc_t.*
              CLOSE i302_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_vmc[l_ac].vmc01,-263,1)
              LET g_vmc[l_ac].* = g_vmc_t.*
           ELSE
              UPDATE vmc_file SET vmc01 = g_vmc[l_ac].vmc01,
                                vmc02 = g_vmc[l_ac].vmc02,
                                vmc03 = g_vmc[l_ac].vmc03,
                                vmc04 = g_vmc[l_ac].vmc04,
                                vmc05 = g_vmc[l_ac].vmc05,
                                vmc06 = g_vmc[l_ac].vmc06,
                                vmc07 = g_vmc[l_ac].vmc07,
                                vmc08 = g_vmc[l_ac].vmc08
               WHERE CURRENT OF i302_bcl
 
              IF SQLCA.sqlcode THEN
  #                CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
            CALL cl_err3("upd","vmc_file",g_vmc_t.vmc01,"",SQLCA.sqlcode,"","",1) # FUN-660095
                  LET g_vmc[l_ac].* = g_vmc_t.*
                  DISPLAY g_vmc[l_ac].* TO s_vmc[l_sl].*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i302_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_vmc[l_ac].* = g_vmc_t.*
               END IF
               CLOSE i302_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i302_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i302_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vmc01) AND l_ac > 1 THEN
                LET g_vmc[l_ac].* = g_vmc[l_ac-1].*
                DISPLAY g_vmc[l_ac].* TO s_vmc[l_sl].*
                NEXT FIELD vmc01
            END IF
 
        #FUN-890130
        ON ACTION controlp
           CASE
            WHEN INFIELD(vmc02)                 #工作模式
                 CALL cl_init_qry_var()
                 #FUN-8A0004  q_vma02 --> q_vma03
                 #LET g_qryparam.form = "q_vma02"
                 #LET g_qryparam.default1 = g_vmc[l_ac].vmc02
                 #CALL cl_create_qry() RETURNING g_vmc[l_ac].vmc02
                 CALL q_vma03(FALSE,TRUE,g_vmc[l_ac].vmc02)
                      RETURNING  g_vmc[l_ac].vmc02,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[l_ac].vmc02
                 NEXT FIELD vmc02
            WHEN INFIELD(vmc03)     #工作模式
                 CALL cl_init_qry_var()
                 #FUN-8A0004  q_vma02 --> q_vma03
                 #LET g_qryparam.form = "q_vma02"
                 #LET g_qryparam.default1 = g_vmc[l_ac].vmc03
                 #CALL cl_create_qry() RETURNING g_vmc[l_ac].vmc03
                 CALL q_vma03(FALSE,TRUE,g_vmc[l_ac].vmc03)
                      RETURNING  g_vmc[l_ac].vmc03,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[l_ac].vmc03
                 NEXT FIELD vmc03
            WHEN INFIELD(vmc04)     #工作模式
                 CALL cl_init_qry_var()
                 #FUN-8A0004  q_vma02 --> q_vma03
                 #LET g_qryparam.form = "q_vma02"
                 #LET g_qryparam.default1 = g_vmc[l_ac].vmc04
                 #CALL cl_create_qry() RETURNING g_vmc[l_ac].vmc04
                 CALL q_vma03(FALSE,TRUE,g_vmc[l_ac].vmc04)
                      RETURNING  g_vmc[l_ac].vmc04,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[l_ac].vmc04
                 NEXT FIELD vmc04
            WHEN INFIELD(vmc05)     #工作模式
                 CALL cl_init_qry_var()
                 #FUN-8A0004   q_vma02 --> q_vma03
                 #LET g_qryparam.form = "q_vma02"
                 #LET g_qryparam.default1 = g_vmc[l_ac].vmc05
                 #CALL cl_create_qry() RETURNING g_vmc[l_ac].vmc05
                 CALL q_vma03(FALSE,TRUE,g_vmc[l_ac].vmc05)
                      RETURNING  g_vmc[l_ac].vmc05,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[l_ac].vmc05
                 NEXT FIELD vmc05
            WHEN INFIELD(vmc06)     #工作模式
                 CALL cl_init_qry_var()
                 #FUN-8A0004   q_vma02 --> q_vma03
                 #LET g_qryparam.form = "q_vma02"
                 #LET g_qryparam.default1 = g_vmc[l_ac].vmc06
                 #CALL cl_create_qry() RETURNING g_vmc[l_ac].vmc06
                 CALL q_vma03(FALSE,TRUE,g_vmc[l_ac].vmc06)
                      RETURNING  g_vmc[l_ac].vmc06,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[l_ac].vmc06
                 NEXT FIELD vmc06
            WHEN INFIELD(vmc07)     #工作模式
                 CALL cl_init_qry_var()
                 #FUN-8A0004   q_vma02 --> q_vma03 
                 #LET g_qryparam.form = "q_vma02"
                 #LET g_qryparam.default1 = g_vmc[l_ac].vmc07
                 #CALL cl_create_qry() RETURNING g_vmc[l_ac].vmc07
                 CALL q_vma03(FALSE,TRUE,g_vmc[l_ac].vmc07)
                      RETURNING  g_vmc[l_ac].vmc07,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[l_ac].vmc07
                 NEXT FIELD vmc07
            WHEN INFIELD(vmc08)     #工作模式
                 CALL cl_init_qry_var()
                 #FUN-8A0004   q_vma02 --> q_vma03 
                 #LET g_qryparam.form = "q_vma02"
                 #LET g_qryparam.default1 = g_vmc[l_ac].vmc08
                 #CALL cl_create_qry() RETURNING g_vmc[l_ac].vmc08
                 CALL q_vma03(FALSE,TRUE,g_vmc[l_ac].vmc08)
                      RETURNING  g_vmc[l_ac].vmc08,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[l_ac].vmc08
                 NEXT FIELD vmc08
 
            OTHERWISE
                  EXIT CASE
          END CASE
 
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
 
    CLOSE i302_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i302_b_askkey()
    CLEAR FORM
    CALL g_vmc.clear()
    CONSTRUCT g_wc2 ON vmc01,
                       vmc02,
                       vmc03,
                       vmc04,
                       vmc05,
                       vmc06,
                       vmc07,
                       vmc08
            FROM s_vmc[1].vmc01,
                 s_vmc[1].vmc02,
                 s_vmc[1].vmc03,
                 s_vmc[1].vmc04,
                 s_vmc[1].vmc05,
                 s_vmc[1].vmc06,
                 s_vmc[1].vmc07,
                 s_vmc[1].vmc08
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
 
      #FUN-890130
      ON ACTION controlp
         CASE
            WHEN INFIELD(vmc02)
                 CALL cl_init_qry_var()
                 #FUN-8A0004   q_vma02 --> q_vma03
                 #LET g_qryparam.form ="q_vma02"
                 #CALL cl_create_qry() RETURNING g_vmc[1].vmc02
                 CALL q_vma03(FALSE,TRUE,' ')
                 RETURNING  g_vmc[1].vmc02,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[1].vmc02
                 NEXT FIELD vmc02
            WHEN INFIELD(vmc03)
                 CALL cl_init_qry_var()
                 #FUN-8A0004  q_vma02 --> q_vma03
                 #LET g_qryparam.form ="q_vma02"
                 #CALL cl_create_qry() RETURNING g_vmc[1].vmc03
                 CALL q_vma03(FALSE,TRUE,' ')
                      RETURNING  g_vmc[1].vmc03,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[1].vmc03
                 NEXT FIELD vmc03
            WHEN INFIELD(vmc04)
                 CALL cl_init_qry_var()
                 #FUN-8A0004   q_vma02 --> q_vma03
                 #LET g_qryparam.form ="q_vma02"
                 #CALL cl_create_qry() RETURNING g_vmc[1].vmc04
                 CALL q_vma03(FALSE,TRUE,' ')
                      RETURNING  g_vmc[1].vmc04,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[1].vmc04
                 NEXT FIELD vmc04
            WHEN INFIELD(vmc05)
                 CALL cl_init_qry_var()
                 #FUN-8A0004   q_vma02 --> q_vma03
                 #LET g_qryparam.form ="q_vma02"
                 #CALL cl_create_qry() RETURNING g_vmc[1].vmc05
                 CALL q_vma03(FALSE,TRUE,' ')
                      RETURNING  g_vmc[1].vmc05,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[1].vmc05
                 NEXT FIELD vmc05
            WHEN INFIELD(vmc06)
                 CALL cl_init_qry_var()
                 #FUN-8A0004    q_vma02 -> q_vma03
                 #LET g_qryparam.form ="q_vma02"
                 #CALL cl_create_qry() RETURNING g_vmc[1].vmc06
                 CALL q_vma03(FALSE,TRUE,' ')
                      RETURNING  g_vmc[1].vmc06,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[1].vmc06
                 NEXT FIELD vmc06
            WHEN INFIELD(vmc07)
                 CALL cl_init_qry_var()
                 #FUN-8A0004    q_vma02 --> q_vma03
                 #LET g_qryparam.form ="q_vma02"
                 #CALL cl_create_qry() RETURNING g_vmc[1].vmc07
                 CALL q_vma03(FALSE,TRUE,' ')
                      RETURNING  g_vmc[1].vmc07,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[1].vmc07
                 NEXT FIELD vmc07
            WHEN INFIELD(vmc08)
                 CALL cl_init_qry_var()
                 #FUN-8A0004    q_vma02  --> q_vma03
                 #LET g_qryparam.form ="q_vma02"
                 #CALL cl_create_qry() RETURNING g_vmc[1].vmc08
                 CALL q_vma03(FALSE,TRUE,' ')
                      RETURNING  g_vmc[1].vmc08,l_vma021,l_vma031,l_vma02,l_vma03
 
                 DISPLAY BY NAME g_vmc[1].vmc08
                 NEXT FIELD vmc08
 
            OTHERWISE
            EXIT CASE
          END CASE
 
 
 
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
    CALL i302_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i302_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)
 
    LET g_sql =
        "SELECT vmc01, ",
        " vmc02,vmc03,vmc04,vmc05,vmc06,vmc07,vmc08 ",
        "  FROM vmc_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1,2"
    PREPARE i302_pb FROM g_sql
    DECLARE vmc_file_curs CURSOR FOR i302_pb
 
    CALL g_vmc.clear()
    LET g_cnt = 1
    FOREACH vmc_file_curs INTO g_vmc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vmc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i302_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vmc TO s_vmc.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-570110--begin
FUNCTION i302_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("vmc01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i302_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("vmc01",FALSE)
   END IF
END FUNCTION
#No.FUN-570110--end
#Patch....NO.TQC-610036 <001> #
