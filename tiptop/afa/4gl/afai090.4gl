# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afai090.4gl
# Descriptions...: 資產異動預設科目維護作業
# Date & Author..: 97/01/04 By Apple
# Modify.........: No.8720 03/11/13 By Kitty 改錯誤訊息代號
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470515 04/07/26 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-660007 06/06/06 By Smapmin 開放減值準備為可輸入
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-740026 07/04/10 By mike    會計科目加帳套
# Modify.........: No.FUN-740020 07/04/12 By mike    會計科目加帳套
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: NO:FUN-B90096 11/11/03 By Sakura 所有傳入aza82的地方，全改為g_faa.faa02c
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fbz   RECORD LIKE fbz_file.*,
    g_fbz_t RECORD LIKE fbz_file.*,
    g_fbz_o RECORD LIKE fbz_file.*,
    g_dbs_gl       LIKE type_file.chr21,        #No.FUN-680070 VARCHAR(21)
    g_wc,g_sql     STRING,                      #No.FUN-580092 HCN
    g_aag02        LIKE aag_file.aag02
 
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_forupd_sql STRING
 
DEFINE g_msg               LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
MAIN
#    DEFINE l_time          LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
    DEFINE p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_plant_new = g_faa.faa02p
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
    LET p_row = 4 LET p_col = 17
    OPEN WINDOW i090_w AT p_row,p_col
        WITH FORM "afa/42f/afai090" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    #No.FUN-680028 --begin
 #  IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
       CALL cl_set_comp_visible("page02",TRUE)
    ELSE
       CALL cl_set_comp_visible("page02",FALSE)
    END IF
    #No.FUN-680028 --end
    CALL i090_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i090_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i090_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
END MAIN
 
FUNCTION i090_show()
DEFINE l_chr LIKE type_file.num5         #No.FUN-680070 SMALLINT
    SELECT * INTO g_fbz.* FROM fbz_file WHERE fbz00 = '0'
##No.2911 modify 1998/12/09
    IF SQLCA.SQLCODE THEN
       LET g_fbz.fbz00   = '0'
       LET g_fbz.fbzacti = 'Y'  
       LET g_fbz.fbzuser = g_user
       LET g_fbz.fbzgrup = g_grup
       LET g_fbz.fbzdate = g_today
       IF SQLCA.SQLCODE THEN
          LET g_fbz.fbzoriu = g_user      #No.FUN-980030 10/01/04
          LET g_fbz.fbzorig = g_grup      #No.FUN-980030 10/01/04
          INSERT INTO fbz_file VALUES(g_fbz.*)
          IF SQLCA.SQLCODE THEN
#            CALL cl_err('',SQLCA.sqlcode,0)    #No.FUN-660136
             CALL cl_err3("ins","fbz_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-660136
             RETURN
          END IF
       ELSE
          UPDATE fbz_file SET fbz_file.* = g_fbz.* 
              WHERE fbz00 = '0' 
          IF SQLCA.SQLCODE THEN
#            CALL cl_err('',SQLCA.sqlcode,0)    #No.FUN-660136
             CALL cl_err3("upd","fbz_file","","",SQLCA.sqlcode,"","",1)   #No.FUN-660136
             RETURN
          END IF
       END IF
#No.FUN-660136 --Begin--
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err('',SQLCA.sqlcode,0)
#         RETURN
#      END IF
#No.FUN-660136 --End--
    END IF
##----------------------------------
    DISPLAY BY NAME g_fbz.fbz05,g_fbz.fbz06,g_fbz.fbz07,
                    g_fbz.fbz08,g_fbz.fbz09,g_fbz.fbz10,
                    g_fbz.fbz11,g_fbz.fbz12,g_fbz.fbz13,
                    g_fbz.fbz14,g_fbz.fbz15,g_fbz.fbz16,
                    g_fbz.fbz17,g_fbz.fbz18,                      #No:A099
                    #No.FUN-680028 --begin
                    g_fbz.fbz051,g_fbz.fbz061,g_fbz.fbz071,
                    g_fbz.fbz081,g_fbz.fbz091,g_fbz.fbz101,
                    g_fbz.fbz111,g_fbz.fbz121,g_fbz.fbz131,
                    g_fbz.fbz141,g_fbz.fbz151,g_fbz.fbz161,
                    g_fbz.fbz171,g_fbz.fbz181,                      #No:A099
                    #No.FUN-680028 --end
                    g_fbz.fbzuser,g_fbz.fbzgrup,g_fbz.fbzdate,
                    g_fbz.fbzacti,g_fbz.fbzmodu
                    
    CALL i090_actchk(g_fbz.fbz05,g_aza.aza81) DISPLAY g_aag02 TO fbz05_act                #No.FUN-740026
    CALL i090_actchk(g_fbz.fbz06,g_aza.aza81) DISPLAY g_aag02 TO fbz06_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz07,g_aza.aza81) DISPLAY g_aag02 TO fbz07_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz08,g_aza.aza81) DISPLAY g_aag02 TO fbz08_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz09,g_aza.aza81) DISPLAY g_aag02 TO fbz09_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz10,g_aza.aza81) DISPLAY g_aag02 TO fbz10_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz11,g_aza.aza81) DISPLAY g_aag02 TO fbz11_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz12,g_aza.aza81) DISPLAY g_aag02 TO fbz12_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz13,g_aza.aza81) DISPLAY g_aag02 TO fbz13_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz14,g_aza.aza81) DISPLAY g_aag02 TO fbz14_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz15,g_aza.aza81) DISPLAY g_aag02 TO fbz15_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz16,g_aza.aza81) DISPLAY g_aag02 TO fbz16_act                #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz17,g_aza.aza81) DISPLAY g_aag02 TO fbz17_act      #No:A099  #No.FUN-740026 
    CALL i090_actchk(g_fbz.fbz18,g_aza.aza81) DISPLAY g_aag02 TO fbz18_act      #No:A099  #No.FUN-740026 
	##FUN-B90096----------mark-------str
    #No.FUN-680028 --begin
    #CALL i090_actchk(g_fbz.fbz051,g_aza.aza82) DISPLAY g_aag02 TO fbz051_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz061,g_aza.aza82) DISPLAY g_aag02 TO fbz061_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz071,g_aza.aza82) DISPLAY g_aag02 TO fbz071_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz081,g_aza.aza82) DISPLAY g_aag02 TO fbz081_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz091,g_aza.aza82) DISPLAY g_aag02 TO fbz091_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz101,g_aza.aza82) DISPLAY g_aag02 TO fbz101_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz111,g_aza.aza82) DISPLAY g_aag02 TO fbz111_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz121,g_aza.aza82) DISPLAY g_aag02 TO fbz121_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz131,g_aza.aza82) DISPLAY g_aag02 TO fbz131_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz141,g_aza.aza82) DISPLAY g_aag02 TO fbz141_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz151,g_aza.aza82) DISPLAY g_aag02 TO fbz151_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz161,g_aza.aza82) DISPLAY g_aag02 TO fbz161_act              #No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz171,g_aza.aza82) DISPLAY g_aag02 TO fbz171_act      #No:A099#No.FUN-740026 
    #CALL i090_actchk(g_fbz.fbz181,g_aza.aza82) DISPLAY g_aag02 TO fbz181_act      #No:A099#No.FUN-740026 
    #No.FUN-680028 --end
    ##FUN-B90096----------mark-------end

    #FUN-B90096----------add-------str
    CALL i090_actchk(g_fbz.fbz051,g_faa.faa02c) DISPLAY g_aag02 TO fbz051_act
    CALL i090_actchk(g_fbz.fbz061,g_faa.faa02c) DISPLAY g_aag02 TO fbz061_act
    CALL i090_actchk(g_fbz.fbz071,g_faa.faa02c) DISPLAY g_aag02 TO fbz071_act
    CALL i090_actchk(g_fbz.fbz081,g_faa.faa02c) DISPLAY g_aag02 TO fbz081_act
    CALL i090_actchk(g_fbz.fbz091,g_faa.faa02c) DISPLAY g_aag02 TO fbz091_act
    CALL i090_actchk(g_fbz.fbz101,g_faa.faa02c) DISPLAY g_aag02 TO fbz101_act
    CALL i090_actchk(g_fbz.fbz111,g_faa.faa02c) DISPLAY g_aag02 TO fbz111_act
    CALL i090_actchk(g_fbz.fbz121,g_faa.faa02c) DISPLAY g_aag02 TO fbz121_act
    CALL i090_actchk(g_fbz.fbz131,g_faa.faa02c) DISPLAY g_aag02 TO fbz131_act
    CALL i090_actchk(g_fbz.fbz141,g_faa.faa02c) DISPLAY g_aag02 TO fbz141_act
    CALL i090_actchk(g_fbz.fbz151,g_faa.faa02c) DISPLAY g_aag02 TO fbz151_act
    CALL i090_actchk(g_fbz.fbz161,g_faa.faa02c) DISPLAY g_aag02 TO fbz161_act
    CALL i090_actchk(g_fbz.fbz171,g_faa.faa02c) DISPLAY g_aag02 TO fbz171_act
    CALL i090_actchk(g_fbz.fbz181,g_faa.faa02c) DISPLAY g_aag02 TO fbz181_act
    #FUN-B90096----------add-------end
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i090_menu()
    MENU ""
    ON ACTION modify 
       LET g_action_choice = "modify"
       IF cl_chk_act_auth() THEN 
          CALL i090_u()
       END IF 
 
     ON ACTION related_document    #No.MOD-470515 
       LET g_action_choice="related_document"
       IF cl_chk_act_auth() THEN
          IF g_fbz.fbz00 IS NOT NULL THEN 
             LET g_doc.column1 = "fbz00"
             LET g_doc.value1 = g_fbz.fbz00
             CALL cl_doc()
          END IF
       END IF
 
    ON ACTION help
       CALL cl_show_help()

        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
   
    
FUNCTION i090_u()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_forupd_sql = "SELECT * FROM fbz_file WHERE fbz00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE fbz_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN fbz_curl 
    FETCH fbz_curl INTO g_fbz.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF
    LET g_fbz_t.* = g_fbz.*
    LET g_fbz_o.* = g_fbz.*
    LET g_fbz.fbzmodu=g_user    #資料所有者
    LET g_fbz.fbzgrup=g_grup    #資料所有者所屬群
    #LET g_fbz.fbzmodu=NULL      #資料修改日期
    LET g_fbz.fbzdate=g_today   #資料建立日期
    LET g_fbz.fbzacti='Y'       #有效資料
    DISPLAY BY NAME g_fbz.fbz05,g_fbz.fbz06,g_fbz.fbz07,
                    g_fbz.fbz08,g_fbz.fbz09,g_fbz.fbz10,
                    g_fbz.fbz11, g_fbz.fbz12,g_fbz.fbz13,
                    g_fbz.fbz14, g_fbz.fbz15,g_fbz.fbz16,
                    g_fbz.fbz17, g_fbz.fbz18,                   #No:A099
                    #No.FUN-680028 --begin
                    g_fbz.fbz051,g_fbz.fbz061,g_fbz.fbz071,
                    g_fbz.fbz081,g_fbz.fbz091,g_fbz.fbz101,
                    g_fbz.fbz111,g_fbz.fbz121,g_fbz.fbz131,
                    g_fbz.fbz141,g_fbz.fbz151,g_fbz.fbz161,
                    g_fbz.fbz171,g_fbz.fbz181,                   #No:A099
                    #No.FUN-680028 --end
                    g_fbz.fbzuser,g_fbz.fbzgrup,g_fbz.fbzdate,
                    g_fbz.fbzacti,g_fbz.fbzmodu
                    
    WHILE TRUE
        CALL i090_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 
           CALL cl_err('',9001,0)
           LET g_fbz.* = g_fbz_t.* 
           CALL i090_show()
           EXIT WHILE
        END IF
        UPDATE fbz_file SET * = g_fbz.* WHERE fbz00='0'
        IF STATUS THEN 
#          CALL cl_err('',STATUS,0)    #No.FUN-660136
           CALL cl_err3("upd","fbz_file","","",STATUS,"","",1)   #No.FUN-660136
           CONTINUE WHILE 
        END IF
        CLOSE fbz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
   
FUNCTION i090_i()
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_actname		LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
        l_n             LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    INPUT BY NAME
        g_fbz.fbz05,g_fbz.fbz06,g_fbz.fbz07,
        g_fbz.fbz08,g_fbz.fbz09,g_fbz.fbz10,g_fbz.fbz11,g_fbz.fbz12,g_fbz.fbz13,
        g_fbz.fbz14,g_fbz.fbz15,g_fbz.fbz16,g_fbz.fbz17,g_fbz.fbz18,  #No:A099
        #No.FUN-680028 --begin
        g_fbz.fbz051,g_fbz.fbz061,g_fbz.fbz071,
        g_fbz.fbz081,g_fbz.fbz091,g_fbz.fbz101,g_fbz.fbz111,g_fbz.fbz121,g_fbz.fbz131,
        g_fbz.fbz141,g_fbz.fbz151,g_fbz.fbz161,g_fbz.fbz171,g_fbz.fbz181,  #No:A099
        #No.FUN-680028 --end
        g_fbz.fbzuser,g_fbz.fbzgrup,g_fbz.fbzmodu,g_fbz.fbzdate,g_fbz.fbzacti
        WITHOUT DEFAULTS  
 
        #No:A099
        BEFORE INPUT 
           LET g_before_input_done = FALSE
           CALL i090_set_entry()
           CALL i090_set_no_entry()
           LET g_before_input_done = TRUE
        #end No:A099
 
        AFTER FIELD fbz05
          IF NOT cl_null(g_fbz.fbz05) THEN 
             CALL i090_fbz05(g_fbz.fbz05,g_aza.aza81)  #No.FUN-740020
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz05  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz05 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz05
                 DISPLAY BY NAME g_fbz.fbz05  
                 #FUN-B10049--end                     
                 NEXT FIELD fbz05
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz05_act
             END IF
          END IF
 
        AFTER FIELD fbz06
          IF NOT cl_null(g_fbz.fbz06) THEN 
             CALL i090_fbz05(g_fbz.fbz06,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz06  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz06 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz06
                 DISPLAY BY NAME g_fbz.fbz06  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz06
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz06_act
             END IF
          END IF
 
        AFTER FIELD fbz07
          IF NOT cl_null(g_fbz.fbz07) THEN 
             CALL i090_fbz05(g_fbz.fbz07,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz07  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz07 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz07
                 DISPLAY BY NAME g_fbz.fbz07  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz07
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz07_act
             END IF
          END IF
 
        AFTER FIELD fbz08
          IF NOT cl_null(g_fbz.fbz08) THEN 
             CALL i090_fbz05(g_fbz.fbz08,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz08  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz08 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz08
                 DISPLAY BY NAME g_fbz.fbz08  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz08
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz08_act
             END IF
          END IF
 
        AFTER FIELD fbz09
          IF NOT cl_null(g_fbz.fbz09) THEN 
             CALL i090_fbz05(g_fbz.fbz09,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz09  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz09 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz09
                 DISPLAY BY NAME g_fbz.fbz09  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz09
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz09_act
             END IF
          END IF
 
        AFTER FIELD fbz10
          IF NOT cl_null(g_fbz.fbz10) THEN 
             CALL i090_fbz05(g_fbz.fbz10,g_aza.aza81) #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz10  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz10 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz10
                 DISPLAY BY NAME g_fbz.fbz10  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz10
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz10_act
             END IF
          END IF
 
        AFTER FIELD fbz11
          IF NOT cl_null(g_fbz.fbz11) THEN 
             CALL i090_fbz05(g_fbz.fbz11,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz11  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz11 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz11
                 DISPLAY BY NAME g_fbz.fbz11  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz11
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz11_act
             END IF
          END IF
 
        AFTER FIELD fbz12
          IF NOT cl_null(g_fbz.fbz12) THEN 
             CALL i090_fbz05(g_fbz.fbz12,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz12  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz12 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz12
                 DISPLAY BY NAME g_fbz.fbz12  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz12
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz12_act
             END IF
          END IF
 
        AFTER FIELD fbz13
          IF NOT cl_null(g_fbz.fbz13) THEN 
             CALL i090_fbz05(g_fbz.fbz13,g_aza.aza81) #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz13  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz13 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz13
                 DISPLAY BY NAME g_fbz.fbz13  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz13
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz13_act
             END IF
          END IF
 
        AFTER FIELD fbz14
          IF NOT cl_null(g_fbz.fbz14) THEN 
             CALL i090_fbz05(g_fbz.fbz14,g_aza.aza81) #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz14  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz14 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz14
                 DISPLAY BY NAME g_fbz.fbz14  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz14
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz14_act
             END IF
          END IF
 
        AFTER FIELD fbz15
          IF NOT cl_null(g_fbz.fbz15) THEN 
             CALL i090_fbz05(g_fbz.fbz15,g_aza.aza81) #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz15  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz15 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz15
                 DISPLAY BY NAME g_fbz.fbz15  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz15
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz15_act
             END IF
          END IF
 
        AFTER FIELD fbz16
          IF NOT cl_null(g_fbz.fbz16) THEN 
             CALL i090_fbz05(g_fbz.fbz16,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz16  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz16 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz16
                 DISPLAY BY NAME g_fbz.fbz16  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz16
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz16_act
             END IF
          END IF
 
        #No:A099
        AFTER FIELD fbz17
          IF NOT cl_null(g_fbz.fbz17) THEN 
             CALL i090_fbz05(g_fbz.fbz17,g_aza.aza81)  #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz17  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz17 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz17
                 DISPLAY BY NAME g_fbz.fbz17  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz17
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz17_act
             END IF
          END IF
 
        AFTER FIELD fbz18
          IF NOT cl_null(g_fbz.fbz18) THEN 
             CALL i090_fbz05(g_fbz.fbz18,g_aza.aza81) #No.FUN-740020 
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz18  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz18 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz18
                 DISPLAY BY NAME g_fbz.fbz18  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz18
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz18_act
             END IF
          END IF
        #end No:A099
        AFTER FIELD fbz051
          IF NOT cl_null(g_fbz.fbz051) THEN 
            #CALL i090_fbz05(g_fbz.fbz051,g_aza.aza82)  #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz051,g_faa.faa02c)  #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz051  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz051 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz051
                 DISPLAY BY NAME g_fbz.fbz051  
                 #FUN-B10049--end                  
                 NEXT FIELD fbz051
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz051_act
             END IF
          END IF
 
        AFTER FIELD fbz061
          IF NOT cl_null(g_fbz.fbz061) THEN 
             #CALL i090_fbz05(g_fbz.fbz061,g_aza.aza82)  #No.FUN-740020 #FUN-B90096 mark 
			  CALL i090_fbz05(g_fbz.fbz061,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz061  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz061 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz061
                 DISPLAY BY NAME g_fbz.fbz061  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz061
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz061_act
             END IF
          END IF
 
        AFTER FIELD fbz071
          IF NOT cl_null(g_fbz.fbz071) THEN 
            #CALL i090_fbz05(g_fbz.fbz071,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
             CALL i090_fbz05(g_fbz.fbz071,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz071  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz071 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz071
                 DISPLAY BY NAME g_fbz.fbz071  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz071
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz071_act
             END IF
          END IF
 
        AFTER FIELD fbz081
          IF NOT cl_null(g_fbz.fbz081) THEN 
            #CALL i090_fbz05(g_fbz.fbz081,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz081,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz081  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz081 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz081
                 DISPLAY BY NAME g_fbz.fbz081  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz081
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz081_act
             END IF
          END IF
 
        AFTER FIELD fbz091
          IF NOT cl_null(g_fbz.fbz091) THEN 
            #CALL i090_fbz05(g_fbz.fbz091,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz091,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz091  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz091 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz091
                 DISPLAY BY NAME g_fbz.fbz091  
                 #FUN-B10049--end                   
                 NEXT FIELD fbz091
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz091_act
             END IF
          END IF
 
        AFTER FIELD fbz101
          IF NOT cl_null(g_fbz.fbz101) THEN 
            #CALL i090_fbz05(g_fbz.fbz101,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz101,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz101  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz101 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz101
                 DISPLAY BY NAME g_fbz.fbz101  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz101
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz101_act
             END IF
          END IF
 
        AFTER FIELD fbz111
          IF NOT cl_null(g_fbz.fbz111) THEN 
            #CALL i090_fbz05(g_fbz.fbz111,g_aza.aza82)  #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz111,g_faa.faa02c)  #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz111  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz111 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz111
                 DISPLAY BY NAME g_fbz.fbz111  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz111
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz111_act
             END IF
          END IF
 
        AFTER FIELD fbz121
          IF NOT cl_null(g_fbz.fbz121) THEN 
            #CALL i090_fbz05(g_fbz.fbz121,g_aza.aza82)  #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz121,g_faa.faa02c)  #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz121  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz121 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz121
                 DISPLAY BY NAME g_fbz.fbz121  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz121
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz121_act
             END IF
          END IF
 
        AFTER FIELD fbz131
          IF NOT cl_null(g_fbz.fbz131) THEN 
            #CALL i090_fbz05(g_fbz.fbz131,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz131,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz131  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz131 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz131
                 DISPLAY BY NAME g_fbz.fbz131  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz131
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz131_act
             END IF
          END IF
 
        AFTER FIELD fbz141
          IF NOT cl_null(g_fbz.fbz141) THEN 
            #CALL i090_fbz05(g_fbz.fbz141,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz141,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz141  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz141 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz141
                 DISPLAY BY NAME g_fbz.fbz141  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz141
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz141_act
             END IF
          END IF
 
        AFTER FIELD fbz151
          IF NOT cl_null(g_fbz.fbz151) THEN 
            #CALL i090_fbz05(g_fbz.fbz151,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz151,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz151  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz151 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz151
                 DISPLAY BY NAME g_fbz.fbz151  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz151
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz151_act
             END IF
          END IF
 
        AFTER FIELD fbz161
          IF NOT cl_null(g_fbz.fbz161) THEN 
            #CALL i090_fbz05(g_fbz.fbz161,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz161,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz161  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz161 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz161
                 DISPLAY BY NAME g_fbz.fbz161  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz161
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz161_act
             END IF
          END IF
 
        #No:A099
        AFTER FIELD fbz171
          IF NOT cl_null(g_fbz.fbz171) THEN 
            #CALL i090_fbz05(g_fbz.fbz171,g_aza.aza82) #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz171,g_faa.faa02c) #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz171  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz171 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz171
                 DISPLAY BY NAME g_fbz.fbz171  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz171
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz171_act
             END IF
          END IF
 
        AFTER FIELD fbz181
          IF NOT cl_null(g_fbz.fbz181) THEN 
            #CALL i090_fbz05(g_fbz.fbz181,g_aza.aza82)  #No.FUN-740020 #FUN-B90096 mark 
			 CALL i090_fbz05(g_fbz.fbz181,g_faa.faa02c)  #FUN-B90096 add
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_fbz.fbz181  
                 LET g_qryparam.construct = 'N'                
                #LET g_qryparam.arg1 = g_aza.aza82 #FUN-B90096 mark
                 LET g_qryparam.arg1 = g_faa.faa02c #FUN-B90096 add  
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_fbz.fbz181 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_fbz.fbz181
                 DISPLAY BY NAME g_fbz.fbz181  
                 #FUN-B10049--end                      
                 NEXT FIELD fbz181
             ELSE
                 DISPLAY g_aag02 TO FORMONLY.fbz181_act
             END IF
          END IF
       #No.FUN-680028 --end
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF INT_FLAG THEN EXIT INPUT  END IF
 
        #ON KEY(CONTROL-P)
        ON ACTION controlp
           CASE
              WHEN INFIELD(fbz05)
                #   CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz05,'23')
                #        RETURNING g_fbz.fbz05
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz05
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz05
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz05 )
                   DISPLAY BY NAME g_fbz.fbz05 
                   NEXT FIELD fbz05
              WHEN INFIELD(fbz06)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz06,'23')
                   #     RETURNING g_fbz.fbz06
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz06
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz06
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz06 )
                   DISPLAY BY NAME g_fbz.fbz06 
                   NEXT FIELD fbz06
              WHEN INFIELD(fbz07)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz07,'23')
                   #     RETURNING g_fbz.fbz07
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz07
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz07
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz07 )
                   DISPLAY BY NAME g_fbz.fbz07 NEXT FIELD fbz07
              WHEN INFIELD(fbz08)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz08,'23')
                   #     RETURNING g_fbz.fbz08
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz08
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz08
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz08 )
                   DISPLAY BY NAME g_fbz.fbz08 NEXT FIELD fbz08
              WHEN INFIELD(fbz09)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz09,'23')
                   #     RETURNING g_fbz.fbz09
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz09
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz09
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz09 )
                   DISPLAY BY NAME g_fbz.fbz09 NEXT FIELD fbz09
              WHEN INFIELD(fbz10)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz10,'23')
                   #     RETURNING g_fbz.fbz10
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz10
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz10
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz10 )
                   DISPLAY BY NAME g_fbz.fbz10 NEXT FIELD fbz10
              WHEN INFIELD(fbz11)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz11,'23')
                   #     RETURNING g_fbz.fbz11
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz11
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz11
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz11 )
                   DISPLAY BY NAME g_fbz.fbz11 NEXT FIELD fbz11
              WHEN INFIELD(fbz12)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz12,'23')
                   #     RETURNING g_fbz.fbz12
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz12
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz12
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz12 )
                   DISPLAY BY NAME g_fbz.fbz12 NEXT FIELD fbz12
              WHEN INFIELD(fbz13)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz13,'23')
                   #     RETURNING g_fbz.fbz13
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz13
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz13
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz13 )
                   DISPLAY BY NAME g_fbz.fbz13 NEXT FIELD fbz13
              WHEN INFIELD(fbz14)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz14,'23')
                   #     RETURNING g_fbz.fbz14
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz14
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz14
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz14 )
                   DISPLAY BY NAME g_fbz.fbz14 NEXT FIELD fbz14
              WHEN INFIELD(fbz15)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz15,'23')
                   #     RETURNING g_fbz.fbz15
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz15
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz15
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz15 )
                   DISPLAY BY NAME g_fbz.fbz15 NEXT FIELD fbz15
              WHEN INFIELD(fbz16)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz16,'23')
                   #     RETURNING g_fbz.fbz16
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz16
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz16
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz16 )
                   DISPLAY BY NAME g_fbz.fbz16 NEXT FIELD fbz16
              #No:A099
              WHEN INFIELD(fbz17)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz17
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz17
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz17 )
                   DISPLAY BY NAME g_fbz.fbz17 NEXT FIELD fbz17
              WHEN INFIELD(fbz18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz18
                   LET g_qryparam.arg1 = g_aza.aza81              #No.FUN-740026 
                   CALL cl_create_qry() RETURNING g_fbz.fbz18
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz18 )
                   DISPLAY BY NAME g_fbz.fbz18 NEXT FIELD fbz18
              #end No:A099
              #No.FUN-680028 --begin
              WHEN INFIELD(fbz051)
                #   CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz05,'23')
                #        RETURNING g_fbz.fbz05
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz051
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark 
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz051
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz051 )
                   DISPLAY BY NAME g_fbz.fbz051
                   NEXT FIELD fbz051
              WHEN INFIELD(fbz061)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz06,'23')
                   #     RETURNING g_fbz.fbz061
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz061
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c             #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz061
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz061 )
                   DISPLAY BY NAME g_fbz.fbz061 
                   NEXT FIELD fbz061
              WHEN INFIELD(fbz071)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz07,'23')
                   #     RETURNING g_fbz.fbz07
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz071
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz071
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz07 )
                   DISPLAY BY NAME g_fbz.fbz071 NEXT FIELD fbz071
              WHEN INFIELD(fbz081)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz08,'23')
                   #     RETURNING g_fbz.fbz08
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz081
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz081
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz081 )
                   DISPLAY BY NAME g_fbz.fbz081 NEXT FIELD fbz081
              WHEN INFIELD(fbz091)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz09,'23')
                   #     RETURNING g_fbz.fbz09
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz091
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c             #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz091
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz091 )
                   DISPLAY BY NAME g_fbz.fbz091 NEXT FIELD fbz091
              WHEN INFIELD(fbz101)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz10,'23')
                   #     RETURNING g_fbz.fbz10
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz101
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz101
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz101 )
                   DISPLAY BY NAME g_fbz.fbz101 NEXT FIELD fbz101
              WHEN INFIELD(fbz111)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz11,'23')
                   #     RETURNING g_fbz.fbz11
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz111
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz111
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz111 )
                   DISPLAY BY NAME g_fbz.fbz111 NEXT FIELD fbz111
              WHEN INFIELD(fbz121)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz12,'23')
                   #     RETURNING g_fbz.fbz12
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz121
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz121
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz121 )
                   DISPLAY BY NAME g_fbz.fbz121 NEXT FIELD fbz121
              WHEN INFIELD(fbz131)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz13,'23')
                   #     RETURNING g_fbz.fbz13
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz131
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz131
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz131 )
                   DISPLAY BY NAME g_fbz.fbz131 NEXT FIELD fbz131
              WHEN INFIELD(fbz141)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz14,'23')
                   #     RETURNING g_fbz.fbz14
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz141
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz141
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz141 )
                   DISPLAY BY NAME g_fbz.fbz141 NEXT FIELD fbz141
              WHEN INFIELD(fbz151)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz15,'23')
                   #     RETURNING g_fbz.fbz15
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz151
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz151
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz151 )
                   DISPLAY BY NAME g_fbz.fbz151 NEXT FIELD fbz151
              WHEN INFIELD(fbz161)
                   #CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_fbz.fbz16,'23')
                   #     RETURNING g_fbz.fbz16
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz161
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz161
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz161 )
                   DISPLAY BY NAME g_fbz.fbz161 NEXT FIELD fbz161
              #No:A099
              WHEN INFIELD(fbz171)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz171
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz171
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz171 )
                   DISPLAY BY NAME g_fbz.fbz171 NEXT FIELD fbz171
              WHEN INFIELD(fbz181)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_aag"
                   LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                   LET g_qryparam.default1 = g_fbz.fbz181
                  #LET g_qryparam.arg1 = g_aza.aza82              #No.FUN-740026 #FUN-B90096 mark
				   LET g_qryparam.arg1 = g_faa.faa02c              #FUN-B90096 add
                   CALL cl_create_qry() RETURNING g_fbz.fbz181
#                   CALL FGL_DIALOG_SETBUFFER( g_fbz.fbz181 )
                   DISPLAY BY NAME g_fbz.fbz181 NEXT FIELD fbz181
              #No.FUN-680028 --end
              OTHERWISE EXIT CASE
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
END FUNCTION
   
FUNCTION i090_fbz05(p_code,p_bookno)  #No.FUN-740020 
  DEFINE p_code     LIKE aag_file.aag01  
  DEFINE p_bookno   LIKE aag_file.aag00  #No.FUN-740020 
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07  
  DEFINE l_aag09    LIKE aag_file.aag09  
  DEFINE l_aag03    LIKE aag_file.aag03  
 
   LET g_aag02 = ''     #No:A099
   SELECT aag02,aag03,aag07,aag09,aagacti
     INTO g_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
     FROM aag_file
    WHERE aag01=p_code  
    AND   aag00=p_bookno     #No.FUN-740026     #No.FUN-740020 
   CASE WHEN STATUS=100         LET g_errno = 'agl-001'  #No.7926 #No:8720
        WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015' 
         WHEN l_aag03  = '4'      LET g_errno = 'agl-177' 
         WHEN l_aag09  = 'N'      LET g_errno = 'agl-214' 
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
END FUNCTION
 
FUNCTION i090_actchk(actno,p_bookno)                #No.FUN-740026 
DEFINE actno		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(24)
DEFINE p_bookno         LIKE aag_file.aag00         #No.FUN-740026
	LET g_aag02 = NULL    #No:A099
        SELECT aag02 INTO g_aag02 FROM aag_file
         WHERE aag01=actno
          AND  aag00=p_bookno                       #No.FUN-740026 
END FUNCTION
 
#No:A099
FUNCTION i090_set_entry() 
  
    IF (NOT g_before_input_done) THEN 
        #CALL cl_set_comp_entry("fbz17,fbz18",TRUE)   #MOD-660007
        CALL cl_set_comp_entry("fbz18",TRUE)   #MOD-660007
    END IF
END FUNCTION
#end No:A099
 
#No:A099
FUNCTION i090_set_no_entry() 
 
    IF g_aza.aza26 != '2' THEN  
       #CALL cl_set_comp_entry("fbz17,fbz18",FALSE)   #MOD-660007
       CALL cl_set_comp_entry("fbz18",FALSE)   #MOD-660007
    END IF
END FUNCTION
#end No:A099
