# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimr880.4gl
# Descriptions...: 盤點過帳執行前檢查/錯誤訊息表
# Input parameter: 
# Return code....: 
# Modify.........: No:8990 By Melody 1.delete pif_file 資料 2.pia08/pia10應判斷 is null情況
# Modify.........: No:9031 By Melody 錯誤訊息與條件式判斷不符
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-510017 05/01/12 By Mandy 報表轉XML
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大&報表抓不到zaa
# Modify.........: No.MOD-560076 05/07/13 By pengu r880_check()函數內的訊息，改CALLcl_getmsg(p_ze code number,g_lang)
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
#
#
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: NO.FUN-750093 07/05/25 BY xiaofeizhu 制作水晶報表
# Modify.........: No.FUN-870051 08/07/26 By sherry 增加被替代料為Key值
# Modify.........: NO.MOD-910029 09/01/05 BY claire aim-869 的錯誤只判斷pie03=null,因為 pie03= ' ' 預設值
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: NO:MOD-AC0390 10/12/29 BY sabrina 修改aim-879的判斷
# Modify.........: NO:MOD-BC0186 11/12/16 By ck2yuan 修改cs1 sql語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD                        # Print condition RECORD
              check   LIKE type_file.chr1,  # 是否檢查  #No.FUN-690026 VARCHAR(1)
              more    LIKE type_file.chr1   # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
              END RECORD,
       g_pif  RECORD LIKE pif_file.*
DEFINE g_i    LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   LET g_pdate  = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.check = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r880_tm(0,0)        # Input print condition
      ELSE CALL r880()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r880_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 8 LET p_col = 30 
   ELSE
       LET p_row = 6 LET p_col = 12
   END IF
 
   OPEN WINDOW r880_w AT p_row,p_col
        WITH FORM "aim/42f/aimr880" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.check= 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   INPUT BY NAME tm.check,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD check 
         IF cl_null(tm.check) OR tm.check NOT MATCHES "[YN]"
            THEN NEXT FIELD check
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
     
      AFTER INPUT 
         IF cl_null(tm.check) THEN LET tm.check = '0' END IF
         IF INT_FLAG THEN
            LET INT_FLAG = 0 CLOSE WINDOW r880_w 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
            EXIT PROGRAM
               
         ELSE 
              IF tm.check ='Y' THEN 
                 CALL cl_wait()
                 #No:8990
                 DELETE FROM pif_file WHERE 1=1
                 CALL r880_check()
                 ERROR ""
              END IF
         END IF
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r880_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='r880'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr880','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.check CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('r880',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r880_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r880()
   ERROR ""
END WHILE
   CLOSE WINDOW r880_w
END FUNCTION
 
FUNCTION r880()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          sr        RECORD 
                           pif01   LIKE pif_file.pif01,
                           pif02   LIKE pif_file.pif02,
                           pif03   LIKE pif_file.pif03 
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT DISTINCT pif01, pif02, pif03,ima02,ima021 ",
                 #"  FROM ima_file LEFT OUTER JOIN pif_file ON(ima01 = pif02)",   #MOD-BC0186 mark
                 "  FROM pif_file LEFT OUTER JOIN ima_file ON(ima01 = pif02)",    #MOD-BC0186 add
                 "  ORDER BY pif01"
 
     CALL cl_prt_cs1('aimr880','aimr880',l_sql,'')   # FUN-750093
    
#    FUN-750093
    { PREPARE r880_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r880_curs1 CURSOR FOR r880_prepare1
     CALL cl_outnam('aimr880') RETURNING l_name   #No.FUN-550029
     START REPORT r880_rep TO l_name
 
     FOREACH r880_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       OUTPUT TO REPORT r880_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r880_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)}  # FUN-750093
END FUNCTION
 
# FUN-750093
{REPORT r880_rep(sr)
   DEFINE l_ima02       LIKE ima_file.ima02     #FUN-510017
   DEFINE l_ima021      LIKE ima_file.ima021    #FUN-510017
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr            RECORD 
                            pif01   LIKE pif_file.pif01, 
                            pif02   LIKE pif_file.pif02, 
                            pif03   LIKE pif_file.pif03
                        END RECORD,
          l_trailer_sw  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_chr         LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pif01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
      PRINT 
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1 
      LET l_trailer_sw = 'y'
 
 ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021
        FROM ima_file
       WHERE ima01 = sr.pif02
      IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
      END IF
    PRINT COLUMN g_c[31],sr.pif01,
          COLUMN g_c[32],sr.pif02,
          COLUMN g_c[33],l_ima02,
          COLUMN g_c[34],l_ima021,
          COLUMN g_c[35],sr.pif03
 
 ON LAST ROW
     PRINT g_dash
     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
     LET l_trailer_sw = 'n'
 
 PAGE TRAILER
     IF l_trailer_sw = 'y' THEN
        PRINT g_dash
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C000
     ELSE
        SKIP 2 LINE
     END IF
END REPORT} 
                         # FUN-750093 
   
FUNCTION r880_check()
  DEFINE l_sql      LIKE type_file.chr1000,   #No.FUN-690026 VARCHAR(1000)
         l_str      LIKE type_file.chr1000,   #No.MOD-560076  #No.FUN-690026 VARCHAR(255)
         l_pid01    LIKE pid_file.pid01,
         l_pid02    LIKE pid_file.pid02,
         l_pid13    LIKE pid_file.pid13,
         l_pid14    LIKE pid_file.pid14,
         l_pid15    LIKE pid_file.pid15,
         l_pid17    LIKE pid_file.pid17,
         l_sfb09    LIKE sfb_file.sfb09,
         l_sfb10    LIKE sfb_file.sfb10,
         l_sfb11    LIKE sfb_file.sfb11,
         l_sfb12    LIKE sfb_file.sfb12,
         l_sfa05    LIKE sfa_file.sfa05,
         l_sfa06    LIKE sfa_file.sfa06,
         l_sfa062   LIKE sfa_file.sfa062,
         l_sfa161   LIKE sfa_file.sfa161,
         l_sfa063   LIKE sfa_file.sfa063,
         l_pia      RECORD 
                    pia01  LIKE pia_file.pia01, 
                    pia02  LIKE pia_file.pia02, 
                    pia03  LIKE pia_file.pia03, 
                    pia08  LIKE pia_file.pia08, 
                    pia30  LIKE pia_file.pia30, 
                    pia50  LIKE pia_file.pia50, 
                    pia10  LIKE pia_file.pia10
                    END RECORD,
         l_pie      RECORD 
                    pie01  LIKE pie_file.pie01, 
                    pie02  LIKE pie_file.pie02, 
                    pie03  LIKE pie_file.pie03, 
                    pie04  LIKE pie_file.pie04, 
                    pie11  LIKE pie_file.pie11, 
                    pie12  LIKE pie_file.pie12, 
                    pie13  LIKE pie_file.pie13, 
                    pie14  LIKE pie_file.pie14, 
                    pie15  LIKE pie_file.pie15, 
                    pie30  LIKE pie_file.pie30, 
                    pie50  LIKE pie_file.pie50,
                    pie152 LIKE pie_file.pie152,
                    pie900 LIKE pie_file.pie900,    #No.FUN-870051
                    pie012 LIKE pie_file.pie012,    #No.FUN-A60027
                    pie013 LIKE pie_file.pie013,    #No.FUN-A60027 
                    pid02  LIKE pid_file.pid02
                    END RECORD
 
     #---->現有庫存檢查
     LET l_sql = "SELECT pia01,pia02,pia03,pia08,pia30,pia50,pia10",
                 "  FROM pia_file ",
                 "  WHERE pia02 IS NOT NULL"
     PREPARE r880_prestk   FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r880_cstk CURSOR FOR r880_prestk
 
     #---->在製工單檢查
     LET l_sql = "SELECT pie01,pie02,pie03,pie04,",
                 " pie11,pie12,pie13,pie14,pie15,",
                 " pie30,pie50,pie152,pie900,pie012,pie013,pid02 ",  #No.FUN-870051 add pie900  #FUN-A60027 add pie012 pie013
                 "  FROM pid_file,pie_file ",
                 "  WHERE pie02 IS NOT NULL",
                 "    AND pie01 = pid01 "
       
     PREPARE r880_prewip   FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE r880_cwip CURSOR FOR r880_prewip
 
     FOREACH r880_cstk INTO l_pia.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF l_pia.pia02 IS NULL OR l_pia.pia02 = ' ' THEN
           #LET l_str = '此標籤無料件編號'                     #No.MOD-560076
           CALL cl_getmsg('aim-860',g_lang) RETURNING l_str    #No.MOD-560076
           INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
               VALUES(l_pia.pia01,l_pia.pia02,l_str,g_plant,g_legal) #No.FUN-980004
       END IF
       IF l_pia.pia03 IS NULL OR l_pia.pia03 = ' ' THEN
           #LET l_str = '此標籤無倉庫編號'                     #No.MOD-560076
           CALL cl_getmsg('aim-877',g_lang) RETURNING l_str    #No.MOD-560076
           INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
               VALUES(l_pia.pia01,l_pia.pia02,l_str,g_plant,g_legal) #No.FUN-980004
       END IF
       IF (l_pia.pia30 IS NULL OR l_pia.pia30 = ' ')
          AND (l_pia.pia50 IS NULL OR l_pia.pia50 = ' ') THEN
           #LET l_str = '此標籤無使用者(一)初/複盤資料'       #No.MOD-560076
           CALL cl_getmsg('aim-878',g_lang) RETURNING l_str   #No.MOD-560076
           INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
               VALUES(l_pia.pia01,l_pia.pia02,l_str,g_plant,g_legal) #No.FUN-980004
       END IF
      #IF l_pia.pia30 IS NOT NULL AND (l_pia.pia50 IS NULL)
       IF l_pia.pia30 IS NULL AND (l_pia.pia50 IS NULL) THEN  #No:9031
           #LET l_str = '此標籤無使用者(一)初/複盤資料有問題'  #No.MOD-560076
           CALL cl_getmsg('aim-879',g_lang) RETURNING l_str    #No.MOD-560076
           INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
               VALUES(l_pia.pia01,l_pia.pia02,l_str,g_plant,g_legal) #No.FUN-980004
       END IF
      #IF l_pia.pia08 IS NOT NULL OR l_pia.pia08 = ' '
       IF l_pia.pia08 IS NULL OR l_pia.pia08 = ' ' THEN  #No:8990
           #LET l_str = '此標籤無其現有庫存(pia08)為NULL有問題'  #No.MOD-560076
           CALL cl_getmsg('aim-864',g_lang) RETURNING l_str      #No.MOD-560076
           INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
               VALUES(l_pia.pia01,l_pia.pia02,l_str,g_plant,g_legal) #No.FUN-980004
       END IF
      #IF l_pia.pia10 IS NOT NULL OR l_pia.pia10 = ' '
       IF l_pia.pia10 IS NULL OR l_pia.pia10 = ' ' OR l_pia.pia10 = 0 THEN #No:8990
           #LET l_str = '此標籤其庫存/料件轉換率有問題'#No.MOD-560076
            CALL cl_getmsg('aim-865',g_lang) RETURNING l_str    #No.MOD-560076
           INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
               VALUES(l_pia.pia01,l_pia.pia02,l_str,g_plant,g_legal) #No.FUN-980004
       END IF
     END FOREACH
 
     FOREACH r880_cwip INTO l_pie.*,l_pid02
        IF SQLCA.sqlcode != 0 THEN 
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
        IF cl_null(l_pie.pie900) THEN LET l_pie.pie900=l_pie.pie02 END IF #FUN-870051 
        SELECT sfa05,sfa06,sfa062,sfa161,sfa063 
          INTO l_sfa05,l_sfa06,l_sfa062,l_sfa161,l_sfa063
         FROM sfa_file 
         WHERE sfa01 = l_pid02 
           AND sfa03 = l_pie.pie02
           AND sfa08 = l_pie.pie03
           AND sfa12 = l_pie.pie04
           AND sfa27 = l_pie.pie900    #No.FUN-870051
           AND sfa012 = l_pie.pie012 AND sfa013 = l_pie.pie013   #FUN-A60027
 
        IF l_pie.pie11 != l_sfa05 THEN 
            #LET l_str = '此工單應發量現行資料與盤點卡中資料不一致'   #No.MOD-560076
            CALL cl_getmsg('aim-866',g_lang) RETURNING l_str          #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie12 != l_sfa06 THEN
            #LET l_str = '此工單已發量現行資料與盤點卡中資料不一致'   #No.MOD-560076
            CALL cl_getmsg('aim-875',g_lang) RETURNING l_str          #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie13 != l_sfa062 THEN
            #LET l_str = '此工單超領量現行資料與盤點卡中資料不一致'   #No.MOD-560076
            CALL cl_getmsg('aim-876',g_lang) RETURNING l_str          #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie14 != l_sfa161 THEN
            #LET l_str = '此工單QPA 現行資料與盤點卡中資料不一致'  #No.MOD-560076
            CALL cl_getmsg('aim-867',g_lang) RETURNING l_str       #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie15 != l_sfa063 THEN
            #LET l_str = '此工單報廢現行資料與盤點卡中資料不一致'  #No.MOD-560076
            CALL cl_getmsg('aim-868',g_lang) RETURNING l_str       #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie02 IS NULL OR l_pie.pie02 = ' ' THEN
            #LET l_str = '此標籤無料件編號'                     #No.MOD-560076
            CALL cl_getmsg('aim-860',g_lang) RETURNING l_str    #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
       #IF l_pie.pie03 IS NULL OR l_pie.pie03 = ' ' THEN         #MOD-910029 mark  
        IF l_pie.pie03 IS NULL  THEN                             #MOD-910029 
            #LET l_str = '此標籤其作業序號有問題'                #No.MOD-560076
            CALL cl_getmsg('aim-869',g_lang) RETURNING l_str     #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie04 IS NULL OR l_pie.pie04 = ' ' THEN
            #LET l_str = '此標籤其發料單位有問題'                #No.MOD-560076
            CALL cl_getmsg('aim-870',g_lang) RETURNING l_str     #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie30 IS NULL AND l_pie.pie50 IS NULL THEN
            #LET l_str = '此標籤無使用者(一)初/複盤資料'         #No.MOD-560076
            CALL cl_getmsg('aim-878',g_lang) RETURNING l_str     #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
       #IF l_pie.pie30 IS NOT NULL AND (l_pie.pie50 IS NULL) THEN    #MOD-AC0390 mark
        IF l_pie.pie30 IS NULL AND (l_pie.pie50 IS NULL) THEN        #MOD-AC0390 add
            #LET l_str = '此標籤無使用者(一)初/複盤資料有問題'   #No.MOD-560076
            CALL cl_getmsg('aim-879',g_lang) RETURNING l_str     #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pie.pie152 IS NULL OR l_pie.pie152 = ' ' OR l_pie.pie152 = 0 THEN
            #LET l_str = '此標籤其單位轉換率有問題'             #No.MOD-560076
            CALL cl_getmsg('aim-871',g_lang) RETURNING l_str    #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pie.pie01,l_pie.pie02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
     END FOREACH
 
     LET l_sql = "SELECT pid01,pid02,pid13,pid14,pid15,pid17,",
                 "       sfb09,sfb10,sfb11,sfb12 ",
                 "  FROM pid_file,sfb_file",
                 "  WHERE pid02 = sfb01 " 
           
     PREPARE r880_prepid  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r880_cpid CURSOR FOR r880_prepid
     FOREACH r880_cpid INTO l_pid01,l_pid02,l_pid13,l_pid14,l_pid15,l_pid17,
                            l_sfb09,l_sfb10,l_sfb11,l_sfb12 
        IF SQLCA.sqlcode != 0 THEN 
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
        IF l_pid13 != l_sfb09 THEN
            #LET l_str = '此工單入庫量現行資料與盤點卡中資料不一致'   #No.MOD-560076
            CALL cl_getmsg('aim-872',g_lang) RETURNING l_str          #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pid01,l_pid02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pid14 != l_sfb10 THEN
            #LET l_str = '此工單再加工量現行資料與盤點卡中資料不一致' #No.MOD-560076
            CALL cl_getmsg('aim-873',g_lang) RETURNING l_str          #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pid01,l_pid02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pid15 != l_sfb11 THEN
            #LET l_str = '此工單FQC 量現行資料與盤點卡中資料不一致'   #No.MOD-560076
            CALL cl_getmsg('aim-874',g_lang) RETURNING l_str          #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pid01,l_pid02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
        IF l_pid17 != l_sfb12 THEN
            #LET l_str = '此工單報廢量現行資料與盤點卡中資料不一致'    #No.MOD-560076
            CALL cl_getmsg('aim-868',g_lang) RETURNING l_str           #No.MOD-560076
            INSERT INTO pif_file(pif01,pif02,pif03,pifplant,piflegal)  #No.MOD-470041 #No.FUN-980004
                VALUES(l_pid01,l_pid02,l_str,g_plant,g_legal) #No.FUN-980004
        END IF
     END FOREACH  
END FUNCTION
