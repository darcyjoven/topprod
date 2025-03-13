# Prog. Version..: '5.30.08-13.07.05(00010)'     #
#
# Pattern name...: axcp302.4gl
# Descriptions...: CA系統傳票拋轉還原
# Date & Author..: 05/01/26 By Carol
# Modify.........: No.FUN-510041 05/01/25 By Carol 新增成本拋轉傳票還原功能
# Modify.........: No.MOD-590096 05/09/07 By wujie 傳票號碼加大到16碼  
# Modify.........: MOD-590081 05/09/20 By Smapmin 取消call s_abhmod()
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼 
# Modify.........: No.FUN-680086 06/08/25 By Ray 多帳套修改
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-780008 07/08/13 By Smapmin 還原MOD-590081
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/08/31 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0118 09/12/02 By Carrier axcq310的方式是多套帐独立抛转,不再启用两套帐相对应的方式,故抛转还原时,第二套帐存在否的判断拿掉
# Modify.........: No:TQC-9C0073 09/12/10 By Carrier 不过plant字段时,g_dbs_new的赋值
# Modify.........: No:CHI-A20014 10/02/25 By sabrina 送簽中或已核准不可還原
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-AA0025 10/10/25 By wujie 新增成本分录结转相关修改
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B40056 11/06/03 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:CHI-C20017 12/05/28 By jinjj 若g_bgjob='Y'時使用彙總訊息方式呈現
# Modify.........: No.FUN-C50131 12/05/31 By minpp 1.增加兩個傳值參數2.axcp100拋轉總帳還原時開窗顯示第一賬套憑證編號 
# Modify.........: No.FUN-C70093 12/07/28 By minpp axcp100/axct326抛转还原时，需回写ccbglno=NULL
# Modify.........: No.MOD-CB0129 12/11/14 By wujie 画面增加开窗功能
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業增加日誌功能
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No.MOD-CC0008 12/12/03 By wujie 背景执行时也要检查凭证单号的有效性
# Modify.........: No.FUN-D60110 13/06/24 by zhangweib 憑證編號開窗可多選

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       STRING   #No.FUN-580092 HCN
DEFINE g_dbs_gl 	      LIKE type_file.chr21     #No.FUN-680122 VARCHAR(21)
DEFINE p_plant          LIKE ccz_file.ccz11    #No.FUN-680122 VARCHAR(12)
DEFINE p_bookno         LIKE aaa_file.aaa01    #No.FUN-670039
DEFINE p_bookno1        LIKE aaa_file.aaa01    #No.FUN-680086
DEFINE gl_date		      LIKE type_file.dat       #No.FUN-680122 DATE
DEFINE gl_yy,gl_mm     	LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_existno	      LIKE npp_file.nppglno    #No.FUN-680122 VARCHAR(16)	       #No.MOD-590096
DEFINE g_existno1	      LIKE npp_file.nppglno    #No.FUN-680122 VARCHAR(16)               #No.FUN-680086
DEFINE p_row,p_col      LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_aaz84          LIKE aaz_file.aaz84 #還原方式 1.刪除 2.作廢 
DEFINE l_flag           LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(1),                #No.FUN-570153
       g_change_lang    LIKE type_file.chr1,      # Prog. Version..: '5.30.08-13.07.05(01),               #是否有做語言切換 No.FUN-570153
       g_flag           LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(1),
       ls_date          STRING                  #->No.FUN-570153
DEFINE   g_msg          LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(72)
DEFINE g_cka00          LIKE cka_file.cka00       #No.FUN-C80092 add
DEFINE g_cka09          LIKE cka_file.cka09       #No.FUN-C80092 add
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
#No.FUN-CB0096 ---end  --- Add
#No.FUN-D60110 ---Add--- Start
DEFINE g_existno_str     STRING
DEFINE bst base.StringTokenizer
DEFINE temptext STRING
DEFINE l_errno LIKE type_file.num10
DEFINE g_existno1_str STRING
DEFINE tm   RECORD
            wc1         STRING,
            wc2         STRING
            END RECORD
#No.FUN-D60110 ---Add--- End

MAIN
#     DEFINE     l_time LIKE type_file.chr8              #No.FUN-6A0146
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET p_plant  = ARG_VAL(1)                      
   LET p_bookno = ARG_VAL(2)                      
   LET g_existno= ARG_VAL(3)                      
   LET g_bgjob  = ARG_VAL(4) 
   LET p_bookno1 = ARG_VAL(5)       #FUN-C50131
   LET g_existno1= ARG_VAL(6)       #FUN-C50131        
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570153 mark--
#    OPEN WINDOW p302 AT p_row,p_col WITH FORM "axc/42f/axcp302" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    
#    CALL cl_ui_init()
 
#    CALL cl_opmsg('z')
#    CALL p302()
#    IF INT_FLAG THEN 
#       LET INT_FLAG = 0
#    ELSE 
#       CALL cl_end(18,20)
#    END IF
#    CLOSE WINDOW p302
#NO.FUN-570153 mark-
 
#NO.FUN-570153 start---
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add
   LET g_success = 'Y'
   WHILE TRUE
      CALL s_showmsg_init()   #CHI-C20017 add
      LET g_flag = 'Y' 
      IF g_bgjob = "N" THEN
         CLEAR FORM
         CALL p302_ask()
         #FUN-D60110 ---Add--- Start
         IF tm.wc1 = " 1=1" THEN
            CALL cl_err('','9033',0)
            CONTINUE WHILE  
         END IF
         #FUN-D60110 ---Add--- End
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         #No.TQC-9C0073  --Begin                                                
         LET g_plant_new=p_plant                                                
         CALL s_getdbs()                                                        
         LET g_dbs_gl=g_dbs_new                                                 
         #No.TQC-9C0073  --End 
         IF cl_sure(18,20) THEN
            #FUN-C80092--add--str--
            LET g_cka09 = " p_plant='",p_plant,"'; p_bookno='",p_bookno,"'; g_existno='",g_existno,
                          "'; g_bgjob='",g_bgjob,"'; p_bookno1='",p_bookno1,"'; g_existno1='",g_existno1,"' "
            CALL s_log_ins(g_prog,'','','',g_cka09) RETURNING g_cka00
            #FUN-C80092--add--end-- 
            BEGIN WORK
            LET g_success = 'Y'
            #FUN-D60110 ---Add--- Start
            CALL p302_existno_chk()
            IF g_success = 'N' THEN 
                CALL s_showmsg()
                CONTINUE WHILE 
            END IF 
            #FUN-D60110 ---Add--- End
            CALL p302_t()
            #No.FUN-680086 --begin
          # IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #No.FUN-9B0118
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' AND g_existno1 IS NOT NULL THEN  #No.FUN-9B0118
               CALL p302_t_1()
            END IF
            #No.FUN-680086 --end
            CALL s_showmsg()   #CHI-C20017 add
        
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CLOSE WINDOW p302_t_w9
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p302_t_w9
               CLOSE WINDOW p302
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p302
      ELSE
         LET tm.wc1 = "g_existno IN ('",g_existno,"')"  #No.FUN-D60110 Add
         CALL p302_existno_chk()                        #No.FUN-D60110 Add
         #FUN-C80092--add--str--
         LET g_cka09 = " p_plant='",p_plant,"'; p_bookno='",p_bookno,"'; g_existno='",g_existno,
                       "'; g_bgjob='",g_bgjob,"'; p_bookno1='",p_bookno1,"'; g_existno1='",g_existno1,"' "
         CALL s_log_ins(g_prog,'','','',g_cka09) RETURNING g_cka00
         #FUN-C80092--add--end--
         BEGIN WORK
         LET g_success = 'Y'
         #No.TQC-9C0073  --Begin                                                
         LET g_plant_new=p_plant                                                
         CALL s_getdbs()                                                        
         LET g_dbs_gl=g_dbs_new                                                 
         #No.TQC-9C0073  --End
         CALL p302_t()
         #No.FUN-680086 --begin
        #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  #No.FUN-9B0118
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' AND g_existno1 IS NOT NULL THEN  #No.FUN-9B0118
            CALL p302_t_1()
         END IF
         #No.FUN-680086 --end
         CALL s_showmsg()   #CHI-C20017 add
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570153 ---end---
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
#NO.FUN-570153 mark--
#FUNCTION p302()
#  # 得出總帳 database name 
#  # g_ccz.ccz11 -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
#   CALL p302_ask()			
#   IF INT_FLAG THEN RETURN END IF
#
#   IF NOT cl_sure(20,20) THEN LET INT_FLAG = 1 RETURN END IF
#   CALL cl_wait()
#
#   OPEN WINDOW p302_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
#   LET g_success   = 'Y'
#   LET g_plant_new = p_plant
#   CALL s_getdbs()
#   LET g_dbs_gl    = g_dbs_new 
#
#   #還原方式為刪除/作廢
#   LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",
#               " WHERE aaz00 = '0' "
#   PREPARE aaz84_pre FROM g_sql
#   DECLARE aaz84_cs CURSOR FOR aaz84_pre
#
#   OPEN aaz84_cs 
#   FETCH aaz84_cs INTO g_aaz84
#   IF STATUS THEN 
#      CALL cl_err('sel aaz84',STATUS,1)
#      CLOSE WINDOW p302_t_w9
#      CLOSE WINDOW p302
#      EXIT PROGRAM
#   END IF
#
#   BEGIN WORK
#   CALL p302_t()
#   IF g_success = 'Y' THEN 
#      COMMIT WORK 
#   ELSE 
#      ROLLBACK WORK
#   END IF
#   ERROR ""
#
#   CLOSE WINDOW p302_t_w9
#
#END FUNCTION
#NO.FUN-570153 mark-
 
FUNCTION p302_ask()
   DEFINE   l_abapost,l_flag   LIKE aba_file.abapost    #No.FUN-680122 VARCHAR(1)
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_npp07            LIKE npp_file.npp07     #No.FUN-680086
   DEFINE   l_nppglno          LIKE npp_file.nppglno     #No.FUN-680086
   DEFINE   lc_cmd             LIKE type_file.chr1000   #No.FUN-680122 VARCHAR(500) #No.FUN-570153
   DEFINE   l_aba20            LIKE aba_file.aba20    #CHI-A20014 add 
 
#NO.FUN-570153 start--
    OPEN WINDOW p302 AT p_row,p_col WITH FORM "axc/42f/axcp302" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    #No.FUN-680086 --begin
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("p_bookno1,g_existno1",TRUE)
    ELSE
       CALL cl_set_comp_visible("p_bookno1,g_existno1",TRUE)
    END IF
    #No.FUN-680086 --end
 
    CALL cl_opmsg('z')
#NO.FUN-570153 end---
 
   LET p_plant   = g_ccz.ccz11
   LET p_bookno  = g_ccz.ccz12
   #LET g_existno = NULL   #FUN-C50131 mark
   LET g_bgjob = 'N'    # FUN-570153
  #FUN-C50131---ADD--STR
   IF NOT cl_null(g_existno) THEN   
      DISPLAY BY NAME g_existno   
   ELSE                          
      LET g_existno = NULL 
   END IF                       
   IF NOT cl_null(p_bookno1) THEN
      DISPLAY BY NAME p_bookno1
   ELSE
      LET p_bookno1=null
   END IF
   IF NOT cl_null(g_existno1) THEN    
      DISPLAY BY NAME g_existno1     
   ELSE                             
      LET g_existno1 = NULL
   END IF              
   #FUN-C50131---ADD--END 
   DISPLAY BY NAME p_plant,p_bookno,g_existno 
   DIALOG ATTRIBUTES(UNBUFFERED)  #No.FUN-D60110 Add
      #INPUT BY NAME p_plant,p_bookno,g_existno WITHOUT DEFAULTS
     #INPUT BY NAME p_plant,p_bookno,g_existno,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570153   #No.FUN-D60110  Mark
      INPUT BY NAME p_plant,p_bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)         #No.FUN-D60110   Add
#       #No.FUN-D60110 ---Mark--- Start
#        ON ACTION locale
#  #NO.FUN-570153 start--
#  #          CALL cl_dynamic_locale()
#  #          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            LET g_change_lang = TRUE
#            EXIT INPUT
#  #NO.FUN-570153 end--
#       #No.FUN-D60110 ---Mark--- End
         AFTER FIELD p_plant
            IF NOT cl_null(p_plant) THEN
               SELECT azp01 FROM azp_file WHERE azp01 = p_plant
               IF STATUS THEN 
   #              CALL cl_err(p_plant,'mfg9142',1)   #No.FUN-660127
                  CALL cl_err3("sel","azp_file",p_plant,"","mfg9142","","",1)   #No.FUN-660127
                  NEXT FIELD p_plant 
               END IF
              
               LET g_plant_new=p_plant
               CALL s_getdbs()
               LET g_dbs_gl=g_dbs_new 
            END IF
    
         AFTER FIELD p_bookno
             IF NOT cl_null(p_bookno) THEN
               LET g_ccz.ccz12 = p_bookno
             END IF
             
        #No.FUN-D60110 ---Mark--- Start
        #AFTER FIELD g_existno
        #    IF NOT cl_null(g_existno) THEN 
        #       LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20 ",   #CHI-A20014 add aba20
        #                 #"  FROM ",g_dbs_gl,"aba_file",
        #                 "  FROM ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
        #                 " WHERE aba01 = ? AND aba00 = ? AND aba06='CA'"
        #      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #       CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
        #       PREPARE p302_t_p1 FROM g_sql
        #       DECLARE p302_t_c1 CURSOR FOR p302_t_p1
        #       IF STATUS THEN
        #          CALL cl_err('decl aba_cursor:',STATUS,0) 
        #          NEXT FIELD g_existno
        #       END IF
        #
        #       OPEN p302_t_c1 USING g_existno,g_ccz.ccz12
        #       FETCH p302_t_c1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
        #                            l_abaacti,l_aba20        #CHI-A20014 add l_aba20 
        #       IF STATUS THEN
        #          CALL cl_err('sel aba:',STATUS,0) 
        #          NEXT FIELD g_existno
        #       END IF
        #
        #       IF l_abaacti = 'N' THEN
        #          CALL cl_err('','mfg8001',1) 
        #          NEXT FIELD g_existno
        #       END IF
        #      #CHI-A20014---add---start---
        #       IF l_aba20 MATCHES '[Ss1]' THEN
        #          CALL cl_err('','mfg3557',0) 
        #          NEXT FIELD g_existno
        #       END IF
        #      #CHI-A20014---add---end---
        #       IF l_abapost = 'Y' THEN
        #          CALL cl_err(g_existno,'aap-130',0)
        #          NEXT FIELD g_existno
        #       END IF
        #       #FUN-B50090 add begin-------------------------
        #       #重新抓取關帳日期
        #       SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
        #       #FUN-B50090 add -end--------------------------
        #       IF gl_date < g_sma.sma53 THEN 
        #          CALL cl_err(gl_date,'aap-027',0)
        #          NEXT FIELD g_existno
        #       END IF
        #       IF l_aba19 ='Y' THEN 
        #          CALL cl_err(gl_date,'aap-026',0)
        #          NEXT FIELD g_existno
        #       END IF
        #       #No.FUN-680086 --begin
        #       IF g_aza.aza63 = 'Y' THEN
        #          SELECT unique npp07,nppglno INTO l_npp07,l_nppglno
        #            FROM npp_file
        #           WHERE npp01 IN (SELECT npp01 FROM npp_file
        #                            WHERE npp07 = p_bookno
        #                              AND nppglno = g_existno
        #                              AND npptype = '0'
        #                              AND nppsys = 'CA')
        #             AND npptype ='1'
        #             AND nppsys = 'CA'
        #          #No.FUN-9B0118  --Begin
        #          IF STATUS THEN
        #             IF STATUS = 100 THEN
        #                #No.FUN-9B0118  --Begin
        #             #  CALL cl_err3("sel","npp_file",g_existno,"","axr-800","","",1)
        #             #  NEXT FIELD g_existno
        #                #No.FUN-9B0118  --End  
        #             ELSE
        #                CALL cl_err3("sel","npp_file",g_existno,"",STATUS,"","",1)
        #                NEXT FIELD g_existno
        #             END IF
        #          ELSE
        #             DISPLAY l_npp07 TO FORMONLY.p_bookno1
        #             DISPLAY l_nppglno TO FORMONLY.g_existno1
        #             LET g_ccz.ccz121 = l_npp07
        #             LET g_existno1 = l_nppglno
        #             LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20 ",     #CHI-A20014 add aba20
        #                       #"  FROM ",g_dbs_gl,"aba_file",
        #                       "  FROM ",cl_get_target_table(p_plant,'aba_file'),  #FUN-A50102
        #                       " WHERE aba01 = ? AND aba00 = ? AND aba06='CA'"
        #               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        #              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
        #             PREPARE p302_t_p2 FROM g_sql
        #             DECLARE p302_t_c2 CURSOR FOR p302_t_p2
        #             IF STATUS THEN
        #                CALL cl_err('decl aba_cursor:',STATUS,0) 
        #                NEXT FIELD g_existno
        #             END IF
        #
        #             OPEN p302_t_c1 USING g_existno1,g_ccz.ccz121
        #             FETCH p302_t_c1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19,
        #                                  l_abaacti,l_aba20      #CHI-A20014 add l_aba20 
        #             IF STATUS THEN
        #                CALL cl_err('sel aba:',STATUS,0) 
        #                NEXT FIELD g_existno
        #             END IF
        #
        #             IF l_abaacti = 'N' THEN
        #                CALL cl_err('','mfg8001',1) 
        #                NEXT FIELD g_existno
        #             END IF
        #            #CHI-A20014---add---start---
        #             IF l_aba20 MATCHES '[Ss1]' THEN
        #                CALL cl_err('','mfg3557',0) 
        #                NEXT FIELD g_existno
        #             END IF
        #            #CHI-A20014---add---end---
        #             IF l_abapost = 'Y' THEN
        #                CALL cl_err(g_existno,'aap-130',0)
        #                NEXT FIELD g_existno
        #             END IF
        #            #FUN-B50090 add begin-------------------------
        #             #重新抓取關帳日期
        #             SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
        #            #FUN-B50090 add -end--------------------------
        #             IF gl_date < g_sma.sma53 THEN 
        #                CALL cl_err(gl_date,'aap-027',0)
        #                NEXT FIELD g_existno
        #             END IF
        #             IF l_aba19 ='Y' THEN 
        #                CALL cl_err(gl_date,'aap-026',0)
        #                NEXT FIELD g_existno
        #             END IF
        #          END IF
        #          #No.FUN-9B0118  --End
        #       END IF
        #       #No.FUN-680086 --end
        #    END IF
        #No.FUN-D60110 ---Mark--- Start
    
         AFTER INPUT
   #NO.FUN-570153 start---
   #         IF INT_FLAG THEN 
   #            EXIT INPUT
   #         END IF
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CLOSE WINDOW p302
              #No.FUN-CB0096 ---start--- add
              #LET l_time = TIME         #No.FUN-D60110   Mark
               LET l_time = l_time + 1   #No.FUN-D60110   Add
               LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
               CALL s_log_data('U','100',g_id,'1',l_time,'','')
              #No.FUN-CB0096 ---end  --- add
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
               EXIT PROGRAM
            END IF
   #NO.FUN-570153 end--
    
            LET l_flag='N'
            IF cl_null(p_plant)   THEN 
               LET l_flag='Y'
            END IF
            IF cl_null(p_bookno)     THEN
               LET l_flag='Y'
            END IF
           #No.FUN-D60110 ---Mark--- Start
           #IF cl_null(g_existno) THEN
           #   LET l_flag='Y'
           #END IF
           #No.FUN-D60110 ---Mark--- Start
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD p_plant
            END IF
           # 得出總帳 database name
           # g_apz.apz02p -> g_plant_new -> s_getdbs() -> g_dbs_new --> g_dbs_gl
            LET g_plant_new= p_plant  # 工廠編號
            CALL s_getdbs()
            LET g_dbs_gl=g_dbs_new    # 得資料庫名稱

        #No.FUN-D60110 ---Mark--- Start
        #ON ACTION CONTROLR
        #   CALL cl_show_req_fields()
        #
        #ON ACTION CONTROLG
        #   CALL cl_cmdask()
        #
        #ON IDLE g_idle_seconds
        #   CALL cl_on_idle()
        #   CONTINUE INPUT
        #
        #ON ACTION about        
        #   CALL cl_about()     
        #
        #ON ACTION help         
        #   CALL cl_show_help() 
        #
        #ON ACTION exit                            #加離開功能
        #   LET INT_FLAG = 1
        #   EXIT INPUT
        #No.FUN-D60110 ---Mark--- Start

   #No.MOD-CB0129 --begin
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(p_plant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azp01_2"
                  LET g_qryparam.default1 = p_plant
                  CALL cl_create_qry() RETURNING p_plant
                  DISPLAY BY NAME p_plant
                  NEXT FIELD p_plant 
               WHEN INFIELD(p_bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = p_bookno
                  CALL cl_create_qry() RETURNING p_bookno
                  DISPLAY BY NAME p_bookno
                  NEXT FIELD p_bookno 
              #No.FUN-D60110 ---Mark--- Add
              #WHEN INFIELD(g_existno)
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form ="q_aba"
              #   LET g_qryparam.arg1 = p_bookno
              #   LET g_qryparam.where = "aba06 = 'CA' AND abapost ='N' AND abaacti ='Y' AND aba20 NOT IN ('S','s','1')"
              #   LET g_qryparam.default1 = g_existno
              #   CALL cl_create_qry() RETURNING g_existno
              #   DISPLAY BY NAME g_existno
              #   NEXT FIELD g_existno
              #No.FUN-D60110 ---Mark--- Add
            END CASE 
   #No.MOD-CB0129 --end 
      
            #No.FUN-580031 --start--
            BEFORE INPUT
                CALL cl_qbe_init()
            #No.FUN-580031 ---end---
           #No.FUN-D60110 ---Mark--- Add
           ##No.FUN-580031 --start--
           #ON ACTION qbe_select
           #   CALL cl_qbe_select()
           ##No.FUN-580031 ---end---
    
           ##No.FUN-580031 --start--
           #ON ACTION qbe_save
           #   CALL cl_qbe_save()
           ##No.FUN-580031 ---end---
           #No.FUN-D60110 ---Mark--- Add
    
      END INPUT
   #->No.FUN-570153 --start--
   #FUN-D60110 ---Add--- Start
   CONSTRUCT BY NAME  tm.wc1 ON g_existno
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

   AFTER FIELD g_existno
      IF tm.wc1 = " 1=1" THEN 
         CALL cl_err('','9033',0)
         NEXT FIELD g_existno 
      END IF  
      CALL  p302_existno_chk() 
      IF g_success = 'N' THEN 
         CALL s_showmsg()
         NEXT FIELD g_existno
      END IF 

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(g_existno)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aba"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = p_bookno
               LET g_qryparam.where = "aba06 = 'CA' AND abapost ='N' AND abaacti ='Y' AND aba20 NOT IN ('S','s','1')"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO g_existno
               NEXT FIELD g_existno
         END CASE

   END CONSTRUCT

   INPUT BY NAME g_bgjob ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

   END INPUT 
   
   ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
         LET g_change_lang = TRUE
      ON ACTION exit 
         LET INT_FLAG = 1
         EXIT DIALOG    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
  
      ON ACTION ACCEPT
         EXIT DIALOG        
       
      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END DIALOG 
   #FUN-D60110 ---Add--- End
   
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p302
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp302"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp302','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",p_plant CLIPPED ,"'",
                      " '",p_bookno CLIPPED ,"'",
                      " '",g_existno CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axcp302',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p302
     #No.FUN-CB0096 ---start--- add
     #LET l_time = TIME   #No.FUN-D60110 Mark
      LET l_time = l_time + 1 #No.FUN-D60110   Add
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   #->No.FUN-570153 --end--
END FUNCTION
 
FUNCTION p302_t()
   DEFINE l_npp	   	    RECORD LIKE npp_file.*
#No.FUN-AA0025 --begin 
   DEFINE l_cdl11       LIKE cdl_file.cdl11
   DEFINE l_cdl12       LIKE cdl_file.cdl12
   DEFINE l_nppglno     LIKE npp_file.nppglno 
   DEFINE l_npp00       LIKE npp_file.npp00
  #FUN-C70093--ADD--STR
   DEFINE l_cdm02     LIKE cdm_file.cdm02
   DEFINE l_cdm03     LIKE cdm_file.cdm03
   DEFINE l_cdm04     LIKE cdm_file.cdm04
   DEFINE l_cdm05     LIKE cdm_file.cdm05
   DEFINE l_cdm06     LIKE cdm_file.cdm06
   DEFINE l_cdm11     LIKE cdm_file.cdm11
 #FUN-C70093--ADD--END
#No.FUN-AA0025 --end
#No.MOD-CC0008 --begin
   DEFINE   l_abapost,l_flag   LIKE aba_file.abapost    #No.FUN-680122 VARCHAR(1)
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba20            LIKE aba_file.aba20    #CHI-A20014 add 
#No.MOD-CC0008 --end
 
   #NO.FUN-570153 start--
   IF g_bgjob = 'N' THEN  
      OPEN WINDOW p302_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
      LET g_success   = 'Y'
      LET g_plant_new = p_plant
      #CALL s_getdbs()             #FUN-A50102
      #LET g_dbs_gl    = g_dbs_new #FUN-A50102
    
      #還原方式為刪除/作廢
      #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",
      LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file'), #FUN-A50102
                  " WHERE aaz00 = '0' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE aaz84_pre FROM g_sql
      DECLARE aaz84_cs CURSOR FOR aaz84_pre
    
      OPEN aaz84_cs 
      FETCH aaz84_cs INTO g_aaz84
      IF STATUS THEN 
        #CALL cl_err('sel aaz84',STATUS,1)          #No.FUN-D60110   Mark
         CALL s_errmsg('sel aaz84','','',STATUS,1)   #No.FUN-D60110   Add
         LET g_success = 'N'
         RETURN
   #      CLOSE WINDOW p302_t_w9
   #      CLOSE WINDOW p302
   #      EXIT PROGRAM
      END IF
   END IF
   #NO.FUN-570153 end---
   #No.MOD-CC0008 --begin
   IF g_bgjob = 'Y' THEN
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")   #No.FUN-D60110   Add
      LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20 ",   #CHI-A20014 add aba20
               #"  FROM ",g_dbs_gl,"aba_file",
                "  FROM ",cl_get_target_table(p_plant,'aba_file'), #FUN-A50102
               #" WHERE aba01 = ? AND aba00 = ? AND aba06='CA'"         #No.FUN-D60110   Mark
                " WHERE aba00 = ? AND aba06='CA' AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
      PREPARE p302_t_p3 FROM g_sql
      DECLARE p302_t_c3 CURSOR FOR p302_t_p3
      IF STATUS THEN
         LET g_success = 'N'
        #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','',STATUS,1)
        #No.FUN-D60110 ---Mark--- Start
        #ELSE
        #   CALL cl_err('',STATUS,1)
        #   RETURN
        #END IF
        #No.FUN-D60110 ---Mark--- Start
      END IF
 
     #OPEN p302_t_c3 USING g_existno,g_ccz.ccz12   #No.FUN-D60110   Mark
      OPEN p302_t_c3 USING g_ccz.ccz12   #No.FUN-D60110   Add
      FOREACH p302_t_c3 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19,   #No.FUN-D60110 Mod   FETCH --> FOREACH
                             l_abaacti,l_aba20        #CHI-A20014 add l_aba20 
         IF STATUS THEN
            LET g_success = 'N'
           #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
               CALL s_errmsg('','','',STATUS,1)
           #No.FUN-D60110 ---Mark--- Start
           #ELSE
           #   CALL cl_err('',STATUS,1)
           #   RETURN
           #END IF
           #No.FUN-D60110 ---Mark--- End
         END IF
    
         IF l_abaacti = 'N' THEN
            LET g_success = 'N'
           #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
               CALL s_errmsg('','','','mfg8001',1)
           #No.FUN-D60110 ---Mark--- Start
           #ELSE
           #   CALL cl_err('','mfg8001',1)
           #   RETURN
           #END IF
           #No.FUN-D60110 ---Mark--- End
         END IF
   #      CHI-A20014---add---start---
         IF l_aba20 MATCHES '[Ss1]' THEN
            LET g_success = 'N'
           #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
               CALL s_errmsg('','','','mfg3557',1)
           #No.FUN-D60110 ---Mark--- Start
           #ELSE
           #   CALL cl_err('','mfg3557',1)
           #   RETURN
           #END IF
           #No.FUN-D60110 ---Mark--- End
         END IF
   #      CHI-A20014---add---end---
         IF l_abapost = 'Y' THEN
            LET g_success = 'N'
           #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
               CALL s_errmsg('','','','aap-130',1)
           #No.FUN-D60110 ---Mark--- Start
           #ELSE
           #   CALL cl_err(g_existno,'aap-130',1)
           #   RETURN
           #END IF
           #No.FUN-D60110 ---Mark--- End
         END IF
         #FUN-B50090 add begin-------------------------
         #重新抓取關帳日期
         SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
         #FUN-B50090 add -end--------------------------
         IF gl_date < g_sma.sma53 THEN 
            LET g_success = 'N'
           #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark   
               CALL s_errmsg('','','','aap-027',1)
           #No.FUN-D60110 ---Mark--- Start
           #ELSE
           #   CALL cl_err(g_existno,'aap-027',1)
           #   RETURN
           #END IF
           #No.FUN-D60110 ---Mark--- End
         END IF
         IF l_aba19 ='Y' THEN 
            LET g_success = 'N'
           #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark   
               CALL s_errmsg('','','','aap-026',1)
           #No.FUN-D60110 ---Mark--- Start
           #ELSE
           #   CALL cl_err(g_existno,'aap-026',1)
           #   RETURN
           #END IF
           #No.FUN-D60110 ---Mark--- End
         END IF
      END FOREACH   #No.FUN-D60110   Add
   END IF
#No.MOD-CC0008 --end  
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
     #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")   #No.FUN-D60110   Add
      LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),#FUN-A50102
                "  SET abaacti = 'N' ",
               #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
                " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE p302_updaba_p FROM g_sql
     #EXECUTE p302_updaba_p USING g_existno,g_ccz.ccz12   #No.FUN-D60110   Mark
      EXECUTE p302_updaba_p USING g_ccz.ccz12             #No.FUN-D60110   Add
      IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1) 
        #LET g_success = 'N'
        #RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
           CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       ##end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
   ELSE
#No.FUN-AA0025 --begin  
    #杂项进出差异分录未抛转还原时，杂项进出分录不能抛转还原
    #SELECT aba07 INTO l_cdl11 FROM aba_file WHERE aba01 = g_existno #No.FUN-D60110   Mark
      LET l_cdl12 = NULL
    #No.FUN-D60110 ---Add--- Start
      LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")   #No.FUN-D60110   Add
      LET g_sql = "SELECT aba07 FROM aba_file WHERE ",tm.wc2 CLIPPED
      PREPARE p302_sel_aba07_p FROM g_sql
      DECLARE p302_sel_aba07 CURSOR FOR p302_sel_aba07_p
      FOREACH p302_sel_aba07 INTO l_cdl11
        #No.FUN-D60110 ---Add--- End
         SELECT npp00 INTO l_npp00 FROM npp_file WHERE npp01=l_cdl11 AND npptype = '0'
         IF l_npp00 = 6 THEN
        #IF NOT cl_null(l_cdl12) THEN  
            SELECT DISTINCT cdl12 INTO l_cdl12 FROM cdl_file
             WHERE cdl11 = l_cdl11         
            LET l_nppglno = NULL
            SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = l_cdl12 AND nppsys ='CA' AND npp00 =7 AND npp011 =1 AND npptype = '0' 
            IF NOT cl_null(l_nppglno) THEN
              #str CHI-C20017 mod  
              #CALL cl_err('','axc-528',0)
              #LET g_success ='N'
              #RETURN  
               LET g_success = 'N'
              #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
                  CALL s_errmsg('','','','axc-528',1)
              #No.FUN-D60110 ---Mark--- Start
              #ELSE
              #   CALL cl_err('','axc-528',0)
              #   RETURN
              #END IF
              #end CHI-C20017 mod
              #No.FUN-D60110 ---Mark--- End
            END IF
         END IF
      END FOREACH   #No.FUN-D60110   Add
#No.FUN-AA0025 --end
     IF g_bgjob = 'N' THEN   #NO.FUN-570153 
         MESSAGE "Delete GL's Voucher body!"  #-------------------------
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"
     LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","abb01")   #No.FUN-D60110   Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),#FUN-A50102
              #" WHERE abb01=? AND abb00=?"   #No.FUN-D60110   Mark
               " WHERE abb00=? AND ",tm.wc2   #No.FUN-D60110   Add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p302_2_p3 FROM g_sql
    #EXECUTE p302_2_p3 USING g_existno,g_ccz.ccz12   #No.FUN-D60110   Mark
     EXECUTE p302_2_p3 USING g_ccz.ccz12      #No.FUN-D60110   Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del abb)',SQLCA.sqlcode,1) 
        #LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
       #IF g_bgjob = 'Y' THEN   #
     END IF
     IF g_bgjob = 'N' THEN   #NO.FUN-570153 
         MESSAGE "Delete GL's Voucher head!"  #-------------------------
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"
     LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01")        #No.FUN-D60110  Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),#FUN-A50102
              #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
               " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p302_2_p4 FROM g_sql
    #EXECUTE p302_2_p4 USING g_existno,g_ccz.ccz12   #No.FUN-D60110   Mark
     EXECUTE p302_2_p4 USING g_ccz.ccz12             #No.FUN-D60110   Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del aba)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
     IF SQLCA.sqlerrd[3] = 0 THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del aba)','aap-161',1) LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del aba)','aap-161',1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)','aap-161',1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
     IF g_bgjob = 'N' THEN   #NO.FUN-570153 
         MESSAGE "Delete GL's Voucher desp!"  #-------------------------
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"
     LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","abc01")        #No.FUN-D60110  Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'),#FUN-A50102
              #" WHERE abc01 = ? AND abc00 = ? "   #No.FUN-D60110   Mark
               " WHERE abc00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p302_2_p5 FROM g_sql
    #EXECUTE p302_2_p5 USING g_existno,g_ccz.ccz12  #No.FUN-D60110   Mark
     EXECUTE p302_2_p5 USING g_ccz.ccz12            #No.FUN-D60110   Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del abc)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
#FUN-B40056  --begin
     LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","tic04")        #No.FUN-D60110  Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
              #" WHERE tic04=? AND tic00=?"   #No.FUN-D60110   Mark
               " WHERE tic00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE p302_2_p9 FROM g_sql
    #EXECUTE p302_2_p9 USING g_existno,g_ccz.ccz12   #No.FUN-D60110   Mark
     EXECUTE p302_2_p9 USING g_ccz.ccz12             #No.FUN-D60110   Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del tic)',SQLCA.sqlcode,1) 
        #LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
            CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del tic)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
#FUN-B40056  --end
   END IF
   IF g_bgjob = 'N' THEN   #NO.FUN-570153 
       MESSAGE "Delete GL's Voucher detail!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF  
#  CALL s_abhmod(g_dbs_gl,g_ccz.ccz12,g_existno)   #MOD-590081   #CHI-780008 #FUN-980020 mark
   CALL s_abhmod(p_plant,g_ccz.ccz12,g_existno)    #FUN-980020
   IF g_success = 'N' THEN RETURN END IF
 
   #FUN-C70093---ADD--STR
  #No.FUN-D60110 ---Mod--- Start
  #SELECT npp00,npp01 INTO l_npp.npp00,l_npp.npp01  FROM npp_file WHERE nppglno=g_existno
  #                                                                 AND npptype='0'
  #                                                                 AND npp07 = g_ccz.ccz12
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")        #No.FUN-D60110  Add
   LET g_sql = "SELECT npp00,npp01 FROM npp_file ",
               " WHERE npptype='0' ",
               "   AND npp07 = '",g_ccz.ccz12,"'",
               "   AND ",tm.wc2 CLIPPED
   PREPARE p302_npp01_prep FROM g_sql
   DECLARE p302_npp01_p CURSOR FOR p302_npp01_prep
   FOREACH p302_npp01_p INTO l_npp.npp00,l_npp.npp01
  #No.FUN-D60110 ---Mod--- End
      IF l_npp.npp00=9 THEN
          DECLARE cdm_cs CURSOR FOR 
          SELECT cdm02,cdm03,cdm04,cdm05,cdm06,cdm11 FROM cdm_file 
           WHERE cdm10=l_npp.npp01
         FOREACH cdm_cs INTO l_cdm02,l_cdm03,l_cdm04,l_cdm05,l_cdm06,l_cdm11
            UPDATE ccb_file SET ccbglno=null WHERE ccb01=l_cdm06
                                               AND ccb02=l_cdm02
                                               AND ccb03=l_cdm03
                                               AND ccb04=l_cdm11
                                               AND ccb06=l_cdm04
                                               AND ccb07=l_cdm05
            IF STATUS THEN
              #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
                  CALL s_errmsg('','','(upd ccbglno)',STATUS,1)
              #No.FUN-D60110 ---Mark--- Start
              #ELSE
              #   CALL cl_err3("upd","ccb_file",g_existno,"",STATUS,"","upd ccbglno",1)
              #   RETURN
              #END IF
              #No.FUN-D60110 ---Mark--- End
            END IF
         END FOREACH
       END IF
    END FOREACH   #No.FUN-D60110   Add
   #FUN-C70093--ADD--END
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980009 add azoplant,azolegal
          VALUES('axcp302',g_user,g_today,g_msg,g_existno,'delete',g_plant,g_legal) #FUN-980009 add g_plant,g_legal
   #----------------------------------------------------------------------
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,
  #                    npp06 = NULL ,npp07  = NULL 
  # WHERE nppglno=g_existno
  #   AND npptype = '0'     #No.FUN-680086
  #   AND npp07 = g_ccz.ccz12     #No.FUN-680086
   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","nppglno")        #No.FUN-D60110  Add
   LET g_sql = "UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,",
               "                    npp06 = NULL ,npp07  = NULL ",
               " WHERE ",tm.wc2 CLIPPED,
               "   AND npptype = '0'",    
               "   AND npp07 = '",g_ccz.ccz12,"'"
   PREPARE p302_npp_prep FROM g_sql
   EXECUTE p302_npp_prep
  #No.FUN-D60110 ---Mod--- End
   IF STATUS THEN
      #str CHI-C20017 mod
#     CALL cl_err('(upd npp03)',STATUS,1)    #No.FUN-660127
      #CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","(upd npp03)",1)   #No.FUN-660127
      #LET g_success='N'
      #RETURN
      LET g_success = 'N'
     #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(upd npp03)',STATUS,1)
     #No.FUN-D60110 ---Mark--- Start
     #ELSE
     #   CALL cl_err3("upd","npp_file",g_existno,"",STATUS,"","(upd npp03)",1)
     #   RETURN
     #END IF
     ##end CHI-C20017 mod
     #No.FUN-D60110 ---Mark--- Start
   END IF
  #No.FUN-CB0096 ---start--- Add
  #LET l_time = TIME   #No.FUN-D60110 Mark
   LET l_time = l_time + 1 #No.FUN-D60110   Add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
 
#No.FUN-680086 --begin
FUNCTION p302_t_1()
   DEFINE l_npp	   	    RECORD LIKE npp_file.*
#No.FUN-AA0025 --begin 
   DEFINE l_cdl11       LIKE cdl_file.cdl11
   DEFINE l_cdl12       LIKE cdl_file.cdl12
   DEFINE l_nppglno     LIKE npp_file.nppglno 
   DEFINE l_npp00       LIKE npp_file.npp00
#No.FUN-AA0025 --end
#FUN-C70093--ADD--STR
   DEFINE l_cdm02     LIKE cdm_file.cdm02
   DEFINE l_cdm03     LIKE cdm_file.cdm03
   DEFINE l_cdm04     LIKE cdm_file.cdm04
   DEFINE l_cdm05     LIKE cdm_file.cdm05
   DEFINE l_cdm06     LIKE cdm_file.cdm06
   DEFINE l_cdm11     LIKE cdm_file.cdm11
 #FUN-C70093--ADD--END 
#NO.FUN-570153 start--
IF g_bgjob = 'N' THEN  
   OPEN WINDOW p302_t_w9 AT 19,4 WITH 3 ROWS, 70 COLUMNS 
   LET g_success   = 'Y'
   LET g_plant_new = p_plant
   CALL s_getdbs()
   LET g_dbs_gl    = g_dbs_new 
 
   #還原方式為刪除/作廢
   #LET g_sql = "SELECT aaz84 FROM ",g_dbs_gl CLIPPED,"aaz_file",
   LET g_sql = "SELECT aaz84 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),#FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE aaz84_pre1 FROM g_sql
   DECLARE aaz84_cs1 CURSOR FOR aaz84_pre1
 
   OPEN aaz84_cs1 
   FETCH aaz84_cs1 INTO g_aaz84
   IF STATUS THEN
     #CALL cl_err('sel aaz84',STATUS,1)           #No.FUN-D60110   Mark
      CALL s_errmsg('sel aaz84','','',STATUS,1)   #No.FUN-D60110   Add
      LET g_success = 'N'                         #No.FUN-D60110   Add
      RETURN
   END IF
END IF
 
   IF g_aaz84 = '2' THEN   #還原方式為作廢 
     #LET g_sql="UPDATE ",g_dbs_gl," aba_file  SET abaacti = 'N' ",
     LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","aba01")        #No.FUN-D60110  Add
     LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'aba_file'),#FUN-A50102
               "   SET abaacti = 'N' ",
              #" WHERE aba01 = ? AND aba00 = ? "   #No.FUN-D60110   Mark
               " WHERE aba00 = ? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p302_updaba_p1 FROM g_sql
    #EXECUTE p302_updaba_p1 USING g_existno1,g_ccz.ccz121  #No.FUN-D60110   Mark
     EXECUTE p302_updaba_p1 USING g_ccz.ccz121             #No.FUN-D60110   Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1) 
        #LET g_success = 'N'
        #RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN  #No.FUN-D60110   Mark
           CALL s_errmsg('','','(upd abaacti)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(upd abaacti)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       ##end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
   ELSE
#No.FUN-AA0025 --begin  
   #杂项进出差异分录未抛转还原时，杂项进出分录不能抛转还原
    #No.FUN-D60110 ---Mod--- Start
    #SELECT aba07 INTO l_cdl11 FROM aba_file WHERE aba01 = g_existno 
     LET l_cdl12 = NULL
     LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","aba01")
     LET g_sql = "SELECT aba07 FROM aba_file WHERE ",tm.wc2 CLIPPED
     PREPARE p302_sel_aba071_1 FROM g_sql
     DECLARE p302_sel_aba07_1 CURSOR FOR p302_sel_aba071_1
     FOREACH p302_sel_aba07_1 INTO l_cdl11
    #No.FUN-D60110 ---Mod--- End
        SELECT npp00 INTO l_npp00 FROM npp_file WHERE npp01=l_cdl11 AND npptype = '1'
        IF l_npp00 = 6 THEN
       #IF NOT cl_null(l_cdl12) THEN  
           SELECT DISTINCT cdl12 INTO l_cdl12 FROM cdl_file
            WHERE cdl11 = l_cdl11         
           LET l_nppglno = NULL
           SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = l_cdl12 AND nppsys ='CA' AND npp00 =7 AND npp011 =1 AND npptype = '1' 
           IF NOT cl_null(l_nppglno) THEN
             #str CHI-C20017 mod
              #CALL cl_err('','axc-528',0)
              #LET g_success ='N'
              #RETURN  
              LET g_success = 'N'
             #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
                 CALL s_errmsg('','','','axc-528',1)
             #No.FUN-D60110 ---Mark--- Start
             #ELSE
             #   CALL cl_err('','axc-528',0)
             #   RETURN
             #END IF
             #end CHI-C20017 mod
             #No.FUN-D60110 ---Mark--- End
           END IF
        END IF
     END FOREACH   #No.FUN-D60110   Add
#No.FUN-AA0025 --end
     IF g_bgjob = 'N' THEN   #NO.FUN-570153 
         MESSAGE "Delete GL's Voucher body!"  #-------------------------
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abb_file WHERE abb01=? AND abb00=?"
     LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","abb01")        #No.FUN-D60110  Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abb_file'),#FUN-A50102
              #" WHERE abb01=? AND abb00=?"   #No.FUN-D60110   Mark
               " WHERE abb00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p302_2_p6 FROM g_sql
    #EXECUTE p302_2_p6 USING g_existno1,g_ccz.ccz121   #No.FUN-D60110  Mark
     EXECUTE p302_2_p6 USING g_ccz.ccz121              #No.FUN-D60110  Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del abb)',SQLCA.sqlcode,1) 
        #LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
           CALL s_errmsg('','','(del abb)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del abb)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
     IF g_bgjob = 'N' THEN   #NO.FUN-570153 
         MESSAGE "Delete GL's Voucher head!"  #-------------------------
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"aba_file WHERE aba01=? AND aba00=?"
     LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","aba01")        #No.FUN-D60110  Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aba_file'),#FUN-A50102
              #" WHERE aba01=? AND aba00=?"   #No.FUN-D60110   Mark
               " WHERE aba00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p302_2_p7 FROM g_sql
    #EXECUTE p302_2_p7 USING g_existno1,g_ccz.ccz121   #No.FUN-D60110  Mark
     EXECUTE p302_2_p7 USING g_ccz.ccz121              #No.FUN-D60110  Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del aba)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
           CALL s_errmsg('','','(del aba)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
     IF SQLCA.sqlerrd[3] = 0 THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del aba)','aap-161',1) LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
           CALL s_errmsg('','','(del aba)','aap-161',1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del aba)','aap-161',1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
     IF g_bgjob = 'N' THEN   #NO.FUN-570153 
         MESSAGE "Delete GL's Voucher desp!"  #-------------------------
         CALL ui.Interface.refresh()
     END IF
     #LET g_sql="DELETE FROM ",g_dbs_gl,"abc_file WHERE abc01=? AND abc00=?"
     LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","abc01")        #No.FUN-D60110  Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abc_file'),#FUN-A50102
              #" WHERE abc01=? AND abc00=?"   #No.FUN-D60110   Mark
               " WHERE abc00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
     PREPARE p302_2_p8 FROM g_sql
    #EXECUTE p302_2_p8 USING g_existno1,g_ccz.ccz121   #No.FUN-D60110  Mark
     EXECUTE p302_2_p8 USING g_ccz.ccz121              #No.FUN-D60110  Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del abc)',SQLCA.sqlcode,1) LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
           CALL s_errmsg('','','(del abc)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del abc)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
#FUN-B40056  --begin
     LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","tic04")        #No.FUN-D60110  Add
     LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
              #" WHERE tic04=? AND tic00=?"   #No.FUN-D60110   Mark
               " WHERE tic00=? AND ",tm.wc2 CLIPPED   #No.FUN-D60110   Add
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
     PREPARE p302_2_p10 FROM g_sql
    #EXECUTE p302_2_p10 USING g_existno1,g_ccz.ccz121   #No.FUN-D60110  Mark
     EXECUTE p302_2_p10 USING g_ccz.ccz121              #No.FUN-D60110  Add
     IF SQLCA.sqlcode THEN
        #str CHI-C20017 mod
        #CALL cl_err('(del tic)',SQLCA.sqlcode,1) 
        #LET g_success = 'N' RETURN
        LET g_success = 'N'
       #IF g_bgjob = 'Y' THEN   #No.FUN-D60110  Mark
           CALL s_errmsg('','','(del tic)',SQLCA.sqlcode,1)
       #No.FUN-D60110 ---Mark--- Start
       #ELSE
       #   CALL cl_err('(del tic)',SQLCA.sqlcode,1)
       #   RETURN
       #END IF
       #end CHI-C20017 mod
       #No.FUN-D60110 ---Mark--- End
     END IF
#FUN-B40056  --end
   END IF
   IF g_bgjob = 'N' THEN   #NO.FUN-570153 
       MESSAGE "Delete GL's Voucher detail!"  #-------------------------
       CALL ui.Interface.refresh()
   END IF  
   IF g_success = 'N' THEN RETURN END IF

  #FUN-C70093--ADD-STR
  #No.FUN-D60110 ---Mod--- Start
  #SELECT npp00,npp01 INTO l_npp.npp00,l_npp.npp01  FROM npp_file WHERE nppglno=g_existno
  #                                                                     AND npptype='1'
  #                                                                     AND npp07 = g_ccz.ccz12
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","nppglno")        #No.FUN-D60110  Add
   LET g_sql = "SELECT npp00,npp01 FROM npp_file ",
               " WHERE npptype='1' ",
               "   AND npp07 = '",g_ccz.ccz12,"'",
               "   AND ",tm.wc2 CLIPPED
   PREPARE p302_npp01_prep_1 FROM g_sql
   DECLARE p302_npp01_p_1 CURSOR FOR p302_npp01_prep_1
   FOREACH p302_npp01_p_1 INTO l_npp.npp00,l_npp.npp01
      #No.FUN-D60110 ---Mod--- End
      IF l_npp.npp00=9 THEN
         DECLARE cdm_cs1 CURSOR FOR
         SELECT cdm02,cdm03,cdm04,cdm05,cdm06,cdm11 FROM cdm_file
          WHERE cdm10=l_npp.npp01
         FOREACH cdm_cs1 INTO l_cdm02,l_cdm03,l_cdm04,l_cdm05,l_cdm06,l_cdm11
            UPDATE ccb_file SET ccbglno=null WHERE ccb01=l_cdm06
                                               AND ccb02=l_cdm02
                                               AND ccb03=l_cdm03
                                               AND ccb04=l_cdm11
                                               AND ccb06=l_cdm04
                                               AND ccb07=l_cdm05
            IF STATUS THEN
              #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
                  CALL s_errmsg('','','(upd ccbglno)',STATUS,1)
              #No.FUN-D60110 ---Mark--- Start
              #ELSE
              #   CALL cl_err3("upd","ccb_file",g_existno,"",STATUS,"","upd ccbglno",1)
              #   RETURN
              #END IF
              #No.FUN-D60110 ---Mark--- End
            END IF
          END FOREACH
       END IF
   END FOREACH   #No.FUN-D60110   Add
   #FUN-C70093--ADD--END 
    # #FUN-C70093--ADD--END
   LET g_msg = TIME
   INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980009 add azoplant,azolegal
          VALUES('axcp302',g_user,g_today,g_msg,g_existno1,'delete',g_plant,g_legal) #FUN-980009 add g_plant,g_legal
   #----------------------------------------------------------------------
  #No.FUN-D60110 ---Mod--- Start
  #UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,
  #                    npp06 = NULL ,npp07  = NULL 
  # WHERE nppglno=g_existno1
  #   AND npptype = '1'     #No.FUN-680086
  #   AND npp07 = g_ccz.ccz121    #No.FUN-680086
   LET tm.wc2 = cl_replace_str(g_existno1_str,"g_existno","nppglno")        #No.FUN-D60110  Add
   LET g_sql = "UPDATE npp_file SET npp03 = NULL ,nppglno= NULL,",
               "                    npp06 = NULL ,npp07  = NULL ",
               " WHERE ",tm.wc2 CLIPPED,
               "   AND npptype = '1'",    
               "   AND npp07 = '",g_ccz.ccz121,"'"
   PREPARE p302_npp_prep_1 FROM g_sql
   EXECUTE p302_npp_prep_1
  #No.FUN-D60110 ---Mod--- End
   IF STATUS THEN
      #str CHI-C20017 mod
      #CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","(upd npp03)",1)   #No.FUN-660127
      #LET g_success='N'
      #RETURN
      LET g_success = 'N'
     #IF g_bgjob = 'Y' THEN   #No.FUN-D60110   Mark
         CALL s_errmsg('','','(upd npp03)',STATUS,1)
     #No.FUN-D60110 ---Mark--- Start
     #ELSE
     #   CALL cl_err3("upd","npp_file",g_existno1,"",STATUS,"","(upd npp03)",1)
     #   RETURN
     #END IF
     ##end CHI-C20017 mod
     #No.FUN-D60110 ---Mark--- End
   END IF
  #No.FUN-CB0096 ---start--- Add
  #LET l_time = TIME   #No.FUN-D60110 Mark
   LET l_time = l_time + 1 #No.FUN-D60110   Add
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('I','114',g_id,'2',l_time,g_existno,'')
  #No.FUN-CB0096 ---end  --- Add
END FUNCTION
#No.FUN-680086 --end

#No.FUN-D60110 ---Add--- Start
FUNCTION p302_existno_chk()
   DEFINE   l_chk_bookno       LIKE type_file.num5    
   DEFINE   l_chk_bookno1      LIKE type_file.num5    
   DEFINE   l_abapost,l_flag   LIKE type_file.chr1    
   DEFINE   l_aba19            LIKE aba_file.aba19 
   DEFINE   l_abaacti          LIKE aba_file.abaacti
   DEFINE   l_aba01            LIKE aba_file.aba01 
   DEFINE   l_aba00            LIKE aba_file.aba00 
   DEFINE   l_aaa07            LIKE aaa_file.aaa07 
   DEFINE   l_npp00            LIKE npp_file.npp00 
   DEFINE   l_npp01            LIKE npp_file.npp01
   DEFINE   l_npp07            LIKE npp_file.npp07     
   DEFINE   l_nppglno          LIKE npp_file.nppglno   
   DEFINE   l_cnt              LIKE type_file.num5    
   DEFINE   lc_cmd             LIKE type_file.chr1000 
   DEFINE   l_sql              STRING        
   DEFINE   l_cnt1             LIKE type_file.num5     
   DEFINE   l_aba20            LIKE aba_file.aba20    


    #重新抓取關帳日期
    SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'

   LET tm.wc2 = cl_replace_str(tm.wc1,"g_existno","aba01") 
   LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20,aba01 ", 
             "  FROM ",cl_get_target_table(p_plant,'aba_file'),
             " WHERE aba00 = ? AND aba06='CA' AND",tm.wc2 CLIPPED
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql 
   PREPARE p302_t_p1 FROM g_sql
   DECLARE p302_t_c1 CURSOR FOR p302_t_p1
   IF STATUS THEN
        CALL s_errmsg('decl p302_t_c1:','','',STATUS,1)
        LET g_success = 'N'
    END IF
   
    OPEN p302_t_c1 USING g_ccz.ccz12
    FOREACH p302_t_c1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19,l_abaacti,l_aba20,l_aba01 
       IF STATUS THEN
         CALL s_errmsg('sel aba:','','',STATUS,1) 
         LET g_success = 'N'
       END IF
      
       IF l_abaacti = 'N' THEN
         CALL s_errmsg('sel aba:','','','mfg8001',1)    
         LET g_success = 'N'
       END IF
       IF l_aba20 MATCHES '[Ss1]' THEN
         CALL s_errmsg('sel aba:','','','mfg3557',1)  
         LET g_success = 'N'
       END IF
       IF l_abapost = 'Y' THEN
         CALL s_errmsg('sel aba:','','','aap-130',1)   
         LET g_success = 'N'
       END IF
       IF gl_date < g_sma.sma53 THEN 
            CALL s_errmsg('sel aba:','','','aap-027',1) 
            LET g_success = 'N'
       END IF
       IF l_aba19 ='Y' THEN 
         CALL s_errmsg('sel aba:','','','aap-026',1)    
         LET g_success = 'N'
       END IF
   END FOREACH
   IF g_aza.aza63 = 'Y' THEN
      LET tm.wc2 = cl_replace_str(tm.wc1,"aba01","nppglno")
      LET g_sql = "SELECT unique npp07,nppglno ",
                  "  FROM npp_file",
                  " WHERE npp01 IN (SELECT npp01 FROM npp_file",
                  "                  WHERE npp07 = '",p_bookno,"'",
                  "                    AND ",tm.wc2 CLIPPED,
                  "                    AND npptype = '0'",
                  "                    AND nppsys = 'CA')",
                  "   AND npptype = '1' ",
                  "   AND nppsys = 'CA' "
      PREPARE p302_sel_npp1 FROM g_sql
      DECLARE p302_sel_npp CURSOR FOR p302_sel_npp1
      FOREACH p302_sel_npp INTO l_npp07,l_nppglno
         IF STATUS THEN
            IF STATUS = 100 THEN
            ELSE
               CALL s_errmsg('sel nnp_file:','','',STATUS,1) 
               LET g_success = 'N'
            END IF
         ELSE
            DISPLAY l_npp07 TO FORMONLY.p_bookno1
            DISPLAY l_nppglno TO FORMONLY.g_existno1
            LET g_ccz.ccz121 = l_npp07
            IF cl_null(g_existno1) THEN 
               LET g_existno1 = "'",l_nppglno,"'"
               LET g_existno1_str = g_existno1
            ELSE
               LET g_existno1_str = g_existno1_str,",","'",l_nppglno,"'"
            END IF
            LET g_existno1 = l_nppglno
            LET g_sql="SELECT aba02,aba03,aba04,abapost,aba19,abaacti,aba20 ",    
                      "  FROM ",cl_get_target_table(p_plant,'aba_file'),
                      " WHERE aba01 = ? AND aba00 = ? AND aba06='CA'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql 
            PREPARE p302_t_p2 FROM g_sql
            DECLARE p302_t_c2 CURSOR FOR p302_t_p2
            IF STATUS THEN
               CALL s_errmsg('decl p302_t_c2:','','',STATUS,1)   
               LET g_success = 'N'
            END IF
      
            OPEN p302_t_c1 USING g_existno1,g_ccz.ccz121
            FOREACH p302_t_c1 INTO gl_date,gl_yy,gl_mm,l_abapost,l_aba19,l_abaacti,l_aba20   
               IF STATUS THEN
                  CALL s_errmsg('sel aba:','','',STATUS,1)   
                  LET g_success = 'N'
               END IF
      
               IF l_abaacti = 'N' THEN
                  CALL s_errmsg('sel aba:','','','mfg8001',1)  
                  LET g_success = 'N'
               END IF
               IF l_aba20 MATCHES '[Ss1]' THEN
                  CALL s_errmsg('sel aba:','','','mfg3557',1) 
                  LET g_success = 'N'
               END IF
               IF l_abapost = 'Y' THEN
                  CALL s_errmsg('sel aba:','','','aap-130',1)  
                  LET g_success = 'N'
               END IF
               IF gl_date < g_sma.sma53 THEN 
                  CALL s_errmsg('sel aba:','','','aap-027',1)
                  LET g_success = 'N'
               END IF
               IF l_aba19 ='Y' THEN 
                  CALL s_errmsg('sel aba:','','','aap-026',1) 
                  LET g_success = 'N'
               END IF
            END FOREACH
         END IF
      END FOREACH
      LET g_existno1_str = "g_existno IN (",g_existno1_str,")"
   END IF

END FUNCTION
#No.FUN-D60110 ---Add--- End
