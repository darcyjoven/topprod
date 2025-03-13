# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: acop763.4gl
# Descriptions...: 歸併前BOM資料匯出Excel作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A30038 09/03/09 By lutingting windows改用zhcode方式來進行轉碼 
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)

IMPORT os    #FUN-A30038 

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000  # Where condition    
              END RECORD
 
DEFINE m_tempdir        LIKE type_file.chr1000, 
       m_file           LIKE type_file.chr1000,
       g_file_name      LIKE type_file.chr1000,
       lc_channel      base.Channel,
       g_str           STRING
DEFINE ms_codeset      STRING  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   LET tm.wc       = ARG_VAL(1)	             # Get arguments from command line
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
      CALL p763_tm()                        # Input print condition
   ELSE
      CALL p763()                           # Read data and create out-file
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION p763_tm()
   DEFINE l_cmd		STRING,
          lc_zz08       LIKE zz_file.zz08,
          l_flag        LIKE type_file.num5
 
   OPEN WINDOW p763_w WITH FORM "aco/42f/acop763"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.wc TO NULL			# Default condition
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   
   WHILE TRUE
     ERROR ''
     LET tm.wc = ""
     CONSTRUCT BY NAME tm.wc ON cej01,cej02,cej03,cej04  #成品序號，BOM版本，特性碼，廠內料號
        BEFORE CONSTRUCT
             CALL cl_qbe_init()
        
        ON ACTION controlp
           CASE
             WHEN INFIELD(cej04)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_cej01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO cej04
               NEXT FIELD cej04
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
 
        ON ACTION exit               #genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
        ON ACTION qbe_select
           CALL cl_qbe_select()
     END CONSTRUCT
     IF g_action_choice = "locale" THEN  #genero
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
           IF  cl_null(g_file_name) THEN
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
           CALL cl_cmdask()	# Command execution
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
       SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01 = 'acop763'
        IF SQLCA.sqlcode OR lc_zz08 IS NULL THEN
            CALL cl_err('acop763','9031',1)   
        ELSE          
           LET tm.wc  = cl_replace_str(tm.wc,"'","\"")
           LET l_cmd = lc_zz08 CLIPPED,
                        " '",tm.wc CLIPPED,"'",
                        " '",g_file_name,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('acop763',g_time,l_cmd CLIPPED)
        END IF
        CLOSE WINDOW p763_w
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
     CALL p763()
    
     IF g_success = 'N' THEN
        CALL cl_end2(2) RETURNING l_flag
     END IF
     IF g_success = 'Y' THEN
        CALL cl_end2(1) RETURNING l_flag
     END IF
 
     IF l_flag THEN CONTINUE WHILE
     ELSE EXIT WHILE
     END IF
 
     IF NOT INT_FLAG THEN  
        CONTINUE WHILE
     ELSE
        EXIT WHILE
     END IF
 
     ERROR ""
   END WHILE
   CLOSE WINDOW p763_w
END FUNCTION
 
 
FUNCTION p763()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name
          l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT         
          l_cmd         STRING,                  
          l_n       	LIKE type_file.num5,          #No.FUN-710002 SMALLINT
          sr            RECORD
                        cej01  LIKE cej_file.cej02,    #成品序號
                        cej02  LIKE cej_file.cej02,    #BOM版本
                        cej03  LIKE cej_file.cej02,    #特性代碼
                        cej04  LIKE cej_file.cej04,    #成品料號
                        cej05  LIKE cej_file.cej05,    #歸併後序號
                        cek06  LIKE cek_file.cek06,    #料件料號
                        cek10  LIKE cek_file.cek10,    #單耗
                        cek11  LIKE cek_file.cek11     #耗損率
                        END RECORD,
          sr2           RECORD
                        cej01  LIKE cej_file.cej02,    #成品序號
                        cej02  LIKE cej_file.cej02,    #BOM版本
                        cej03  LIKE cej_file.cej02,    #特性代碼
                        cej04  LIKE cej_file.cej04,    #成品料號
                        cej05  LIKE cej_file.cej05,    #歸併後序號
                        cek06  LIKE cek_file.cek06,    #料件料號
                        cek10  LIKE cek_file.cek10,    #單耗
                        cek11  LIKE cek_file.cek11     #耗損率
                        END RECORD
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND cejuser = '",g_user,"'"
     #     END IF
 
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND cejgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #4群組權限
     #         LET tm.wc = tm.wc clipped," AND cejgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cejuser', 'cejgrup')
     #End:FUN-980030
 
 
 
     IF NOT cl_null(tm.wc) THEN
        LET l_sql = "SELECT cej01,cej02,cej03,cej04,cej05,'','',''",
                    "  FROM cej_file ",
                    " WHERE ",tm.wc CLIPPED,
                    "   AND cej07 = 'N'"     #未確認
       
     ELSE  CALL  cl_err('','9046','1')
           RETURN
     END IF
     LET g_success = 'Y'
     PREPARE p763_prepare FROM l_sql
     IF STATUS THEN
        LET g_success = 'N'
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE p763_cs CURSOR FOR p763_prepare
#------------產生Excel file ----------------
     
     LET l_name = g_file_name,'.xls'
     LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/", g_file_name CLIPPED
     LET lc_channel = base.Channel.create()
     CALL lc_channel.openFile(m_file,"w")
     CALL lc_channel.setDelimiter("")
     CALL p763_get_h_xml()
 
     CALL s_showmsg_init()           
     LET l_n = 0
     FOREACH p763_cs INTO sr.*
        IF STATUS THEN
           CALL s_errmsg('','',"foreach",SQLCA.sqlcode,1)
           LET g_success = 'N'       
           EXIT FOREACH
        END IF
 
        LET sr.cek06 = sr.cej04 CLIPPED 
        LET sr.cej04 = '0'
        LET sr.cek10 = '1'
        LET sr.cek11 = '1'
 
        #-->資料產生 cej_file
        LET g_str = '<TR>',
               '<TD class=xl24>',sr.cej04,'</TD>',         #(1)成品料號
               '<TD class=xl24>',sr.cek06,'</TD>',         #(2)料件料號
               '<TD>',sr.cek10,'</TD>',                    #(3)單耗
               '<TD>',sr.cek11,'</TD>',                    #(4)損耗
               '<TD class=xl24>',sr.cej02 CLIPPED,'</TD>', #(5)企業版本
               '<TD class=xl24>','-1','</TD>',             #(6)內部版本號(固定-1)
               '</TR>'
        CALL lc_channel.write(g_str)
        #
 
        LET l_sql = "SELECT cej01,cej02,cej03,cej04,cej05,cek06,cek10,cek11",
                    "  FROM cek_file ,cej_file ",
                    " WHERE cek01 = '",sr.cej01,"' ",
                    "   AND cek02 = '",sr.cej02,"' ",
                    "   AND cek03 = '",sr.cej03,"' ",
                    "   AND cek12 = '",sr.cej05,"' ",
                    "   AND cej01 = cek01 ",
                    "   AND cej02 = cek02 ",
                    "   AND cej03 = cek03 ",
                    "   AND cej05 = cek12 "
 
        PREPARE p763_prepare2 FROM l_sql
    
        IF STATUS THEN
           LET g_success = 'N'
           CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
        END IF
 
        DECLARE p763_cs2 CURSOR FOR p763_prepare2        
 
        FOREACH p763_cs2 INTO sr2.*
          IF STATUS THEN
             CALL s_errmsg('','',"foreach",SQLCA.sqlcode,1)
             LET g_success = 'N'       
             EXIT FOREACH
          END IF
 
          #-->資料產生
          #OUTPUT TO REPORT p763_rep(sr2.*)     #print cek_file資料
          #-->資料產生 cej_file
           LET g_str = '<TR>',
                  '<TD class=xl24>',sr2.cej04,'</TD>',        #(1)成品料號
                  '<TD class=xl24>',sr2.cek06,'</TD>',        #(2)料件料號
                  '<TD>',sr2.cek10,'</TD>',                   #(3)單耗
                  '<TD>',sr2.cek11,'</TD>',                   #(4)損耗
                  '<TD class=xl24>',sr2.cej02 CLIPPED,'</TD>',#(5)企業版本
                  '<TD class=xl24>','-1','</TD>',             #(6)內部版本號(固定-1)
                  '</TR>'
           CALL lc_channel.write(g_str)
 
            LET l_n = l_n + 1
        END FOREACH
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
FUNCTION p763_get_h_xml()
 
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
   #LET g_str='    <!--td pre'
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
             '<TD class=xl24>',cl_getmsg("aco-895",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-896",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-897",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-898",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-899",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-900",g_lang) CLIPPED,'</TD>',
             '</TR>'
   CALL lc_channel.write(g_str)
END FUNCTION
 
#FUN-930151
 
