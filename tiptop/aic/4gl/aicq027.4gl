# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aicq027.4gl
# Descriptions...: 料件刻號BIN庫存卡查詢作業
# Date & Author..: 08/01/20  by lilingyu
# Modify.........: 08/03/20 No.FUN-830083 by hellen 過單
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30160 10/07/16 By Pengu 由aimq231串查時會查不到資料
# Modify.........: No:TQC-B90036 11/09/05 By lilingyu fetch函數裡面g_img.img02/img03/img04的值為NULL，無法選出資料
# Modify.........: No:TQC-C30003 12/03/01 By bart 修改程式無法查詢
# Modify.........: No:TQC-C30310 12/03/27 By bart 程式查詢不需與月檔綁在一起
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     tm  RECORD
        #	wc     LIKE type_file.chr1000,
        #	wc2    LIKE type_file.chr1000 
        wc,wc2   STRING              #NO.FUN-910082
        END RECORD,
    g_img  RECORD
            img01      LIKE img_file.img01,    #料件編號
            img02      LIKE img_file.img02,    #倉庫編號
            img03      LIKE img_file.img03,    #存放位置
            img04      LIKE img_file.img04,    #批號
            img09      LIKE img_file.img09,    #單位
            img10      LIKE img_file.img10     #目前庫存
        END RECORD,
    g_bdate            DATE,                   #期初庫存
    g_yy               LIKE type_file.num5 ,
    g_mm               LIKE type_file.num5 ,
    g_edate            DATE,                
 
    g_imk09	       LIKE imk_file.imk09,    #期初庫存
    g_ima02	       LIKE ima_file.ima02,    #品名
    g_ima021	       LIKE ima_file.ima02,    #品名 
    g_ima08	       LIKE ima_file.ima08,    #來源碼
    g_pia30	       LIKE pia_file.pia30,    #初盤量
    g_pia50	       LIKE pia_file.pia50,    #復盤量
    g_year 	  	LIKE imk_file.imk05,   #年度
    g_month 	        LIKE imk_file.imk06,   #期別
    g_idd         DYNAMIC ARRAY OF RECORD
            idd08      LIKE idd_file.idd08,    #產生日期
            cond       LIKE type_file.chr14,   #異動情況
            idd30      LIKE idd_file.idd30,    #來源單號
            idd10      LIKE idd_file.idd10,    #目的單號
            idd15      LIKE idd_file.idd15,    #母體料號
            idd16      LIKE idd_file.idd16,    #母批
            idd05      LIKE idd_file.idd05,    #刻號
            idd06      LIKE idd_file.idd06,    #BIN值
            idd13      LIKE idd_file.idd13,    #異動數量
            idd18      LIKE idd_file.idd18,    #DIE數
            idd07      LIKE idd_file.idd07,    #FROM單位
            idd29      LIKE idd_file.idd29     #FROM異動后數量
        END RECORD,
    g_cmd              LIKE type_file.chr1000,     
    g_tlf13            LIKE tlf_file.tlf13,    #異動命令
    g_tlf08            LIKE tlf_file.tlf08,    #TIME
    g_tlf12            LIKE tlf_file.tlf12,        
    g_tlf03            LIKE tlf_file.tlf03,         
    g_tlf031           LIKE tlf_file.tlf031, 
    g_tlf032           LIKE tlf_file.tlf032, 
    g_tlf033           LIKE tlf_file.tlf033, 
    g_tlf034           LIKE tlf_file.tlf034,   #TO 異動后數量
    g_tlf035           LIKE tlf_file.tlf035,   #TO 單位
    g_query_flag       LIKE type_file.num5 ,   #第一次進入程式即進入QUERY之后進入next
     g_sql             STRING,                
     g_argv1           LIKE img_file.img01,   
     g_argv2           LIKE img_file.img02,   
     g_argv3           LIKE img_file.img03,   
     g_argv4           LIKE img_file.img04,  
     g_argv5           LIKE idd_file.idd08,
     g_argv6           LIKE idd_file.idd10, 
     g_argv7,g_argv8   LIKE type_file.num5 ,
    i,m_cnt            LIKE type_file.num10,
    g_rec_b            LIKE type_file.num5 
DEFINE   g_cnt         LIKE type_file.num10  
DEFINE   g_msg         LIKE type_file.chr1000
DEFINE   g_row_count   LIKE type_file.num10  
DEFINE   g_curs_index  LIKE type_file.num10  
DEFINE   g_jump        LIKE type_file.num10  
DEFINE   g_no_ask     LIKE type_file.num5 
 
MAIN
   OPTIONS                                
        INPUT NO WRAP
    DEFER INTERRUPT                        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry("icd") THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2) 
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4) 
    LET g_argv5 = ARG_VAL(5)
    LET g_argv6 = ARG_VAL(6)
    LET g_argv7 = ARG_VAL(7)
    LET g_argv8 = ARG_VAL(8)
    LET g_msg=MDY(g_today USING 'mm',1,g_today USING 'yy')    
    CALL s_yp(g_today) RETURNING g_yy,g_mm  
    LET g_query_flag=1
 
   #-----------No:MOD-A30160 add
    IF NOT cl_null(g_argv7) THEN 
       LET g_year = g_argv7
    END IF

    IF NOT cl_null(g_argv8) THEN 
       LET g_month = g_argv8
    END IF
   #-----------No:MOD-A30160 end

    OPEN WINDOW q027_w WITH FORM "aic/42f/aicq027" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
     IF NOT cl_null(g_argv1) THEN    
       CALL q027_q()
    END IF
 
    CALL q027_menu()
    CLOSE WINDOW q027_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q027_curs()
   DEFINE   l_cnt       LIKE type_file.num5 
   DEFINE   l_azm02     LIKE azm_file.azm02
    
   CLEAR FORM 
   CALL g_idd.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL	
   IF g_argv1 != ' ' THEN
      LET tm.wc = " img01 = '",g_argv1,"' AND img02 = '",g_argv2,"' ",
                  " AND img03 = '",g_argv3,"' AND img04 = '",g_argv4,"' "
      LET tm.wc2= " idd02 = '",g_argv2,"'",
                 " AND idd03 = '",g_argv3,"' AND idd04 = '",g_argv4,"' ",
		 " AND idd08 = '",g_argv5,"' AND idd10 = '",g_argv6,"' "
      DISPLAY g_argv1 TO img01
      DISPLAY g_argv2 TO img02
      DISPLAY g_argv3 TO img03
      DISPLAY g_argv4 TO img04
      LET g_yy = g_argv7
      LET g_mm = g_argv8
      DISPLAY g_yy TO FORMONLY.yy
      DISPLAY g_mm TO FORMONLY.mm           
   ELSE 
      CONSTRUCT BY NAME tm.wc ON img01, ima02,ima021,img02, img03, img04           
        BEFORE CONSTRUCT
          CALL cl_qbe_init()
           
        ON ACTION CONTROLP
           CASE WHEN INFIELD(img01) #料件編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_ima"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO img01
         	     NEXT FIELD img01
               OTHERWISE EXIT CASE
           END CASE
         
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about        
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help() 
 
        ON ACTION controlg     
           CALL cl_cmdask()     
  
        ON ACTION qbe_select
           CALL cl_qbe_select() 
         
        ON ACTION qbe_save
	   CALL cl_qbe_save()
 	
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
     
      INPUT g_yy,g_mm WITHOUT DEFAULTS FROM yy,mm  
        BEFORE FIELD yy
          IF NOT cl_null(g_argv1) OR g_argv1 <> ' ' THEN
             EXIT INPUT
          END IF
        
        AFTER FIELD yy
          IF g_yy IS NULL OR g_yy < 999 OR g_yy>2100 THEN
             NEXT FIELD yy
          END IF
     
        AFTER FIELD mm
          IF g_mm IS NULL OR g_mm <1 OR g_mm>13  THEN
             NEXT FIELD mm
          END IF
 
        AFTER INPUT
          IF INT_FLAG THEN
             LET INT_FLAG = 0
             RETURN       
          END IF
          IF cl_null(g_yy) THEN 
             CALL cl_err('','aic-084',0) NEXT FIELD yy   
          END IF
          IF cl_null(g_mm) THEN
             CALL cl_err('','aic-084',0) NEXT FIELD mm   
          END IF
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help         
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()     
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   
      CALL s_lsperiod(g_yy,g_mm) RETURNING g_year,g_month
      CALL s_azn01(g_yy,g_mm)   RETURNING g_bdate,g_edate
      LET tm.wc2 = " idd08>= '",g_bdate,"'"           
      MESSAGE ' WAIT ' 
    END IF
 
#   LET g_sql= " SELECT img01,ima02,ima021,ima08,img10,imk09 ",                     #TQC-B90036
    LET g_sql= " SELECT img01,ima02,ima021,ima08,img10,imk09,img02,img03,img04 ",   #TQC-B90036
               #TQC-C30310---begin
               " FROM ima_file ",
               " INNER JOIN img_file ON ima_file.ima01 = img_file.img01 ",
               " LEFT OUTER JOIN imk_file ON (imk_file.imk01 = img_file.img01 AND imk_file.imk02 = img_file.img02 ",   
               " AND  imk_file.imk03 = img_file.img03 AND   imk_file.imk04 = img_file.img04 ",        
               " AND  imk_file.imk05 ='",g_year,"'"," AND  imk_file.imk06 ='",g_month,"')",
               #" FROM img_file,ima_file,imk_file ",    
               #" WHERE ima_file.ima01 = img01 ",       
               #" AND   imk_file.imk01 = img01 ",       
               #" AND   imk_file.imk02 = img02 ",      
               #" AND   imk_file.imk03 = img03 ",       
               #" AND   imk_file.imk04 = img04 ",        
               #" AND   imk_file.imk05 ='",g_year,"'",  
               #" AND   imk_file.imk06 ='",g_month,"'",  
               #" AND   imk_file.imk05 ='",g_yy,"'",        
               #" AND   imk_file.imk06 ='",g_mm,"'",  
               #" AND ",tm.wc CLIPPED,   
               " WHERE ",tm.wc CLIPPED,
               #TQC-C30310---end
               " ORDER BY img01"
    PREPARE q027_prepare FROM g_sql
    DECLARE q027_cs SCROLL CURSOR FOR q027_prepare 
    #取合乎條件的筆數,若使用組合鍵值,則可以使用本方法去得到筆數值
    LET g_sql=" SELECT COUNT(*) ",
               #TQC-C30003---begin
               #" FROM img_file ",          
               #" WHERE ",tm.wc CLIPPED 
               #TQC-C30310---begin  
               " FROM ima_file ",            
               " INNER JOIN img_file ON ima_file.ima01 = img_file.img01 ",        
               " LEFT OUTER JOIN imk_file ON (imk_file.imk01 = img_file.img01 AND imk_file.imk02 = img_file.img02 ",   
               " AND  imk_file.imk03 = img_file.img03 AND   imk_file.imk04 = img_file.img04 ", 
               " AND  imk_file.imk05 ='",g_year,"'"," AND  imk_file.imk06 ='",g_month,"')",     
               #" FROM img_file,ima_file,imk_file ",    
               #" WHERE ima_file.ima01 = img01 ",      
               #" AND   imk_file.imk01 = img01 ",     
               #" AND   imk_file.imk02 = img02 ",      
               #" AND   imk_file.imk03 = img03 ",     
               #" AND   imk_file.imk04 = img04 ",     
               #" AND   imk_file.imk05 ='",g_yy,"'",    
               #" AND   imk_file.imk06 ='",g_mm,"'",
               #" AND ",tm.wc CLIPPED
               " WHERE ",tm.wc CLIPPED 
               #TQC-C30310---end  
               #TQC-C30003---end
    PREPARE q027_pp  FROM g_sql
    DECLARE q027_count   CURSOR FOR q027_pp
END FUNCTION
 
FUNCTION q027_b_askkey()
   CONSTRUCT tm.wc2 ON idd08,idd30,idd10,idd15,idd16,idd05,
             idd06,idd13,idd18,idd07,idd29 FROM
	     s_idd[1].idd08,s_idd[1].idd30,s_idd[1].idd10,
	     s_idd[1].idd15,s_idd[1].idd16,s_idd[1].idd05,
	     s_idd[1].idd06,s_idd[1].idd13,s_idd[1].idd18,
	     s_idd[1].idd07,s_idd[1].idd29
	     
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
   
     ON ACTION qbe_save 
        CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION
 
FUNCTION q027_menu()
 
   WHILE TRUE
      CALL q027_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q027_q()
            END IF
     
         WHEN "du_bin_detail" 
          LET g_cmd = "aimq233 '",g_img.img01,"' '",g_img.img02,"' '",g_img.img03,"' '",g_img.img04,"' ",g_yy," ",g_mm 
          CALL cl_cmdrun(g_cmd CLIPPED)
    
         WHEN "help" 
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"    
            CALL cl_cmdask()
            
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlff),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q027_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL q027_curs()
 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
    END IF
 
    OPEN q027_cs                        
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q027_count
       FETCH  q027_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL q027_fetch('F')  
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q027_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,            #處理方式
    l_abso          LIKE type_file.num10            #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q027_cs INTO g_img.img01,g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
                                            ,g_img.img02,g_img.img03,g_img.img04   #TQC-B90036                                              
        WHEN 'P' FETCH PREVIOUS q027_cs INTO g_img.img01,g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
                                            ,g_img.img02,g_img.img03,g_img.img04   #TQC-B90036                                              
        WHEN 'F' FETCH FIRST    q027_cs INTO g_img.img01,g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
                                            ,g_img.img02,g_img.img03,g_img.img04   #TQC-B90036                                              
        WHEN 'L' FETCH LAST     q027_cs INTO g_img.img01,g_ima02,
                                             g_ima021,g_ima08,g_img.img10,g_imk09
                                            ,g_img.img02,g_img.img03,g_img.img04   #TQC-B90036                                              
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0                     #add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q027_cs INTO g_img.img01,g_ima02,
                                               g_ima021,g_ima08,g_img.img10,g_imk09
                                            ,g_img.img02,g_img.img03,g_img.img04   #TQC-B90036                                                
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
	SELECT img01,img02,img03,img04,img09,img10
	  INTO g_img.* 
	  FROM img_file
      WHERE img01 = g_img.img01 AND img02 = g_img.img02 AND img03 = g_img.img03 AND img04 = g_img.img04
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_img.img01,SQLCA.sqlcode,0)
            RETURN
        END IF
 
    CALL q027_show()
END FUNCTION
 
FUNCTION q027_show()
   DISPLAY BY NAME g_img.*         #顯示單頭值
   
   IF g_imk09 IS NULL THEN 
      LET g_imk09=0 
   END IF
   
   DISPLAY g_imk09 TO imk09
   
   CALL q027_b_fill() 
   
   DISPLAY g_ima02, g_ima021,g_ima08, g_yy,g_mm   
        TO ima02, ima021, ima08, yy,mm            
   CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION q027_b_fill()              
   DEFINE #l_sql     LIKE type_file.chr1000 ,
          l_sql      STRING,     #NO.FUN-910082
          l_nouse   LIKE type_file.chr1  
   DEFINE l_idd13   LIKE idd_file.idd13    
 
   LET l_sql =
        "SELECT idd08,tlf07,idd30,idd10,idd15,idd16,idd05,",
	      "       idd06,idd13,idd18,idd07,idd29,tlf03,",
        "       tlf031,tlf032,tlf033,tlf034,tlf035,tlf13,tlf08,tlf12,tlf02 ",
        " FROM  idd_file,tlf_file",
        " WHERE tlf01 = '",g_img.img01,"'",
        "   AND (tlf907 <> 0)  AND tlf902 = '",g_img.img02 ,"'",
        "   AND tlf903 = '",g_img.img03,"'",
        "   AND tlf904 = '",g_img.img04,"'",
       	"   AND idd01=tlf01", 
	      "   AND idd02=tlf902", 
        "   AND idd03=tlf903", 
        "   AND idd04=tlf904", 
        "   AND idd08=tlf06", 
        "   AND idd10=tlf905", 
        "   AND idd11=tlf906",
        "  AND ",tm.wc2 CLIPPED,
        " ORDER BY idd08,tlf08"
    PREPARE q027_pb FROM l_sql
    DECLARE q027_bcs                
        CURSOR FOR q027_pb
 
    CALL g_idd.clear()
 
    LET g_rec_b=0
    LET m_cnt = 1
    FOREACH q027_bcs INTO g_idd[m_cnt].*,g_tlf03,
                          g_tlf031,g_tlf032,g_tlf033,g_tlf034,g_tlf035,g_tlf13,
                          g_tlf08, g_tlf12
        IF m_cnt=1 THEN
            LET g_rec_b=SQLCA.SQLERRD[3]
        END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_tlf13 = 'aimp880' THEN
           SELECT pia30,pia50 INTO g_pia30,g_pia50 FROM pia_file
             WHERE pia02=g_img.img01 AND pia03=g_img.img02
               AND pia04=g_img.img03 AND pia05=g_img.img04
               AND (pia01=g_idd[m_cnt].idd30 OR pia01=g_idd[m_cnt].idd10)
           IF NOT cl_null(g_pia50) THEN LET g_pia30 = g_pia50 END IF
           IF g_idd[m_cnt].idd10 ='Physical'
              THEN LET g_idd[m_cnt].idd10=g_pia30
              ELSE LET g_idd[m_cnt].idd30=g_pia30
           END IF
        END IF
        IF g_tlf031 = g_img.img02 AND g_tlf032 = g_img.img03 AND
           g_tlf033 = g_img.img04 AND g_tlf13 != 'apmt1071'
           THEN LET g_idd[m_cnt].idd29 = g_tlf034
           ELSE LET g_idd[m_cnt].idd13 = g_idd[m_cnt].idd13 * -1
                IF (g_tlf13='aimt324' OR g_tlf13='aimt720')
                    THEN LET g_tlf12=1
                END IF
        END IF
        IF g_idd[m_cnt].idd13 IS NULL THEN LET g_idd[m_cnt].idd13=0 END IF
        IF g_tlf12 IS NULL THEN LET g_tlf12=0 END IF
        IF g_imk09 IS NULL THEN LET g_imk09=0 END IF  
    
        LET l_idd13=g_idd[m_cnt].idd13 * g_tlf12    
        LET g_imk09 = g_imk09 + l_idd13
      
        LET g_idd[m_cnt].idd29 = g_imk09
        CALL s_command (g_tlf13) RETURNING l_nouse,g_idd[m_cnt].cond
        IF cl_null(g_idd[m_cnt].cond)
           THEN LET g_idd[m_cnt].cond=g_tlf13 END IF
        LET m_cnt = m_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b = m_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q027_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_idd TO s_idd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
 
       BEFORE DISPLAY
         IF g_sma.sma115 = 'N' THEN
            CALL cl_set_act_visible("du_bin_detail",FALSE)
         ELSE
            CALL cl_set_act_visible("du_bin_detail",TRUE)
         END IF
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
 
      BEFORE ROW
         CALL cl_show_fld_cont()                      
   
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION first
         CALL q027_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                   
                              
      ON ACTION previous
         CALL q027_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
                              
      ON ACTION jump
         CALL q027_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
                              
      ON ACTION next
         CALL q027_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                 
 
      ON ACTION last
         CALL q027_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                
                              
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
  
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY    
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()   
 
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      AFTER DISPLAY
         CONTINUE DISPLAY
          
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-830083 by hellen 過單
