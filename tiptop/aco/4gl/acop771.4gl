# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: acop771.4gl
# Descriptions...: 出口報關資料匯出Excel作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)

IMPORT os    #FUN-A30038 

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE tm              RECORD                  # Print condition RECORD
         wc            STRING                  # Where condition
                       END RECORD
DEFINE g_flag          LIKE type_file.chr1
DEFINE m_tempdir       LIKE type_file.chr1000,
       m_file          LIKE type_file.chr1000,
       g_file_name     LIKE type_file.chr1000,
       lc_channel      base.Channel,
       g_str           STRING
DEFINE ms_codeset      STRING  
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                       # Supress DEL key function
 
   LET tm.wc       = ARG_VAL(1)                # Get arguments from command line
   LET g_file_name = ARG_VAL(2)
   LET g_bgjob     = ARG_VAL(3)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET ms_codeset = cl_get_codeset()
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL p771_tm(0,0)                        # Input print condition
   ELSE
      CALL p771()                              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
 
#===================================
# 開窗輸入條件
#===================================
FUNCTION p771_tm(p_row,p_col)
   DEFINE p_row,p_col      LIKE type_file.num5,
          l_cmd            LIKE type_file.chr1000,
          l_flag           LIKE type_file.num5
 
   OPEN WINDOW p771_w WITH FORM "aco/42f/acop771"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.wc TO NULL                  # Default condition
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
 
   WHILE TRUE
      ERROR ''
      LET tm.wc = ""
      CONSTRUCT BY NAME tm.wc ON cet01,cet03,cet05,cet04,cet34  
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE WHEN INFIELD(cet01)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state= "c"
                      LET g_qryparam.form = "q_cet01"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO cet01
                 WHEN INFIELD(cet05)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form  = "q_pmc"
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO cet05
                 WHEN INFIELD(cet04)
#FUN-AA0059 --Begin--
                   #   CALL cl_init_qry_var()
                   #   LET g_qryparam.form  = "q_ima"
                   #   LET g_qryparam.state = "c"
                   #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                       CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                      DISPLAY g_qryparam.multiret TO cet04
                 WHEN INFIELD(cet34)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form  = "q_ofa"
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO cet34
            END CASE
 
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
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
 
         ON ACTION exit                     #genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END CONSTRUCT
      IF g_action_choice = "locale" THEN     #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG=0
         EXIT WHILE
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',1)
         CONTINUE WHILE
      END IF
 
 
      INPUT g_file_name,g_bgjob FROM file_name,bg_job 
         AFTER FIELD file_name        
            IF cl_null(g_file_name) THEN
               NEXT FIELD file_name
            END IF     
        
         AFTER FIELD bg_job
            IF g_bgjob NOT MATCHES '[YN]' THEN
               NEXT FIELD bg_job
            END IF    
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()      # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about 
            CALL cl_about() 
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01 = 'acop771'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('acop771','9031',1)   
         ELSE          
            LET tm.wc  = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",tm.wc CLIPPED,"'",
                        " '",g_file_name,"'",
                        " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('acop771',g_time,l_cmd CLIPPED)
         END IF
         CLOSE WINDOW p771_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CONTINUE WHILE
      END IF
 
      IF NOT cl_sure(18,20) THEN
         CONTINUE WHILE
      END IF
 
      CALL cl_wait()
      CALL p771()
    
      IF g_success = 'N' THEN
         CALL cl_end2(2) RETURNING l_flag
      ELSE
         CALL cl_end2(1) RETURNING l_flag
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
      IF NOT INT_FLAG THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW p771_w
END FUNCTION
 
 
#===================================
# 開始處理資料
#===================================
FUNCTION p771()
   DEFINE l_name        LIKE type_file.chr20,    # External(Disk) file name
          l_sql         STRING,                  # RDSQL STATEMENT
          l_cmd         STRING,
          l_n           LIKE type_file.num5,
          l_oga23       LIKE oga_file.oga23,        #幣別
          l_oga24       LIKE oga_file.oga24,        #匯率
          l_ogb13       LIKE ogb_file.ogb13,        #原幣單價
          l_cei05       LIKE cei_file.cei05,        #幣別
          l_cei10       LIKE cei_file.cei10,        #第一法定計量單位轉換比率
          l_cei18       LIKE cei_file.cei18,        #第二法定單位轉換率
          l_rate        LIKE azj_file.azj03,        #匯率
 
          sr            RECORD
                        cet01    LIKE cet_file.cet01,       #異動單號
                        cet02    LIKE cet_file.cet02,       #項次
                        cnb13    LIKE cnb_file.cnb13,       #營業執照號碼
                        cet03    LIKE cet_file.cet03,       #單據日期
                        cet11    LIKE cet_file.cet11,       #海關代號
                        cet24    LIKE cet_file.cet24,    #交運方式
                        cet26    LIKE cet_file.cet26,    #成交方式
                        cet30    LIKE cet_file.cet30,    #歸併後序號
                        cet17    LIKE cet_file.cet17,       #BOM版本編號
                        cet04    LIKE cet_file.cet04,       #料件編號
                        price    LIKE ogb_file.ogb13,       #單價
                        total    LIKE type_file.num26_10,   #總價
                        qty1     LIKE type_file.num26_10,   #法定數量
                        qty2     LIKE type_file.num26_10,   #第二法定數量
                        cet13    LIKE cet_file.cet13,       #異動數量
                        cet15    LIKE cet_file.cet15,       #異動數量(合同)
                        cet18    LIKE cet_file.cet18,       #手冊編號
                        wet      LIKE type_file.num26_10    #淨重
                        END RECORD
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND cetuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND cetgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN              #群組權限
   #      LET tm.wc = tm.wc clipped," AND cetgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cetuser', 'cetgrup')
   #End:FUN-980030
 
   IF cl_null(tm.wc) THEN LET tm.wc = " 1=1" END IF
   LET l_sql = "SELECT cet34,cet02,'',cet03,cet11,cet24, ",
               "       cet26,cet30,cet17,cet04,cet36,cet37,",
               "       cet31,cet32,cet13,cet15,cet18,cet33",
               "  FROM cet_file ",
               " WHERE cetacti = 'Y' AND cetconf='Y' ",
               "   AND ", tm.wc CLIPPED
   LET g_success = 'Y'
   PREPARE p771_prepare FROM l_sql
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE p771_cs CURSOR FOR p771_prepare
    
  #------------產生Excel file ----------------
   LET l_name = g_file_name CLIPPED,'.xls'
   LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/", g_file_name CLIPPED 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(m_file,"w")
   CALL lc_channel.setDelimiter("")
   CALL p771_get_h_xml()
 
   CALL s_showmsg_init()           
 
   LET l_n = 0
   FOREACH p771_cs INTO sr.*
      IF STATUS THEN
         CALL s_errmsg('','',"foreach",SQLCA.sqlcode,1)
         LET g_success = 'N'       
         EXIT FOREACH
      END IF
     #-->營業執照號碼
      SELECT cnb13 INTO sr.cnb13 FROM cnb_file
       WHERE cnb03 = (SELECT MIN(cnb03) FROM cnb_file)
     #-->資料產生
      LET g_str = '<TR>',
                  '<TD class=xl24>',g_cez.cez04 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet01 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cnb13 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cnb13 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet03 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet11 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet11 CLIPPED,'</TD>',
                  '<TD class=xl24>E</TD>',
                  '<TD class=xl24>4</TD>',
                  '<TD class=xl24>',sr.cet24 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet26 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet30 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet17 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet04 CLIPPED,'</TD>',
                  '<TD>',sr.price,'</TD>',
                  '<TD>',sr.total,'</TD>',
                  '<TD>',sr.qty1,'</TD>',
                  '<TD>',sr.qty2,'</TD>',
                  '<TD>',sr.cet15,'</TD>',
                  '<TD>',sr.wet,'</TD>',
                  '<TD class=xl24>',sr.cnb13 CLIPPED,'</TD>',
                  '<TD class=xl24>',sr.cet17 CLIPPED,'</TD>',
                  '</TR>'
      CALL lc_channel.write(g_str)
      LET l_n = l_n + 1
   END FOREACH
 
   IF l_n > 0 THEN
      LET g_str = '</TABLE>'
      CALL lc_channel.write(g_str)
      CALL lc_channel.close()
      IF g_lang = '2' THEN
         IF os.Path.separator() = "/" THEN        #Unix 環境    #FUN-A30038
            LET l_cmd = "iconv -f UTF-8 -t GBK -o ", l_name CLIPPED," ", m_file CLIPPED
         #FUN-A30038--add--str--FOR WINDOWS
         ELSE
            LET l_cmd = "java -cp zhcode.jar zhcode -8k ", l_name CLIPPED," ", m_file CLIPPED
         END IF
         #FUN-A30038--add--end
      ELSE
         LET l_cmd = "cp ", m_file CLIPPED," ", l_name CLIPPED
      END IF
      RUN l_cmd
      LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED
      IF NOT cl_download_file(m_file CLIPPED,"c:/tiptop/"|| l_name CLIPPED) THEN
         CALL s_errmsg('','',g_file_name,'amd-021',1) 
         LET g_success = 'N' 
      END IF
   ELSE
      CALL s_errmsg('','','','mfg3382',1) 
      LET g_success = 'N' 
   END IF
   CALL s_showmsg()    
END FUNCTION
 
#===================================
# 設定xml表頭
#===================================
FUNCTION p771_get_h_xml()
 
   LET g_str='<html xmlns:o="urn:schemas-microsoft-com:office:office"'
   CALL lc_channel.write(g_str)
   IF g_lang = '2' THEN
      LET g_str='  <meta http-equiv=Content-Type content="text/html; charset=GBK">'
   ELSE
      LET g_str='  <meta http-equiv=Content-Type content="text/html; charset=',ms_codeset,'">'
   END IF
   CALL lc_channel.write(g_str)
   LET g_str='      xmlns:x="urn:schemas-microsoft-com:office:excel"'
   CALL lc_channel.write(g_str)
   LET g_str='      xmlns="http://www.w3.org/TR/REC-html40">'
   CALL lc_channel.write(g_str)
   #LET g_str='  <head>'
   #CALL lc_channel.write(g_str)
   #LET g_str='  <style>'
   #CALL lc_channel.write(g_str)
   #LET g_str='    <!--td  pre'
   #CALL lc_channel.write(g_str)
   #LET g_str='            {margin:0cm;  margin-bottom:.0001pt;'
   #CALL lc_channel.write(g_str)
   #LET g_str='            font-size:12.0pt;'
   #CALL lc_channel.write(g_str)
   #LET g_str='            mso-bidi-font-family:"Courier New";} .xl24'
   #CALL lc_channel.write(g_str)
   #LET g_str='            {mso-number-format:"@";}-->'
   #CALL lc_channel.write(g_str)
   LET g_str = '<head><style><!--'
   CALL lc_channel.write(g_str)
   IF not ms_codeset.getIndexOf("UTF-8", 1) THEN
      IF g_lang = "0" THEN  #繁體中文
         LET g_str = 'td  {font-family:細明體, serif;}'
         CALL lc_channel.write(g_str)
      ELSE
         IF g_lang = "2" THEN  #簡體中文
            LET g_str = 'td  {font-family:新宋体, serif;}'
            CALL lc_channel.write(g_str)
         ELSE
            LET g_str = 'td  {font-family:細明體, serif;}'
            CALL lc_channel.write(g_str)
         END IF
      END IF
   ELSE
      LET g_str = 'td  {font-family:Courier New, serif;}'
      CALL lc_channel.write(g_str)
   END IF
   LET g_str=' .xl24   {mso-number-format:"@";}-->'
   CALL lc_channel.write(g_str)
   LET g_str='  </style>'
   CALL lc_channel.write(g_str)
   LET g_str='  <!--[if gte mso 9]>'
   CALL lc_channel.write(g_str)
   LET g_str='  <xml>'
   CALL lc_channel.write(g_str)
   LET g_str='    <x:ExcelWorkbook>'
   CALL lc_channel.write(g_str)
   LET g_str='    <x:ExcelWorksheets>'
   CALL lc_channel.write(g_str)
   LET g_str='    <x:ExcelWorksheet>'
   CALL lc_channel.write(g_str)
   LET g_str='    <x:Name>Sheet1</x:Name>'
   CALL lc_channel.write(g_str)
   CALL lc_channel.write(g_str)
   LET g_str='    <x:DefaultRowHeight>330</x:DefaultRowHeight>'
   CALL lc_channel.write(g_str)
   LET g_str='    <x:Selected/>'
   CALL lc_channel.write(g_str)
   LET g_str='    <x:DoDisplayGridlines/>'
   CALL lc_channel.write(g_str)
   CALL lc_channel.write(g_str)
   LET g_str='    </x:ExcelWorksheet>'
   CALL lc_channel.write(g_str)
   LET g_str='    </x:ExcelWorkbook>'
   CALL lc_channel.write(g_str)
   LET g_str='  </xml>'
   CALL lc_channel.write(g_str)
   LET g_str='  <![endif]-->'
   CALL lc_channel.write(g_str)
   LET g_str='  </head>'
   CALL lc_channel.write(g_str)
   LET g_str='  <div align=center>'
   CALL lc_channel.write(g_str)
   LET g_str='  <TABLE BORDER=1 CELLSPACING=0 CELLPADDING=0 STYLE="font-size: 12pt" >'
   CALL lc_channel.write(g_str)
   LET g_str='  <TR>',
             '<TD class=xl24>',cl_getmsg("aco-800",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-801",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-802",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-803",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-804",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-805",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-806",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-807",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-808",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-809",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-810",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-811",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-812",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-813",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-814",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-815",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-816",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-817",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-818",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-819",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-820",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-821",g_lang) CLIPPED,'</TD>',
             '</TR>'
   CALL lc_channel.write(g_str)
   LET g_str='  <TR>',
             '<TD class=xl24>',cl_getmsg("aco-822",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-823",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-824",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-825",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-826",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-827",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-828",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-829",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-830",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-831",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-832",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-833",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-834",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-835",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-836",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-837",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-838",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-839",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-840",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-841",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-842",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-843",g_lang) CLIPPED,'</TD>',
             '</TR>'
   CALL lc_channel.write(g_str)
END FUNCTION
 
#FUN-930151 
