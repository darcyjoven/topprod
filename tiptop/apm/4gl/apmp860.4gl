# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp860.4gl
# Descriptions...: 代採買應收/應付帳款拋轉作業 no.6215
# Date & Author..: 02/10/23 By Kammy
# Modify.........: 03/05/30 By Kammy 增加倉退單拋轉應收應付部份 no.7176
# Modify.........: No.8037 03/09/03 Kammy 來源廠的AP帳款類別不應defulat AR類別
# Modify.........: No.8166 03/09/09 Kammy 1.流程代碼改抓poy_file,poz_file
#                                         2.AR/AP部門改抓流程代碼，而非採購部門
#                                         3.多角序號
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/29 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設# Modify.........: NO.FUN-590002 05/12/27By Monster radio type 應都要給預設值值
# Modify.........: No.FUN-570138 06/03/08 By yiting 批次背景執行
# Modify.........: NO.MOD-630079 06/03/22 By Mandy 代採逆拋時,若在最終工廠有指定最終供應商時,apmp860並不會自動產生最終供應商的相對AP,
#                                                  所以並不需要判斷最終站是否有打此供應商的相對應收貨/入庫單
# Modify.........: NO.MOD-640433 06/04/12 BY Pengu 單據日期不應與立帳日會計期別不同
# Modify.........: NO.TQC-640164 06/04/20 by yiting 單據日期沒有輸入時應default原異動單據日
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: NO.FUN-670007 06/08/24 by yiting 1.s_mutislip移到p860_azp()之後，加傳入流程代碼/站別
#                                                   2.依apmi000設定站別抓取資料
#                                                   3.如果有設定中斷點，只拋轉到中斷點營運中心，所設營運中心之後段工廠不拋
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: NO.FUN-710019 07/01/12 BY Yiting 三角改善
# Modify.........: No.FUN-710030 07/01/23 By bnlent 錯誤訊息匯總顯示修改
# Modify.........: NO.TQC-760097 07/06/21 by Yiting pmm904->pmm01
# Modify.........: No.TQC-760158 07/07/04 By claire 變數應由pmm904->pmm99
# Modify.........: NO.MOD-780191 07/08/29 by yiting 拋轉時需檢查單別設定資料
# Modify.........: NO.TQC-790117 07/09/20 BY yiting 二站時拋轉錯誤
# Modify.........: NO.TQC-7C0034 07/12/06 BY heather 使異動單號能開窗查詢
# Modify.........: NO.MOD-7C0116 07/12/19 BY claire (1)重取來源站AP資料
#                                                   (2)重取各站AP資料
#                                                   (3)重取來源站AP單據別
# Modify.........: NO.TQC-810029 08/01/09 BY yiting 最終供應商時，取不到AP單別
# Modify.........: NO.MOD-820171 08/02/27 BY claire 有最終供應商時,最後一站會無法拋AP(axr-186)
# Modify.........: No.MOD-870123 08/07/11 By claire 有最終供應商時,要清除殘值收貨/入庫單號
# Modify.........: No.MOD-870144 08/07/11 By claire 排除已拋轉多角入庫/倉退單
# Modify.........: No.MOD-8C0125 08/12/12 By claire 已拋帳款的確認應用計價數量
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()     
# Mofify.........: No.FUN-980020 09/08/18 By douzh 集團架構調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/17 By TSD.sar2436  GP5.2 跨資料庫語法修改 
# Modify.........: No.MOD-990245 09/09/30 By Dido AP單據抓取調整 
# Modify.........: No:TQC-980232 09/10/26 By lilingyu 單據類型選擇:3.倉退單,成功運行后,并未生成相應的折讓單據 
# Modify.........: No:TQC-980174 09/11/26 By lilingyu "部門編號"欄位需要可以開窗查詢
# Modify.........: No:MOD-9B0186 09/11/27 By Dido AP單據應與銷售相同 
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:MOD-A20031 10/02/05 By Dido 抓取條件增加排除已存在 apb_file 部分
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-AC0043 11/01/25 By Smapmin oga27要抓取下一站的資料
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-C40183 12/04/24 By Elise 不判斷中斷點否
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_date           LIKE type_file.dat     #No.FUN-680136 DATE                # 應收立帳日
DEFINE p_date           LIKE type_file.dat     #No.FUN-680136 DATE                # 應收立帳日
DEFINE g_rvu00          LIKE rvu_file.rvu00 # 異動類別
DEFINE g_argv1		LIKE oea_file.oea01 #No.FUN-680136 VARCHAR(16)            #No.FUN-550060
 
DEFINE g_rvu    RECORD LIKE rvu_file.*
DEFINE g_rva    RECORD LIKE rva_file.*
DEFINE g_oga    RECORD LIKE oga_file.*
DEFINE g_pmm    RECORD LIKE pmm_file.*
DEFINE p_poy16  LIKE poy_file.poy16,     #AR類別
       p_poy17  LIKE poy_file.poy17,     #AP類別
       p_poy20  LIKE poy_file.poy20,     #申報方式
       p_poy18  LIKE poy_file.poy18,     #AR部門
       p_poy19  LIKE poy_file.poy19      #AP部門
DEFINE p_poy04  LIKE poy_file.poy04      #AR之工廠編號
DEFINE p_poy12  LIKE oga_file.oga05      #發票別
DEFINE g_poz    RECORD LIKE poz_file.*   #流程代碼資料(單頭) No.8166
DEFINE g_poy    RECORD LIKE poy_file.*   #流程代碼資料(單身) No.8166
DEFINE s_poy    RECORD LIKE poy_file.*   #流程代碼資料(單身) #FUN-710019
DEFINE p_last_plant  LIKE poy_file.poy04 #最後一家工廠編號
DEFINE g_flow99      LIKE apa_file.apa99 #No.FUN-680136 VARCHAR(17)            #No.8166   #FUN-560043
DEFINE g_sw          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE g_t1          LIKE oay_file.oayslip            #No.FUN-550060  #No.FUN-680136 VARCHAR(05)
DEFINE g_rvu01       LIKE rvu_file.rvu01
DEFINE g_oga01       LIKE oga_file.oga01
DEFINE g_oha01       LIKE oha_file.oha01
DEFINE l_dbs_new     LIKE type_file.chr21  #No.FUN-680136  VARCHAR(21)            #New DataBase Name
DEFINE s_dbs_new     LIKE type_file.chr21  #NO.FUN-670007
DEFINE n_dbs_new     LIKE type_file.chr21  #No.FUN-680136  VARCHAR(21)            #FUN-670007
DEFINE l_azp  RECORD LIKE azp_file.*
DEFINE s_azp  RECORD LIKE azp_file.*     #FUN-670007
DEFINE p_last        LIKE type_file.num5   #No.FUN-680136  SMALLINT
DEFINE g_cnt         LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_msg         LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE l_flag          LIKE type_file.chr1,                  #No.FUN-570138  #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)               #No.FUN-570138 是否有做語言切換
       ls_date         STRING                  #No.FUN-570138
DEFINE g_yy,g_mm,g_rvu_yy,g_rvu_mm  LIKE type_file.num5   #No.FUN-680136  SMALLINT   #NO.MOD-640433 
DEFINE l_poy02_2       LIKE poy_file.poy02  #FUN-670007 
DEFINE l_c             LIKE type_file.num5    #No.FUN-680136 SMALLINT             #FUN-670007
DEFINE l_dbs_tra     LIKE azw_file.azw05  #FUN-980092 add 
DEFINE l_plant_new   LIKE azw_file.azw01  #FUN-980092 add 
DEFINE s_plant_new   LIKE azw_file.azw01  #CHI-AC0043
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1  = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET g_date   = cl_batch_bg_date_convert(ls_date)
   LET g_rvu00  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818
 
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob= "N" THEN
         IF cl_null(g_argv1) THEN
            CALL p860_tm()
         ELSE
            LET g_wc   =" oga01 MATCHES '",g_argv1,"'"
         END IF
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL p860_p()
            CALL s_showmsg()    #No.FUN-710030
            #若無傳入值時
            IF cl_null(g_argv1) THEN                      #TQC-980232
               IF g_success = 'Y' THEN                    #TQC-980232
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
          END IF     #TQC-980232            
            #若有傳入值時
            IF NOT cl_null(g_argv1) THEN                      #TQC-980232
               IF g_success = 'Y' THEN                        #TQC-980232
               CALL cl_cmmsg(1) COMMIT WORK
            ELSE
               CALL cl_rbmsg(1) ROLLBACK WORK
            END IF
            END IF                                            #TQC-980232              
            CLOSE WINDOW win
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p860_w
               EXIT WHILE
            END IF
         ELSE
            CLOSE WINDOW win
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p860_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p860_p()
         CALL s_showmsg()   #No.FUN-710030
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION p860_tm()
DEFINE lc_cmd       LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(500)            #No.FUN-570138
 
   OPEN WINDOW p860_w WITH FORM "apm/42f/apmp860"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
                              
   CLEAR FORM
   CALL cl_opmsg('w')
 
   WHILE TRUE
       LET g_rvu00 = '1'
       ERROR ''
       CONSTRUCT BY NAME g_wc ON rvu01,rvu03,rvu06 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
       ON ACTION controlp                                                       
          CASE                                                                  
             WHEN INFIELD(rvu01)                                                 
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_rvu7"   #MOD-870144                                   
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO FORMONLY.rvu01
                NEXT FIELD rvu01
             WHEN INFIELD(rvu06)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_rvu06"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO FORMONLY.rvu06
                NEXT FIELD rvu06
             OTHERWISE EXIT CASE                                                
          END CASE                                                              
 
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        
         ON ACTION locale                    #genero
            LET g_change_lang = TRUE          #NO.FUN-570138
            EXIT CONSTRUCT
        
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup') #FUN-980030
   
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p860_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
       IF g_wc = ' 1=1' THEN 
          CALL cl_err('','9046',0) 
          CONTINUE WHILE
       END IF
 
       LET g_date=NULL
       LET g_bgjob = 'N' #NO.FUN-570138 
       CALL cl_opmsg('a')
       INPUT BY NAME g_rvu00,g_date,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570138
 
          AFTER FIELD g_rvu00
             IF cl_null(g_rvu00) THEN
                NEXT FIELD g_rvu00
             ELSE
                IF g_rvu00 NOT MATCHES '[13]' THEN
                   NEXT FIELD g_rvu00
                END IF
             END IF
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG call cl_cmdask()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
          ON ACTION exit  #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT
       
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION locale                    #genero
            LET g_change_lang = TRUE  
            EXIT INPUT 
 
       END INPUT
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p860_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
     END IF
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp860"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp860','9031',1)   #No.FUN-660129
        ELSE
           LET g_wc=cl_replace_str(g_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_wc CLIPPED ,"'",
                        " '",g_date CLIPPED ,"'",
                        " '",g_rvu00 CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp860',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p860_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
 
    END WHILE
 
END FUNCTION
 
FUNCTION p860_p()
  DEFINE l_oma58     LIKE oma_file.oma58
  DEFINE l_cnt,i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
  DEFINE ar_t1,ap_t1 LIKE poy_file.poy38    #No.FUN-680136 VARCHAR(5)   #No.FUN-550060
  DEFINE l_x         LIKE aba_file.aba00  #No.FUN-680136 VARCHAR(5)   #No.FUN-550060
  DEFINE l_azp03     LIKE azp_file.azp03
  DEFINE l_sql1      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
  DEFINE k           LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
    IF g_bgjob = 'N' THEN  #NO.FUN-570138 
        CALL cl_wait() 
    END IF
 
 
    LET g_success='Y'
 
    LET p_date = g_date  #存所給之應付日
    #讀取符合條件之出貨資料
    LET g_sql="SELECT rvu_file.*,rva_file.* ",
              "   FROM rvu_file,rva_file ",
              " WHERE rvuconf = 'Y' ",        #必須為已確認入庫單
   	      "   AND rvu00 = '",g_rvu00,"'", #異動類別 
              "   AND rvu08 = 'TAP' ",        #代採買採購性質
              "   AND rvu02 = rva01 ",
              "   AND rvu20 = 'Y'  ",         #入庫單必須已拋轉  
              "   AND rvu99 IS NOT NULL ",                              #MOD-A20031
              "   AND rvu01 NOT IN( SELECT apb21 ",                     #MOD-A20031
              "                       FROM apb_file ,apa_file ",        #MOD-A20031
              "                      WHERE apb01 = apa01      ",        #MOD-A20031
              "                        AND apa42 = 'N'        ",        #MOD-A20031
              "                        AND apb21 IS NOT NULL) ",        #MOD-A20031
              "   AND ",g_wc CLIPPED
    PREPARE p860_prepare FROM g_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('prepare:',STATUS,1) 
       LET g_success='N' 
       RETURN
    END IF
    DECLARE p860_cs CURSOR WITH HOLD FOR p860_prepare
    IF SQLCA.sqlcode THEN 
       CALL cl_err('declare:',STATUS,1) 
       LET g_success='N' 
       RETURN
    END IF
    LET l_cnt=0
    CALL s_showmsg_init()    #No.FUN-710030
    FOREACH p860_cs INTO g_rvu.* , g_rva.*
        IF STATUS THEN 
           CALL s_errmsg('','','p860(foreach):',STATUS,1)
           LET g_success='N'
           EXIT FOREACH 
        END IF
   #若畫面上之應付日未給則給入庫日(出貨日)
   IF p_date IS NULL THEN LET g_date=g_rvu.rvu03 END IF
   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
       WHERE azn01 = g_date
   IF STATUS THEN
       CALL s_errmsg('azn01','g_date','read azn:',SQLCA.sqlcode,0)
       CONTINUE FOREACH
   END IF
 
        SELECT azn02,azn04
          INTO g_rvu_yy,g_rvu_mm FROM azn_file
        WHERE azn01 = g_rvu.rvu03
        IF g_rvu_yy IS NOT NULL AND g_rvu_mm IS NOT NULL THEN
            IF g_rvu_yy != g_yy OR g_rvu_mm != g_mm THEN
               CALL s_errmsg('azn01','g_rvu.rvu03',g_rvu.rvu01,'axr-065',1)
               LET g_success = 'N' 
               CONTINUE FOREACH
            END IF
        END IF
 
        LET g_flow99 = g_rvu.rvu99
        #若單據已立帳，則不產生
         SELECT COUNT(*) INTO g_cnt FROM rvv_file
          WHERE rvv01 = g_rvu.rvu01
            AND (rvv87 > rvv23 OR rvv87 = 0) #MOD-8C0125
         IF g_cnt = 0 THEN CONTINUE FOREACH END IF
        #若畫面上之應付日未給則給入庫日(出貨日)
        LET l_cnt = l_cnt +1
        IF cl_null(g_rva.rva02) THEN   
           #只讀取第一筆訂單之資料
           LET l_sql1= " SELECT pmm_file.* FROM pmm_file,rvb_file ",
                       "  WHERE pmm01 = rvb04 ",
                       "    AND rvb01 = '",g_rvu.rvu02,"'"
           PREPARE pmm_pre FROM l_sql1
           DECLARE pmm_f CURSOR FOR pmm_pre
           OPEN pmm_f 
           FETCH pmm_f INTO g_pmm.*
        ELSE
           #讀取該入庫單之採購單
           SELECT * INTO g_pmm.*
             FROM pmm_file
            WHERE pmm01 = g_rva.rva02
        END IF
        #必須檢查為來源採購單(目前應收/應付拋轉只採正拋)
        IF g_pmm.pmm906 != 'Y' THEN
           CALL s_errmsg('pmm01','g_rva.rva02',g_pmm.pmm01,'apm-021',1) 
           LET g_success='N' CONTINUE FOREACH
        END IF
 
        #讀取三角貿易流程代碼資料
        SELECT * INTO g_poz.*
          FROM poz_file
         WHERE poz01=g_pmm.pmm904 AND poz00='2'
        IF SQLCA.sqlcode THEN
            CALL s_errmsg('poz01','g_pmm.pmm904',g_pmm.pmm904,'axm-318',1)
            LET g_success = 'N'
            CONTINUE FOREACH    #No.FUN-710030
        END IF
        IF g_poz.pozacti = 'N' THEN 
            CALL s_errmsg('','',g_pmm.pmm904,'tri-009',1)
            LET g_success = 'N'
            CONTINUE FOREACH   #No.FUN-710030
        END IF
        CALL s_mtrade_last_plant(g_pmm.pmm904) 
             RETURNING p_last,p_last_plant       #記錄最後一家
 
        #依流程代碼最多6層
        FOR i = 1 TO p_last
           LET k = i + 1          #FUN-670007
           #得到廠商/客戶代碼及database
           CALL p860_azp(i)
           CALL p860_chk99()                         #No.8166
           LET g_t1 = s_get_doc_no(g_rvu.rvu01)     #No.FUN-550060
           IF g_rvu00 = '1' THEN
                IF i <> 0 THEN
                    CALL s_mutislip('1','2',g_t1,g_poz.poz01,i)
                        RETURNING g_sw,l_x,l_x,l_x,ar_t1,l_x
                    IF cl_null(ar_t1) THEN
                        CALL cl_err('','axm4017',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                END IF 
                
                IF i <> p_last THEN
                    CALL s_mutislip('1','2',g_t1,g_poz.poz01,k)		#MOD-990245 mark  #MOD-9B0186 remark
                       RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
                    IF cl_null(ap_t1) THEN
                        CALL cl_err('','axm4018',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                ELSE
                    IF ( i = p_last AND NOT cl_null(g_pmm.pmm50)) THEN  
                        LET ap_t1='' #MOD-870123 
                        SELECT poy40 INTO ap_t1
                          FROM poy_file
                         WHERE poy01 = g_poz.poz01
                           AND poy02 = 99
                    ELSE
                    CALL s_mutislip('1','2',g_t1,g_poz.poz01,i)
                       RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
                    END IF                              #NO.TQC-810029 add
                    IF cl_null(ap_t1) THEN
                        CALL cl_err('','axm4018',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                END IF
           ELSE
                IF i <> 0  THEN
                    CALL s_mutislip('2','2',g_t1,g_poz.poz01,i)
                       RETURNING g_sw,l_x,l_x,ar_t1,l_x,l_x
                    IF cl_null(ar_t1) THEN
                        CALL cl_err('','axm4017',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                END IF
                IF i <> p_last THEN
                    CALL s_mutislip('2','2',g_t1,g_poz.poz01,k)		#MOD-990245 mark   #MOD-9B0186 remark
                       RETURNING g_sw,l_x,l_x,l_x,ap_t1,l_x
                    IF cl_null(ap_t1) THEN
                        CALL cl_err('','axm4018',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                ELSE
                    IF ( i = p_last AND NOT cl_null(g_pmm.pmm50)) THEN  
                        LET ap_t1='' #MOD-870123 
                        SELECT poy44 INTO ap_t1
                          FROM poy_file
                         WHERE poy01 = g_poz.poz01
                           AND poy02 = 99
                    ELSE
                    CALL s_mutislip('2','2',g_t1,g_poz.poz01,i)
                       RETURNING g_sw,l_x,l_x,l_x,ap_t1,l_x
                    END IF                             #no.TQC-810029 add
                    IF cl_null(ap_t1) THEN
                        CALL cl_err('','axm4018',1)
                        LET g_success = 'N'
                        EXIT FOREACH
                    END IF
                END IF
           END IF
           IF g_sw THEN
               LET g_success = 'N' EXIT FOREACH
           END IF
 
           #讀取該廠別之A/R及A/P立帳
           IF g_rvu00='1' THEN  #入庫單
              CALL p860_getno1(i)                    #No.8166
              CALL apmp861(g_rvu.rvu01,g_date,p_poy20,p_poy16,p_poy17,
                          l_plant_new,p_poy12,p_last_plant,           #FUN-980092  add
                          p_poy18,p_poy19,g_poz.poz011,g_pmm.pmm99,   #TQC-760158 pmm01->pmm99
                          g_flow99,ar_t1,ap_t1,g_rvu01,g_oga01,s_plant_new)      #No.8166   #CHI-AC0043 add s_plant_new
           END IF
           IF g_rvu00='3' THEN  #倉退單
              CALL p860_getno2(i)                     #No.8166
              CALL apmp881(g_rvu.rvu01,g_date,p_poy20,p_poy16,p_poy17,
                           l_plant_new,p_poy12,p_last_plant,               #FUN-980020  #FUN-980098 add 
			   p_poy18,p_poy19,g_poz.poz011,g_pmm.pmm99,       #TQC-760158 pmm01->pmm99
                           g_flow99,ar_t1,ap_t1,g_rvu01,g_oha01)          #No.8166
           END IF
       END FOR
       #來源廠之AP立帳(必須給來源廠之AP分類)
       LET k=0 
       SELECT poy02 INTO k FROM poy_file
         WHERE poy01 = g_poz.poz01   
           AND poy04 = g_plant
       CALL p860_azp(k)
       #取AP單別
       LET k=k+1					#MOD-990245 mark   #MOD-9B0186 remark
       CALL s_mutislip('1','2',g_t1,g_poz.poz01,k)
          RETURNING g_sw,l_x,l_x,l_x,l_x,ap_t1
       IF cl_null(ap_t1) THEN
           CALL cl_err('','axm4018',1)
           LET g_success = 'N'
       END IF
       SELECT azp03 INTO l_azp03 FROM azp_file
        WHERE azp01=g_plant
 
       LET l_dbs_new = s_dbstring(l_azp03 CLIPPED)    #FUN-920166
 
       IF g_rvu00='1' THEN  #入庫單
          CALL apmp861(g_rvu.rvu01,g_date,p_poy20,p_poy16,p_poy17,
                      l_plant_new,p_poy12,p_last_plant,              #FUN-980020
                      p_poy18,p_poy19,g_poz.poz011,g_pmm.pmm99,      #TQC-760158 pmm01->pmm99
                      g_flow99,ar_t1,ap_t1,g_rvu.rvu01,g_oga01,s_plant_new)      #No.8166   #CHI-AC0043 add s_plant_new
       END IF
       CALL s_mutislip('2','2',g_t1,g_poz.poz01,k)
          RETURNING g_sw,l_x,l_x,l_x,ap_t1,l_x
       IF cl_null(ap_t1) THEN
           CALL cl_err('','axm4018',1)
           LET g_success = 'N'
       END IF
       IF g_rvu00='3' THEN  #倉退單
          CALL apmp881(g_rvu.rvu01,g_date,p_poy20,p_poy16,p_poy17,
                       l_plant_new,p_poy12,p_last_plant,                 #FUN-980020
                       p_poy18,p_poy19,g_poz.poz011,g_pmm.pmm99,         #TQC-760158
                       g_flow99,ar_t1,ap_t1,g_rvu.rvu01,g_oha01)          #No.8166
       END IF
   END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
   #無符合條件時
   IF l_cnt = 0 THEN
      CALL s_errmsg('','','','mfg3160',1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION p860_azp(l_i)
  DEFINE l_i     LIKE type_file.num5,    #No.FUN-680136 SMALLINT
         l_sql1  LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
         l_next  LIKE type_file.num5    #FUN-670007
 
     ##-------------取得當站資料----------------------
     SELECT * INTO g_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_i      
     SELECT * INTO l_azp.* FROM azp_file WHERE azp01 = g_poy.poy04
     LET l_dbs_new = s_dbstring(l_azp.azp03)   #TQC-950010 ADD 
 
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
     LET p_poy04  = g_poy.poy04     #工廠編號
     LET p_poy12  = g_poy.poy12     #發票別        
     LET p_poy16  = g_poy.poy16     #AR 科目類別   
     LET p_poy17  = g_poy.poy17     #AP 科目類別
     LET p_poy18  = g_poy.poy18     #AR 部門
     LET p_poy19  = g_poy.poy19     #AP 部門   
     LET p_poy20  = g_poy.poy20     #營業額申報方式
 
     IF cl_null(p_poy20) THEN LET p_poy20 = g_poz.poz03 END IF 
 
     LET l_next = l_i + 1  
     ##-------------取下一站資料----------------------
     SELECT * INTO s_poy.* FROM poy_file
      WHERE poy01 = g_poz.poz01 AND poy02 = l_next      
     IF STATUS=100 AND NOT cl_null(g_pmm.pmm50) THEN
        SELECT * INTO s_poy.* FROM poy_file
         WHERE poy01 = g_poz.poz01 AND poy02 = 99      
        SELECT poy04 INTO s_poy.poy04 FROM poy_file
         WHERE poy01 = g_poz.poz01 AND poy02 = (l_next-1)
     END IF
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_dbs_new = s_dbstring(s_azp.azp03)   #TQC-950010 ADD  
     LET s_plant_new = s_azp.azp01   #CHI-AC0043
     LET p_poy17  = s_poy.poy17     #AP 科目類別
     LET p_poy19  = s_poy.poy19     #AP 部門
 
END FUNCTION
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p860_chk99()
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
 
     LET g_cnt = 0
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"apa_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'apa_file'), #FUN-A50102
                 "  WHERE apa99 ='",g_flow99,"'"
     IF g_rvu00 = '1' THEN
        LET l_sql = l_sql CLIPPED," AND apa00 = '11' "
     ELSE
        LET l_sql = l_sql CLIPPED," AND apa00 = '21' "
     END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE apacnt_pre FROM l_sql
     DECLARE apacnt_cs CURSOR FOR apacnt_pre
     OPEN apacnt_cs 
     FETCH apacnt_cs INTO g_cnt                                #應付款
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_new CLIPPED,'apa99 duplicate'
        CALL cl_err(g_msg CLIPPED,'tri-011',1)
        LET g_success = 'N'
     END IF
 
     #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_new CLIPPED,"oma_file ",
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oma_file'), #FUN-A50102
                 "  WHERE oma99 ='",g_flow99,"'"
     IF g_rvu00 = '1' THEN
        LET l_sql = l_sql CLIPPED," AND oma00 = '12' "
     ELSE
        LET l_sql = l_sql CLIPPED," AND oma00 = '21' "
     END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE omacnt_pre FROM l_sql
     DECLARE omacnt_cs CURSOR FOR omacnt_pre
     OPEN omacnt_cs 
     FETCH omacnt_cs INTO g_cnt                                #應收款
     IF g_cnt > 0 THEN
        LET g_msg = l_dbs_new CLIPPED,'oma99 duplicate'
        CALL cl_err(g_msg CLIPPED,'tri-011',1)
        LET g_success = 'N'
     END IF
END FUNCTION
 
FUNCTION p860_getno1(i) 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   #IF cl_null(g_poz.poz18) OR ( i < l_poy02_2 AND NOT cl_null(g_poz.poz18)) THEN   #FUN-670007   #設定的中斷點為起源站時，不再往下做還原動作 #MOD-C40183 mark
        IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm.pmm50) AND g_poz.poz011 = '1' ) THEN  #MOD-630079 #正拋時才需進入
            #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ", #FUN-980092 add
            LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102 
                        "  WHERE rvu99 ='",g_rvu.rvu99,"'",
                        "    AND rvu00 = '1' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
            PREPARE rvu01_pre FROM l_sql
            DECLARE rvu01_cs CURSOR FOR rvu01_pre
            OPEN rvu01_cs 
            FETCH rvu01_cs INTO g_rvu01                              #入庫單
            IF SQLCA.SQLCODE THEN
               LET g_msg = l_dbs_new CLIPPED,'fetch rvu01_cs'
               CALL cl_err(g_msg,SQLCA.SQLCODE,1)
               LET g_success = 'N'
            END IF
         END IF
   #END IF             #FUN-670007  #MOD-C40183 mark
 
     IF i <> 0 THEN     #FUN-670007 
         #LET l_sql = " SELECT oga01 FROM ",l_dbs_tra CLIPPED,"oga_file ",#FUN-980092 add
         LET l_sql = " SELECT oga01 FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102 
                     "  WHERE oga99 ='",g_rvu.rvu99,"'",
                     "    AND oga09 = '6' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE oga01_pre FROM l_sql
         DECLARE oga01_cs CURSOR FOR oga01_pre
         OPEN oga01_cs 
         FETCH oga01_cs INTO g_oga01                              #出貨單
         IF SQLCA.SQLCODE THEN
            LET g_msg = l_dbs_new CLIPPED,'fetch oga01_cs'
            CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
     END IF           #FUN-670007
END FUNCTION
 
FUNCTION p860_getno2(i) 
  DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
  DEFINE i     LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
    IF i <> p_last OR ( i = p_last AND NOT cl_null(g_pmm.pmm50) AND g_poz.poz011 = '1' ) THEN  #MOD-630079 #正拋時才需進入
        #LET l_sql = " SELECT rvu01 FROM ",l_dbs_tra CLIPPED,"rvu_file ",   #FUN-980092 add
        LET l_sql = " SELECT rvu01 FROM ",cl_get_target_table(l_plant_new,'rvu_file'), #FUN-A50102  
                    "  WHERE rvu99 ='",g_rvu.rvu99,"'",
                    "    AND rvu00 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
        PREPARE rvu01t_pre FROM l_sql
        DECLARE rvu01t_cs CURSOR FOR rvu01t_pre
        OPEN rvu01t_cs 
        FETCH rvu01t_cs INTO g_rvu01                              #倉退單
        IF SQLCA.SQLCODE THEN
           LET g_msg = l_dbs_new CLIPPED,'fetch rvu01_cs'
           CALL cl_err(g_msg,SQLCA.SQLCODE,1)
           LET g_success = 'N'
        END IF
     END IF
 
     IF i <> 0 THEN  #NO.FUN-670007 
         #LET l_sql = " SELECT oha01 FROM ",l_dbs_tra CLIPPED,"oha_file ",#FUN-980092 add
         LET l_sql = " SELECT oha01 FROM ",cl_get_target_table(l_plant_new,'oha_file'), #FUN-A50102 
                     "  WHERE oha99 ='",g_rvu.rvu99,"'",
                     "    AND oha05 = '3' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE oha01_pre FROM l_sql
         DECLARE oha01_cs CURSOR FOR oha01_pre
         OPEN oha01_cs 
         FETCH oha01_cs INTO g_oha01                              #銷退單
         IF SQLCA.SQLCODE THEN
            LET g_msg = l_dbs_new CLIPPED,'fetch oha01_cs'
            CALL cl_err(g_msg,SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
     END IF         #NO.FUN-670007
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
