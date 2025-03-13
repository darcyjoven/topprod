# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: sapmt542.4gl
# Descriptions...: 採購單－廠商資料維護作業
# Date & Author..: 92/11/24 By Apple
# Modify.........: No.MOD-4B0255 04/11/26 By Mandy 串apmi600/apmq210/apmq220時,可針對供應商顯示相關的資料,如果供應商空白則可查詢全部的資料
# Modify.........: NO.FUN-5A0193 06/01/10 BY yiting 檢查若sfb82有值,pmm09與sfb82要一致
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/06 By Jackho 欄位類型修改
# Modify.........: No.FUN-690024 06/09/15 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/15 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti 
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-7C0018 07/12/05 By heather不需要彈出的prompt界面
# Modify.........: No.TQC-7C0112 07/12/08 By heather使彈出的prompt的界面點擊關閉按鈕可以離開
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.TQC-950082 09/05/13 By Carrier 過ora
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整argv1為pmm_file.pmm01
# Modify.........: No:TQC-C20013 12/02/02 By suncx 修改供應商時需做供應商的管控，修改完供應商需要重新取價
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmm         RECORD LIKE pmm_file.*,
    g_pmm_t       RECORD LIKE pmm_file.*,
    g_pmm_o       RECORD LIKE pmm_file.*,
    g_pmm01_t     LIKE pmm_file.pmm01,
    g_pmc05       LIKE pmc_file.pmc05,
    g_cmd         LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(100)
    g_argv1       LIKE pmm_file.pmm01,          #type_file.chr18,  	#No.FUN-680136 INTEGER FUN-A70120
    g_sfb82       LIKE sfb_file.sfb82,          #NO.FUN-5A0193 
    g_sfb100      LIKE sfb_file.sfb100          #NO.FUN-5A0193
DEFINE   g_chr    LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt    LIKE type_file.num10          #No.FUN-680136 INTEGER
DEFINE   g_msg    LIKE ze_file.ze03             #No.FUN-680136 VARCHAR(72)


FUNCTION t542(g_argv2,p_pmm01)

DEFINE 
    p_pmm01       LIKE pmm_file.pmm01,    
    g_argv2       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    l_sw          LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
    l_chr         LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)
 
    WHENEVER ERROR CONTINUE

    INITIALIZE g_pmm.* TO NULL
    INITIALIZE g_pmm_t.* TO NULL
    INITIALIZE g_pmm_o.* TO NULL
    LET g_argv1 = p_pmm01 

    OPEN WINDOW t542_w WITH FORM "apm/42f/apmt542" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt542")
 
    SELECT * INTO  g_pmm.* FROM pmm_file WHERE pmm01 = p_pmm01
    IF SQLCA.sqlcode THEN  
#      CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,0)   #No.FUN-660129
       CALL cl_err3("sel","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN 
    END IF
    CALL t542_show()
    LET l_sw = 0  
    #開立的P/R針對(已核准/已轉PO/結案/取消)的資料無修改權限
    IF (g_argv2 = '0' and g_pmm.pmm25 not matches'[1269]')
       OR (g_argv2 = '0' and g_pmm.pmmmksg ='N' and 
           g_pmm.pmm25 not matches'[269]')
    THEN 
       CALL t542_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已核准的P/R針對(已轉PO/結案/取消)的資料無修改權限
    IF g_argv2 = '1' and g_pmm.pmm25 not matches'[269]' THEN 
       CALL t542_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    #已發出的P/R針對(結案/取消)的資料無修改權限 1993/01/14 pin modify
    IF g_argv2 = '2' and g_pmm.pmm25 not matches'[69]' THEN 
       CALL t542_u()
       LET l_sw = 1
       IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    END IF
    IF NOT l_sw THEN 
        #TQC-7C0018-begin  mark
{
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
       END WHILE}
        #TQC-7C0018-end  mark
    END IF
    CALL t542_menu()#TQC-7C0018-end  add
    CLOSE WINDOW t542_w  
END FUNCTION


#TQC-7C0018-begin
FUNCTION t542_menu()
MENU ""
     ON ACTION locale
	CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   
 
     ON ACTION exit
        LET g_action_choice = "exit"
           EXIT MENU
     #TQC-7C0112-add begin
     ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145                                                       
          EXIT MENU   
     #TQC-7C0112-add end
 
    #TQC-860019-add
    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE MENU 
  
    ON ACTION about      
       CALL cl_about()     
 
    ON ACTION controlg      
       CALL cl_cmdask()    
 
    ON ACTION help         
       CALL cl_show_help()
    #TQC-860019-add
 
END MENU
END FUNCTION
#TQC-7C0018-end
FUNCTION t542_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(100)
        l_n             LIKE type_file.num5          #No.FUN-680136 SMALLINT
    #TQC-C20013 add begin-----------------------
    DEFINE l_pmn012    LIKE pmn_file.pmn012,
           l_pmn18     LIKE pmn_file.pmn18,
           l_pmn04     LIKE pmn_file.pmn04,
           l_pmn41     LIKE pmn_file.pmn41,
           l_pmn43     LIKE pmn_file.pmn43,
           l_ima915    LIKE ima_file.ima915,
           l_type      LIKE pmh_file.pmh22
    DEFINE l_cnt       LIKE type_file.num5
    DEFINE l_pmn68     LIKE pmn_file.pmn68
    DEFINE l_pom09     LIKE pom_file.pom09

    IF g_prog = 'apmt590' THEN
       LET l_type = "2"
    ELSE
       LET l_type = "1"
    END IF
    #TQC-C20013 add end-------------------------
 
    INPUT BY NAME
        g_pmm.pmm09,g_pmm.pmm10,g_pmm.pmm11
        WITHOUT DEFAULTS 
 
        #--NO.FUN-5A0193 START--
        BEFORE FIELD pmm09
           SELECT sfb82,sfb100 INTO g_sfb82,g_sfb100 
             FROM sfb_file,pmn_file 
            WHERE pmn01 = g_pmm.pmm01
              AND sfb01 = pmn41 
              AND sfb87 != 'X'      
        #--NO.FUN-5A0193 END---
 
        AFTER FIELD pmm09  #供應廠商, 可空白, 須存在
        #--NO.FUN-5A0193 START--
           IF NOT cl_null(g_sfb82) THEN
             IF g_pmm.pmm02 = 'SUB' THEN
               IF g_sfb100 <> '2' THEN
                   IF g_pmm.pmm09 <> g_sfb82 THEN
                      CALL cl_err('','apm-038',0)
                      LET g_pmm.pmm09 = g_pmm_o.pmm09
                      DISPLAY BY NAME g_pmm.pmm09
                      NEXT FIELD pmm09
                   END IF 
                END IF
              END IF
           END IF
        #--NO.FUN-5A0193 END---
           #TQC-C20013 add begin-------------------------------
           DECLARE pmn_cur2 CURSOR FOR
            SELECT pmn012,pmn04,pmn18,pmn41,pmn43 FROM pmn_file
             WHERE pmn01 = g_pmm.pmm01
           FOREACH pmn_cur2 INTO l_pmn012,l_pmn04,l_pmn18,l_pmn41,l_pmn43
              SELECT ima915 INTO l_ima915 FROM ima_file
               WHERE ima01 = l_pmn04
              IF l_ima915='2' OR l_ima915='3' THEN
                 CALL t540sub_pmh(l_pmn04,l_pmn41,
                                  l_pmn43,l_pmn18,l_pmn012,g_pmm.*,l_type)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(l_pmn04,g_errno,1)
                    LET g_pmm.pmm09 = g_pmm_o.pmm09
                    DISPLAY BY NAME g_pmm.pmm09
                    CALL t540_supplier('a','1',g_pmm.pmm09)
                    NEXT FIELD pmm09
                    EXIT FOREACH
                 END IF
              END IF
           END FOREACH
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM pmn_file
            WHERE pmn01 = g_pmm.pmm01
           IF l_cnt > 0 THEN
              DECLARE pmn_cur CURSOR FOR
               SELECT pmn68 FROM pmn_file WHERE pmn01=g_pmm.pmm01
              FOREACH pmn_cur INTO l_pmn68
                 IF NOT cl_null(l_pmn68) THEN
                    LET l_pom09 = ''
                    SELECT pom09 INTO l_pom09 FROM pom_file
                     WHERE pom01=l_pmn68
                    IF l_pom09 <> g_pmm.pmm09 THEN
                       CALL cl_err(l_pom09,'apm-903',1)
                       NEXT FIELD pmm09
                    END IF
                 END IF
              END FOREACH
           END IF
           #TQC-C20013 add end---------------------------------
 
           IF cl_null(g_pmm.pmm09) THEN             
              DISPLAY ' ' TO FORMONLY.pmc03  #(
              DISPLAY ' ' TO FORMONLY.pmc091 #(
              DISPLAY ' ' TO FORMONLY.pmc092 #(
              DISPLAY ' ' TO FORMONLY.pmc093 #(
              DISPLAY ' ' TO FORMONLY.pmc094 #(
              DISPLAY ' ' TO FORMONLY.pmc095 #(
           END IF
            IF NOT cl_null(g_pmm.pmm09)  THEN
                IF (g_pmm_o.pmm09 IS NULL) OR (g_pmm_t.pmm09 IS NULL) OR
                  (g_pmm.pmm09 != g_pmm_o.pmm09 ) THEN
                    CALL t542_pmm09('a')
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pmm.pmm09,g_errno,0)
                        LET g_pmm.pmm09 = g_pmm_o.pmm09
                        DISPLAY BY NAME g_pmm.pmm09
                        NEXT FIELD pmm09
                    END IF
                    CALL t542_pmm09_cd()
                    IF NOT cl_null(g_chr) THEN 
                        LET g_pmm.pmm09 = g_pmm_o.pmm09
                        DISPLAY BY NAME g_pmm.pmm09
                        NEXT FIELD pmm09
                    END IF
                END IF
            END IF
            LET  g_pmm_o.pmm09 = g_pmm.pmm09
 
        AFTER FIELD pmm10  		        #送貨地址
            IF NOT cl_null(g_pmm.pmm10) THEN 
          #Modify:
             SELECT pme02 INTO g_cnt FROM pme_file 
             WHERE pme01 = g_pmm.pmm10 
             IF g_cnt ='1' THEN 
                CALL cl_err('此非送貨地址!!!請重新輸入..',STATUS,1) 
                NEXT FIELD pmm10 
             END IF 
               IF (g_pmm_o.pmm10 IS NULL) OR (g_pmm_o.pmm10 != g_pmm.pmm10)
                  THEN CALL t542_add('0',g_pmm.pmm10)
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_pmm.pmm10,g_errno,0)
                          LET g_pmm.pmm10 = g_pmm_o.pmm10
                          DISPLAY BY NAME g_pmm_o.pmm10
                          NEXT FIELD pmm10
                       END IF
               END IF
            END IF
            LET  g_pmm_o.pmm10 = g_pmm.pmm10
 
        AFTER FIELD pmm11  		        #帳單地址
           IF NOT cl_null(g_pmm.pmm11) THEN
          #Modify:
             SELECT pme02 INTO g_cnt FROM pme_file 
             WHERE pme01 = g_pmm.pmm11 
             IF g_cnt ='0'  THEN 
                CALL cl_err('此非帳單地址!!!請重新輸入..',STATUS,1) 
                NEXT FIELD pmm11 
             END IF 
             IF (g_pmm_o.pmm11 IS NULL) OR (g_pmm_o.pmm11 != g_pmm.pmm11)
                  THEN CALL t542_add('1',g_pmm.pmm11)
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_pmm.pmm11,g_errno,0)
                          LET g_pmm.pmm11 = g_pmm_o.pmm11
                          DISPLAY BY NAME g_pmm_o.pmm11
                          NEXT FIELD pmm11
                       END IF
             END IF
           END IF
           LET g_pmm_o.pmm11 = g_pmm.pmm11
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
            CALL cl_err('',9001,0)
            EXIT INPUT 
        END IF
 
        ON ACTION mntn_vender #建立付款廠商檔
                  #LET g_cmd = "apmi600 ",g_pmm.pmm09 CLIPPED 
                   #LET g_cmd = "apmi600 '' ",g_pmm.pmm09 CLIPPED #MOD-4B0255 參數傳錯
                    LET g_cmd = "apmi600 ",g_pmm.pmm09 CLIPPED #FUN-7C0050
                   CALL cl_cmdrun(g_cmd)
 
        ON ACTION mntn_shipping_addr #建立送貨地址資料檔
                   LET g_cmd = "apmi204 ",g_pmm.pmm10 CLIPPED 
                   CALL cl_cmdrun(g_cmd)
 
        ON ACTION mntn_bill_addr #建立帳單地址資料檔
                   LET g_cmd = "apmi204 ",g_pmm.pmm11 CLIPPED 
                   CALL cl_cmdrun(g_cmd)
 
 
        ON ACTION qry_item_vender  #料件/供應商詢價查詢
           #CALL cl_cmdrun("apmq210 ") 
             LET g_cmd = "apmq210 '' ",g_pmm.pmm09 CLIPPED #MOD-4B0255 
            CALL cl_cmdrun(g_cmd)
 
        ON ACTION qry_vender_item         #供應商
           #CALL cl_cmdrun("apmq220 ") 
             LET g_cmd = "apmq220 ",g_pmm.pmm09 CLIPPED #MOD-4B0255 
            CALL cl_cmdrun(g_cmd)
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmm09) #查詢廠商檔
#                 CALL q_pmc1(0,0,g_pmm.pmm09) RETURNING g_pmm.pmm09
#                 CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm09 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc1"
                  LET g_qryparam.default1 = g_pmm.pmm09
                  CALL cl_create_qry() RETURNING g_pmm.pmm09
#                  CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm09 )
                  DISPLAY BY NAME g_pmm.pmm09 
                  CALL t542_pmm09('a')
                  NEXT FIELD pmm09
               WHEN INFIELD(pmm10) #查詢地址資料檔 (0:表送貨地址)
#                 CALL q_pme(10,3,g_pmm.pmm10,0) RETURNING g_pmm.pmm10
#                 CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm10 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pme"
                  LET g_qryparam.default1 = g_pmm.pmm10
                  CALL cl_create_qry() RETURNING g_pmm.pmm10
#                  CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm10 )
                  DISPLAY BY NAME g_pmm.pmm10 
                  NEXT FIELD pmm10
               WHEN INFIELD(pmm11) #查詢地址資料檔 (1:表帳單地址)
#                 CALL q_pme(10,3,g_pmm.pmm11,1) RETURNING g_pmm.pmm11
#                 CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm11 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pme"
                  LET g_qryparam.default1 = g_pmm.pmm11
                  CALL cl_create_qry() RETURNING g_pmm.pmm11
#                  CALL FGL_DIALOG_SETBUFFER( g_pmm.pmm11 )
                  DISPLAY BY NAME g_pmm.pmm11 
                  NEXT FIELD pmm11
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
   
FUNCTION t542_pmm09(p_cmd)  #供應廠商
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
    SELECT pmc05,pmc03,pmc10,pmc11,pmc12,pmc081,pmc082,pmc091,pmc092,
           pmc093,pmc094,pmc095,pmcacti
      INTO g_pmc05,l_pmc03,l_pmc10,l_pmc11,l_pmc12,
           l_pmc081,l_pmc082,l_pmc091,l_pmc092,
           l_pmc093,l_pmc094,l_pmc095,l_pmcacti
      FROM pmc_file 
     WHERE pmc01 = g_pmm.pmm09 
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
                            LET l_pmc081 = NULL LET l_pmc082 = NULL
                            LET l_pmc091 = NULL LET l_pmc092 = NULL
                            LET l_pmc093 = NULL LET l_pmc094 = NULL
                            LET l_pmc095 = NULL LET l_pmc10  = NULL
                            LET l_pmc11  = NULL LET l_pmc12  = NULL
         WHEN l_pmcacti='N' LET g_errno = '9028'
      #FUN-690024------mod-------
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690024------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_pmc03 TO FORMONLY.pmc03   #(
       DISPLAY l_pmc10 TO FORMONLY.pmc10   #(
       DISPLAY l_pmc11 TO FORMONLY.pmc11   #(
       DISPLAY l_pmc12 TO FORMONLY.pmc12   #(
       DISPLAY l_pmc081 TO FORMONLY.pmc081 #(
       DISPLAY l_pmc082 TO FORMONLY.pmc082 #(
       DISPLAY l_pmc091 TO FORMONLY.pmc091 #(
       DISPLAY l_pmc092 TO FORMONLY.pmc092 #(
       DISPLAY l_pmc093 TO FORMONLY.pmc093 #(
       DISPLAY l_pmc094 TO FORMONLY.pmc094 #(
       DISPLAY l_pmc095 TO FORMONLY.pmc095 #(
    END IF
END FUNCTION
   
FUNCTION t542_pmm09_cd()    #check 廠商狀況
  DEFINE  l_chr   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
LET g_chr = " "
   CASE 
 # WHEN g_pmc05 = '1'   #NO.FUN-690025 
   WHEN g_pmc05 = '0'   #NO.FUN-690025
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
 # WHEN g_pmc05 = '2'  LET g_chr = 's'         #停止  #NO.FUN-690025
   WHEN g_pmc05 = '3'  LET g_chr = 's'         #停止  #NO.FUN-690025
   OTHERWISE EXIT CASE
   END CASE
END FUNCTION
   
FUNCTION t542_add(p_cmd,p_code)    #check 地址
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
   
FUNCTION t542_show()
# DEFINE  l_str  LIKE apm_file.apm08 	#No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
    LET g_pmm_t.* = g_pmm.*
    DISPLAY BY NAME g_pmm.pmm09,g_pmm.pmm10,g_pmm.pmm11 
    CALL t542_pmm09('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION t542_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pmm.pmm01 IS NULL THEN
        CALL cl_err('',-542,0)
        RETURN
    END IF
    IF g_pmm.pmmacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_pmm.pmm01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    LET g_pmm01_t = g_pmm.pmm01
    BEGIN WORK
    WHILE TRUE
        LET g_pmm_o.* = g_pmm.*
        CALL t542_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pmm.*=g_pmm_t.*
            CALL t542_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pmm_file SET pmm_file.* = g_pmm.*    # 更新DB
            WHERE pmm01 = g_argv1               
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmm.pmm01,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
