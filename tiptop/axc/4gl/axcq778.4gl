# Prog. Version..: '5.30.06-13.03.19(00004)'     #
#
# Pattern name...: axcq778.4gl
# Descriptions...: 
# Date & Author..: 12/08/28 By fengrui #No.FUN-C80092
# Modify.........: No.FUN-C80092 12/09/12 By lixh1 增加寫入日誌功能
# Modify.........: No.FUN-C80092 12/09/27 By fengrui 最大筆數控制與excel導出處理
# Modify.........: NO.FUN-C90076 12/12/06 By xujing 增加axcq460傳入參數
# Modify.........: NO.FUN-D10022 13/01/05 By fengrui 程式效能優化
# Modify.........: NO.TQC-D30024 13/03/07 By fengrui 雙擊詳細頁簽不應退出dialog
 
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE
   g_tlf01        LIKE tlf_file.tlf01, 
   g_tlf DYNAMIC ARRAY OF RECORD          
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021, 
         tlf905   LIKE tlf_file.tlf905,
         tlf19    LIKE tlf_file.tlf19, 
         occ02    LIKE occ_file.occ02,
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62, 
         tlfccost LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt_d    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222 
             END RECORD,
   g_tlf_excel DYNAMIC ARRAY OF RECORD  
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021, 
         tlf905   LIKE tlf_file.tlf905,
         tlf19    LIKE tlf_file.tlf19, 
         occ02    LIKE occ_file.occ02,
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62, 
         tlfccost LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt_d    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222 
             END RECORD,
   g_tlf_1 DYNAMIC ARRAY OF RECORD
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021, 
         tlf905   LIKE tlf_file.tlf905,
         tlf19    LIKE tlf_file.tlf19, 
         occ02    LIKE occ_file.occ02,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt_d    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222                   
             END RECORD,
   g_argv1       LIKE type_file.num5,
   g_argv2       LIKE type_file.num5,
   g_argv3       LIKE type_file.chr1,
   g_argv4       LIKE type_file.chr1,
   g_argv5       LIKE type_file.chr1,
   g_rec_b       LIKE type_file.num10,  #FUN-C80092 num5->10 
   g_rec_b1      LIKE type_file.num10,  #FUN-C80092 num5->10 
   g_rec_b2      LIKE type_file.num10,  
   l_ac          LIKE type_file.num10,        
   l_ac1         LIKE type_file.num10   
DEFINE sr1 RECORD 
           bdate LIKE type_file.dat,         
           edate LIKE type_file.dat,         
           type  LIKE type_file.chr1,     #成本計算類型
           qty   LIKE tlf_file.tlf10,     #數量
           tot   LIKE ccc_file.ccc23,     #總金額
           cl    LIKE tlfc_file.tlfc221,  #材料費用 
           rg    LIKE tlfc_file.tlfc222,  #人工費用    
           jg    LIKE tlfc_file.tlfc2232, #加工費用  
           zz1   LIKE tlfc_file.tlfc2231, #製費一 
           zz2   LIKE tlfc_file.tlfc224,  #製費二     
           zz3   LIKE tlfc_file.tlfc2241, #製費三  
           zz4   LIKE tlfc_file.tlfc2242, #製費四  
           zz5   LIKE tlfc_file.tlfc2243  #製費五
           END RECORD 
DEFINE tm,tm_t  RECORD
           wc      LIKE type_file.chr1000, 
           bdate   LIKE type_file.dat,         
           edate   LIKE type_file.dat, 
           type    LIKE tlfc_file.tlfctype,
           a       LIKE type_file.chr1,
           b       LIKE type_file.chr1,
           c       LIKE type_file.chr1
           END RECORD           
DEFINE   g_sql           STRING            
DEFINE   g_filter_wc     STRING   
DEFINE   g_flag          LIKE type_file.chr1          
DEFINE   g_cnt           LIKE type_file.num10                   
DEFINE   g_cka00         LIKE cka_file.cka00      
DEFINE   g_action_flag   LIKE type_file.chr100
DEFINE   g_row_count     LIKE type_file.num10  
DEFINE   g_curs_index    LIKE type_file.num10  
DEFINE   w               ui.Window
DEFINE   f               ui.Form
DEFINE   page            om.DomNode

MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_argv1 = ARG_VAL(1)  #年度          #FUN-C90076 add
   LET g_argv2 = ARG_VAL(2)  #期別          #FUN-C90076 add
   CALL q778_table()   #xj add
   OPEN WINDOW q778_w WITH FORM "axc/42f/axcq778"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()      
   #CALL q778_tm()
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q778_q()
   CALL q778_menu()
   CLOSE WINDOW q778_w 
   DROP TABLE axcq778_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q778_menu()
   WHILE TRUE
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page1" THEN
            CALL q778_bp("G")
         END IF
         IF g_action_flag = "page2" THEN
            CALL q778_bp2()
         END IF
      END IF
      #CALL q778_bp("G")
      CASE g_action_choice
         WHEN "page1"
            CALL q778_bp("G")
         WHEN "page2"
            CALL q778_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN  
               CALL q778_q()
            END IF
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q778_filter_askkey()
               CALL q778()        #重填充新臨時表
               CALL q778_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q778()        #重填充新臨時表
               CALL q778_show() 
            END IF             
            LET g_action_choice = " "
         WHEN "help" 
            CALL cl_show_help()
            LET g_action_choice = " "
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
            LET g_action_choice = " "
         WHEN "exporttoexcel" 
            LET w = ui.Window.getCurrent()
            LET f = w.getForm()
            IF g_action_flag = "page1" THEN
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_excel),'','')
               END IF
            END IF
            IF g_action_flag = "page2" THEN
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_1),'','')
               END IF
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION

FUNCTION q778_cs()
   DEFINE l_flag            LIKE type_file.chr1,   
          l_bdate,l_edate   LIKE type_file.dat
          
   CLEAR FORM   #清除畫面
   CALL cl_opmsg('q')

   LET g_bgjob = 'N'
   
   INITIALIZE tm.* TO NULL
   #FUN-C90076---add---str---
   IF cl_null(g_action_choice) AND NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      CALL s_azm(g_argv1,g_argv2) RETURNING l_flag,l_bdate,l_edate
   ELSE
   #FUN-C90076---add---end---
      CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,l_bdate,l_edate
   END IF                   #FUN-C90076 add
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = '1'
   LET tm.b   = 'N'
   LET tm.c   = 'N'
   LET tm.a   = '2'
   LET g_bgjob= 'N'
   LET g_filter_wc = ' 1=1'
   LET g_action_flag = ''

   #FUN-C90076---add---str---
   DISPLAY tm.bdate TO bdate
   DISPLAY tm.edate TO edate
   DISPLAY tm.type  TO type
   DISPLAY tm.b     TO b
   DISPLAY tm.c     TO c
   #FUN-C90076---add---end--- 

   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)

   DIALOG ATTRIBUTE(UNBUFFERED)   
      INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.b,tm.c,tm.a ATTRIBUTE(WITHOUT DEFAULTS)

         BEFORE INPUT
            IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
               CALL s_azm(g_argv1,g_argv2) RETURNING l_flag,tm.bdate,tm.edate
               LET tm.type = g_argv3  
               DISPLAY BY NAME tm.bdate,tm.edate,tm.type,tm.b,tm.c
               CALL cl_set_comp_entry('bdate,edate,type',FALSE)
            ELSE 
               CALL cl_set_comp_entry('bdate,edate,type',TRUE)
            END IF 
 
         AFTER FIELD TYPE
            IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF

         AFTER INPUT
            IF INT_FLAG THEN
               EXIT DIALOG
            END IF
            IF tm.edate < tm.bdate THEN
               CALL cl_err('','agl-031',0)
               NEXT FIELD edate
            END IF
      END INPUT
      CONSTRUCT tm.wc ON ima12,tlf01,tlf905,tlf19,
                         tlf021,tlf06,tlf026,tlf62,tlf10   #FUN-D10022
                    FROM s_tlf[1].ima12,s_tlf[1].tlf01,s_tlf[1].tlf905,s_tlf[1].tlf19,
                         s_tlf[1].tlf021,s_tlf[1].tlf06,s_tlf[1].tlf026,s_tlf[1].tlf62, #FUN-D10022
                         s_tlf[1].tlf10     #FUN-D10022
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT 

      ON ACTION controlp 
         CASE   
            WHEN INFIELD(tlf01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tlf"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf01
               NEXT FIELD tlf01      
            WHEN INFIELD(ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1  = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            #TQC-D30024 add
            WHEN INFIELD(tlf19)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf19
               NEXT FIELD tlf19
            #TQC-D30024 add
            #FUN-D10022--add--str--
            WHEN INFIELD(tlf021)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img21"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf021
               NEXT FIELD tlf021
            #FUN-D10022--add--end--
         END CASE                                                   
 
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG 

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT DIALOG 

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION qbe_select
    	  CALL cl_qbe_select() 

       ON ACTION ACCEPT
          ACCEPT DIALOG 

       ON ACTION CANCEL
          LET INT_FLAG=1
          EXIT DIALOG    
   END DIALOG
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')  
   IF INT_FLAG THEN
       LET INT_FLAG = 0 
       INITIALIZE tm.* TO NULL                          #xj add
       INITIALIZE sr1.* TO NULL                         #xj add
       DELETE FROM axcq778_tmp                          #xj add
   END IF 
   LET tm.wc = cl_replace_str(tm.wc,'tlf021','(CASE WHEN tlf907=1 THEN tlf031 ELSE tlf021 END)') #FUN-D10022
   LET tm.wc = cl_replace_str(tm.wc,'tlf026','(CASE WHEN tlf907=1 THEN tlf036 ELSE tlf026 END)') #FUN-D10022
   CALL q778()
END FUNCTION 

FUNCTION q778_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q778_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q778_show()
END FUNCTION

FUNCTION q778_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM

   CONSTRUCT l_wc ON ima12,tlf01,tlf905,tlf19,
                     tlf021,tlf06,tlf026,tlf62,tlf10                                 #FUN-D10022
                 FROM s_tlf[1].ima12,s_tlf[1].tlf01,s_tlf[1].tlf905,s_tlf[1].tlf19,
                      s_tlf[1].tlf021,s_tlf[1].tlf06,s_tlf[1].tlf026,s_tlf[1].tlf62, #FUN-D10022
                      s_tlf[1].tlf10                                                 #FUN-D10022
      BEFORE CONSTRUCT
         DISPLAY tm.bdate TO bdate
         DISPLAY tm.edate TO edate
         DISPLAY tm.type TO type
         DISPLAY tm.b TO b
         DISPLAY tm.c TO c
         DISPLAY tm.a TO a 
         CALL cl_qbe_init()

     ON ACTION controlp                                                      
         CASE   
            WHEN INFIELD(tlf01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tlf"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf01
               NEXT FIELD tlf01      
            WHEN INFIELD(ima12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1  = "G"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima12
               NEXT FIELD ima12
            #TQC-D30024 add
            WHEN INFIELD(tlf19)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf19
               NEXT FIELD tlf19
            #TQC-D30024 add
            #FUN-D10022--add--str--
            WHEN INFIELD(tlf021)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img21"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf021
               NEXT FIELD tlf021
            #FUN-D10022--add--end--
         END CASE  
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT
   
   IF INT_FLAG THEN 
      LET g_filter_wc = ''
      CALL cl_set_act_visible("revert_filter",FALSE)
      LET INT_FLAG = 0
      RETURN 
   END IF
   IF cl_null(l_wc) THEN LET l_wc =" 1=1" END IF 
   IF l_wc !=" 1=1" THEN
      CALL cl_set_act_visible("revert_filter",TRUE)
   END IF 
   LET l_wc = cl_replace_str(l_wc,'tlf021','(CASE WHEN tlf907=1 THEN tlf031 ELSE tlf021 END)') #FUN-D10022
   LET l_wc = cl_replace_str(l_wc,'tlf026','(CASE WHEN tlf907=1 THEN tlf036 ELSE tlf026 END)') #FUN-D10022
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION

FUNCTION q778_show()
   DISPLAY tm.a TO a
   IF cl_null(g_action_flag) OR g_action_flag="page2" THEN
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
      CALL q778_b_fill_2()
   ELSE
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      CALL q778_b_fill()  
   END IF
   CALL q778_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION
   
FUNCTION q778()          
DEFINE   p_wc        STRING,
         l_sql       STRING      
         
DEFINE  sr  RECORD
        ima12  LIKE ima_file.ima12,
        ima02  LIKE ima_file.ima02,
        ima021 LIKE ima_file.ima021,
        tlfccost LIKE tlfc_file.tlfccost,   
        tlf02  LIKE tlf_file.tlf02,
        tlf021 LIKE tlf_file.tlf021,
        tlf03  LIKE tlf_file.tlf03,
        tlf031 LIKE tlf_file.tlf031,
        tlf06  LIKE tlf_file.tlf06,
        tlf026 LIKE tlf_file.tlf026,
        tlf62  LIKE tlf_file.tlf62,
        tlf027 LIKE tlf_file.tlf027,
        tlf036 LIKE tlf_file.tlf036,
        tlf037 LIKE tlf_file.tlf037,
        tlf01  LIKE tlf_file.tlf01,
        tlf10  LIKE tlf_file.tlf10,
        tlfc21 LIKE tlfc_file.tlfc21,      
        tlf13  LIKE tlf_file.tlf13,
        tlf905 LIKE tlf_file.tlf905,
        tlf906 LIKE tlf_file.tlf906,
        tlf19  LIKE tlf_file.tlf19 ,
        tlf907 LIKE tlf_file.tlf907,
        amt01  LIKE tlfc_file.tlfc221,    
        amt02  LIKE tlfc_file.tlfc222,    
        amt03  LIKE tlfc_file.tlfc2231,   
        amt_d  LIKE tlfc_file.tlfc2232,   
        amt05  LIKE tlfc_file.tlfc224,    
        amt06  LIKE tlfc_file.tlfc2241,   
        amt07  LIKE tlfc_file.tlfc2242,   
        amt08  LIKE tlfc_file.tlfc2243,   
        amt04  LIKE ccc_file.ccc23,   
        wsaleamt  LIKE omb_file.omb16 
        END RECORD 
   DEFINE l_oga00    LIKE oga_file.oga00  
   DEFINE l_oga65    LIKE oga_file.oga65   
   DEFINE l_tlf14    LIKE tlf_file.tlf14     
   DEFINE l_azf08    LIKE azf_file.azf08
   DEFINE i          LIKE type_file.num10  #FUN-C80092 num5->10
   DEFINE l_flag     LIKE type_file.chr1
   DEFINE l_msg      STRING       #FUN-C80092


   DELETE FROM axcq778_tmp    #xj add
   IF cl_null(tm.wc) THEN LET tm.wc = '1=1' END IF
#   CALL q778_table()   #xj mark
#FUN-C80092 ---------Begin--------------
   LET l_msg = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.type = '",tm.type,"'",";",
               "tm.b = '",tm.b,"'",";","tm.c = '",tm.c,"'"
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00
#FUN-C80092 ---------End---------------

   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF   #xj add
   #ima12,azf03,tlf01,ima02,ima021,tlf905,tlf19,tlf021,tlf06,tlf026,tlf62,tlfccost,
   #tlf10,amt01,amt02,amt03,amt_d,amt05,amt06,amt07,amt08,amt04
   LET l_sql = " SELECT nvl(trim(ima12),'') ima12,azf03,nvl(trim(ima01),'') tlf01,ima02,ima021,nvl(trim(tlf905),'') tlf905,nvl(trim(tlf19),'') tlf19,occ02,",
               "        CASE WHEN tlf907=1 THEN tlf031 ELSE tlf021 END tlf021,tlf06,",
               "        CASE WHEN tlf907=1 THEN tlf036 ELSE tlf026 END tlf026,tlf62,tlfccost, ", 
               "        nvl(tlf10*tlf60,0) tlf10,nvl(tlfc221,0) amt01,nvl(tlfc222,0) amt02,nvl(tlfc2231,0) amt03,nvl(tlfc2232,0) amt_d,",
               "        nvl(tlfc224,0) amt05,nvl(tlfc2241,0) amt06,nvl(tlfc2242,0) amt07,nvl(tlfc2243,0) amt08,0 amt04,tlf907 ",  
               "  FROM ima_file LEFT OUTER JOIN azf_file ON ima12=azf01 AND azf02='G', ",
               "       tlf_file LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",  
               "                LEFT OUTER JOIN occ_file ON occ01 = tlf19 ",
               " WHERE ima01 = tlf01 ", 
               " AND (tlf13 LIKE 'axm%' OR tlf13 LIKE 'aomt%')",
               " AND ",tm.wc CLIPPED,
               " AND ",g_filter_wc CLIPPED,     #xj add
               " AND tlf902 not in (select jce02 from jce_file)",
               " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"') ",
               #free--add--str--
               #" AND ( ('",tm.b,"'='2' AND 'Y'=(SELECT azf08 FROM azf_file WHERE tlf14=azf01 AND azf02='2')) ",
               #"    OR ('",tm.b,"'='1' AND 0=(SELECT count(*) FROM azf_file WHERE tlf14=azf01 AND azf02='2' AND azf08='Y'))) ",
               " AND ( ('",tm.b,"'='Y') ",
               "    OR ('",tm.b,"'='N' AND 0=(SELECT count(*) FROM azf_file WHERE tlf14=azf01 AND azf02='2' AND azf08='Y'))) ",
               " AND ( tlf13 NOT LIKE 'axmt%' OR (tlf13 LIKE 'axmt%' AND ",
               "     0= (SELECT count(*) FROM oga_file WHERE (oga00='3' OR oga00='A' OR oga00='7' OR oga65 = 'Y') AND oga01=tlf905 ))) "
               #free--add--end-- 

   #LET l_sql = " SELECT ima12,ima02,ima021,tlfccost,",   
   #            " tlf02,tlf021,tlf03,tlf031,tlf06,tlf026,tlf62,tlf027,", 
   #            " tlf036,tlf037,tlf01,tlf10*tlf60,tlfc21,tlf13,tlf905,tlf906,", 
   #            " tlf19,tlf907,tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,0,tlf14,azf08",
   #            "  FROM ima_file,tlf_file LEFT OUTER JOIN azf_file ON tlf14=azf01 AND azf02='2' LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlfctype = '",tm.type,"' AND tlf06=tlfc06 AND tlf026=tlfc026 AND tlf027=tlfc027 AND tlf036=tlfc036 AND tlf037=tlfc037 AND tlf02=tlfc02 AND tlf03=tlfc03 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906 ",  
   #            " WHERE ima01 = tlf01 ", 
   #            " AND (tlf13 LIKE 'axm%' OR tlf13 LIKE 'aomt%')",
   #            " AND ",tm.wc CLIPPED,
   #            " and tlf902 not in (select jce02 from jce_file)",
   #            " AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')"

   #IF tm.c = 'Y' THEN
   #   LET l_sql = l_sql," AND tlf28 = 'S' ORDER BY tlf905,tlf01"
   #ELSE
   #   LET l_sql = l_sql," ORDER BY tlf905,tlf01 "
   #END IF 
   IF tm.c = 'Y' THEN
      LET l_sql = l_sql," AND tlf28 = 'S' "
   END IF 

   LET l_sql = " INSERT INTO axcq778_tmp ",l_sql CLIPPED 
   PREPARE q778_ins FROM l_sql
   EXECUTE q778_ins
   SELECT count(*)  INTO i FROM axcq778_tmp #free test
   LET l_sql = " UPDATE axcq778_tmp ",
               "    SET tlf10 = tlf10 * -1 ,",
               "        amt01 = amt01 * -1 ,",
               "        amt02 = amt02 * -1 ,",
               "        amt03 = amt03 * -1 ,",
               "        amt_d = amt_d * -1 ,",
               "        amt05 = amt05 * -1 ,",
               "        amt06 = amt06 * -1 ,",
               "        amt07 = amt07 * -1 ,",
               "        amt08 = amt08 * -1  ",
               "  WHERE tlf907 <> 1 "
   PREPARE q778_pre1 FROM l_sql
   EXECUTE q778_pre1  

   LET l_sql = " UPDATE axcq778_tmp ",
               "    SET amt04 =nvl(amt01+amt02+amt03+amt_d+amt05+amt06+amt07+amt08 ,0) "
   PREPARE q778_pre2 FROM l_sql
   EXECUTE q778_pre2     

   IF g_aza.aza26 = '2' THEN
      LET l_sql = " UPDATE axcq778_tmp ",
                  "    SET tlf10 = tlf10 * -1 ,",
                  "        amt01 = amt01 * -1 ,",
                  "        amt02 = amt02 * -1 ,",
                  "        amt03 = amt03 * -1 ,",
                  "        amt_d = amt_d * -1 ,",
                  "        amt05 = amt05 * -1 ,",
                  "        amt06 = amt06 * -1 ,",
                  "        amt07 = amt07 * -1 ,",
                  "        amt08 = amt08 * -1  "
      PREPARE q778_pre3 FROM l_sql
      EXECUTE q778_pre3   
   END IF  


   #PREPARE axcq778_prepare1 FROM l_sql
   #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
   #   CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   #   EXIT PROGRAM 
   #END IF
   #DECLARE axcq778_curs1 CURSOR FOR axcq778_prepare1
   #CALL g_tlf.clear()
   #CALL g_tlf_excel.clear()
   #LET g_cnt = 1
   #FOREACH axcq778_curs1 INTO sr.*,l_tlf14,l_azf08
   #   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
   #   #寫入主sql   
   #   LET l_oga00 = NULL
   #   LET l_oga65 = NULL 
   #   IF sr.tlf13 MATCHES 'axmt*' THEN
   #      SELECT oga00,oga65 INTO l_oga00,l_oga65 FROM oga_file WHERE oga01=sr.tlf905    
   #      IF l_oga00 = '3' OR l_oga00 ='A' OR l_oga00='7' OR l_oga65 = 'Y' THEN   
   #         CONTINUE FOREACH
   #      END IF
   #   END IF
   #   #寫入主sql 
   #   IF cl_null(l_azf08) THEN LET l_azf08='N' END IF
   #      CASE tm.b
   #         WHEN '1'
   #            IF l_azf08='Y' THEN CONTINUE FOREACH END IF
   #         WHEN '2'
   #            IF l_azf08='N' THEN CONTINUE FOREACH END IF
   #      END CASE 
   #   IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
   #   IF  cl_null(sr.amt01)  THEN LET sr.amt01=0 END IF
   #   IF  cl_null(sr.amt02)  THEN LET sr.amt02=0 END IF
   #   IF  cl_null(sr.amt03)  THEN LET sr.amt03=0 END IF
   #   IF  cl_null(sr.tlfc21) THEN LET sr.tlfc21=0 END IF  
   #   IF  cl_null(sr.amt_d)  THEN LET sr.amt_d=0 END IF
   #   IF  cl_null(sr.amt04)  THEN LET sr.amt04=0 END IF
   #   IF  cl_null(sr.amt05)  THEN LET sr.amt05=0 END IF  
   #   IF  cl_null(sr.amt06)  THEN LET sr.amt06=0 END IF   
   #   IF  cl_null(sr.amt07)  THEN LET sr.amt07=0 END IF   
   #   IF  cl_null(sr.amt08)  THEN LET sr.amt08=0 END IF
   #   IF sr.tlf907 = 1 THEN
   #      LET sr.tlf02  = sr.tlf03
   #      LET sr.tlf021 = sr.tlf031
   #      LET sr.tlf026 = sr.tlf036
   #   ELSE
   #      LET sr.tlf10= sr.tlf10 * -1
   #      LET sr.amt01= sr.amt01 * -1
   #      LET sr.amt02= sr.amt02 * -1
   #      LET sr.amt03= sr.amt03 * -1
   #      LET sr.amt_d= sr.amt_d * -1
   #      LET sr.amt05= sr.amt05 * -1   
   #      LET sr.amt06= sr.amt06 * -1    
   #      LET sr.amt07= sr.amt07 * -1   
   #      LET sr.amt08= sr.amt08 * -1   
   #   END IF
   #   LET sr.amt04 = sr.amt01 + sr.amt02 + sr.amt03 + sr.amt_d + sr.amt05  
   #                 +sr.amt06+sr.amt07+sr.amt08 
   #   IF cl_null(sr.amt04)  THEN LET sr.amt01=0 END IF        
   #   IF g_aza.aza26 = '2' THEN
   #      LET sr.tlf10= sr.tlf10 * -1
   #      LET sr.amt01= sr.amt01 * -1
   #      LET sr.amt02= sr.amt02 * -1
   #      LET sr.amt03= sr.amt03 * -1
   #      LET sr.amt_d= sr.amt_d * -1
   #      LET sr.amt05= sr.amt05 * -1
   #      LET sr.amt06= sr.amt06 * -1
   #      LET sr.amt07= sr.amt07 * -1
   #      LET sr.amt08= sr.amt08 * -1
   #   END IF
   #   LET g_tlf_excel[g_cnt].tlf021 = sr.tlf021
   #   LET g_tlf_excel[g_cnt].tlf06 = sr.tlf06
   #   LET g_tlf_excel[g_cnt].tlf026 = sr.tlf026
   #   LET g_tlf_excel[g_cnt].tlf62 = sr.tlf62       
   #   LET g_tlf_excel[g_cnt].tlf01 = sr.tlf01
   #   LET g_tlf_excel[g_cnt].ima02 = sr.ima02
   #   LET g_tlf_excel[g_cnt].ima021 = sr.ima021
   #   LET g_tlf_excel[g_cnt].tlfccost = sr.tlfccost
   #   LET g_tlf_excel[g_cnt].tlf10 = sr.tlf10
   #   LET g_tlf_excel[g_cnt].amt01 = sr.amt01
   #   LET g_tlf_excel[g_cnt].amt02 = sr.amt02
   #   LET g_tlf_excel[g_cnt].amt03 = sr.amt03
   #   LET g_tlf_excel[g_cnt].amt04 = sr.amt04
   #   LET g_tlf_excel[g_cnt].amt05 = sr.amt05
   #   LET g_tlf_excel[g_cnt].amt06 = sr.amt06
   #   LET g_tlf_excel[g_cnt].amt07 = sr.amt07
   #   LET g_tlf_excel[g_cnt].amt08 = sr.amt08
   #   LET g_tlf_excel[g_cnt].amt_d = sr.amt_d
   #   IF g_cnt <= g_max_rec THEN
   #      LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
   #   END IF 
   #   LET g_cnt = g_cnt + 1
   #END FOREACH
   #IF g_cnt <= g_max_rec THEN
   #   CALL g_tlf.deleteElement(g_cnt)
   #END IF
   #CALL g_tlf_excel.deleteElement(g_cnt)
   #LET g_rec_b1 = g_cnt-1
   #LET g_rec_b  = g_rec_b1
   #IF g_rec_b > g_max_rec THEN
   #   CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
   #   LET g_rec_b  = g_max_rec 
   #END IF

   #填充axcq778畫面檔數組
   LET sr1.bdate = tm.bdate 
   LET sr1.edate = tm.edate  
   LET sr1.type = tm.type 
   #LET sr1.qty = 0 
   #LET sr1.tot = 0
   #LET sr1.cl  = 0
   #LET sr1.rg  = 0 
   #LET sr1.jg  = 0
   #LET sr1.zz1 = 0
   #LET sr1.zz2 = 0
   #LET sr1.zz3 = 0
   #LET sr1.zz4 = 0
   #LET sr1.zz5 = 0
   SELECT sum(nvl(tlf10,0)),sum(nvl(amt04,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt_d,0)),
          sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt06,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0)) 
     INTO sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,sr1.zz1,sr1.zz2,sr1.zz3,sr1.zz4,sr1.zz5
     FROM axcq778_tmp 
   #IF g_rec_b1 > 0 THEN
   #   FOR i=1 TO g_rec_b1
   #      LET sr1.qty = sr1.qty + g_tlf_excel[i].tlf10
   #      LET sr1.tot = sr1.tot + g_tlf_excel[i].amt04
   #      LET sr1.cl  = sr1.cl  + g_tlf_excel[i].amt01
   #      LET sr1.rg  = sr1.rg  + g_tlf_excel[i].amt02
   #      LET sr1.jg  = sr1.jg  + g_tlf_excel[i].amt_d
   #      LET sr1.zz1 = sr1.zz1 + g_tlf_excel[i].amt03
   #      LET sr1.zz2 = sr1.zz2 + g_tlf_excel[i].amt05
   #      LET sr1.zz3 = sr1.zz3 + g_tlf_excel[i].amt06
   #      LET sr1.zz4 = sr1.zz4 + g_tlf_excel[i].amt07
   #      LET sr1.zz5 = sr1.zz5 + g_tlf_excel[i].amt08
   #   END FOR  
   #END IF 
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092

END FUNCTION

FUNCTION q778_b_fill()
   LET g_sql = "SELECT ima12,azf03,tlf01,ima02,ima021,tlf905,tlf19,occ02,tlf021,tlf06,tlf026,tlf62,tlfccost,",
               "       tlf10,amt01,amt02,amt03,amt_d,amt05,amt06,amt07,amt08,amt04 ",
               "  FROM axcq778_tmp "   

   PREPARE axcq778_pb FROM g_sql
   DECLARE tlf_curs  CURSOR FOR axcq778_pb        #CURSOR

   CALL g_tlf.clear()
   CALL g_tlf_excel.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH tlf_curs INTO g_tlf_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt <= g_max_rec THEN 
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF 
      LET g_cnt = g_cnt + 1 
   END FOREACH

   SELECT sum(nvl(tlf10,0)),sum(nvl(amt04,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt_d,0)),
          sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt06,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0)) 
     INTO sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,sr1.zz1,sr1.zz2,sr1.zz3,sr1.zz4,sr1.zz5
     FROM axcq778_tmp 
   IF g_cnt <= g_max_rec THEN 
      CALL g_tlf.deleteElement(g_cnt)
   END IF 
   CALL g_tlf_excel.deleteElement(g_cnt)
   LET g_cnt = g_cnt -1      
   LET g_rec_b = g_cnt
   IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec 
   END IF 
   DISPLAY g_rec_b TO FORMONLY.cn2 
END FUNCTION

FUNCTION q778_b_fill_2()

   CALL g_tlf_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   SELECT sum(nvl(tlf10,0)),sum(nvl(amt04,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt_d,0)),
          sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt06,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0)) 
     INTO sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,sr1.zz1,sr1.zz2,sr1.zz3,sr1.zz4,sr1.zz5
     FROM axcq778_tmp 
   CALL q778_get_sum()
     
END FUNCTION

FUNCTION q778_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,  
          l_sql        STRING, 
          l_sql1       STRING,
          l_tmp        STRING   

   LET l_sql = "SELECT ima12,azf03,tlf01,ima02,ima021,tlf905,tlf19,occ02,tlf021,tlf06,tlf026,tlf62,tlfccost,",
               "       tlf10,amt01,amt02,amt03,amt_d,amt05,amt06,amt07,amt08,amt04 ",
               "  FROM axcq778_tmp " 
               
   LET l_sql1= "SELECT sum(nvl(tlf10,0)),sum(nvl(amt04,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt_d,0)), ",
               "       sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt06,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0))  ",
               "  FROM axcq778_tmp  "


   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_tlf_1[p_ac].ima12) THEN 
            LET g_tlf_1[p_ac].ima12 = ''
            LET l_tmp = " OR ima12 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql ," WHERE (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                            " ORDER BY ima12,tlf01,tlf905,tlf19 "
         LET l_sql1= l_sql1," WHERE (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )"

      WHEN "2"
         IF cl_null(g_tlf_1[p_ac].tlf01) THEN 
            LET g_tlf_1[p_ac].tlf01 = ''
            LET l_tmp = " OR tlf01 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql ," WHERE (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )",
                            " ORDER BY tlf01,ima12,tlf905,tlf19 "
         LET l_sql1= l_sql1," WHERE (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )"
         
      WHEN "3"
         IF cl_null(g_tlf_1[p_ac].tlf905) THEN 
            LET g_tlf_1[p_ac].tlf905 = ''
            LET l_tmp = " OR tlf905 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql, " WHERE (tlf905 = '",g_tlf_1[p_ac].tlf905 CLIPPED,"'",l_tmp," )",
                            " ORDER BY tlf905,ima12,tlf01,tlf19 "
         LET l_sql1= l_sql1," WHERE (tlf905 = '",g_tlf_1[p_ac].tlf905 CLIPPED,"'",l_tmp," )"
         
      WHEN "4"
         IF cl_null(g_tlf_1[p_ac].tlf19) THEN 
            LET g_tlf_1[p_ac].tlf19 = ''
            LET l_tmp = " OR tlf19 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql ," WHERE (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"'",l_tmp," )",
                            " ORDER BY tlf19,ima12,tlf01,tlf905 "
         LET l_sql1= l_sql1," WHERE (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"'",l_tmp," )"
         
   END CASE

   PREPARE axcq778_pb_detail FROM l_sql
   DECLARE tlf_curs_detail  CURSOR FOR axcq778_pb_detail        #CURSOR
   
   PREPARE axcq778_pb_det_sr1 FROM l_sql1                                                                                               
   DECLARE axcq778_cs_sr1 CURSOR FOR axcq778_pb_det_sr1                                                                                      
   OPEN axcq778_cs_sr1                                                                                                             
   FETCH axcq778_cs_sr1 INTO sr1.qty,sr1.tot,sr1.cl,sr1.rg,sr1.jg,sr1.zz1,sr1.zz2,sr1.zz3,sr1.zz4,sr1.zz5
   CALL g_tlf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH tlf_curs_detail INTO g_tlf_excel[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF g_cnt < = g_max_rec THEN
         LET g_tlf[g_cnt].* = g_tlf_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1  
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_tlf.deleteElement(g_cnt)
   END IF
   CALL g_tlf_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION 

FUNCTION q778_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING

   CASE tm.a
      WHEN '1'
         LET l_sql = "SELECT ima12,azf03,'','','','','','', ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt_d),",
                     "       SUM(amt05),SUM(amt06),SUM(amt07),SUM(amt08),SUM(amt04) ",
                     "  FROM axcq778_tmp ", 
                     " GROUP BY ima12,azf03 ",
                     " ORDER BY ima12,azf03 "
      WHEN '2'
         LET l_sql = "SELECT '','',tlf01,ima02,ima021,'','','', ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt_d),",
                     "       SUM(amt05),SUM(amt06),SUM(amt07),SUM(amt08),SUM(amt04) ",
                     "  FROM axcq778_tmp ", 
                     " GROUP BY tlf01,ima02,ima021 ",
                     " ORDER BY tlf01,ima02,ima021 "
      WHEN '3'
         LET l_sql = "SELECT '','','','','',tlf905,'','', ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt_d),",
                     "       SUM(amt05),SUM(amt06),SUM(amt07),SUM(amt08),SUM(amt04) ",
                     "  FROM axcq778_tmp ", 
                     " GROUP BY tlf905 ",
                     " ORDER BY tlf905 "
      WHEN '4'
         LET l_sql = "SELECT '','','','','','',tlf19,occ02, ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt_d),",
                     "       SUM(amt05),SUM(amt06),SUM(amt07),SUM(amt08),SUM(amt04) ",
                     "  FROM axcq778_tmp ", 
                     " GROUP BY tlf19,occ02 ",
                     " ORDER BY tlf19,occ02 "
   END CASE 
              
   PREPARE q778_pb FROM l_sql
   DECLARE q778_curs1 CURSOR FOR q778_pb
   FOREACH q778_curs1 INTO g_tlf_1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   CALL g_tlf_1.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cnt1 
END FUNCTION  
 
FUNCTION q778_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q778_b_fill()
   END IF
   LET g_action_choice = " "
   LET g_flag = ' '
   IF cl_null(tm.a) THEN LET tm.a = '3' END IF 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.bdate TO bdate
   DISPLAY tm.edate TO edate
   DISPLAY tm.type TO TYPE
   DISPLAY tm.b TO b
   DISPLAY tm.c TO c
   DISPLAY tm.a TO a 
   DISPLAY BY NAME sr1.*
   DISPLAY g_rec_b TO FORMONLY.cn2 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q778_b_fill_2()
               CALL q778_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q778_b_fill()
               CALL g_tlf_1.clear()
            END IF
            DISPLAY BY NAME tm.a
            EXIT DIALOG
      END INPUT
      DISPLAY ARRAY g_tlf TO s_tlf.* 
         BEFORE ROW
            LET l_ac = ARR_CURR()
      END DISPLAY 
      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      #TQC-D30024--mark--str--
      #ON ACTION ACCEPT
      #   LET l_ac = ARR_CURR()
      #   EXIT DIALOG
      #TQC-D30024--mark--end---
   
      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION refresh_detail          #明細資料刷新
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG
         
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
      &include "qry_string.4gl"
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q778_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q778_b_fill_2()
   DISPLAY  tm.a TO a
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   DISPLAY BY NAME sr1.*
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q778_b_fill_2()
               CALL q778_set_visible()
               LET g_action_choice = "page2"
            END IF
            DISPLAY  tm.a TO a
            EXIT DIALOG
      END INPUT
      DISPLAY ARRAY g_tlf_1 TO s_tlf_1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

      END DISPLAY

      ON ACTION page1
         LET g_action_choice="page1"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      ON ACTION ACCEPT
         LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q778_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  
            LET g_flag = '1'             
            EXIT DIALOG 
         END IF
   
      ON ACTION refresh_detail
         CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page2", TRUE)
         LET g_action_choice = 'page1' 
         EXIT DIALOG
         
      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG


      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q778_table()
   DROP TABLE axcq778_tmp;
   CREATE TEMP TABLE axcq778_tmp( 
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021, 
         tlf905   LIKE tlf_file.tlf905,
         tlf19    LIKE tlf_file.tlf19, 
         occ02    LIKE occ_file.occ02,
         tlf021   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf036,    
         tlf62    LIKE tlf_file.tlf62, 
         tlfccost LIKE tlfc_file.tlfccost,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt_d    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         tlf907   LIKE type_file.num5)   
END FUNCTION 

FUNCTION q778_set_visible()
   CALL cl_set_comp_visible("ima12_1,azf03_1,tlf01_1,ima02_1,ima021_1,tlf905_1,tlf19_1,occ02_1",TRUE)
   CASE tm.a 
      WHEN "1"
         CALL cl_set_comp_visible("tlf01_1,ima02_1,ima021_1,tlf905_1,tlf19_1,occ02_1",FALSE)
      WHEN "2"
         CALL cl_set_comp_visible("ima12_1,azf03_1,tlf905_1,tlf19_1,occ02_1",FALSE)
      WHEN "3"
         CALL cl_set_comp_visible("ima12_1,azf03_1,tlf01_1,ima02_1,ima021_1,tlf19_1,occ02_1",FALSE)
      WHEN "4"
         CALL cl_set_comp_visible("ima12_1,azf03_1,tlf01_1,ima02_1,ima021_1,tlf905_1",FALSE)
   END CASE
END FUNCTION  
