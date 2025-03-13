# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: sapmt582.4gl
# Descriptions...: 無交期採購單－廠商資料維護作業
# Date & Author..: 92/11/24 By Apple
# Modify.........: 01/03/30 By Kammy
# Modify.........: No.MOD-4B0255 04/11/26 By Mandy 串apmi600/apmq210/apmq220時,可針對供應商顯示相關的資料,如果供應商空白則可查詢全部的資料
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-690024 06/09/15 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/15 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti 
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6C0043 06/12/12 By ray 1.在“供應商資料”中按確定后報錯
#                                                2.采購狀況查詢無法查詢采購情況
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pom        RECORD LIKE pom_file.*,
    g_pom_t      RECORD LIKE pom_file.*,
    g_pom_o      RECORD LIKE pom_file.*,
    g_pom01_t    LIKE pom_file.pom01,
    g_pmc05      LIKE pmc_file.pmc05,
    g_cmd        LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(100)
    g_argv1      LIKE pom_file.pom01
DEFINE   g_chr   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt   LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_msg   LIKE ze_file.ze03            #No.FUN-680136 VARCHAR(72)

FUNCTION t582(g_argv2,p_pom01)
DEFINE
    p_pom01      LIKE pom_file.pom01,   
    g_argv2      LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    l_sw         LIKE type_file.num5,         #No.FUN-680136 SMALLINT
    l_chr        LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)

    WHENEVER ERROR CONTINUE
 
    INITIALIZE g_pom.* TO NULL
    INITIALIZE g_pom_t.* TO NULL
    INITIALIZE g_pom_o.* TO NULL
    LET g_argv1 = p_pom01 

    OPEN WINDOW t582_w WITH FORM "apm/42f/apmt582" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt582")
 
    SELECT * INTO  g_pom.* FROM pom_file WHERE pom01 = p_pom01
    IF SQLCA.sqlcode THEN  
#      CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)   #No.FUN-660129
       CALL cl_err3("sel","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t582_show()
    LET l_sw = 0
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF (g_argv2 = '0' and g_pom.pom25 not matches'[1269]')
       OR (g_argv2 = '0' and g_pom.pommksg ='N' and 
           g_pom.pom25 not matches'[269]')
    THEN 
       CALL t582_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pom.pom25 not matches'[269]' THEN 
       CALL t582_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(結案/取消)的資料無修改權限 1993/01/14 pin modify
    IF g_argv2 = '2' and g_pom.pom25 not matches'[69]' THEN 
       CALL t582_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    IF NOT l_sw THEN 
       CALL cl_getmsg('mfg6012',g_lang) RETURNING g_msg
       WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED FOR l_chr   
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
#                CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          
          END PROMPT
             IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
             EXIT WHILE 
       END WHILE
    END IF
    CLOSE WINDOW t582_w
END FUNCTION
 
FUNCTION t582_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(100)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    INPUT BY NAME
        g_pom.pom09,g_pom.pom10,g_pom.pom11
        WITHOUT DEFAULTS 
 
        AFTER FIELD pom09  #供應廠商, 可空白, 須存在
           IF cl_null(g_pom.pom09) THEN             
              DISPLAY ' ' TO FORMONLY.pmc03  
              DISPLAY ' ' TO FORMONLY.pmc091 
           END IF
            IF NOT cl_null(g_pom.pom09)  THEN
                IF (g_pom_o.pom09 IS NULL) OR (g_pom_t.pom09 IS NULL) OR
                  (g_pom.pom09 != g_pom_o.pom09 ) THEN
                    CALL t582_pom09('a')
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pom.pom09,g_errno,0)
                        LET g_pom.pom09 = g_pom_o.pom09
                        DISPLAY BY NAME g_pom.pom09
                        NEXT FIELD pom09
                    END IF
                    CALL t582_pom09_cd()
                    IF NOT cl_null(g_chr) THEN 
                        LET g_pom.pom09 = g_pom_o.pom09
                        DISPLAY BY NAME g_pom.pom09
                        NEXT FIELD pom09
                    END IF
                END IF
            END IF
            LET  g_pom_o.pom09 = g_pom.pom09
 
        AFTER FIELD pom10  		        #送貨地址
            IF NOT cl_null(g_pom.pom10) THEN 
          #Modify:
             SELECT pme02 INTO g_cnt FROM pme_file 
             WHERE pme01 = g_pom.pom10 
             IF g_cnt ='1' THEN 
                CALL cl_err('此非送貨地址!!!請重新輸入..',STATUS,1) 
                NEXT FIELD pom10 
             END IF 
               IF (g_pom_o.pom10 IS NULL) OR (g_pom_o.pom10 != g_pom.pom10)
                  THEN CALL t582_add('0',g_pom.pom10)
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_pom.pom10,g_errno,0)
                          LET g_pom.pom10 = g_pom_o.pom10
                          DISPLAY BY NAME g_pom_o.pom10
                          NEXT FIELD pom10
                       END IF
               END IF
            END IF
            LET  g_pom_o.pom10 = g_pom.pom10
 
        AFTER FIELD pom11  		        #帳單地址
           IF NOT cl_null(g_pom.pom11) THEN
          #Modify:
             SELECT pme02 INTO g_cnt FROM pme_file 
             WHERE pme01 = g_pom.pom11 
             IF g_cnt ='0'  THEN 
                CALL cl_err('此非帳單地址!!!請重新輸入..',STATUS,1) 
                NEXT FIELD pom11 
             END IF 
             IF (g_pom_o.pom11 IS NULL) OR (g_pom_o.pom11 != g_pom.pom11)
                  THEN CALL t582_add('1',g_pom.pom11)
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_pom.pom11,g_errno,0)
                          LET g_pom.pom11 = g_pom_o.pom11
                          DISPLAY BY NAME g_pom_o.pom11
                          NEXT FIELD pom11
                       END IF
             END IF
           END IF
           LET g_pom_o.pom11 = g_pom.pom11
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
        ON ACTION mntn_vender #建立付款廠商檔
                   #LET g_cmd = "apmi600 ",g_pom.pom09 CLIPPED    #MOD-4B0255
                   #LET g_cmd = "apmi600 '' ",g_pom.pom09 CLIPPED #MOD-4B0255 參數傳錯
                    LET g_cmd = "apmi600    ",g_pom.pom09 CLIPPED #FUN-7C0050 參數傳錯
                   CALL cl_cmdrun(g_cmd)
 
        ON ACTION mntn_shipping_addr #建立送貨地址資料檔
                   LET g_cmd = "apmi204 ",g_pom.pom10 CLIPPED 
                   CALL cl_cmdrun(g_cmd)
 
        ON ACTION mntn_bill_addr #建立帳單地址資料檔
                   LET g_cmd = "apmi204 ",g_pom.pom11 CLIPPED 
                   CALL cl_cmdrun(g_cmd)
 
 
        ON ACTION qry_item_vender  #料件/供應商詢價查詢
                  #CALL cl_cmdrun("apmq210 ") 
                    LET g_cmd = "apmq210 '' ",g_pom.pom09 CLIPPED #MOD-4B0255 
                   CALL cl_cmdrun(g_cmd)
 
        ON ACTION qry_vender_item  #供應商/料件詢價查詢
                   CALL cl_cmdrun("apmq220 ") 
                    LET g_cmd = "apmq220 ",g_pom.pom09 CLIPPED #MOD-4B0255 
                   CALL cl_cmdrun(g_cmd)
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pom09) #查詢廠商檔
#                 CALL q_pmc1(0,0,g_pom.pom09) RETURNING g_pom.pom09
#                 CALL FGL_DIALOG_SETBUFFER( g_pom.pom09 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc1"
                  LET g_qryparam.default1 = g_pom.pom09
                  CALL cl_create_qry() RETURNING g_pom.pom09
#                  CALL FGL_DIALOG_SETBUFFER( g_pom.pom09 )
 
                  DISPLAY BY NAME g_pom.pom09 
                  CALL t582_pom09('a')
                  NEXT FIELD pom09
               WHEN INFIELD(pom10) #查詢地址資料檔 (0:表送貨地址)
#                 CALL q_pme(10,3,g_pom.pom10,0) RETURNING g_pom.pom10
#                 CALL FGL_DIALOG_SETBUFFER( g_pom.pom10 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pme"
                  LET g_qryparam.default1 = g_pom.pom10
                  CALL cl_create_qry() RETURNING g_pom.pom10
#                  CALL FGL_DIALOG_SETBUFFER( g_pom.pom10 )
 
                  DISPLAY BY NAME g_pom.pom10 
                  NEXT FIELD pom10
               WHEN INFIELD(pom11) #查詢地址資料檔 (1:表帳單地址)
#                 CALL q_pme(10,3,g_pom.pom11,1) RETURNING g_pom.pom11
#                 CALL FGL_DIALOG_SETBUFFER( g_pom.pom11 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pme"
                  LET g_qryparam.default1 = g_pom.pom11
                  CALL cl_create_qry() RETURNING g_pom.pom11
#                  CALL FGL_DIALOG_SETBUFFER( g_pom.pom11 )
 
                  DISPLAY BY NAME g_pom.pom11 
                  NEXT FIELD pom11
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
   
FUNCTION t582_pom09(p_cmd)  #供應廠商
    DEFINE p_cmd    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
           l_pmc03  LIKE pmc_file.pmc03, 
           l_pmc10  LIKE pmc_file.pmc10,
           l_pmc11  LIKE pmc_file.pmc11,
           l_pmc12  LIKE pmc_file.pmc12,
           l_pmc081 LIKE pmc_file.pmc081,
           l_pmc082 LIKE pmc_file.pmc082,
           l_pmc091 LIKE pmc_file.pmc091,
           l_pmc092 LIKE pmc_file.pmc092,
           l_pmc093 LIKE pmc_file.pmc093,
           l_pmc094 LIKE pmc_file.pmc094,
           l_pmc095 LIKE pmc_file.pmc095,
           l_pmcacti LIKE pmc_file.pmcacti
 
    LET g_errno = ' '
    SELECT pmc05,pmc03,pmc10,pmc11,pmc12,pmc081,pmc082,
           pmc091,pmc092,pmc093,pmc094,pmc095,pmcacti
      INTO g_pmc05,l_pmc03,l_pmc10,l_pmc11,l_pmc12,
           l_pmc081,l_pmc082, l_pmc091, l_pmc092,
           l_pmc093, l_pmc094, l_pmc095,l_pmcacti
      FROM pmc_file 
     WHERE pmc01 = g_pom.pom09 
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
                            LET l_pmc081 = NULL 
                            LET l_pmc082 = NULL 
                            LET l_pmc091 = NULL 
                            LET l_pmc092 = NULL 
                            LET l_pmc093 = NULL 
                            LET l_pmc094 = NULL 
                            LET l_pmc095 = NULL 
                            LET l_pmc10  = NULL
                            LET l_pmc11  = NULL LET l_pmc12  = NULL
         WHEN l_pmcacti='N' LET g_errno = '9028'
    #FUN-690024------mod-------
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690024------mod-------
 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_pmc03 TO FORMONLY.pmc03   
       DISPLAY l_pmc10 TO FORMONLY.pmc10   
       DISPLAY l_pmc11 TO FORMONLY.pmc11   
       DISPLAY l_pmc12 TO FORMONLY.pmc12   
       DISPLAY l_pmc081 TO FORMONLY.pmc081 
       DISPLAY l_pmc082 TO FORMONLY.pmc082 
       DISPLAY l_pmc091 TO FORMONLY.pmc091 
       DISPLAY l_pmc092 TO FORMONLY.pmc092 
       DISPLAY l_pmc093 TO FORMONLY.pmc093 
       DISPLAY l_pmc094 TO FORMONLY.pmc094 
       DISPLAY l_pmc095 TO FORMONLY.pmc095 
    END IF
END FUNCTION
   
FUNCTION t582_pom09_cd()    #check 廠商狀況
  DEFINE  l_chr   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
LET g_chr = " "
   CASE 
 # WHEN g_pmc05 = '1' No.FUN-690025 
   WHEN g_pmc05 = '0' 
        CALL cl_getmsg('mfg3174',g_lang) RETURNING g_msg 
        WHILE l_chr IS NULL OR l_chr NOT MATCHES'[YyNn]'
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED FOR l_chr
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
#                CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          
          END PROMPT
          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
        END WHILE
        IF l_chr MATCHES '[Nn]' THEN LET g_chr = 'e'  END IF
 # WHEN g_pmc05 = '2'  LET g_chr = 's'  No.FUN-690025
   WHEN g_pmc05 = '3'  LET g_chr = 's'         #停止
   OTHERWISE EXIT CASE
   END CASE
END FUNCTION
   
FUNCTION t582_add(p_cmd,p_code)    #check 地址
  DEFINE  p_cmd   LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          p_code  LIKE pme_file.pme01,
          l_pme02 LIKE pme_file.pme02,
          l_pmeacti LIKE pme_file.pmeacti
 
  LET g_errno = " "
  SELECT pme02,pmeacti INTO l_pme02,l_pmeacti FROM pme_file 
              WHERE pme01 = p_code 
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3012'
                        LET l_pmeacti = NULL
       WHEN l_pmeacti='N' LET g_errno = '9028'
       WHEN p_code = '0'  IF l_pme02 = '1' THEN LET g_errno = 'mfg3019' END IF
       WHEN p_code = '1'  IF l_pme02 = '0' THEN LET g_errno = 'mfg3026' END IF
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
   
FUNCTION t582_show()
# DEFINE  l_str  LIKE apm_file.apm08 	#No.FUN-680136 VARCHAR(10)  #No.TQC-6A0079
    LET g_pom_t.* = g_pom.*
    DISPLAY BY NAME g_pom.pom09,g_pom.pom10,g_pom.pom11 
    CALL t582_pom09('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t582_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pom.pom01 IS NULL THEN
        CALL cl_err('',-542,0)
        RETURN
    END IF
    IF g_pom.pomacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pom.pom01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pom01_t = g_pom.pom01
    BEGIN WORK
    WHILE TRUE
        LET g_pom_o.* = g_pom.*
        CALL t582_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pom.*=g_pom_t.*
            CALL t582_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pom_file SET pom_file.* = g_pom.*    # 更新DB
            WHERE pom01 = g_argv1               
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
