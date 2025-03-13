# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: acop773.4gl
# Descriptions...: 進口報關資料匯出Excel作業(電子帳冊)
# Date & Author..: FUN-930151 09/05/13 BY rainy 
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
DEFINE 
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
      CALL p773_tm(0,0)                        # Input print condition
   ELSE
      CALL p773()                              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
#===================================
# 開窗輸入條件
#===================================
FUNCTION p773_tm(p_row,p_col)
   DEFINE p_row,p_col      LIKE type_file.num5,
          l_cmd            LIKE type_file.chr1000,
          l_flag           LIKE type_file.num5
 
   OPEN WINDOW p773_w AT p_row,p_col WITH FORM "aco/42f/acop773"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   INITIALIZE tm.wc TO NULL                  # Default condition
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
 
   WHILE TRUE
      ERROR ''
      LET tm.wc = ""
      CONSTRUCT BY NAME tm.wc ON ceu01,ceu03,ceu05,ceu04,ceu11  
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE WHEN INFIELD(ceu01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_ceu01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceu01
                 WHEN INFIELD(ceu05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_pmc"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ceu05
                 WHEN INFIELD(ceu04)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form  = "q_ima"
                 #   LET g_qryparam.state = "c"
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO ceu04
                 WHEN INFIELD(ceu11)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form  = "q_rva09"
                      LET g_qryparam.state = "c"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO ceu11
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
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01 = 'acop773'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('acop773','9031',1)   
         ELSE          
            LET tm.wc  = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",tm.wc CLIPPED,"'",
                        " '",g_file_name,"'",
                        " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('acop773',g_time,l_cmd CLIPPED)
         END IF
         CLOSE WINDOW p773_w
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
      CALL p773()
    
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
   CLOSE WINDOW p773_w
END FUNCTION
 
 
#===================================
# 開始處理資料
#===================================
FUNCTION p773()
   DEFINE l_name        LIKE type_file.chr20,    # External(Disk) file name
          l_sql         STRING,                  # RDSQL STATEMENT
          l_cmd         STRING,
          l_n           LIKE type_file.num5,
          l_rvb88t      LIKE rvb_file.rvb88t,       #原幣單價  #總價
          l_rvw12       LIKE rvw_file.rvw12,        #匯率
          l_cei05       LIKE cei_file.cei05,        #幣別
          l_cei10       LIKE cei_file.cei10,        #第一法定計量單位轉換比率
          l_cei18       LIKE cei_file.cei18,        #第二法定單位轉換率
          l_rate        LIKE azj_file.azj03,        #匯率
          l_cod02       LIKE cod_file.cod02,
          l_rvw11       LIKE rvw_file.rvw11,        #幣別海關代碼
          l_cei09       LIKE cei_file.cei09,        #單位海關代碼
          l_cei17       LIKE cei_file.cei17,        #單位海關代碼
          l_ceu16       LIKE cee_file.cee02,        #單位海關代碼
          l_ceu02       LIKE ceu_file.ceu02,        #項次
          l_ceu04       LIKE ceu_file.ceu04,        #海關料號
          l_ceu01       LIKE ceu_file.ceu01,        #單據編號
 
          sr            RECORD
                        ceu01    LIKE ceu_file.ceu01,       #單據編號
                        ceu02    LIKE ceu_file.ceu02,       #項次
                        ceu04    LIKE ceu_file.ceu04,       #料件編號
                        ceu08    LIKE ceu_file.ceu08,       #報單日期
                        ima02    LIKE ima_file.ima02,       #品名
                        ima021   LIKE ima_file.ima021,      #規格     
                        ceu10    LIKE ceu_file.ceu10,       #商品編號
                        ceu13    LIKE ceu_file.ceu13,       #異動數量
                        ceu15    LIKE ceu_file.ceu15,       #異動數量(合同)
                        ceu16    LIKE ceu_file.ceu16,       #異動單位(合同)
                        price    LIKE rvb_file.rvb10,       #單價
                        total    LIKE type_file.num26_10,   #總價
                        net      LIKE type_file.num26_10,   #淨重(KGS)
                        rvw11    LIKE cef_file.cef02,       #幣值 
                        cei09    LIKE cee_file.cee02,       #法定單位一
                        net10    LIKE type_file.num26_10,   #淨重(KGS)
                        cei17    LIKE cee_file.cee02,       #法定單位一
                        net18    LIKE type_file.num26_10,   #淨重(KGS)
                        ceu29    LIKE ceu_file.ceu29,       #用途
                        ceu31    LIKE ceu_file.ceu31,       #歸併後序號
                        ceu32    LIKE ceu_file.ceu32,        #產銷國
                        ceu33    LIKE ceu_file.ceu33,       #征免方式
                        ceu11    LIKE ceu_file.ceu11,       #INVOICE No 
                        ceu19    LIKE ceu_file.ceu19         #收貨單項次
                        END RECORD
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND ceuuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND ceugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN              #群組權限
   #      LET tm.wc = tm.wc clipped," AND ceugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ceuuser', 'ceugrup')
   #End:FUN-980030
 
   IF cl_null(tm.wc) THEN LET tm.wc = " 1=1" END IF
   
 
   LET l_sql = "SELECT ceu01,ceu02,ceu04, ceu08,ima02,ima021, ",
               "       ceu10,ceu13,ceu15,ceu16,",
               "       0,0,0,'','',0,'',0,",
               "       ceu29,ceu31,ceu32,ceu33,ceu11,ceu19 ", 
               "  FROM ceu_file,ima_file ",
               "  WHERE ceu04 = ima_file.ima01 ",
               "   AND ceuacti = 'Y' AND ceuconf='Y' ",
               "   AND ", tm.wc CLIPPED ," ORDER BY ceu01,ceu02,ceu04 "
               
   Display "l_sql:",l_sql
   LET g_success = 'Y'
   PREPARE p773_prepare FROM l_sql
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
   END IF
   DECLARE p773_cs CURSOR FOR p773_prepare
    
 
  #------------產生Excel file ----------------
   LET l_name = g_file_name CLIPPED,'.xls'
   LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/", g_file_name CLIPPED 
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile(m_file,"w")
   CALL lc_channel.setDelimiter("")
   CALL p773_get_h_xml()
 
   CALL s_showmsg_init()           
 
   LET l_n = 0
  
   LET l_ceu01=NULL  #單據編號
   LET l_ceu02=NULL  #項次
   LET l_ceu04=NULL  #料號 
   
   FOREACH p773_cs INTO sr.*
   
      IF STATUS THEN
         CALL s_errmsg('','',"foreach",SQLCA.sqlcode,1)
         LET g_success = 'N'       
         EXIT FOREACH
      END IF
      
     
      IF l_ceu02=sr.ceu02 AND l_ceu04=sr.ceu04 AND l_ceu01=sr.ceu01 THEN
        CONTINUE FOREACH
      END IF
 
   {# SELECT rvb10,rvw11,rvw12
    #  INTO l_rvb10,sr.rvw11,l_rvw12
    #  FROM rvb_file, OUTER rvw_file
    # WHERE rvb01 = sr.ceu01
    #   AND rvb02 = sr.ceu02
    #   AND rvb22 = rvw_file.rvw01  }   
         
      DECLARE p773_cei_cs CURSOR FOR
         SELECT cei05,cei09,cei10,cei17,cei18  #幣別,法定計量單位,法定計量轉換率,法二單位,法二轉換率
           FROM cei_file
          WHERE cei03 = sr.ceu04
      OPEN p773_cei_cs
      FETCH p773_cei_cs INTO l_cei05,l_cei09,l_cei10,l_cei17,l_cei18
      CLOSE p773_cei_cs
    
    
      SELECT cee02 INTO l_ceu16 FROM cee_file 
      WHERE cee01=sr.ceu16
      
      SELECT cee02 INTO sr.cei09 FROM cee_file 
      WHERE cee01=l_cei09
    
      SELECT cee02 INTO sr.cei17 FROM cee_file 
      WHERE cee01=l_cei17
      
    
      
   {#IF sr.rvw11 = l_cei05 THEN
    #   LET sr.price = l_rvb10 * sr.ceu13 / sr.ceu15
    #ELSE
    #   LET l_rate = s_curr(l_cei05,g_today)
    #   IF NOT cl_null(g_errno) THEN
    #      CALL s_errmsg('curr',l_cei05,"s_curr",g_errno,1)
    #   END IF
    #   LET sr.price = l_rvb10 * l_rvw12 / l_rate * sr.ceu13 / sr.ceu15
    #END IF   }
 
      SELECT rvb88t,pmm22 INTO l_rvb88t,l_rvw11 
        FROM rvb_file,pmm_file,ima_file 
       WHERE rvb04=pmm01
         AND rvb01=sr.ceu01 AND ima01=sr.ceu04 
         AND rvb05=ima01   AND rvb02=sr.ceu19 
      LET sr.total=l_rvb88t    
      
     #海關幣別代碼
      SELECT cef02 INTO sr.rvw11 FROM cef_file   
      WHERE  cef01=l_rvw11      
      
      IF sr.total IS NULL THEN LET sr.total = 0 END IF   #總價
      LET sr.price =sr.total  / sr.ceu15                 #單價
 
     #-->淨重
      LET sr.net = 0
     #-->法定數量一
      LET sr.net10 = sr.ceu15 * l_cei10
     #-->法定數量二
      IF NOT cl_null(l_cei17) THEN
        LET sr.net18 = sr.ceu15 * l_cei18
      END IF
     
     IF sr.net10 IS NULL THEN LET sr.net10=0 END IF
     
     IF sr.net18 IS NULL THEN LET sr.net18=0 END IF
    
     
 
     #-->資料產生
      LET g_str = '<TR>',
                  '<TD class=xl24>',sr.ceu04 CLIPPED,'</TD>',                    #(1)料號
                  '<TD class=xl24>',sr.ceu08 USING "yyyy-mm-dd" CLIPPED,'</TD>', #(2)報關日期
                  '<TD class=xl24>',sr.ceu11 CLIPPED,'</TD>',                    #(3)報關清單號碼(收貨單號)
                  '<TD class=xl24>',sr.ima02 CLIPPED,'</TD>',                    #(4)品名(ima02)
                  '<TD class=xl24>',sr.ima021 CLIPPED,'</TD>',                   #(5)規格(ima021)
                  '<TD>',sr.ceu15,'</TD>',                                       #(6)合同數量
                  '<TD class=xl24>',l_ceu16 CLIPPED,'</TD>',                     #(7)單位
                  '<TD>',sr.price,'</TD>',                                       #(8)單價
                  '<TD>',sr.total,'</TD>',                                       #(9)總價
                  '<TD>',sr.net,'</TD>',                                         #(10)淨重    
                  '<TD class=xl24>',sr.rvw11 CLIPPED,'</TD>',                    #(11)幣別
                  '<TD class=xl24>',sr.cei09 CLIPPED,'</TD>',                    #(12)法定單位一
                  '<TD>',sr.net10,'</TD>',                                       #(13)法定數量一
                  '<TD class=xl24>',sr.cei17 CLIPPED,'</TD>',                    #(14)法定單位二
                  '<TD>',sr.net18,'</TD>',                                       #(15)法定數量二
                  '<TD class=xl24>',sr.ceu32 CLIPPED,'</TD>',                    #(16)產銷國
                  '<TD class=xl24>',sr.ceu29 CLIPPED,'</TD>',                    #(17)用途
                  '<TD class=xl24>',sr.ceu33 CLIPPED,'</TD>',                    #(18)征免方式
                  '</TR>'
      CALL lc_channel.write(g_str)
      LET l_n = l_n + 1
      
      LET l_ceu01=NULL
      LET l_ceu02=NULL
      LET l_ceu04=NULL 
      LET l_ceu01=sr.ceu01  
      LET l_ceu02=sr.ceu02
      LET l_ceu04=sr.ceu04   
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
FUNCTION p773_get_h_xml()
 
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
             '<TD class=xl24>',cl_getmsg("aco-901",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-902",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-903",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-904",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-905",g_lang) CLIPPED,'</TD>', 
             '<TD class=xl24>',cl_getmsg("asm-013",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("asm-011",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-906",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-907",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-908",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-909",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-860",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-910",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-861",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-911",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-912",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("anm-167",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-913",g_lang) CLIPPED,'</TD>',
             '</TR>'
   CALL lc_channel.write(g_str)
END FUNCTION
#FUN-930151 
