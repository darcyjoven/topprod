# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afap200.4gl
# Descriptions...: 財簽二自動攤提折舊作業
# Date & Author..: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark
# Modify.........: No:MOD-BB0145 11/11/12 By johung 修正多部門分攤無法折舊問題
# Modify.........: No.MOD-BC0131 12/01/13 By Sakura 新增fbn20處理
# Modify.........: No:MOD-C50132 12/05/21 By Polly 取財簽二幣別取位
# Modify.........: No.CHI-C60010 12/06/15 By wangrr 財簽二欄位需依財簽二幣別做取位 
# Modify.........: No:MOD-C70003 12/07/02 By Polly 採用平均無殘值，折舊計算需考慮已提列減值準備
# Modify.........: No:MOD-C70022 12/07/03 By Polly 折舊完需更新未折減額(faj332)時，未折減額需扣除已提列減值的金額
# Modify.........: No:MOD-C70270 12/07/27 By Polly 有殘值的折畢提列需包含(g_faj.faj1012-g_faj.faj1022)
# Modify.........: No:MOD-C80114 12/08/20 By Polly 調整資產折畢的條件
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql  STRING,  
       m_yy             LIKE faa_file.faa07,
       m_mm             LIKE faa_file.faa08,
       g_yy             LIKE type_file.chr4,
       g_mm             LIKE type_file.chr2,
       g_ym             LIKE type_file.chr6,
       tm               RECORD
                        yy   LIKE type_file.num5,
                        mm   LIKE type_file.num5
                        END RECORD,
       m_tot            LIKE type_file.num20_6,   
       m_tot_fan07      LIKE fan_file.fan07, 
       m_tot_fan14      LIKE fan_file.fan14, 
       m_tot_fan15      LIKE fan_file.fan15, 
       m_tot_fan17      LIKE fan_file.fan17,
       m_tot_curr       LIKE type_file.num20_6,
       l_first2,l_last2 LIKE type_file.dat,    
       l_first,l_last   LIKE type_file.num5,
       g_cnt,g_cnt2     LIKE type_file.num5,
       g_type           LIKE type_file.chr1,
       g_faj       RECORD LIKE faj_file.*,
       g_fan       RECORD LIKE fan_file.*,
       g_fae       RECORD LIKE fae_file.*,
       m_aao            LIKE type_file.num20_6,
       m_amt,m_amt2,m_cost,m_accd,m_curr LIKE type_file.num20_6,  
       m_amt_o                           LIKE type_file.num20_6, 
       m_fan07     LIKE fan_file.fan07, 
       m_fan08     LIKE fan_file.fan08, 
       m_fan14     LIKE fan_file.fan14, 
       m_fan15     LIKE fan_file.fan15, 
       m_fan17     LIKE fan_file.fan17,
       mm_fan07    LIKE fan_file.fan07,
       mm_fan08    LIKE fan_file.fan08,
       mm_fan14    LIKE fan_file.fan14,
       mm_fan15    LIKE fan_file.fan15,
       mm_fan17    LIKE fan_file.fan17,
       m_ratio,mm_ratio  LIKE type_file.num26_10,   
       m_max_ratio  LIKE type_file.num26_10,  
       m_faa02c    LIKE aaa_file.aaa01,    
       m_status    LIKE type_file.chr1,
       l_diff,l_diff2  LIKE fan_file.fan07,
       m_faj24     LIKE faj_file.faj24,
       m_faj30     LIKE faj_file.faj30,
       m_faj32     LIKE faj_file.faj32,
       m_faj203    LIKE faj_file.faj203,
       m_faj57     LIKE faj_file.faj57,
       m_faj571    LIKE faj_file.faj571,
       m_fad05     LIKE fad_file.fad05,
       m_fad031    LIKE fad_file.fad031,
       m_fae08,mm_fae08   LIKE fae_file.fae08,
       p_row,p_col LIKE type_file.num5,
       #g_fan_rowid LIKE type_file.num10, # saki 20070821 rowid chr18 -> num10   #FUN-B60140 mark 
       g_fan07_year, g_fan07_all LIKE fan_file.fan07,  
       g_msg       LIKE type_file.chr1000,
       l_flag      LIKE type_file.chr1            
DEFINE l_bdate     LIKE type_file.dat  
DEFINE l_edate     LIKE type_file.dat 
DEFINE y_curr      LIKE fan_file.fan08
DEFINE m_fae06     LIKE fae_file.fae06
DEFINE l_fan07     LIKE fan_file.fan07
DEFINE l_fan08     LIKE fan_file.fan08
DEFINE m_max_fae06     LIKE fae_file.fae06    

DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  
                  faj02     LIKE faj_file.faj02,
                  faj022    LIKE faj_file.faj022,
                  ze01      LIKE ze_file.ze01,
                  ze03      LIKE ze_file.ze03
        END RECORD,
        l_msg,l_msg2    STRING,
        lc_gaq03  LIKE gaq_file.gaq03

DEFINE m_tot_fbn07      LIKE fbn_file.fbn07, 
       m_tot_fbn14      LIKE fbn_file.fbn14, 
       m_tot_fbn15      LIKE fbn_file.fbn15, 
       m_tot_fbn17      LIKE fbn_file.fbn17,
       g_fbn            RECORD LIKE fbn_file.*,
       m_fbn07          LIKE fbn_file.fbn07, 
       m_fbn08          LIKE fbn_file.fbn08, 
       m_fbn14          LIKE fbn_file.fbn14, 
       m_fbn15          LIKE fbn_file.fbn15, 
       m_fbn17          LIKE fbn_file.fbn17,
       mm_fbn07         LIKE fbn_file.fbn07,
       mm_fbn08         LIKE fbn_file.fbn08,
       mm_fbn14         LIKE fbn_file.fbn14,
       mm_fbn15         LIKE fbn_file.fbn15,
       mm_fbn17         LIKE fbn_file.fbn17,
       #g_fbn_rowid      LIKE type_file.num10,
       g_fbn07_year,g_fbn07_all LIKE fbn_file.fbn07,
       m_faj242         LIKE faj_file.faj242,
       m_faj302         LIKE faj_file.faj302,
       m_faj322         LIKE faj_file.faj322,
       m_faj2032        LIKE faj_file.faj2032,
       m_faj572         LIKE faj_file.faj572,
       m_faj5712        LIKE faj_file.faj5712 
DEFINE l_fbn07          LIKE fbn_file.fbn07
DEFINE l_fbn08          LIKE fbn_file.fbn08

MAIN
 DEFINE l_cnt   LIKE type_file.num5   
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
   CALL cl_used(g_prog,g_time, 1)  RETURNING g_time #FUN-B60140   

   IF g_faa.faa31 = 'N' THEN
      CALL cl_err('','afa-260',1)
      EXIT PROGRAM
   END IF

   WHILE TRUE
      IF g_bgjob = "N" THEN
         SELECT * INTO g_faa.* FROM faa_file WHERE faa00='0'
         SELECT faa02c,faa072,faa082 INTO m_faa02c,m_yy,m_mm FROM faa_file
          WHERE faa00='0'
         IF SQLCA.sqlcode THEN LET m_faa02c='00' END IF
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
            CALL s_azmm(m_yy,m_mm,g_faa.faa02p,g_faa.faa02c) RETURNING l_flag,l_bdate,l_edate
         ELSE
           CALL s_azm(m_yy,m_mm) RETURNING l_flag,l_bdate,l_edate
         END IF
         LET tm.yy = YEAR(l_bdate)
         LET tm.mm = MONTH(l_bdate)
         IF tm.mm = 1 THEN
            SELECT COUNT(*) INTO l_cnt
              FROM foo_file
             WHERE foo03=tm.yy-1
            IF l_cnt > 0 THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM foo_file
                WHERE foo03=tm.yy
                  AND foo04=tm.mm-1
               IF l_cnt = 0 THEN
                  CALL cl_err('','afa-117',1)
                  EXIT WHILE
               END IF
            END IF
         END IF
         CALL p200()
         IF cl_sure(18,20) THEN
            LET g_cnt2 = 1
            CALL g_show_msg.clear()
            CALL p200_process1()
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
               CLOSE WINDOW p200_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_cnt2 = 1
         CALL g_show_msg.clear()
         CALL p200_process1()
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
   CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140
END MAIN
   
FUNCTION p200()
   DEFINE   lc_cmd    LIKE type_file.chr1000      

   OPEN WINDOW p200_w AT p_row,p_col WITH FORM "afa/42f/afap200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()

   CLEAR FORM
   CALL cl_opmsg('w')
   IF g_aza.aza26 = '2' THEN                                                   
      CALL cl_err('','afa-397',0)                                              
   END IF                                                                      

   LET tm.yy = YEAR(l_bdate)      
   LET tm.mm = MONTH(l_bdate)    
   LET m_tot=0
   LET m_tot_fan07=0
   LET m_tot_fan14=0
   LET m_tot_fan15=0
   LET m_tot_fan17=0        
   LET m_tot_fbn07=0
   LET m_tot_fbn14=0
   LET m_tot_fbn15=0
   LET m_tot_fbn17=0        
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
      CLOSE WINDOW p200_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
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

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p200_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
      EXIT PROGRAM
   END IF

   IF g_wc =' 1=1' THEN
      CALL cl_err('','9046',0) 
      CONTINUE WHILE
   END IF

   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "afap200"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap200','9031',1)  
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",
                      " '",tm.mm CLIPPED,"'",
                      " '",g_bgjob  CLIPPED,"'"
         CALL cl_cmdat('afap200',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p200_w
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE

END FUNCTION

FUNCTION p200_process1()
   DEFINE l_over        LIKE type_file.chr1,
          l_fbi02       LIKE fbi_file.fbi02,
          l_fbi021      LIKE fbi_file.fbi021,
          p_yy,p_mm     LIKE type_file.num5,   
          m_faj352      LIKE faj_file.faj352,
          l_faj332      LIKE faj_file.faj332,
          l_faj3312     LIKE faj_file.faj3312,
          p_fbn08       LIKE fbn_file.fbn08,   
          p_fbn15       LIKE fbn_file.fbn15,   
          l_rate        LIKE azx_file.azx04,          
          l_rate_y      LIKE type_file.num20_6,
          t_rate        LIKE type_file.num26_10,         
          t_rate2       LIKE type_file.num26_10,          
          l_fgj05       LIKE fgj_file.fgj05,
          l_amt_y       LIKE faj_file.faj31
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
   DEFINE g_flag        LIKE type_file.chr1  
   DEFINE g_bookno1     LIKE aza_file.aza81  
   DEFINE g_bookno2     LIKE aza_file.aza82  
   DEFINE l_aag04       LIKE aag_file.aag04  
   DEFINE l_bdate       LIKE type_file.dat   
   DEFINE l_edate       LIKE type_file.dat   
   DEFINE l_cnt         LIKE type_file.num5  
   DEFINE l_flag        LIKE type_file.chr1  
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_azi04        LIKE azi_file.azi04  #CHI-C60010 add

   CALL s_get_bookno(m_yy) RETURNING g_flag,g_bookno1,g_bookno2

   LET l_bdate = MDY(tm.mm,1,tm.yy)      #取得當月第一天   
   LET l_edate = s_monend(tm.yy,tm.mm)   #取得當月最後一天

   #------------------ 資產主檔 SQL ----------------------------------
   # 判斷 資產狀態, 開始折舊年月, 確認碼, 折舊方法, 剩餘月數
   LET g_sql="SELECT '1',faj_file.* FROM faj_file ",
             " WHERE faj432 NOT IN ('0','4','5','6','7','X') ",
             " AND faj272 <= '",g_ym CLIPPED,"'",
             " AND faj332+faj3312-(faj1012-faj1022) > 0 ", 
             " AND fajconf='Y' AND ",g_wc CLIPPED 

   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3','4')"
   ELSE
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3')"
   END IF                                                                      

   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
     #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark    
	  LET g_sql = g_sql CLIPPED," AND faj432 <> 'Z' " #No.FUN-B80081 add 
   END IF                                                                      

   LET g_sql = g_sql CLIPPED," UNION ALL ", 
               "SELECT '2',faj_file.* FROM faj_file ",   #折畢再提/續提
               " WHERE faj432 IN ('7') ",
               " AND faj332-(faj1012-faj1022) > 0 ",  
               " AND fajconf='Y' AND ",g_wc CLIPPED 

   IF g_aza.aza26 = '2' THEN                                                   
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3','4')"
   ELSE
      LET g_sql = g_sql CLIPPED," AND faj282 IN ('1','2','3')"
   END IF                                                                      

   #已停用資產是否提列折舊                                                       
   IF g_faa.faa30 = 'N' THEN                                                   
     #LET g_sql = g_sql CLIPPED," AND (faj105 = 'N' OR faj105 IS NULL)" #No.FUN-B80081 mark     
	  LET g_sql = g_sql CLIPPED," AND faj432 <> 'Z' " #No.FUN-B80081 add
   END IF                                                                      

   LET g_sql = g_sql CLIPPED," ORDER BY 3,4,5 "  

   PREPARE p200_pre22 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('p200_pre22',STATUS,0) 
      RETURN 
   END IF

   DECLARE p200_cur22 CURSOR WITH HOLD FOR p200_pre22

   LET l_flag ='N' 
   FOREACH p200_cur22 INTO g_type,g_faj.*
      IF SQLCA.sqlcode THEN 
         CALL cl_err('p200_cur22 foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF

      LET g_success='Y'

      BEGIN WORK

      #--折舊月份已提列折舊,則不再提列(訊息不列入清單中)
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM fbn_file 
       WHERE fbn01=g_faj.faj02 AND fbn02=g_faj.faj022
         AND (fbn03>m_yy OR (fbn03=m_yy AND fbn04>=m_mm))  
         AND fbn05 <> '3' AND fbn041='1'
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF

      #--檢核異動未過帳
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM fay_file,faz_file
       WHERE fay01=faz01 AND faz03=g_faj.faj02 AND faz031=g_faj.faj022
         AND faypost<>'Y' 
         AND fay02 BETWEEN l_bdate AND l_edate
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
         AND fbapost<>'Y' 
         AND fba02 BETWEEN l_bdate AND l_edate
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
         AND fbcpost<>'Y' 
         AND fbc02 BETWEEN l_bdate AND l_edate
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
         AND fgh02 BETWEEN l_bdate AND l_edate
         AND fgh03='3' 
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

      #--檢核當月處份應提列折舊='N',已存在處份資料,不可進行折舊 
      IF g_faa.faa232 = 'N' THEN
         IF g_faj.faj17-g_faj.faj582=0 THEN 
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM fbg_file,fbh_file
             WHERE fbg01=fbh01 AND fbh03=g_faj.faj02 AND fbh031=g_faj.faj022
               AND fbg02 BETWEEN l_bdate AND l_edate 
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
                AND fbe02 BETWEEN l_bdate AND l_edate   
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
         END IF
      END IF 

      #--若在折舊月份前就為先前折畢
      IF g_faj.faj302 = 0 and ( g_faj.faj572 < m_yy or
         ( g_faj.faj572=m_yy and g_faj.faj5712 < m_mm )) THEN
         LET l_over = 'Y'    
      ELSE
         LET l_over = 'N'    
      END IF 

      #--折舊提列時，再檢查/設定折舊科目
      IF g_faa.faa20 = '2' THEN  
         IF g_faj.faj232='1' THEN 
            LET l_fbi02  = NULL
            LET l_fbi021 = NULL
            DECLARE p200_fbi2 CURSOR FOR SELECT fbi02,fbi021
                                           FROM fbi_file
                                          WHERE fbi01=g_faj.faj242
                                            AND fbi03= g_faj.faj04  
            FOREACH p200_fbi2 INTO l_fbi02,l_fbi021
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_fbi021) THEN
                  EXIT FOREACH
               END IF
            END FOREACH
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
      ELSE
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

      IF g_faj.faj332+g_faj.faj3312 <= g_faj.faj312 OR g_faj.faj432='7' THEN  
         LET g_type = '2'
      ELSE
         LET g_type = '1'
      END IF

      LET m_faj302=g_faj.faj302   

      #已為最後一期折舊則將剩餘淨值一併視為該期折舊
      LET l_amt_y = 0          

     #----------------------MOD-C50132-----------------(S)
     #取用財簽二幣別取位
     #SELECT azi04 INTO g_azi04 FROM azi_file #CHI-C60010 mark
      SELECT azi04 INTO l_azi04 FROM azi_file #CHI-C60010 add
       WHERE azi01 = g_faj.faj143               
     #----------------------MOD-C50132-----------------(E)
 
      IF m_faj302=1 THEN   
         IF g_type = '1' THEN 
            LET m_amt=g_faj.faj142+g_faj.faj1412-g_faj.faj592 
                                  -(g_faj.faj322-g_faj.faj602)
                                  -(g_faj.faj1012-g_faj.faj1022) - g_faj.faj312    
           #末月的折舊金額不應包含faj3312
            IF g_faa.faa152 = '4' THEN                                                                                               
               LET m_amt = m_amt - g_faj.faj3312
            END IF                                                                                                                  
         ELSE  
            LET m_amt=g_faj.faj142+g_faj.faj1412-g_faj.faj592
                                 -(g_faj.faj322-g_faj.faj602)-g_faj.faj352
         END IF
      ELSE
         IF m_faj302 = 0 THEN 
           #faa15=4時,當為未用年限為0之次月,折舊金額應為faj3312
            IF g_faa.faa152 = '4' THEN                                                                                               
               LET m_amt = g_faj.faj3312
            ELSE                                                                                                                    
               LET m_amt = 0
            END IF
         ELSE 
            CASE g_faj.faj282
               WHEN '1'    #有殘值
                  IF g_type = '1' THEN   #一般提列 
                     LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                               (g_faj.faj322-g_faj.faj602)-g_faj.faj312-
                                g_faj.faj3312-
                               (g_faj.faj1012-g_faj.faj1022))/m_faj302 
                  ELSE                   #折畢提列
                    #--------------------------MOD-C70270------------------(S)
                    #--MOD-C70270--mark
                    #LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                    #          (g_faj.faj322-g_faj.faj602)-g_faj.faj352)/
                    #          m_faj302
                    #--MOD-C70270--mark
                     LET m_amt = (g_faj.faj142 + g_faj.faj1412 - g_faj.faj592
                               - (g_faj.faj322 - g_faj.faj602) - g_faj.faj352
                               - (g_faj.faj1012-g_faj.faj1022)) / m_faj302
                    #--------------------------MOD-C70270------------------(E)
                  END IF
               WHEN '2'    #無殘值
                  IF g_aza.aza26 = '2' THEN      #雙倍餘額遞減法             
                     IF m_faj302 > 24 THEN                                    
                        IF g_faj.faj1082 = 0 OR (g_faj.faj302 MOD 12 = 0) THEN 
                           LET l_rate_y = (2/(g_faj.faj292/12))  
                           LET l_amt_y = (g_faj.faj142+g_faj.faj1412-
                                          g_faj.faj592- 
                                          g_faj.faj3312- 
                                         (g_faj.faj322-g_faj.faj602))*l_rate_y
                           LET m_amt = l_amt_y / 12 
                        ELSE  
                           LET m_amt = g_faj.faj1082 / 12
                        END IF 
                     ELSE 
                        IF m_faj302 = 24 THEN 
                           LET l_amt_y = (g_faj.faj142+g_faj.faj1412-  
                                          g_faj.faj592- 
                                          g_faj.faj3312-
                                         (g_faj.faj322-g_faj.faj602)-
                                          g_faj.faj312) / 2 
                           LET m_amt = l_amt_y / 12 
                        ELSE 
                           LET m_amt = g_faj.faj1082 / 12 
                        END IF 
                     END IF
                  ELSE
                    #------------------MOD-C70003--------------------------(S)
                    #--MOD-C70003--mark
                    #LET m_amt = (g_faj.faj142 + g_faj.faj1412 - g_faj.faj592-
                    #            g_faj.faj3312 -
                    #            (g_faj.faj322 - g_faj.faj602)) / m_faj302
                    #--MOD-C70003--mark
                     LET m_amt = (g_faj.faj142 + g_faj.faj1412 - g_faj.faj592
                                -g_faj.faj3312 - (g_faj.faj322 - g_faj.faj602)
                                -(g_faj.faj1012 - g_faj.faj1022)) / m_faj302
                    #------------------MOD-C70003--------------------------(E)
                  END IF
               WHEN '3'    #定率餘額遞減法
                  IF g_aza.aza26 = '2' THEN    #年數總合法                   
                     IF g_faj.faj1082 = 0 OR (g_faj.faj302 MOD 12 = 0) THEN                         
                        LET l_rate_y = (m_faj302/12)/((g_faj.faj292/12)*       
                                       ((g_faj.faj292/12)+1)/2)               
                        LET l_amt_y = (g_faj.faj142+g_faj.faj1412-g_faj.faj312) 
                                       * l_rate_y                            
                        LET m_amt = l_amt_y / 12                             
                     ELSE                                                    
                        LET m_amt = g_faj.faj1082 / 12                        
                     END IF                                                  
                  ELSE           
                     #--計算前期日期範圍-----------
                     LET l_date = g_faj.faj272
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
                         LET l_depr_amt = 0
                         LET l_depr_amt0= 0
                         LET l_depr_amt_1= 0   
                         LET l_depr_amt_2= 0   
                         LET g_sql = "SELECT faj322 FROM faj_file",
                                     " WHERE faj02 = '",g_faj.faj02,"'",
                                     "   AND faj022= '",g_faj.faj022,"'"
                         PREPARE p200_amt_p02 FROM g_sql
                         DECLARE p200_amt_c02 CURSOR WITH HOLD FOR p200_amt_p02
                         OPEN p200_amt_c02 
                         FETCH p200_amt_c02 INTO l_depr_amt0
                         IF cl_null(l_depr_amt0) THEN LET l_depr_amt0=0 END IF
                         #抓取前一次截止期+1~前一次折舊期間的折舊值,可用兩種方式抓取!
                         #1.找看看有沒有上一次截止期的折舊記錄,若有就直接SUM這段期間的折舊加總
                         LET g_sql = "SELECT COUNT(*) FROM fbn_file",
                                     " WHERE fbn01 = '",g_faj.faj02,"'",
                                     "   AND fbn02 = '",g_faj.faj022,"'",
                                     "   AND fbn03||'/'||SUBSTR(('0'||fbn04),length('0'||fbn04)-1,2) ||'/01'",
                                     "             = '",l_year2,"/",l_month2,"/01'",
                                     "   AND fbn041 = '1'"
                         PREPARE p200_amt_cnt_p2 FROM g_sql
                         DECLARE p200_amt_cnt_c2 CURSOR WITH HOLD FOR p200_amt_cnt_p2
                         OPEN p200_amt_cnt_c2 
                         FETCH p200_amt_cnt_c2 INTO l_cnt
                         IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
                         IF l_cnt > 0 THEN
                            LET g_sql = "SELECT SUM(fbn07) ",
                                        "  FROM fbn_file ",
                                        " WHERE fbn01 = '",g_faj.faj02,"'",
                                        "   AND fbn02 = '",g_faj.faj022,"'",
                                        "   AND fbn03||'/'||SUBSTR(('0'||fbn04),length('0'||fbn04)-1,2) ||'/01'",
                                        "            >= '",l_year2,"/",l_month2,"/01'",
                                        "   AND fbn041 = '1'"
                            PREPARE p200_amt_p2 FROM g_sql
                            DECLARE p200_amt_c2 CURSOR WITH HOLD FOR p200_amt_p2
                            OPEN p200_amt_c2 
                            FETCH p200_amt_c2 INTO l_depr_amt      #前期累折   
                            IF cl_null(l_depr_amt) THEN LET l_depr_amt=0 END IF
                         ELSE
                            #1.那這段期間的折舊加總可用(截止期-2)期別折舊額*11
                            #                         +(截止期-1)期別折舊額(因為有尾差會調在最後一期)
                            LET g_sql = "SELECT fbn07*11 ",                        
                                        "  FROM fbn_file ",                        
                                        " WHERE fbn01 = '",g_faj.faj02,"'",        
                                        "   AND fbn02 = '",g_faj.faj022,"'",       
                                        "   AND fbn03 = ",l_year_new,
                                        "   AND fbn04 = ",l_month2-2,              
                                        "   AND fbn041 = '1'"                      
                            PREPARE p200_amt_p012 FROM g_sql
                            DECLARE p200_amt_c012 CURSOR WITH HOLD FOR p200_amt_p012
                            OPEN p200_amt_c012                 
                            FETCH p200_amt_c012 INTO l_depr_amt_1
                            IF cl_null(l_depr_amt_1) THEN LET l_depr_amt_1=0 END IF
                            LET g_sql = "SELECT fbn07 ",                        
                                        "  FROM fbn_file ",                        
                                        " WHERE fbn01 = '",g_faj.faj02,"'",        
                                        "   AND fbn02 = '",g_faj.faj022,"'",       
                                        "   AND fbn03 = ",l_year_new,
                                        "   AND fbn04 = ",l_month2-1,              
                                        "   AND fbn041 = '1'"                      
                            PREPARE p200_amt_p12 FROM g_sql
                            DECLARE p200_amt_c12 CURSOR WITH HOLD FOR p200_amt_p12
                            OPEN p200_amt_c12
                            FETCH p200_amt_c12 INTO l_depr_amt_2
                            IF cl_null(l_depr_amt_2) THEN LET l_depr_amt_2=0 END IF
                         END IF
                         LET l_depr_amt=l_depr_amt0-(l_depr_amt_1+l_depr_amt_2+l_depr_amt)
                     ELSE
                         LET l_depr_amt = 0
                     END IF

                     IF g_type = '1' THEN   #一般提列 
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT pow(g_faj.faj312/(g_faj.faj142+g_faj.faj1412),   
                                   1/(g_faj.faj292/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) /12) * 100
                        LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                                   g_faj.faj3312-(l_depr_amt))*t_rate2 / 100
                     ELSE                   #折畢提列
                        LET t_rate = 0
                        LET t_rate2= 0
                        SELECT pow(g_faj.faj352/(g_faj.faj142+g_faj.faj1412),
                                   1/(g_faj.faj292/12)) INTO t_rate
                          FROM faa_file
                         WHERE faa00 = '0'
                        LET t_rate2 = ((1 - t_rate) / 12) * 100
                        LET m_amt=(g_faj.faj142+g_faj.faj1412-g_faj.faj592-
                                  (l_depr_amt)) * t_rate2 / 100
                     END IF
                  END IF
               OTHERWISE
                  EXIT CASE
            END CASE
         END IF
      END IF
      IF g_aza.aza26 = '2' THEN                                                
         IF g_faj.faj282 = '4' THEN      #工作量法                              
            LET l_fgj05 = 0                                                    
            SELECT fgj05 INTO l_fgj05 FROM fgj_file                            
             WHERE fgj01 = m_yy AND fgj02 = m_mm 
               AND fgj03 = g_faj.faj02 AND fgj04 = g_faj.faj022                
               AND fgjconf = 'Y'                                               
            IF cl_null(l_fgj05) THEN LET l_fgj05 = 0 END IF                    
            LET l_rate_y = (g_faj.faj142+g_faj.faj1412-g_faj.faj312)/g_faj.faj1062
            LET m_amt = l_rate_y * l_fgj05 
         END IF                                                                
         #LET l_amt_y = cl_digcut(l_amt_y,g_azi04) #CHI-C60010 mark                         
         IF l_amt_y = 0 THEN LET l_amt_y = g_faj.faj1082 END IF                 
         IF g_faj.faj282 NOT MATCHES '[23]' THEN                                
            LET l_amt_y = 0                                                    
         END IF                                                                
      ELSE                                                                     
         LET l_amt_y = 0                                                       
      END IF                                                                   
      #新增一筆折舊費用資料 ----------------------------------------
      IF g_faj.faj232 = '1' THEN
         LET m_faj242 = g_faj.faj242   # 單一部門 -> 折舊部門
      ELSE
         LET m_faj242 = g_faj.faj20   # 多部門分攤 -> 保管部門
      END IF

      LET m_cost=g_faj.faj142+g_faj.faj1412-g_faj.faj592  #成本
      IF cl_null(m_amt) THEN LET m_amt = 0 END IF
      #LET m_amt = cl_digcut(m_amt,g_azi04) #CHI-C60010 mark

      #先把完整一個月該提列的折舊金額舊值記錄起來                                                                                   
      LET m_amt_o = m_amt                                                                                                           
      IF cl_null(m_amt_o) THEN LET m_amt_o = 0 END IF                                                                               

      IF g_faa.faa152 = '4' THEN
         IF g_ym = g_faj.faj272 THEN    #第一期攤提
            LET l_first = l_last - DAY(g_faj.faj262) + 1
            LET l_rate = l_first / l_last   #攤提比率
            IF cl_null(l_rate) THEN
               LET l_rate = 1 
            END IF 
            LET m_amt = m_amt * l_rate
           #算出第一個月未折減額faj331=完整一個月該攤提折舊-第一期攤提折舊                                                          
            IF cl_null(m_amt) THEN LET m_amt = 0 END IF                                                                             
            #LET m_amt = cl_digcut(m_amt,g_azi04) #CHI-C60010 mark                                                                                   
            LET l_faj3312 = m_amt_o - m_amt                                                                                          
            IF cl_null(l_faj3312) THEN LET l_faj3312 = 0 END IF                                                                       
            #LET l_faj3312 = cl_digcut(l_faj3312,g_azi04) #CHI-C60010 mark                                                              
         END IF  
      END IF
      LET m_accd=g_faj.faj322-g_faj.faj602+m_amt         #累折
      #--->本期累折改由(faj_file)讀取
      #--->本期累折 - 本期銷帳累折
      IF g_faj.faj2032 = 0 THEN
         LET m_curr   = m_amt 
         LET m_faj2032 = m_amt
      ELSE
         LET m_curr=(g_faj.faj2032 - g_faj.faj2042) + m_amt  
         LET m_faj2032 = g_faj.faj2032 + m_amt
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
      IF cl_null(m_faj242) THEN LET m_faj242=' ' END IF
#CHI-C60010--add--str--
      LET m_amt = cl_digcut(m_amt,l_azi04)
      LET m_curr= cl_digcut(m_curr,l_azi04)
      LET m_cost= cl_digcut(m_cost,l_azi04)
      LET m_accd= cl_digcut(m_accd,l_azi04)
      LET g_faj.faj1012= cl_digcut(g_faj.faj1012,l_azi04)
      LET g_faj.faj1022=cl_digcut(g_faj.faj1022,l_azi04)
#CHI-C60010--add--end   
      INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06,         
                            fbn07,fbn08,fbn09,fbn10,fbn11,fbn12,fbn13,          
                            fbn14,fbn15,fbn16,fbn17,fbn20, #MOD-BC0131 add fbn20
                            fbnlegal ) #No:FUN-B60140                            
                     VALUES(g_faj.faj02,g_faj.faj022,m_yy,m_mm,'1',
                            g_faj.faj232,m_faj242,m_amt,m_curr,' ',g_faj.faj432,         
                            g_faj.faj531,g_faj.faj551,g_faj.faj242,                
                            m_cost,m_accd,1,g_faj.faj1012-g_faj.faj1022,g_faj.faj541,g_legal)  #No:FUN-B60140 add g_legal #MOD-BC0131 add fbn20
      IF SQLCA.sqlcode THEN
         LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
         LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      #update 回資產主檔
      # 剩餘月數減 1
      LET m_faj302 = g_faj.faj302 -1
      LET m_faj352 = g_faj.faj352
      IF m_faj302 < 0 THEN LET m_faj302 = 0 END IF
      #----->資產狀態碼 
      IF g_type = '2' THEN   
         IF m_faj302 > 0 THEN   
            LET m_status = '7'
         ELSE 
            LET m_status = '4' 
         END IF   
      ELSE
         IF m_faj302=0 THEN 
           #當faa15=4時,判斷資產是否折畢,除了看未用年限是否變為0外,                                                                 
           #還要看faj331也變為0才視為折畢,不然狀態還是要為折舊中                                                                    
            IF g_faa.faa152 = '4' THEN                                                                                               
              #IF l_over = 'Y' THEN                        #已為折畢#MOD-C80114 mark
               IF l_over = 'Y' OR g_faj.faj3312 = 0 THEN   #已為折畢#MOD-C80114 add
                  IF g_faj.faj342 MATCHES '[Nn]' THEN                                                                                
                     LET m_status = '4'  # 折畢                                                                                     
                  ELSE                                                                                                              
                     LET m_status = '7'  # 折畢再提                                                                                 
                     LET m_faj302 = g_faj.faj362                                                                                      
                  END IF                                                                                                            
               ELSE                  #非最後那個殘月,資產狀態都需為2.折舊中                                                         
                  LET m_status = '2'                                                                                                
               END IF                                                                                                               
            ELSE                                                                                                                    
           #折畢再提:折完時,殘值為0 時 即為折畢
               IF g_faj.faj342 MATCHES '[Nn]' THEN
                  LET m_status = '4'
               ELSE
                  LET m_status='7'  # 第一次折畢, 即直接當做欲折畢再提 
                  LET m_faj302 = g_faj.faj362   
               END IF 
            END IF  
         ELSE 
            IF g_faj.faj432='7' THEN
               LET m_status = '7'
            ELSE
               LET m_status = '2'
            END IF
         END IF
      END IF
   #CHI-C60010--add--str--
      LET m_faj352=cl_digcut(m_faj352,l_azi04)
      LET m_faj2032=cl_digcut(m_faj2032,l_azi04)
      LET l_amt_y=cl_digcut(l_amt_y,l_azi04)
   #CHI-C60010--add--end
      #UPDATE  累折, 未折減額, 剩餘月數, 資產狀態
      IF g_faa.faa152 != '4' THEN
         IF l_over = 'N' THEN 
            LET l_faj332 = (g_faj.faj142 + g_faj.faj1412) - g_faj.faj592 
                         - (g_faj.faj322 + m_amt-g_faj.faj602)
                         - (g_faj.faj1012 - g_faj.faj1022)                    #MOD-C70022 add
            LET l_faj332=cl_digcut(l_faj332,l_azi04)  #CHI-C60010 add
            UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年
                                faj5712=m_mm,                  #最近折舊月
                                faj322 =faj322+m_amt,           #累折   
                                faj332 =l_faj332,               #未折減額
                                faj302 =m_faj302,               #未用年限
                                faj352 =m_faj352,               #折畢再提預留殘值
                                faj432 =m_status,              #狀態
                                faj2032=m_faj2032,              #本期累折   
                                faj1082=l_amt_y                #年折舊額 
             WHERE faj02=g_faj.faj02
               AND faj022=g_faj.faj022
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
      ELSE                                                                                                                          
         LET l_faj332 = (g_faj.faj142 + g_faj.faj1412) - g_faj.faj592                                                                         
                      - (g_faj.faj322 + m_amt_o-g_faj.faj602)                                                                              
                      - (g_faj.faj1012 - g_faj.faj1022)                    #MOD-C70022 add
         #非第一期的提列,faj33均需扣掉第一月的未折減額faj331                                                                        
         IF g_ym != g_faj.faj272 AND l_over = 'N' THEN                                                                               
            LET l_faj332 = l_faj332 - g_faj.faj3312                                                                                    
         END IF 
         LET l_faj332=cl_digcut(l_faj332,l_azi04)   #CHI-C60010 add
         LET l_faj3312=cl_digcut(l_faj3312,l_azi04) #CHI-C60010 add                                                                                                                    
         IF l_over = 'N' THEN   #非最後那個殘月的折舊                                                                               
            IF g_ym = g_faj.faj272 THEN  #第一期攤提                                                                                 
               UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年                                                        
                                   faj5712=m_mm,                  #最近折舊月                                                        
                                   faj322 =faj322+m_amt,           #累折                                                              
                                   faj332 =l_faj332,               #未折減額                                                          
                                   faj3312=l_faj3312,              #第一個月未折減額                                                  
                                   faj302 =m_faj302,               #未用年限                                                          
                                   faj352 =m_faj352,               #折畢再提預留殘值                                                  
                                   faj432 =m_status,              #狀態                                                              
                                   faj2032=m_faj2032,              #本期累折                                                          
                                   faj1082=l_amt_y                #年折舊額                                                          
                WHERE faj02=g_faj.faj02
                  AND faj022=g_faj.faj022                                                                     
            ELSE                                                                                                                    
               UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年                                                        
                                   faj5712=m_mm,                  #最近折舊月   
                                   faj322 =faj322+m_amt,          #累折                                                              
                                   faj332 =l_faj332,              #未折減額                                                          
                                   faj302 =m_faj302,              #未用年限                                                          
                                   faj352 =m_faj352,              #折畢再提預留殘值                                                  
                                   faj432 =m_status,              #狀態                                                              
                                   faj2032=m_faj2032,             #本期累折                                                          
                                   faj1082=l_amt_y                #年折舊額                                                          
                WHERE faj02=g_faj.faj02
                  AND faj022=g_faj.faj022                                                                     
            END IF                                                                                                                  
         ELSE                   #最後那個殘月的折舊                                                                                 
            UPDATE faj_file SET faj572 =m_yy,                  #最近折舊年                                                           
                                faj5712=m_mm,                  #最近折舊月                                                           
                                faj322 =faj322+m_amt,          #累折                                                                 
                                faj332 =l_faj332,              #未折減額                                                             
                                faj3312=0,                     #第一個月未折減額                                                     
                                faj302 =m_faj302,              #未用年限                                                             
                                faj352 =m_faj352,              #折畢再提預留殘值                                                     
                                faj432 =m_status,              #狀態                                                                 
                                faj2032=m_faj2032,             #本期累折                                                             
                                faj1082=l_amt_y                #年折舊額                                                             
             WHERE faj02=g_faj.faj02
               AND faj022=g_faj.faj022                                                                        
         END IF                                                                                                                     
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
      IF g_faj.faj232 = '2' THEN
         #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
         LET g_sql="SELECT * FROM fbn_file ",
                   " WHERE fbn03='",m_yy,"'",
                   "   AND fbn04='",m_mm,"'",
                   "   AND fbn05='2' AND fbn041 = '1' ",
                   "   AND fbn01='",g_faj.faj02,"'" 
         PREPARE p200_pre12 FROM g_sql
         DECLARE p200_cur12 CURSOR WITH HOLD FOR p200_pre12
         FOREACH p200_cur12 INTO g_fbn.*
            IF STATUS THEN
               LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
               LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
               LET g_show_msg[g_cnt2].ze01   = ''
               LET g_show_msg[g_cnt2].ze03   = 'foreach p200_cur12'
               LET g_cnt2 = g_cnt2 + 1
               LET g_success='N'  
               CONTINUE FOREACH
            END IF
            #-->讀取分攤方式
           #SELECT fad05,fad031 INTO m_fad05,m_fad031 FROM fad_file
            SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file   
             WHERE fad01=g_fbn.fbn03
               AND fad02=g_fbn.fbn04
               AND fad03=g_fbn.fbn11
               AND fad04=g_fbn.fbn13
               AND fad07 = "2"
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
                 WHERE fae01=g_fbn.fbn03
                   AND fae02=g_fbn.fbn04
                   AND fae03=g_fbn.fbn11
                   AND fae04=g_fbn.fbn13
                   AND fae10 = "2"
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
            LET mm_fbn07=g_fbn.fbn07          # 被分攤金額
            LET mm_fbn08=g_fbn.fbn08          # 本期累折金額
            LET mm_fbn14=g_fbn.fbn14          # 被分攤成本
            LET mm_fbn15=g_fbn.fbn15          # 被分攤累折
            LET mm_fbn17=g_fbn.fbn17          # 被分攤減值 
         
            #------- 找 fae_file 分攤單身檔 ---------------
            LET m_tot=0  
            DECLARE p200_cur21 CURSOR WITH HOLD FOR
            SELECT * FROM fae_file
             WHERE fae01=g_fbn.fbn03
               AND fae02=g_fbn.fbn04
               AND fae03=g_fbn.fbn11
               AND fae04=g_fbn.fbn13 
               AND fae10 = "2"
            FOREACH p200_cur21 INTO g_fae.*
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
                     LET l_n = 0   #MOD-BB0145 add
                     #SELECT rowid INTO g_fbn_rowid FROM fbn_file #FUN-B60140mark
                     SELECT count(*) INTO l_n FROM fbn_file #FUN-B60140 add
                      WHERE fbn01=g_fbn.fbn01
                        AND fbn02=g_fbn.fbn02
                        AND fbn03=g_fbn.fbn03
                        AND fbn04=g_fbn.fbn04
                        AND fbn06=g_fae.fae06
                        AND fbn05='3'
                        AND (fbn041 = '1' OR fbn041='0')    
                     #IF STATUS=100 THEN#FUN-B60140mark
                    #MOD-BB0145 -- mark begin --
                    #IF l_n<>0 THEN     #FUN-B60140 add
                    ##   LET g_fbn_rowid=NULL #FUN-B60140mark
                    #    LET l_n=NULL   #FUN-B60140 add
                    #END IF
                    #MOD-BB0145 -- mark end --
                     LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fbn16用)
                     LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
                     LET m_fbn07=mm_fbn07*m_ratio/100          # 分攤金額
                     LET m_curr =mm_fbn08*m_ratio/100          # 分攤金額
                     LET m_fbn14=mm_fbn14*m_ratio/100          # 分攤成本
                     LET m_fbn15=mm_fbn15*m_ratio/100          # 分攤累折
                     LET m_fbn17=mm_fbn17*m_ratio/100          # 分攤減值 
                     LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                     #LET m_fbn07 = cl_digcut(m_fbn07,g_azi04) #CHI-C60010 mark
                     LET mm_fbn07 = mm_fbn07 - m_fbn07         # 被分攤總數減少
                     #LET m_curr   = cl_digcut(m_curr,g_azi04) #CHI-C60010 mark
                     LET mm_fbn08 = mm_fbn08 - m_curr          # 被分攤總數減少
                     #LET m_fbn14 = cl_digcut(m_fbn14,g_azi04) #CHI-C60010 mark
                     LET mm_fbn14 = mm_fbn14 - m_fbn14         # 被分攤總數減少
                     #LET m_fbn15  = cl_digcut(m_fbn15,g_azi04)#CHI-C60010 mark
                     LET mm_fbn15 = mm_fbn15 - m_fbn15         # 被分攤總數減少
                     #LET m_fbn17  = cl_digcut(m_fbn17,g_azi04)#CHI-C60010 mark 
                     LET mm_fbn17 = mm_fbn17 - m_fbn17         # 被分攤總數減少
                  #CHI-C60010--add--str--
                     LET m_fbn07 = cl_digcut(m_fbn07,l_azi04)
                     LET m_curr = cl_digcut(m_curr,l_azi04)
                     LET m_fbn14 = cl_digcut(m_fbn14,l_azi04)
                     LET m_fbn15 = cl_digcut(m_fbn15,l_azi04)
                     LET m_fbn17 = cl_digcut(m_fbn17,l_azi04)
                     LET mm_ratio= cl_digcut(mm_ratio,l_azi04)
                  #CHI-C60010--add--end
                    #IF l_n IS NOT NULL THEN   #MOD-BB0145 mark
                     IF l_n > 0 THEN           #MOD-BB0145
                        UPDATE fbn_file SET fbn07 = m_fbn07,
                                            fbn08 = m_curr,
                                            fbn09 = g_fbn.fbn06,
                                            fbn14 = m_fbn14,
                                            fbn15 = m_fbn15,
                                            fbn16 = mm_ratio,
                                            fbn17 = m_fbn17,
                                            fbn11 =m_fad031,
                                            fbn12 =g_fae.fae07
                        #WHERE ROWID=g_fbn_rowid
                        #---FUN-B60140---add---- 
                        WHERE fbn01=g_fbn.fbn01
                          AND fbn02=g_fbn.fbn02
                          AND fbn03=g_fbn.fbn03
                          AND fbn04=g_fbn.fbn04
                          AND fbn06=g_fae.fae06
                          AND fbn05='3'
                          AND (fbn041 = '1' OR fbn041='0')
                        #---FUN-B60140---add---end---- 
                        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     ELSE
                        IF cl_null(g_fae.fae06) THEN
                           LET g_fae.fae06=' '
                        END IF
                        INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,   
                                             fbn05,fbn06,fbn07,fbn08,fbn09,    
                                             fbn10,fbn11,fbn12,fbn13,fbn14,    
                                             fbn15,fbn16,fbn17,fbn20, #MOD-BC0131 add fbn20
                                             fbnlegal )   #NO:FUN-B60140 add fbnlegal              
                                      VALUES(g_fbn.fbn01,g_fbn.fbn02,          
                                             g_fbn.fbn03,g_fbn.fbn04,'1','3',  
                                            #m_fad031,g_fae.fae07,m_curr,           #MOD-BB0145 mark
                                             g_fae.fae06,m_fbn07,m_curr,            #MOD-BB0145
                                            #g_fbn.fbn06,g_faj.faj43,g_fbn.fbn11,   #MOD-BB0145 mark 
                                             g_fbn.fbn06,g_faj.faj432,g_fbn.fbn11,  #MOD-BB0145
                                             g_fae.fae07,g_fbn.fbn13,m_fbn14,  
                                             m_fbn15,mm_ratio,m_fbn17,g_faj.faj541,g_legal) #NO:FUn-B60140 add g_legal #MOD-BC0131 add fbn20
                        IF STATUS THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     END IF
                # dennon lai 01/04/18 本期累折=今年度本期折舊(fbn07)的加總
                #                     累積折舊=全期本期折舊(fbn07)的加總
                #No.3426 010824 modify 若用上述方法在年中導入時折舊會少
                   #例7月導入,fbn 6月資料,本月折舊fbn07=6月折舊金額, 故用
                   #select sum(fbn07)的方法會少1-5 月的折舊金額
                   #故改成抓前一期累折+本月的折舊
                        IF g_fbn.fbn04=1 THEN
                           LET p_yy = g_fbn.fbn03-1
                           LET p_mm=12
                        ELSE
                           LET p_yy = g_fbn.fbn03
                           LET p_mm=g_fbn.fbn04-1
                        END IF
                         LET p_fbn08=0  LET p_fbn15=0
                         SELECT SUM(fbn08),SUM(fbn15) INTO p_fbn08,p_fbn15
                           FROM  fbn_file
                          WHERE fbn01=g_fbn.fbn01
                            AND fbn02=g_fbn.fbn02
                            AND fbn03=p_yy
                            AND fbn04=p_mm
                            AND fbn06=g_fae.fae06 AND fbn05='3'
                            AND (fbn041 = '1' OR fbn041='0')    
                        IF SQLCA.SQLCODE THEN
                           LET p_fbn08=0   LET p_fbn15=0
                        END IF
                        IF cl_null(p_fbn08) THEN
                           LET p_fbn08=0
                        END IF
                        IF cl_null(p_fbn15) THEN 
                           LET p_fbn15=0
                        END IF
                        IF g_fbn.fbn04 = 1 THEN
                           LET p_fbn08 = 0
                        END IF
                        LET g_fbn07_year = p_fbn08 +m_fbn07
                        LET g_fbn07_all  = p_fbn15 +m_fbn07
                        LET g_fbn07_year= cl_digcut(g_fbn07_year,l_azi04) #CHI-C60010 add
                        LET g_fbn07_all = cl_digcut(g_fbn07_all,l_azi04)  #CHI-C60010 add
                        UPDATE fbn_file SET fbn08=g_fbn07_year,fbn15=g_fbn07_all
                         WHERE fbn01=g_fbn.fbn01
                           AND fbn02=g_fbn.fbn02
                           AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                           AND fbn06=g_fae.fae06 AND fbn05='3'
                           AND fbn041 = '1'
                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     WHEN '2'
                        LET l_aag04 = ''
                        SELECT aag04 INTO l_aag04 FROM aag_file
                         WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
                        IF l_aag04='1' THEN
                           SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                            WHERE aao00 =m_faa02b AND aao01=g_fae.fae09
                              AND aao02 =g_fae.fae06 AND aao03=m_yy
                              AND aao04<=m_mm
                        ELSE
                           SELECT aao05-aao06 INTO m_aao FROM aao_file
                            WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                              AND aao02=g_fae.fae06 AND aao03=m_yy
                              AND aao04=m_mm
                        END IF  
                        IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                        LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
                  END CASE
               END FOREACH
      
          #----- 若為變動比率, 重新 foreach 一次 insert into fbn_file -----------
               IF m_fad05='2' THEN
                  LET m_max_ratio = 0          #MOD-970027 add
                  LET m_max_fae06 =''          #MOD-970027 add
                  FOREACH p200_cur21 INTO g_fae.*   #MOD-B40085 mod p200_cur22->p200_cur21
                     LET l_aag04 = ''
                     SELECT aag04 INTO l_aag04 FROM aag_file
                      WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
                     IF l_aag04='1' THEN
                        SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                         WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                           AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04<=m_mm
                     ELSE
                        SELECT aao05-aao06 INTO m_aao FROM aao_file
                         WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                           AND aao02=g_fae.fae06 AND aao03=m_yy AND aao04=m_mm  
                     END IF   #MOD-970218 add
                     IF STATUS=100 OR m_aao IS NULL THEN
                        LET m_aao=0 
                     END IF
                     SELECT SUM(fbn07) INTO y_curr FROM fbn_file
                      WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                        AND fbn03=tm.yy       AND fbn04<tm.mm         
                        AND fbn06=g_fae.fae06 AND fbn05='3' 
                     
                     IF cl_null(y_curr) THEN
                        LET y_curr = 0 
                     END IF
                     LET m_ratio = m_aao/m_tot*100
                     IF m_ratio > m_max_ratio THEN
                        LET m_max_fae06 = g_fae.fae06
                        LET m_max_ratio = m_ratio
                     END IF
                     LET m_ratio=cl_digcut(m_ratio,l_azi04) #CHI-C60010 add
                     LET m_fbn07=g_fbn.fbn07*m_ratio/100
                     LET m_curr = y_curr + m_fbn07        
                     LET m_fbn14=g_fbn.fbn14*m_ratio/100
                     LET m_fbn15=g_fbn.fbn15*m_ratio/100
                     LET m_fbn17=g_fbn.fbn17*m_ratio/100
                  #CHI-C60010--mark--str--   
                     #LET m_fbn07 = cl_digcut(m_fbn07,g_azi04)
                     #LET m_curr = cl_digcut(m_curr,g_azi04)
                     #LET m_fbn14 = cl_digcut(m_fbn14,g_azi04)
                     #LET m_fbn15 = cl_digcut(m_fbn15,g_azi04)
                     #LET m_fbn17 = cl_digcut(m_fbn17,g_azi04)
                  #CHI-C60010--mark--end
                     LET m_tot_fbn07=m_tot_fbn07+m_fbn07
                     LET m_tot_curr =m_tot_curr +m_curr  
                     LET m_tot_fbn14=m_tot_fbn14+m_fbn14
                     LET m_tot_fbn15=m_tot_fbn15+m_fbn15
                     LET m_tot_fbn17=m_tot_fbn17+m_fbn17  
                     LET g_cnt = 0   #MOD-BB0145 add
                     SELECT COUNT(*) INTO g_cnt FROM fbn_file
                      WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                        AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                        AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041 = '1'
                  #CHI-C60010--add--str--
                     LET m_fbn07 = cl_digcut(m_fbn07,l_azi04)
                     LET m_curr = cl_digcut(m_curr,l_azi04)
                     LET m_fbn14 = cl_digcut(m_fbn14,l_azi04)
                     LET m_fbn15 = cl_digcut(m_fbn15,l_azi04)
                     LET m_fbn17 = cl_digcut(m_fbn17,l_azi04)
                  #CHI-C60010--add--end
                     IF g_cnt>0 THEN
                        UPDATE fbn_file SET fbn07 = m_fbn07,
                                            fbn08 = m_curr,
                                            fbn09 = g_fbn.fbn06,
                                            fbn16 = m_ratio,
                                            fbn17 = m_fbn17,
                                            fbn11 =m_fad031,
                                            fbn12 =g_fae.fae07
                         WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                           AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                           AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041 = '1'
                        IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN  
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     ELSE
                        IF cl_null(g_fae.fae06) THEN
                           LET g_fae.fae06=' '
                        END IF
                        INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,      
                                             fbn06,fbn07,fbn08,fbn09,fbn10,fbn11,       
                                             fbn12,fbn13,fbn14,fbn15,fbn16,fbn17,fbn20,fbnlegal) #No:FUN-B60140 add fbnlegal #MOD-BC0131 add fbn20
                                   VALUES(g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,       
                                         #g_fbn.fbn04,'1','3',m_fad031,g_fae.fae07,    #MOD-BB0145 mark
                                          g_fbn.fbn04,'1','3',g_fae.fae06,m_fbn07,     #MOD-BB0145
                                         #m_curr,g_fbn.fbn06,g_faj.faj43,g_fbn.fbn11,  #MOD-BB0145 mark 
                                          m_curr,g_fbn.fbn06,g_faj.faj432,g_fbn.fbn11, #MOD-BB0145
                                          g_fae.fae07,g_fbn.fbn13,m_fbn14,m_fbn15,   
                                          m_ratio,m_fbn17,g_fbn.fbn20,g_legal) #No:FUN-B60140 add g_legal #MOD-BC0131 add fbn20
                        IF STATUS THEN
                           LET g_show_msg[g_cnt2].faj02  = g_faj.faj02 
                           LET g_show_msg[g_cnt2].faj022 = g_faj.faj022
                           LET g_show_msg[g_cnt2].ze01   = ''
                           LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
                           LET g_cnt2 = g_cnt2 + 1
                           LET g_success='N'
                           CONTINUE FOREACH 
                        END IF
                     END IF
                  END FOREACH
                  IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF  
               END IF
             IF m_fad05 = '2' THEN
                IF m_tot_fbn07!=mm_fbn07 OR m_tot_curr!=m_curr OR 
                   m_tot_fbn14!=mm_fbn14 OR m_tot_fbn15!=mm_fbn15 THEN          
                   LET m_fae06 = m_max_fae06
                  SELECT fbn07,fbn08 INTO l_fbn07,l_fbn08 from fbn_file
                   WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                     AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
                     AND fbn05='3' 
                  LET l_diff = mm_fbn07 - m_tot_fbn07
                  IF l_diff < 0 THEN 
                     LET l_diff = l_diff * -1 
                     IF l_fbn07 < l_diff THEN
                        LET l_diff = 0
                     ELSE 
                        LET l_diff = l_diff * -1 
                     END IF
                  END IF 
                  IF cl_null(m_tot_curr) THEN
                     LET m_tot_curr=0 
                  END IF 
                  LET l_diff2 = mm_fbn08 - m_tot_curr  
                  IF l_diff2 < 0 THEN 
                     LET l_diff2 = l_diff2 * -1 
                     IF l_fbn08 < l_diff2 THEN
                        LET l_diff2 = 0 
                     ELSE 
                        LET l_diff2 = l_diff2 * -1
                     END IF
                  END IF 
                  UPDATE fbn_file SET fbn07=fbn07+l_diff,
                                      fbn08=fbn08+l_diff2,
                                      fbn14=fbn14+mm_fbn14-m_tot_fbn14,
                                      fbn15=fbn15+mm_fbn15-m_tot_fbn15,
                                      fbn17=fbn17+mm_fbn17-m_tot_fbn17, 
                                      fbn11= m_fad031,    
                                      fbn12= g_fae.fae07     
                   WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                     AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
                     AND fbn05='3' 
                  IF STATUS OR SQLCA.sqlerrd[3]=0  THEN
                       LET g_success='N' 
                       CALL cl_err3("upd","fbn_file",g_fbn.fbn01,g_fbn.fbn02,STATUS,"","upd fbn",1)   
                     EXIT FOREACH
                  END IF
               END IF
               LET m_tot_fbn07=0
               LET m_tot_fbn14=0
               LET m_tot_fbn15=0
               LET m_tot_fbn17=0        
               LET m_tot_curr =0
               LET m_tot=0
          END IF      
         END FOREACH
      END IF
      IF g_success = 'Y' THEN 
         LET l_flag ='Y' 
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END FOREACH    

   IF l_flag ='N' THEN
      CALL cl_getmsg("afa-204",g_lang) RETURNING l_msg
      LET g_show_msg[g_cnt2].faj02  = ' '
      LET g_show_msg[g_cnt2].faj022 = ' '
      LET g_show_msg[g_cnt2].ze01   = 'afa-204'
     LET g_show_msg[g_cnt2].ze03   = l_msg
   END IF
END FUNCTION
  #No:FUN-B60140
