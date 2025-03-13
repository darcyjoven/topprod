# Prog. Version..: '5.30.06-13.03.19(00005)'     #
#
# Pattern name...: axcq777.4gl
# Descriptions...: 
# Date & Author..: 12/08/28 By fengrui #No.FUN-C80092
# Modify.........: No.FUN-C80092 12/09/12 By lixh1 增加寫入日誌功能 
# Modify.........: No.FUN-C80092 12/09/18 By fengrui 增加axcq100串查功能,最大筆數控制與excel導出處理 
# Modify.........: NO.FUN-D10022 13/01/05 By fengrui 程式效能優化
# Modify.........: No:FUN-D20078 13/02/27 By xujing 倉退單過帳寫tlf時,區分一般倉退和委外倉退,同時修正成本計算及相關查詢報表邏輯
# Modify.........: No:TQC-D30024 13/03/07 By fengrui 根據aza63是否啟用多帳套隱藏ima391會計科目二
# Modify.........: No:FUN-D30037 13/03/14 By fengrui 添加checkbox"是否包含差異轉出"
# Modify.........: No.TQC-D50098 13/05/21 By zm 修正判斷是否寫入勾稽表的條件變量
# Modify.........: No:MOD-D60053 13/06/06 By wujie   写入勾稽表的参数应该用tm.z接收

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE
   g_tlf62        LIKE tlf_file.tlf62, 
   g_tlf DYNAMIC ARRAY OF RECORD      
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlf62    LIKE tlf_file.tlf62,
         tlf031   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf036   LIKE tlf_file.tlf036,    
         ima39    LIKE ima_file.ima39 ,  #add
         ima391   LIKE ima_file.ima391,  #add
         tlf930   LIKE tlf_file.tlf930,
         tlfccost LIKE tlfc_file.tlfccost, #add
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222                         
             END RECORD,
   g_tlf_excel DYNAMIC ARRAY OF RECORD          
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlf62    LIKE tlf_file.tlf62,
         tlf031   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf036   LIKE tlf_file.tlf036,    
         ima39    LIKE ima_file.ima39 ,  #add
         ima391   LIKE ima_file.ima391,  #add
         tlf930   LIKE tlf_file.tlf930,
         tlfccost LIKE tlfc_file.tlfccost, #add
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222   
             END RECORD,
   g_tlf_1 DYNAMIC ARRAY OF RECORD
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlf62    LIKE tlf_file.tlf62,
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222   
             END RECORD,
   g_argv1       LIKE type_file.num5,
   g_argv2       LIKE type_file.num5,
   g_argv3       LIKE type_file.chr1,
   g_argv4       LIKE type_file.chr1,
   g_argv5       LIKE type_file.chr1,
   g_argv6       LIKE type_file.chr1,   #FUN-D30037 add
   g_wc,g_sql    STRING,     
   g_rec_b       LIKE type_file.num10,  #FUN-C80092 num5->10       
   g_rec_b1      LIKE type_file.num10,  #FUN-C80092 num5->10   
   g_rec_b2      LIKE type_file.num10,  
   l_ac          LIKE type_file.num10,        
   l_ac1         LIKE type_file.num10       
DEFINE sr        RECORD 
          bdate  LIKE type_file.dat,         
          edate  LIKE type_file.dat,          
          type   LIKE type_file.chr1,        
          qty    LIKE tlf_file.tlf10,     #數量
          tot    LIKE ccc_file.ccc23,     #總金額
          cl     LIKE tlfc_file.tlfc221,  #材料費用 
          rg     LIKE tlfc_file.tlfc222,  #人工費用    
          jg     LIKE tlfc_file.tlfc2232, #加工費用  
          zz1    LIKE tlfc_file.tlfc2231, #製費一 
          zz2    LIKE tlfc_file.tlfc224,  #製費二     
          zz3    LIKE tlfc_file.tlfc2241, #製費三  
          zz4    LIKE tlfc_file.tlfc2242, #製費四  
          zz5    LIKE tlfc_file.tlfc2243  #製費五
          END RECORD 
DEFINE tm RECORD                  
          wc     LIKE type_file.chr1000,      
          bdate  LIKE type_file.dat,         
          edate  LIKE type_file.dat,          
          type   LIKE type_file.chr1, 
          a      LIKE type_file.chr1,
          stock  LIKE type_file.chr1,
          z      LIKE type_file.chr1,       
          diff   LIKE type_file.chr1      #FUN-D30037 add
          END RECORD                   
DEFINE   g_filter_wc     STRING   
DEFINE   g_flag          LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10       
DEFINE   g_chr           LIKE type_file.chr1
DEFINE   g_cka00         LIKE cka_file.cka00    #FUN-C80092
DEFINE   l_bdate,l_edate LIKE type_file.dat
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

   LET g_argv1   = ARG_VAL(1)  #年度    
   LET g_argv2   = ARG_VAL(2)  #期別    
   LET g_argv3   = ARG_VAL(3)  #成本計算類型    
   LET g_argv4   = ARG_VAL(4)  #勾稽否       
   LET g_argv5   = ARG_VAL(5)  #背景執行否        
   LET g_argv6   = ARG_VAL(6)  #是否包含差异转出资料  #FUN-D30037
   LET g_bgjob   = g_argv5 

   CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_bdate,l_edate
   CALL q777_table() 
   IF cl_null(g_bgjob) OR g_bgjob = "N" THEN
      OPEN WINDOW q777_w WITH FORM "axc/42f/axcq777"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      #CALL q777_tm()
      CALL cl_set_act_visible("revert_filter",FALSE)
      CALL cl_set_comp_visible("ima391", g_aza.aza63='Y')  #TQC-D30024 add
      CALL q777_q()
      CALL q777_menu()
      CLOSE WINDOW q777_w
   ELSE 
      CALL q777()
   END IF       

   DROP TABLE axcq777_tmp;
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q777_menu()
   WHILE TRUE
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page1" THEN
            CALL q777_bp("G")
         END IF
         IF g_action_flag = "page2" THEN
            CALL q777_bp2()
         END IF
      END IF
      CASE g_action_choice
         WHEN "page1"
            CALL q777_bp("G")
         WHEN "page2"
            CALL q777_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN  
               CALL q777_q()
            END IF
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q777_filter_askkey()
               CALL q777()        #重填充新臨時表
               CALL q777_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q777()        #重填充新臨時表
               CALL q777_show() 
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
            #darcy:2024/05/07 mark s---
            #  LET w = ui.Window.getCurrent() 
            #  LET f = w.getForm()
            #  IF g_action_flag = "page1" THEN
            #     IF cl_chk_act_auth() THEN
            #        LET page = f.FindNode("Page","page1")
            #        CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_excel),'','')
            #     END IF
            #  END IF  
            #  IF g_action_flag = "page2" THEN 
            #     IF cl_chk_act_auth() THEN
            #        LET page = f.FindNode("Page","page2")
            #        CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_1),'','')
            #     END IF
            #  END IF
            #darcy:2024/05/07 mark e---
            LET g_action_choice = " "
            #darcy:2024/05/07 add s---
            call cl_download_by_explorer(
                  cl_expexcel2(
                        "s_tlf",base.typeinfo.create(g_tlf_excel),
                        "s_tlf_1",base.typeinfo.create(g_tlf_1)
                  ))
            #darcy:2024/05/07 add e---
      END CASE
   END WHILE
END FUNCTION

FUNCTION q777_cs()
   DEFINE l_flag            LIKE type_file.chr1

   CLEAR FORM   #清除畫面
   CALL cl_opmsg('q')

   LET g_bgjob = 'N'
   
   INITIALIZE tm.* TO NULL
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = g_ccz.ccz28  
   LET tm.a    = '3'
   LET tm.stock= '1'  
   LET tm.z= 'Y'   
   LET tm.diff= 'N'    #FUN-D30037 add
   LET g_filter_wc = ' 1=1'
   LET g_action_flag = ''

   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)

   DIALOG ATTRIBUTE(UNBUFFERED)   
      INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.stock,tm.z,tm.diff,tm.a ATTRIBUTE(WITHOUT DEFAULTS) #FUN-D30037 diff

         BEFORE INPUT
            IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
               CALL s_azm(g_argv1,g_argv2) RETURNING l_flag,tm.bdate,tm.edate
               LET tm.type = g_argv3  
               DISPLAY BY NAME tm.bdate,tm.edate,tm.type,tm.stock,tm.z,tm.a
               CALL cl_set_comp_entry('bdate,edate,type',FALSE)
            ELSE 
               CALL cl_set_comp_entry('bdate,edate,type',TRUE)
            END IF 

         BEFORE FIELD bdate
            CALL cl_set_comp_entry('z',TRUE)

         AFTER FIELD bdate
            IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','agl-031',0)
               END IF
               IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN
                  LET tm.z = 'N'
                  DISPLAY BY NAME tm.z
                  CALL cl_set_comp_entry('z',FALSE)
               END IF
            END IF

         BEFORE FIELD edate
            CALL cl_set_comp_entry('z',TRUE)

         AFTER FIELD edate
            IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','agl-031',0)
               END IF
               IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN
                  LET tm.z = 'N'
                  DISPLAY BY NAME tm.z
                  CALL cl_set_comp_entry('z',FALSE)
               END IF
            END IF
            
          AFTER INPUT
            IF INT_FLAG THEN
               EXIT DIALOG
            END IF
            IF tm.edate < tm.bdate THEN
               CALL cl_err('','agl-031',0)
               NEXT FIELD edate
            END IF
      END INPUT
      CONSTRUCT tm.wc ON ima12,ima57,ima08,tlf01,tlf62,
                         tlf031,tlf06,tlf036,ima39,ima391,  #FUN-D10022
                         tlf930,tlf10                       #FUN-D10022
                    FROM s_tlf[1].ima12,s_tlf[1].ima57,s_tlf[1].ima08,s_tlf[1].tlf01,s_tlf[1].tlf62,
                         s_tlf[1].tlf031,s_tlf[1].tlf06,s_tlf[1].tlf036,s_tlf[1].ima39,s_tlf[1].ima391, #FUN-D10022
                         s_tlf[1].tlf930,s_tlf[1].tlf10     #FUN-D10022
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
            WHEN INFIELD(tlf62)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf62 
               NEXT FIELD tlf62 
            #FUN-D10022--add--str--
            WHEN INFIELD(tlf031)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img21"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf031
               NEXT FIELD tlf031
            WHEN INFIELD(tlf036)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfu"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf036
               NEXT FIELD tlf036
            WHEN INFIELD(ima39)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima39
               NEXT FIELD ima39
            WHEN INFIELD(ima391)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima391"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima391
               NEXT FIELD ima391
            WHEN INFIELD(tlf930)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_smh"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf930
               NEXT FIELD tlf930
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
      INITIALIZE tm.* TO NULL                        
      INITIALIZE sr.* TO NULL                         
      DELETE FROM axcq777_tmp                         
   END IF 
   CALL q777()

END FUNCTION 


FUNCTION q777_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q777_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q777_show()
END FUNCTION

FUNCTION q777_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM

   CONSTRUCT l_wc ON ima12,ima57,ima08,tlf01,tlf62,
                     tlf031,tlf06,tlf036,ima39,ima391,  #FUN-D10022
                     tlf930,tlf10                       #FUN-D10022
                 FROM s_tlf[1].ima12,s_tlf[1].ima57,s_tlf[1].ima08,s_tlf[1].tlf01,s_tlf[1].tlf62,
                      s_tlf[1].tlf031,s_tlf[1].tlf06,s_tlf[1].tlf036,s_tlf[1].ima39,s_tlf[1].ima391, #FUN-D10022
                      s_tlf[1].tlf930,s_tlf[1].tlf10    #FUN-D10022
      BEFORE CONSTRUCT
         DISPLAY tm.bdate TO bdate
         DISPLAY tm.edate TO edate
         DISPLAY tm.type TO type
         DISPLAY tm.z TO z
         DISPLAY tm.stock TO stock
         DISPLAY tm.a TO a
         DISPLAY tm.diff TO diff
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
            WHEN INFIELD(tlf62)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf62 
               NEXT FIELD tlf62
            #FUN-D10022--add--str--
            WHEN INFIELD(tlf031)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_img21"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf031
               NEXT FIELD tlf031
            WHEN INFIELD(tlf036)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfu"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf036
               NEXT FIELD tlf036
            WHEN INFIELD(ima39)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima39
               NEXT FIELD ima39
            WHEN INFIELD(ima391)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima391"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima391
               NEXT FIELD ima391
            WHEN INFIELD(tlf930)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_smh"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf930
               NEXT FIELD tlf930
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
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION

FUNCTION q777_show()
   DISPLAY tm.a TO a
   IF cl_null(g_action_flag) OR g_action_flag="page2" THEN
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
      CALL q777_b_fill_2()
   ELSE
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      CALL q777_b_fill()  
   END IF
   CALL q777_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION
       
FUNCTION q777()        
   DEFINE l_sql       STRING,
          l_where     STRING,
          i           LIKE type_file.num10,  #FUN-C80092 num5->10 
          l_flag      LIKE type_file.chr1
   DEFINE l_ckk       RECORD LIKE ckk_file.* 
   DEFINE l_ccg02b  LIKE ccg_file.ccg02,   
          l_ccg03b  LIKE ccg_file.ccg03,  
          l_ccg02e  LIKE ccg_file.ccg02,    
          l_ccg03e  LIKE ccg_file.ccg03,
          l_bmm     LIKE type_file.num5,                 
          l_emm     LIKE type_file.num5              
DEFINE    l_tlf032   LIKE tlf_file.tlf032     
DEFINE    l_tlf930   LIKE tlf_file.tlf930     
DEFINE    l_ima39    LIKE ima_file.ima39      
DEFINE    l_ima391   LIKE ima_file.ima391    
DEFINE    l_ccz07    LIKE ccz_file.ccz07                  
DEFINE    l_msg      STRING        #FUN-C80092
DEFINE    l_filter_wc STRING
         
   IF g_bgjob = 'Y' THEN 
      INITIALIZE tm.* TO NULL
      LET tm.wc = ' 1=1' 
      CALL s_azm(g_argv1,g_argv2) RETURNING l_flag,tm.bdate,tm.edate
      IF NOT l_flag OR cl_null(tm.bdate) OR cl_null(tm.edate) THEN 
         CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,tm.bdate,tm.edate
      END IF 
      LET tm.type = g_argv3
      LET tm.z    = g_argv4   #No.MOD-D60053  tm.a --> tm.z
      LET tm.diff = g_argv6 #FUN-D30037
      LET tm.stock = '1'
   END IF 
   DELETE FROM axcq777_tmp                         
#FUN-C80092 ---------Begin--------------
   LET l_msg = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.type = '",tm.type,"'",";",
               "tm.stock = '",tm.stock,"'",";","tm.a = '",tm.a,"'",";","tm.diff = '",tm.diff,"'"  #FUN-D30037 
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00
#FUN-C80092 ---------End----------------
   IF cl_null(tm.wc) THEN LET tm.wc = ' 1=1' END IF
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = ' 1=1' END IF
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

     #ima12,azf03,ima57,ima08,tlf01,ima02,ima021,tlf62,tlf031,
     #tlf06,tlf036,ima39,ima391,tlf930,lfccost,
     #tlf10,amt01,amt02,amt03,amt04,amt05,amt07,amt08,amt09,amt06
                 
     LET l_sql = "SELECT nvl(trim(ima12),'') ima12,azf03,nvl(trim(ima57),'') ima57,nvl(trim(ima08),'') ima08,",
                 "       nvl(trim(tlf01),'') tlf01,ima02,ima021,nvl(trim(tlf62),'') tlf62,tlf031, ",      
                #"       tlf06,tlf036,ima39,ima391,tlf930,tlfccost, ",     #FUN-D20078 mark
                 "       tlf06,tlf905,ima39,ima391,tlf930,tlfccost, ",     #FUN-D20078 add
                #"       tlf10*tlf60 tlf10,nvl(tlfc221,0) amt01,nvl(tlfc222,0) amt02,nvl(tlfc2231,0) amt03,nvl(tlfc2232,0) amt04,",  #FUN-D20078 mark
                 "       tlf10*tlf60*tlf907 tlf10,nvl(tlfc221,0)*tlf907 amt01,nvl(tlfc222,0)*tlf907 amt02,nvl(tlfc2231,0)*tlf907 amt03,", #FUN-D20078 add
                 "       nvl(tlfc2232,0)*tlf907 amt04,",  #FUN-D20078 add
                #"       nvl(tlfc224,0) amt05,nvl(tlfc2241,0) amt07,nvl(tlfc2242,0) amt08,nvl(tlfc2243,0) amt09,0 amt06 ",    #FUN-D20078 mark
                 "       nvl(tlfc224,0)*tlf907 amt05,nvl(tlfc2241,0)*tlf907 amt07,nvl(tlfc2242,0)*tlf907 amt08,nvl(tlfc2243,0)*tlf907 amt09,0 amt06 ",  #FUN-D20078 add
                 "  FROM tlf_file LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf02=tlfc02 AND tlf03 = tlfc03 AND tlf13=tlfc13 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906,",
                 "       ima_file LEFT OUTER JOIN azf_file ON azf01=ima12 AND azf02='G',sfb_file  ",         
                 " WHERE ima01 = tlf01 and tlf62=sfb01",
                 "   AND sfb02!=11",   
                 "   AND ",tm.wc CLIPPED,
                 "   AND ",g_filter_wc CLIPPED,
                 "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
                 "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                 " AND tlfc_file.tlfctype = '",tm.type,"'"

     CASE tm.stock
        WHEN "2"
           LET l_where = "   AND (tlf13 = 'asft6201' OR tlf13='asft6101' ",
                         "    OR  tlf13 = 'asft6231' OR tlf13='asft660' OR tlf13='asft700')"
        WHEN "3"
           LET l_where = "   AND (tlf13='asft700')"
        OTHERWISE
           LET l_where = "   AND (tlf13 = 'asft6201' OR tlf13='asft6101' ",
                         "    OR  tlf13 = 'asft6231' OR tlf13='asft660' )"
     END CASE
     LET l_sql = l_sql CLIPPED, l_where CLIPPED

     LET l_sql = " INSERT INTO axcq777_tmp ",l_sql CLIPPED 
     PREPARE q777_ins FROM l_sql
     EXECUTE q777_ins

     LET l_sql = " UPDATE axcq777_tmp ",
                 "    SET amt06 =nvl(amt01+amt02+amt03+amt04+amt05+amt07+amt08+amt09,0) "
     PREPARE q777_pre1 FROM l_sql
     EXECUTE q777_pre1     
     
     SELECT ccz07 INTO l_ccz07 FROM ccz_file WHERE ccz00 = '0' 

     CASE WHEN l_ccz07='1'                                                                                                    
           LET l_sql=
               " MERGE INTO axcq777_tmp o ",
               "      USING (SELECT ima01,ima39,ima391 FROM ima_file ) x ",
               "         ON (o.tlf01 = x.ima01 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.ima39 ,",
               "           o.ima391= x.ima391 "                                                               
          WHEN l_ccz07='2'   
           LET l_sql=
               " MERGE INTO axcq775_tmp o ",
               "      USING (SELECT ima01,imz39,imz391 FROM ima_file,imz_file ",
               "              WHERE ima06=imz01 ) x ",
               "         ON (o.tlf01 = x.ima01 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.imz39 ,",
               "           o.ima391= x.imz391 "                                                             
          WHEN l_ccz07='3'    
           LET l_sql=
               " MERGE INTO axcq775_tmp o ",
               "      USING (SELECT imd01,imd08,imd081 FROM imd_file) x ",
               "         ON (o.tlf031 = x.imd01 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.imd08 ,",
               "           o.ima391= x.imd081 "     
          WHEN l_ccz07='4'          
           LET l_sql=
               " MERGE INTO axcq775_tmp o ",
               "      USING (SELECT imd01,ime09,ime091 FROM ime_file) x ",
               "         ON (o.tlf031 = x.ime01 AND o.tlf032 = x.ime02 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ima39 = x.ime09 ,",
               "           o.ima391= x.ime091 "                   
     END CASE
     IF l_ccz07 MATCHES '[1234]' THEN 
        LET l_sql = l_sql , " WHERE trim(o.ima12) IS NOT NULL OR o.ima12 <> 'ZZZ' "
        PREPARE q777_pre2 FROM l_sql
        EXECUTE q777_pre2 
     END IF      

     IF tm.stock <> '3' THEN
        #ccz09 = 'Y' 時,在製差異轉出歸本月入庫
        LET l_ccg02b= YEAR(tm.bdate)   
        LET l_ccg03b= MONTH(tm.bdate)   
        LET l_ccg02e= YEAR(tm.edate)    
        LET l_ccg03e= MONTH(tm.edate)   
        CALL s_yp(tm.bdate) RETURNING l_ccg02b,l_ccg03b
        CALL s_yp(tm.edate) RETURNING l_ccg02e,l_ccg03e
        LET l_bmm = l_ccg02b * 12 + l_ccg03b
        LET l_emm = l_ccg02e * 12 + l_ccg03e

        LET l_filter_wc=cl_replace_str(g_filter_wc,'tlf01','ima01')
        LET l_filter_wc=cl_replace_str(l_filter_wc,'tlf62','ccg01')
        #ima12,azf03,ima57,ima08,tlf01,ima02,ima021,tlf62,tlf031,
        #tlf06,tlf036,ima39,ima391,tlf930,lfccost,
        #tlf10,amt01,amt02,amt03,amt04,amt05,amt07,amt08,amt09,amt06
                    
        LET l_sql = "SELECT ima12,azf03,ima57,ima08,ccg04 tlf01,ima02,ima021,ccg01 tlf62,'' tlf031, ",
                    "       '' tlf06,'' tlf036,ima39,ima391,'' tlf930,ccg07 tlfccost," ,        
                    "       nvl(ccg31,0) tlf10,nvl(-ccg32a,0) amt01,nvl(-ccg32b,0) amt02,nvl(-ccg32c,0) amt03,",
                    "       nvl(-ccg32d,0) amt04,nvl(-ccg32e,0) amt05,nvl(-ccg32f,0) amt07,nvl(-ccg32g,0) amt08,nvl(-ccg32h,0) amt09,",
                    "       (nvl(-ccg32a,0)+nvl(-ccg32b,0)+nvl(-ccg32c,0)+nvl(-ccg32d,0)+nvl(-ccg32e,0)+nvl(-ccg32f,0)+nvl(-ccg32g,0)+nvl(-ccg32h,0)) amt06",   
                    "  FROM ccg_file,ima_file LEFT OUTER JOIN azf_file ON azf01=ima12 AND azf02='G',sfb_file ",
                    " WHERE (ccg02 * 12 + ccg03) BETWEEN ",l_bmm CLIPPED,
                    "   AND ",l_emm CLIPPED,
                    "   AND sfb02<>'11' ",
                    "   AND ccg32 <>0 ",
                    "   AND ccg06 = '",tm.type,"'",   
                    "   AND ima01 = ccg04 ",
                    "   AND ccg31 = 0 ",
                    "   AND sfb01 = ccg01 ",
                    "   AND ",tm.wc CLIPPED ,
                    "   AND ",g_filter_wc CLIPPED

        LET l_sql = " INSERT INTO axcq777_tmp ",l_sql CLIPPED 
        PREPARE q777_ins1 FROM l_sql
        EXECUTE q777_ins1                    
     
  
        IF tm.diff = 'Y' THEN   #FUN-D30037 add
           #ccz09 = 'N' 時,在製差異轉出歸差異ccg42 (成本分群預設為'ZZZ')
           CALL s_yp(tm.bdate) RETURNING l_ccg02b,l_ccg03b
           CALL s_yp(tm.edate) RETURNING l_ccg02e,l_ccg03e

           #ima12,azf03,ima57,ima08,tlf01,ima02,ima021,tlf62,tlf031,
           #tlf06,tlf036,ima39,ima391,tlf930,lfccost,
           #tlf10,amt01,amt02,amt03,amt04,amt05,amt07,amt08,amt09,amt06
            LET l_sql = "SELECT 'ZZZ' ima12,(select nvl(azf03,'') from azf_file where azf01='ZZZ' AND azf02='G') azf03,",
                       "       ima57,ima08,ccg04 tlf01,ima02,ima021,ccg01 tlf62,'' tlf031,",
                       "       '' tlf06,'' tlf036,ima39,ima391,'' tlf930,ccg07 tlfccost, ",
                       "       nvl(ccg41,0) tlf10,-ccg42a amt01,-ccg42b amt02,-ccg42c amt03,-ccg42d amt04,-ccg42e amt05,-ccg42f amt07,-ccg42g amt08,-ccg42h amt09, ",
                       "       (nvl(-ccg42a,0)+nvl(-ccg42b,0)+nvl(-ccg42c,0)+nvl(-ccg42d,0)+nvl(-ccg42e,0)+nvl(-ccg42f,0)+nvl(-ccg42g,0)+nvl(-ccg42h,0)) amt06",                   
                       "  FROM ccg_file,ima_file LEFT OUTER JOIN azf_file ON azf01=ima12 AND azf02='G',sfb_file ",
                       " WHERE ccg02 >= ",l_ccg02b," AND ccg03 >= ",l_ccg03b,   
                       "   AND ccg02 <= ",l_ccg02e," AND ccg03 <= ",l_ccg03e,   
                       "   AND sfb02<>'11' ",
                       "   AND ccg42 <>0 ",
                       "   AND ccg06 = '",tm.type,"'",                        
                       "   AND ima01 = ccg04 ",
                       "   AND sfb01 = ccg01 ",
                       "   AND ",tm.wc CLIPPED,
                       "   AND ",g_filter_wc CLIPPED
           LET l_sql = " INSERT INTO axcq777_tmp ",l_sql CLIPPED 
           PREPARE q777_ins2 FROM l_sql
           EXECUTE q777_ins2
        END IF    #FUN-D30037 add
     END IF  
   

                
   #  LET l_sql = "SELECT '',ima12,ima01,ima02,ima021,tlfccost,",      
   #              " tlf021,tlf031,tlf06,tlf036,tlf037,",
   #              " tlf01,tlf10*tlf60,tlfc21,tlf13,tlf62,tlf907,", 
   #              "  tlfc221,tlfc222,tlfc2231,tlfc2232,tlfc224,tlfc2241,tlfc2242,tlfc2243,0,tlf032,tlf930",    
   #              "  FROM tlf_file LEFT OUTER JOIN tlfc_file ON tlf01=tlfc01 AND tlf06=tlfc06 AND tlf02=tlfc02 AND tlf03 = tlfc03 AND tlf13=tlfc13 AND tlf13=tlfc13 AND tlf902=tlfc902 AND tlf903=tlfc903 AND tlf904=tlfc904 AND tlf907=tlfc907 AND tlf905=tlfc905 AND tlf906=tlfc906,ima_file,sfb_file  ",         
   #              " WHERE ima01 = tlf01 and tlf62=sfb01",
   #              "   AND sfb02!=11",   
   #              "   AND ",tm.wc CLIPPED,
   #              "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",
   #              "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
   #              " AND tlfc_file.tlfctype = '",tm.type,"'"
    # PREPARE axcq777_prepare1 FROM l_sql
    # IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
    #    CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
    #    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
    #    EXIT PROGRAM 
    # END IF
    # DECLARE axcq777_curs1 CURSOR FOR axcq777_prepare1
    # FOREACH axcq777_curs1 INTO sr1.*,l_tlf032,l_tlf930 
    #   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    #   LET sr1.code=' '
    #   SELECT sfb99 INTO sr1.code FROM sfb_file WHERE sfb01 = sr1.tlf62
    #   IF SQLCA.sqlcode THEN LET sr1.code = ' ' END IF
    #   IF  cl_null(sr1.amt01)  THEN LET sr1.amt01=0 END IF
    #   IF  cl_null(sr1.amt02)  THEN LET sr1.amt02=0 END IF
    #   IF  cl_null(sr1.amt03)  THEN LET sr1.amt03=0 END IF
    #   IF  cl_null(sr1.amt04)  THEN LET sr1.amt04=0 END IF
    #   IF  cl_null(sr1.amt05)  THEN LET sr1.amt05=0 END IF
    #   IF  cl_null(sr1.amt07)  THEN LET sr1.amt07=0 END IF                 
    #   IF  cl_null(sr1.amt08)  THEN LET sr1.amt08=0 END IF                 
    #   IF  cl_null(sr1.amt09)  THEN LET sr1.amt09=0 END IF                
    #   LET sr1.amt06 = sr1.amt01 + sr1.amt02 + sr1.amt03 + sr1.amt04 + sr1.amt05+ sr1.amt07 + sr1.amt08 + sr1.amt09   
    #   IF  cl_null(sr1.amt06)  THEN LET sr1.amt06=0 END IF
    #   IF cl_null(sr1.ima12) OR  sr1.ima12 !='ZZZ' THEN                                                                    
    #       LET l_sql = "SELECT ccz07 ",                                                                                             
    #                   " FROM ccz_file ",                                                                          
    #                   " WHERE ccz00 = '0' "                                                                                        
    #       CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                                                     
    #       PREPARE ccz_p1 FROM l_sql                                                                                                
    #       IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF                                                       
    #       DECLARE ccz_c1 CURSOR FOR ccz_p1                                                                                         
    #       OPEN ccz_c1                                                                                                              
    #       FETCH ccz_c1 INTO l_ccz07                                                                                                
    #       CLOSE ccz_c1
    #       CASE WHEN l_ccz07='1'                                                                                                    
    #                 LET l_sql="SELECT ima39,ima391 FROM ima_file ",                  
    #                           " WHERE ima01='",sr1.tlf01,"'"                                                                     
    #            WHEN l_ccz07='2'                                                                                                    
    #                LET l_sql="SELECT imz39,imz391 ",                                                  
    #                     " FROM ima_file,imz_file",                                                                      
    #                     " WHERE ima01='",sr1.tlf01,"' AND ima06=imz01 "                                                          
    #            WHEN l_ccz07='3'                                                                                                    
    #                 LET l_sql="SELECT imd08,imd081 FROM imd_file",                          
    #                     " WHERE imd01='",sr1.tlf031,"'"                                                                           
    #            WHEN l_ccz07='4'                                                                                                    
    #                 LET l_sql="SELECT ime09,ime091 FROM ime_file",           
    #                     " WHERE ime01='",sr1.tlf031,"' ",                                                                         
    #                       " AND ime02='",l_tlf032,"'"                                                                           
    #      END CASE
    #      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                                                               
    #      PREPARE stock_p1 FROM l_sql                                                                                               
    #      IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF                                                      
    #      DECLARE stock_c1 CURSOR FOR stock_p1                                                                                      
    #      OPEN stock_c1                                                                                                             
    #      FETCH stock_c1 INTO l_ima39,l_ima391                                                                                           
    #      CLOSE stock_c1       
    #      CALL q777_move(l_tlf930,l_ima39,l_ima391)
    #   END IF 
    # END FOREACH

    # IF tm.stock <> '3' THEN
    #    #ccz09 = 'Y' 時,在製差異轉出歸本月入庫
    #    LET l_ccg02b= YEAR(tm.bdate)   
    #    LET l_ccg03b= MONTH(tm.bdate)   
    #    LET l_ccg02e= YEAR(tm.edate)    
    #    LET l_ccg03e= MONTH(tm.edate)   
    #    CALL s_yp(tm.bdate) RETURNING l_ccg02b,l_ccg03b
    #    CALL s_yp(tm.edate) RETURNING l_ccg02e,l_ccg03e
    #    LET l_bmm = l_ccg02b * 12 + l_ccg03b
    #    LET l_emm = l_ccg02e * 12 + l_ccg03e
    #    LET l_sql = "SELECT 'Z',ima12,ccg04,ima02,ima021, ",
    #                "       ccg07,' ',' ',' ',ima12,' ', ",
    #                "       ima01,ccg31,ccg32,' ',ccg01, ",            
    #                "       ' ',-ccg32a,-ccg32b,-ccg32c,-ccg32d,-ccg32e,-ccg32f,-ccg32g,-ccg32h,0 ",   
    #                "  FROM ccg_file,ima_file,sfb_file ",
    #                " WHERE (ccg02 * 12 + ccg03) BETWEEN ",l_bmm CLIPPED,
    #                "   AND ",l_emm CLIPPED,
    #                "   AND sfb02<>'11' ",
    #                "   AND ccg32 <>0 ",
    #                "   AND ccg06 = '",tm.type,"'",   
    #                "   AND ima01 = ccg04 ",
    #                "   AND ccg31 = 0 ",
    #                "   AND sfb01 = ccg01 ",
    #                "   AND ",tm.wc CLIPPED
  
    #    PREPARE q777_prepare1 FROM l_sql
    #    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
    #       CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092 
    #       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
    #       EXIT PROGRAM 
    #    END IF
    #    DECLARE q777_ccg_cur CURSOR FOR q777_prepare1
    #    FOREACH q777_ccg_cur INTO sr1.*
    #       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    #       IF  cl_null(sr1.amt01)  THEN LET sr1.amt01=0 END IF
    #       IF  cl_null(sr1.amt02)  THEN LET sr1.amt02=0 END IF
    #       IF  cl_null(sr1.amt03)  THEN LET sr1.amt03=0 END IF
    #       IF  cl_null(sr1.amt04)  THEN LET sr1.amt04=0 END IF
    #       IF  cl_null(sr1.amt05)  THEN LET sr1.amt05=0 END IF
    #       IF  cl_null(sr1.amt07)  THEN LET sr1.amt07=0 END IF                  
    #       IF  cl_null(sr1.amt08)  THEN LET sr1.amt08=0 END IF                
    #       IF  cl_null(sr1.amt09)  THEN LET sr1.amt09=0 END IF               
    #       LET sr1.amt06 = sr1.amt01 + sr1.amt02 + sr1.amt03 + sr1.amt04 + sr1.amt05+ sr1.amt07 + sr1.amt08 + sr1.amt09  
    #       IF  cl_null(sr1.amt06)  THEN LET sr1.amt06=0 END IF                     
    #       CALL q777_move('','','')
    #    END FOREACH
    #    #ccz09 = 'N' 時,在製差異轉出歸差異ccg42 (成本分群預設為'ZZZ')
    #    CALL s_yp(tm.bdate) RETURNING l_ccg02b,l_ccg03b
    #    CALL s_yp(tm.edate) RETURNING l_ccg02e,l_ccg03e
    #    LET l_sql = "SELECT '','ZZZ',ccg04,ima02,ima021, ",
    #                "       ccg07,' ',' ',' ',ima12,' ', ",
    #                "       ima01,ccg41,ccg42,' ',ccg01, ",             
    #                "       ' ',-ccg42a,-ccg42b,-ccg42c,-ccg42d,-ccg42e,-ccg42f,-ccg42g,-ccg42h,0 ",   
    #                "  FROM ccg_file,ima_file,sfb_file ",
    #                " WHERE ccg02 >= ",l_ccg02b," AND ccg03 >= ",l_ccg03b,   
    #                "   AND ccg02 <= ",l_ccg02e," AND ccg03 <= ",l_ccg03e,   
    #                "   AND sfb02<>'11' ",
    #                "   AND ccg42 <>0 ",
    #                "   AND ccg06 = '",tm.type,"'",                        
    #                "   AND ima01 = ccg04 ",
    #                "   AND sfb01 = ccg01 ",
    #                "   AND ",tm.wc CLIPPED 
    #    PREPARE r772_prepare2 FROM l_sql
    #    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
    #       CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
    #       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
    #       EXIT PROGRAM 
    #    END IF
    #    DECLARE r772_ccg_cur1 CURSOR FOR r772_prepare2
    #    FOREACH r772_ccg_cur1 INTO sr.*
    #       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    #       IF  cl_null(sr1.amt01)  THEN LET sr1.amt01=0 END IF
    #       IF  cl_null(sr1.amt02)  THEN LET sr1.amt02=0 END IF
    #       IF  cl_null(sr1.amt03)  THEN LET sr1.amt03=0 END IF
    #       IF  cl_null(sr1.amt04)  THEN LET sr1.amt04=0 END IF
    #       IF  cl_null(sr1.amt05)  THEN LET sr1.amt05=0 END IF
    #       IF  cl_null(sr1.amt07)  THEN LET sr1.amt07=0 END IF          
    #       IF  cl_null(sr1.amt08)  THEN LET sr1.amt08=0 END IF            
    #       IF  cl_null(sr1.amt09)  THEN LET sr1.amt09=0 END IF            
    #       LET sr1.amt06 = sr1.amt01 + sr1.amt02 + sr1.amt03 + sr1.amt04 + sr1.amt05 + sr1.amt07 + sr1.amt08 + sr1.amt09      
    #       IF  cl_null(sr1.amt06)  THEN LET sr1.amt06=0 END IF                      
    #       CALL q777_move('','','')       
    #    END FOREACH 
    # END IF
    
   #LET g_rec_b  = g_rec_b1
   ##IF g_rec_b > g_max_rec THEN  #FUN-C80092
   #IF g_rec_b > g_max_rec AND (g_bgjob is null OR g_bgjob='N') THEN
   #   CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
   #   LET g_rec_b  = g_max_rec 
   #END IF       

   #填充axcq777畫面檔數組
   LET sr.bdate = tm.bdate 
   LET sr.edate = tm.edate 
   LET sr.type  = tm.type 
   #LET sr.qty = 0 
   #LET sr.tot = 0
   #LET sr.cl  = 0
   #LET sr.rg  = 0 
   #LET sr.jg  = 0
   #LET sr.zz1 = 0
   #LET sr.zz2 = 0
   #LET sr.zz3 = 0
   #LET sr.zz4 = 0
   #LET sr.zz5 = 0
   #IF g_rec_b1 > 0 THEN
   #   FOR i=1 TO g_rec_b1
   #      LET sr.qty = sr.qty + g_tlf_excel[i].tlf10
   #      LET sr.tot = sr.tot + g_tlf_excel[i].amt06
   #      LET sr.cl  = sr.cl  + g_tlf_excel[i].amt01
   #      LET sr.rg  = sr.rg  + g_tlf_excel[i].amt02
   #      LET sr.jg  = sr.jg  + g_tlf_excel[i].amt04
   #      LET sr.zz1 = sr.zz1 + g_tlf_excel[i].amt03
   #      LET sr.zz2 = sr.zz2 + g_tlf_excel[i].amt05
   #      LET sr.zz3 = sr.zz3 + g_tlf_excel[i].amt07
   #      LET sr.zz4 = sr.zz4 + g_tlf_excel[i].amt08
   #      LET sr.zz5 = sr.zz5 + g_tlf_excel[i].amt09
   #   END FOR  
   #END IF 

   SELECT sum(nvl(tlf10,0)),sum(nvl(amt06,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt04,0)),
          sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0)),sum(nvl(amt09,0)) 
     INTO sr.qty,sr.tot,sr.cl,sr.rg,sr.jg,sr.zz1,sr.zz2,sr.zz3,sr.zz4,sr.zz5
     FROM axcq777_tmp    
    
   IF NOT cl_null(tm.z) AND tm.z = 'Y' THEN   #TQC-D50098
      CALL s_ckk_fill('','307','axc-438',g_ccz.ccz01,g_ccz.ccz02,'axcq777',tm.type,sr.qty,sr.tot,sr.cl,
                      sr.rg,sr.jg,sr.zz1,sr.zz2,sr.zz3,sr.zz4,sr.zz5,tm.wc,g_user,g_today,TIME,'Y')
         RETURNING l_ckk.*
      IF NOT s_ckk(l_ckk.*,'') THEN  END IF 
   END IF 
   CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
   
END FUNCTION

FUNCTION q777_b_fill()
   #LET g_sql = "SELECT ima12,azf03,tlf01,ima02,ima021,tlf905,tlf19,tlf021,tlf06,tlf026,tlf62,tlfccost,",
   #            "       tlf10,amt01,amt02,amt03,amt_d,amt05,amt06,amt07,amt08,amt04 ",
   #            "  FROM axcq777_tmp "  
   LET g_sql = "SELECT * FROM axcq777_tmp "

   PREPARE axcq777_pb FROM g_sql
   DECLARE tlf_curs  CURSOR FOR axcq777_pb        #CURSOR

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

   SELECT sum(nvl(tlf10,0)),sum(nvl(amt06,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt04,0)),
          sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0)),sum(nvl(amt09,0)) 
     INTO sr.qty,sr.tot,sr.cl,sr.rg,sr.jg,sr.zz1,sr.zz2,sr.zz3,sr.zz4,sr.zz5
     FROM axcq777_tmp  
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

FUNCTION q777_b_fill_2()

   CALL g_tlf_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   SELECT sum(nvl(tlf10,0)),sum(nvl(amt06,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt04,0)),
          sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0)),sum(nvl(amt09,0)) 
     INTO sr.qty,sr.tot,sr.cl,sr.rg,sr.jg,sr.zz1,sr.zz2,sr.zz3,sr.zz4,sr.zz5
     FROM axcq777_tmp  
   CALL q777_get_sum()
     
END FUNCTION

FUNCTION q777_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,  
          l_sql        STRING, 
          l_sql1       STRING,
          l_tmp        STRING   

   LET l_sql = "SELECT * FROM axcq777_tmp " 
               
   LET l_sql1= "SELECT sum(nvl(tlf10,0)),sum(nvl(amt06,0)),sum(nvl(amt01,0)),sum(nvl(amt02,0)),sum(nvl(amt04,0)), ",
               "       sum(nvl(amt03,0)),sum(nvl(amt05,0)),sum(nvl(amt07,0)),sum(nvl(amt08,0)),sum(nvl(amt09,0))  ",
               "  FROM axcq777_tmp  "


   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_tlf_1[p_ac].ima12) THEN 
            LET g_tlf_1[p_ac].ima12 = ''
            LET l_tmp = " OR ima12 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql ," WHERE (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                            " ORDER BY ima12,ima57,ima08,tlf01,tlf62 "
         LET l_sql1= l_sql1," WHERE (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )"

      WHEN "2"
         IF cl_null(g_tlf_1[p_ac].ima57) THEN 
            LET g_tlf_1[p_ac].ima57 = ''
            LET l_tmp = " OR ima57 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql ," WHERE (ima57 = '",g_tlf_1[p_ac].ima57 CLIPPED,"'",l_tmp," )",
                            " ORDER BY ima57,ima12,ima08,tlf01,tlf62 "
         LET l_sql1= l_sql1," WHERE (ima57 = '",g_tlf_1[p_ac].ima57 CLIPPED,"'",l_tmp," )"
         
      WHEN "3"
         IF cl_null(g_tlf_1[p_ac].ima08) THEN 
            LET g_tlf_1[p_ac].ima08 = ''
            LET l_tmp = " OR ima08 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql, " WHERE (ima08 = '",g_tlf_1[p_ac].ima08 CLIPPED,"'",l_tmp," )",
                            " ORDER BY ima08,ima12,ima57,tlf01,tlf62 "
         LET l_sql1= l_sql1," WHERE (ima08 = '",g_tlf_1[p_ac].ima08 CLIPPED,"'",l_tmp," )"
         
      WHEN "4"
         IF cl_null(g_tlf_1[p_ac].tlf01) THEN 
            LET g_tlf_1[p_ac].tlf01 = ''
            LET l_tmp = " OR tlf01 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql ," WHERE (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )",
                            " ORDER BY tlf01,ima12,ima57,ima08,tlf62 "
         LET l_sql1= l_sql1," WHERE (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )"

      WHEN "5"
         IF cl_null(g_tlf_1[p_ac].tlf62) THEN 
            LET g_tlf_1[p_ac].tlf62 = ''
            LET l_tmp = " OR tlf62 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql ," WHERE (tlf62 = '",g_tlf_1[p_ac].tlf62 CLIPPED,"'",l_tmp," )",
                            " ORDER BY tlf62,ima12,ima57,ima08,tlf01 "
         LET l_sql1= l_sql1," WHERE (tlf62 = '",g_tlf_1[p_ac].tlf62 CLIPPED,"'",l_tmp," )"         
   END CASE

   PREPARE axcq777_pb_detail FROM l_sql
   DECLARE tlf_curs_detail  CURSOR FOR axcq777_pb_detail        #CURSOR
   
   PREPARE axcq777_pb_det_sr1 FROM l_sql1                                                                                               
   DECLARE axcq777_cs_sr1 CURSOR FOR axcq777_pb_det_sr1                                                                                      
   OPEN axcq777_cs_sr1                                                                                                             
   FETCH axcq777_cs_sr1 INTO sr.qty,sr.tot,sr.cl,sr.rg,sr.jg,sr.zz1,sr.zz2,sr.zz3,sr.zz4,sr.zz5
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

FUNCTION q777_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING

   CASE tm.a
      WHEN '1'
         LET l_sql = "SELECT ima12,azf03,'','','','','','', ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04),",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06) ",
                     "  FROM axcq777_tmp ", 
                     " GROUP BY ima12,azf03 ",
                     " ORDER BY ima12,azf03 "
      WHEN '2'
         LET l_sql = "SELECT '','',ima57,'','','','','', ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04),",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06) ",
                     "  FROM axcq777_tmp ", 
                     " GROUP BY ima57 ",
                     " ORDER BY ima57 "
      WHEN '3'
         LET l_sql = "SELECT '','','',ima08,'','','','', ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04),",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06) ",
                     "  FROM axcq777_tmp ", 
                     " GROUP BY ima08 ",
                     " ORDER BY ima08 "
      WHEN '4'
         LET l_sql = "SELECT '','','','',tlf01,ima02,ima021,'', ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04),",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06) ",
                     "  FROM axcq777_tmp ", 
                     " GROUP BY tlf01,ima02,ima021 ",
                     " ORDER BY tlf01,ima02,ima021 "
      WHEN '5'
         LET l_sql = "SELECT '','','','','','','',tlf62, ",
                     "       SUM(tlf10),SUM(amt01),SUM(amt02),SUM(amt03),SUM(amt04),",
                     "       SUM(amt05),SUM(amt07),SUM(amt08),SUM(amt09),SUM(amt06) ",
                     "  FROM axcq777_tmp ", 
                     " GROUP BY tlf62 ",
                     " ORDER BY tlf62 "
   END CASE 
              
   PREPARE q777_pb FROM l_sql
   DECLARE q777_curs1 CURSOR FOR q777_pb
   FOREACH q777_curs1 INTO g_tlf_1[g_cnt].*
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
 
FUNCTION q777_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q777_b_fill()
   END IF
   LET g_action_choice = " "
   DISPLAY BY NAME sr.*
   DISPLAY g_rec_b TO FORMONLY.cn2  
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q777_b_fill_2()
               CALL q777_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q777_b_fill()
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
 
      #ON ACTION ACCEPT
      #   LET l_ac = ARR_CURR()
      #   EXIT DIALOG
   
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


FUNCTION q777_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q777_b_fill_2()
   DISPLAY  tm.a TO a
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   DISPLAY BY NAME sr.*
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q777_b_fill_2()
               CALL q777_set_visible()
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
            CALL q777_detail_fill(l_ac1)
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

FUNCTION q777_table()
   CREATE TEMP TABLE axcq777_tmp( 
         ima12    LIKE ima_file.ima12,
         azf03    LIKE azf_file.azf03,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08,
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlf62    LIKE tlf_file.tlf62,
         tlf031   LIKE tlf_file.tlf031,
         tlf06    LIKE tlf_file.tlf06,
         tlf036   LIKE tlf_file.tlf036,    
         ima39    LIKE ima_file.ima39 ,  
         ima391   LIKE ima_file.ima391,  
         tlf930   LIKE tlf_file.tlf930,
         tlfccost LIKE tlfc_file.tlfccost, 
         tlf10    LIKE tlf_file.tlf10,
         amt01    LIKE tlf_file.tlf222,
         amt02    LIKE tlf_file.tlf222,
         amt03    LIKE tlf_file.tlf222,
         amt04    LIKE tlf_file.tlf222,
         amt05    LIKE tlf_file.tlf222,
         amt07    LIKE tlf_file.tlf222,
         amt08    LIKE tlf_file.tlf222,
         amt09    LIKE tlf_file.tlf222,
         amt06    LIKE tlf_file.tlf222     )   
END FUNCTION 

FUNCTION q777_set_visible()
   CALL cl_set_comp_visible("ima12_1,azf03_1,ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1,tlf62_1",TRUE)
   CASE tm.a 
      WHEN "1"
         CALL cl_set_comp_visible("ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1,tlf62_1",FALSE)
      WHEN "2"
         CALL cl_set_comp_visible("ima12_1,azf03_1,ima08_1,tlf01_1,ima02_1,ima021_1,tlf62_1",FALSE)
      WHEN "3"
         CALL cl_set_comp_visible("ima12_1,azf03_1,ima57_1,tlf01_1,ima02_1,ima021_1,tlf62_1",FALSE)
      WHEN "4"
         CALL cl_set_comp_visible("ima12_1,azf03_1,ima57_1,ima08_1,tlf62_1",FALSE)
      WHEN "5"
         CALL cl_set_comp_visible("ima12_1,azf03_1,ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1",FALSE)
   END CASE
END FUNCTION  

