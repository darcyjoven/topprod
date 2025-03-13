# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aicq022.4gl
# Descriptions...: ICD料件刻號BIN庫存明細查詢作業
# Date & Author..: 08/01/18 By lutingting(FUN-810058)
# Modify.........: No.FUN-830065 08/03/21 By lutingting 增加相關文件ACTION 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-A20044 10/03/19 By vealxu ima26x 調整
# Modify.........: No.FUN-B30190 11/05/12 By lixh1 單身增加DATECODE顯示
# Modify.........: No.FUN-C30233 12/03/20 By bart 單身刻號/BIN/母批/DATE CDOE等….欄位可以下QBE條件查詢
# Modify.........: No.FUN-C30131 12/03/23 By bart 新增二個欄位idc21,及鎖定此數量的單號,以利查詢知道由誰鎖住此數量
# Modify.........: No.TQC-C40227 12/04/24 By lixh1 單身無資料時不可進行數量查詢
# Modify.........: No.FUN-C50103 12/05/24 By bart 已備置明細查到出貨單時就不要再秀出通單號,查到發料單時就不要再秀工單單號
# Modify.........: No.TQC-C60016 12/06/04 By bart 備置明細排除作廢資料
# Modify.........: No.CHI-C80009 12/08/14 By Sakura 增加多角拋轉單據

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm            RECORD
                  wc,wc2     STRING             #NO.FUN-910082 
                  END RECORD,
    g_ima         RECORD
                   ima01  LIKE ima_file.ima01, # 料件編號
                   ima02  LIKE ima_file.ima02, # 品名規格
                   ima021 LIKE ima_file.ima021,# 品名規格
                   ima05  LIKE ima_file.ima05, # 版本
                   ima06  LIKE ima_file.ima06, # 分群碼
                   ima07  LIKE ima_file.ima07, # ABC碼
                   ima08  LIKE ima_file.ima08, # 來源碼
                   ima25  LIKE ima_file.ima25, 
#                   ima26  LIKE ima_file.ima26, # MRP庫存可用數量     #FUN-A20044
#                   ima261 LIKE ima_file.ima261,# 庫存不可用數量      #FUN-A20044
#                   ima262 LIKE ima_file.ima262 # 庫存可用數量        #FUN-A20044 
                   avl_stk_mpsmrp    LIKE type_file.num15_3,        #FUN-A20044
                   unavl_stk         LIKE type_file.num15_3,        #FUN-A20044
                   avl_stk           LIKE type_file.num15_3         #FUN-A20044
                  END RECORD,
    g_ima37       LIKE ima_file.ima37,
    g_ima38       LIKE ima_file.ima38,
    g_idc         DYNAMIC ARRAY OF RECORD
                  idc02     LIKE idc_file.idc02, 
                  idc03     LIKE idc_file.idc03, 
                  idc04     LIKE idc_file.idc04, 
                  idc05     LIKE idc_file.idc05,
                  idc06     LIKE idc_file.idc06,
                  img23     LIKE img_file.img23,
                  idc09     LIKE idc_file.idc09,
                  idc10     LIKE idc_file.idc10,
                  idc11     LIKE idc_file.idc11,    #FUN-B30190 
                  idc07     LIKE idc_file.idc07,
                  idc08     LIKE idc_file.idc08,
                  idc12     LIKE idc_file.idc12,
                  idc17     LIKE idc_file.idc17,
                  idc21     LIKE idc_file.idc21,     #FUN-C30131
                  idb07     LIKE type_file.chr30     #FUN-C30131
                  END RECORD,
    l_ac          LIKE type_file.num5,    
    l_cc          LIKE type_file.num5,    
    g_wc,g_wc2,g_wc3 string,              
    g_flag        LIKE type_file.num5,    
    g_argv1       LIKE ima_file.ima01,    # INPUT ARGUMENT - 1
    g_argv2       LIKE img_file.img02,    # INPUT ARGUMENT - 1
    g_argv3       LIKE img_file.img03,    # INPUT ARGUMENT - 1
    g_argv4       LIKE img_file.img04,    # INPUT ARGUMENT - 1
 
    g_query_flag  LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next  
    g_sql         string,                 #WHERE CONDITION  
    g_rec_b       LIKE type_file.num5,    #單身筆數  
    g_rec_b2      LIKE type_file.num5     #單身筆數  
DEFINE g_cnt          LIKE type_file.num10   
DEFINE g_msg          LIKE type_file.chr1000 
DEFINE g_row_count    LIKE type_file.num10   
DEFINE g_curs_index   LIKE type_file.num10   
DEFINE g_jump         LIKE type_file.num10   
DEFINE g_no_ask       LIKE type_file.num5    
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
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
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    

    LET g_query_flag=1
    LET g_flag=1
 
    OPEN WINDOW q022_w WITH FORM "aic/42f/aicq022"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
 
    IF NOT cl_null(g_argv1)
       THEN CALL q022_q()
    END IF
    CALL q022_menu()
    CLOSE WINDOW q022_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
#QBE 查詢資料
FUNCTION q022_cs()
   DEFINE   l_cnt LIKE type_file.num5    
   DEFINE   l_i   LIKE type_file.num5  
 
   IF g_argv1 != ' '
      THEN LET g_wc = "ima01 = '",g_argv1,"'"
	   LET g_wc2= " img02 = '",g_argv2,"'",
                      " AND img03 = '",g_argv3,"' AND img04 = '",g_argv4,"' "
   ELSE CLEAR FORM #清除畫面
        CALL g_idc.clear()
        CALL cl_opmsg('q')
 
        INITIALIZE g_ima.* TO NULL
        CALL cl_set_head_visible("","YES")       
        CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021 # 螢幕上取單頭條件
 
              BEFORE CONSTRUCT        #預設查詢條件
                 CALL cl_qbe_init()
 
              ON ACTION CONTROLP     #單頭字段開窗查詢
                 IF INFIELD(ima01) THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima01
                    NEXT FIELD ima01
                 END IF
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
              ON ACTION qbe_select
		 CALL cl_qbe_list() RETURNING lc_qbe_sn
		 CALL cl_qbe_display_condition(lc_qbe_sn)
             
              END CONSTRUCT
        
             IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
             CALL q022_b_askkey()
             IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
 
      IF g_wc2=' 1=1' THEN
         LET g_sql=" SELECT ima01 FROM ima_file ",
                   " WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql=" SELECT UNIQUE ima01 FROM ima_file,idc_file,img_file ",
                   " WHERE ima01=idc01 AND ima01=img01 AND img02=idc02",
                   "   AND img03=idc03 AND img04 = idc04", 
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED
      END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q022_prepare FROM g_sql
   DECLARE q022_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q022_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   IF g_wc2=' 1=1' THEN
      LET g_sql=" SELECT COUNT(*) FROM ima_file ",
                " WHERE ",g_wc CLIPPED
    ELSE
      LET g_sql=" SELECT COUNT(UNIQUE ima01) FROM ima_file,img_file,idc_file ",
#               " WHERE ima01=idc01 AND ima01=img01 AND ima02=idc02 ",#FUN-A20044
                " WHERE ima01=idc01 AND ima01=img01 AND img02=idc02 ",#FUN-A20044
                "   AND img03=idc03 AND img04=idc04 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q022_pp  FROM g_sql
   DECLARE q022_count   CURSOR FOR q022_pp
END FUNCTION
 
FUNCTION q022_b_askkey()
   #CONSTRUCT g_wc2 ON idc02,idc03,idc04,img23 FROM                 #FUN-C30233 mark
	   #s_idc[1].idc02,s_idc[1].idc03,s_idc[1].idc04,s_idc[1].img23 #FUN-C30233 mark
    CONSTRUCT g_wc2 ON idc02,idc03,idc04,idc05,idc06,img23,idc09,idc10,idc11,idc07,idc08,idc12,idc17,idc21 FROM         #FUN-C30233  #FUN-C30131
       s_idc[1].idc02,s_idc[1].idc03,s_idc[1].idc04,s_idc[1].idc05,s_idc[1].idc06,s_idc[1].img23,                 #FUN-C30233 
       s_idc[1].idc09,s_idc[1].idc10,s_idc[1].idc11,s_idc[1].idc07,s_idc[1].idc08,s_idc[1].idc12,s_idc[1].idc17   #FUN-C30233
       ,s_idc[1].idc21  #FUN-C30131
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION
 
FUNCTION q022_menu()
   WHILE TRUE
      CALL q022_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q022_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_idc),'','')
#No.FUN-830065--start--                                                                                                             
         WHEN "related_document"
            LET g_action_choice="related_document"                                                                                     
            IF cl_chk_act_auth() THEN                                                                                                  
               IF g_ima.ima01 IS NOT NULL THEN                                                                                         
                  LET g_doc.column1 = "ima01"                                                                                          
                  LET g_doc.value1 = g_ima.ima01                                                                                       
                  CALL cl_doc()                                                                                                        
               END IF                                                                                                                  
            END IF                                                                                                                     
#No.FUN-830065--end   
         #FUN-C30131---begin
         WHEN "s_aic_idbqry"
            IF NOT cl_null(g_ima.ima01) THEN 
               CALL q022_idb_qry()
            END IF 
         #FUN-C30131---end
          
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q022_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q022_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q022_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q022_count
       FETCH q022_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q022_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q022_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    
    l_abso          LIKE type_file.num10     #絕對的筆數  
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q022_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS q022_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    q022_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     q022_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q022_cs INTO g_ima.ima01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  
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
#	SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,ima25,ima26,ima261,ima262,ima37,ima38                  #FUN-A20044
       SELECT ima01,ima02,ima021,ima05,ima06,ima07,ima08,ima25,' ',' ',' ',ima37,ima38      #FUN-A20044      
	  INTO g_ima.*,g_ima37,g_ima38
	  FROM ima_file
	 WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",0)  
       RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING g_ima.avl_stk_mpsmrp,g_ima.unavl_stk,g_ima.avl_stk   #FUN-A20044
 
    CALL q022_show()
END FUNCTION
 
FUNCTION q022_show()
 
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_ima.*   # 顯示單頭值
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima05,g_ima.ima06,g_ima.ima07,
#                   g_ima.ima08,g_ima.ima25,g_ima.ima26,g_ima.ima261,g_ima.ima262                   #FUN-A20044
                   g_ima.ima08,g_ima.ima25,g_ima.avl_stk_mpsmrp,g_ima.unavl_stk,g_ima.avl_stk       #FUN-A20044      
   #No.FUN-9A0024--end 
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL q022_b_fill(g_wc2) #單身
   IF g_ima37='0' AND g_ima38!=0 AND     
#      g_ima.ima262 < g_ima38 THEN         #FUN-A20044   
      g_ima.avl_stk < g_ima38 THEN         #FUN-A20044 
      CALL cl_err(g_ima.ima01,'mfg1025',0)
   END IF
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION q022_b_fill(p_wc2)              #BODY FILL UP
   DEFINE #l_sql     LIKE type_file.chr1000
         l_sql      STRING     #NO.FUN-910082 
   DEFINE 
         #p_wc2     LIKE type_file.chr1000
          p_wc2     STRING         #NO.FUN-910082 
   DEFINE l_i,l_j   LIKE type_file.num5    
   DEFINE l_cnt     LIKE type_file.num5    
   DEFINE l_type    LIKE imgg_file.imgg00
   DEFINE l_val     LIKE img_file.img10
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_ima907  LIKE ima_file.ima907
   DEFINE l_chr     LIKE type_file.chr3    
   DEFINE l_flag    LIKE type_file.chr1    
   DEFINE tot,tot1  LIKE type_file.num20_6  
   DEFINE l_idb07   LIKE idb_file.idb07   #FUN-C30131 
   DEFINE l_cnt1    LIKE type_file.num5   #FUN-C50103
 
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
    WHERE ima01 = g_ima.ima01
   IF l_ima906 = '2' THEN LET l_type = '1' END IF
   IF l_ima906 = '3' THEN LET l_type = '2' END IF
 
   CALL g_idc.clear()
   LET g_rec_b=0
   LET l_i = 1
   LET tot = 0     LET tot1 = 0
  
  #LET l_sql = "SELECT idc02,idc03,idc04,idc05,idc06,img23,idc09,idc10,idc07,",         #FUN-B30190 
   LET l_sql = "SELECT idc02,idc03,idc04,idc05,idc06,img23,idc09,idc10,idc11,idc07,",   #FUN-B30190
               "       idc08,idc12,idc17,idc21,''",     #FUN-C30131 add idc21,''
               " FROM  img_file,idc_file",
               " WHERE img01=idc01 AND img02=idc02",
               "   AND img03=idc03 AND img04=idc04 ",
               "   AND img01 = '",g_ima.ima01,"' AND ", p_wc2 CLIPPED,
               " ORDER BY idc02,idc03,idc04,idc05,idc06"
    PREPARE q022_pb FROM l_sql
    DECLARE q022_bcs CURSOR FOR q022_pb
    
   
    FOREACH q022_bcs INTO g_idc[l_i].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF cl_null(g_idc[l_i].idc08) THEN
           LET g_idc[l_i].idc08 = 0
        END IF
        IF cl_null(g_idc[l_i].idc12) THEN
           LET g_idc[l_i].idc12 = 0
        END IF 
        LET tot   = tot + g_idc[l_i].idc08
        LET tot1  = tot1+ g_idc[l_i].idc12
        #FUN-C30131---begin
        LET l_sql = "SELECT idb07 ",
                    " FROM  idb_file",
                    " WHERE idb01 = '",g_ima.ima01,"'",
                    "   AND idb02 = '",g_idc[l_i].idc02,"'",
                    "   AND idb03 = '",g_idc[l_i].idc03,"'",
                    "   AND idb04 = '",g_idc[l_i].idc04,"'",
                    "   AND idb05 = '",g_idc[l_i].idc05,"'",
                    "   AND idb06 = '",g_idc[l_i].idc06,"'"

        PREPARE q022_pb1 FROM l_sql
        DECLARE q022_bcs1 CURSOR FOR q022_pb1
        LET l_cnt = 0
        FOREACH q022_bcs1 INTO l_idb07
           #FUN-C50103---begin
           LET l_cnt1 = 0
           LET l_flag = 'N'
           SELECT 'Y' INTO l_flag FROM oga_file
           #WHERE oga09 = '1' AND oga01 = l_idb07                  #CHI-C80009 mark
            WHERE (oga09 = '1' OR oga09 = '5') AND oga01 = l_idb07 #CHI-C80009 add
            AND ogaconf <> 'X'  #TQC-C60016
           IF l_flag = 'Y' THEN 
              SELECT COUNT(*) INTO l_cnt1 FROM idb_file,oga_file
              #WHERE idb07 = oga01 AND oga011 = l_idb07 AND oga09 = '2'                  #CHI-C80009 mark
               WHERE idb07 = oga01 AND oga011 = l_idb07 AND (oga09 = '2' OR oga09 = '4') #CHI-C80009 add
                 AND ogaconf <> 'X'  #TQC-C60016
                 AND idb01 = g_ima.ima01
                 AND idb02 = g_idc[l_i].idc02
                 AND idb03 = g_idc[l_i].idc03
                 AND idb04 = g_idc[l_i].idc04
                 AND idb05 = g_idc[l_i].idc05
                 AND idb06 = g_idc[l_i].idc06
              IF l_cnt1 = 0 THEN
                 SELECT COUNT(*) INTO l_cnt1 FROM idd_file,oga_file
                 #WHERE idd10 = oga01 AND oga011 = l_idb07 AND oga09 = '2'                  #CHI-C80009 mark
                  WHERE idd10 = oga01 AND oga011 = l_idb07 AND (oga09 = '2' OR oga09 = '4') #CHI-C80009 add
                    AND ogaconf <> 'X'  #TQC-C60016
                    AND idd01 = g_ima.ima01
                    AND idd02 = g_idc[l_i].idc02
                    AND idd03 = g_idc[l_i].idc03
                    AND idd04 = g_idc[l_i].idc04
                    AND idd05 = g_idc[l_i].idc05
                    AND idd06 = g_idc[l_i].idc06
              END IF
           ELSE 
              LET l_flag = 'N'
              SELECT 'Y' INTO l_flag FROM sfb_file
               WHERE sfb01 = l_idb07
                 AND sfb87 <> 'X'  #TQC-C60016
              IF l_flag = 'Y' THEN 
                 SELECT COUNT(*) INTO l_cnt1 FROM idd_file,sfe_file
                  WHERE idd10 = sfe02 AND sfe01 = l_idb07
                    AND idd01 = g_ima.ima01
                    AND idd02 = g_idc[l_i].idc02
                    AND idd03 = g_idc[l_i].idc03
                    AND idd04 = g_idc[l_i].idc04
                    AND idd05 = g_idc[l_i].idc05
                    AND idd06 = g_idc[l_i].idc06
                 IF l_cnt1 = 0 THEN
                    SELECT COUNT(*) INTO l_cnt1 FROM idb_file,sfs_file,sfp_file #TQC-C60016 add sfp_file
                     WHERE idb07 = sfs01 AND sfs03 = l_idb07
                       AND sfs01 = sfp01 AND sfpconf <> 'X'   #TQC-C60016
                       AND idb01 = g_ima.ima01
                       AND idb02 = g_idc[l_i].idc02
                       AND idb03 = g_idc[l_i].idc03
                       AND idb04 = g_idc[l_i].idc04
                       AND idb05 = g_idc[l_i].idc05
                       AND idb06 = g_idc[l_i].idc06
                 END IF
              END IF 
           END IF 
           IF l_cnt1 = 0 THEN
           #FUN-C50103---end 
              LET l_cnt = l_cnt + 1
              IF l_cnt > 1 THEN
                 EXIT FOREACH 
              END IF 
              LET g_idc[l_i].idb07 = l_idb07
           #FUN-C50103---begin   
           ELSE
              LET l_idb07 = g_idc[l_i].idb07
           END IF  
           #FUN-C50103---end
        END FOREACH 
        IF g_idc[l_i].idb07 <> l_idb07 THEN
           LET g_idc[l_i].idb07 = g_idc[l_i].idb07,"..."
        END IF 
        #FUN-C30131---end
        LET l_i = l_i + 1
        IF l_i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
        END IF
    END FOREACH
    LET l_cc = l_i
    CALL g_idc.deleteElement(l_cc)
    LET g_rec_b=(l_i-1)
    DISPLAY BY NAME tot
    DISPLAY BY NAME tot1
    DISPLAY g_rec_b TO FORMONLY.cn2
    IF g_rec_b != 0 THEN
       CALL fgl_set_arr_curr(1)
    END IF
END FUNCTION
 
FUNCTION q022_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_idc TO s_idc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
  
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q022_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY               
 
      ON ACTION previous
         CALL q022_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL q022_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL q022_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q022_fetch('L')
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      
      AFTER DISPLAY
         CONTINUE DISPLAY
      
 
                                                                                          
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      
 
#No.FUN-830065--start--
      ON ACTION related_document                                                                  
         LET g_action_choice="related_document"                                                                                     
         EXIT DISPLAY
#No.FUN-830065--end
      #FUN-C30131---begin
      ON ACTION s_aic_idbqry
         LET l_ac = ARR_CURR()
         LET g_action_choice="s_aic_idbqry"
         EXIT DISPLAY
      #FUN-C30131---end
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-C30131---begin
FUNCTION q022_idb_qry()
DEFINE    g_idb   DYNAMIC ARRAY OF RECORD
                  idb07     LIKE idb_file.idb07, 
                  idb08     LIKE idb_file.idb08, 
                  idb09     LIKE idb_file.idb09, 
                  idb11     LIKE idb_file.idb11
          END RECORD 
DEFINE l_sql STRING 
DEFINE l_cnt LIKE type_file.num5
#FUN-C50103---begin
DEFINE    l_idb  RECORD
                  idb07     LIKE idb_file.idb07, 
                  idb08     LIKE idb_file.idb08, 
                  idb09     LIKE idb_file.idb09, 
                  idb11     LIKE idb_file.idb11
          END RECORD
DEFINE l_cnt1 LIKE type_file.num5
DEFINE l_flag LIKE type_file.chr1
#FUN-C50103---end
#TQC-C40227 -------------Begin---------------
    IF cl_null(l_ac) OR l_ac < 1 THEN
       RETURN
    END IF 
#TQC-C40227 -------------End-----------------

    OPEN WINDOW q0221_w WITH FORM "aic/42f/aicq0221"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_act_visible("accept,cancel", FALSE) 

    LET l_sql = "SELECT idb07,idb08,idb09,idb11",
                " FROM  idb_file",
                " WHERE idb01 = '",g_ima.ima01,"'",
                "   AND idb02 = '",g_idc[l_ac].idc02,"'",
                "   AND idb03 = '",g_idc[l_ac].idc03,"'",
                "   AND idb04 = '",g_idc[l_ac].idc04,"'",
                "   AND idb05 = '",g_idc[l_ac].idc05,"'",
                "   AND idb06 = '",g_idc[l_ac].idc06,"'"

    PREPARE q0221_pb FROM l_sql
    DECLARE q0221_bcs CURSOR FOR q0221_pb
    LET l_cnt = 1
    #FOREACH q0221_bcs INTO g_idb[l_cnt].*  #FUN-C50103
    FOREACH q0221_bcs INTO l_idb.*          #FUN-C50103
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        #FUN-C50103---begin
        LET l_cnt1 = 0
        LET l_flag = 'N'
        #當這筆資料是出通單時,查看是否已拋出貨單,若是則跳過,若不是才顯示
        SELECT 'Y' INTO l_flag FROM oga_file
        #WHERE oga09 = '1' AND oga01 = l_idb.idb07                   #CHI-C80009 mark
         WHERE (oga09 = '1' OR oga09 = '5') AND oga01 = l_idb.idb07  #CHI-C80009 add
           AND ogaconf <> 'X'  #TQC-C60016
        IF l_flag = 'Y' THEN 
           SELECT COUNT(*) INTO l_cnt1 FROM idb_file,oga_file
           #WHERE idb07 = oga01 AND oga011 = l_idb.idb07 AND oga09 = '2'                  #CHI-C80009 mark
            WHERE idb07 = oga01 AND oga011 = l_idb.idb07 AND (oga09 = '2' OR oga09 = '4') #CHI-C80009 add
              AND ogaconf <> 'X'  #TQC-C60016
              AND idb01 = g_ima.ima01
              AND idb02 = g_idc[l_ac].idc02
              AND idb03 = g_idc[l_ac].idc03
              AND idb04 = g_idc[l_ac].idc04
              AND idb05 = g_idc[l_ac].idc05
              AND idb06 = g_idc[l_ac].idc06
           IF l_cnt1 = 0 THEN
              SELECT COUNT(*) INTO l_cnt1 FROM idd_file,oga_file
              #WHERE idd10 = oga01 AND oga011 = l_idb.idb07 AND oga09 = '2'                  #CHI-C80009 mark
               WHERE idd10 = oga01 AND oga011 = l_idb.idb07 AND (oga09 = '2' OR oga09 = '4') #CHI-C80009 add
                 AND ogaconf <> 'X'  #TQC-C60016
                 AND idd01 = g_ima.ima01
                 AND idd02 = g_idc[l_ac].idc02
                 AND idd03 = g_idc[l_ac].idc03
                 AND idd04 = g_idc[l_ac].idc04
                 AND idd05 = g_idc[l_ac].idc05
                 AND idd06 = g_idc[l_ac].idc06
           END IF
        ELSE 
           LET l_flag = 'N'
           #當這筆資料是工單時,查看是否已產生發料單,若是則跳過,若不是才顯示
           SELECT 'Y' INTO l_flag FROM sfb_file
            WHERE sfb01 = l_idb.idb07
              AND sfb87 <> 'X'  #TQC-C60016
           IF l_flag = 'Y' THEN 
              SELECT COUNT(*) INTO l_cnt1 FROM idd_file,sfe_file
               WHERE idd10 = sfe02 AND sfe01 = l_idb.idb07
                 AND idd01 = g_ima.ima01
                 AND idd02 = g_idc[l_ac].idc02
                 AND idd03 = g_idc[l_ac].idc03
                 AND idd04 = g_idc[l_ac].idc04
                 AND idd05 = g_idc[l_ac].idc05
                 AND idd06 = g_idc[l_ac].idc06
              IF l_cnt1 = 0 THEN
                 SELECT COUNT(*) INTO l_cnt1 FROM idb_file,sfs_file,sfp_file #TQC-C60016
                  WHERE idb07 = sfs01 AND sfs03 = l_idb.idb07
                    AND sfs01 = sfp01 AND sfpconf <> 'X'   #TQC-C60016
                    AND idb01 = g_ima.ima01
                    AND idb02 = g_idc[l_ac].idc02
                    AND idb03 = g_idc[l_ac].idc03
                    AND idb04 = g_idc[l_ac].idc04
                    AND idb05 = g_idc[l_ac].idc05
                    AND idb06 = g_idc[l_ac].idc06
              END IF
           END IF 
        END IF 
        IF l_cnt1 = 0 THEN
           LET g_idb[l_cnt].* = l_idb.*
        #FUN-C50103---end 
           LET l_cnt = l_cnt + 1
        END IF   #FUN-C50103
    END FOREACH 

    CALL g_idb.deleteElement(l_cnt)

    LET g_action_choice = " "
 
    DISPLAY ARRAY g_idb TO s_idb.* 
       BEFORE DISPLAY
           CALL cl_navigator_setting( g_curs_index, g_row_count )
          
       BEFORE ROW
          LET l_cnt = ARR_CURR()
          CALL cl_show_fld_cont()  
         
       AFTER DISPLAY
          CONTINUE DISPLAY
         
       ON ACTION exit
          EXIT DISPLAY

       ON ACTION controlg
          CALL cl_cmdask()
          EXIT DISPLAY
         
       ON ACTION controls                                                                                                             
          CALL cl_set_head_visible("","AUTO")   
          EXIT DISPLAY

       ON ACTION CANCEL
          EXIT DISPLAY
    END DISPLAY   
    
    CALL cl_set_act_visible("accept,cancel", FALSE)     
    CLOSE WINDOW q0221_w
          
END FUNCTION 
 
 
