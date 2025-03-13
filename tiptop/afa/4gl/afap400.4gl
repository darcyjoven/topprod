# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: afap400.4gl
# Descriptions...: 自動攤提折舊作業
# Date & Author..: 96/06/11 By Melody
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-4B0086 04/11/11 By Nicola 放寬t_rate,t_rate2小數為十位
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.TQC-620041 06/02/14 By Smapmin 計算折舊時,先四捨五入再處理金額
# Modify.........: No.FUN-570144 06/03/06 By yiting 批次背景執行
# Modify.........: No.MOD-640510 06/04/19 By Smapmin Update faj時,是以m_faj205給值而非g_faj.faj205
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 語言按紐在鼠標點擊下無效，要按鍵盤上‘ENTER’鍵，才會有效
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-770014 07/07/04 By Smapmin 修改取位問題
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 將原本的程式段備份於afap400.bak,該張單子將程式段依照afap300重新調整
# Modify.........: No.MOD-8A0225 08/10/27 By Sarah 將m_faj24改回LIKE faj_file.faj24
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-970218 09/07/24 By Sarah 抓取aao_file的餘額時,應該分科目性質(aag04)來決定
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No:CHI-A60006 10/06/08 By Summer 調整定率遞減法的折舊計算
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No:TQC-B20074 11/02/18 By yinhy 增加欄位fao20,fao201
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No:MOD-BB0115 11/11/12 By johung afa-177已不使用，相關程式段mark
# Modify.........: No.MOD-C10160 12/02/01 By Polly 無資料需顯示執行失敗
# Modify.........: No.MOD-C20218 12/02/28 By Polly 若當月處份不提折舊時，所有單據應皆確認、過帳後，才能提折舊
# Modify.........: No.MOD-C50067 12/05/11 By Elise 稅簽折舊攤提多部門分攤的問題
# Modify.........: No.MOD-C50148 12/05/24 By Polly 調整稅簽折舊攤提多部門分攤
# Modify.........: No.MOD-C60016 12/06/12 By Elise 稅簽資產狀態若為『折畢再提』，afai100中的稅簽資產狀態需為『折畢再提』
# Modify.........: No.MOD-C60169 12/06/21 By Polly 調整afap400折舊邏輯和afap300一樣
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢
# Modify.........: No.MOD-D20155 13/02/26 By Polly 參數faa23='N'時若是部份出售/報廢/銷帳,當月應可針對未處份的資產進行折舊

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql  STRING,  
       m_yy             LIKE faa_file.faa11,
       m_mm             LIKE faa_file.faa12,
       g_yy             LIKE type_file.chr4,
       g_mm             LIKE type_file.chr2,
       g_ym             LIKE type_file.chr6,
       tm               RECORD
                        yy   LIKE type_file.num5,
                        mm   LIKE type_file.num5
                        END RECORD,
       m_tot            LIKE type_file.num20_6,   
       m_tot_fao07      LIKE fao_file.fao07, 
       m_tot_fao14      LIKE fao_file.fao14, 
       m_tot_fao15      LIKE fao_file.fao15, 
       m_tot_fao17      LIKE fao_file.fao17,
       m_tot_curr       LIKE type_file.num20_6,
       l_first2,l_last2 LIKE type_file.dat,    
       l_first,l_last   LIKE type_file.num5,
       g_cnt,g_cnt2     LIKE type_file.num5,
       g_cnt3           LIKE type_file.num5,       #MOD-C20218 add
       g_have           VARCHAR(01),               #MOD-C20218 add
       g_chk_err        VARCHAR(01),               #MOD-C20218 add
       g_type           LIKE type_file.chr1,
       g_faj       RECORD LIKE faj_file.*,
       g_fao       RECORD LIKE fao_file.*,
       g_fae       RECORD LIKE fae_file.*,
       m_aao            LIKE type_file.num20_6,
       m_amt,m_amt2,m_cost,m_accd,m_curr LIKE type_file.num20_6,  
       m_fao07     LIKE fao_file.fao07, 
       m_fao08     LIKE fao_file.fao08, 
       m_fao14     LIKE fao_file.fao14, 
       m_fao15     LIKE fao_file.fao15, 
       m_fao17     LIKE fao_file.fao17,
       mm_fao07    LIKE fao_file.fao07,
       mm_fao08    LIKE fao_file.fao08,
       mm_fao14    LIKE fao_file.fao14,
       mm_fao15    LIKE fao_file.fao15,
       mm_fao17    LIKE fao_file.fao17,
       m_ratio,mm_ratio  LIKE type_file.num26_10,   
       m_faa02b    LIKE aaa_file.aaa01,    
       m_status    LIKE type_file.chr1,
       l_diff,l_diff2  LIKE fao_file.fao07,
       m_faj24     LIKE faj_file.faj24,   #MOD-8A0225 mod
       m_faj65     LIKE faj_file.faj65,
       m_faj67     LIKE faj_file.faj67,
       m_faj205    LIKE faj_file.faj205,
       m_faj74     LIKE faj_file.faj74,
       m_faj741    LIKE faj_file.faj741,
       m_fad05     LIKE fad_file.fad05,
       m_fad031    LIKE fad_file.fad031,
       m_fae08,mm_fae08   LIKE fae_file.fae08,
       p_row,p_col LIKE type_file.num5,
       g_fao07_year, g_fao07_all LIKE fao_file.fao07,
       g_msg       LIKE type_file.chr1000,
       l_flag      LIKE type_file.chr1            
DEFINE l_bdate     LIKE type_file.dat  #No.TQC-7B0060
DEFINE l_edate     LIKE type_file.dat  #No.TQC-7B0060
 
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  
                  faj02     LIKE faj_file.faj02,
                  faj022    LIKE faj_file.faj022,
                  ze01      LIKE ze_file.ze01,
                  ze03      LIKE ze_file.ze03
        END RECORD,
        l_msg,l_msg2    STRING,
        lc_gaq03  LIKE gaq_file.gaq03

DEFINE g_show_msg2 DYNAMIC ARRAY OF RECORD     #MOD-C20218 add
           memo    LIKE type_file.chr1000,     #MOD-C20218 add
           f_no    LIKE faq_file.faq01,        #MOD-C20218 add
           ze03    LIKE ze_file.ze03           #MOD-C20218 add
       END RECORD                              #MOD-C20218 add 
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET tm.yy   = ARG_VAL(2)
   LET tm.mm   = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
  #----------------------MOD-C20218----------------------start
   CREATE TEMP TABLE p400_tmp
     (faj09  LIKE faj_file.faj09,
      faj04  LIKE faj_file.faj04,
      faj02  LIKE faj_file.faj02)
  #----------------------MOD-C20218------------------------end
   WHILE TRUE
      IF g_bgjob = "N" THEN
         SELECT * INTO g_faa.* FROM faa_file WHERE faa00='0'
         SELECT faa02b,faa11,faa12 INTO m_faa02b,m_yy,m_mm FROM faa_file
          WHERE faa00='0'
         IF SQLCA.sqlcode THEN LET m_faa02b='00' END IF
         #CALL s_azm(m_yy,m_mm) RETURNING l_flag,l_bdate,l_edate #No.TQC-7B0060 #CHI-A60036 mark
         #CHI-A60036 add --start--
      #  IF g_aza.aza63 = 'Y' THEN
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
            CALL s_azmm(m_yy,m_mm,g_faa.faa02p,g_faa.faa02b) RETURNING l_flag,l_bdate,l_edate
         ELSE
           CALL s_azm(m_yy,m_mm) RETURNING l_flag,l_bdate,l_edate
         END IF
         #CHI-A60036 add --end--
         CALL p400()
         IF cl_sure(18,20) THEN
            LET g_cnt2 = 1
            CALL g_show_msg.clear()
            LET g_chk_err = 'N'             #MOD-C20218 add
            CALL p400_process()
            IF g_chk_err = 'Y' THEN         #MOD-C20218 add
               CONTINUE WHILE               #MOD-C20218 add
            END IF                          #MOD-C20218 add
            IF g_show_msg.getLength() > 0 THEN 
               CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
               CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
               CONTINUE WHILE
            ELSE
               CALL cl_end2(1) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p400_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_cnt2 = 1
         CALL g_show_msg.clear()
         CALL p400_process()
         IF g_show_msg.getLength() > 0 THEN 
            CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
            CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
   DROP TABLE p400_tmp                                 #MOD-C20218 add
END MAIN
   
FUNCTION p400()
   DEFINE   lc_cmd    LIKE type_file.chr1000      
 
   OPEN WINDOW p400_w AT p_row,p_col WITH FORM "afa/42f/afap400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CLEAR FORM
   CALL cl_opmsg('w')
   IF g_aza.aza26 = '2' THEN                                                   
      CALL cl_err('','afa-397',0)                                              
   END IF                                                                      
 
#  LET tm.yy=m_yy LET tm.mm=m_mm  #No.TQC-7B0060 mark
   LET tm.yy = YEAR(l_bdate)      #No.TQC-7B0060
   LET tm.mm = MONTH(l_bdate)     #No.TQC-7B0060
   LET m_tot=0
   LET m_tot_fao07=0
   LET m_tot_fao14=0
   LET m_tot_fao15=0
   LET m_tot_fao17=0        
   LET m_tot_curr =0
   LET g_yy = m_yy
   LET g_mm = m_mm
   LET g_ym = g_yy USING '&&&&',g_mm USING '&&'
   LET l_first2 = MDY(g_mm,1,g_yy)
   CALL s_mothck_ar(l_first2) RETURNING l_first2,l_last2
   LET l_last = DAY(l_last2)
 
   LET g_bgjob = "N"
 
   WHILE TRUE
 
   CALL cl_opmsg('a')
   DISPLAY g_yy TO FORMONLY.yy 
   DISPLAY g_mm TO FORMONLY.mm 
   LET g_bgjob = "N"
   INPUT BY NAME g_bgjob WITHOUT DEFAULTS   
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION locale                          
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION exit                          
         LET INT_FLAG = 1
         EXIT INPUT 
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p400_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
     EXIT PROGRAM
   END IF
 
   CONSTRUCT BY NAME g_wc ON faj09,faj04,faj02 
 
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
     ON ACTION controlg      
        CALL cl_cmdask()     
  
     ON ACTION exit                          
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
     ON ACTION qbe_select
        CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_wc =' 1=1' THEN
      CALL cl_err('','9046',0) 
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "afap400"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap400','9031',1)  
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.mm CLIPPED,"'",
                      " '",g_bgjob  CLIPPED,"'"
         CALL cl_cmdat('afap400',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
 
END FUNCTION
 
FUNCTION p400_process()
   DEFINE l_over        LIKE type_file.chr1,
          l_fbi02       LIKE fbi_file.fbi02,
          l_fbi021      LIKE fbi_file.fbi021,
          l_faj68       LIKE faj_file.faj68,
          m_faj72       LIKE faj_file.faj72,
          p_yy,p_mm     LIKE type_file.num5,   
          p_fao08       LIKE fao_file.fao08,   
          p_fao15       LIKE fao_file.fao15,   
          l_rate        LIKE azx_file.azx04,          
          l_rate_y      LIKE type_file.num20_6,
          t_rate        LIKE type_file.num26_10,         
          t_rate2       LIKE type_file.num26_10,          
          l_fgj05       LIKE fgj_file.fgj05,
          l_amt_y       LIKE faj_file.faj66
   DEFINE g_flag        LIKE type_file.chr1   #MOD-970218 add
   DEFINE g_bookno1     LIKE aza_file.aza81   #MOD-970218 add
   DEFINE g_bookno2     LIKE aza_file.aza82   #MOD-970218 add
   DEFINE l_aag04       LIKE aag_file.aag04   #MOD-970218 add
   DEFINE l_bdate       LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1   #CHI-9A0021 add
   DEFINE l_count       LIKE type_file.num5   #09/10/19 xiaofeizhu Add
#CHI-A60006 add --start--
   DEFINE l_depr_amt    LIKE type_file.num10
   DEFINE l_depr_amt0   LIKE type_file.num10
   DEFINE l_depr_amt_1  LIKE type_file.num10
   DEFINE l_depr_amt_2  LIKE type_file.num10
   DEFINE l_year1       LIKE type_file.chr4
   DEFINE l_year_new    LIKE type_file.chr4
   DEFINE l_year2       LIKE type_file.chr4
   DEFINE l_month1      LIKE type_file.chr2
   DEFINE l_month2      LIKE type_file.chr2
   DEFINE l_date        STRING
   DEFINE l_date2       DATE
   DEFINE l_date_old    DATE
   DEFINE l_date_new    DATE 
   DEFINE l_date_today  DATE
   DEFINE l_cnt         LIKE type_file.num5
#CHI-A60006 add --end--
   DEFINE l_db_type  STRING       #FUN-B40029
   DEFINE l_flag        LIKE type_file.chr1        #MOD-C10160 add
   DEFINE l_faj09       LIKE faj_file.faj09        #MOD-C20218 add
   DEFINE l_faj04       LIKE faj_file.faj04        #MOD-C20218 add
   DEFINE l_faj02       LIKE faj_file.faj02        #MOD-C20218 add
   DEFINE l_cnt1        LIKE type_file.num5        #MOD-C50067
 
   CALL s_get_bookno(m_yy) RETURNING g_flag,g_bookno1,g_bookno2  #MOD-970218 add
 
   #------------------ 資產主檔 SQL ----------------------------------
   # 判斷 資產狀態, 開始折舊年月, 確認碼, 折舊方法, 剩餘月數
   LET g_sql="SELECT '1',faj_file.* FROM faj_file ",
             #" WHERE faj201 NOT MATCHES '[0567X]' ",     #MOD-7B0133
            #" WHERE faj201 NOT MATCHES '[04567X]' ",     #MOD-7B0133   #MOD-BB0115 mark
             " WHERE faj201 NOT IN ('0','4','5','6','7','X') ",         #MOD-BB0115
             " AND faj27 <= '",g_ym CLIPPED,"'",
             " AND faj68+faj681-(faj103-faj104) > 0 ",    #MOD-BB0115 add
             " AND fajconf='Y' AND ",g_wc CLIPPED 
   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj61 IN ('1','2','3','4') "                 
   ELSE                                                                        
      LET g_sql = g_sql CLIPPED," AND faj61 IN ('1','2','3') "                  
   END IF                                                                      
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #FUN-B80081 mark
       LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' "	#FUN-B80081 add      
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," UNION ALL ", 
               "SELECT '2',faj_file.* FROM faj_file ",   #折畢再提/續提
              #" WHERE faj201 MATCHES '[7]' ",           #MOD-BB0115 mark
               " WHERE faj201 IN ('7') ",                #MOD-BB0115
               " AND faj61 = '1' ",
               " AND faj68-(faj103-faj104) > 0 ",        #MOD-BB0115 add
               " AND fajconf='Y' AND ",g_wc CLIPPED 
   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
      #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #FUN-B80081 mark
      LET g_sql = g_sql CLIPPED," AND faj43 <> 'Z' "	#FUN-B80081 add
   END IF                                                                      
   LET g_sql = g_sql CLIPPED," ORDER BY 3,4,5 "  
 
   PREPARE p400_pre FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p400_pre',STATUS,0) 
      RETURN 
   END IF
   DECLARE p400_cur CURSOR WITH HOLD FOR p400_pre
   LET l_flag ='N'                                     #MOD-C10160 add
  #---------------------------MOD-C20218---------------------start
   IF g_faa.faa23 = 'N' THEN
      CALL g_show_msg2.clear()
      LET g_cnt3 = 1
      DELETE FROM p400_tmp
      FOREACH p400_cur INTO g_type,g_faj.*
         SELECT *
           FROM p400_tmp
          WHERE faj09 = g_faj.faj09
            AND faj04 = g_faj.faj04
            AND faj02 = g_faj.faj02
         IF SQLCA.SQLCODE = 100 THEN
            INSERT INTO p400_tmp VALUES(g_faj.faj09,g_faj.faj04,
                                        g_faj.faj02)
         END IF
      END FOREACH
      DECLARE tmp_cr CURSOR FOR
       SELECT *
         FROM p400_tmp
      FOREACH tmp_cr INTO l_faj09,l_faj04,l_faj02
         CALL p400_chk(l_faj09,l_faj04,l_faj02)
      END FOREACH
      IF g_show_msg2.getLength() > 0 THEN
         LET l_msg = ""
         LET l_msg2 = ""
         CALL cl_get_feldname("gat03",g_lang) RETURNING lc_gaq03
              LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("faq01",g_lang) RETURNING lc_gaq03
              LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03
              LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
         CALL cl_show_array(base.TypeInfo.create(g_show_msg2),l_msg,l_msg2)
         LET g_success = 'N'
         LET g_chk_err = 'Y'
      END IF
      IF g_chk_err = 'Y' THEN RETURN END IF
   END IF
  #---------------------------MOD-C20218-----------------------end
   FOREACH p400_cur INTO g_type,g_faj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('p400_cur foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      LET g_success='Y'
      BEGIN WORK
      #--折舊月份已提列折舊,則不再提列(訊息不列入清單中)
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM fao_file 
        WHERE fao01=g_faj.faj02 AND fao02=g_faj.faj022
#         AND (fao03>tm.yy OR (fao03=tm.yy AND fao04>=tm.mm)) #No.TQC-7B0060 mark
          AND (fao03>m_yy OR (fao03=m_yy AND fao04>=m_mm))    #No.TQC-7B0060
          AND fao05 <> '3' AND fao041='1'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF
      #--
 
     #MOD-BB0115 -- mark begin --
     ##--已全額提列減值準備的固定資產,不再提列折舊                              
     #IF g_faj.faj68 - (g_faj.faj103 - g_faj.faj104) <= 0 THEN                 
     #   CALL cl_getmsg("afa-177",g_lang) RETURNING l_msg
     #   LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
     #   LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
     #   LET g_show_msg[g_cnt2].ze01   = 'afa-177'
     #   LET g_show_msg[g_cnt2].ze03   = l_msg
     #   LET g_cnt2 = g_cnt2 + 1
     #   CONTINUE FOREACH                                                      
     #END IF                                                                   
     ##--
     #MOD-BB0115 -- mark end --
 
     #當月起始日與截止日
      #CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A60036
      #CHI-A60036 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(tm.yy,tm.mm,g_faa.faa02p,g_faa.faa02b) RETURNING l_correct,l_bdate,l_edate
      ELSE
        CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate
      END IF
      #CHI-A60036 add --end--
 
      #--檢核異動未過帳
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fay_file,faz_file
        WHERE fay01=faz01 AND faz03=g_faj.faj02 AND faz031=g_faj.faj022
          AND faypost2<>'Y' 
         #AND YEAR(fay02)=tm.yy AND MONTH(fay02)=tm.mm #CHI-9A0021
          AND fay02 BETWEEN l_bdate AND l_edate        #CHI-9A0021
          AND fayconf<>'X'
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-180",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-180'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fba_file,fbb_file
        WHERE fba01=fbb01 AND fbb03=g_faj.faj02 AND fbb031=g_faj.faj022
          AND fbapost2<>'Y' 
         #AND YEAR(fba02)=tm.yy AND MONTH(fba02)=tm.mm  #CHI-9A0021
          AND fba02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
          AND fbaconf<>'X' 
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-181",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-181'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fbc_file,fbd_file
        WHERE fbc01=fbd01 AND fbd03=g_faj.faj02 AND fbd031=g_faj.faj022
          AND fbcpost2<>'Y' 
         #AND YEAR(fbc02)=tm.yy AND MONTH(fbc02)=tm.mm  #CHI-9A0021
          AND fbc02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
          AND fbcconf<>'X'
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-182",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-182'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
 
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fgh_file,fgi_file
        WHERE fgh01=fgi01 AND fgi06=g_faj.faj02 AND fgi07=g_faj.faj022
          AND fghconf<>'Y' 
         #AND YEAR(fgh02)=tm.yy AND MONTH(fgh02)=tm.mm  #CHI-9A0021
          AND fgh02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
          AND fgh03='2'  
          AND fghconf<>'X'  #CHI-C80041
      IF g_cnt > 0 THEN
         CALL cl_getmsg("afa-183",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-183'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH                                                      
      END IF
      #--
 
      #--檢核當月處份應提列折舊='N',已存在處份資料,不可進行折舊 
      IF g_faa.faa23 = 'N' THEN
         IF g_faj.faj17 - g_faj.faj58 = 0 THEN                             #MOD-D20155 add
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM fbg_file,fbh_file
              WHERE fbg01=fbh01 AND fbh03=g_faj.faj02 AND fbh031=g_faj.faj022
               #AND YEAR(fbg02)=tm.yy AND MONTH(fbg02)=tm.mm  #CHI-9A0021
                AND fbg02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
                AND fbgconf<>'X'
            IF g_cnt > 0 THEN
               CALL cl_getmsg("afa-184",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-184'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH                                                      
            END IF
            
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM fbe_file,fbf_file
              WHERE fbe01=fbf01 AND fbf03=g_faj.faj02 AND fbf031=g_faj.faj022
               #AND YEAR(fbe02)=tm.yy AND MONTH(fbe02)=tm.mm  #CHI-9A0021
                AND fbe02 BETWEEN l_bdate AND l_edate         #CHI-9A0021
                AND fbeconf<>'X'
            IF g_cnt > 0 THEN
               CALL cl_getmsg("afa-185",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-185'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH                                                      
            END IF
         END IF                                                              #MOD-D20155 add
      END IF
      #--
 
      #--若在折舊月份前就為先前折畢
#No.TQC-7B0060 --start--
#     IF g_faj.faj65 = 0 and ( g_faj.faj74 < tm.yy or
#        ( g_faj.faj74=tm.yy and g_faj.faj741 < tm.mm )) THEN
      IF g_faj.faj65 = 0 and ( g_faj.faj74 < m_yy or
         ( g_faj.faj74=m_yy and g_faj.faj741 < m_mm )) THEN
#No.TQC-7B0060
         LET l_over = 'Y'    
      ELSE
         LET l_over = 'N'    
      END IF 
      #--
 
      #--折舊提列時，再檢查/設定折舊科目
      IF g_faa.faa20 = '2' THEN  
         IF g_faj.faj23='1' THEN 
            DECLARE p400_fbi CURSOR FOR
            SELECT fbi02,fbi021 FROM fbi_file WHERE fbi01=g_faj.faj24 AND fbi03= g_faj.faj04  
            FOREACH p400_fbi INTO l_fbi02,l_fbi021
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_fbi02) THEN
                  EXIT FOREACH
               END IF
           #   IF g_aza.aza63 = 'Y' THEN 
               IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
                  IF NOT cl_null(l_fbi021) THEN
                     EXIT FOREACH
                  END IF
               END IF
            END FOREACH
            IF cl_null(l_fbi02) THEN
               CALL cl_getmsg("afa-317",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-317'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
            LET g_faj.faj55 = l_fbi02
            UPDATE faj_file SET faj55=l_fbi02
             WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02
               AND faj022=g_faj.faj022
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = ''
               LET g_show_msg[g_cnt2].ze03   = 'upd faj_file' 
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
         #  IF g_aza.aza63 = 'Y' THEN
            IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
               IF cl_null(l_fbi021) THEN
                  CALL cl_getmsg("afa-317",g_lang) RETURNING l_msg
                  LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                  LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                  LET g_show_msg[g_cnt2].ze01   = 'afa-317'
                  LET g_show_msg[g_cnt2].ze03   = l_msg
                  LET g_cnt2 = g_cnt2 + 1
                  CONTINUE FOREACH
               END IF
               LET g_faj.faj551 = l_fbi021
               UPDATE faj_file SET faj551=l_fbi021
                WHERE faj01=g_faj.faj01 AND faj02=g_faj.faj02
                  AND faj022=g_faj.faj022
               IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                  LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                  LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                  LET g_show_msg[g_cnt2].ze01   = ''
                  LET g_show_msg[g_cnt2].ze03   = 'upd faj_file' 
                  LET g_cnt2 = g_cnt2 + 1
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
      ELSE
         IF cl_null(g_faj.faj55) THEN
            CALL cl_getmsg("afa-361",g_lang) RETURNING l_msg
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = 'afa-361'
            LET g_show_msg[g_cnt2].ze03   = l_msg
            LET g_cnt2 = g_cnt2 + 1
            CONTINUE FOREACH
         END IF
    #    IF g_aza.aza63 = 'Y' THEN
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
            IF cl_null(g_faj.faj551) THEN
               CALL cl_getmsg("afa-361",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-361'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      #--
 
     #IF g_faj.faj68 <= g_faj.faj66 THEN                        #MOD-C60169 mark
      IF g_faj.faj68 <= g_faj.faj66 OR g_faj.faj201 = '7' THEN  #MOD-C60169 add
         LET g_type = '2'
      ELSE
         LET g_type = '1'
      END IF
 
      #計算本期折舊金額
      #因為舊資料中,仍有主件止舊,而副件續繼的情形
      #附件之剩餘月數以主件為主
      LET m_faj65=g_faj.faj65   
      #-----CHI-810009---------
      #IF not cl_null(g_faj.faj022) THEN
      #   SELECT faj65,faj74,faj741 INTO m_faj65,m_faj74,m_faj741 
      #     FROM faj_file WHERE faj02=g_faj.faj02 
      #      AND (faj022=' ' OR faj022 IS NULL) 
      #      AND faj201 not IN ('4','5','6')
      #   IF SQLCA.sqlcode THEN
      #      LET m_faj65=g_faj.faj65       
      #   ELSE
      #      #No.TQC-7B0060 --start--
      #      #IF NOT ( m_faj65=0 AND (m_faj74<tm.yy OR     # 主件已無剩餘月數
      #      #       (m_faj741=tm.yy AND m_faj741<tm.mm))) THEN 
      #      IF NOT ( m_faj65=0 AND (m_faj74<m_yy OR
      #             (m_faj741=m_yy AND m_faj741<m_mm))) THEN 
      #      #No.TQC-7B0060 --end--
      #         LET m_faj65 = m_faj65 + 1
      #      END IF
      #   END IF
      #   IF m_faj65=0 THEN
      #      LET m_faj65=g_faj.faj65
      #   END IF
      #END IF
      #-----END CHI-810009----- 
      #已為最後一期折舊則將剩餘淨值一併視為該期折舊
      LET l_amt_y = 0          
      IF m_faj65=1 THEN   
         IF g_type = '1' THEN 
            LET m_amt=g_faj.faj62+g_faj.faj63-g_faj.faj69                     
                                  -(g_faj.faj67-g_faj.faj70)                    
                                  -(g_faj.faj103-g_faj.faj104) - g_faj.faj66    
         ELSE  
            LET m_amt=g_faj.faj62+g_faj.faj63-g_faj.faj69
                                 -(g_faj.faj67-g_faj.faj70)-g_faj.faj72
         END IF
      ELSE
         IF m_faj65 = 0 THEN 
            LET m_amt = 0
         ELSE 
            CASE g_faj.faj61
               WHEN '1'    #有殘值
                  IF g_type = '1' THEN   #一般提列 
                     LET m_amt=(g_faj.faj62+g_faj.faj63-g_faj.faj69-        
                               (g_faj.faj67-g_faj.faj70)-g_faj.faj66-        
                               (g_faj.faj103-g_faj.faj104))/m_faj65          
                  ELSE                   #折畢提列
                     LET m_amt=(g_faj.faj62+g_faj.faj63-g_faj.faj69-
                               (g_faj.faj67-g_faj.faj70)-g_faj.faj72)/
                               m_faj65
                  END IF
               WHEN '2'    #無殘值
                  IF g_aza.aza26 = '2' THEN      #雙倍餘額遞減法             
                     IF m_faj65 > 24 THEN                                    
                        IF g_faj.faj109 = 0 OR (g_faj.faj65 MOD 12 = 0) THEN   #TQC-690087                        
                           LET l_rate_y = (2/(g_faj.faj64/12))               
                           LET l_amt_y = (g_faj.faj62+g_faj.faj63-          
                                          g_faj.faj69-                       
                                         (g_faj.faj67-g_faj.faj70))*l_rate_y 
                           LET m_amt = l_amt_y / 12                          
                        ELSE                                                 
                           LET m_amt = g_faj.faj109 / 12                     
                        END IF                                               
                     ELSE                                                    
                        IF m_faj65 = 24 THEN                                 
                           LET l_amt_y = (g_faj.faj62+g_faj.faj63-          
                                          g_faj.faj69-                       
                                         (g_faj.faj67-g_faj.faj70)-          
                                          g_faj.faj66) / 2                   
                           LET m_amt = l_amt_y / 12                          
                        ELSE                                                 
                           LET m_amt = g_faj.faj109 / 12                     
                        END IF                                               
                     END IF          
                  ELSE
                     LET m_amt=(g_faj.faj62+g_faj.faj63-g_faj.faj69-
                               (g_faj.faj67-g_faj.faj70))/m_faj65 
                  END IF
               WHEN '3'    #定率餘額遞減法
                  IF g_aza.aza26 = '2' THEN    #年數總合法                   
                     IF g_faj.faj109 = 0 OR (g_faj.faj65 MOD 12 = 0) THEN                         
                        LET l_rate_y = (m_faj65/12)/((g_faj.faj64/12)*       
                                       ((g_faj.faj64/12)+1)/2)               
                        LET l_amt_y = (g_faj.faj62+g_faj.faj63-g_faj.faj66) 
                                       * l_rate_y                            
                        LET m_amt = l_amt_y / 12                             
                     ELSE                                                    
                        LET m_amt = g_faj.faj109 / 12                        
                     END IF                                                  
                  ELSE           
                  #CHI-A60006 add --start--
                     #--計算前期日期範圍-----------
                     LET l_date = g_faj.faj27
                     LET l_year1 = l_date.substring(1,4)   #前期累折開始年度
                     LET l_month1 = l_date.substring(5,6)  #前期累折開始月份  
                     LET l_date_old = MDY(l_month1,01,l_year1)
                     LET l_date_new = MDY(l_month1,01,l_year1+1)
                     LET l_date_new = MDY(l_month1,01,l_year1+1)
                     LET l_date_today = MDY(g_mm,01,g_yy)
                     IF l_date_new <= l_date_today THEN
                         LET l_date_new = l_date_old
                         WHILE TRUE
                         IF l_date_new > l_date_today THEN  
                             LET l_date2 = l_date_old
                             EXIT WHILE
                         END IF
                         LET l_date_old = l_date_new
                         LET l_year_new = YEAR(l_date_new)+1
                         LET l_date_new = MDY(l_month1,01,l_year_new)
                         END WHILE
                    
                         LET l_year2 = YEAR(l_date2) 
                         LET l_month2 = MONTH(l_date2) USING '&&'

                    #先抓取主檔的累計折舊(faj67),
                    #再扣掉大於等於截止日期(l_year2/l_month2/01)的折舊加總值,
                    #就是該筆資產的前期累折金額
                         LET l_depr_amt = 0
                         LET l_depr_amt0= 0
                         LET l_depr_amt_1= 0
                         LET l_depr_amt_2= 0
                         LET g_sql = "SELECT faj67 FROM faj_file",
                                     " WHERE faj02 = '",g_faj.faj02,"'",
                                     "   AND faj022= '",g_faj.faj022,"'"
                         PREPARE p400_amt_p0 FROM g_sql
                         DECLARE p400_amt_c0 CURSOR WITH HOLD FOR p400_amt_p0
                         OPEN p400_amt_c0 
                         FETCH p400_amt_c0 INTO l_depr_amt0
                         IF cl_null(l_depr_amt0) THEN LET l_depr_amt0=0 END IF

                         #抓取前一次截止期+1~前一次折舊期間的折舊值,可用兩種方式抓取!
                         #1.找看看有沒有上一次截止期的折舊記錄,若有就直接SUM這段期間的折舊加總
                         LET l_db_type=cl_db_get_database_type()    #FUN-B40029
                         #FUN-B40029-add-start--
                         IF l_db_type='MSV' THEN #SQLSERVER的版本
                            LET g_sql = "SELECT COUNT(*) FROM fao_file",
                                        " WHERE fao01 = '",g_faj.faj02,"'",
                                        "   AND fao02 = '",g_faj.faj022,"'",
                                        "   AND fao03||'/'||SUBSTRING(('0'||fao04),length('0'||fao04)-1,2-length('0'||fao04)+1) ||'/01'",
                                        "             = '",l_year2,"/",l_month2,"/01'",
                                        "   AND fao041 = '1'"
                         ELSE 
                         #FUN-B40029-add-end--
                            LET g_sql = "SELECT COUNT(*) FROM fao_file",
                                        " WHERE fao01 = '",g_faj.faj02,"'",
                                        "   AND fao02 = '",g_faj.faj022,"'",
                                        "   AND fao03||'/'||SUBSTR(('0'||fao04),length('0'||fao04)-1,2) ||'/01'",
                                        "             = '",l_year2,"/",l_month2,"/01'",
                                        "   AND fao041 = '1'"
                         END IF     #FUN-B40029
                         PREPARE p400_amt_cnt_p FROM g_sql
                         DECLARE p400_amt_cnt_c CURSOR WITH HOLD FOR p400_amt_cnt_p
                         OPEN p400_amt_cnt_c 
                         FETCH p400_amt_cnt_c INTO l_cnt
                         IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
                         IF l_cnt > 0 THEN
                            #FUN-B40029-add-start--
                            IF l_db_type='MSV' THEN #SQLSERVER的版本
                               LET g_sql = "SELECT SUM(fao07) ",
                                           "  FROM fao_file ",
                                           " WHERE fao01 = '",g_faj.faj02,"'",
                                           "   AND fao02 = '",g_faj.faj022,"'",
                                           "   AND fao03||'/'||SUBSTRING(('0'||fao04),length('0'||fao04)-1,2-length('0'||fao04)+1) ||'/01'",
                                           "            >= '",l_year2,"/",l_month2,"/01'",
                                           "   AND fao041 = '1'"
                            ELSE
                            #FUN-B40029-add-end--
                               LET g_sql = "SELECT SUM(fao07) ",
                                           "  FROM fao_file ",
                                           " WHERE fao01 = '",g_faj.faj02,"'",
                                           "   AND fao02 = '",g_faj.faj022,"'",
                                           "   AND fao03||'/'||SUBSTR(('0'||fao04),length('0'||fao04)-1,2) ||'/01'",
                                           "            >= '",l_year2,"/",l_month2,"/01'",
                                           "   AND fao041 = '1'"
                            END  IF   #FUN-B40029
                            PREPARE p400_amt_p FROM g_sql
                            DECLARE p400_amt_c CURSOR WITH HOLD FOR p400_amt_p
                            OPEN p400_amt_c 
                            FETCH p400_amt_c INTO l_depr_amt      #前期累折   
                            IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
                         ELSE
                            #1.那這段期間的折舊加總可用(截止期-2)期別折舊額*11
                            #                         +(截止期-1)期別折舊額(因為有尾差會調在最後一期)
                            LET g_sql = "SELECT fao07*11 ",                        
                                        "  FROM fao_file ",                        
                                        " WHERE fao01 = '",g_faj.faj02,"'",        
                                        "   AND fao02 = '",g_faj.faj022,"'",       
                                        "   AND fao03 = ",l_year_new,
                                        "   AND fao04 = ",l_month2-2,              
                                        "   AND fao041 = '1'"                      
                            PREPARE p400_amt_p01 FROM g_sql
                            DECLARE p400_amt_c01 CURSOR WITH HOLD FOR p400_amt_p01
                            OPEN p400_amt_c01                 
                            FETCH p400_amt_c01 INTO l_depr_amt_1
                            IF cl_null(l_depr_amt_1) THEN LET l_depr_amt_1=0 END IF
                            LET g_sql = "SELECT fao07 ",                        
                                        "  FROM fao_file ",                        
                                        " WHERE fao01 = '",g_faj.faj02,"'",        
                                        "   AND fao02 = '",g_faj.faj022,"'",       
                                        "   AND fao03 = ",l_year_new,
                                        "   AND fao04 = ",l_month2-1,              
                                        "   AND fao041 = '1'"                      
                            PREPARE p400_amt_p1 FROM g_sql
                            DECLARE p400_amt_c1 CURSOR WITH HOLD FOR p400_amt_p1
                            OPEN p400_amt_c1
                            FETCH p400_amt_c1 INTO l_depr_amt_2
                            IF cl_null(l_depr_amt_2) THEN LET l_depr_amt_2=0 END IF
                         END IF
                         LET l_depr_amt=l_depr_amt0-(l_depr_amt_1+l_depr_amt_2+l_depr_amt)
                     ELSE
                         LET l_depr_amt = 0
                     END IF
                  #CHI-A60006 add --end--
                     IF g_type = '1' THEN   #一般提列 
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT power(g_faj.faj66/(g_faj.faj62+g_faj.faj63),   
                                   1/(g_faj.faj64/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) /12) * 100
                        LET m_amt=(g_faj.faj62+g_faj.faj63-g_faj.faj69-
                                  #(g_faj.faj67-g_faj.faj70)) *  #CHI-A60006 mark
                                  (l_depr_amt)) *                #CHI-A60006 add
                                  t_rate2 / 100
                     ELSE                   #折畢提列
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT power(g_faj.faj72/(g_faj.faj62+g_faj.faj63),
                                   1/(g_faj.faj64/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) / 12) * 100
                        LET m_amt=(g_faj.faj62+g_faj.faj63-g_faj.faj69-
                                  #(g_faj.faj67-g_faj.faj70)) *  #CHI-A60006 mark
                                  (l_depr_amt)) *                #CHI-A60006 add
                                  t_rate2 / 100
                     END IF
                  END IF
               OTHERWISE EXIT CASE
            END CASE
         END IF
      END IF
      IF g_aza.aza26 = '2' THEN                                                
         IF g_faj.faj61 = '4' THEN      #工作量法                              
            LET l_fgj05 = 0                                                    
            SELECT fgj05 INTO l_fgj05 FROM fgj_file                            
#            WHERE fgj01 = tm.yy AND fgj02 = tm.mm  #No.TQC-7B0060 mark
             WHERE fgj01 = m_yy AND fgj02 = m_mm    #No.TQC-7B0060
               AND fgj03 = g_faj.faj02 AND fgj04 = g_faj.faj022                
               AND fgjconf = 'Y'                                               
            IF cl_null(l_fgj05) THEN LET l_fgj05 = 0 END IF                    
            LET l_rate_y = (g_faj.faj62+g_faj.faj63-g_faj.faj66)/g_faj.faj110 
            LET m_amt = l_rate_y * l_fgj05                                     
         END IF                                                                
         LET l_amt_y = cl_digcut(l_amt_y,g_azi04)                          
         IF l_amt_y = 0 THEN LET l_amt_y = g_faj.faj109 END IF                 
         IF g_faj.faj61 NOT MATCHES '[23]' THEN                                
            LET l_amt_y = 0                                                    
         END IF                                                                
      ELSE                                                                     
         LET l_amt_y = 0                                                       
      END IF                                                                   
      #新增一筆折舊費用資料 ----------------------------------------
      IF g_faj.faj23 = '1' THEN
         LET m_faj24 = g_faj.faj24   # 單一部門 -> 折舊部門
      ELSE
         LET m_faj24 = g_faj.faj20   # 多部門分攤 -> 保管部門
      END IF
 
      LET m_cost=g_faj.faj62+g_faj.faj63-g_faj.faj69  #成本
 
      IF g_faa.faa15 = '4' THEN
         IF g_ym = g_faj.faj27 THEN    #第一期攤提
            LET l_first = l_last - DAY(g_faj.faj26) + 1
            LET l_rate = l_first / l_last   #攤提比率
            IF cl_null(l_rate) THEN
               LET l_rate = 1 
            END IF 
            LET m_amt = m_amt * l_rate
         END IF  
      END IF
      IF cl_null(m_amt) THEN LET m_amt = 0 END IF
      LET m_amt = cl_digcut(m_amt,g_azi04)
      LET m_accd=g_faj.faj67-g_faj.faj70+m_amt         #累折
      #--->本期累折改由(faj_file)讀取
      #--->本期累折 - 本期銷帳累折
      IF g_faj.faj205 = 0 THEN
         LET m_curr   = m_amt 
         LET m_faj205 = m_amt
      ELSE
         LET m_curr=(g_faj.faj205 - g_faj.faj204) + m_amt  
         LET m_faj205 = g_faj.faj205 + m_amt
      END IF
      IF m_amt < 0 THEN    
         CALL cl_getmsg("afa-178",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = 'afa-178'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         CONTINUE FOREACH
      END IF
      IF cl_null(m_faj24) THEN LET m_faj24=' ' END IF   
      INSERT INTO fao_file(fao01,fao02,fao03,fao04,fao041,fao05,fao06,         
                            fao07,fao08,fao09,fao10,fao11,fao12,fao20,fao13,        #TQC-B20074 add fao20  
                            fao14,fao15,fao16,fao17,fao111,fao121,fao201,           #TQC-B20074 add fao201
                            faolegal)  #FUN-980003 add
#                    VALUES(g_faj.faj02,g_faj.faj022,tm.yy,tm.mm,'1', #No.TQC-7B0060
                     VALUES(g_faj.faj02,g_faj.faj022,m_yy,m_mm,'1',   #No.TQC-7B0060
                            g_faj.faj23,m_faj24,m_amt,m_curr,' ',g_faj.faj201,         
                            g_faj.faj53,g_faj.faj55,g_faj.faj54,g_faj.faj24,        #TQC-B20074 add faj54        
                            m_cost,m_accd,1,g_faj.faj103-g_faj.faj104,
                            g_faj.faj531,g_faj.faj551,g_faj.faj541,                 #TQC-B20074 add faj541
                            g_legal)  #FUN-980003 add       
      IF SQLCA.sqlcode THEN
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'ins fao_file'
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      #update 回資產主檔
      # 剩餘月數減 1
      LET m_faj65 = g_faj.faj65 -1
      LET m_faj72 = g_faj.faj72
      IF m_faj65 < 0 THEN LET m_faj65 = 0 END IF
      #----->資產狀態碼 
      IF g_type = '2' THEN   
         IF m_faj65 > 0 THEN   
           #LET m_status = '2'    #MOD-C60169 mark
            LET m_status = '7'    #MOD-C60169 add
         ELSE 
            #LET m_status = '7'   #MOD-820067
            LET m_status = '4'   #MOD-820067
         END IF   
      ELSE
         IF m_faj65=0 THEN 
            #折畢再提:折完時,殘值為0 時 即為折畢
            IF g_faj.faj71 MATCHES '[Nn]' THEN
               LET m_status = '4'
            ELSE
               LET m_status='7'  # 第一次折畢, 即直接當做欲折畢再提 
               LET m_faj65 = g_faj.faj73   
            END IF 
         ELSE
           #MOD-C60016---S---
            IF g_faj.faj201='7' THEN
               LET m_status = '7'
            ELSE
               LET m_status='2'
            END IF
           #MOD-C60016---E--- 
         END IF
      END IF
      #UPDATE  累折, 未折減額, 剩餘月數, 資產狀態
      IF l_over = 'N' THEN 
         LET l_faj68=(g_faj.faj62+g_faj.faj63)-g_faj.faj69 
                    -(g_faj.faj67+m_amt-g_faj.faj70)
#No.TQC-7B0060 --start--
#        UPDATE faj_file SET faj74 =tm.yy,                 #最近折舊年
#                            faj741=tm.mm,                 #最近折舊月
         UPDATE faj_file SET faj74 =m_yy,                  #最近折舊年
                             faj741=m_mm,                  #最近折舊月
#No.TQC-7B0060 --end--
                             faj67 =faj67+m_amt,           #累折   
                             faj68 =l_faj68,               #未折減額
                             faj65 =m_faj65,               #未用年限
                             faj72 =m_faj72,               #折畢再提預留殘值
                             faj201 =m_status,              #狀態
                             faj205=m_faj205,              #本期累折   
                             faj109=l_amt_y                #年折舊額 
          WHERE faj02=g_faj.faj02 AND faj022=g_faj.faj022
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = ''
            LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
   IF g_faj.faj23 = '2' THEN
      #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
#No.TQC-7B0060 --start--
#     LET g_sql="SELECT * FROM fao_file WHERE fao03='",tm.yy,"'",
#             "                         AND fao04='",tm.mm,"'",

      LET g_sql="SELECT * FROM fao_file WHERE fao03='",m_yy,"'",
              "                         AND fao04='",m_mm,"'",
#No.TQC-7B0060 --end--
              "                         AND fao05='2' AND fao041 = '1' ",
              "                         AND fao01='",g_faj.faj02,"'", 
              "                         AND fao02='",g_faj.faj022,"'"   #MOD-C50067 add
 
      PREPARE p400_pre1 FROM g_sql
      DECLARE p400_cur1 CURSOR WITH HOLD FOR p400_pre1
      FOREACH p400_cur1 INTO g_fao.*
         IF STATUS THEN
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = ''
            LET g_show_msg[g_cnt2].ze03   = 'foreach p400_cur1'
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'  
            CONTINUE FOREACH
         END IF
         #-->讀取分攤方式
         SELECT fad05,fad031 INTO m_fad05,m_fad031 FROM fad_file
          WHERE fad01=g_fao.fao03 AND fad02=g_fao.fao04
            AND fad03=g_fao.fao11
            AND fad04=g_fao.fao13
            AND fad07='1'     #No:FUN-AB0088
         IF SQLCA.sqlcode THEN 
            CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
            LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
            LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
            LET g_show_msg[g_cnt2].ze01   = 'afa-152'
            LET g_show_msg[g_cnt2].ze03   = l_msg
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         #-->讀取分母
         IF m_fad05='1' THEN
            SELECT SUM(fae08) INTO m_fae08 FROM fae_file
              WHERE fae01=g_fao.fao03 AND fae02=g_fao.fao04
                AND fae03=g_fao.fao11 AND fae04=g_fao.fao13
                AND fae10 = '1'      #No:FUN-AB0088
            IF SQLCA.sqlcode OR cl_null(m_fae08) THEN 
               CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-152'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'
               CONTINUE FOREACH 
            END IF
            LET mm_fae08 = m_fae08            # 分攤比率合計
         END IF
      
         #-->保留金額以便處理尾差
         LET mm_fao07=g_fao.fao07          # 被分攤金額
         LET mm_fao08=g_fao.fao08          # 本期累折金額
         LET mm_fao14=g_fao.fao14          # 被分攤成本
         LET mm_fao15=g_fao.fao15          # 被分攤累折
         LET mm_fao17=g_fao.fao17          # 被分攤減值 
      
         #------- 找 fae_file 分攤單身檔 ---------------
         LET m_tot=0  
         DECLARE p400_cur2 CURSOR WITH HOLD FOR
         SELECT * FROM fae_file
          WHERE fae01=g_fao.fao03 AND fae02=g_fao.fao04
            AND fae03=g_fao.fao11 AND fae04=g_fao.fao13 
            AND fae10 = '1'      #No:FUN-AB0088
         FOREACH p400_cur2 INTO g_fae.*
            IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
               CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = 'afa-152'
               LET g_show_msg[g_cnt2].ze03   = l_msg
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'
               CONTINUE FOREACH 
            END IF
            CASE m_fad05
               WHEN '1' 
                 #SELECT rowid INTO g_fao_rowid FROM fao_file                  #09/10/19 xiaofeizhu Mark
                #MOD-C50067---mod---S---
                 #SELECT fao01,fao02,fao03,fao04,fao041,fao05,fao06            #09/10/19 xiaofeizhu Add
                 #  INTO g_fao.fao01,g_fao.fao02,g_fao.fao03,g_fao.fao04,      #09/10/19 xiaofeizhu Add
                 #       g_fao.fao041,g_fao.fao05,g_fao.fao06                  #09/10/19 xiaofeizhu Add 
                  LET l_cnt1 = 0
                  SELECT COUNT(*) INTO l_cnt1
                    FROM fao_file                                              #09/10/19 xiaofeizhu Add  
                   WHERE fao01 = g_fao.fao01 AND fao02 = g_fao.fao02
                     AND fao03 = g_fao.fao03 AND fao04 = g_fao.fao04
                     AND fao06 = g_fae.fae06 AND fao05 = '3'
                     AND (fao041 = '1' OR fao041 = '0')    
                 #IF STATUS=100 THEN
                 #   LET g_fao_rowid=NULL                                      #09/10/19 xiaofeizhu Mark
                 #END IF
                #MOD-C50067---mod---E---
                  LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fao16用)
                  LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
                  LET m_fao07=mm_fao07*m_ratio/100          # 分攤金額
                  LET m_curr =mm_fao08*m_ratio/100          # 分攤金額
                  LET m_fao14=mm_fao14*m_ratio/100          # 分攤成本
                  LET m_fao15=mm_fao15*m_ratio/100          # 分攤累折
                  LET m_fao17=mm_fao17*m_ratio/100          # 分攤減值 
                  LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                  LET m_fao07 = cl_digcut(m_fao07,g_azi04)
                  LET mm_fao07 = mm_fao07 - m_fao07         # 被分攤總數減少
                  LET m_curr   = cl_digcut(m_curr,g_azi04)
                  LET mm_fao08 = mm_fao08 - m_curr          # 被分攤總數減少
                  LET m_fao14 = cl_digcut(m_fao14,g_azi04)
                  LET mm_fao14 = mm_fao14 - m_fao14         # 被分攤總數減少
                  LET m_fao15  = cl_digcut(m_fao15,g_azi04)
                  LET mm_fao15 = mm_fao15 - m_fao15         # 被分攤總數減少
                  LET m_fao17  = cl_digcut(m_fao17,g_azi04)  
                  LET mm_fao17 = mm_fao17 - m_fao17         # 被分攤總數減少
#                 IF g_fao_rowid IS NOT NULL THEN           #09/10/19 xiaofeizhu Mark 
                  #09/10/19 xiaofeizhu Add Begin
                 #-----------------MOD-C50148-----------------mark
                 #SELECT COUNT(*)                                        
                 #  INTO l_count                                          
                 #  FROM fao_file                                                                           
                 # WHERE fao01=g_fao.fao01 AND fao02=g_fao.fao02                                                                    
                 #   AND fao03=g_fao.fao03 AND fao04=g_fao.fao04
                 #   AND fao041=g_fao.fao041                                                                     
                 #   AND fao05=g_fao.fao05 AND fao06=g_fae.fae06 
                 #IF STATUS=100 THEN                                                                                                
                 #   LET l_count = 0                                                                                           
                 #END IF
                 #IF l_count > 0 THEN
                  IF l_cnt1 > 0 THEN                          #MOD-C50148 add
                 #-----------------MOD-C50148-----------------mark
                  #09/10/19 xiaofeizhu Add End 
                     UPDATE fao_file SET fao07 = m_fao07,
                                         fao08 = m_curr,
                                         fao09 = g_fao.fao06,
                                         fao12 = g_fae.fae07,
                                         fao14 = m_fao14,
                                         fao15 = m_fao15,
                                         fao16 = mm_ratio,
                                         fao17 = m_fao17,
                                         fao111 = m_fad031,
                                         fao121 = g_fae.fae071
                    #WHERE rowid=g_fao_rowid                            #09/10/19 xiaofeizhu Mark
                    #09/10/19 xiaofeizhu Add Begin
                     WHERE fao01 = g_fao.fao01 AND fao02 = g_fao.fao02                                                                    
                       AND fao03 = g_fao.fao03 AND fao04 = g_fao.fao04
                      #AND fao041 = g_fao.fao041                         #MOD-C50067 mark                                              
                       AND (fao041 = '1' OR fao041 = '0')                #MOD-C50067
                      #AND fao05 = g_fao.fao05                           #MOD-C50067 mark
                       AND fao05 = '3'                                   #MOD-C50067
                       AND fao06 = g_fae.fae06
                    #09/10/19 xiaofeizhu Add End 
                     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'upd fao_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  ELSE
                     IF cl_null(g_fae.fae06) THEN
                        LET g_fae.fae06=' '
                     END IF
                     INSERT INTO fao_file(fao01,fao02,fao03,fao04,fao041,   
                                          fao05,fao06,fao07,fao08,fao09,    
                                          fao10,fao11,fao12,fao13,fao14,    
                                          fao15,fao16,fao17,fao111,fao121,
                                          fao20,fao201,                            #TQC-B20074
                                          faolegal) #FUN-980003 add
                                   VALUES(g_fao.fao01,g_fao.fao02,          
                                          g_fao.fao03,g_fao.fao04,'1','3',  
                                          g_fae.fae06,m_fao07,m_curr,       
                                          g_fao.fao06,g_faj.faj201,g_fao.fao11,   
                                          g_fae.fae07,g_fao.fao13,m_fao14,  
                                          m_fao15,mm_ratio,m_fao17,m_fad031,
                                          g_fae.fae071,g_fao.fao20,g_fao.fao201,   #TQC-B20074 add fao20,fao201          
                                          g_legal)  #FUN-980003 add       
                     IF STATUS THEN
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'ins fao_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  END IF
# dennon lai 01/04/18 本期累折=今年度本期折舊(fao07)的加總
#                     累積折舊=全期本期折舊(fao07)的加總
             #No.3426 010824 modify 若用上述方法在年中導入時折舊會少
                #例7月導入,fao 6月資料,本月折舊fao07=6月折舊金額, 故用
                #select sum(fao07)的方法會少1-5 月的折舊金額
                #故改成抓前一期累折+本月的折舊
                     IF g_fao.fao04=1 THEN
                        LET p_yy = g_fao.fao03-1
                        LET p_mm=12
                     ELSE
                        LET p_yy = g_fao.fao03
                        LET p_mm=g_fao.fao04-1
                     END IF
                      LET p_fao08=0  LET p_fao15=0
                      SELECT SUM(fao08),SUM(fao15) INTO p_fao08,p_fao15
                        FROM  fao_file
                       WHERE fao01=g_fao.fao01
                         AND fao02=g_fao.fao02
                         AND fao03=p_yy
                         AND fao04=p_mm
                         AND fao06=g_fae.fae06 AND fao05='3'
                         AND (fao041 = '1' OR fao041='0')    
                     IF SQLCA.SQLCODE THEN
                        LET p_fao08=0   LET p_fao15=0
                     END IF
                     IF cl_null(p_fao08) THEN
                        LET p_fao08=0
                     END IF
                     IF cl_null(p_fao15) THEN 
                        LET p_fao15=0
                     END IF
                     IF g_fao.fao04 = 1 THEN
                        LET p_fao08 = 0
                     END IF
                     LET g_fao07_year = p_fao08 +m_fao07
                     LET g_fao07_all  = p_fao15 +m_fao07
                     UPDATE fao_file SET fao08=g_fao07_year,fao15=g_fao07_all
                      WHERE fao01=g_fao.fao01
                        AND fao02=g_fao.fao02
                        AND fao03=g_fao.fao03 AND fao04=g_fao.fao04
                        AND fao06=g_fae.fae06 AND fao05='3'
                        AND fao041 = '1'
                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'upd fao_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  WHEN '2'
                    #str MOD-970218 add
                     LET l_aag04 = ''
                     SELECT aag04 INTO l_aag04 FROM aag_file
                      WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                     IF l_aag04='1' THEN
                        SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                         WHERE aao00 =m_faa02b AND aao01=g_fae.fae09
                           AND aao02 =g_fae.fae06 AND aao03=m_yy
                           AND aao04<=m_mm
                     ELSE
                    #end MOD-970218 add
                        SELECT aao05-aao06 INTO m_aao FROM aao_file
                         WHERE aao00=m_faa02b AND aao01=g_fae.fae09
#No.TQC-7B0060 --start--
#                          AND aao02=g_fae.fae06 AND aao03=tm.yy
#                          AND aao04=tm.mm
                           AND aao02=g_fae.fae06 AND aao03=m_yy
                           AND aao04=m_mm
#No.TQC-7B0060 --end--
                     END IF   #MOD-970218 add
                     IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                     LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
               END CASE
            END FOREACH
 
       #----- 若為變動比率, 重新 foreach 一次 insert into fao_file -----------
            IF m_fad05='2' THEN
               FOREACH p400_cur2 INTO g_fae.*
                 #str MOD-970218 add
                  LET l_aag04 = ''
                  SELECT aag04 INTO l_aag04 FROM aag_file
                   WHERE aag01=g_fae.fae09 AND aag00=g_bookno1
                  IF l_aag04='1' THEN
                     SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                      WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                        AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04<=m_mm
                  ELSE
                 #end MOD-970218 add
                     SELECT aao05-aao06 INTO m_aao FROM aao_file
                      WHERE aao00=m_faa02b AND aao01=g_fae.fae09
#                       AND aao02=g_fae.fae06 AND aao03=tm.yy AND aao04=tm.mm #No.TQC-7B0060 mark
                        AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04=m_mm   #No.TQC-7B0060
                  END IF   #MOD-970218 add
                  IF STATUS=100 OR m_aao IS NULL THEN
                     LET m_aao=0 
                  END IF
                  LET m_ratio = m_aao/m_tot*100
                  LET m_fao07=g_fao.fao07*m_ratio/100
                  LET m_curr =g_fao.fao08*m_ratio/100
                  LET m_fao14=g_fao.fao14*m_ratio/100
                  LET m_fao15=g_fao.fao15*m_ratio/100
                  LET m_fao17=g_fao.fao17*m_ratio/100   
                  LET m_fao07 = cl_digcut(m_fao07,g_azi04)
                  LET m_curr = cl_digcut(m_curr,g_azi04)
                  LET m_fao14 = cl_digcut(m_fao14,g_azi04)
                  LET m_fao15 = cl_digcut(m_fao15,g_azi04)
                  LET m_fao17 = cl_digcut(m_fao17,g_azi04)
                  LET m_tot_fao07=m_tot_fao07+m_fao07
                  LET m_tot_curr =m_tot_curr +m_curr  
                  LET m_tot_fao14=m_tot_fao14+m_fao14
                  LET m_tot_fao15=m_tot_fao15+m_fao15
                  LET m_tot_fao17=m_tot_fao17+m_fao17  
                  SELECT COUNT(*) INTO g_cnt FROM fao_file
                   WHERE fao01=g_fao.fao01 AND fao02=g_fao.fao02
                     AND fao03=g_fao.fao03 AND fao04=g_fao.fao04
                     AND fao06=g_fae.fae06 AND fao05='3' AND fao041 = '1'
                  IF g_cnt>0 THEN
                     UPDATE fao_file SET fao07 = m_fao07,
                                         fao08 = m_curr,
                                         fao09 = g_fao.fao06,
                                         fao12 = g_fae.fae07,
                                         fao16 = m_ratio,
                                         fao17 = m_fao17,
                                         fao111=m_fad031,
                                         fao121=g_fae.fae071
                      WHERE fao01=g_fao.fao01 AND fao02=g_fao.fao02
                        AND fao03=g_fao.fao03 AND fao04=g_fao.fao04
                        AND fao06=g_fae.fae06 AND fao05='3' AND fao041 = '1'
                     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN  
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'upd fao_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  ELSE
                     IF cl_null(g_fae.fae06) THEN
                        LET g_fae.fae06=' '
                     END IF
                     INSERT INTO fao_file(fao01,fao02,fao03,fao04,fao041,fao05,      
                                          fao06,fao07,fao08,fao09,fao10,fao11,       
                                          fao12,fao13,fao14,fao15,fao16,fao17,
                                          fao111,fao121,fao20,fao201,            #TQC-B20074       
                                          faolegal)  #FUN-980003 add       
                                VALUES(g_fao.fao01,g_fao.fao02,g_fao.fao03,       
                                       g_fao.fao04,'1','3',g_fae.fae06,m_fao07,   
                                       m_curr,g_fao.fao06,g_faj.faj201,g_fao.fao11,       
                                       g_fae.fae07,g_fao.fao13,m_fao14,m_fao15,   
                                       m_ratio,m_fao17,m_fad031,g_fae.fae071,                         
                                       fao20,fao201,                             #TQC-B20074
                                       g_legal)  #FUN-980003 add       
                     IF STATUS THEN
                        LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                        LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                        LET g_show_msg[g_cnt2].ze01   = ''
                        LET g_show_msg[g_cnt2].ze03   = 'ins fao_file'
                        LET g_cnt2 = g_cnt2 + 1
                        LET g_success='N'
                        CONTINUE FOREACH 
                     END IF
                  END IF
               END FOREACH
            END IF
      END FOREACH
   END IF
   IF g_success = 'Y' THEN 
      LET l_flag ='Y'                                  #MOD-C10160 add
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   END FOREACH   
  #-----------------------------------MOD-C10160-------------------------start
   IF l_flag ='N' THEN
      CALL cl_getmsg("aic-024",g_lang) RETURNING l_msg
      LET g_show_msg[g_cnt2].faj02  = ' '
      LET g_show_msg[g_cnt2].faj022 = ' '
      LET g_show_msg[g_cnt2].ze01   = 'aic-024'
      LET g_show_msg[g_cnt2].ze03   = l_msg
   END IF
  #-----------------------------------MOD-C10160----------------------------end 
END FUNCTION
#CHI-860025
#---------------------------MOD-C20218--------------------------start
FUNCTION p400_chk_no(p_no)
   DEFINE p_no    LIKE faq_file.faq01
   DEFINE i       INTEGER

   LET g_have = 'N'
   LET i = g_show_msg2.getLength()
   IF cl_null(i) THEN LET i = 0 END IF
   IF i > 0 THEN
      FOR i = 1 TO g_show_msg2.getLength()
         IF g_show_msg2[i].f_no = p_no THEN
            LET g_have = 'Y'  #已存在
            EXIT FOR
         END IF
      END FOR
   END IF
END FUNCTION

FUNCTION p400_chk(p_faj09,p_faj04,p_faj02)
   DEFINE p_faj09  LIKE faj_file.faj09
   DEFINE p_faj04  LIKE faj_file.faj04
   DEFINE p_faj02  LIKE faj_file.faj02
   DEFINE l_err    LIKE ze_file.ze01
   DEFINE l_err1   LIKE ze_file.ze03
   DEFINE l_err2   LIKE ze_file.ze03
   DEFINE l_memo   LIKE ze_file.ze03
   DEFINE l_msg    LIKE ze_file.ze03
   DEFINE l_no     LIKE faq_file.faq01
   DEFINE l_post   LIKE faq_file.faqpost
   DEFINE l_conf   LIKE faq_file.faqconf

   CALL cl_getmsg('aco-174',g_lang) RETURNING l_err1 #未確認
   CALL cl_getmsg('aba-108',g_lang) RETURNING l_err2 #未過帳

   DECLARE faq_cr CURSOR FOR
    SELECT DISTINCT faq01,faqpost,faqconf
      FROM faq_file,far_file
     WHERE faqpost != 'Y'
       AND faqconf != 'X'
       AND faq01 = far01
       AND far03 = p_faj02
       AND YEAR(faq02) = tm.yy
       AND MONTH(faq02) = tm.mm
     GROUP BY faq01,faqpost,faqconf

   FOREACH faq_cr INTO l_no,l_post,l_conf
      IF STATUS THEN
         CALL cl_err('chk faq',STATUS,1)
         EXIT FOREACH
      END IF
      CALL p400_chk_no(l_no)
      IF g_have = 'Y' THEN
         CONTINUE FOREACH
      END IF
      LET l_err = ""
      IF l_conf = 'N' THEN  #未確認
         LET l_msg = l_err1 CLIPPED
      ELSE                  #未過帳
         LET l_msg = l_err2 CLIPPED
      END IF

      LET l_memo = ""
      SELECT gat03 INTO l_memo
        FROM gat_file
       WHERE gat01 = 'faq_file'
         AND gat02 = g_lang

      LET g_show_msg2[g_cnt3].memo  = l_memo CLIPPED
      LET g_show_msg2[g_cnt3].f_no  = l_no
      LET g_show_msg2[g_cnt3].ze03  = l_msg
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH

   DECLARE fas_cr CURSOR FOR
    SELECT DISTINCT fas01,faspost,fasconf
      FROM fas_file,fat_file
     WHERE faspost != 'Y'
       AND fasconf != 'X'
       AND fat03 = p_faj02
       AND fas01 = fat01
       AND YEAR(fas02) = tm.yy
       AND MONTH(fas02) = tm.mm
   FOREACH fas_cr INTO l_no,l_post, l_conf
      IF STATUS THEN
         CALL cl_err('chk fas',STATUS,1)
         EXIT FOREACH
      END IF
      CALL p400_chk_no(l_no)
      IF g_have = 'Y' THEN
         CONTINUE FOREACH
      END IF
      LET l_err = ""
      IF l_conf = 'N' THEN  #未確認
         LET l_msg = l_err1 CLIPPED
      ELSE                  #未過帳
         LET l_msg = l_err2 CLIPPED
      END IF

      LET l_memo = ""
      SELECT gat03 INTO l_memo
        FROM gat_file
       WHERE gat01 = 'fas_file'
         AND gat02 = g_lang

      LET g_show_msg2[g_cnt3].memo  = l_memo CLIPPED
      LET g_show_msg2[g_cnt3].f_no  = l_no
      LET g_show_msg2[g_cnt3].ze03  = l_msg
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH

   DECLARE fay_cr CURSOR FOR
    SELECT DISTINCT fay01,faypost,fayconf
      FROM fay_file,faz_file
     WHERE faypost != 'Y'
       AND fayconf != 'X'
       AND fay01 = faz01
       AND faz03 = p_faj02
       AND YEAR(fay02) = tm.yy
       AND MONTH(fay02) = tm.mm
   FOREACH fay_cr INTO l_no,l_post, l_conf
      IF STATUS THEN
         CALL cl_err('chk fay',STATUS,1)
         EXIT FOREACH
      END IF
      CALL p400_chk_no(l_no)
      IF g_have = 'Y' THEN
         CONTINUE FOREACH
      END IF
      LET l_err = ""
      IF l_conf = 'N' THEN  #未確認
         LET l_msg = l_err1 CLIPPED
      ELSE                  #未過帳
         LET l_msg = l_err2 CLIPPED
      END IF

      LET l_memo = ""
      SELECT gat03 INTO l_memo
        FROM gat_file
       WHERE gat01 = 'fay_file'
         AND gat02 = g_lang

      LET g_show_msg2[g_cnt3].memo  = l_memo CLIPPED
      LET g_show_msg2[g_cnt3].f_no  = l_no
      LET g_show_msg2[g_cnt3].ze03  = l_msg
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH

   DECLARE fba_cr CURSOR FOR
    SELECT DISTINCT fba01,fbapost,fbaconf
      FROM fba_file,fbb_file
     WHERE fbapost != 'Y'
       AND fbaconf != 'X'
       AND fba01 = fbb01
       AND fbb03 = p_faj02
       AND YEAR(fba02) = tm.yy
       AND MONTH(fba02) = tm.mm
   FOREACH fba_cr INTO l_no,l_post, l_conf
      IF STATUS THEN
         CALL cl_err('chk fba',STATUS,1)
         EXIT FOREACH
      END IF
      CALL p400_chk_no(l_no)
      IF g_have = 'Y' THEN
         CONTINUE FOREACH
      END IF
      LET l_err = ""
      IF l_conf = 'N' THEN  #未確認
         LET l_msg = l_err1 CLIPPED
      ELSE                  #未過帳
         LET l_msg = l_err2 CLIPPED
      END IF

      LET l_memo = ""
      SELECT gat03 INTO l_memo
        FROM gat_file
       WHERE gat01 = 'fba_file'
         AND gat02 = g_lang

      LET g_show_msg2[g_cnt3].memo  = l_memo CLIPPED
      LET g_show_msg2[g_cnt3].f_no  = l_no
      LET g_show_msg2[g_cnt3].ze03  = l_msg
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH

   DECLARE fbc_cr CURSOR FOR
    SELECT DISTINCT fbc01,fbcpost,fbcconf
      FROM fbc_file,fbd_file
     WHERE fbcpost != 'Y'
       AND fbcconf != 'X'
       AND fbc01 = fbd01
       AND fbd03 = p_faj02
       AND YEAR(fbc02) = tm.yy
       AND MONTH(fbc02) = tm.mm
   FOREACH fbc_cr INTO l_no,l_post, l_conf
      IF STATUS THEN
         CALL cl_err('chk fbc',STATUS,1)
         EXIT FOREACH
      END IF
      CALL p400_chk_no(l_no)
      IF g_have = 'Y' THEN
         CONTINUE FOREACH
      END IF
      LET l_err = ""
      IF l_conf = 'N' THEN  #未確認
         LET l_msg = l_err1 CLIPPED
      ELSE                  #未過帳
         LET l_msg = l_err2 CLIPPED
      END IF

      LET l_memo = ""
      SELECT gat03 INTO l_memo
        FROM gat_file
       WHERE gat01 = 'fbc_file'
         AND gat02 = g_lang

      LET g_show_msg2[g_cnt3].memo  = l_memo CLIPPED
      LET g_show_msg2[g_cnt3].f_no  = l_no
      LET g_show_msg2[g_cnt3].ze03  = l_msg
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH

   DECLARE fbe_cr CURSOR FOR
    SELECT DISTINCT fbe01,fbepost,fbeconf
      FROM fbe_file,fbf_file
     WHERE fbepost != 'Y'
       AND fbeconf != 'X'
       AND fbe01 = fbf01
       AND fbf03 = p_faj02
       AND YEAR(fbe02) = tm.yy
       AND MONTH(fbe02) = tm.mm
   FOREACH fbe_cr INTO l_no,l_post, l_conf
      IF STATUS THEN
         CALL cl_err('chk fbe',STATUS,1)
         EXIT FOREACH
      END IF
      CALL p400_chk_no(l_no)
      IF g_have = 'Y' THEN
         CONTINUE FOREACH
      END IF
      LET l_err = ""
      IF l_conf = 'N' THEN  #未確認
         LET l_msg = l_err1 CLIPPED
      ELSE                  #未過帳
         LET l_msg = l_err2 CLIPPED
      END IF

      LET l_memo = ""
      SELECT gat03 INTO l_memo
        FROM gat_file
       WHERE gat01 = 'fbe_file'
         AND gat02 = g_lang

      LET g_show_msg2[g_cnt3].memo  = l_memo CLIPPED
      LET g_show_msg2[g_cnt3].f_no  = l_no
      LET g_show_msg2[g_cnt3].ze03  = l_msg
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH

   DECLARE fbg_cr CURSOR FOR
    SELECT DISTINCT fbg01,fbgpost,fbgconf
      FROM fbg_file,fbh_file
     WHERE fbgpost != 'Y'
       AND fbgconf != 'X'
       AND fbg01 = fbh01
       AND fbh03 = p_faj02
       AND YEAR(fbg02) = tm.yy
       AND MONTH(fbg02) = tm.mm
   FOREACH fbg_cr INTO l_no,l_post, l_conf
      IF STATUS THEN
         CALL cl_err('chk fbg',STATUS,1)
         EXIT FOREACH
      END IF
      CALL p400_chk_no(l_no)
      IF g_have = 'Y' THEN
         CONTINUE FOREACH
      END IF
      LET l_err = ""
      IF l_conf = 'N' THEN  #未確認
         LET l_msg = l_err1 CLIPPED
      ELSE                  #未過帳
         LET l_msg = l_err2 CLIPPED
      END IF

      LET l_memo = ""
      SELECT gat03 INTO l_memo
        FROM gat_file
       WHERE gat01 = 'fbg_file'
         AND gat02 = g_lang

      LET g_show_msg2[g_cnt3].memo  = l_memo CLIPPED
      LET g_show_msg2[g_cnt3].f_no  = l_no
      LET g_show_msg2[g_cnt3].ze03  = l_msg
      LET g_cnt3 = g_cnt3 + 1
   END FOREACH

END FUNCTION
#---------------------------MOD-C20218----------------------------end
