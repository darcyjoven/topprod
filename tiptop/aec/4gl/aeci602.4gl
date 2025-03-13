# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci602.4gl
# Descriptions...: 廠外/廠內成本維護作業
# Date & Author..: 92/03/19 By DAVID
# Modify ........: 92/03/19 By Pin
# Modify ........: 92/08/28 By Keith
# Source.........: From aeci600.4gl 's  Function aeci602
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660091 06/06/14 By hellen cl_err --> cl_err3
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
    g_flag              LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1)
    g_wc,g_sql          STRING,                  #No.FUN-580092 HCN    
    p_row,p_col         LIKE type_file.num5      #No.FUN-680073 SMALLINT 
 
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
MAIN
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
    DECLARE i602_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 5 LET p_col = 3
    OPEN WINDOW i602_w AT p_row,p_col
      WITH FORM "aec/42f/aeci602"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_eca.eca01 = ARG_VAL(1)
    LET g_eca02     = ARG_VAL(2)
    IF g_eca.eca01 IS NOT NULL AND  g_eca.eca01 != ' '
       THEN LET g_flag = 'Y'
        CALL i602_q()
	    CALL i602_u()
       ELSE LET g_flag = 'N'
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i602_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i602_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i602_cs()
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
 
        ON ACTION controlp
	    CASE
		WHEN INFIELD(eca37)
# 		     CALL q_smg(10,3,g_eca.eca37) RETURNING g_eca.eca37
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca37
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca37
                     NEXT FIELD eca37
		WHEN INFIELD(eca43)
# 		     CALL q_smg(10,3,g_eca.eca43) RETURNING g_eca.eca43
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_eca.eca43
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO eca43
                     NEXT FIELD eca43
		WHEN INFIELD(eca39)
# 		     CALL q_smg(10,3,g_eca.eca39) RETURNING g_eca.eca39
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca39
                     CALL cl_create_qry() RETURNING g_eca.eca39
                     DISPLAY BY NAME g_eca.eca39
                     NEXT FIELD eca39
		WHEN INFIELD(eca45)
# 		     CALL q_smg(10,3,g_eca.eca45) RETURNING g_eca.eca45
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca45
                     CALL cl_create_qry() RETURNING g_eca.eca45
                     DISPLAY BY NAME g_eca.eca45
                     NEXT FIELD eca45
		WHEN INFIELD(eca41)
# 		     CALL q_smg(10,3,g_eca.eca41) RETURNING g_eca.eca41
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca41
                     CALL cl_create_qry() RETURNING g_eca.eca41
                     DISPLAY BY NAME g_eca.eca41
                     NEXT FIELD eca41
		WHEN INFIELD(eca47)
# 		     CALL q_smg(10,3,g_eca.eca47) RETURNING g_eca.eca47
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca47
                     CALL cl_create_qry() RETURNING g_eca.eca47
                     DISPLAY BY NAME g_eca.eca47
                     NEXT FIELD eca47
                OTHERWISE EXIT CASE
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
			" AND eca04 IN ('1','2') ", "ORDER BY eca01"
    PREPARE i602_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i602_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i602_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM eca_file WHERE ",g_wc CLIPPED
    PREPARE i602_precount FROM g_sql
    DECLARE i602_count CURSOR FOR i602_precount
END FUNCTION
 
FUNCTION i602_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i602_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i602_fetch('N')
        ON ACTION previous
            CALL i602_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i602_u()
            END IF
            NEXT OPTION "next"
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i602_fetch('/')
        ON ACTION first
            CALL i602_fetch('F')
        ON ACTION last
            CALL i602_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
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
    CLOSE i602_cs
END FUNCTION
 
 
FUNCTION i602_i(p_cmd)
    DEFINE
           l_msg LIKE type_file.chr8,     # No.FUN-680073 VARCHAR(8)
           p_cmd LIKE type_file.chr1,     #No.FUN-680073 VARCHAR(1)
           l_sw  LIKE type_file.chr1      # No.FUN-680073 VARCHAR(1)      #重要欄位輸入否
 
    DISPLAY BY NAME g_eca.eca01, g_eca.eca02, g_eca.eca04,g_eca.eca06
 
{
    CASE
	WHEN g_eca.eca04 = '1'
             CALL cl_getmsg('mfg4005',g_lang) RETURNING l_msg
	WHEN g_eca.eca04 = '2'
             CALL cl_getmsg('mfg4006',g_lang) RETURNING l_msg
    END CASE
    DISPLAY l_msg TO FORMONLY.d01
}
 
    IF g_eca.eca04 = '2' THEN #廠內加工才需輸入'製造'類成本
       DISPLAY BY NAME g_eca.eca38, g_eca.eca39, g_eca.eca40, g_eca.eca41,
  	       g_eca.eca44, g_eca.eca45, g_eca.eca46, g_eca.eca47
    ELSE
       LET g_eca.eca38 = 0 LET g_eca.eca39 = NULL
       LET g_eca.eca40 = 0 LET g_eca.eca41 = NULL
       LET g_eca.eca44 = 0 LET g_eca.eca45 = NULL
       LET g_eca.eca46 = 0 LET g_eca.eca47 = NULL
    END IF
    INPUT BY NAME g_eca.eca36, g_eca.eca37, g_eca.eca42, g_eca.eca43
                     		  WITHOUT DEFAULTS
   	AFTER FIELD eca36
	    IF g_eca.eca36 IS NULL THEN
               IF g_eca_o.eca36 IS NULL THEN
                  LET g_eca.eca36 = 0
               ELSE
		  LET g_eca.eca36 = g_eca_o.eca36
               END IF
		DISPLAY BY NAME g_eca.eca36
		NEXT FIELD eca36
	    END IF
            LET g_eca_o.eca36 = g_eca.eca36
 
   	AFTER FIELD eca37
	    IF g_eca.eca37 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca37
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca37,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca37,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca37 = g_eca_o.eca37
                    DISPLAY BY NAME g_eca.eca37
		    NEXT FIELD eca37
		END IF
	    END IF
   #    IF g_eca.eca04 = '2' THEN #廠內加工才需輸入'製造'類成本
   #	   CALL i602_eca38()
   #  	   IF INT_FLAG THEN
   #          EXIT INPUT
   #       END IF
   #    END IF
            LET g_eca_o.eca37 = g_eca.eca37
 
	BEFORE FIELD  eca42
	    IF g_eca.eca42 IS NULL OR g_eca.eca42 = 0 THEN
               LET g_eca.eca42 = g_eca.eca36
	    END IF
	    IF g_eca.eca43 IS NULL OR g_eca.eca43 = 0 THEN
               LET g_eca.eca43 = g_eca.eca37
	    END IF
	    DISPLAY BY NAME g_eca.eca42, g_eca.eca43
 
	#   IF g_eca.eca04 = '2' THEN       #廠內加工才需輸入'製造'類成本
	#      IF g_eca.eca44 IS NULL OR g_eca.eca44 = 0 THEN
    #         LET g_eca.eca44 = g_eca.eca38
	#      END IF
	#      IF g_eca.eca45 IS NULL OR g_eca.eca45 = 0 THEN
    #         LET g_eca.eca45 = g_eca.eca39
	#  	   END IF
	#      IF g_eca.eca46 IS NULL OR g_eca.eca46 = 0 THEN
    #         LET g_eca.eca46 = g_eca.eca40
	#      END IF
	#      IF g_eca.eca47 IS NULL OR g_eca.eca47 = 0 THEN
    #          LET g_eca.eca47 = g_eca.eca41
	#      END IF
	#      DISPLAY BY NAME g_eca.eca44,g_eca.eca45,g_eca.eca47, g_eca.eca46
	#   END IF
 
   	AFTER FIELD eca42
	   IF g_eca.eca42 IS NULL THEN
              IF g_eca_o.eca42 IS NULL THEN
                 LET g_eca.eca42 = 0
              ELSE
	         LET g_eca.eca42 = g_eca_o.eca42
              END IF
	      DISPLAY BY NAME g_eca.eca42
	      NEXT FIELD eca42
	   END IF
           LET g_eca_o.eca42 = g_eca.eca42
 
   	AFTER FIELD eca43
	    IF g_eca.eca43 IS NOT NULL THEN
	       SELECT * FROM smg_file WHERE smg01 = g_eca.eca43
	       IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_eca.eca43,'mfg4003',0) #No.FUN-660091
                  CALL cl_err3("sel","smg_file",g_eca.eca43,"","mfg4003","","",1) #FUN-660091
		  LET g_eca.eca43 = g_eca_o.eca43
                  DISPLAY BY NAME g_eca.eca43
	          NEXT FIELD eca43
	       END IF
	    END IF
 
   #    IF g_eca.eca04 = '2' THEN #廠內加工才需輸入'製造'類成本
   #        CALL i602_eca44()
   #    	IF INT_FLAG THEN
   #           EXIT INPUT
   #        END IF
   #    END IF
 
        IF g_eca.eca04 = '2' THEN #廠內加工才需輸入'製造'類成本
            CALL i602_eca38()
            CALL i602_eca40()
        	IF INT_FLAG THEN
               EXIT INPUT
            END IF
        END IF
 
 
        LET g_eca_o.eca44 = g_eca.eca44
 
	AFTER INPUT
	   LET g_eca.ecauser = s_get_data_owner("eca_file") #FUN-C10039
	   LET g_eca.ecagrup = s_get_data_group("eca_file") #FUN-C10039
        LET l_sw = 'N'
	    IF NOT INT_FLAG THEN
 
           IF g_eca.eca36 IS NULL THEN
              DISPLAY BY NAME g_eca.eca36
              LET l_sw = 'Y'
           END IF
 
           IF g_eca.eca36 IS NULL THEN
              DISPLAY BY NAME g_eca.eca36
              LET l_sw = 'Y'
           END IF
 
           IF g_eca.eca42 IS NULL THEN
              DISPLAY BY NAME g_eca.eca42
              LET l_sw = 'Y'
           END IF
 
           IF l_sw = 'Y' THEN
	          CALL cl_err(g_eca.eca01,9033,0)
		      NEXT FIELD eca36
	       END IF
 
	    END IF
 
        ON ACTION controlp
	    CASE
		WHEN INFIELD(eca37)
# 		     CALL q_smg(10,3,g_eca.eca37) RETURNING g_eca.eca37
# 		     CALL FGL_DIALOG_SETBUFFER( g_eca.eca37 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca37
                     CALL cl_create_qry() RETURNING g_eca.eca37
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca37 )
                     DISPLAY BY NAME g_eca.eca37
                     NEXT FIELD eca37
		WHEN INFIELD(eca43)
# 		     CALL q_smg(10,3,g_eca.eca43) RETURNING g_eca.eca43
# 		     CALL FGL_DIALOG_SETBUFFER( g_eca.eca43 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca43
                     CALL cl_create_qry() RETURNING g_eca.eca43
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca43 )
                     DISPLAY BY NAME g_eca.eca43
                     NEXT FIELD eca43
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION maintain_cost_items
	    CASE
		WHEN INFIELD(eca37) OR INFIELD(eca43)
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
 
FUNCTION i602_eca38()
    DEFINE
             l_sw  LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)         #重要欄位輸入否
    INPUT BY NAME  g_eca.eca38, g_eca.eca39, g_eca.eca44, g_eca.eca45
                             WITHOUT DEFAULTS
   	AFTER FIELD eca38
	    IF g_eca.eca38 IS NULL THEN
               IF g_eca_o.eca38 IS NULL THEN
                  LET g_eca.eca38 = 0
               ELSE
		  LET g_eca.eca38 = g_eca_o.eca38
               END IF
		DISPLAY BY NAME g_eca.eca38
		NEXT FIELD eca38
	    END IF
            LET g_eca_o.eca38 = g_eca.eca38
 
   	AFTER FIELD eca39
	    IF g_eca.eca39 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca39
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca39,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca39,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca39 = g_eca_o.eca39
                    DISPLAY BY NAME g_eca.eca39
		    NEXT FIELD eca39
		END IF
	    END IF
            LET g_eca_o.eca39 = g_eca.eca39
 
    BEFORE FIELD eca44
	       IF g_eca.eca44 IS NULL OR g_eca.eca44 = 0 THEN
              LET g_eca.eca44 = g_eca.eca38
	       END IF
	       IF g_eca.eca45 IS NULL OR g_eca.eca45 = 0 THEN
              LET g_eca.eca45 = g_eca.eca39
	   	   END IF
	       DISPLAY BY NAME g_eca.eca44,g_eca.eca45
 
   	AFTER FIELD eca44
	    IF g_eca.eca44 IS NULL THEN
               IF g_eca_o.eca44 IS NULL THEN
                  LET g_eca.eca44 = 0
               ELSE
		  LET g_eca.eca44 = g_eca_o.eca44
               END IF
		DISPLAY BY NAME g_eca.eca44
		NEXT FIELD eca44
	    END IF
            LET g_eca_o.eca44 = g_eca.eca44
 
   	AFTER FIELD eca45
	    IF g_eca.eca45 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca45
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca45,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca45,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca45 = g_eca_o.eca45
                    DISPLAY BY NAME g_eca.eca45
		    NEXT FIELD eca45
		END IF
	    END IF
            LET g_eca_o.eca45 = g_eca.eca45
 
	AFTER INPUT
        LET l_sw = 'N'
	    IF NOT INT_FLAG THEN
           IF g_eca.eca38 IS NULL THEN
              DISPLAY BY NAME g_eca.eca38
              LET l_sw = 'Y'
           END IF
           IF g_eca.eca44 IS NULL THEN
              DISPLAY BY NAME g_eca.eca44
              LET l_sw = 'Y'
           END IF
           IF l_sw = 'Y' THEN
	          CALL cl_err(g_eca.eca01,9033,0)
	          NEXT FIELD eca38
	       END IF
	    END IF
 
        ON ACTION controlp
	    CASE
		WHEN INFIELD(eca39)
# 		     CALL q_smg(10,3,g_eca.eca39) RETURNING g_eca.eca39
# 		     CALL FGL_DIALOG_SETBUFFER( g_eca.eca39 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca39
                     CALL cl_create_qry() RETURNING g_eca.eca39
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca39 )
                     DISPLAY BY NAME g_eca.eca39
                     NEXT FIELD eca39
		WHEN INFIELD(eca45)
# 		     CALL q_smg(10,3,g_eca.eca45) RETURNING g_eca.eca45
# 		     CALL FGL_DIALOG_SETBUFFER( g_eca.eca45 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca45
                     CALL cl_create_qry() RETURNING g_eca.eca45
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca45 )
                     DISPLAY BY NAME g_eca.eca45
                     NEXT FIELD eca45
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION maintain_cost_items
	    CASE
		WHEN INFIELD(eca39) OR INFIELD(eca45)
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
	
FUNCTION i602_eca40()
    DEFINE 
            l_sw  LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)           #重要欄位輸入否 
    INPUT BY NAME g_eca.eca40, g_eca.eca41, g_eca.eca46, g_eca.eca47
            		 WITHOUT DEFAULTS
   	AFTER FIELD eca40
	    IF g_eca.eca40 IS NULL THEN
               IF g_eca_o.eca40 IS NULL THEN
                  LET g_eca.eca40 = 0
               ELSE
		  LET g_eca.eca40 = g_eca_o.eca40
               END IF
		DISPLAY BY NAME g_eca.eca40
		NEXT FIELD eca40
	    END IF
            LET g_eca_o.eca40 = g_eca.eca40
 
   	AFTER FIELD eca41
	    IF g_eca.eca41 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca41
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca41,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca41,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca41 = g_eca_o.eca41
                    DISPLAY BY NAME g_eca.eca39
		    NEXT FIELD eca41
		END IF
	    END IF
            LET g_eca_o.eca41 = g_eca.eca41
 
    BEFORE FIELD eca46
	       IF g_eca.eca46 IS NULL OR g_eca.eca46 = 0 THEN
              LET g_eca.eca46 = g_eca.eca40
	       END IF
	       IF g_eca.eca47 IS NULL OR g_eca.eca47 = 0 THEN
               LET g_eca.eca47 = g_eca.eca41
	       END IF
	       DISPLAY BY NAME g_eca.eca47, g_eca.eca46
 
   	AFTER FIELD eca46
	    IF g_eca.eca46 IS NULL THEN
               IF g_eca_o.eca46 IS NULL THEN
                  LET g_eca.eca46 = 0
               ELSE
		  LET g_eca.eca46 = g_eca_o.eca46
               END IF
		DISPLAY BY NAME g_eca.eca46
		NEXT FIELD eca46
	    END IF
            LET g_eca_o.eca46 = g_eca.eca46
 
   	AFTER FIELD eca47
	    IF g_eca.eca47 IS NOT NULL THEN
		SELECT * FROM smg_file WHERE smg01 = g_eca.eca47
		IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_eca.eca47,'mfg4003',0) #No.FUN-660091
                    CALL cl_err3("sel","smg_file",g_eca.eca47,"","mfg4003","","",1) #FUN-660091
		    LET g_eca.eca47 = g_eca_o.eca47
                    DISPLAY BY NAME g_eca.eca47
		    NEXT FIELD eca47
		END IF
	    END IF
            LET g_eca_o.eca47 = g_eca.eca47
 
	AFTER INPUT
            LET l_sw = 'N'
	    IF NOT INT_FLAG THEN
               IF g_eca.eca40 IS NULL THEN
                  DISPLAY BY NAME g_eca.eca40
                  LET l_sw = 'Y'
               END IF
               IF g_eca.eca46 IS NULL THEN
                  DISPLAY BY NAME g_eca.eca46
                  LET l_sw = 'Y'
               END IF
               IF l_sw = 'Y' THEN
		   CALL cl_err(g_eca.eca01,9033,0)
		   NEXT FIELD eca40
	       END IF
	    END IF
 
        ON ACTION controlp
	    CASE
		WHEN INFIELD(eca41)
# 		     CALL q_smg(10,3,g_eca.eca41) RETURNING g_eca.eca41
# 		     CALL FGL_DIALOG_SETBUFFER( g_eca.eca41 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca41
                     CALL cl_create_qry() RETURNING g_eca.eca41
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca41 )
                     DISPLAY BY NAME g_eca.eca41
                     NEXT FIELD eca41
		WHEN INFIELD(eca47)
# 		     CALL q_smg(10,3,g_eca.eca47) RETURNING g_eca.eca47
# 		     CALL FGL_DIALOG_SETBUFFER( g_eca.eca47 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_eca.eca47
                     CALL cl_create_qry() RETURNING g_eca.eca47
#                     CALL FGL_DIALOG_SETBUFFER( g_eca.eca47 )
                     DISPLAY BY NAME g_eca.eca47
                     NEXT FIELD eca47
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION maintain_cost_items
	    CASE
		WHEN INFIELD(eca41) OR INFIELD(eca47)
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
 
FUNCTION i602_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_eca.* TO NULL              #No.FUN-6A0039
    CALL cl_opmsg('q')
    MESSAGE ""
   #DISPLAY '   ' TO FORMONLY.cnt
    CALL i602_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i602_count
    FETCH i602_count INTO g_row_count
    OPEN i602_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        INITIALIZE g_eca.* TO NULL
    ELSE
        CALL i602_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i602_fetch(p_fleca)
    DEFINE
        p_fleca         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1) 
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_fleca
        WHEN 'N' FETCH NEXT     i602_cs INTO g_eca.eca01
        WHEN 'P' FETCH PREVIOUS i602_cs INTO g_eca.eca01
        WHEN 'F' FETCH FIRST    i602_cs INTO g_eca.eca01
        WHEN 'L' FETCH LAST     i602_cs INTO g_eca.eca01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i602_cs INTO g_eca.eca01
            LET g_no_ask = FALSE
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
        CALL i602_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i602_show()
 DEFINE
        l_msg LIKE type_file.chr8      # No.FUN-680073 VARCHAR(8)
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
                  g_eca.eca36, g_eca.eca37, g_eca.eca38, g_eca.eca39,
                  g_eca.eca40, g_eca.eca41, g_eca.eca42, g_eca.eca43,
                  g_eca.eca44,g_eca.eca45,
                  g_eca.eca46, g_eca.eca47
 
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i602_u()
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
 
    OPEN i602_cl USING g_eca.eca01
    IF STATUS THEN
       CALL cl_err("OPEN i602_cl:", STATUS, 1)
       CLOSE i602_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i602_cl INTO g_eca.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_eca.eca01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_eca.ecamodu=g_user                     #修改者
    LET g_eca.ecadate = g_today                  #修改日期
    CALL i602_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i602_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_eca.*=g_eca_t.*
            CALL i602_show()
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
    CLOSE i602_cl
    COMMIT WORK
END FUNCTION
 

