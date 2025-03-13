# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: afap998.4gl
# Descriptions...: 固定資產期初轉檔作業(稅務)                    
# Date & Author..: 99/09/17 By Sophia
# Modify.........: No.MOD-480085 04/08/23 By Nicola 加入離開功能
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.MOD-920302 09/02/23 By Sarah fao17應預設為l_faj.faj103
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:MOD-BB0114 11/11/12 by johung 資產不提折舊時則不轉
# Modify.........: No:MOD-C30765 12/04/06 By Polly 若faj23='2'需再產生多部門分攤
# Modify.........: No:MOD-D30116 13/03/12 By Polly 調整update多部門折舊金額條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql       string,  #No.FUN-580092 HCN
        tm               RECORD
         wc             LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
         yy             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         mm             LIKE type_file.num5         #No.FUN-680070 SMALLINT
         END RECORD,
       b_date,e_date    LIKE type_file.dat,          #No.FUN-680070 DATE
       g_dc             LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_amt1,g_amt2    LIKE type_file.num20_6      #No.FUN-680070 DECIMAL(20,6)
DEFINE g_flag          LIKE type_file.chr1,                  #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
      g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
#--------------MOD-C30765--------------------(S)
 DEFINE m_tot            LIKE type_file.num20_6,
        m_tot_fao07      LIKE fao_file.fao07,
        m_tot_fao14      LIKE fao_file.fao14,
        m_tot_fao15      LIKE fao_file.fao15,
        m_tot_fao17      LIKE fao_file.fao17,
        m_tot_curr       LIKE type_file.num20_6,
        g_cnt,g_cnt2     LIKE type_file.num5,
        m_fad05          LIKE fad_file.fad05,
        m_fad031         LIKE fad_file.fad031,
        m_fae08,mm_fae08 LIKE fae_file.fae08,
        m_aao            LIKE type_file.num20_6,
        m_curr           LIKE type_file.num20_6,
        m_fao07          LIKE fao_file.fao07,
        m_fao08          LIKE fao_file.fao08,
        m_fao14          LIKE fao_file.fao14,
        m_fao15          LIKE fao_file.fao15,
        m_fao17          LIKE fao_file.fao17,
        mm_fao07         LIKE fao_file.fao07,
        mm_fao08         LIKE fao_file.fao08,
        mm_fao14         LIKE fao_file.fao14,
        mm_fao15         LIKE fao_file.fao15,
        mm_fao17         LIKE fao_file.fao17,
        m_ratio,mm_ratio LIKE type_file.num26_10,
        m_max_ratio      LIKE type_file.num26_10,
        m_max_fae06      LIKE fae_file.fae06,
        y_curr           LIKE fao_file.fao08,
        m_fae06          LIKE fae_file.fae06,
        l_fao07          LIKE fao_file.fao07,
        l_fao08          LIKE fao_file.fao08,
        l_diff,l_diff2   LIKE fao_file.fao07,
        g_show_msg       DYNAMIC ARRAY OF RECORD
                         faj02     LIKE faj_file.faj02,
                         faj022    LIKE faj_file.faj022,
                         ze01      LIKE ze_file.ze01,
                         ze03      LIKE ze_file.ze03
                        END RECORD,
       l_msg,l_msg2      STRING,
       lc_gaq03          LIKE gaq_file.gaq03
#--------------MOD-C30765--------------------(E)
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc  = ARG_VAL(1)
   LET tm.yy  = ARG_VAL(2)
   LET tm.mm  = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   IF g_bgjob ='N' THEN
      INITIALIZE tm.* TO NULL
   END IF

   SELECT faa07,faa08 INTO tm.yy,tm.mm FROM faa_file
   LET g_success = 'Y'
   WHILE TRUE
    IF g_bgjob = "N" THEN
      CALL p998()
      IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL g_show_msg.clear()              #MOD-C30765 add
         CALL p998_1()
        #--------------MOD-C30765--------------------(S)
         IF g_show_msg.getLength() > 0 THEN
            CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED 
            CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED 
            CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED 
            CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED 
            CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
            CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
            CONTINUE WHILE
         END IF
        #--------------MOD-C30765--------------------(E)
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag
         END IF
        IF g_flag THEN
           CONTINUE WHILE
        ELSE
           CLOSE WINDOW p998_w
           EXIT WHILE
        END IF
    ELSE
        CONTINUE WHILE
    END IF
  ELSE
    BEGIN WORK
    LET g_success = 'Y'
    CALL g_show_msg.clear()              #MOD-C30765 add
    CALL p998_1()
   #--------------MOD-C30765--------------------(S)       
    IF g_show_msg.getLength() > 0 THEN
       CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED 
       CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
       CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
       CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
       CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
       CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
    END IF
   #--------------MOD-C30765--------------------(E) 
    IF g_success = "Y" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_batch_bg_javamail(g_success)
    EXIT WHILE
   END IF
 END WHILE
#->No.FUN-570144 ---end---
 
 CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p998()
DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
  OPEN WINDOW p998_w WITH FORM "afa/42f/afap998"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_init()

  CALL cl_opmsg('z')
 
  #->No.FUN-570144 ---end---
 
   CLEAR FORM
 
   INITIALIZE tm.* TO NULL
   SELECT faa07,faa08 INTO tm.yy,tm.mm FROM faa_file
   DISPLAY tm.yy TO FORMONLY.yy 
   DISPLAY tm.mm TO FORMONLY.mm 
 
   WHILE TRUE
      CALL cl_opmsg('z')
      CONSTRUCT BY NAME tm.wc ON faj04,faj02,faj25
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          #CALL cl_dynamic_locale()
          #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE                   #->No.FUN-570144
          EXIT CONSTRUCT
 
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      #-----No.MOD-480085----- 
     ON ACTION exit
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     #-----END--------------- 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
#NO.FUN-570144 start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p998_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
#      IF INT_FLAG THEN
#         EXIT WHILE
#      END IF
#NO.FUN-570144 end---
 
      LET g_bgjob = 'N'  #NO.FUN-570144     
      #INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS 
      INPUT BY NAME tm.yy,tm.mm,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570144
   
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
      
         AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.mm) THEN
               NEXT FIELD mm 
            END IF
#No.TQC-720032 -- begin --
#            IF tm.mm < 1 OR tm.mm > 12 THEN
#               NEXT FIELD mm
#            END IF
#No.TQC-720032 -- end --
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
          #-----No.MOD-480085----- 
         ON ACTION exit
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         #-----END--------------- 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        #->No.FUN-570144 --start--
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
        #->No.FUN-570144 ---end---
 
      END INPUT
  #->No.FUN-570144 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin) #NO.FUN-570112 MARK
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p998_w  #NO.FUN-570144
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM         #NO.FUN-570144
#         RETURN
      END IF
#NO.FUN-570144 MARK---
#      IF NOT cl_sure(0,0) THEN
#         RETURN
#      END IF
#      CALL cl_wait()
#      CALL p998_1()
#      MESSAGE ''
#      CALL cl_end(0,0)
#      EXIT WHILE
#NO.FUN-570144 MARK---
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap998'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap998','9031',1)
     ELSE
        LET g_wc = cl_replace_str(g_wc,"'","\"")
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm.wc CLIPPED,"'",
                     " '",tm.yy CLIPPED,"'",
                     " '",tm.mm CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('afap998',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p998_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
 
  EXIT WHILE
END WHILE
#FUN-570144 ---end---
END FUNCTION
 
FUNCTION p998_1()
 DEFINE l_faj RECORD LIKE faj_file.*,
        l_fao RECORD LIKE fao_file.*, 
        l_sql LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
        i     LIKE type_file.num10,        #No.FUN-680070 INTEGER
        j     LIKE type_file.num10,        #No.FUN-680070 INTEGER
        l_var LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
#--------------MOD-C30765--------------------(S)
 DEFINE p_yy,p_mm LIKE type_file.num5,
        g_fao     RECORD LIKE fao_file.*,
        g_fae     RECORD LIKE fae_file.*,
        l_aag04   LIKE aag_file.aag04,
        p_fao08   LIKE fao_file.fao08,
        p_fao15   LIKE fao_file.fao15,
        l_cnt1    LIKE type_file.num5
#--------------MOD-C30765--------------------(E)
 
  LET l_sql ="SELECT * FROM faj_file",
             " WHERE ",tm.wc CLIPPED
  
  PREPARE p998_pre FROM l_sql
  DECLARE p998_cur CURSOR FOR p998_pre
 
  LET i = 0
  LET j = 0
  FOREACH p998_cur INTO l_faj.*
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('foreach',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
   #IF l_faj.faj28 ='0' THEN         #'0'.不提折舊
   #   CONTINUE FOREACH
   #END IF   
    #MOD-BB0114 -- begin --
    IF l_faj.faj61 = '0' THEN    #'0':不提折舊
       CONTINUE FOREACH
    END IF
    #MOD-BB0114 -- end --
    LET l_fao.fao01 = l_faj.faj02
    LET l_fao.fao02 = l_faj.faj022
    LET l_fao.fao03 = tm.yy
    LET l_fao.fao04 = tm.mm
    LET l_fao.fao041= '0'     #No:5790
    LET l_fao.fao05 = l_faj.faj23
    LET l_fao.fao06 = l_faj.faj20
    LET l_fao.fao07 = 0
    LET l_fao.fao08 = l_faj.faj205
    LET l_fao.fao11 = l_faj.faj53
    LET l_fao.fao12 = l_faj.faj55
    #No.FUN-680028 --begin
 #  IF g_aza.aza63 = 'Y' THEN   
    IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 
       LET l_fao.fao111 = l_faj.faj531
       LET l_fao.fao121 = l_faj.faj551
    END IF
    #No.FUN-680028 --end
    LET l_fao.fao13 = l_faj.faj24
    LET l_fao.fao14 = l_faj.faj62 + l_faj.faj63  - l_faj.faj69
    LET l_fao.fao15 = l_faj.faj67
    LET l_fao.fao16 = 0
    LET l_fao.fao17 = l_faj.faj103   #MOD-920302 add
    #CHI-790004..................begin
    IF cl_null(l_fao.fao06) THEN
       LET l_fao.fao06=' '
    END IF
    #CHI-790004..................end
 
    LET l_fao.faolegal = g_legal   #FUN-980003 add
 
    INSERT INTO fao_file VALUES (l_fao.*)
    IF g_bgjob = 'N' THEN  #NO.FUN-570144 
        MESSAGE l_faj.faj02,l_faj.faj022   
        CALL ui.Interface.refresh()
    END IF
   #str MOD-C30765 add                                                                         
    IF l_faj.faj23 = '2' THEN                                                                  
       #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------                       
       LET g_sql="SELECT * FROM fao_file WHERE fao03='",tm.yy,"'",                             
                 "                         AND fao04='",tm.mm,"'",                             
                 "                         AND fao05='2' AND fao041='0' ",                     
                 "                         AND fao01='",l_faj.faj02,"'",                       
                 "                         AND fao02='",l_faj.faj022,"'"     #MOD-C20187 add   
       PREPARE p998_pre1 FROM g_sql                                                            
       DECLARE p998_cur1 CURSOR WITH HOLD FOR p998_pre1                                        
       FOREACH p998_cur1 INTO g_fao.*                                                          
          IF STATUS THEN                                                                       
             LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                                       
             LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                                      
             LET g_show_msg[g_cnt2].ze01   = ''                                                
             LET g_show_msg[g_cnt2].ze03   = 'foreach p998_cur1'                               
             LET g_cnt2 = g_cnt2 + 1                                                           
             LET g_success='N'                                                                 
             CONTINUE FOREACH                                                                  
          END IF                                                                               
          #-->讀取分攤方式                                                                     
          SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file                               
           WHERE fad01=g_fao.fao03 AND fad02=g_fao.fao04                                       
             AND fad03=g_fao.fao11 AND fad04=g_fao.fao13                                       
             AND fad07="1"                                                                     
          IF SQLCA.sqlcode THEN                                                                
             CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg                                  
             LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                                       
             LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                                      
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
                AND fae10="1"                                                                  
             IF SQLCA.sqlcode OR cl_null(m_fae08) THEN                                         
                CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg                               
                LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                                    
                LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                                   
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
          DECLARE p998_cur2 CURSOR WITH HOLD FOR                                               
          SELECT * FROM fae_file                                                               
           WHERE fae01=g_fao.fao03 
             AND fae02=g_fao.fao04                                       
             AND fae03=g_fao.fao11 
             AND fae04=g_fao.fao13                                       
             AND fae10="1"                                                                     
          FOREACH p998_cur2 INTO g_fae.*                                                       
             IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN                       
                CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg                               
                LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                                    
                LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                                   
                LET g_show_msg[g_cnt2].ze01   = 'afa-152'                                      
                LET g_show_msg[g_cnt2].ze03   = l_msg                                          
                LET g_cnt2 = g_cnt2 + 1                                                        
                LET g_success='N'                                                              
                CONTINUE FOREACH                                                               
             END IF                                                                            
             CASE m_fad05                                                                      
                WHEN '1'                                                                       
                   LET l_cnt1 = 0                                                              
                   SELECT COUNT(*) INTO l_cnt1 FROM fao_file                                   
                    WHERE fao01 = g_fao.fao01 
                      AND fao02 = g_fao.fao02                              
                      AND fao03 = g_fao.fao03 
                      AND fao04 = g_fao.fao04                              
                      AND fao06 = g_fae.fae06 
                      AND fao05='3'                                      
                      AND (fao041 = '1' OR fao041='0')                                         
                   LET mm_ratio = g_fae.fae08/mm_fae08*100     # 分攤比率(存入fao16用)           
                   LET m_ratio = g_fae.fae08/m_fae08*100       # 分攤比率                        
                   LET m_fao07 = mm_fao07*m_ratio/100          # 分攤金額                        
                   LET m_curr  = mm_fao08*m_ratio/100          # 分攤金額                        
                   LET m_fao14 = mm_fao14*m_ratio/100          # 分攤成本                        
                   LET m_fao15 = mm_fao15*m_ratio/100          # 分攤累折                        
                   LET m_fao17 = mm_fao17*m_ratio/100          # 分攤減值                        
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
                   IF l_cnt1 > 0 THEN                                                          
                      UPDATE fao_file SET fao07 = m_fao07,                                     
                                          fao08 = m_curr,                                      
                                          fao09 = g_fao.fao06,                                 
                                          fao12 = g_fae.fae07,                                 
                                          fao14 = m_fao14,                                     
                                          fao15 = m_fao15,                                     
                                          fao16 = mm_ratio,                                    
                                          fao17 = m_fao17                                      
                       WHERE fao01 = g_fao.fao01 
                         AND fao02 = g_fao.fao02                       
                         AND fao03 = g_fao.fao03 
                         AND fao04 = g_fao.fao04                       
                        #AND fao05 = g_fao.fao05              #MOD-D30116 mark
                         AND fao05 = '3'                      #MOD-D30116 add
                        #AND fao06 = g_fao.fao06              #MOD-D30116 mark           
                         AND fao06 = g_fae.fae06              #MOD-D30116 add
                        #AND fao041= g_fao.fao041             #MOD-D30116 mark                                  
                         AND (fao041 = '1' OR fao041 = '0')   #MOD-D30116 add
                      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN                                     
                         LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                           
                         LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                          
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
                      LET m_curr = cl_digcut(m_curr,g_azi04)                                   
                      INSERT INTO fao_file(fao01,fao02,fao03,fao04,fao041,                     
                                           fao05,fao06,fao07,fao08,fao09,                      
                                           fao10,fao11,fao12,fao13,fao14,                      
                                           fao15,fao16,fao17,fao20,fao201,                     
                                           faolegal)                                           
                                    VALUES(g_fao.fao01,g_fao.fao02,                            
                                           g_fao.fao03,g_fao.fao04,'0','3',                    
                                           g_fae.fae06,m_fao07,m_curr,                         
                                           g_fao.fao06,l_faj.faj43,g_fao.fao11,                
                                           g_fae.fae07,g_fao.fao13,m_fao14,                    
                                           m_fao15,mm_ratio,m_fao17,                           
                                           g_fao.fao20,g_fao.fao201,                           
                                           g_legal)                                            
                      IF STATUS THEN                                                           
                         LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                           
                         LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                          
                         LET g_show_msg[g_cnt2].ze01   = ''                                    
                         LET g_show_msg[g_cnt2].ze03   = 'ins fao_file'                        
                         LET g_cnt2 = g_cnt2 + 1                                               
                         LET g_success='N'                                                     
                         CONTINUE FOREACH                                                      
                      END IF                                                                   
                   END IF                                                                      
                WHEN '2'                                                                       
                   LET l_aag04 = ''                                                            
                   SELECT aag04 INTO l_aag04 FROM aag_file                                     
                    WHERE aag01=g_fae.fae09 AND aag00=g_bookno1                                
                   IF l_aag04='1' THEN                                                         
                      SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file                         
                       WHERE aao00 = m_faa02b    
                         AND aao01 = g_fae.fae09                          
                         AND aao02 = g_fae.fae06 
                         AND aao03 = tm.yy                                
                         AND aao04 <= tm.mm                                                      
                   ELSE                                                                        
                      SELECT aao05-aao06 INTO m_aao FROM aao_file                              
                       WHERE aao00 = m_faa02b    
                         AND aao01 = g_fae.fae09                           
                         AND aao02 = g_fae.fae06 
                         AND aao03 = tm.yy                                 
                         AND aao04 = tm.mm                                                       
                   END IF                                                                      
                   IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF                      
                   LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額                      
             END CASE                                                                          
          END FOREACH                                                                          
                                                                                               
          #----- 若為變動比率, 重新 foreach 一次 insert into fao_file -----------              
          IF m_fad05='2' THEN                                                                  
             LET m_max_ratio = 0                                                               
             LET m_max_fae06 = ''                                                               
             FOREACH p998_cur2 INTO g_fae.*                                                    
                LET l_aag04 = ''                                                               
                SELECT aag04 INTO l_aag04 FROM aag_file                                        
                 WHERE aag01=g_fae.fae09 AND aag00=g_bookno1                                   
                IF l_aag04='1' THEN                                                            
                   SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file                            
                    WHERE aao00 = m_faa02b 
                      AND aao01 = g_fae.fae09                                 
                      AND aao02 = g_fae.fae06 
                      AND aao03 = tm.yy 
                      AND aao04 <= tm.mm                   
                ELSE                                                                           
                   SELECT aao05-aao06 INTO m_aao FROM aao_file                                 
                    WHERE aao00 = m_faa02b 
                      AND aao01 = g_fae.fae09                                 
                      AND aao02 = g_fae.fae06 
                      AND aao03 = tm.yy 
                      AND aao04 = tm.mm                    
                END IF                                                                         
                IF STATUS=100 OR m_aao IS NULL THEN                                            
                   LET m_aao=0                                                                 
                END IF                                                                         
                SELECT SUM(fao07) INTO y_curr FROM fao_file                                    
                 WHERE fao01 = g_fao.fao01 
                   AND fao02 = g_fao.fao02                                 
                   AND fao03 = tm.yy       
                   AND fao04 < tm.mm                                       
                   AND fao06 = g_fae.fae06 
                   AND fao05 = '3'                                         
                IF cl_null(y_curr) THEN LET y_curr = 0 END IF                                  
                LET m_ratio = m_aao/m_tot*100                                                  
                IF m_ratio > m_max_ratio THEN                                                  
                   LET m_max_fae06 = g_fae.fae06                                               
                   LET m_max_ratio = m_ratio                                                   
                END IF                                                                         
                LET m_fao07 = g_fao.fao07*m_ratio/100                                            
                LET m_curr = y_curr + m_fao07                                                  
                LET m_fao14 = g_fao.fao14*m_ratio/100                                            
                LET m_fao15 = g_fao.fao15*m_ratio/100                                            
                LET m_fao17 = g_fao.fao17*m_ratio/100                                            
                LET m_fao07 = cl_digcut(m_fao07,g_azi04)                                       
                LET m_curr = cl_digcut(m_curr,g_azi04)                                         
                LET m_fao14 = cl_digcut(m_fao14,g_azi04)                                       
                LET m_fao15 = cl_digcut(m_fao15,g_azi04)                                       
                LET m_fao17 = cl_digcut(m_fao17,g_azi04)                                       
                LET m_tot_fao07 = m_tot_fao07+m_fao07                                            
                LET m_tot_curr = m_tot_curr +m_curr                                             
                LET m_tot_fao14 = m_tot_fao14+m_fao14                                            
                LET m_tot_fao15 = m_tot_fao15+m_fao15                                            
                LET m_tot_fao17 = m_tot_fao17+m_fao17                                            
                SELECT COUNT(*) INTO g_cnt FROM fao_file                                       
                 WHERE fao01 = g_fao.fao01 
                   AND fao02 = g_fao.fao02                                 
                   AND fao03 = g_fao.fao03 
                   AND fao04 = g_fao.fao04                                 
                   AND fao06 = g_fae.fae06 
                   AND fao05 = '3' 
                   AND fao041 = '0'                          
                IF g_cnt>0 THEN                                                                
                   UPDATE fao_file SET fao07 = m_fao07,                                        
                                       fao08 = m_curr,                                         
                                       fao09 = g_fao.fao06,                                    
                                       fao12 = g_fae.fae07,                                    
                                       fao16 = m_ratio,                                        
                                       fao17 = m_fao17                                         
                    WHERE fao01 = g_fao.fao01 
                      AND fao02 = g_fao.fao02                              
                      AND fao03 = g_fao.fao03 
                      AND fao04 = g_fao.fao04                              
                      AND fao06 = g_fae.fae06 
                      AND fao05 = '3' 
                      AND fao041 = '0'                       
                   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN                                      
                      LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                              
                      LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                             
                      LET g_show_msg[g_cnt2].ze01   = ''                                       
                      LET g_show_msg[g_cnt2].ze03   = 'upd fao_file'                           
                      LET g_cnt2 = g_cnt2 + 1                                                  
                      LET g_success = 'N'                                                        
                      CONTINUE FOREACH                                                         
                   END IF                                                                      
                ELSE                                                                           
                   IF cl_null(g_fae.fae06) THEN                                                
                      LET g_fae.fae06 = ' '                                                      
                   END IF                                                                      
                   LET m_curr = cl_digcut(m_curr,g_azi04)                                      
                   INSERT INTO fao_file(fao01,fao02,fao03,fao04,fao041,fao05,                  
                                        fao06,fao07,fao08,fao09,fao10,fao11,                   
                                        fao12,fao13,fao14,fao15,fao16,fao17,                   
                                        fao20,fao201,faolegal)                                 
                              VALUES(g_fao.fao01,g_fao.fao02,g_fao.fao03,                      
                                     g_fao.fao04,'0','3',g_fae.fae06,m_fao07,                  
                                     m_curr,g_fao.fao06,l_faj.faj43,g_fao.fao11,               
                                     g_fae.fae07,g_fao.fao13,m_fao14,m_fao15,                  
                                     m_ratio,m_fao17,g_fao.fao20,g_fao.fao201,                 
                                     g_legal)                                                  
                   IF STATUS THEN                                                              
                      LET g_show_msg[g_cnt2].faj02  = l_faj.faj02                              
                      LET g_show_msg[g_cnt2].faj022 = l_faj.faj022                             
                      LET g_show_msg[g_cnt2].ze01   = ''                                       
                      LET g_show_msg[g_cnt2].ze03   = 'ins fao_file'                           
                      LET g_cnt2 = g_cnt2 + 1                                                  
                      LET g_success='N'                                                        
                      CONTINUE FOREACH                                                         
                   END IF                                                                      
                END IF                                                                         
             END FOREACH                                                                       
             IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF                   
          END IF                                                                               
          IF m_fad05 = '2' THEN                                                                
             IF m_tot_fao07!=mm_fao07 OR m_tot_curr!=m_curr OR                                 
                m_tot_fao14!=mm_fao14 OR m_tot_fao15!=mm_fao15 THEN                            
                LET m_fae06 = m_max_fae06                                                      
                SELECT fao07,fao08 INTO l_fao07,l_fao08 from fao_file                          
                 WHERE fao01 = g_fao.fao01 
                   AND fao02 = g_fao.fao02                                 
                   AND fao03 = tm.yy 
                   AND fao04 = tm.mm 
                   AND fao06 = m_fae06                           
                   AND fao05 = '3'                                                               
                LET l_diff = mm_fao07 - m_tot_fao07                                            
                IF l_diff < 0 THEN                                                             
                   LET l_diff = l_diff * -1                                                    
                   IF l_fao07 < l_diff THEN                                                    
                      LET l_diff = 0                                                           
                   ELSE                                                                        
                      LET l_diff = l_diff * -1                                                 
                   END IF                                                                      
                END IF                                                                         
                IF cl_null(m_tot_curr) THEN                                                    
                   LET m_tot_curr=0                                                            
                END IF                                                                         
                LET l_diff2 = mm_fao08 - m_tot_curr                                            
                IF l_diff2 < 0 THEN                                                            
                   LET l_diff2 = l_diff2 * -1                                                  
                   IF l_fao08 < l_diff2 THEN                                                   
                      LET l_diff2 = 0                                                          
                   ELSE                                                                        
                      LET l_diff2 = l_diff2 * -1                                               
                   END IF                                                                      
                END IF                                                                          
                UPDATE fao_file SET fao07 = fao07+l_diff,                                        
                                    fao08 = fao08+l_diff2,                                       
                                    fao14 = fao14+mm_fao14-m_tot_fao14,                          
                                    fao15 = fao15+mm_fao15-m_tot_fao15,                          
                                    fao17 = fao17+mm_fao17-m_tot_fao17                           
                 WHERE fao01=g_fao.fao01 AND fao02=g_fao.fao02                                 
                   AND fao03=tm.yy AND fao04=tm.mm AND fao06=m_fae06                           
                   AND fao05='3'                                                               
                IF STATUS OR SQLCA.sqlerrd[3]=0  THEN                                          
                   LET g_success='N'                                                           
                   CALL cl_err3("upd","fao_file",g_fao.fao01,g_fao.fao02,STATUS,"","upd fao",1)
                   EXIT FOREACH                                                                
                END IF                                                                         
             END IF                                                                            
             LET m_tot_fao07 = 0                                                                 
             LET m_tot_fao14 = 0                                                                 
             LET m_tot_fao15 = 0                                                                 
             LET m_tot_fao17 = 0                                                                 
             LET m_tot_curr = 0                                                                 
             LET m_tot = 0                                                                       
          END IF                                                                               
       END FOREACH                                                                             
    END IF                                                                                     
   #end MOD-C30765 add                                                                         
  END FOREACH
END FUNCTION
