# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aeci603.4gl
# Descriptions...: 工作站成本會計作業
# Date & Author..: 91/11/04 By Carol
# Modify.........: 92/01/09 By Nora
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei欄位型態轉換
# Modify.........: No.FUN-6A0039 06/10/25 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-A40090 10/04/20 By destiny 管控会计科目必须为独立或统制             
# Modify.........: No.TQC-A50065 10/05/18 By destiny aeci600调用时画面无资料            
# Modify.........: No.TQC-A70017 10/07/05 By Carrier TQC-A40090 更正
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ecc   RECORD LIKE ecc_file.*,
    g_ecc_t RECORD LIKE ecc_file.*,
    g_ecc01_t LIKE ecc_file.ecc01,
    g_eca02   LIKE eca_file.eca02,
    g_flag              LIKE type_file.chr1,       #No.FUN-680073 VARCHAR(1)
    g_wc,g_sql          STRING
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5   #No.FUN-570110        #No.FUN-680073 SMALLINT
DEFINE   g_ecc01         LIKE ecc_file.ecc01          #No.TQC-A50065 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #LET g_ecc.ecc01 = ARG_VAL(1)                      #No.TQC-A50065  
    LET g_ecc01 = ARG_VAL(1)                          #No.TQC-A50065
    LET g_eca02     = ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100

    INITIALIZE g_ecc.* TO NULL
    INITIALIZE g_ecc_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ecc_file WHERE ecc01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i603_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i603_w WITH FORM "aec/42f/aeci603"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
   #IF g_ecc.ecc01 IS NOT NULL AND  g_ecc.ecc01 != ' '       #No.TQC-A50065
    IF NOT cl_null(g_ecc01)                                      #No.TQC-A50065 
       THEN LET g_flag = 'Y'
            LET g_ecc.ecc01=g_ecc01                          #No.TQC-A50065 
            CALL i603_q()
	    CALL i603_u()
       ELSE LET g_flag = 'N'
    END IF
 
    LET g_action_choice=""
    CALL i603_menu()
 
    CLOSE WINDOW i603_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN
 
FUNCTION i603_cs()
    CLEAR FORM
    IF g_flag = 'Y' THEN
       LET g_wc = "ecc01='",g_ecc.ecc01,"'"
    ELSE
   INITIALIZE g_ecc.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           ecc01,ecc02,ecc03,ecc04,ecc05,
           eccuser,eccgrup,eccmodu,eccdate,eccacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(ecc01)
                    CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ecc01
                    NEXT FIELD ecc01
               WHEN INFIELD(ecc02) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc02,' ',' ',' ')
#		RETURNING g_ecc.ecc02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ecc.ecc02
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_ecc.ecc02
                  NEXT FIELD ecc02
               WHEN INFIELD(ecc03) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc03,' ',' ',' ')
#		RETURNING g_ecc.ecc03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ecc.ecc03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_ecc.ecc02
                  NEXT FIELD ecc03
               WHEN INFIELD(ecc04) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc04,' ',' ',' ')
#		RETURNING g_ecc.ecc04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ecc.ecc04
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_ecc.ecc04
                  NEXT FIELD ecc04
               WHEN INFIELD(ecc05) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc05,' ',' ',' ')
#		RETURNING g_ecc.ecc05
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ecc.ecc05
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_ecc.ecc05
                  NEXT FIELD ecc05
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
    #        LET g_wc = g_wc clipped," AND eccuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND eccgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND eccgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('eccuser', 'eccgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ecc01 FROM ecc_file ", # 組合出 SQL 指令
            " WHERE ",g_wc CLIPPED, "ORDER BY ecc01"
    PREPARE i603_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i603_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i603_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ecc_file WHERE ",g_wc CLIPPED
    PREPARE i603_precount FROM g_sql
    DECLARE i603_count CURSOR FOR i603_precount
END FUNCTION
 
FUNCTION i603_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i603_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL i603_fetch('N')
        ON ACTION previous
            CALL i603_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i603_u()
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
            CALL i603_fetch('/')
        ON ACTION first
            CALL i603_fetch('F')
        ON ACTION last
            CALL i603_fetch('L')
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
               IF g_ecc.ecc01 IS NOT NULL THEN
                  LET g_doc.column1 = "ecc01"
                  LET g_doc.value1 = g_ecc.ecc01
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
    CLOSE i603_cs
END FUNCTION
 
 
FUNCTION i603_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680073 SMALLINT
 
    DISPLAY BY NAME g_ecc.ecc01,g_ecc.eccuser,g_ecc.eccgrup,
        g_ecc.eccdate, g_ecc.eccacti
    DISPLAY g_eca02 TO eca02
    INPUT BY NAME
#        g_ecc.ecc02, g_ecc.ecc03,g_ecc.ecc04,g_ecc.ecc05
        g_ecc.ecc01,g_ecc.ecc02, g_ecc.ecc03,g_ecc.ecc04,g_ecc.ecc05    #No.FUN-570110
        WITHOUT DEFAULTS
 
#No.FUN-570110 --start--
         BEFORE INPUT
                LET g_before_input_done = FALSE
                CALL i603_set_entry(p_cmd)
                CALL i603_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
#No.FUN-570110 --end--
        AFTER FIELD ecc02
            IF g_ecc.ecc02 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  #FUN-B10049--begin
                  #IF NOT s_actchk3(g_ecc.ecc02,g_aza.aza81) THEN #檢查會計科目 #No.FUN-730033
                  #   CALL cl_err(g_ecc.ecc02,'mfg0018',0)
		              #   LET g_ecc.ecc02 = g_ecc_t.ecc02
		              #   DISPLAY BY NAME g_ecc.ecc02
                  #   NEXT FIELD ecc02
                  ##No.TQC-A40090--begin   
                  #ELSE 
                  #	 IF i603_s(g_ecc.ecc02) THEN 
                  #	    CALL cl_err(g_ecc.ecc02,'agl-134',0)
                  #	    LET g_ecc.ecc02 = g_ecc_t.ecc02
		              #      DISPLAY BY NAME g_ecc.ecc02
                  #      NEXT FIELD ecc02
                  #	 END IF 
                  ##No.TQC-A40090--end 
                  IF NOT cl_null(g_ecc.ecc02) THEN #FUN-B10049
                     CALL i603_s(g_ecc.ecc02)
                     IF NOT cl_null(g_errno) THEN 
                        CALL cl_err(g_ecc.ecc02,'g_errno',0)
                        CALL cl_init_qry_var()                                         
                        LET g_qryparam.form ="q_aag"                                   
                        LET g_qryparam.default1 = g_ecc.ecc02  
                        LET g_qryparam.construct = 'N'                
                        LET g_qryparam.arg1 = g_aza.aza81  
                        LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_ecc.ecc02 CLIPPED,"%' "                                                                        
                        CALL cl_create_qry() RETURNING g_ecc.ecc02                 
                        DISPLAY BY NAME g_ecc.ecc02
                        NEXT FIELD ecc02
                     #FUN-B10049--end
                     END IF
                  END IF 
                END IF
            END IF
        AFTER FIELD ecc03  #會計科目, 可空白, 須存在
            IF g_ecc.ecc03 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN      
                  #FUN-B10049--begin              
                  #IF NOT s_actchk3(g_ecc.ecc03,g_aza.aza81) THEN #檢查會計科目 #No.FUN-730033
                  #   CALL cl_err(g_ecc.ecc03,'mfg0018',0)
		              #   LET g_ecc.ecc03 = g_ecc_t.ecc03
		              #   DISPLAY BY NAME g_ecc.ecc03
                  #   NEXT FIELD ecc03
                  ##No.TQC-A40090--begin   
                  #ELSE    
                  #  IF i603_s(g_ecc.ecc03) THEN 
                  #	    CALL cl_err(g_ecc.ecc03,'agl-134',0)
                  #	    LET g_ecc.ecc03 = g_ecc_t.ecc03
		              #      DISPLAY BY NAME g_ecc.ecc03
                  #      NEXT FIELD ecc03
                  #	END IF 
                  ##No.TQC-A40090--end
                  #FUN-B10049
                  IF NOT cl_null(g_ecc.ecc03) THEN #FUN-B10049
                    CALL i603_s(g_ecc.ecc03) 
                    IF NOT cl_null(g_errno) THEN 
                       CALL cl_err(g_ecc.ecc03,'g_errno',0)
                       CALL cl_init_qry_var()                                         
                       LET g_qryparam.form ="q_aag"                                   
                       LET g_qryparam.default1 = g_ecc.ecc03 
                       LET g_qryparam.construct = 'N'                
                       LET g_qryparam.arg1 = g_aza.aza81  
                       LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_ecc.ecc03 CLIPPED,"%' "                                                                        
                       CALL cl_create_qry() RETURNING g_ecc.ecc03                 
                       DISPLAY BY NAME g_ecc.ecc03
                       NEXT FIELD ecc03
                    #FUN-B10049--end                  
                    END IF
                  END IF 
                END IF
            END IF
 
        AFTER FIELD ecc04  #會計科目, 可空白, 須存在
            IF g_ecc.ecc04 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  #FUN-B10049--begin
                  #IF NOT s_actchk3(g_ecc.ecc04,g_aza.aza81) THEN #檢查會計科目 #No.FUN-730033
                  #    CALL cl_err(g_ecc.ecc04,'mfg0018',0)
		              #    LET g_ecc.ecc04 = g_ecc_t.ecc04
		              #    DISPLAY BY NAME g_ecc.ecc04
                  #    NEXT FIELD ecc04
                  ##No.TQC-A40090--begin   
                  #ELSE 
                  #	 IF i603_s(g_ecc.ecc04) THEN 
                  #	    CALL cl_err(g_ecc.ecc04,'agl-134',0)
                  #	    LET g_ecc.ecc04 = g_ecc_t.ecc04
		              #      DISPLAY BY NAME g_ecc.ecc04
                  #      NEXT FIELD ecc04
                  #	 END IF 
                  ##No.TQC-A40090--end  
                  IF NOT cl_null(g_ecc.ecc04) THEN #FUN-B10049
                     CALL i603_s(g_ecc.ecc04) 
                     IF NOT cl_null(g_errno) THEN 
                        CALL cl_err(g_ecc.ecc04,'g_errno',0)
                        CALL cl_init_qry_var()                                         
                        LET g_qryparam.form ="q_aag"                                   
                        LET g_qryparam.default1 = g_ecc.ecc04 
                        LET g_qryparam.construct = 'N'                
                        LET g_qryparam.arg1 = g_aza.aza81  
                        LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_ecc.ecc04 CLIPPED,"%' "                                                                        
                        CALL cl_create_qry() RETURNING g_ecc.ecc04                 
                        DISPLAY BY NAME g_ecc.ecc04
                        NEXT FIELD ecc04
                     #FUN-B10049--end                       
                     END IF
                  END IF 
               END IF
            END IF
 
        AFTER FIELD ecc05  #會計科目, 可空白, 須存在
            IF g_ecc.ecc05 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  #FUN-B10049--begin
                  #IF NOT s_actchk3(g_ecc.ecc05,g_aza.aza81) THEN #檢查會計科目 #No.FUN-730033
                  #   CALL cl_err(g_ecc.ecc05,'mfg0018',0)
		              #   LET g_ecc.ecc05 = g_ecc_t.ecc05
		              #   DISPLAY BY NAME g_ecc.ecc05
                  #   NEXT FIELD ecc05
                  # #No.TQC-A40090--begin   
                  # ELSE 
                  # 	 IF i603_s(g_ecc.ecc05) THEN 
                  # 	    CALL cl_err(g_ecc.ecc05,'agl-134',0)
                  # 	    LET g_ecc.ecc05 = g_ecc_t.ecc05
		              #       DISPLAY BY NAME g_ecc.ecc05
                  #       NEXT FIELD ecc05
                  # 	 END IF                    	 
                  # #No.TQC-A40090--end
                  IF NOT cl_null(g_ecc.ecc05) THEN #FUN-B10049
                     CALL i603_s(g_ecc.ecc05) 
                     IF NOT cl_null(g_errno) THEN 
                        CALL cl_err(g_ecc.ecc05,'g_errno',0)
                        CALL cl_init_qry_var()                                         
                        LET g_qryparam.form ="q_aag"                                   
                        LET g_qryparam.default1 = g_ecc.ecc05
                        LET g_qryparam.construct = 'N'                
                        LET g_qryparam.arg1 = g_aza.aza81  
                        LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",g_ecc.ecc05 CLIPPED,"%' "                                                                        
                        CALL cl_create_qry() RETURNING g_ecc.ecc05                
                        DISPLAY BY NAME g_ecc.ecc05
                        NEXT FIELD ecc05
                      #FUN-B10049--end                        
                      END IF
                   END IF 
                END IF
            END IF
        #MOD-650015 --start 
#       ON ACTION CONTROLO                        # 沿用所有欄位
#           IF INFIELD(ecc01) THEN
#               LET g_ecc.* = g_ecc_t.*
#               DISPLAY BY NAME g_ecc.*
#               NEXT FIELD ecc01
#           END IF
        #MOD-650015 --end
 
        ON ACTION controlp
            CASE
              WHEN INFIELD(ecc01)
                   CALL q_eca(FALSE,FALSE,g_ecc.ecc01)
                        RETURNING g_ecc.ecc01
                   DISPLAY g_ecc.ecc01
                   NEXT FIELD ecc01
               WHEN INFIELD(ecc02) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc02,' ',' ',' ')
#		RETURNING g_ecc.ecc02
#                 CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc02 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_ecc.ecc02
                  LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' "  #FUN-B10049
                  CALL cl_create_qry() RETURNING g_ecc.ecc02
#                  CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc02 )
                  DISPLAY BY NAME g_ecc.ecc02
                  NEXT FIELD ecc02
               WHEN INFIELD(ecc03) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc03,' ',' ',' ')
#		RETURNING g_ecc.ecc03
#                 CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc03 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_ecc.ecc03
                  LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' "  #FUN-B10049
                  CALL cl_create_qry() RETURNING g_ecc.ecc03
#                  CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc03 )
                  DISPLAY BY NAME g_ecc.ecc03
                  NEXT FIELD ecc03
               WHEN INFIELD(ecc04) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc04,' ',' ',' ')
#		RETURNING g_ecc.ecc04
#                 CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc04 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_ecc.ecc04
                  LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' "  #FUN-B10049
                  CALL cl_create_qry() RETURNING g_ecc.ecc04
#                  CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc04 )
                  DISPLAY BY NAME g_ecc.ecc04
                  NEXT FIELD ecc04
               WHEN INFIELD(ecc05) #會計科目
#                 CALL q_aag(10,3,g_ecc.ecc05,' ',' ',' ')
#		RETURNING g_ecc.ecc05
#                 CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc05 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.default1 = g_ecc.ecc05
                  LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                  LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' "  #FUN-B10049
                  CALL cl_create_qry() RETURNING g_ecc.ecc05
#                  CALL FGL_DIALOG_SETBUFFER( g_ecc.ecc05 )
                  DISPLAY BY NAME g_ecc.ecc05
                  NEXT FIELD ecc05
               OTHERWISE EXIT CASE
            END CASE
 
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

#No.TQC-A40090--begin
FUNCTION i603_s(p_aag01) 
DEFINE   l_aag07    LIKE aag_file.aag07
DEFINE   p_aag01    LIKE aag_file.aag01
DEFINE   l_aagacti  LIKE aag_file.aagacti 

    SELECT aag07,aagacti INTO l_aag07,l_aagacti FROM aag_file  #FUN-B10049
     WHERE aag00=g_aza.aza81 AND aag01=p_aag01
    #IF l_aag07='1' THEN
    #  #RETURN 0   #No.TQC-A70017
    #   RETURN 1   #No.TQC-A70017
    #ELSE 
    #  #RETURN 1   #No.TQC-A70017
    #   RETURN 0   #No.TQC-A70017
    #END IF 
    #FUN-B10049--begin 
    CASE
        WHEN SQLCA.SQLCODE = 100
             LET g_errno='mfg9086'
        WHEN l_aagacti='N'
             LET g_errno='9028'
        WHEN l_aag07='1'
             LET g_errno='agl-134' 
        OTHERWISE
        LET g_errno=SQLCA.sqlcode USING '----------'
    END CASE        
    #FUN-B10049--end
END FUNCTION

FUNCTION i603_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i603_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i603_count
    FETCH i603_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i603_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecc.ecc01,SQLCA.sqlcode,0)
        INITIALIZE g_ecc.* TO NULL
    ELSE
        CALL i603_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i603_fetch(p_flecc)
    DEFINE
        p_flecc         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER
 
    CASE p_flecc
        WHEN 'N' FETCH NEXT     i603_cs INTO g_ecc.ecc01
        WHEN 'P' FETCH PREVIOUS i603_cs INTO g_ecc.ecc01
        WHEN 'F' FETCH FIRST    i603_cs INTO g_ecc.ecc01
        WHEN 'L' FETCH LAST     i603_cs INTO g_ecc.ecc01
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso i603_cs INTO g_ecc.ecc01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecc.ecc01,SQLCA.sqlcode,0)
        INITIALIZE g_ecc.* TO NULL              #No.FUN-6A0039
        RETURN
    ELSE
       CASE p_flecc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ecc.* FROM ecc_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ecc01 = g_ecc.ecc01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ecc.ecc01,SQLCA.sqlcode,0) #No.FUN-660091
        CALL cl_err3("sel","ecc_file",g_ecc.ecc01,"",SQLCA.sqlcode,"","",1) #FUN-660091
        INITIALIZE g_ecc.* TO NULL              #No.FUN-6A0039
   ELSE
        LET g_data_owner = g_ecc.eccuser      #FUN-4C0034
        LET g_data_group = g_ecc.eccgrup      #FUN-4C0034
        CALL i603_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i603_show()
    LET g_ecc_t.* = g_ecc.*
    IF g_flag='N' THEN
       SELECT eca02 INTO g_eca02
         FROM eca_file
        WHERE eca01 = g_ecc.ecc01
    END IF
    DISPLAY g_eca02 TO eca02
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_ecc.*
    DISPLAY BY NAME g_ecc.ecc01,g_ecc.ecc02, g_ecc.ecc03,g_ecc.ecc04,g_ecc.ecc05,g_ecc.eccuser,
                    g_ecc.eccgrup,g_ecc.eccdate,g_ecc.eccacti,g_ecc.eccoriu,g_ecc.eccorig
    #No.FUN-9A0024--end 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i603_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ecc.ecc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ecc.eccacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ecc.ecc01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ecc01_t = g_ecc.ecc01
    BEGIN WORK
 
    OPEN i603_cl USING g_ecc.ecc01
    IF STATUS THEN
       CALL cl_err("OPEN i603_cl:", STATUS, 1)
       CLOSE i603_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i603_cl INTO g_ecc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecc.ecc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_ecc.eccmodu=g_user                     #修改者
    LET g_ecc.eccdate = g_today                  #修改日期
    CALL i603_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i603_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ecc.*=g_ecc_t.*
            CALL i603_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ecc_file SET ecc_file.* = g_ecc.*    # 更新DB
            WHERE ecc01 = g_ecc.ecc01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ecc.ecc01,SQLCA.sqlcode,0) #No.FUN-660091
            CALL cl_err3("upd","ecc_file",g_ecc01_t,"",SQLCA.sqlcode,"","",1) #FUN-660091
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i603_cl
    COMMIT WORK
END FUNCTION
#No.FUN-570110 --start--
FUNCTION i603_set_entry(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ecc01",TRUE)
  END IF
 
END FUNCTION
 
 
FUNCTION i603_set_no_entry(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ecc01",FALSE)
   END IF
 
END FUNCTION
#No.FUN-570110 --end--
 
#Patch....NO.TQC-610035 <001> #
