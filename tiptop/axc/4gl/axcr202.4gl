# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcr202.4gl
# Descriptions...: 投入工時核對明細表
# Date & Author..: 06/02/27 By Sarah
# Modify.........: No.FUN-620066 06/02/27 by Sarah 新增"投入工時核對明細表"
# Modify.........: NO.TQC-630258 06/03/31 BY yiting 合計錯誤
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-780017 07/08/03 By dxfwo CR報表的制作
# Modify.........: No.MOD-920202 09/02/16 By Pengu 抓工時時會抓工單的全部工時，應加上日期條件
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C80041 13/01/03 By bart 1.增加作廢功能 2.刪除單頭
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
            wc         LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)  # Where condition
            yy,mm      LIKE type_file.num5,          #No.FUN-680122SMALLINT
            more       LIKE type_file.chr1           #No.FUN-680122CHAR(1)    # Input more condition(Y/N)
           END RECORD
DEFINE bdate           LIKE type_file.dat            #No.FUN-680122DATE 
DEFINE edate           LIKE type_file.dat            #No.FUN-680122DATE 
DEFINE g_sql           STRING  #No.FUN-580092 HCN
 
DEFINE g_chr           LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE g_i             LIKE type_file.num5           #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000        #No.FUN-680122CHAR(72)
DEFINE l_table              STRING                   #No.FUN-780017                                                                    
DEFINE g_str                STRING                   #No.FUN-780017 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_lang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(11)           #No.FUN-570264
   LET g_template = ARG_VAL(12)           #No.FUN-570264
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-580121 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
#No.FUN-780017---Begin                                                                                                              
   LET g_sql = " srk01.srk_file.srk01,",
               " srk02.srk_file.srk02,",
               " srl04.srl_file.srl04,",
               " l_ima02.ima_file.ima02,",
               " l_ima021.ima_file.ima021,",
               " qty1.oeb_file.oeb13 ,",
               " qty2.oeb_file.oeb13 ,",
               " qty3.oeb_file.oeb13 ,",
               " qty4.oeb_file.oeb13, ",                                                                                                                                                                                            
               " l_gem02.gem_file.gem02 "
   LET l_table = cl_prt_temptable('axcr202',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
               " VALUES(?,?,?,?,?,?,?,?,?,?)"                                                   
   PREPARE insert_prep FROM g_sql                                                                                           
   IF STATUS THEN                                                                                                           
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                     
   END IF                                                                                                                   
#No.FUN-780017---End
 
   #No.FUN-580121 --start--
   IF cl_null(g_bgjob) OR g_bgjob = "N" THEN
      CALL r202_tm(0,0)        # Input print condition
   ELSE
      CALL r202()
   END IF
   #No.FUN-580121 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r202_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE 
      LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW r202_w AT p_row,p_col
        WITH FORM "axc/42f/axcr202" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
 
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   CALL s_yp(g_today) RETURNING tm.yy,tm.mm  #FUN-570240
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-580121 ---end---
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON srk02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
             #CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
             LET g_action_choice = "locale"
             EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION CONTROLP                                                      
            IF INFIELD(srk02) THEN    #成本中心                                          
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO srk02
               NEXT FIELD srk02      
            END IF                                                              
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('srkuser', 'srkgrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r202_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF tm.yy IS NULL THEN NEXT FIELD yy END IF
 
         AFTER FIELD mm
          #FUN-570240  --begin
          # IF tm.mm IS NULL THEN NEXT FIELD mm END IF
            IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN
               NEXT FIELD mm
            END IF
          #FUN-570240  --end
            CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
################################################################################
# START genero shell script ADD
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
     
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
     
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
     
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r202_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='axcr202'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcr202','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.yy CLIPPED,"'",
                            " '",tm.mm CLIPPED,"'"
            CALL cl_cmdat('axcr202',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r202_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r202()
      ERROR ""
   END WHILE
   CLOSE WINDOW r202_w
END FUNCTION
 
FUNCTION r202()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)      # External(Disk) file name 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          sr        RECORD 
                     srk01   LIKE srk_file.srk01,  #日期
                     srk02   LIKE srk_file.srk02,  #成本中心
                     srl04   LIKE srl_file.srl04,  #產品編號
                     qty1    LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)           #報工工時
                     qty2    LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)           #成本投入工時
                     qty3    LIKE oeb_file.oeb13,         #No.FUN-680122 DEC(20,6)           #差異工時
                     qty4    LIKE oeb_file.oeb13          #No.FUN-680122 DEC(20,6)            #入庫數
                    END RECORD
   DEFINE l_msg     STRING
   DEFINE l_ima02   LIKE ima_file.ima02            #品名
   DEFINE l_gem02   LIKE gem_file.gem02            #成本中心名稱
   DEFINE l_ima021  LIKE ima_file.ima021           #規格
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#  CALL cl_outnam('axcr202') RETURNING l_name         #No.FUN-780017
#  START REPORT r202_rep TO l_name                    #No.FUN-780017
   CALL cl_del_data(l_table)                          #No.FUN-780017
   LET g_pageno = 0
   #組SQL抓資料
   LET l_sql = "SELECT srk01,srk02,srl04,SUM(srl05),0,0,SUM(srl06)",
               "  FROM srk_file,srl_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND srk01=srl01 AND srk02=srl02 ",
               "   AND YEAR(srk01) =",tm.yy CLIPPED,
               "   AND MONTH(srk01)=",tm.mm CLIPPED,
               "   AND srkfirm <> 'X' ",  #CHI-C80041
               " GROUP BY srk01,srk02,srl04 ",
               " ORDER BY srk01,srk02,srl04 "
 
   PREPARE r202_prepare1 FROM l_sql
   DECLARE r202_curs1 CURSOR FOR r202_prepare1
   FOREACH r202_curs1 INTO sr.*
      IF STATUS THEN 
        CALL cl_err('foreach1:',STATUS,1)    
         EXIT FOREACH 
      END IF
#NO.TQC-630258 start--
      #抓成本投入工時
      SELECT SUM(srg10)/60 INTO sr.qty2
        FROM srf_file,srg_file,eci_file,eca_file
       WHERE srf01=srg01 AND srfconf='Y' AND srf03=eci01 AND eca01=eci03
         AND eca03=sr.srk02 AND srg03=sr.srl04
         AND srf02= sr.srk01       #No.MOD-920202
      IF cl_null(sr.qty2) THEN LET sr.qty2 = 0 END IF
      #計算差異工時
      LET sr.qty3 = sr.qty2 - sr.qty1
#NO.TQC-630258 end--
#     OUTPUT TO REPORT r202_rep(sr.*)             #No.FUN-780017
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.srk02                                                                  
      IF cl_null(l_gem02) THEN LET l_gem02='' END IF                                                                                
      LET l_msg = sr.srk02 CLIPPED,' ',l_gem02 CLIPPED 
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                                                                       
       WHERE ima01=sr.srl04                                                                                                         
      IF cl_null(l_ima02)  THEN LET l_ima02=''  END IF                                                                              
      IF cl_null(l_ima021) THEN LET l_ima021='' END IF
#No.FUN-780017---Begin
      EXECUTE insert_prep USING sr.srk01,sr.srk02,sr.srl04,l_ima02,l_ima021,sr.qty1,
      sr.qty2,sr.qty3,sr.qty4,l_gem02 
   END FOREACH
   
#  FINISH REPORT r202_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'srk02')         
           RETURNING tm.wc                                                     
   END IF
   LET g_str = tm.wc,";",tm.yy,";",tm.mm,";",g_ccz.ccz27
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   
   CALL cl_prt_cs3('axcr202','axcr202',l_sql,g_str)
#No.FUN-780017---end
END FUNCTION
{                            #No.FUN-780017
REPORT r202_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   DEFINE sr        RECORD 
                     srk01   LIKE srk_file.srk01,  #日期
                     srk02   LIKE srk_file.srk02,  #成本中心
                     srl04   LIKE srl_file.srl04,  #產品編號
                     qty1    LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)            #報工工時
                     qty2    LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)            #成本投入工時
                     qty3    LIKE oeb_file.oeb13,         #No.FUN-680122DEC(20,6)            #差異工時
                     qty4    LIKE oeb_file.oeb13          #No.FUN-680122DEC(20,6)             #入庫數
                    END RECORD
   DEFINE l_gem02   LIKE gem_file.gem02            #成本中心名稱
   DEFINE l_msg     STRING
   DEFINE l_ima02   LIKE ima_file.ima02            #品名
   DEFINE l_ima021  LIKE ima_file.ima021           #規格
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.srk01,sr.srk02,sr.srl04
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      LET g_msg=g_x[10] CLIPPED,tm.yy USING '&&&&','/',
                                tm.mm USING '&&',' ',g_msg CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_msg))/2)+1,g_msg
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.srk01
      PRINT COLUMN g_c[31],sr.srk01 CLIPPED;
 
   BEFORE GROUP OF sr.srk02
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.srk02 
      IF cl_null(l_gem02) THEN LET l_gem02='' END IF
      LET l_msg = sr.srk02 CLIPPED,' ',l_gem02 CLIPPED 
      PRINT COLUMN g_c[32],l_msg CLIPPED;
 
   ON EVERY ROW
      #抓品名、規格
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
       WHERE ima01=sr.srl04 
      IF cl_null(l_ima02)  THEN LET l_ima02=''  END IF
      IF cl_null(l_ima021) THEN LET l_ima021='' END IF
#NO.TQC-630258 MARK
#      #抓成本投入工時
#      SELECT SUM(srg10)/60 INTO sr.qty2
#        FROM srf_file,srg_file,eci_file,eca_file
#       WHERE srf01=srg01 AND srfconf='Y' AND srf03=eci01 AND eca01=eci03
#         AND eca03=sr.srk02 AND srg03=sr.srl04
#      IF cl_null(sr.qty2) THEN LET sr.qty2 = 0 END IF
#      #計算差異工時
#      LET sr.qty3 = sr.qty2 - sr.qty1
#NO.TQC-630258 MARK
      PRINT COLUMN g_c[33],sr.srl04 CLIPPED,
            COLUMN g_c[34],l_ima02 CLIPPED,
            COLUMN g_c[35],l_ima021 CLIPPED, 
            COLUMN g_c[36],cl_numfor(sr.qty1,36,3),
            COLUMN g_c[37],cl_numfor(sr.qty2,37,3),
            COLUMN g_c[38],cl_numfor(sr.qty3,38,3),
            COLUMN g_c[39],cl_numfor(sr.qty4,39,g_ccz.ccz27)  #CHI-690007 0->ccz27
 
   AFTER GROUP OF sr.srk01
      PRINT COLUMN g_c[35],g_x[12] CLIPPED,   #合計:
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.qty1),36,3),
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.qty2),37,3),
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty3),38,3),
            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.qty4),39,g_ccz.ccz27)  #CHI-690007 0->ccz27
      PRINT
 
   AFTER GROUP OF sr.srk02
      PRINT COLUMN g_c[35],g_x[11] CLIPPED,   #小計:
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.qty1),36,3),
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.qty2),37,3),
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.qty3),38,3),
            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.qty4),39,g_ccz.ccz27)  #CHI-690007 0->ccz27
 
   ON LAST ROW
      PRINT g_dash2
      PRINT COLUMN g_c[35],g_x[13] CLIPPED,   #總計:
            COLUMN g_c[36],cl_numfor(SUM(sr.qty1),36,3),
            COLUMN g_c[37],cl_numfor(SUM(sr.qty2),37,3),
            COLUMN g_c[38],cl_numfor(SUM(sr.qty3),38,3),
            COLUMN g_c[39],cl_numfor(SUM(sr.qty4),39,g_ccz.ccz27)  #CHI-690007 0->ccz27
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'n' THEN
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE 
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT               }            #No.FUN-780017
 
