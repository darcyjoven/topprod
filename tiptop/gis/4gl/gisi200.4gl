# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gisi200.4gl
# Descriptions...: 進項發票底稿維護作業
# Date & Author..: 02/03/25 By Danny
# Modify.........: No.FUN-4C0046 04/12/08 By Smapmin 加入權限控管
# Modify.........: No.FUN-550074 05/05/23 By Will 單據編號放大
# Modify ........: No.FUN-580006 05/08/17 By ice 有稅控時,發票代碼Required
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0020 06/10/16 By jamie 1.FUNCTION i200()_q 一開始應清空g_ise.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790001 07/09/02 By Mandy PK 問題
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/09 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980275 09/08/26 By Carrier ise08/ise08x/ise08t非負控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 11/12/29 By chenjing 增加數量欄位小數取位
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ise          RECORD  LIKE ise_file.*,
    g_ise_t        RECORD  LIKE ise_file.*,
    g_buf          LIKE type_file.chr20,        #NO.FUN-690009 VARCHAR(20)
     g_wc,g_sql     string,  #No.FUN-580092 HCN
    g_argv1	   LIKE ise_file.ise04
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
 
DEFINE   g_cnt      LIKE type_file.num10    #NO.FUN-690009 INTEGER 
DEFINE   g_msg      LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-690009 INTEGER
#CKP3
DEFINE   g_jump          LIKE type_file.num10         #NO.FUN-690009 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #NO.FUN-690009 SMALLINT
MAIN
    DEFINE
        l_sql           LIKE type_file.chr1000,      #NO.FUN-690009 VARCHAR(200)
        p_row,p_col     LIKE type_file.num5          #NO.FUN-690009 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0098
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1=ARG_VAL(1)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
    INITIALIZE g_ise.* TO NULL
    INITIALIZE g_ise_t.* TO NULL
 
    LET g_forupd_sql = "SELECT  * FROM ise_file WHERE ise01 = ? AND ise04 = ? AND ise05 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 4
    OPEN WINDOW i200_w AT p_row,p_col WITH FORM "gis/42f/gisi200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN CALL i200_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i200_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i200_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
END MAIN
 
FUNCTION i200_curs()
    IF cl_null(g_argv1) THEN
       CLEAR FORM
   INITIALIZE g_ise.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
	   ise00,ise07,ise01, ise03,ise02,
           ise06,ise061,ise062,  #No.TQC-980275
           ise08,ise08x,ise08t,
           ise051,ise052, ise04 ,ise05 ,
           ise11,ise12,ise13, ise09,ise18,ise14,
           ise15,ise16,ise10, ise17,
	   iseuser,isedate,isegrup,isemodu,isemodd
              #No.FUN-580031 --start--     HCN
           #FUN-840202   ---start---
           ,iseud01,iseud02,iseud03,iseud04,iseud05,
           iseud06,iseud07,iseud08,iseud09,iseud10,
           iseud11,iseud12,iseud13,iseud14,iseud15
           #FUN-840202    ----end----
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           IF INFIELD(ise06) THEN    #稅別
#             CALL q_gec(0,0,g_ise.ise06,'1') RETURNING g_ise.ise06
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gec"
              LET g_qryparam.default1 = g_ise.ise06
              LET g_qryparam.arg1 = '1'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ise06
              NEXT FIELD ise06
           END IF
           IF INFIELD(ise16) THEN    #單位
#             CALL q_gfe(0,0,g_ise.ise16) RETURNING g_ise.ise16
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = g_ise.ise16
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO g_ise.ise16
              NEXT FIELD ise16
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc=" ise04='",g_argv1,"'"
    END IF
 
    LET g_sql="SELECT ise01,ise04,ise05 FROM ise_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY 2,3,1 "
    PREPARE i200_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i200_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i200_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ise_file WHERE ",g_wc CLIPPED
    PREPARE i200_precount FROM g_sql
    DECLARE i200_count CURSOR FOR i200_precount
END FUNCTION
 
FUNCTION i200_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i200_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
        ON ACTION next
           CALL i200_fetch('N')
        ON ACTION previous
           CALL i200_fetch('P')
#       ON ACTION jump
#          CALL i200_fetch('/')
#       ON ACTION first
#          CALL i200_fetch('F')
#       ON ACTION last
#          CALL i200_fetch('L')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i200_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i200_r()
            END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
           #No.FUN-6A0009-------add--------str----
           ON ACTION related_document             #相關文件"                        
            LET g_action_choice="related_document"           
               IF cl_chk_act_auth() THEN                     
                  IF g_ise.ise01 IS NOT NULL THEN            
                     LET g_doc.column1 = "ise01"               
                     LET g_doc.column2 = "ise04" 
                     LET g_doc.column3 = "ise05"
                     LET g_doc.value1 = g_ise.ise01            
                     LET g_doc.value2 = g_ise.ise04
                     LET g_doc.value3 = g_ise.ise05
                     CALL cl_doc()                             
                  END IF                                        
               END IF                                           
            #No.FUN-6A0009-------add--------end----
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i200_cs
END FUNCTION
 
FUNCTION i200_a()
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_ise.* TO NULL
    LET g_ise_t.*=g_ise.*
    LET g_ise.ise00 = '1'      #人工
    LET g_ise.ise04 = ' '
    LET g_ise.ise05 = ' '
    LET g_ise.ise03 = g_today
    LET g_ise.ise07 = '0'      #未匯出
    LET g_ise.ise09 = g_today
    LET g_ise.ise12 = g_today
    LET g_ise.ise13 = 0
    LET g_ise.ise15 = 0
    LET g_ise.iseuser = g_user
    LET g_ise.iseoriu = g_user #FUN-980030
    LET g_ise.iseorig = g_grup #FUN-980030
    LET g_ise.isedate = g_today
    LET g_ise.isegrup = g_grup
    LET g_ise.iselegal= g_legal   #FUN-980011 add
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i200_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                      # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ise.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF cl_null(g_ise.ise01) THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        IF g_ise.ise04 IS NULL THEN LET g_ise.ise04 = ' ' END IF
       #TQC-790001--mod--str--
        IF g_ise.ise05 IS NULL THEN LET g_ise.ise05 = ' ' END IF
        IF cl_null(g_ise.ise05) THEN LET g_ise.ise05 = 0 END IF
       #TQC-790001--mod--end--
        INSERT INTO ise_file VALUES(g_ise.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ise.ise01,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("ins","ise_file",g_ise.ise01,g_ise.ise04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
           CONTINUE WHILE
        END IF
        SELECT ise01,ise04,ise05 INTO g_ise.ise01,g_ise.ise04,g_ise.ise05 FROM ise_file
         WHERE ise01 = g_ise.ise01 AND ise04 = g_ise.ise04
           AND ise05 = g_ise.ise05
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i200_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)
        l_n             LIKE type_file.num5     #NO.FUN-690009 SMALLINT 
 
    INPUT BY NAME g_ise.iseoriu,g_ise.iseorig,
	g_ise.ise00, g_ise.ise07,
        g_ise.ise01, g_ise.ise03, g_ise.ise02,
	g_ise.ise06, g_ise.ise061,g_ise.ise062,  #No.TQC-980275
	g_ise.ise08, g_ise.ise08x,g_ise.ise08t,
        g_ise.ise051,g_ise.ise052,
        g_ise.ise04, g_ise.ise05,
        g_ise.ise11, g_ise.ise12, g_ise.ise13,
	g_ise.ise09, g_ise.ise18, g_ise.ise14,
	g_ise.ise15, g_ise.ise16, g_ise.ise10, g_ise.ise17,
	g_ise.iseuser,g_ise.isedate,g_ise.isegrup,g_ise.isemodu,g_ise.isemodd
        #FUN-840202     ---start---
        ,g_ise.iseud01,g_ise.iseud02,g_ise.iseud03,g_ise.iseud04,
        g_ise.iseud05,g_ise.iseud06,g_ise.iseud07,g_ise.iseud08,
        g_ise.iseud09,g_ise.iseud10,g_ise.iseud11,g_ise.iseud12,
        g_ise.iseud13,g_ise.iseud14,g_ise.iseud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i200_set_entry(p_cmd)
            CALL i200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            #No.FUN-550074  --start
            CALL cl_set_docno_format("ise04")
            CALL cl_set_docno_format("ise11")
            #NO.Fun-550074  --end
 
        BEFORE FIELD ise00
            CALL i200_set_entry(p_cmd)
 
        AFTER FIELD ise00
            CALL i200_set_no_entry(p_cmd)
 
        AFTER FIELD ise01
            IF NOT cl_null(g_ise.ise01) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_ise.ise01 != g_ise_t.ise01) THEN
                  SELECT COUNT(*) INTO l_n FROM ise_file
                   WHERE ise01 = g_ise.ise01
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_ise.ise01,-239,0)
                     LET g_ise.ise01 = g_ise_t.ise01
                     DISPLAY BY NAME g_ise.ise01
                     NEXT FIELD ise01
                  END IF
               END IF
            END IF
 
        AFTER FIELD ise02
            IF g_ise.ise062 MATCHES '[sSnN]' AND cl_null(g_ise.ise02) THEN
               NEXT FIELD ise02
            END IF
            #No.FUN-580006 --start--
            IF cl_null(g_ise.ise02) AND g_aza.aza46 = 'Y'THEN
               CALL cl_err('','gap-142',0)
               NEXT FIELD ise02
            END IF
            #No.FUN-580006 --end--
 
        AFTER FIELD ise051
            IF NOT cl_null(g_ise.ise051) THEN
               IF g_ise_t.ise051 IS NULL OR g_ise.ise051 != g_ise_t.ise051 THEN
                  SELECT apl02 INTO g_ise.ise052 FROM apl_file
                   WHERE apl01 = g_ise.ise051
                  DISPLAY BY NAME g_ise.ise052
               END IF
            END IF
 
        AFTER FIELD ise06
            IF NOT cl_null(g_ise.ise06) THEN
               IF g_ise_t.ise06 IS NULL OR g_ise.ise06 != g_ise_t.ise06 THEN
                  CALL i200_ise06('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_ise.ise06,g_errno,0) NEXT FIELD ise06
                  END IF
               END IF
            END IF
 
        BEFORE FIELD ise062
            CALL i200_set_entry(p_cmd)
 
        AFTER FIELD ise062
            IF g_ise.ise062 MATCHES '[SN]' AND cl_null(g_ise.ise02) THEN
               NEXT FIELD ise02
            END IF
            IF g_ise.ise062 = 'G' AND cl_null(g_ise.ise15) THEN
               NEXT FIELD ise15
            END IF
            IF g_ise.ise062 = 'G' AND cl_null(g_ise.ise16) THEN
               NEXT FIELD ise16
            END IF
            IF g_ise.ise062 != 'G' THEN
               LET g_ise.ise15 = ''
               LET g_ise.ise16 = ''
               DISPLAY BY NAME g_ise.ise15,g_ise.ise16
            END IF
            CALL i200_set_no_entry(p_cmd)
 
        AFTER FIELD ise08
            IF NOT cl_null(g_ise.ise08) THEN
               #No.TQC-980275  --Begin
               IF g_ise.ise08 < 0 THEN
                  CALL cl_err(g_ise.ise08,'axm-179',0)
                  NEXT FIELD ise08
               END IF  
               #No.TQC-980275  --End  
               LET g_ise.ise08x = g_ise.ise08 * g_ise.ise061 /100
               LET g_ise.ise08x = cl_digcut(g_ise.ise08x,t_azi04)
               LET g_ise.ise08t = g_ise.ise08 + g_ise.ise08x
               DISPLAY BY NAME g_ise.ise08x,g_ise.ise08t
            END IF
 
        #No.TQC-980275  --Begin
        AFTER FIELD ise08x
           IF NOT cl_null(g_ise.ise08x) THEN
              IF g_ise.ise08x < 0 THEN
                 CALL cl_err(g_ise.ise08x,'axm-179',0)
                 NEXT FIELD ise08x
              END IF  
           END IF
 
        AFTER FIELD ise08t
           IF NOT cl_null(g_ise.ise08t) THEN
              IF g_ise.ise08t < 0 THEN
                 CALL cl_err(g_ise.ise08t,'axm-179',0)
                 NEXT FIELD ise08t
              END IF  
           END IF
        #No.TQC-980275  --End  
 
        AFTER FIELD ise09
            IF g_ise.ise062 MATCHES '[SN]' AND cl_null(g_ise.ise09) THEN
               NEXT FIELD ise09
            END IF
 
        AFTER FIELD ise10
            IF g_ise.ise062 MATCHES '[SNG]' AND cl_null(g_ise.ise10) THEN
               NEXT FIELD ise10
            END IF
 
        AFTER FIELD ise11
            IF g_ise.ise062 MATCHES '[SN]' AND cl_null(g_ise.ise11) THEN
               NEXT FIELD ise11
            END IF
 
        AFTER FIELD ise12
            IF g_ise.ise062 MATCHES '[SN]' AND cl_null(g_ise.ise12) THEN
               NEXT FIELD ise12
            END IF
 
        AFTER FIELD ise13
            IF g_ise.ise062 MATCHES '[SN]' AND cl_null(g_ise.ise13) THEN
               NEXT FIELD ise13
            END IF
 
 
        AFTER FIELD ise15
            IF g_ise.ise062 = 'G' AND cl_null(g_ise.ise15) THEN
               NEXT FIELD ise15
            END IF
            LET g_ise.ise15 = s_digqty(g_ise.ise15,g_ise.ise16)    #FUN-910088--add--
            DISPLAY BY NAME g_ise.ise15                            #FUN-910088--add--
        AFTER FIELD ise16
            IF g_ise.ise062 = 'G' AND cl_null(g_ise.ise16) THEN
               NEXT FIELD ise16
            END IF
            IF NOT cl_null(g_ise.ise16) THEN
               SELECT gfe01 FROM gfe_file
                WHERE gfe01 = g_ise.ise16 AND gfeacti = 'Y'
               IF STATUS THEN
#                 CALL cl_err(g_ise.ise16,'aoo-012',0)   #No.FUN-660146
                  CALL cl_err3("sel","gfe_file",g_ise.ise16,"","aoo-012","","",1)  #No.FUN-660146
                  NEXT FIELD ise16 
               END IF
               LET g_ise.ise15 = s_digqty(g_ise.ise15,g_ise.ise16)    #FUN-910088--add--
               DISPLAY BY NAME g_ise.ise15                            #FUN-910088--add--
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD iseud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD iseud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        AFTER INPUT
           LET g_ise.iseuser = s_get_data_owner("ise_file") #FUN-C10039
           LET g_ise.isegrup = s_get_data_group("ise_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            #No.FUN-580006 --start--
            IF cl_null(g_ise.ise02) AND g_aza.aza46 = 'Y'THEN
               CALL cl_err('','gap-142',0)
               NEXT FIELD ise02
            END IF
            #No.FUN-580006 --end--
 
        ON ACTION controlp
           IF INFIELD(ise06) THEN    #稅別
#             CALL q_gec(0,0,g_ise.ise06,'1') RETURNING g_ise.ise06
#             CALL FGL_DIALOG_SETBUFFER( g_ise.ise06 )
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gec"
              LET g_qryparam.default1 = g_ise.ise06
              LET g_qryparam.arg1 = '1'
              CALL cl_create_qry() RETURNING g_ise.ise06
#              CALL FGL_DIALOG_SETBUFFER( g_ise.ise06 )
              DISPLAY BY NAME g_ise.ise06
              NEXT FIELD ise06
           END IF
           IF INFIELD(ise16) THEN    #單位
#             CALL q_gfe(0,0,g_ise.ise16) RETURNING g_ise.ise16
#             CALL FGL_DIALOG_SETBUFFER( g_ise.ise16 )
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = g_ise.ise16
              CALL cl_create_qry() RETURNING g_ise.ise16
#              CALL FGL_DIALOG_SETBUFFER( g_ise.ise16 )
              DISPLAY BY NAME g_ise.ise16
              NEXT FIELD ise16
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
 
FUNCTION i200_ise06(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1          #NO.FUN-690009 VARCHAR(1)
    DEFINE l_gec04   LIKE gec_file.gec04
    DEFINE l_gec05   LIKE gec_file.gec05
    DEFINE l_gec06   LIKE gec_file.gec06
    DEFINE l_gecacti LIKE gec_file.gecacti
 
    SELECT gec04,gec05,gec06,gecacti
      INTO l_gec04,l_gec05,l_gec06,l_gecacti
      FROM gec_file
     WHERE gec01 = g_ise.ise06 AND gec011='1'  #進項
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
         WHEN l_gecacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET g_ise.ise061 = l_gec04
    LET g_ise.ise062 = l_gec05     #發票種類
    DISPLAY BY NAME g_ise.ise061,g_ise.ise062
END FUNCTION
 
FUNCTION i200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ise.* TO NULL             #No.FUN-6A0009
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i200_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLEAR FORM RETURN
    END IF
    OPEN i200_count
    FETCH i200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ise.ise01,SQLCA.sqlcode,0)
        INITIALIZE g_ise.* TO NULL
    ELSE
        CALL i200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i200_fetch(p_flise)
    DEFINE
        p_flise         LIKE type_file.chr1,     #NO.FUN-690009 VARCHAR(1)
        l_abso          LIKE type_file.num10     #NO.FUN-690009 INTEGER
 
    CASE p_flise
        WHEN 'N' FETCH NEXT     i200_cs INTO g_ise.ise01,g_ise.ise04,
                                             g_ise.ise05
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_ise.ise01,g_ise.ise04,
                                             g_ise.ise05
        WHEN 'F' FETCH FIRST    i200_cs INTO g_ise.ise01,g_ise.ise04,
                                             g_ise.ise05
        WHEN 'L' FETCH LAST     i200_cs INTO g_ise.ise01,g_ise.ise04,
                                             g_ise.ise05
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i200_cs INTO g_ise.ise01,g_ise.ise04,
                                             g_ise.ise05
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ise.ise01,SQLCA.sqlcode,0)
       INITIALIZE g_ise.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flise
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_ise.* FROM ise_file WHERE ise01 = g_ise.ise01 AND ise04 = g_ise.ise04 AND ise05 = g_ise.ise05
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ise.ise01,SQLCA.sqlcode,0)   #No.FUN-660146
       CALL cl_err3("sel","ise_file",g_ise.ise01,g_ise.ise04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
    ELSE
       LET g_data_owner = g_ise.iseuser  #FUN-4C0046
       LET g_data_group = g_ise.isegrup  #FUN-4C0046
       CALL i200_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i200_show()
    DISPLAY BY NAME g_ise.iseoriu,g_ise.iseorig,
	g_ise.ise00, g_ise.ise01, g_ise.ise02, g_ise.ise03,
        g_ise.ise04, g_ise.ise05, g_ise.ise051,g_ise.ise052,
	g_ise.ise06, g_ise.ise061,g_ise.ise062,
	g_ise.ise08, g_ise.ise08x,g_ise.ise08t,
	g_ise.ise09, g_ise.ise10, g_ise.ise11, g_ise.ise12,
	g_ise.ise13, g_ise.ise18, g_ise.ise19, g_ise.ise14,
	g_ise.ise15, g_ise.ise16, g_ise.ise07, g_ise.ise17,
	g_ise.iseuser,g_ise.isedate,g_ise.isegrup,g_ise.isemodu,g_ise.isemodd
        #FUN-840202     ---start---
       ,g_ise.iseud01,g_ise.iseud02,g_ise.iseud03,g_ise.iseud04,
        g_ise.iseud05,g_ise.iseud06,g_ise.iseud07,g_ise.iseud08,
        g_ise.iseud09,g_ise.iseud10,g_ise.iseud11,g_ise.iseud12,
        g_ise.iseud13,g_ise.iseud14,g_ise.iseud15 
        #FUN-840202     ----end----
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i200_u()
    IF cl_null(g_ise.ise01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ise.* FROM ise_file
     WHERE ise01 = g_ise.ise01 AND ise04 = g_ise.ise04 AND ise05 = g_ise.ise05
    IF g_ise.ise07 = '1' THEN RETURN END IF     #已匯出
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ise_t.* = g_ise.*
    BEGIN WORK
    LET g_success = 'Y'
 
    OPEN i200_cl USING g_ise.ise01,g_ise.ise04,g_ise.ise05
 
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_ise.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ise.ise01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
    END IF
    CALL i200_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ise.isemodu = g_user
        LET g_ise.isemodd = g_today
        CALL i200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ise.*=g_ise_t.*
            CALL i200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ise_file SET * = g_ise.*
         WHERE ise01 = g_ise_t.ise01 AND ise04 = g_ise_t.ise04 AND ise05 = g_ise_t.ise05 # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ise.ise01,SQLCA.sqlcode,0)   #No.FUN-660146
           CALL cl_err3("upd","ise_file",g_ise_t.ise01,g_ise_t.ise04,SQLCA.sqlcode,"","",1)  #No.FUN-660146
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i200_cl
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION i200_r()
    IF cl_null(g_ise.ise01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ise.* FROM ise_file
     WHERE ise01 = g_ise.ise01 AND ise04 = g_ise.ise04 AND ise05 = g_ise.ise05
    IF g_ise.ise07 = '1' THEN RETURN END IF    #已匯出
    BEGIN WORK
 
    OPEN i200_cl USING g_ise.ise01,g_ise.ise04,g_ise.ise05
 
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_ise.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ise.ise01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
    END IF
    CALL i200_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ise01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ise04"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "ise05"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ise.ise01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ise.ise04      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_ise.ise05      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       IF g_ise.ise00 = '0' THEN
          DELETE FROM ise_file WHERE ise01 = g_ise.ise01
                                 AND ise04 = g_ise.ise04
                                 AND ise05 = g_ise.ise05
       ELSE
          DELETE FROM ise_file WHERE ise01 = g_ise.ise01
       END IF
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980011 add
          VALUES ('gisi200',g_user,g_today,g_msg,g_ise.ise01,'delete',g_plant,g_legal) #FUN-980011 add
       CLEAR FORM
       INITIALIZE g_ise.* TO NULL
       MESSAGE ""
       CLEAR FORM
         #CKP3
         OPEN i200_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE i200_count
            CLOSE i200_cl
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         FETCH i200_count INTO g_row_count
#FUN-B50065------begin---
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i200_count
            CLOSE i200_cl
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i200_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i200_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i200_fetch('/')
         END IF
    END IF
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #NO.FUN-690009 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ise01",TRUE)
   END IF
   IF INFIELD(ise00) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ise04,ise05,ise06,ise08,ise08x,ise08t",TRUE)
   END IF
   IF INFIELD(ise062) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ise15,ise16",TRUE)
   END IF
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #NO.FUN-690009 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ise01",FALSE)
   END IF
   IF INFIELD(ise00) OR (NOT g_before_input_done) THEN
      IF (g_ise.ise00 = '0') THEN
         CALL cl_set_comp_entry("ise04,ise05,ise06,ise08,ise08x,ise08t",FALSE)
      END IF
   END IF
   IF INFIELD(ise062) OR (NOT g_before_input_done) THEN
      IF g_ise.ise062 != 'G' THEN
        CALL cl_set_comp_entry("ise15,ise16",FALSE)
      END IF
   END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #


