# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci601.4gl
# Descriptions...: 正常工作站成本維護作業
# Date & Author..: 92/03/18 By DAVID
# Modify.........: 92/03/19 By Pin
# Modify.........: 92/08/28 By Keith
# Source.........: From aeci600.4gl 's  Function aeci601
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_eca   RECORD LIKE eca_file.*,
    g_eca_t RECORD LIKE eca_file.*,
    g_eca_o RECORD LIKE eca_file.*,
    g_eca01_t LIKE eca_file.eca01,
    g_eca02   LIKE eca_file.eca02,
    g_flag              LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    p_row,p_col         LIKE type_file.num5,          #No.FUN-680073 SMALLINT SMALLINT
    g_wc,g_sql          STRING                        #No.FUN-580092 HCN  
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL 
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680073
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0100
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
    INITIALIZE g_eca.* TO NULL
    INITIALIZE g_eca_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM eca_file WHERE eca01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i601_w AT p_row,p_col WITH FORM "aec/42f/aeci601"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_eca.eca01 = ARG_VAL(1)
    LET g_eca02     = ARG_VAL(2)
    IF g_eca.eca01 IS NOT NULL AND  g_eca.eca01 != ' '
       THEN LET g_flag = 'Y'
        CALL i601_q()
	    CALL i601_u()
       ELSE LET g_flag = 'N'
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i601_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i601_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i601_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = "eca01='",g_eca.eca01,"'"
    ELSE
   INITIALIZE g_eca.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           eca01,eca02,eca04,eca06
 
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
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND ecauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND ecagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ecagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ecauser', 'ecagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT eca01 FROM eca_file ", # 組合出 SQL 指令
            " WHERE ",g_wc CLIPPED,
			" AND eca04 ='0' ", "ORDER BY eca01"
    PREPARE i601_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i601_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i601_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM eca_file WHERE ",g_wc CLIPPED
    PREPARE i601_precount FROM g_sql
    DECLARE i601_count CURSOR FOR i601_precount
END FUNCTION
 
FUNCTION i601_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i601_q()
            END IF
        ON ACTION next
            CALL i601_fetch('N')
        ON ACTION previous
            CALL i601_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i601_u()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
            CALL i601_fetch('/')
        ON ACTION first
            CALL i601_fetch('F')
        ON ACTION last
            CALL i601_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0039-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_eca.eca01 IS NOT NULL THEN
                  LET g_doc.column1 = "eca01"
                  LET g_doc.value1 = g_eca.eca01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0039-------add--------end----
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i601_cs
END FUNCTION
 
 
FUNCTION i601_i(p_cmd)
    DEFINE
           l_msg LIKE type_file.chr8,     # No.FUN-680073 CHA(8)
           p_cmd LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1)
           l_sw  LIKE type_file.chr1      #No.FUN-680073 VARCHAR(1)  #重要欄位輸入否
 
    DISPLAY BY NAME g_eca.eca01, g_eca.eca02, g_eca.eca04, g_eca.eca06
 
{
    CALL cl_getmsg('mfg4004',g_lang) RETURNING l_msg
    DISPLAY l_msg TO FORMONLY.d01
}
    INPUT BY NAME g_eca.eca01, g_eca.eca02, g_eca.eca04, g_eca.eca06,
                  g_eca.eca14, g_eca.eca15, g_eca.eca16, g_eca.eca17,
                  g_eca.eca26, g_eca.eca27, g_eca.eca18, g_eca.eca19,
                  g_eca.eca28, g_eca.eca29,
                  g_eca.eca20, g_eca.eca21, g_eca.eca30, g_eca.eca31,
                  g_eca.eca201,g_eca.eca211,g_eca.eca301,g_eca.eca311,
                  g_eca.eca22, g_eca.eca23, g_eca.eca32, g_eca.eca33,
                  g_eca.eca24, g_eca.eca25,
                  g_eca.eca34, g_eca.eca35  WITHOUT DEFAULTS
 
	AFTER FIELD eca14
	    IF g_eca.eca14 NOT MATCHES'[12]' THEN
		LET g_eca.eca14 = g_eca_o.eca14
		DISPLAY BY NAME g_eca.eca14
		NEXT FIELD eca14
	    END IF
            LET g_eca_o.eca14 = g_eca.eca14
 
	AFTER FIELD eca15
          IF g_eca.eca15 IS NOT NULL THEN
            IF (g_eca.eca06 = '1' AND g_eca.eca15 NOT MATCHES'[3-6]') OR
               (g_eca.eca06 = '2' AND g_eca.eca15 NOT MATCHES'[1256]') THEN
                CALL cl_err(g_eca.eca15,'mfg4122',0)
		LET g_eca.eca15 = g_eca_o.eca15
		DISPLAY BY NAME g_eca.eca15
		NEXT FIELD eca15
	    END IF
            LET g_eca_o.eca15 = g_eca.eca15
	  END IF
 
   	AFTER FIELD eca16
	    IF g_eca.eca16 IS NULL THEN
               IF g_eca_o.eca16 IS NULL THEN
                  LET g_eca.eca16 = 0
               ELSE
		  LET g_eca.eca16 = g_eca_o.eca16
               END IF
		DISPLAY BY NAME g_eca.eca16
		NEXT FIELD eca16
	    END IF
            LET g_eca_o.eca16 = g_eca.eca16
 
   	AFTER FIELD eca17
	    IF g_eca.eca17 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca17
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca17,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca17,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca17 = g_eca_o.eca17
                    DISPLAY BY NAME g_eca.eca17
		    NEXT FIELD eca17
		END IF
                LET g_eca_o.eca17 = g_eca.eca17
	    END IF
 
	BEFORE FIELD eca26
	    IF g_eca.eca26 IS NULL OR g_eca.eca26 =0 THEN
               LET g_eca.eca26 = g_eca.eca16
            END IF
	    IF g_eca.eca27 IS NULL OR g_eca.eca27 =0 THEN
               LET g_eca.eca27 = g_eca.eca17
            END IF
	    IF g_eca.eca28 IS NULL OR g_eca.eca28 =0 THEN
               LET g_eca.eca28 = g_eca.eca18
            END IF
	    IF g_eca.eca29 IS NULL OR g_eca.eca29 =0 THEN
               LET g_eca.eca29 = g_eca.eca19
            END IF
	    IF g_eca.eca30 IS NULL OR g_eca.eca30 =0 THEN
               LET g_eca.eca30 = g_eca.eca20
            END IF
	    IF g_eca.eca31 IS NULL OR g_eca.eca31 =0 THEN
                LET g_eca.eca31 = g_eca.eca21
            END IF
	    IF g_eca.eca301 IS NULL OR g_eca.eca301 =0 THEN
                LET g_eca.eca301 = g_eca.eca201
            END IF
	    IF g_eca.eca32 IS NULL OR g_eca.eca32 =0 THEN
                LET g_eca.eca32 = g_eca.eca22
            END IF
	    IF g_eca.eca33 IS NULL OR g_eca.eca33 =0 THEN
                LET g_eca.eca33 = g_eca.eca23
            END IF
	    IF g_eca.eca34 IS NULL OR g_eca.eca34 =0 THEN
                LET g_eca.eca34 = g_eca.eca24
            END IF
	    IF g_eca.eca35 IS NULL OR g_eca.eca35 =0 THEN
                LET g_eca.eca35 = g_eca.eca25
            END IF
	    DISPLAY BY NAME g_eca.eca26, g_eca.eca27, g_eca.eca28,
			    g_eca.eca29, g_eca.eca30, g_eca.eca31, g_eca.eca301,
                            g_eca.eca32, g_eca.eca33, g_eca.eca34, g_eca.eca35
 
   	AFTER FIELD eca27
	    IF g_eca.eca27 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca27
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca27,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca27,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca27 = g_eca_o.eca27
                    DISPLAY BY NAME g_eca.eca27
		    NEXT FIELD eca27
		END IF
                LET g_eca_o.eca27 = g_eca.eca27
	    END IF
 
   	AFTER FIELD eca18
	    IF g_eca.eca18 IS NULL THEN
               IF g_eca_o.eca18 IS NULL THEN
                  LET g_eca.eca18 = 0
               ELSE
		  LET g_eca.eca18 = g_eca_o.eca18
               END IF
		DISPLAY BY NAME g_eca.eca18
		NEXT FIELD eca18
	    END IF
            LET g_eca_o.eca18 = g_eca.eca18
 
   	AFTER FIELD eca19
	    IF g_eca.eca19 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca19
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca19,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca19,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca19 = g_eca_o.eca19
                    DISPLAY BY NAME g_eca.eca19
		    NEXT FIELD eca19
		END IF
                LET g_eca_o.eca19 = g_eca.eca19
	    END IF
 
   	AFTER FIELD eca29
	    IF g_eca.eca29 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca29
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca29,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca29,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca29 = g_eca_o.eca29
                    DISPLAY BY NAME g_eca.eca29
		    NEXT FIELD eca29
		END IF
                LET g_eca_o.eca29 = g_eca.eca29
	    END IF
 
   	AFTER FIELD eca20
	    IF g_eca.eca20 IS NULL THEN
               IF g_eca_o.eca20 IS NULL THEN
                  LET g_eca.eca20 = 0
               ELSE
		  LET g_eca.eca20 = g_eca_o.eca20
               END IF
		DISPLAY BY NAME g_eca.eca20
		NEXT FIELD eca20
                LET g_eca_o.eca20 = g_eca.eca20
	    END IF
 
   	AFTER FIELD eca21
	    IF g_eca.eca21 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca21
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca21,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca21,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca21 = g_eca_o.eca21
                    DISPLAY BY NAME g_eca.eca21
		    NEXT FIELD eca21
		END IF
                LET g_eca_o.eca21 = g_eca.eca21
	    END IF
 
   	AFTER FIELD eca31
	    IF g_eca.eca31 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca31
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca31,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca31,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca31 = g_eca_o.eca31
                    DISPLAY BY NAME g_eca.eca31
		    NEXT FIELD eca31
		END IF
                LET g_eca_o.eca31 = g_eca.eca31
	    END IF
 
   	AFTER FIELD eca201
	    IF g_eca.eca201 IS NULL THEN
               IF g_eca_o.eca201 IS NULL THEN
                  LET g_eca.eca201 = 0
               ELSE
		  LET g_eca.eca201 = g_eca_o.eca201
               END IF
		DISPLAY BY NAME g_eca.eca201
		NEXT FIELD eca201
	    END IF
            LET g_eca_o.eca201 = g_eca.eca201
 
   	AFTER FIELD eca211
	    IF g_eca.eca211 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca211
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca211,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca211,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca211 = g_eca_o.eca211
                    DISPLAY BY NAME g_eca.eca211
		    NEXT FIELD eca211
		END IF
                LET g_eca_o.eca211 = g_eca.eca211
	    END IF
 
   	AFTER FIELD eca311
	    IF g_eca.eca311 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca311
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca311,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca311,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca311 = g_eca_o.eca311
                    DISPLAY BY NAME g_eca.eca311
		    NEXT FIELD eca311
		END IF
                LET g_eca_o.eca311 = g_eca.eca311
	    END IF
 
   	AFTER FIELD eca22
	    IF g_eca.eca22 IS NULL THEN
               IF g_eca_o.eca22 IS NULL THEN
                  LET g_eca.eca22 = 0
               ELSE
		  LET g_eca.eca22 = g_eca_o.eca22
               END IF
		DISPLAY BY NAME g_eca.eca22
		NEXT FIELD eca22
	    END IF
            LET g_eca_o.eca22 = g_eca.eca22
 
   	AFTER FIELD eca23
	    IF g_eca.eca23 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca23
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca23,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca23,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca23 = g_eca_o.eca23
                    DISPLAY BY NAME g_eca.eca23
		    NEXT FIELD eca23
		END IF
                LET g_eca_o.eca23 = g_eca.eca23
	    END IF
 
   	AFTER FIELD eca33
	    IF g_eca.eca33 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca33
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca33,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca33,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca33 = g_eca_o.eca33
                    DISPLAY BY NAME g_eca.eca33
		    NEXT FIELD eca33
		END IF
                LET g_eca_o.eca33 = g_eca.eca33
	    END IF
 
   	AFTER FIELD eca25
	    IF g_eca.eca25 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca25
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca25,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca25,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca25 = g_eca_o.eca25
                    DISPLAY BY NAME g_eca.eca25
		    NEXT FIELD eca25
		END IF
                LET g_eca_o.eca25 = g_eca.eca25
	    END IF
 
   	AFTER FIELD eca35
	    IF g_eca.eca35 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca35
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca35,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca35,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca35 = g_eca_o.eca35
                    DISPLAY BY NAME g_eca.eca35
		    NEXT FIELD eca35
		END IF
                LET g_eca_o.eca35 = g_eca.eca35
	    END IF
 
	AFTER INPUT
	   LET g_eca.ecauser = s_get_data_owner("eca_file") #FUN-C10039
	   LET g_eca.ecagrup = s_get_data_group("eca_file") #FUN-C10039
            LET l_sw = 'N'
	    IF NOT INT_FLAG THEN
		IF g_eca.eca14 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca14
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca15 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca15
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca16 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca16
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca18 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca18
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca20 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca20
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca201 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca201
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca22 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca22
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca24 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca24
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca26 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca26
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca28 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca28
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca30 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca30
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca301 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca301
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca32 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca32
                   LET l_sw = 'Y'
                END IF
		IF g_eca.eca34 IS NULL THEN               #check重要欄位
                   DISPLAY BY NAME g_eca.eca34
                   LET l_sw = 'Y'
                END IF
                IF l_sw = 'Y' THEN
		   CALL cl_err(g_eca.eca01,9033,0)
		   NEXT FIELD eca14
	        END IF
	    END IF
 
        ON ACTION controlp
	    CASE
		WHEN INFIELD(eca17)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca17
                     CALL cl_create_qry() RETURNING g_eca.eca17
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca17 )
                     DISPLAY BY NAME g_eca.eca17
                     NEXT FIELD eca17
		WHEN INFIELD(eca19)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca19
                     CALL cl_create_qry() RETURNING g_eca.eca19
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca19 )
                     DISPLAY BY NAME g_eca.eca19
                     NEXT FIELD eca19
		WHEN INFIELD(eca21)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca21
                     CALL cl_create_qry() RETURNING g_eca.eca21
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca21 )
                     DISPLAY BY NAME g_eca.eca21
                     NEXT FIELD eca21
		WHEN INFIELD(eca211)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca211
                     CALL cl_create_qry() RETURNING g_eca.eca211
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca211 )
                     DISPLAY BY NAME g_eca.eca211
                     NEXT FIELD eca211
		WHEN INFIELD(eca23)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca23
                     CALL cl_create_qry() RETURNING g_eca.eca23
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca23 )
                     DISPLAY BY NAME g_eca.eca23
                     NEXT FIELD eca23
		WHEN INFIELD(eca25)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca25
                     CALL cl_create_qry() RETURNING g_eca.eca25
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca25 )
                     DISPLAY BY NAME g_eca.eca25
                     NEXT FIELD eca25
		WHEN INFIELD(eca27)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca27
                     CALL cl_create_qry() RETURNING g_eca.eca27
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca27 )
                     DISPLAY BY NAME g_eca.eca27
                     NEXT FIELD eca27
		WHEN INFIELD(eca29)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca29
                     CALL cl_create_qry() RETURNING g_eca.eca29
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca29 )
                     DISPLAY BY NAME g_eca.eca29
                     NEXT FIELD eca29
		WHEN INFIELD(eca31)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca31
                     CALL cl_create_qry() RETURNING g_eca.eca31
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca31 )
                     DISPLAY BY NAME g_eca.eca31
                     NEXT FIELD eca31
		WHEN INFIELD(eca311)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca311
                     CALL cl_create_qry() RETURNING g_eca.eca311
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca311 )
                     DISPLAY BY NAME g_eca.eca311
                     NEXT FIELD eca311
		WHEN INFIELD(eca33)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca33
                     CALL cl_create_qry() RETURNING g_eca.eca33
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca33 )
                     DISPLAY BY NAME g_eca.eca33
                     NEXT FIELD eca33
		WHEN INFIELD(eca35)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca35
                     CALL cl_create_qry() RETURNING g_eca.eca35
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca35 )
                     DISPLAY BY NAME g_eca.eca35
                     NEXT FIELD eca35
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION maintain_cost_items
	    CASE
		WHEN INFIELD(eca17) OR INFIELD(eca19) OR INFIELD(eca21) OR
		     INFIELD(eca23) OR INFIELD(eca25) OR INFIELD(eca27) OR
		     INFIELD(eca29) OR INFIELD(eca31) OR INFIELD(eca33) OR
		     INFIELD(eca35)
  		     CALL cl_cmdrun('asms150')
                OTHERWISE EXIT CASE
            END CASE
 
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
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i601_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_eca.* TO NULL              #No.FUN-6A0039
    CALL cl_opmsg('q')
    MESSAGE ""
   #DISPLAY '   ' TO FORMONLY.cnt
    CALL i601_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i601_count
    FETCH i601_count INTO g_row_count
    #DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i601_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        INITIALIZE g_eca.* TO NULL
    ELSE
        CALL i601_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i601_fetch(p_fleca)
    DEFINE
        p_fleca         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_fleca
        WHEN 'N' FETCH NEXT     i601_cs INTO g_eca.eca01
        WHEN 'P' FETCH PREVIOUS i601_cs INTO g_eca.eca01
        WHEN 'F' FETCH FIRST    i601_cs INTO g_eca.eca01
        WHEN 'L' FETCH LAST     i601_cs INTO g_eca.eca01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
            END IF
            FETCH ABSOLUTE g_jump i601_cs INTO g_eca.eca01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        INITIALIZE g_eca.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_fleca
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_eca.* FROM eca_file            # 重讀DB,因TEMP有不被更新特性
       WHERE eca01 = g_eca.eca01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0) #No.FUN-660091
        CALL cl_err3("sel","eca_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
    ELSE
        LET g_data_owner = g_eca.ecauser      #FUN-4C0034
        LET g_data_group = g_eca.ecagrup      #FUN-4C0034
        CALL i601_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i601_show()
 DEFINE
        l_msg LIKE cre_file.cre08   # No.FUN-680073 VARCHAR(10)
    LET g_eca_t.* = g_eca.*
	CASE g_eca.eca04
		 WHEN '0' CALL cl_getmsg('mfg4004',0) RETURNING l_msg
		 WHEN '1' CALL cl_getmsg('mfg4005',0) RETURNING l_msg
		 WHEN '2' CALL cl_getmsg('mfg4006',0) RETURNING l_msg
		 OTHERWISE LET l_msg=' '
				   EXIT CASE
	END CASE
	DISPLAY g_row_count TO d01
	CASE g_eca.eca06
		 WHEN '1' CALL cl_getmsg('mfg4126',0) RETURNING l_msg
		 WHEN '2' CALL cl_getmsg('mfg4127',0) RETURNING l_msg
		 OTHERWISE LET l_msg=' '
				   EXIT CASE
	END CASE
	DISPLAY l_msg TO d02
 
    DISPLAY BY NAME g_eca.eca01, g_eca.eca02, g_eca.eca04, g_eca.eca06,
                  g_eca.eca14, g_eca.eca15, g_eca.eca16, g_eca.eca17,
                  g_eca.eca26, g_eca.eca27, g_eca.eca18, g_eca.eca19,
                  g_eca.eca28, g_eca.eca29,
                  g_eca.eca20, g_eca.eca21, g_eca.eca30, g_eca.eca31,
                  g_eca.eca201,g_eca.eca211,g_eca.eca301,g_eca.eca311,
                  g_eca.eca22, g_eca.eca23, g_eca.eca32, g_eca.eca33,
                  g_eca.eca24, g_eca.eca25,
                  g_eca.eca34, g_eca.eca35
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i601_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_eca.eca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_eca.ecaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_eca.eca01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_eca01_t = g_eca.eca01
    BEGIN WORK
 
    OPEN i601_cl USING g_eca.eca01
    IF STATUS THEN
       CALL cl_err("OPEN i601_cl:", STATUS, 1)
       CLOSE i601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i601_cl INTO g_eca.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_eca.ecamodu=g_user                     #修改者
    LET g_eca.ecadate = g_today                  #修改日期
    CALL i601_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i601_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_eca.*=g_eca_t.*
            CALL i601_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE eca_file SET eca_file.* = g_eca.*    # 更新DB
            WHERE eca01 = g_eca.eca01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("upd","eca_file",g_eca.eca01,"",SQLCA.sqlcode,"","",1) #FUN-660091
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i601_cl
    COMMIT WORK
END FUNCTION
 
#Patch....NO.TQC-610035 <> #

