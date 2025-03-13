# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: axci050.4gl
# Descriptions...: 成本項目分攤係數設定作業
# Date & Author..: 01/11/20 BY DS/P
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
#
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-570376 05/08/02 By Claire  修正原prompt以cl_err表示
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660160 06/06/23 By Sarah # Modify.........: No.FUN-660160 06/06/23 By Sarah 根據參數(ccz06)決定cac01開窗為'部門代號'或'作業編號'或'工作中心'
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.MOD-870035 08/07/16 By Pengu 無任何資料的情況下查詢點選成本中心開窗查詢程式就會自動關閉
# Modify.........: No.TQC-970159 09/07/20 By destiny 增加成本中心的管控
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cac           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
              cac01   LIKE  cac_file.cac01,
              cac02   LIKE  cac_file.cac02,
              cab02   LIKE  cab_file.cab02,
              cac03   LIKE  cac_file.cac03
                    END RECORD,
    g_cac_t         RECORD                 #程式變數 (舊值)
              cac01   LIKE  cac_file.cac01,
              cac02   LIKE  cac_file.cac02,
              cab02   LIKE  cab_file.cab02,
              cac03   LIKE  cac_file.cac03
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-57011        #No.FUN-680122 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i050_w AT p_row,p_col WITH FORM "axc/42f/axci050"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i050_b_fill(g_wc2)
    #No:A088
    CALL i050_menu()
    ##
    CLOSE WINDOW i050_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i050_menu()
 
   WHILE TRUE
      CALL i050_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i050_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i050_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0015
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cac),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
#No:A088
##
FUNCTION i050_q()
   CALL i050_b_askkey()
END FUNCTION
 
FUNCTION i050_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                                   #No.FUN-680122 VARCHAR(1) 
    l_allow_delete  LIKE type_file.chr1                                    #No.FUN-680122 VARCHAR(1) 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT cac01,cac02,'',cac03 FROM cac_file WHERE cac01=?  AND cac02=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i050_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_cac WITHOUT DEFAULTS FROM s_cac.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
               LET p_cmd='u'
               LET g_cac_t.* = g_cac[l_ac].*  #BACKUP
#No.FUN-570110--begin
               LET g_before_input_done = FALSE
               CALL i050_set_entry_b(p_cmd)
               CALL i050_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110--end
               BEGIN WORK
 
               OPEN i050_bcl USING g_cac_t.cac01,g_cac_t.cac02
               IF STATUS THEN
                  CALL cl_err("OPEN i050_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i050_bcl INTO g_cac[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_cac_t.cac01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               IF l_ac <= l_n THEN                    #DISPLAY NEWEST
                  CALL i050_cac02(g_cac[l_ac].cac02) RETURNING g_cac[l_ac].cab02
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i050_set_entry_b(p_cmd)
            CALL i050_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end
            INITIALIZE g_cac[l_ac].* TO NULL      #900423
            LET g_cac_t.* = g_cac[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cac01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
#           CALL g_cac.deleteElement(l_ac)   # 重要
#           IF g_rec_b != 0 THEN
#             LET g_action_choice = "detail"
#           END IF
#           EXIT INPUT
         END IF
         INSERT INTO cac_file(cac01,cac02,cac03)
         VALUES(g_cac[l_ac].cac01,g_cac[l_ac].cac02,
                g_cac[l_ac].cac03)
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_cac[l_ac].cac01,SQLCA.sqlcode,0)   #No.FUN-660127
             CALL cl_err3("ins","cac_file",g_cac[l_ac].cac01,g_cac[l_ac].cac02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
        #No.TQC-970159--begin 
        AFTER FIELD cac01                                   
            IF NOT cl_null(g_cac[l_ac].cac01) THEN 
               CASE g_ccz.ccz06
                  WHEN '3'
                     SELECT COUNT(*) INTO g_cnt
                       FROM ecd_file
                      WHERE ecd01 = g_cac[l_ac].cac01
                        AND ecdacti='Y'
                  WHEN '4'
                     SELECT COUNT(*) INTO g_cnt
                       FROM eca_file
                      WHERE eca01 = g_cac[l_ac].cac01
                        AND ecaacti='Y'
                  OTHERWISE
                     SELECT COUNT(*) INTO g_cnt
                       FROM gem_file
                      WHERE gem01 = g_cac[l_ac].cac01
                        AND gemacti='Y'
               END CASE
               IF g_cnt=0 THEN 
                  CALL cl_err("","mfg1318" , 1) 
                  LET g_cac[l_ac].cac01=g_cac_t.cac01
                  NEXT FIELD cac01                   
               END IF                
            END IF 
            IF NOT cl_null(g_cac[l_ac].cac01) AND NOT cl_null(g_cac[l_ac].cac02) THEN
               IF g_cac[l_ac].cac01 !=g_cac_t.cac01 OR g_cac_t.cac01 IS NULL THEN 
                  SELECT COUNT(*) INTO g_cnt FROM caa_file
                   WHERE caa01=g_cac[l_ac].cac01 AND caa02=g_cac[l_ac].cac02
                   IF g_cnt=0 THEN
                      CALL cl_err('','axc-195',1)
                      NEXT FIELD cac01
                   END IF  
               END IF 
            END IF   
        #No.TQC-970159--end 
        AFTER FIELD cac02
            IF NOT cl_null(g_cac[l_ac].cac02) AND NOT cl_null(g_cac[l_ac].cac01 ) THEN
               IF g_cac[l_ac].cac02 !=g_cac_t.cac02 OR
                 (g_cac[l_ac].cac02 IS NOT NULL AND g_cac_t.cac02 IS NULL) THEN
                  SELECT COUNT(*) INTO g_cnt FROM cac_file
                  WHERE cac01 = g_cac[l_ac].cac01
                    AND cac02 = g_cac[l_ac].cac02
                  IF g_cnt != 0 THEN
                     LET SQLCA.SQLCODE=-239
                     CALL cl_err('',SQLCA.SQLCODE,1)
                     LET g_cac[l_ac].cac01 = g_cac_t.cac01
                     NEXT FIELD cac01
                  END IF
               END IF
               CALL i050_cac02(g_cac[l_ac].cac02) RETURNING g_cac[l_ac].cab02
 
               SELECT COUNT(*) INTO g_cnt FROM caa_file
                WHERE caa01=g_cac[l_ac].cac01 AND caa02=g_cac[l_ac].cac02
 
 #---MOD-570376 ----------------
              IF g_cnt=0 THEN
                 CALL cl_err('','axc-195',1)
                 NEXT FIELD cac02
              END IF
 #---MOD-570376 ----------------
#               IF g_cnt=0 THEN LET g_msg='此成本中心不分攤此項目' CLIPPED
#            LET INT_FLAG = 0  ######add for prompt bug
#                  PROMPT g_msg FOR g_chr
#                     ON IDLE g_idle_seconds
#                        CALL cl_on_idle()
##                        CONTINUE PROMPT
 
 #     ON ACTION about         #MOD-4C0121
 #        CALL cl_about()      #MOD-4C0121
 
 #     ON ACTION help          #MOD-4C0121
 #        CALL cl_show_help()  #MOD-4C0121
 
 #     ON ACTION controlg      #MOD-4C0121
 #        CALL cl_cmdask()     #MOD-4C0121
 
 
#                  END PROMPT
#                  NEXT FIELD cac02
#               END IF
 #---MOD-570376 ---------------- 取消prompt寫法
            END IF
 
        BEFORE DELETE                            #是否取消單身
             IF g_cac_t.cac01 IS NOT NULL AND g_cac_t.cac02 IS NOT NULL THEN
                IF g_cnt = 0 THEN
                   IF NOT cl_delete() THEN
                      CANCEL DELETE
                   END IF
 
                   IF l_lock_sw = "Y" THEN
                      CALL cl_err("", -263, 1)
                      CANCEL DELETE
                   END IF
 
                   DELETE FROM cac_file WHERE cac01 = g_cac_t.cac01
                                          AND cac02 = g_cac_t.cac02
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_cac_t.cac01,SQLCA.sqlcode,0)   #No.FUN-660127
                      CALL cl_err3("del","cac_file",g_cac_t.cac01,g_cac_t.cac02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
 
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   MESSAGE "Delete OK"
                   CLOSE i050_bcl
                   COMMIT WORK
                END IF
             END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_cac[l_ac].* = g_cac_t.*
              CLOSE i050_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_cac[l_ac].cac01,-263,1)
              LET g_cac[l_ac].* = g_cac_t.*
           ELSE
                        UPDATE cac_file SET cac01= g_cac[l_ac].cac01,
                                            cac02= g_cac[l_ac].cac02,
                                            cac03= g_cac[l_ac].cac03
                         WHERE CURRENT OF i050_bcl
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_cac[l_ac].cac01,SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","cac_file",g_cac_t.cac01,g_cac_t.cac02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                  LET g_cac[l_ac].* = g_cac_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i050_bcl
                  COMMIT WORK
              END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_cac[l_ac].* = g_cac_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_cac.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE i050_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i050_bcl
            COMMIT WORK
 
       ON ACTION controlp
           CASE WHEN INFIELD(cac01)
                  #CALL q_gem(10,3,g_cac[l_ac].cac01) RETURNING g_cac[l_ac].cac01
                  #CALL FGL_DIALOG_SETBUFFER( g_cac[l_ac].cac01 )
                  #start FUN-660160 modify
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_gem"
                  #LET g_qryparam.default1 = g_cac[l_ac].cac01
                  #CALL cl_create_qry() RETURNING g_cac[l_ac].cac01
                   CASE g_ccz.ccz06
                      WHEN '3'
                         CALL q_ecd(FALSE,TRUE,g_cac[l_ac].cac01)
                              RETURNING g_cac[l_ac].cac01
                      WHEN '4'
                         CALL q_eca(FALSE,TRUE,g_cac[l_ac].cac01)
                              RETURNING g_cac[l_ac].cac01
                      OTHERWISE
                         CALL cl_init_qry_var()
                         LET g_qryparam.form     ="q_gem"
                         LET g_qryparam.default1 = g_cac[l_ac].cac01
                         CALL cl_create_qry() RETURNING g_cac[l_ac].cac01
                   END CASE
                  #end FUN-660160 modify
                   DISPLAY g_cac[l_ac].cac01 TO cac01
                 #  CALL FGL_DIALOG_SETBUFFER( g_cac[l_ac].cac01 )
                WHEN INFIELD(cac02)
                  #CALL q_cab(10,3,g_cac[l_ac].cac02) RETURNING g_cac[l_ac].cac02
                  #CALL FGL_DIALOG_SETBUFFER( g_cac[l_ac].cac02 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_cab"
                   LET g_qryparam.default1 = g_cac[l_ac].cac02
                   CALL cl_create_qry() RETURNING g_cac[l_ac].cac02
                   DISPLAY g_cac[l_ac].cac01 TO cac02
                  # CALL FGL_DIALOG_SETBUFFER( g_cac[l_ac].cac02 )
                OTHERWISE   EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i050_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cac01) AND l_ac > 1 THEN
                LET g_cac[l_ac].* = g_cac[l_ac-1].*
                NEXT FIELD cac01
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
 
    CLOSE i050_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i050_b_askkey()
    CLEAR FORM
    CALL g_cac.clear()
    CONSTRUCT g_wc2 ON cac01,cac02,cac03
            FROM s_cac[1].cac01,s_cac[1].cac02,s_cac[1].cac03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
           
       ON ACTION controlp
      CASE WHEN INFIELD(cac01)
                  #start FUN-660160 modify
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_gem"
                  #LET g_qryparam.state    = "c"
                  #LET g_qryparam.default1 = g_cac[l_ac].cac01
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CASE g_ccz.ccz06
                      WHEN '3'
                         CALL q_ecd(TRUE,TRUE,g_cac[1].cac01)    #No.MOD-870035 modify
                              RETURNING g_qryparam.multiret
                      WHEN '4'
                         CALL q_eca(TRUE,TRUE,g_cac[1].cac01)    #No.MOD-870035 modify
                              RETURNING g_qryparam.multiret
                      OTHERWISE
                         CALL cl_init_qry_var()
                         LET g_qryparam.form     ="q_gem"
                         LET g_qryparam.state    = "c"
                        #LET g_qryparam.default1 = g_cac[l_ac].cac01    #No.MOD-870035 mark
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                   END CASE
                  #end FUN-660160 modify
                   DISPLAY g_qryparam.multiret TO s_cac[1].cac01
                WHEN INFIELD(cac02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_cab"
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.default1 = g_cac[1].cac02
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_cac[1].cac02
                OTHERWISE   EXIT CASE
            END CASE
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
    CALL i050_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i050_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200) 
 
    LET g_sql =
        "SELECT cac01,cac02,cab02,cac03 ",
        " FROM cac_file,cab_file ",
        " WHERE cac02=cab01 AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i050_pb FROM g_sql
    DECLARE cac_curs CURSOR FOR i050_pb
 
    CALL g_cac.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH cac_curs INTO g_cac[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_cac.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i050_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cac TO s_cac.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i050_cac02(p_cac02)
  DEFINE p_cac02  LIKE cac_file.cac02
  DEFINE l_desc   LIKE cab_file.cab02
 
  LET l_desc=''
  SELECT cab02 INTO l_desc FROM cab_file
   WHERE cab01=p_cac02
  RETURN l_desc
END FUNCTION
#No.FUN-570110--begin
FUNCTION i050_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("cac01,cac02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i050_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("cac01,cac02",FALSE)
   END IF
END FUNCTION
#No.FUN-570110--end
#Patch....NO.TQC-610037 <001> #
