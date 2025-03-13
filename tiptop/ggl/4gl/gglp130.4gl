# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gglp130.4gl
# Descriptions...: 用友財務軟件接口作業-XML
# Date & Author..: 03/06/04 By Jack
# Modify.........: No.TQC-630006 06/03/02 By alex 移除 cat /dev/null 寫法
# Modify.........: No.TQC-630185 06/03/17 By Echo 將echo '' 改為 echo -n ''
# Modify.........: No.MOD-650098 06/05/25 By Echo 恢復 cat /dev/null 寫法
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_sql   string,                 #No.FUN-580092 HCN
        g_print LIKE type_file.num5,    #NO FUN-690009 SMALLINT
       g_abb01  LIKE abb_file.abb01,
       tm       RECORD
                wc    LIKE type_file.chr1000,      #NO.FUN-690009 VARCHAR(600)
                a     LIKE type_file.chr1,         #NO.FUN-690009 VARCHAR(01)
                b     LIKE type_file.chr1          #NO.FUN-690009 VARCHAR(01)
                END RECORD,
       l_headtag      LIKE type_file.chr1,         #NO.FUN-690009 VARCHAR(01)
       l_aba01        like aba_file.aba01,
       m_headtag      LIKE type_file.chr1,         #NO.FUN-690009 VARCHAR(01)
#       l_time       LIKE type_file.chr8             #No.FUN-6A0097
       xml_name       LIKE type_file.chr20         #NO.FUN-690009 VARCHAR(20)
 
MAIN
    DEFINE p_row,p_col     LIKE type_file.num5     #NO.FUN-690009
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   LET g_print =1
   LET g_abb01=' '
   OPEN WINDOW p130 AT p_row,p_col WITH FORM "ggl/42f/gglp130"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   CALL p130()
   CLOSE WINDOW p130
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
END MAIN
 
FUNCTION p130()
   WHILE TRUE
 
      CLEAR FORM
 
      CONSTRUCT BY NAME tm.wc ON aba00,aba01,aba02,aba06
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET tm.a = '1'
      LET tm.b = '1'
 
      INPUT BY NAME tm.a,tm.b WITHOUT DEFAULTS
 
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[123]' THEN
               NEXT FIELD b
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
      IF NOT cl_sure(0,0) THEN
         CONTINUE WHILE
      END IF
      CALL cl_wait()
      CALL p130_t()
      ERROR ''
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p130_t()
   DEFINE l_sql         LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(600)
   DEFINE m_sql         LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(50)
   DEFINE l_name        LIKE type_file.chr20    #NO.FUN-690009 VARCHAR(20)
   DEFINE i,l_i,l_n     LIKE type_file.num5     #NO.FUN-690009 SMALLINT
   DEFINE l_str         LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(100)
   DEFINE l_za05        LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(40)
   DEFINE l_aee04       LIKE aee_file.aee04
   DEFINE sr            RECORD
                        aaf03       like   aaf_file.aaf03,
                        aba         RECORD LIKE aba_file.*,
                        abb         RECORD LIKE abb_file.*
                        END RECORD
 
   LET l_sql = "SELECT aaf03,aba_file.*,abb_file.* ",
               "  FROM aba_file,abb_file,aaf_file ",
               " WHERE aaf01 = aba00 AND aaf02 = '2' ",
               "   AND aba00 = abb00 AND aba01 = abb01 ",
               "   AND abaacti = 'Y' ",
               "   AND aba19 <> 'X' ",   #CHI-C80041
               "   AND aba06 != 'CE' ",
               "   AND ",tm.wc CLIPPED
 
   PREPARE p130_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('p130_pre1',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE p130_curs1 CURSOR FOR p130_pre1
 
   LET l_name = 'UFERPM85'
   LET xml_name=l_name CLIPPED,'.xml'
 
#  LET m_sql = "chmod 777 UFERPM85.xml 2>/dev/null"
#  RUN m_sql RETURNING l_n
   IF os.Path.chrwx("UFERPM85.xml", 511) THEN     #FUN-9B0113  7*64+7*8+7=511
   END IF
 
#  LET m_sql = "rm UFERPM85.xml 2>/dev/null"      #FUN-9B0113
#  RUN m_sql RETURNING l_n
   IF os.Path.delete("UFERPM85.xml") THEN
   END IF
 
   START REPORT p130_rep TO l_name
   LET l_headtag = '0'
   LET l_aba01 = ' '
   LET m_headtag = '0'
   LET l_i = 0
   FOREACH p130_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('p130_curs1',STATUS,1) EXIT FOREACH
      END IF
      IF tm.a = '1' AND sr.aba.aba19 = 'N' THEN CONTINUE FOREACH END IF
      IF tm.a = '2' AND sr.aba.aba19 = 'Y' THEN CONTINUE FOREACH END IF
      IF tm.b = '1' AND sr.aba.abapost = 'N' THEN CONTINUE FOREACH END IF
      IF tm.b = '2' AND sr.aba.abapost = 'Y' THEN CONTINUE FOREACH END IF
      LET l_i = 1
      OUTPUT TO REPORT p130_rep(sr.aaf03,sr.aba.*,sr.abb.*)
   END FOREACH
 
   FINISH REPORT p130_rep
#   CALL cl_prt(xml_name,g_prtway,g_copies,g_len)#use p000 directly
 #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
END FUNCTION
 
REPORT p130_rep(sr)
  DEFINE sr             RECORD
                        aaf03       like aaf_file.aaf03,
                        aba         RECORD LIKE aba_file.*,
                        abb         RECORD LIKE abb_file.*
                        END RECORD
  DEFINE l_abb04        LIKE abb_file.abb04,
         l_abb02        like abb_file.abb02
  DEFINE l_abb03        LIKE abb_file.abb03
  DEFINE l_e_amt        LIKE ooy_file.ooytype    #NO.FUN-690009    VARCHAR(2)
  DEFINE l_d_amt,l_c_amt LIKE abb_file.abb07
  DEFINE l_abb01        LIKE abb_file.abb01
  DEFINE l_str          LIKE type_file.chr1000   #NO.FUN-690009    VARCHAR(100)
  DEFINE l_sql          LIKE type_file.chr1000,  #NO.FUN-690009    VARCHAR(500)
         l_cmd          LIKE type_file.chr1000   #NO.FUN-690009    VARCHAR(40)
  DEFINE i,l_i,l_n      LIKE type_file.num5      #NO.FUN-690009    SMALLINT
  DEFINE l_channel      base.Channel
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.aba.aba00,sr.aba.aba01,sr.abb.abb02
 
  FORMAT
 
    PAGE HEADER
      IF l_headtag='0' THEN
#        LET l_cmd = 'cat /dev/null>',xml_name CLIPPED    #TQC-630006 #MOD-650098
         CALL cl_null_cat_to_file(xml_name CLIPPED)       #FUN-9B0113
 
         LET l_channel = base.Channel.create()
 
         CALL l_channel.openFile( xml_name CLIPPED, "a" )
 
         CALL l_channel.setDelimiter("")
 
         CALL l_channel.write( "<?xml version=""1.0"" encoding=""GB2312""?>" )
         CALL l_channel.write( "<ufinterface roottag=""voucher"" billtype="""" docid="""" receiver=""u8"" sender=""999"" proc=""Query"" codeexchanged=""N"" exportneedexch=""N"" renewproofno=""n"" version=""2.0"">" )
         LET l_headtag = '1'
      END IF
 
    ON EVERY ROW
 
       IF m_headtag ='0' THEN
          LET l_str=' <voucher id="','">'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='  <voucher_header>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <company>',sr.aaf03 CLIPPED,'</company>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <voucher_type>',sr.aba.aba01[1,2] CLIPPED,'</voucher_type>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <fiscal_year>',sr.aba.aba03 CLIPPED,'</fiscal_year>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <accounting_period>',sr.aba.aba04 CLIPPED,'</accounting_period>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <voucher_id>',sr.aba.aba01 CLIPPED,'</voucher_id>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <attachment_number>',-1,'</attachment_number>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <date>',sr.aba.aba02 USING "YYYY-MM-DD",'</date>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <enter>',sr.aba.abauser CLIPPED,'</enter>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <cashier>','</cashier>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <signature>',sr.aba.aba19 CLIPPED,'</signature>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <checker>','</checker>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <posting_date>',sr.aba.abadate USING "YYYY-MM-DD",'</posting_date>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <posting_person>',sr.aba.abamodu CLIPPED,'</posting_person>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <voucher_making_system>','</voucher_making_system>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <memo1>','</memo1>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <memo2>','</memo2>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <reserve1>','</reserve1>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <reserve2>','</reserve2>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='  </voucher_header>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='  <voucher_body>'
          CALL l_channel.write(l_str CLIPPED)
 
          LET l_aba01=sr.aba.aba01
          LET m_headtag = '1'
       ELSE IF sr.aba.aba01 != l_aba01 THEN   #aba01 different then print header
###first print body tailer
          LET l_str='  </voucher_body>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str=' </voucher>'
          CALL l_channel.write(l_str CLIPPED)
#####
 
          LET l_str=' <voucher id="','">'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='  <voucher_header>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <company>',sr.aaf03 CLIPPED,'</company>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <voucher_type>',sr.aba.aba01[1,2] CLIPPED,'</voucher_type>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <fiscal_year>',sr.aba.aba03 CLIPPED,'</fiscal_year>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <accounting_period>',sr.aba.aba04 CLIPPED,'</accounting_period>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <voucher_id>',sr.aba.aba01 CLIPPED,'</voucher_id>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <attachment_number>',-1,'</attachment_number>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <date>',sr.aba.aba02 USING "YYYY-MM-DD",'</date>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <enter>',sr.aba.abauser CLIPPED,'</enter>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <cashier>','</cashier>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <signature>',sr.aba.aba19 CLIPPED,'</signature>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <checker>','</checker>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <posting_date>',sr.aba.abadate USING "YYYY-MM-DD",'</posting_date>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <posting_person>',sr.aba.abamodu CLIPPED,'</posting_person>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <voucher_making_system>',sr.aba.aba06 CLIPPED,'</voucher_making_system>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <memo1>','</memo1>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <memo2>','</memo2>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <reserve1>','</reserve1>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   <reserve2>','</reserve2>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='  </voucher_header>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='  <voucher_body>'
          CALL l_channel.write(l_str CLIPPED)
 
          LET l_aba01=sr.aba.aba01
           END IF
       END IF
 
###print body
          LET l_str='   <entry>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <entry_id>',sr.abb.abb02 CLIPPED,'</entry_id>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <account_code>',sr.abb.abb03 CLIPPED,'</account_code>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <abstract>',sr.abb.abb04 CLIPPED,'</abstract>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <settlement>','</settlement>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <document_id>','</document_id>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <document_date>','</document_date>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <currency>',sr.abb.abb24 CLIPPED,'</currency>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <unit_price>','</unit_price>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='    <exchange_rate1>',sr.abb.abb25 CLIPPED,'</exchange_rate1>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='    <exchange_rate2>','</exchange_rate2>'
          CALL l_channel.write(l_str CLIPPED)
        IF sr.abb.abb06 = '1' THEN
	  LET l_str='    <debit_quantity>',0,'</debit_quantity>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <primary_debit_amount>',0,'</primary_debit_amount>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='    <secondary_debit_amount>','</secondary_debit_amount>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <natural_debit_currency>',sr.abb.abb07 CLIPPED,'</natural_debit_currency>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='    <credit_quantity>',0,'</credit_quantity>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <primary_credit_amount>',0,'</primary_credit_amount>'
          CALL l_channel.write(l_str CLIPPED)
 	  LET l_str='    <secondary_credit_amount>','</secondary_credit_amount>'
          CALL l_channel.write(l_str CLIPPED)
 	  LET l_str='    <natural_credit_currency>',0,'</natural_credit_currency>'
          CALL l_channel.write(l_str CLIPPED)
        ELSE
          LET l_str='    <debit_quantity>',0,'</debit_quantity>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <primary_debit_amount>',0,'</primary_debit_amount>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <secondary_debit_amount>','</secondary_debit_amount>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <natural_debit_currency>',0,'</natural_debit_currency>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <credit_quantity>',0,'</credit_quantity>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <primary_credit_amount>',0,'</primary_credit_amount>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <secondary_credit_amount>','</secondary_credit_amount>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <natural_credit_currency>',sr.abb.abb07,'</natural_credit_currency>'
          CALL l_channel.write(l_str CLIPPED)
        END IF
          LET l_str='    <bill_type>','</bill_type>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <bill_id>','</bill_id>'
          CALL l_channel.write(l_str CLIPPED)
 	  LET l_str='    <bill_date>','</bill_date>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='    <auxiliary_accounting>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="dept_id">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="personnel_id">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="cust_id">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="supplier_id">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="item_class">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="item_id">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="operator">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define1">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define2">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define3">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define4">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define5">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define6">','</item>'
          CALL l_channel.write(l_str CLIPPED)
 
	  LET l_str='     <item name="self_define7">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define8">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define9">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define10">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define11">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define12">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define13">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define14">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define15">','</item>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <item name="self_define16">','</item>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    </auxiliary_accounting>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='    <detail>'
          CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     <cash_flow_statement>'
 	  CALL l_channel.write(l_str CLIPPED)
          LET l_str='      <cash_flow cash_item="" natural_debit_currency="" natural_credit_currency="">','</cash_flow>'
	  CALL l_channel.write(l_str CLIPPED)
	  LET l_str='     </cash_flow_statement>'
	  CALL l_channel.write(l_str CLIPPED)
	  LET l_str='    </detail>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='   </entry>'
 	  CALL l_channel.write(l_str CLIPPED)
 
    ON LAST ROW
###print xml tailer
   IF l_i = 1 THEN
          LET l_str='  </voucher_body>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str=' </voucher>'
          CALL l_channel.write(l_str CLIPPED)
          LET l_str='</ufinterface>'
          CALL l_channel.write(l_str CLIPPED)
          CALL l_channel.close()
#         LET l_sql = "chmod 777 ", xml_name                   #No.FUN-9C0009
#         RUN l_sql RETURNING l_n                              #No.FUN-9C0009
          IF os.Path.chrwx(xml_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
          LET l_sql = "netedit.ie ",xml_name CLIPPED
          RUN l_sql RETURNING l_n
    END IF
###
 
END REPORT
#Patch....NO.TQC-610037 <001> #
