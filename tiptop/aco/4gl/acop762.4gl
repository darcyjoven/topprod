# Prog. Version..: '5.30.06-13.03.28(00003)'     #
#
# Pattern name...: acop762.4gl
# Descriptions...: 歸併關係表匯出Excel作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0108 09/12/12 By destiny 画面增加资料状态栏位
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-CC0037 12/12/17 By Elise 修正簡體匯出xls為亂碼的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD			# Print condition RECORD
	wc  	LIKE type_file.chr1000  # Where condition    
      END RECORD
 
DEFINE g_cei01         LIKE cei_file.cei01
DEFINE g_cei15         LIKE cei_file.cei15    #No.FUN-9C0108
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
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET tm.wc       = ARG_VAL(1)	      # Get arguments from command line
   LET g_cei01     = ARG_VAL(2)
   LET g_file_name = ARG_VAL(3)
   LET g_bgjob     = ARG_VAL(4)
   LET g_cei15     = ARG_VAL(5)       #No.FUN-9C0108
   
   LET ms_codeset = cl_get_codeset()
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL p762_tm(0,0)                        # Input print condition
   ELSE
      CALL p762()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION p762_tm(p_row,p_col)
 DEFINE p_row,p_col	LIKE type_file.num5,        
        l_cmd		LIKE type_file.chr1000,     
        l_flag          LIKE type_file.num5
   LET p_row = 5  LET p_col = 17
 
   OPEN WINDOW p762_w AT p_row,p_col WITH FORM "aco/42f/acop762"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.wc TO NULL			# Default condition
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_cei15='N'              #No.FUN-9C0108    
 
   WHILE TRUE
     ERROR ''
     LET tm.wc = ""
     CONSTRUCT BY NAME tm.wc ON cei02,cei03
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
              WHEN INFIELD(cei03)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_cei06"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cei03
                NEXT FIELD cei03
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
     #No.FUN-9C0108--begin
#    INPUT g_cei01,g_file_name,g_bgjob FROM cei01,file_name,bg_job 
     INPUT g_cei01,g_cei15,g_file_name,g_bgjob FROM cei01,cei15,file_name,bg_job    
     #No.FUN-9C0108--end   
     
        AFTER FIELD cei01 
          #IF g_cei01 NOT MATCHES '[123]' THEN
          IF g_cei01 NOT MATCHES '[12]' THEN
             NEXT FIELD cei01
          END IF
        #No.FUN-9C0108--begin
        AFTER FIELD cei15 
          IF g_cei15 NOT MATCHES '[NY]' THEN
             NEXT FIELD cei15
          END IF          
        #No.FUN-9C0108--end
        
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
 
        ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
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
       SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01 = 'acop762'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('acop762','9031',1)   
        ELSE          
           LET tm.wc  = cl_replace_str(tm.wc,"'","\"")
           LET l_cmd = l_cmd CLIPPED,
                        " '",tm.wc CLIPPED,"'",
                        " '",g_cei01 CLIPPED,"'",
                        " '",g_file_name,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_cei15 CLIPPED,"'"           #No.FUN-9C0108
           CALL cl_cmdat('acop762',g_time,l_cmd CLIPPED)
        END IF
        CLOSE WINDOW p762_w
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
     CALL p762()
    
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
   CLOSE WINDOW p762_w
END FUNCTION
 
 
FUNCTION p762()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name     
          l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT             
          l_chr		LIKE type_file.chr1,          
          l_cmd         STRING,                      
          l_za05	LIKE za_file.za05,        
          i       	LIKE type_file.num5,          
          l_n       	LIKE type_file.num5,          
          l_length	LIKE type_file.num5,          
          l_flag        LIKE type_file.num5,
          l_fac         LIKE cei_file.cei10,
 
          sr     RECORD
                   cei01      LIKE cei_file.cei01, 	
                   cei03      LIKE cei_file.cei03, 	
                   cei04      LIKE cei_file.cei04,
                   cei05      LIKE cei_file.cei05,
                   cei06      LIKE cei_file.cei06,
                   cei07      LIKE cei_file.cei07,   
                   cei08      LIKE cei_file.cei08,
                   cei09      LIKE cei_file.cei09,
                   cei10      LIKE cei_file.cei10,
                   cei11      LIKE cei_file.cei11,
                   cei12      LIKE cei_file.cei12,
                   cei13      LIKE cei_file.cei13,
                   cei14      LIKE cei_file.cei14,
                   cei20      LIKE cei_file.cei20,
                   ima02      LIKE ima_file.ima02,
                   ima021     LIKE ima_file.ima021, 
                   cef02   LIKE cef_file.cef02,
                   ceg09   LIKE ceg_file.ceg09,
                   cee02   LIKE cee_file.cee02,
                   cee02_2 LIKE cee_file.cee02,
                   cee02_3 LIKE cee_file.cee02,
                   transfer_num LIKE cei_file.cei10
                 END RECORD
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ceiuser = '",g_user,"'"
     #     END IF
 
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ceigrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #群組權限
     #         LET tm.wc = tm.wc clipped," AND ceigrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ceiuser', 'ceigrup')
     #End:FUN-980030
 
 
     IF NOT cl_null(tm.wc) THEN
        LET l_sql = "SELECT cei01,cei03,cei04,cei05,cei06,",
                    "       cei07,cei08,cei09,cei10,cei11,",
                    "       cei12,cei13,cei14,cei20,",
                    "       '','','','','','','',0",
                    " FROM  cei_file ",
                    " WHERE ",tm.wc CLIPPED,
                    " AND cei01 = '",g_cei01,"' ",
#                    " AND cei15 = 'N'"                #No.FUN-9C0108
                    " AND cei15 = '",g_cei15,"'"       #No.FUN-9C0108
     ELSE  
        CALL  cl_err('','9046','1')
        RETURN
     END IF
     LET g_success = 'Y'
 
     PREPARE p762_prepare FROM l_sql
     IF STATUS THEN
        LET g_success = 'N'
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
     END IF
 
     DECLARE p762_cs CURSOR FOR p762_prepare
    
#------------產生Excel file ----------------
     
     LET l_name = g_file_name,'.xls'
     LET m_file = FGL_GETENV("TEMPDIR") CLIPPED,"/", g_file_name CLIPPED
     LET lc_channel = base.Channel.create()
     CALL lc_channel.openFile(m_file,"w")
     CALL lc_channel.setDelimiter("")
     CALL p762_get_h_xml()
 
     CALL s_showmsg_init()           
 
     LET l_n = 0
     FOREACH p762_cs INTO sr.*
       IF STATUS THEN
          CALL s_errmsg('','',"foreach",SQLCA.sqlcode,1)
          LET g_success = 'N'       
          EXIT FOREACH
       END IF
 
       SELECT ima02,ima021 INTO sr.ima02,sr.ima021
         FROM ima_file
        WHERE ima01 = sr.cei03
 
       SELECT cef02 INTO sr.cef02
         FROM cef_file
        WHERE cef01 = sr.cei05
 
       SELECT ceg09 INTO sr.ceg09 
         FROM ceg_file
        WHERE ceg01 = sr.cei04
 
 
       IF NOT cl_null(sr.cei08) THEN
          SELECT cee02 INTO sr.cee02 FROM cee_file WHERE 
                 cee01 = sr.cei08
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','',"sel cee02",SQLCA.SQLCODE,0)
             LET sr.cee02 = ""
          END IF
       END IF 
 
       IF NOT cl_null(sr.cei09) THEN
          SELECT cee02 INTO sr.cee02_2 FROM cee_file WHERE
                cee01 = sr.cei09
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','',"sel cee02_2",SQLCA.SQLCODE,0)
             LET sr.cee02_2 = ""
          END IF
       END IF
 
       IF NOT cl_null(sr.cei07) THEN
           SELECT cee02 INTO sr.cee02_3 FROM cee_file WHERE
                 cee01 = sr.cei07
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('','',"sel cee02_3",SQLCA.SQLCODE,0)
              LET sr.cee02_3 = ""
           END IF
       END IF
       
       IF sr.cei07 = sr.cei08 THEN
          LET sr.transfer_num = 1
       ELSE
          CALL s_umfchk(sr.cei03,sr.cei08,sr.cei07) RETURNING l_flag,l_fac
          IF l_flag = '0' THEN
             LET sr.transfer_num = l_fac
          ELSE
             CALL s_errmsg('','',"tramsfer factor error",'',0)
             LET sr.transfer_num = ""
          END IF
       END IF
 
       
     #-->資料產生
      LET g_str = '<TR>',
             '<TD>',g_cei01,'</TD>',              #(1)g_cei01 報關商品類型 1:成品 2:材料 3:半成品
             '<TD>',sr.cei11,'</TD>',             #(2)報關商品序號
             '<TD class=xl24>',sr.cei04,'</TD>',  #(3)海關商品編號
             '<TD class=xl24>',' ','</TD>',           #(4)附加商品編號 (不給值)
             '<TD class=xl24>',sr.cei12 CLIPPED,'</TD>', #(5)海關商品名稱
             '<TD class=xl24>',sr.cei13 CLIPPED,'</TD>',  #(6)海關商品規格
             '<TD class=xl24>',sr.cee02 CLIPPED,'</TD>',  #(7)申報計量單位(海關單位代號)
             '<TD class=xl24>',sr.cef02 CLIPPED,'</TD>',  #(8)申報幣別(海關幣別代號)
             '<TD>',sr.cei14,'</TD>',                     #(9)申報單價
             '<TD class=xl24>',' ','</TD>',               #(10)原產國(不給值)
             '<TD class=xl24>',sr.cee02_2 ,'</TD>',       #(11)法定單位一
             '<TD class=xl24>',' ','</TD>',               #(12)法定單位二(不給值)
             '<TD>','</TD>',                            #(13)報關商品毛重(不給值)
             '<TD>','</TD>',                            #(14)報關商品淨重(不給值)
             '<TD>','</TD>',                            #(15)加工費(不給值)
             '<TD>','</TD>',                            #(16)利潤(不給值)
             '<TD class=xl24>',sr.ceg09 CLIPPED,'</TD>',  #(17)海關商品大類
             '<TD>',sr.cei10,'</TD>',                     #(18)申報單位元和第一法定單位比例因數
             '<TD>','</TD>',                            #(19)申報單位元和第二法定單位比例因數(不給值)
             '<TD>','</TD>',                            #(20)重量比例因子(不給值)
             '<TD class=xl24>',sr.cei20 CLIPPED,'</TD>',  #(21)歸併後貨號
             '<TD class=xl24>',sr.cei03 CLIPPED,'</TD>',  #(22)企業料號
             '<TD class=xl24>',sr.ima02 CLIPPED,'</TD>',  #(23)企業商品名稱
             '<TD class=xl24>',sr.ima021 CLIPPED,'</TD>', #(24)企業商品規格
             '<TD>',g_cei01,'</TD>',                      #(25)企業商品類型 1:成品  2:材料
             '<TD class=xl24>',sr.cee02_3 CLIPPED,'</TD>',#(26)企業單位一
             '<TD class=xl24>',' ','</TD>',               #(27)企業單位二(不給值)
             '<TD>',sr.cei06,'</TD>',                     #(28)企業商品單價
             '<TD class=xl24>',sr.cef02 CLIPPED,'</TD>',  #(29)企業商品單價幣別
             '<TD>','</TD>',                            #(30)企業商品毛重(不給值)
             '<TD>','</TD>',                            #(31)企業商品淨重(不給值)
             '<TD>',sr.transfer_num,'</TD>',              #(32)轉換率一（企業單位一與申報單位元轉換率）
             '<TD>','</TD>',                            #(33)轉換率二(不給值)
             '<TD>','</TD>',                            #(34)轉換率三(不給值)
             '<TD>','</TD>',                            #(35)轉換率四(不給值)
             '<TD>','</TD>',                            #(36)轉換率五(不給值)
             '<TD>','</TD>',                            #(37)轉換率六(不給值)
             '<TD>','</TD>',                            #(38)轉廠標記(不給值)
             '<TD class=xl24>',' ','</TD>',               #(39)默認供應商(不給值)
             '<TD>','</TD>',                              #(40)套裝標記(不給值)
             '<TD class=xl24>',' ','</TD>',               #(41)備註(不給值)
             '<TD>','</TD>',                              #(42)申報單位元和第一法定單位比例因數(不給值)
             '<TD>','</TD>',                              #(43)申報單位元和第二法定單位比例因數(不給值)
             '<TD>','</TD>',                              #(44)重量比例因子(不給值)
             '<TD>','</TD>',                              #(45)申報單價(不給值)
             '</TR>'
      CALL lc_channel.write(g_str)
      #################
       LET l_n = l_n + 1
    END FOREACH
                                                                                                                          
   IF l_n > 0 THEN
      LET g_str = '</TABLE>'
      CALL lc_channel.write(g_str)
      CALL lc_channel.close()
 
      CALL cl_prt_convert(m_file)
      LET l_cmd = "cp ", m_file CLIPPED," ", l_name CLIPPED
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
FUNCTION p762_get_h_xml()
 
   LET g_str='<html xmlns:o="urn:schemas-microsoft-com:office:office"'
   CALL lc_channel.write(g_str)
   IF g_lang = '2' THEN
     #LET g_str='  <meta http-equiv=Content-Type content="text/html; charset=GBK">'     #MOD-CC0037 mark 
      LET g_str='  <meta http-equiv=Content-Type content="text/html; charset=UTF-8">'   #MOD-CC0037
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
             '<TD class=xl24>',cl_getmsg("aco-850",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-851",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-852",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-853",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-854",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-855",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-856",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-857",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-858",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-859",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-860",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-861",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-862",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-863",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-864",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-865",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-866",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-867",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-868",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-869",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-870",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-871",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-872",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-873",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-874",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-875",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-876",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-877",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-878",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-879",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-880",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-881",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-882",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-883",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-884",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-885",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-886",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-887",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-888",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-889",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-890",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-891",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-892",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-893",g_lang) CLIPPED,'</TD>',
             '<TD class=xl24>',cl_getmsg("aco-894",g_lang) CLIPPED,'</TD>',
             '</TR>'
   CALL lc_channel.write(g_str)
END FUNCTION
 
#FUN-930151
