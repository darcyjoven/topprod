# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: gisp110.4gl
# Descriptions...: 銷項發票底稿匯出作業
# Date & Author..: 02/04/15 By Danny
# Modify.........: No.FUN-540006 05/04/25 By day  gisi100新增"匯出"按鈕,傳入參數帳單編號
 # Modify.........: No.MOD-560233 05/06/29 By day  報表檔名固定，g_page_line取法改變
# Modify.........: No.FUN-580006 05/08/11 By ice 修正發票底稿作業與航天金穗防偽稅控系統接口
# Modify.........: No.MOD-590044 05/10/21 By Carrier 修改發票匯出/產品類型碼內容
# Modify.........: No.MOD-5A0183 05/10/24 By day  換行符替換成\n
# Modify.........: No.FUN-5B0070 05/11/14 By wujie 增加可從客戶端匯出資料
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
 
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-D50034 13/05/13 By zhangweib 匯出數據來源改取isg_file/ish_file

import os      #No.FUN-D50034   Add
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_sql   	string,  #No.FUN-580092 HCN
       tm       RECORD
                wc    LIKE type_file.chr1000, #NO.FUN-690009  VARCHAR(600)
                b     LIKE type_file.chr1,    #NO.FUN-690009  VARCHAR(01)
                d     LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #MOD-590044
                e     LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)   #No.FUN-5B0070
                END RECORD
 
DEFINE g_argv1  LIKE isa_file.isa04     #No.FUN-540006
DEFINE g_argv2  LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)    #No.MOD-590044
#No.FUN-5B0070--begin
DEFINE  g_target  LIKE gbc_file.gbc05,    #NO.FUN-690009  VARCHAR(100)
        g_fileloc LIKE gbc_file.gbc05,    #NO.FUN-690009  VARCHAR(100)
        l_url     STRING
#No.FUN-5B0070--end
 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0098
   DEFINE p_row,p_col     LIKE type_file.num5     #NO.FUN-690009  SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)    #No.FUN-540006
   LET g_argv2=ARG_VAL(2)    #No.MOD-590044
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
#No.FUN-540006-begin
   IF cl_null(g_argv1) THEN
      OPEN WINDOW p110 AT p_row,p_col
         WITH FORM "gis/42f/gisp110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_init()
 
      CALL cl_opmsg('z')
 
      CALL p110()
 
      CLOSE WINDOW p110
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
   ELSE
      LET tm.wc=" isa04='",g_argv1,"' "
      LET tm.b='N'
      LET tm.d=g_isf.isf01   #No.MOD-590044
      CALL p110_t()
   END IF
#No.FUN-540006-end
END MAIN
 
FUNCTION p110()
   WHILE TRUE
      CLEAR FORM
      CONSTRUCT BY NAME tm.wc ON isa04,isa05,isa062,isa00
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('isauser', 'isagrup') #FUN-980030
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      LET tm.b = 'N'
      LET tm.d = g_isf.isf01  #No.MOD-590044
     # LET tm.e = 'N'          #No.FUN-5B0070   #No.FUN-D50034   Mark
     LET tm.e = 'Y'          #No.FUN-D50034   Add
      DISPLAY BY NAME tm.b,tm.e,tm.d   #No.FUN-D50034   Add
 
      INPUT BY NAME tm.b,tm.d,tm.e WITHOUT DEFAULTS  #No.FUN-5B0070
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
 
         #No.MOD-590044  --begin
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
               NEXT FIELD d
            END IF
         #No.MOD-590044  --end
         #No.FUN-5B0070  --begin
         AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
               NEXT FIELD e
            END IF
         #No.FUN-5B0070  --end
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()     # Command execution
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
      IF NOT cl_sure(0,0) THEN
         RETURN
      END IF
      CALL cl_wait()
      CALL p110_t()
      ERROR ''
      IF INT_FLAG THEN
         LET INT_FLAG = 0 EXIT WHILE
      END IF
   END WHILE
 
END FUNCTION
#No.FUN-D50034 ---Mark--- Start 
#FUNCTION p110_t()
#   DEFINE l_sql         LIKE type_file.chr1000  #NO.FUN-690009  VARCHAR(600)
#   DEFINE l_name        LIKE type_file.chr20    #NO.FUN-690009  VARCHAR(20)
#   DEFINE l_cnt         LIKE type_file.num5     #NO.FUN-690009  SMALLINT
#   DEFINE l_str         LIKE type_file.chr1000  #NO.FUN-690009  VARCHAR(80)
#   DEFINE l_za05        LIKE type_file.chr1000  #NO.FUN-690009  VARCHAR(40)
#   DEFINE sr            RECORD
#                        isa   RECORD LIKE isa_file.*,
#                        isb   RECORD LIKE isb_file.*
#                        END RECORD
# 
#   LET l_sql = "SELECT * FROM isa_file,isb_file ",
#               #No.MOD-590044  --begin
#               #" WHERE isa07 = '0' ",
#               "  WHERE isa07 <>'V' ",
#               #No.MOD-590044  --end
#               "   AND isa01 = isb01 AND isa04 = isb02 ",
#               "   AND ",tm.wc CLIPPED,
#               " ORDER BY isa04,isb03 "
# 
#   PREPARE p110_pre1 FROM l_sql
#   IF STATUS THEN CALL cl_err('p110_pre1',STATUS,1)
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#      EXIT PROGRAM 
#   END IF
#   DECLARE p110_curs1 CURSOR FOR p110_pre1
# 
#   CALL cl_outnam('gisp110') RETURNING l_name        #No.FUN-580006
# #No.MOD-560233-begin
#   LET l_name = 'BILL.txt'   #FUN-5B0070
#   SELECT UNIQUE zaa12 INTO g_page_line FROM zaa_file WHERE zaa01=g_prog
# #No.MOD-560233-end
#   START REPORT p110_rep TO l_name
#   FOREACH p110_curs1 INTO sr.*
#      IF STATUS THEN
#         CALL cl_err('p110_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
#      END IF
#      LET sr.isa.isa061 = sr.isa.isa061 / 100
#      OUTPUT TO REPORT p110_rep(sr.*)
#   END FOREACH
# 
#   FINISH REPORT p110_rep
# 
#   IF tm.b = 'Y' THEN
#      BEGIN WORK
#      LET g_success='Y'
#      LET l_sql = "UPDATE isa_file SET isa07 = '1' ",
#                  " WHERE isa07 = '0' ",
#                  "   AND ",tm.wc CLIPPED
#      PREPARE p110_pre2 FROM l_sql
#      IF STATUS THEN
#         CALL cl_err('p110_pre2',STATUS,1) LET g_success='N'
#      END IF
#      EXECUTE p110_pre2
#      IF STATUS THEN
#         CALL cl_err('execute',STATUS,1) LET g_success='N'
#      END IF
#      IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
#   END IF
##No.FUN-5B0070--begin
#   IF tm.e = 'Y' THEN
#      LET l_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/",l_name CLIPPED
#      IF NOT cl_open_url(l_url) THEN
#         CALL cl_err_msg(NULL,"lib-052",g_prog CLIPPED ||"|"|| g_lang CLIPPED,10)
#      END IF
#    ELSE
#      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#   END IF
##No.FUN-5B0070--end
#END FUNCTION
# 
#REPORT p110_rep(sr)
#   DEFINE sr            RECORD
#                        isa   RECORD LIKE isa_file.*,
#                        isb   RECORD LIKE isb_file.*
#                        END RECORD
##No.FUN-580006 --start--
#   DEFINE l_gen02       LIKE gen_file.gen02
#   DEFINE m_gen02       LIKE gen_file.gen02
#   DEFINE l_price       LIKE oeb_file.oeb13     #NO.FUN-690009  DEC(16,6)
#   DEFINE l_flag        LIKE type_file.num5     #NO.FUN-690009  SMALLINT
#   DEFINE l_gec07       LIKE gec_file.gec07
#   DEFINE l_cnt         LIKE type_file.num5     #NO.FUN-690009  SMALLINT
#   DEFINE l_sum         LIKE isb_file.isb09     #No.MOD-590044
##No.FUN-580006 --end--
#   DEFINE l_str         LIKE type_file.chr20    #NO.FUN-690009  VARCHAR(10)  #No.MOD-5A0183
# 
#   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin
#   PAGE LENGTH g_page_line      #No.FUN-560233
#   ORDER BY sr.isa.isa04,sr.isb.isb03
#   FORMAT
#    #No.MOD-590044  --begin
#    FIRST PAGE HEADER
#       PRINT "SJJK0101" CLIPPED,
#             '~~',
#             g_x[2] CLIPPED,
#             '~~',
#             g_x[3] CLIPPED
#    #No.MOD-590044  --end
# 
##No.FUN-580006 --start--
#   BEFORE GROUP OF sr.isa.isa04
#      SELECT gen02 INTO l_gen02 FROM gen_file
#       WHERE gen01=sr.isa.isa11
#      IF STATUS THEN LET l_gen02 ='' END IF
#      SELECT gen02 INTO m_gen02 FROM gen_file
#       WHERE gen01 = sr.isa.isa12
#      IF STATUS THEN LET m_gen02 ='' END IF
##No.MOD-5A0183-begin
#       LET l_str = ASCII 10
#       CALL cl_replace_str(sr.isa.isa10 CLIPPED,l_str CLIPPED,'@') RETURNING sr.isa.isa10
#       LET l_str = '@'
#       CALL cl_replace_str(sr.isa.isa10  CLIPPED,l_str CLIPPED,'\\\\n') RETURNING sr.isa.isa10
##No.MOD-5A0183-end
#      #No.MOD-590044  --begin
#      #IF l_cnt !=99 THEN
##     #   PRINT "SJJK0101~~銷售單據傳入~~銷售業務"
#      #   PRINT "SJJK0101" CLIPPED,
#      #         '~~',
#      #         g_x[2] CLIPPED,
#      #         '~~',
#      #         g_x[3] CLIPPED
#      #   LET l_cnt = 99
#      #END IF
#      #No.MOD-590044  --end
#      PRINT
#      PRINT "//",sr.isa.isa04 CLIPPED                #表示第几張單
#      PRINT sr.isa.isa04 CLIPPED,                    #應收賬款的編號(文本20)，可自行編號
#            '~~',
#            sr.isa.isa09 USING '<<<&',               #商品行數即單身的筆數(整數4)
#            '~~',
#            sr.isa.isa051 CLIPPED,                   #購方名稱(文本100)，即客戶全稱
#            '~~',
#            #No.MOD-590044  --begin
#            sr.isa.isa052[1,15] CLIPPED,             #購方稅號(文本15),即客戶統一編號
#            #No.MOD-590044  --end
#            '~~',
#            sr.isa.isa053 CLIPPED,                   #購方地址電話(文本80)，即客戶地址電話
#            '~~',
#            sr.isa.isa054 CLIPPED,                   #購方銀行賬號(文本80)，即客戶銀行賬號
#            '~~',
#            sr.isa.isa10  CLIPPED,                   #備注(文本160)，如開具負數發票，首行必須為“對應正數發票代碼XXXXXXXXXX號碼YYYYYYYY”,"\n"字符表示換行
#            '~~',
#            l_gen02       CLIPPED,                   #復核人(文本8)
#            '~~',
#            m_gen02       CLIPPED,                   #收款人(文本8)
#            '~~',
#            #No.MOD-590044  --begin
#            sr.isa.isa13 USING "YYYYMMDD",           #單據日期(日期)
#            #No.MOD-590044  --end
#            '~~',
#            sr.isa.isa15  CLIPPED                    #銷方銀行賬號(文本80)
#   ON EVERY ROW
#      LET l_price = 0
#      SELECT gec07 INTO l_gec07 FROM gec_file
#       WHERE gec01 = sr.isa.isa06
#      IF l_gec07 ='Y' THEN
#         LET l_price = sr.isb.isb09t/sr.isb.isb08
#         LET l_flag = 1
#      END IF
#      IF l_gec07 = 'N' THEN
#         LET l_price = sr.isb.isb09/sr.isb.isb08
#         LET l_flag = 0
#      END IF
#      #No.MOD-590044  --begin
#      IF tm.d='Y' THEN
#         LET l_sum = sr.isb.isb09t
#      ELSE
#         LET l_sum = sr.isb.isb09
#      END IF
#      IF cl_null(sr.isb.isb06) THEN LET sr.isb.isb06=sr.isb.isb04 END IF
#      #No.MOD-590044  --end
#      PRINT sr.isb.isb05 CLIPPED,                    #貨物名稱(文本8)即品名
#            '~~',
#            sr.isb.isb07 CLIPPED,                    #計量單位(文本16)
#            '~~',
#            sr.isb.isb06 CLIPPED,                    #規格(文本30)
#            '~~',
#            sr.isb.isb08  USING '-<<<<<<<<&.&&&&&&', #數量(數值 16.6)
#            '~~',
#            #No.MOD-590044  --begin
#            l_sum  USING '-<<<<<<<<<<&.&&',          #不含稅金額(數值 14.2)
#            #No.MOD-590044  --end
#            '~~',
#            sr.isa.isa061 USING '<&.&&',             #稅率(數值4.2)
#            '~~',
#            sr.isb.isb10 CLIPPED,                    #商品稅目(文本4),即商品類型ima131
#            '~~',
#            #No.MOD-590044  --begin
#            0 USING '-<<<<<<<<<<&.&&',               #折扣金額(數值14.2),暫時系統不支持
#            #No.MOD-590044  --end
#            '~~',
#            sr.isb.isb09x USING '-<<<<<<<<<<&.&&',   #稅額(數值14.2)
#            '~~',
#            #No.MOD-590044  --begin
#            0 USING '-<<<<<<<<<<&.&&',               #折扣稅額(數值14.2),系統暫不支持
#            '~~',
#            0 USING '-<&.&&&',                       #折扣率(數值6.3),系統暫不支持
#            #No.MOD-590044  --end
#            '~~',
#            l_price USING '-<<<<<<<<&.&&&&&&',       #單價(數值16.6)
#            '~~',
#            l_flag USING '<<<<&'                     #價格方式(0-不含稅單價，1-含稅單價)
##No.FUN-580006 --end--
##   BEFORE GROUP OF sr.isa.isa04
##      PRINT sr.isa.isa04 CLIPPED,' ',sr.isa.isa09 USING '<<<&',' ',
##            sr.isa.isa051 CLIPPED,' ',sr.isa.isa052 CLIPPED,' ',
##            sr.isa.isa053 CLIPPED,' ',sr.isa.isa054 CLIPPED
##   ON EVERY ROW
# 
##      PRINT '"',sr.isb.isb05 CLIPPED,'"',' ',sr.isb.isb07 CLIPPED,' ',
##            '"',sr.isb.isb06 CLIPPED,'"',' ',
##            sr.isb.isb08  USING '-<<<<<<<<&.&&&&&&',' ',
##            sr.isb.isb09  USING '-<<<<<<<<<<&.&&',' ',
##            sr.isa.isa061 USING '<&.&&',' ',sr.isb.isb10 CLIPPED,' 0 ',
##            sr.isb.isb09x USING '-<<<<<<<<<<&.&&',' 0 0'
#END REPORT
##Patch....NO.TQC-610037 <> #
#No.FUN-D50034 ---Mark--- End

#No.FUN-D50034 ---Add--- Start
FUNCTION p110_t()
   DEFINE l_sql         LIKE type_file.chr1000 
   DEFINE l_name        LIKE type_file.chr20    
   DEFINE l_str         LIKE type_file.chr1000 
   DEFINE sr            RECORD
                        isg   RECORD LIKE isg_file.*,
                        ish   RECORD LIKE ish_file.*
                        END RECORD
   DEFINE l_up_path,l_down_path STRING 
   DEFINE l_flag LIKE type_file.chr1   
   DEFINE l_ch  base.Channel           
   DEFINE l_cmd,l_name1 STRING         
 
   LET l_sql = "SELECT * FROM isg_file,ish_file ",
               " WHERE isg01 = ish01",
               "   AND isg01 IN (SELECT isa04 FROM isa_file,isb_file ",
               "                  WHERE isa07 <> 'V' ",
               "                    AND isa01 = isb01",
               "                    AND isa04 = isb02",
               "                    AND ",tm.wc CLIPPED,")",
               " ORDER BY isg01,ish02 "
 
   PREPARE p110_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('p110_pre1',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   DECLARE p110_curs1 CURSOR FOR p110_pre1
 
   CALL cl_outnam('gisp110') RETURNING l_name  
   LET l_name = 'BILL.txt'  
   SELECT UNIQUE zaa12 INTO g_page_line FROM zaa_file WHERE zaa01=g_prog
   START REPORT p110_rep TO l_name
   FOREACH p110_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p110_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      LET sr.ish.ish09 = sr.ish.ish09 / 100
      OUTPUT TO REPORT p110_rep(sr.*)
   END FOREACH
 
   FINISH REPORT p110_rep
 
   IF tm.b = 'Y' THEN
      BEGIN WORK
      LET g_success='Y'
      LET l_sql = "UPDATE isa_file SET isa07 = '1' ",
                  " WHERE isa07 = '0' ",
                  "   AND ",tm.wc CLIPPED
      PREPARE p110_pre2 FROM l_sql
      IF STATUS THEN
         CALL cl_err('p110_pre2',STATUS,1) LET g_success='N'
      END IF
      EXECUTE p110_pre2
      IF STATUS THEN
         CALL cl_err('execute',STATUS,1) LET g_success='N'
      END IF
      IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   END IF
   IF tm.e = 'Y' THEN
      LET l_url = FGL_GETENV("TEMPDIR")
      LET l_url = l_url CLIPPED,'/',l_name CLIPPED
      LET l_up_path = FGL_GETENV("TEMPDIR")
      LET l_up_path = l_up_path CLIPPED,'/',"BILL1.txt" CLIPPED
      LET l_ch = base.Channel.create()
      LET l_cmd = "iconv -f UTF-8 -t GBK ",l_url," > ",l_up_path
      CALL l_ch.openPipe(l_cmd,"r")
      CALL l_ch.close()
      LET l_down_path = "d:/INVOICE/"              
      LET l_name1 = sr.isg.isg01 CLIPPED,'.txt'
      LET l_down_path = os.path.join(l_down_path,l_name1 CLIPPED)  
      LET l_flag = cl_download_file(l_up_path,l_down_path) 
      IF l_flag THEN
         DISPLAY "Download OK!!"
      ELSE
         DISPLAY "Download fail!!"
      END IF
    ELSE
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   END IF
END FUNCTION
 
REPORT p110_rep(sr)
   DEFINE sr            RECORD
                        isg   RECORD LIKE isg_file.*,
                        ish   RECORD LIKE ish_file.*
                        END RECORD 
   DEFINE l_str         LIKE type_file.chr20 
   DEFINE l_gfe02       LIKE gfe_file.gfe02  
   
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin
   PAGE LENGTH g_page_line    
   ORDER BY sr.isg.isg01,sr.ish.ish02
   FORMAT
    FIRST PAGE HEADER
       PRINT "SJJK0101" CLIPPED,
             '~~',
             g_x[2] CLIPPED,
             '~~',
             g_x[3] CLIPPED
             
   BEFORE GROUP OF sr.isg.isg01
      LET l_str = ASCII 10
      CALL cl_replace_str(sr.isg.isg07 CLIPPED,l_str CLIPPED,'@') RETURNING sr.isg.isg07
      LET l_str = '@'
      CALL cl_replace_str(sr.isg.isg07  CLIPPED,l_str CLIPPED,'\\\\n') RETURNING sr.isg.isg07
      PRINT
      PRINT "//",sr.isg.isg01 CLIPPED               #表示第几張單
      PRINT sr.isg.isg01 CLIPPED,                   #應收賬款的編號(文本20)，可自行編號
            '~~',
            sr.isg.isg02 USING '<<<&',              #商品行數即單身的筆數(整數4)
            '~~',
            sr.isg.isg03 CLIPPED,                   #購方名稱(文本100)，即客戶全稱
            '~~',
            sr.isg.isg04[1,15] CLIPPED,             #購方稅號(文本15),即客戶統一編號
            '~~',
            sr.isg.isg05 CLIPPED,                   #購方地址電話(文本80)，即客戶地址電話
            '~~',
            sr.isg.isg06 CLIPPED,                   #購方銀行賬號(文本80)，即客戶銀行賬號
            '~~',
            sr.isg.isg07 CLIPPED,                   #備注(文本160)，如開具負數發票，首行必須為“對應正數發票代碼XXXXXXXXXX號碼YYYYYYYY”,"
            '~~',
            sr.isg.isg08 CLIPPED,                   #復核人(文本8)
            '~~',
            sr.isg.isg09 CLIPPED,                   #收款人(文本8)
            '~~',
            sr.isg.isg11 USING "YYYYMMDD",          #單據日期(日期)
            '~~',
            sr.isg.isg12  CLIPPED                   #銷方銀行賬號(文本80)
   ON EVERY ROW
      IF cl_null(sr.ish.ish06) THEN LET sr.ish.ish06=sr.ish.ish03 END IF
      SELECT gfe02 INTO l_gfe02 FROM gfe_file WHERE gfe01 = sr.ish.ish05
      PRINT sr.ish.ish04 CLIPPED,                    #貨物名稱(文本8)即品名
            '~~',
            l_gfe02      CLIPPED,                    #計量單位(文本16) 
            '~~',
            sr.ish.ish06 CLIPPED,                    #規格(文本30)
            '~~',
            sr.ish.ish07 USING '-<<<<<<<<&.&&&&&&',  #數量(數值 16.6)
            '~~',
            sr.ish.ish08 USING '-<<<<<<<<<<&.&&',    #不含稅金額(數值 14.2)
            '~~',
            sr.ish.ish09 USING '<&.&&',              #稅率(數值4.2)
            '~~',
            sr.ish.ish10 CLIPPED,                    #商品稅目(文本4),即商品類型ima131
            '~~',
            sr.ish.ish11 USING '-<<<<<<<<<<&.&&',    #折扣金額(數值14.2),暫時系統不支持
            '~~',
            sr.ish.ish12 USING '-<<<<<<<<<<&.&&',    #稅額(數值14.2)
            '~~',
                                                     #折扣稅額(數值14.2),系統暫不支持
            '~~',
            0            USING '-<&.&&&',            #折扣率(數值6.3),系統暫不支持
            '~~',
            sr.ish.ish15 USING '-<<<<<<<<&.&&&&&&',  #單價(數值16.6)
            '~~',
            sr.ish.ish16 USING '<<<<&'               #含稅否(1/0)
END REPORT
#No.FUN-D50034 ---Add--- End

