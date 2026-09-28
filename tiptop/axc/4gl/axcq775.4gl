# Prog. Version..: '5.30.06-13.03.29(00005)'     #
#
# Pattern name...: axcq775.4gl
# Descriptions...: 
# Date & Author..: 12/08/29 By lixh1
# Modify.........: No.FUN-C80092 12/09/18 By fengrui 增加axcq100串查功能,最大筆數控制與excel導出處理 
# Modify.........: No.FUN-C90076 12/11/09 By fengrui 增加出入庫QBE查詢
# Modify.........: No.FUN-C90076 12/12/06 By xujing  增加axcq460傳入參數
# Modify.........: No.TQC-CC0118 12/12/25 By lixh1 修改與axcr770數據不一致問題
# Modify.........: No.FUN-D10022 12/12/31 By fengrui 程式效能優化
# Modify.........: No:TQC-D30024 13/03/07 By fengrui 根據aza63是否啟用多帳套隱藏ima391會計科目二
# Modify.........: No:MOD-D30247 13/03/28 By ck2yuan 系統ina09已無使用，故抓取ina09程式Mark 
# Modify.........: No.TQC-D50098 13/05/21 By fengrui g_filter_wc赋值为' 1=1'
# Modify.........: No.MOD-D60056 13/06/06 By wujie 汇出excel会数据重复 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
   g_tlf01        LIKE tlf_file.tlf01, 
   g_tlf DYNAMIC ARRAY OF RECORD
         ima12    LIKE ima_file.ima12,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08, 
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         #darcy:2024/09/09 add s---
         imaud33  like ima_file.imaud33,
         imaud34  like ima_file.imaud34,
         #darcy:2024/09/09 add e---
         tlf19    LIKE tlf_file.tlf19,
         gem02    LIKE gem_file.gem02,
         tlf14    LIKE tlf_file.tlf14,
         azf03    LIKE azf_file.azf03,  #FUN-D10022
         tlf17    LIKE tlf_file.tlf17,
         tlf021   LIKE tlf_file.tlf021,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf026,    
         ima39    LIKE ima_file.ima39,
         ima391   LIKE ima_file.ima391,
         tlf930   LIKE tlf_file.tlf930,
         tlfccost LIKE type_file.chr100, 
         tlf10    LIKE tlf_file.tlf10,
         ccc23a   LIKE    ccc_file.ccc23a,
         ccc23b   LIKE    ccc_file.ccc23b,
         ccc23c   LIKE    ccc_file.ccc23c,
         ccc23d   LIKE    ccc_file.ccc23d,
         ccc23e   LIKE    ccc_file.ccc23e,
         ccc23f   LIKE    ccc_file.ccc23f,
         ccc23g   LIKE    ccc_file.ccc23g,
         ccc23h   LIKE    ccc_file.ccc23h,
         ccc23a2  LIKE    ccc_file.ccc23a
         #darcy:2023/07/04 add s---
        ,gen01    like    gen_file.gen01,
         gen02    like    gen_file.gen02,
         gem01    like    gem_file.gem01,
         gem021    like    gem_file.gem02,
         pmk04    like    pmk_file.pmk04
         #darcy:2023/07/04 add e---
         ,inbud02 like inb_file.inbud02 #darcy:2023/07/12 add
             END RECORD,
   g_tlf_excel DYNAMIC ARRAY OF RECORD
         ima12    LIKE ima_file.ima12,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08, 
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         #darcy:2024/09/09 add s---
         imaud33  like ima_file.imaud33,
         imaud34  like ima_file.imaud34,
         #darcy:2024/09/09 add e---
         tlf19    LIKE tlf_file.tlf19,
         gem02    LIKE gem_file.gem02,
         tlf14    LIKE tlf_file.tlf14,
         azf03    LIKE azf_file.azf03,  #FUN-D10022
         tlf17    LIKE tlf_file.tlf17,
         tlf021   LIKE tlf_file.tlf021,
         tlf06    LIKE tlf_file.tlf06,
         tlf026   LIKE tlf_file.tlf026,    
         ima39    LIKE ima_file.ima39,
         ima391   LIKE ima_file.ima391,
         tlf930   LIKE tlf_file.tlf930,
         tlfccost LIKE type_file.chr100, 
         tlf10    LIKE tlf_file.tlf10,
         ccc23a   LIKE    ccc_file.ccc23a,
         ccc23b   LIKE    ccc_file.ccc23b,
         ccc23c   LIKE    ccc_file.ccc23c,
         ccc23d   LIKE    ccc_file.ccc23d,
         ccc23e   LIKE    ccc_file.ccc23e,
         ccc23f   LIKE    ccc_file.ccc23f,
         ccc23g   LIKE    ccc_file.ccc23g,
         ccc23h   LIKE    ccc_file.ccc23h,
         ccc23a2  LIKE    ccc_file.ccc23a
         #darcy:2023/07/04 add s---
        ,gen01    like    gen_file.gen01,
         gen02    like    gen_file.gen02,
         gem01    like    gem_file.gem01,
         gem021    like    gem_file.gem02,
         pmk04    like    pmk_file.pmk04
         #darcy:2023/07/04 add e---
         ,inbud02 like  inb_file.inbud02  #darcy:2023/07/12 add
             END RECORD,
   g_tlf_1 DYNAMIC ARRAY OF RECORD
         ima12    LIKE ima_file.ima12,
         ima57    LIKE ima_file.ima57,
         ima08    LIKE ima_file.ima08, 
         tlf01    LIKE tlf_file.tlf01,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         tlf19    LIKE tlf_file.tlf19,
         gem02    LIKE gem_file.gem02,
         tlf14    LIKE tlf_file.tlf14,
         azf03    LIKE azf_file.azf03,  #FUN-D10022
         tlf10    LIKE tlf_file.tlf10,
         ccc23a   LIKE    ccc_file.ccc23a,
         ccc23b   LIKE    ccc_file.ccc23b,
         ccc23c   LIKE    ccc_file.ccc23c,
         ccc23d   LIKE    ccc_file.ccc23d,
         ccc23e   LIKE    ccc_file.ccc23e,
         ccc23f   LIKE    ccc_file.ccc23f,
         ccc23g   LIKE    ccc_file.ccc23g,
         ccc23h   LIKE    ccc_file.ccc23h,
         ccc23a2  LIKE    ccc_file.ccc23a
             END RECORD,
   g_argv1       LIKE type_file.num5,  #年度
   g_argv2       LIKE type_file.num5,  #期別
   g_argv3       LIKE type_file.chr1,  #成本計算類型
   g_argv4       LIKE type_file.chr1,  #勾稽否  
   g_argv5       LIKE type_file.chr1,  #背景執行否 
   g_argv6       LIKE type_file.chr1,  #雜收發      #FUN-C90076 xj
   g_wc,g_sql    STRING,     
   g_cnt         LIKE type_file.num10, 
   g_rec_b       LIKE type_file.num10, #FUN-C80092 num5->10    
   g_rec_b2      LIKE type_file.num10, #FUN-C80092 num5->10  
   l_ac          LIKE type_file.num10, #FUN-C80092 num5->10 
   l_ac1         LIKE type_file.num10  #FUN-C80092 num5->10
   #l_table       STRING,               
   #g_i           LIKE type_file.num5  


DEFINE tm     RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000,   
           bdate   LIKE type_file.dat,      
           edate   LIKE type_file.dat,     
           type    LIKE type_file.chr1,   
           tlf907  LIKE tlf_file.tlf907,
           #b       LIKE type_file.chr1,  #TQC-CC0118
           z       LIKE type_file.chr1,
           a       LIKE type_file.chr1
                   END RECORD 

DEFINE   g_ckk     RECORD LIKE ckk_file.*
DEFINE   l_bdate   LIKE type_file.dat
DEFINE   l_edate   LIKE type_file.dat
DEFINE   s_qty_1   LIKE tlf_file.tlf10,     #數量
         s_tot_1   LIKE ccc_file.ccc23,     #總金額
         s_cl_1    LIKE tlfc_file.tlfc221,  #材料費用
         s_rg_1    LIKE tlfc_file.tlfc222,  #人工費用
         s_jg_1    LIKE tlfc_file.tlfc2232, #加工費用
         s_zf01_1  LIKE tlfc_file.tlfc2231, #製費一
         s_zf02_1  LIKE tlfc_file.tlfc224,  #製費二
         s_zf03_1  LIKE tlfc_file.tlfc2241, #製費三
         s_zf04_1  LIKE tlfc_file.tlfc2242, #製費四
         s_zf05_1  LIKE tlfc_file.tlfc2243  #製費五    

DEFINE   s_qty_2   LIKE tlf_file.tlf10,     #數量
         s_tot_2   LIKE ccc_file.ccc23,     #總金額
         s_cl_2    LIKE tlfc_file.tlfc221,  #材料費用
         s_rg_2    LIKE tlfc_file.tlfc222,  #人工費用
         s_jg_2    LIKE tlfc_file.tlfc2232, #加工費用
         s_zf01_2  LIKE tlfc_file.tlfc2231, #製費一
         s_zf02_2  LIKE tlfc_file.tlfc224,  #製費二
         s_zf03_2  LIKE tlfc_file.tlfc2241, #製費三
         s_zf04_2  LIKE tlfc_file.tlfc2242, #製費四
         s_zf05_2  LIKE tlfc_file.tlfc2243  #製費五    

DEFINE   sr1        RECORD
         qty_sum1   LIKE tlf_file.tlf10,     #數量
         tot_sum1   LIKE ccc_file.ccc23,     #總金額
         cl_sum1    LIKE tlfc_file.tlfc221,  #材料費用
         rg_sum1    LIKE tlfc_file.tlfc222,  #人工費用
         jg_sum1    LIKE tlfc_file.tlfc2232, #加工費用
         zf01_sum1  LIKE tlfc_file.tlfc2231, #製費一
         zf02_sum1  LIKE tlfc_file.tlfc224,  #製費二
         zf03_sum1  LIKE tlfc_file.tlfc2241, #製費三
         zf04_sum1  LIKE tlfc_file.tlfc2242, #製費四
         zf05_sum1  LIKE tlfc_file.tlfc2243  #製費五
                    END RECORD

DEFINE   sr2        RECORD
         qty_sum2   LIKE tlf_file.tlf10,     #數量
         tot_sum2   LIKE ccc_file.ccc23,     #總金額
         cl_sum2    LIKE tlfc_file.tlfc221,  #材料費用
         rg_sum2    LIKE tlfc_file.tlfc222,  #人工費用
         jg_sum2    LIKE tlfc_file.tlfc2232, #加工費用
         zf01_sum2  LIKE tlfc_file.tlfc2231, #製費一
         zf02_sum2  LIKE tlfc_file.tlfc224,  #製費二
         zf03_sum2  LIKE tlfc_file.tlfc2241, #製費三
         zf04_sum2  LIKE tlfc_file.tlfc2242, #製費四
         zf05_sum2  LIKE tlfc_file.tlfc2243  #製費五
                    END RECORD
DEFINE g_filter_wc  STRING 
DEFINE g_cka00      LIKE cka_file.cka00
DEFINE g_flag       LIKE type_file.chr1 
DEFINE g_action_flag LIKE type_file.chr100
DEFINE g_row_count  LIKE type_file.num10  
DEFINE g_curs_index LIKE type_file.num10  
DEFINE w            ui.Window      
DEFINE f            ui.Form       
DEFINE page         om.DomNode 


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

   LET g_argv1   = ARG_VAL(1)    #年度
   LET g_argv2   = ARG_VAL(2)    #期別
   LET g_argv3   = ARG_VAL(3)    #成本計算類型
   LET g_argv4   = ARG_VAL(4)    #勾稽否  
   LET g_argv5   = ARG_VAL(5)    #背景執行否   
   LET g_argv6   = ARG_VAL(6)    #雜收發     #FUN-C90076 xj 
   
   LET g_bgjob   = g_argv5              
   CALL q775_table()  #xj add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    
      OPEN WINDOW q775_w WITH FORM "axc/42f/axcq775"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
      #CALL q775_tm(0,0)
      CALL cl_set_act_visible("revert_filter",FALSE)
      CALL cl_set_comp_visible("ima391", g_aza.aza63='Y')  #TQC-D30024 add
      CALL q775_q()
      CALL q775_menu()
      CLOSE WINDOW q775_w
   ELSE 
      CALL q775()  
   END IF   
   DROP TABLE axcq775_tmp   #xj add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN 

FUNCTION q775_menu()
   WHILE TRUE
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page1" THEN
            CALL q775_bp("G")
         END IF
         IF g_action_flag = "page2" THEN
            CALL q775_bp2()
         END IF
      END IF
      
      CASE g_action_choice
         WHEN "page1"
            CALL q775_bp("G")
         WHEN "page2"
            CALL q775_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN  
               CALL q775_q()
            END IF
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q775_filter_askkey()
               CALL q775()        #重填充新臨時表
               CALL q775_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q775()        #重填充新臨時表
               CALL q775_show() 
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


FUNCTION q775_cs()
   DEFINE p_row,p_col    LIKE type_file.num5,          
          l_flag         LIKE type_file.chr1,          
          l_cmd        LIKE type_file.chr1000      
   DEFINE l_cnt        LIKE type_file.num5          

   CLEAR FORM   #清除畫面
   CALL cl_opmsg('q')  
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
   IF cl_null(g_action_choice) AND NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN    #FUN-C90076 xj
      CALL s_azn01(g_argv1,g_argv2) RETURNING l_bdate,l_edate                            #FUN-C90076 xj
   ELSE                                                                                  #FUN-C90076 xj
      CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_bdate,l_edate
   END IF                                                                                #FUN-C90076 xj
   INITIALIZE tm.* TO NULL
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = g_ccz.ccz28  
   IF NOT cl_null(g_argv6) THEN    #FUN-C90076 xj
      LET tm.tlf907 = g_argv6      #FUN-C90076 xj
   ELSE                            #FUN-C90076 xj
      #LET tm.tlf907 = '1'         #TQC-CC0118
      LET tm.tlf907 = '3'          #TQC-CC0118 
   END IF                          #FUN-C90076 xj
   #LET tm.b   = 'N' #TQC-CC0118 
   LET tm.z = 'Y'
   LET tm.a = '4'
   DISPLAY BY NAME tm.bdate,tm.edate,tm.type,tm.tlf907,tm.z,tm.a #TQC-CC0118 
   LET g_filter_wc = ' 1=1'  #TQC-D50098
   LET g_action_flag = ''
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'

   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)

   DIALOG ATTRIBUTE(UNBUFFERED)   

   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.tlf907,tm.z,tm.a ATTRIBUTE(WITHOUT DEFAULTS) #TQC-CC0118 mark tm.b 

      BEFORE INPUT
         IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN 
            CALL s_azm(g_argv1,g_argv2) RETURNING l_flag,tm.bdate,tm.edate
            LET tm.type = g_argv3
            IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN 
               LET tm.z = 'N'
            ELSE 
               LET tm.z = 'Y'
            END IF
            DISPLAY BY NAME tm.bdate,tm.edate,tm.type,tm.tlf907,tm.z  #TQC-CC0118 
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
 
     AFTER FIELD type
        IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT DIALOG
         END IF
         IF tm.edate < tm.bdate THEN
            CALL cl_err('','agl-031',0)
            NEXT FIELD edate
         END IF
         IF tm.bdate <> l_bdate OR tm.edate <> l_edate THEN
            LET tm.z = 'N'
         END IF 
 
      END INPUT
   
      CONSTRUCT tm.wc ON ima12,ima57,ima08,tlf01,tlf19,tlf14,
                         tlf17,tlf021,tlf06,tlf026,ima39,ima391,  #FUN-D10022
                         tlf930,tlf10                             #FUN-D10022
                    FROM s_tlf[1].ima12,s_tlf[1].ima57,s_tlf[1].ima08,
                         s_tlf[1].tlf01,s_tlf[1].tlf19,s_tlf[1].tlf14,
                         s_tlf[1].tlf17,s_tlf[1].tlf021,s_tlf[1].tlf06,   #FUN-D10022
                         s_tlf[1].tlf026,s_tlf[1].ima39,s_tlf[1].ima391,  #FUN-D10022
                         s_tlf[1].tlf930,s_tlf[1].tlf10                   #FUN-D10022 
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
           WHEN INFIELD(tlf14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1  = "2"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf14
              NEXT FIELD tlf14
           WHEN INFIELD(ima12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1  = "G"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima12 
              NEXT FIELD ima12
           WHEN INFIELD(tlf19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem3"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf19
              NEXT FIELD tlf19
           #FUN-D10022--add--str--
           WHEN INFIELD(tlf021)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img21"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf021
              NEXT FIELD tlf021
           WHEN INFIELD(tlf026)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ina2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf026
              NEXT FIELD tlf026
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
      CLEAR FORM
      INITIALIZE tm.* TO NULL
      INITIALIZE sr1.* TO NULL
      INITIALIZE sr2.* TO NULL
      DELETE FROM axcq775_tmp
      LET INT_FLAG = 0 
      RETURN
   END IF
   LET tm.wc = cl_replace_str(tm.wc,'tlf021','(CASE WHEN tlf907=-1 THEN tlf021 ELSE tlf031 END)') #FUN-D10022
   LET tm.wc = cl_replace_str(tm.wc,'tlf026','(CASE WHEN tlf907=-1 THEN tlf026 ELSE tlf036 END)') #FUN-D10022

   CALL q775()
   #CALL q775_show()
END FUNCTION  

FUNCTION q775_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q775_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q775_show()
END FUNCTION

FUNCTION q775_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM

   CONSTRUCT l_wc ON ima12,ima57,ima08,tlf01,tlf19,tlf14,
                     tlf17,tlf021,tlf06,tlf026,ima39,ima391,  #FUN-D10022
                     tlf930,tlf10                             #FUN-D10022 
                FROM s_tlf[1].ima12,s_tlf[1].ima57,s_tlf[1].ima08, 
                     s_tlf[1].tlf01,s_tlf[1].tlf19,s_tlf[1].tlf14,
                     s_tlf[1].tlf17,s_tlf[1].tlf021,s_tlf[1].tlf06,   #FUN-D10022
                     s_tlf[1].tlf026,s_tlf[1].ima39,s_tlf[1].ima391,  #FUN-D10022
                     s_tlf[1].tlf930,s_tlf[1].tlf10                   #FUN-D10022

      BEFORE CONSTRUCT
         DISPLAY tm.bdate TO bdate
         DISPLAY tm.edate TO edate
         DISPLAY tm.type TO TYPE
         DISPLAY tm.tlf907 TO tlf907
         #DISPLAY tm.b TO b  #TQC-CC0118 
         DISPLAY tm.z TO z
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
           WHEN INFIELD(tlf14)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1  = "2"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf14
              NEXT FIELD tlf14
           WHEN INFIELD(ima12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1  = "G"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima12 
              NEXT FIELD ima12
           WHEN INFIELD(tlf19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem3"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf19
              NEXT FIELD tlf19
           #FUN-D10022--add--str--
           WHEN INFIELD(tlf021)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_img21"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf021
              NEXT FIELD tlf021
           WHEN INFIELD(tlf026)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ina2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tlf026
              NEXT FIELD tlf026
           WHEN INFIELD(ima39)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
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
   LET l_wc = cl_replace_str(l_wc,'tlf021','(CASE WHEN tlf907=-1 THEN tlf021 ELSE tlf031 END)') #FUN-D10022
   LET l_wc = cl_replace_str(l_wc,'tlf026','(CASE WHEN tlf907=-1 THEN tlf026 ELSE tlf036 END)') #FUN-D10022
   IF cl_null(g_filter_wc) THEN LET g_filter_wc = " 1=1" END IF
   LET g_filter_wc = g_filter_wc CLIPPED," AND ",l_wc CLIPPED
END FUNCTION

FUNCTION q775_show()
   DISPLAY tm.a TO a
   IF cl_null(tm.a)  THEN  LET tm.a ='4' END IF 
   IF cl_null(g_action_flag) OR g_action_flag="page2" THEN
      LET g_action_choice = "page2"
      CALL cl_set_comp_visible("page1", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page1", TRUE)
      CALL q775_b_fill_2()
   ELSE
      LET g_action_choice = "page1"
      CALL cl_set_comp_visible("page2", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("page2", TRUE)
      CALL q775_b_fill()  
   END IF
   CALL q775_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q775()
#FUN-D10022--mark--優化--
DEFINE #l_name    LIKE type_file.chr20,          
       l_sql     STRING,                        
      # l_za05    LIKE type_file.chr1000,        
       l_flag    LIKE type_file.num5           
      # l_factor  LIKE oeo_file.oeo06           
      # sr     RECORD 
      #        order1    LIKE type_file.chr20,    #單據編號
      #        tlf037    LIKE    tlf_file.tlf037, 
      #        tlf907    LIKE    tlf_file.tlf907, #出入庫之判斷
      #        tlf13     LIKE    tlf_file.tlf13,  #異動命令代號
      #        tlf14     LIKE    tlf_file.tlf14,  #雜項原因
      #        tlf17     LIKE    tlf_file.tlf17,  #雜項備註
      #        tlf19     LIKE    tlf_file.tlf19,  #部門
      #        tlf021    LIKE    tlf_file.tlf021, #倉庫代號
      #        tlf031    LIKE    tlf_file.tlf031, #倉庫代號
      #        tlf06     LIKE    tlf_file.tlf06,  #入庫日
      #        tlf026    LIKE    tlf_file.tlf026, #單據編號
      #        tlf027    LIKE    tlf_file.tlf027, #
      #        tlf036    LIKE    tlf_file.tlf036, #單據編號
      #        tlf01     LIKE    tlf_file.tlf01,  #料號
      #        tlf10     LIKE    tlf_file.tlf10,  #入庫數
      #        ccc23a    LIKE    ccc_file.ccc23a, #本月平均材料單位成本
      #        ccc23b    LIKE    ccc_file.ccc23b, #本月平均人工單位成本
      #        ccc23c    LIKE    ccc_file.ccc23c, #本月平均製費單位成本
      #        ccc23d    LIKE    ccc_file.ccc23d, #本月平均加工單位成本
      #        ccc23e    LIKE    ccc_file.ccc23e, #本月平均其他單位成本
      #        ccc23f    LIKE    ccc_file.ccc23f, #本月平均單價-制費三                                                              
      #        ccc23g    LIKE    ccc_file.ccc23g, #本月平均單價-制費四                                                              
      #        ccc23h    LIKE    ccc_file.ccc23h, #本月平均單價-制費五  
      #        ima02     LIKE    ima_file.ima02,  #說明
      #        tlfccost  LIKE    tlfc_file.tlfccost, #類別編號
      #        ima021    LIKE    ima_file.ima021,    #規格   
      #        ima12     LIKE    ima_file.ima12,     #原料/成品
      #        l_ccc23a  LIKE    ccc_file.ccc23a,
      #        l_ccc23b  LIKE    ccc_file.ccc23b,
      #        l_ccc23c  LIKE    ccc_file.ccc23c,
      #        l_ccc23d  LIKE    ccc_file.ccc23d,
      #        l_ccc23e  LIKE    ccc_file.ccc23e,
      #        l_ccc23f  LIKE    ccc_file.ccc23f,                                                                                       
      #        l_ccc23g  LIKE    ccc_file.ccc23g,                                                                                        
      #        l_ccc23h  LIKE    ccc_file.ccc23h,    
      #        l_tot     LIKE    ccc_file.ccc23a,
      #        ina09     LIKE    ina_file.ina09,
      #        ima57     LIKE    ima_file.ima57,
      #        ima08     LIKE    ima_file.ima08,
      #        tlf032    LIKE    tlf_file.tlf032,
      #        tlf930    LIKE    tlf_file.tlf930         
      #        END RECORD
 #DEFINE l_inb13   LIKE   inb_file.inb13  #NO.MOD-580183
 #DEFINE l_inb14   LIKE    inb_file.inb14  #NO.MOD-620047   
 #DEFINE l_exp_tot    LIKE     cmi_file.cmi08  #No.FUN-810073
 #DEFINE l_azf03      LIKE     azf_file.azf03  #No.FUN-810073
 #DEFINE l_gem02      LIKE gem_file.gem02      #No.FUN-810073
 #DEFINE l_i          LIKE type_file.num5                 #No.FUN-8B0026 SMALLINT
 #DEFINE l_dbs        LIKE azp_file.azp03                 #No.FUN-8B0026
 #DEFINE i            LIKE type_file.num5                 #No.FUN-8B0026
 #DEFINE l_ima12      LIKE ima_file.ima12
 #DEFINE l_ima57      LIKE ima_file.ima57                 #No.FUN-8B0026
 #DEFINE l_ima08      LIKE ima_file.ima08                 #No.FUN-8B0026
 #DEFINE l_inb        RECORD LIKE inb_file.*              #No.FUN-8B0026 
 #DEFINE l_slip       LIKE smy_file.smyslip    #No.MOD-990086
 #DEFINE l_smydmy1    LIKE smy_file.smydmy1    #No.MOD-990086
 #DEFINE l_tlf032     LIKE tlf_file.tlf032                #No.FUN-9A0050
 #DEFINE l_tlf930     LIKE tlf_file.tlf930                #No.FUN-9A0050 
 #DEFINE l_ima39      LIKE ima_file.ima39                 #No.FUN-9A0050
 #DEFINE l_ima391     LIKE ima_file.ima391                #No.FUN-9A0050
 DEFINE l_ccz07      LIKE ccz_file.ccz07                 #No.FUN-9A0050
 #DEFINE l_tlf14      LIKE tlf_file.tlf14                 #No.FUN-9A0050 add by liuxqa 
 #DEFINE l_tlf19      LIKE tlf_file.tlf19                 
 #DEFINE l_cnt1        LIKE type_file.num5     
 #xj---add---str
 #DEFINE l_tlf021      LIKE tlf_file.tlf021   
 #DEFINE l_tlf026      LIKE tlf_file.tlf026    
 #xj---add--end
 DEFINE l_msg1     STRING
 DEFINE l_msg2     STRING


   DELETE FROM axcq775_tmp      #xj add
   IF g_bgjob = 'Y' THEN
      INITIALIZE tm.* TO NULL
      LET tm.wc = '1=1'
      LET tm.z = g_argv4 
      LET tm.type = g_argv3
      #LET tm.b = 'N'  #TQC-CC0118
      CALL s_azn01(g_argv1,g_argv2) RETURNING tm.bdate,tm.edate
      IF cl_null(tm.bdate) OR cl_null(tm.edate) THEN
          CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING  l_bdate,l_edate
      END IF
   END IF
#   CALL q775_table()  #xj mark
   #FUN-C90076--add--str--
   CASE tm.tlf907
      #WHEN '2'    #TQC-CC0118
      WHEN '1'     #TQC-CC0118
         #FUN-D10022--modify--str--
         #LET tm.wc=tm.wc," AND tlf907='1' "  
         #FUN-D10022--modify--end--
        # LET tm.wc=tm.wc," AND  tlf13 IN ('aimt302','aimt312','aimt306') "   
         LET tm.wc=tm.wc," AND  tlf13 IN ('aimt302','aimt312','aimt306','aimt309') "   #Modi by zm 131121 axcp500中aimt309是作为aimt306的负项,所以aimt309虽为出库也要放在杂收中,否则杂收金额会跟axcr004对不上  
      #WHEN '3'    #TQC-CC0118
      WHEN '2'     #TQC-CC0118 
         #FUN-D10022--modify--str--
         #LET tm.wc=tm.wc," AND tlf907='-1' "
        # LET tm.wc=tm.wc," AND  tlf13 IN ('aimt301','aimt311','aimt303','aimt313','aimt309') "
         LET tm.wc=tm.wc," AND  tlf13 IN ('aimt301','aimt311','aimt303','aimt313') "   #Modi by zm 131121
         #FUN-D10022--modify--end--
      OTHERWISE 
         LET tm.wc=tm.wc," AND  tlf13 IN ('aimt302','aimt312','aimt306','aimt301','aimt311','aimt303','aimt313','aimt309') " #FUN-D10022 xj
   END CASE 
   #FUN-C90076--add--end--
   LET l_msg2 = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";","tm.type = '",tm.type,"'",";",
                "tm.z = '",tm.z,"'"  #TQC-CC0118 
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg2) RETURNING g_cka00

   #CALL g_tlf.clear()   #xj add
   #CALL g_tlf_excel.clear()  
   #LET l_ac = 1         #xj add
   #LET g_i = 0
   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 

   LET l_sql =  "SELECT '' order1,tlf037,tlf907,tlf13,nvl(tlf14,' ') tlf14,azf03,nvl(tlf17,' ') tlf17,nvl(tlf19,' ') tlf19,'' gem02,tlf021,tlf031,",       #FUN-D10022 azf03 
                "       tlf06,tlf026,tlf027,",   
                "       tlf036,'' ima39,'' ima391,tlf01,nvl(tlf10*tlf60,0) tlf10,nvl(tlfc221,0) ccc23a,nvl(tlfc222,0) ccc23b,nvl(tlfc2231,0) ccc23c,nvl(tlfc2232,0) ccc23d,", 
                "       nvl(tlfc224,0) ccc23e,nvl(tlfc2241,0) ccc23f,nvl(tlfc2242,0) ccc23g,nvl(tlfc2243,0) ccc23h,ima02,tlfccost,ima021,imaud33,imaud34,ima12, ",
                # darcy:2024/09/09 add imaud33,imaud34
               #"       0 l_ccc23a,0 l_ccc23b,0 l_ccc23c,0 l_ccc23d,0 l_ccc23e,0 l_ccc23f,0 l_ccc23g,0 l_ccc23h,0 l_tot,'' ina09,",   #MOD-D30247 mark
                "       0 l_ccc23a,0 l_ccc23b,0 l_ccc23c,0 l_ccc23d,0 l_ccc23e,0 l_ccc23f,0 l_ccc23g,0 l_ccc23h,0 l_tot,",            #MOD-D30247 
                "       ima57,ima08,tlf032,tlf930 ",
                "  FROM tlf_file ",
                "  LEFT OUTER JOIN azf_file ON substr(tlf14,1,4)=azf01 AND azf02='2' ",   #FUN-D10022 add
                "  LEFT OUTER JOIN tlfc_file ON tlfc01 = tlf01  AND tlfc06 = tlf06 AND ",
                "       tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",
                "       tlfc13 = tlf13  AND ",
                "       tlfc902= tlf902 AND tlfc903= tlf903 AND",
                "       tlfc904= tlf904 AND tlfc907= tlf907 AND",
                "       tlfc905= tlf905 AND tlfc906= tlf906 ",
                "      ,ima_file ",   
                " WHERE tlf01=ima01 ",
                "   AND (tlf13='aimt301' or tlf13='aimt311' ", 
                "    OR  tlf13='aimt302' or tlf13='aimt312'",
                "    OR  tlf13='aimt720'",   
                "    OR  tlf13='aimt303' or tlf13='aimt313'",
                "    OR  tlf13='aimt306' or tlf13='aimt309'",  
                "    OR  tlf13='atmt260' or tlf13='atmt261')",  
                "   AND tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file) ", 
                #FUN-D10022--add--str--
                "   AND (trim(tlfctype) is null OR tlfctype = '",tm.type CLIPPED,"') ", 
                "   AND (tlf907>0 AND 'Y'=(SELECT smydmy1 FROM smy_file WHERE smyslip = substr(tlf036,0,instr(tlf036,'-')-1) ) ",
                "     OR tlf907<=0 AND 'Y'=(SELECT smydmy1 FROM smy_file WHERE smyslip = substr(tlf026,0,instr(tlf026,'-')-1) ) )",             
                #FUN-D10022--add--end--
                "   AND " ,tm.wc CLIPPED ," AND ",g_filter_wc CLIPPED

   LET l_sql = " INSERT INTO axcq775_tmp  ",l_sql CLIPPED 
   PREPARE q775_ins FROM l_sql
   EXECUTE q775_ins

   #IF tm.b = 'Y' THEN   #TQC-CC0118
 #Mark by 131122 inb908很多作业是空的,如果删除资料就少了很多
 #  LET l_sql = " DELETE FROM axcq775_tmp o ",
 #              "  WHERE o.tlf13 <> 'aimt306' AND o.tlf13 <> 'aimt309' ",
 #              "    AND o.tlf13 <> 'aimt720' AND o.tlf13 <> 'atmt260' ",
 #              "    AND o.tlf13 <> 'atmt261' ",
 #              #"    AND (tlf907 = 1 OR ",  #TQC-CC0118 
 #              "    AND  ",                #TQC-CC0118 
 #              "         EXISTS(SELECT * FROM inb_file ",
 #              "                 WHERE inb01=o.tlf026 AND inb03=o.tlf027 AND inb908 IS NULL)  "
 #  PREPARE q775_pre1 FROM l_sql
 #  EXECUTE q775_pre1
   #END IF               #TQC-CC0118
 #End by 131122
 
   LET l_sql = " MERGE INTO axcq775_tmp o ",
              #"      USING (SELECT ina01,ina02,ina09 FROM ina_file ",   #MOD-D30247 mark
               "      USING (SELECT ina01,ina02 FROM ina_file ",         #MOD-D30247
               "              WHERE ina00 IN ('3','4') ) x ",
               "         ON (o.tlf036 = x.ina01 AND o.tlf06 = x.ina02 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.order1 = o.tlf036  ",         #MOD-D30247 remove ,
              #"           o.ina09  = x.ina09   ",         #MOD-D30247 mark
               "     WHERE o.tlf13 <> 'aimt306' AND o.tlf13 <> 'aimt309' ",
               "       AND o.tlf13 <> 'aimt720' AND o.tlf13 <> 'atmt260' ",
               "       AND o.tlf13 <> 'atmt261' AND o.tlf907 > 0 "
   PREPARE q775_pre2 FROM l_sql
   EXECUTE q775_pre2

   LET l_sql = " MERGE INTO axcq775_tmp o ",
              #"      USING (SELECT ina01,ina02,ina09 FROM ina_file ",    #MOD-D30247 mark
               "      USING (SELECT ina01,ina02 FROM ina_file ",          #MOD-D30247
               "              WHERE ina00 IN ('3','4') ) x ",
               "         ON (o.tlf026 = x.ina01 AND o.tlf06 = x.ina02 ) ", 
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.order1 = o.tlf026  ",         #MOD-D30247 remove ,
              #"           o.ina09  = x.ina09   ",         #MOD-D30247 mark
               "     WHERE o.tlf13 <> 'aimt306' AND o.tlf13 <> 'aimt309' ",
               "       AND o.tlf13 <> 'aimt720' AND o.tlf13 <> 'atmt260' ",
               "       AND o.tlf13 <> 'atmt261' AND o.tlf907 <= 0 "
   PREPARE q775_pre3 FROM l_sql
   EXECUTE q775_pre3   

   LET l_sql = " UPDATE axcq775_tmp SET tlf10 = tlf10 * tlf907 "  #FUN-D10022
   PREPARE q775_pre4 FROM l_sql
   EXECUTE q775_pre4 

   LET l_sql = " UPDATE axcq775_tmp o",
               "    SET o.l_ccc23a = o.ccc23a*o.tlf907 "
   PREPARE q775_pre5 FROM l_sql
   EXECUTE q775_pre5   
   
   LET l_sql = " UPDATE axcq775_tmp o",
               "    SET o.l_ccc23a = (SELECT nvl(inb13*inb09,0) FROM inb_file ",
               "                       WHERE inb01 = o.tlf036 AND inb03 =o.tlf037 )",
               "     WHERE (o.tlf13 ='aimt302' OR o.tlf13='aimt312') ",
               "       AND o.ccc23a = 0 "
   PREPARE q775_pre6 FROM l_sql
   EXECUTE q775_pre6   
 
   LET l_sql = " UPDATE axcq775_tmp o",
               "    SET o.l_ccc23b = o.ccc23b*o.tlf907, ",
               "        o.l_ccc23c = o.ccc23c*o.tlf907, ",
               "        o.l_ccc23d = o.ccc23d*o.tlf907, ",
               "        o.l_ccc23e = o.ccc23e*o.tlf907, ",
               "        o.l_ccc23f = o.ccc23f*o.tlf907, ",
               "        o.l_ccc23g = o.ccc23g*o.tlf907, ",
               "        o.l_ccc23h = o.ccc23h*o.tlf907  "
   PREPARE q775_pre7 FROM l_sql
   EXECUTE q775_pre7    
   
   LET l_sql = " UPDATE axcq775_tmp ",
               "    SET l_tot=nvl(l_ccc23a,0)+nvl(l_ccc23b,0)+nvl(l_ccc23c,0)+nvl(l_ccc23d,0)+nvl(l_ccc23e,0)+nvl(l_ccc23f,0)+nvl(l_ccc23g,0)+nvl(l_ccc23h,0) "
   PREPARE q775_pre8 FROM l_sql
   EXECUTE q775_pre8 

   LET l_sql = " UPDATE axcq775_tmp o ",
               "    SET o.gem02=(SELECT nvl(gem02,'') FROM gem_file WHERE gem01 = o.tlf19) "
   PREPARE q775_pre9 FROM l_sql
   EXECUTE q775_pre9 

   SELECT ccz07 INTO l_ccz07 FROM ccz_file WHERE ccz00='0'
   CASE WHEN l_ccz07='1'                                                                                                    
           LET l_sql=
               " MERGE INTO axcq775_tmp o ",
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
      PREPARE q775_pre10 FROM l_sql
      EXECUTE q775_pre10 
   END IF 

   LET l_sql = " UPDATE axcq775_tmp ",
               "    SET tlf14 = substr(tlf14,1,4) ,",
               "        tlf19 = substr(tlf19,1,6) "
   PREPARE q775_pre11 FROM l_sql
   EXECUTE q775_pre11 

   LET l_sql = " UPDATE axcq775_tmp ",
               "    SET tlf021 = tlf031 ,",
               "        tlf026 = tlf036  ",
               "  WHERE tlf907 <> -1 "
   PREPARE q775_pre12 FROM l_sql
   EXECUTE q775_pre12 

   
    #FUN-D10022--mark--str--  #優化            
    #PREPARE axcq775_prepare1 FROM l_sql
    #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
    #   CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092 
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
    #   EXIT PROGRAM 
    #END IF
    #DECLARE axcq775_curs1 CURSOR FOR axcq775_prepare1
    #LET g_success = 'Y'                              
    #CALL s_showmsg_init()   
    #LET l_ac = 1
    #FOREACH axcq775_curs1 INTO sr.*,sr.ima57,sr.ima08,sr.tlf032,sr.tlf930
    #   IF STATUS THEN
    #      LET g_success = 'N'              
    #      CALL cl_err('foreach:',STATUS,1)
    #      EXIT FOREACH 
    #   END IF
    #   IF g_success='N' THEN                                                                                                        
    #      LET g_totsuccess='N'                                                                                                      
    #      LET g_success='Y'                                                                                                         
    #   END IF            
    #   #寫入sql  tirm(tlfctype) is null OR tlfctype = tm.type       
    #   IF NOT cl_null(l_tlfctype) AND l_tlfctype <> tm.type THEN 
    #      CONTINUE FOREACH
    #   END IF
    #   IF sr.tlf907>0 THEN
    #      LET l_slip = s_get_doc_no(sr.tlf036)
    #   ELSE
    #      LET l_slip = s_get_doc_no(sr.tlf026)
    #   END IF
    #   LET l_smydmy1 = ''   # add test 處理與r程式差異問題
    #   SELECT smydmy1 INTO l_smydmy1 FROM smy_file
    #    WHERE smyslip = l_slip
    #   IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
    #      CONTINUE FOREACH
    #   END IF
    #   #寫入q775_pre1
    #   IF tm.b = 'Y' THEN 
    #      IF sr.tlf13 != 'aimt306' AND sr.tlf13 != 'aimt309'              
    #         AND sr.tlf13 != 'aimt720'   
    #         AND sr.tlf13 != 'atmt260' AND sr.tlf13 != 'atmt261' THEN     
    #         LET l_sql = "SELECT * ",                                                                              
    #                     "  FROM inb_file ",  
    #                     " WHERE inb01 = '",sr.tlf026,"'",
    #                     "   AND inb03 = '",sr.tlf027,"'",
    #                     "   AND inb908 IS NULL"                        
    #         PREPARE inb_prepare3 FROM l_sql                                                                                          
    #         DECLARE inb_c3  CURSOR FOR inb_prepare3                                                                                 
    #         OPEN inb_c3                                                                                    
    #         FETCH inb_c3 INTO l_inb.*
    #         IF NOT STATUS OR sr.tlf907 = 1 THEN
    #            CONTINUE FOREACH
    #         END IF
    #      END IF          
    #   END IF
    #   #寫入sql (nvl,0)
    #   IF sr.ccc23a IS NULL THEN LET sr.ccc23a=0 END IF
    #   IF sr.ccc23b IS NULL THEN LET sr.ccc23b=0 END IF
    #   IF sr.ccc23c IS NULL THEN LET sr.ccc23c=0 END IF
    #   IF sr.ccc23d IS NULL THEN LET sr.ccc23d=0 END IF
    #   IF sr.ccc23e IS NULL THEN LET sr.ccc23e=0 END IF
    #   IF sr.ccc23f IS NULL THEN LET sr.ccc23f=0 END IF                                                                          
    #   IF sr.ccc23g IS NULL THEN LET sr.ccc23g=0 END IF                                                                             
    #   IF sr.ccc23h IS NULL THEN LET sr.ccc23h=0 END IF          
    #   IF sr.tlf14 IS NULL THEN LET sr.tlf14=' ' END IF
    #   IF sr.tlf17 IS NULL THEN LET sr.tlf17=' ' END IF
    #   IF sr.tlf19 IS NULL THEN LET sr.tlf19=' ' END IF
    #   #寫入q775_pre2 
    #   IF sr.tlf13 != 'aimt306' AND sr.tlf13 != 'aimt309'       
    #      AND sr.tlf13 != 'aimt720'   
    #      AND sr.tlf13 != 'atmt260' AND sr.tlf13 != 'atmt261' THEN     
    #      IF sr.tlf907>0 THEN
    #         LET sr.order1=sr.tlf036
    #         LET l_sql = "SELECT ina09 ",                                                                              
    #                     "  FROM ina_file ",  #FUN-A10098
    #                     " WHERE ina01='",sr.tlf036,"' AND ina00 IN ('3','4')",  #MOD-930067
    #                     "   AND ina02='",sr.tlf06,"'"                   
    #         PREPARE ina_prepare3 FROM l_sql                                                                                          
    #         DECLARE ina_c3  CURSOR FOR ina_prepare3                                                                                 
    #         OPEN ina_c3                                                                                    
    #         FETCH ina_c3 INTO sr.ina09
    #   #寫入q775_pre1
    #      ELSE
    #         LET sr.order1=sr.tlf026
    #         LET l_sql = "SELECT ina09 ",                                                                              
    #                     "  FROM ina_file ",  #FUN-A70084
    #                     " WHERE ina01='",sr.tlf026,"' AND ina00 NOT IN ('3','4')",   #MOD-930067   #No.MOD-940146 add not
    #                     "   AND ina02='",sr.tlf06,"'"      
    #         PREPARE ina_prepare2 FROM l_sql                                                                                          
    #         DECLARE ina_c2  CURSOR FOR ina_prepare2                                                                                 
    #         OPEN ina_c2                                                                                    
    #         FETCH ina_c2 INTO sr.ina09
    #      END IF
    #      IF STATUS THEN
    #         CALL s_errmsg('','',sr.order1,STATUS,1)     #No.FUN-810080  
    #      END IF
    #   END IF     
    #   #寫入q775_pre4
    #   LET sr.tlf10 = sr.tlf10 * sr.tlf907
    #   #寫入q775_pre5
    #   IF sr.tlf13='aimt302' OR sr.tlf13='aimt312' THEN #雜入
    #      IF sr.ccc23a = 0 THEN         
    #         LET l_inb14 = 0  
    #         LET l_sql = "SELECT inb13*inb09 ",                                                                           
    #                     "  FROM inb_file ",  
    #                     " WHERE inb01 = '",sr.tlf036,"'",
    #                     "   AND inb03 = '",sr.tlf037,"'"                
    #         PREPARE inb_prepare2 FROM l_sql                                                                                          
    #         DECLARE inb_c2  CURSOR FOR inb_prepare2                                                                                 
    #         OPEN inb_c2                                                                                    
    #         FETCH inb_c2 INTO l_inb14
    #        
    #         IF cl_null(l_inb14) THEN LET l_inb14 = 0 END IF
    #         LET sr.l_ccc23a=l_inb14
    #      ELSE                                       
    #         LET sr.l_ccc23a = sr.ccc23a*sr.tlf907   
    #      END IF   
    #   #寫入q775_pre6          
    #   ELSE
    #       LET sr.l_ccc23a = sr.ccc23a*sr.tlf907
    #   END IF
    #   #寫入q775_pre7
    #   LET sr.l_ccc23b = sr.ccc23b*sr.tlf907
    #   LET sr.l_ccc23c = sr.ccc23c*sr.tlf907
    #   LET sr.l_ccc23d = sr.ccc23d*sr.tlf907
    #   LET sr.l_ccc23e = sr.ccc23e*sr.tlf907
    #   LET sr.l_ccc23f = sr.ccc23f*sr.tlf907  
    #   LET sr.l_ccc23g = sr.ccc23g*sr.tlf907  
    #   LET sr.l_ccc23h = sr.ccc23h*sr.tlf907  
    #   #寫入q775_pre8
    #   LET sr.l_tot=sr.l_ccc23a+sr.l_ccc23b+sr.l_ccc23c+sr.l_ccc23d+sr.l_ccc23e
    #               +sr.l_ccc23f+sr.l_ccc23g+sr.l_ccc23h        
    #   #此段代碼無實際效用,故暫時為獨立出語句做UPDATE操作
    #   IF NOT cl_null(sr.ima12) THEN
    #      LET l_sql = "SELECT azf03 ",                                                                              
    #                  "  FROM azf_file ",  
    #                  " WHERE azf01='",sr.ima12,"' AND azf02='G'"                  
    #      PREPARE azf_prepare2 FROM l_sql                                                                                          
    #      DECLARE azf_c2  CURSOR FOR azf_prepare2                                                                                 
    #      OPEN azf_c2                                                                                    
    #      FETCH azf_c2 INTO l_azf03
    #        
    #      IF SQLCA.sqlcode THEN
    #         LET l_azf03 = ' '
    #      END IF  
    #   END IF
    #   #q775_pre9
    #   LET l_sql = "SELECT gem02 ",                                                                              
    #               "  FROM gem_file ", 
    #               " WHERE gem01='",sr.tlf19,"'"                           
    #   PREPARE gem_prepare2 FROM l_sql                                                                                          
    #   DECLARE gem_c2  CURSOR FOR gem_prepare2                                                                                 
    #   OPEN gem_c2                                                                                    
    #   FETCH gem_c2 INTO l_gem02
    #   IF SQLCA.sqlcode THEN 
    #      LET l_gem02 = NULL
    #   END IF
    #   #q775_pre10
    #   LET l_sql = "SELECT ccz07 ",                                                                                                                                                 
    #               " FROM ccz_file ",       
    #               " WHERE ccz00 = '0' "                                                                                        
    #   PREPARE ccz_p1 FROM l_sql                                                                                                
    #   IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF                                                       
    #   DECLARE ccz_c1 CURSOR FOR ccz_p1                                                                                         
    #   OPEN ccz_c1                                                                                                              
    #   FETCH ccz_c1 INTO l_ccz07                                                                                                
    #   CLOSE ccz_c1
    #   CASE WHEN l_ccz07='1'                                                                                                    
    #           LET l_sql="SELECT ima39,ima391 FROM ima_file ",      #FUN-A70084
    #                     " WHERE ima01='",sr.tlf01,"'"                                                                     
    #        WHEN l_ccz07='2'                                                                                                    
    #           LET l_sql="SELECT imz39,imz391 ",                    
    #                     " FROM ima_file,imz_file ",     
    #                     " WHERE ima01='",sr.tlf01,"' AND ima06=imz01 "                                                          
    #        WHEN l_ccz07='3'                                                                
    #           LET l_sql="SELECT imd08,imd081 FROM imd_file ",    #FUN-A70084
    #                     " WHERE imd01='",sr.tlf031,"'"                                                                           
    #        WHEN l_ccz07='4'                                                                                                    
    #           LET l_sql="SELECT ime09,ime091 FROM ime_file ",   #FUN-A70084
    #                     " WHERE ime01='",sr.tlf031,"' ",                                                                         
    #                     " AND ime02='",sr.tlf032,"'"                                                                           
    #   END CASE
    #   PREPARE stock_p1 FROM l_sql                                                                                               
    #   IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF                                                      
    #   DECLARE stock_c1 CURSOR FOR stock_p1                                                                                      
    #   OPEN stock_c1                                                                                                             
    #   FETCH stock_c1 INTO l_ima39,l_ima391                                                                                           
    #   CLOSE stock_c1 
    #   #q775_pre11
    #   LET l_tlf14 = ''
    #   LET l_tlf19 = ''
    #   LET l_tlf14 = sr.tlf14[1,4] 
    #   LET l_tlf19 = sr.tlf19[1,6] 
    #   #q775_pre12  
    #   IF sr.tlf907 = -1 THEN
    #      LET l_tlf021 = sr.tlf021
    #   ELSE
    #      LET l_tlf021 = sr.tlf031
    #   END IF
    #   IF sr.tlf907 = -1 THEN
    #      LET l_tlf026 = sr.tlf026
    #   ELSE
    #      LET l_tlf026 = sr.tlf036
    #   END IF   
    #   INSERT INTO axcq775_tmp 
    #   VALUES(sr.ima12,sr.ima57,sr.ima08,sr.tlf01,sr.ima02,sr.ima021,l_tlf14,sr.tlf17,l_tlf19,l_gem02,
    #          l_tlf021,sr.tlf06,l_tlf026,l_ima39,l_ima391,sr.tlf930,sr.tlfccost,
    #          sr.tlf10,sr.l_ccc23a,sr.l_ccc23b,sr.l_ccc23c,sr.l_ccc23d,
    #          sr.l_ccc23e,sr.l_ccc23f,sr.l_ccc23g,sr.l_ccc23h,sr.l_tot,sr.tlf907,sr.tlf13)
    #END FOREACH
    #FUN-D10022--mark--end--
    
   SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0),
          nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0),
          nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0)
          INTO sr1.qty_sum1,sr1.tot_sum1,sr1.cl_sum1,sr1.rg_sum1,sr1.jg_sum1,
               sr1.zf01_sum1,sr1.zf02_sum1,sr1.zf03_sum1,sr1.zf04_sum1,sr1.zf05_sum1
     FROM axcq775_tmp 
    WHERE (tlf907=1 AND (tlf13 <> 'atmt261' AND tlf13 <> 'aimt309') )
           OR (tlf907 = -1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309'))

   SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0),
          nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0),
          nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0)
          INTO sr2.qty_sum2,sr2.tot_sum2,sr2.cl_sum2,sr2.rg_sum2,sr2.jg_sum2,
               sr2.zf01_sum2,sr2.zf02_sum2,sr2.zf03_sum2,sr2.zf04_sum2,sr2.zf05_sum2
     FROM axcq775_tmp 
    WHERE (tlf907=-1 AND (tlf13 <> 'aimt309' AND tlf13 <> 'atmt261') )
           OR (tlf907 = 1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309'))

   IF tm.z = 'Y' AND NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) AND g_filter_wc=" 1=1" THEN  #TQC-D50098
      LET l_msg1 = tm.bdate,"|",tm.edate,"|",tm.type,"|",tm.z  #TQC-CC0118 
      #雜收
      CALL s_ckk_fill('','301','axc-451',g_ccz.ccz01,g_ccz.ccz02,g_prog,tm.type,sr1.qty_sum1,sr1.tot_sum1,sr1.cl_sum1,sr1.rg_sum1,sr1.jg_sum1,
                      sr1.zf01_sum1,sr1.zf02_sum1,sr1.zf03_sum1,sr1.zf04_sum1,sr1.zf05_sum1,l_msg1,g_user,g_today,g_time,'Y')
           RETURNING g_ckk.*
      IF NOT s_ckk(g_ckk.*,'') THEN END IF 
      #雜出
      CALL s_ckk_fill('','302','axc-452',g_ccz.ccz01,g_ccz.ccz02,g_prog,tm.type,sr2.qty_sum2,sr2.tot_sum2,sr2.cl_sum2,sr2.rg_sum2,sr2.jg_sum2,
                      sr2.zf01_sum2,sr2.zf02_sum2,sr2.zf03_sum2,sr2.zf04_sum2,sr2.zf05_sum2,l_msg1,g_user,g_today,g_time,'Y')
           RETURNING g_ckk.*
      IF NOT s_ckk(g_ckk.*,'') THEN END IF
   END IF 

#插入ckk_file
   #類型編碼301/302
   CALL s_log_upd(g_cka00,'Y')           #更新日誌  #FUN-C80092
END FUNCTION    

#FUN-D10022 add
FUNCTION q775_b_fill()
    define l_str STRING
    let l_str = "SELECT unique rvv31,rvv32,pmk12,pmk13,pmk04 FROM (",
                " SELECT rvv31,rvv32,pmk12,pmk13,rvu03,pmk04, ",
                " dense_rank() OVER(PARTITION BY rvv31,rvv32 ORDER BY rvu03 DESC,pmk04 DESC,pmk12 ) r", #darcy:2023/08/08 add pmk12,防止同一天请购重复
                " FROM rvv_file ,rvu_file ,",
                " pmn_file,pml_file,pmk_file",
                " WHERE rvv01 =rvu01 ",
                " AND rvuconf='Y'",
                " AND pmn01 = rvv36 AND pmn02 = rvv37",
                " AND pmn24 =pml01 AND pmn25=pml02",
                " AND pml01 =pmk01 )",
                " WHERE r = 1"
   
   LET g_sql = "SELECT ima12,ima57,ima08,tlf01,ima02,ima021,imaud33,imaud34,tlf19,axcq775_tmp.gem02,tlf14,azf03,tlf17, ",
               #darcy:2024/09/09 add imaud33,imaud34
               "       tlf021,tlf06,tlf026,ima39,ima391,tlf930,tlfccost,tlf10,l_ccc23a, ",
               "       l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e,l_ccc23f,l_ccc23g,l_ccc23h,l_tot ",
               "       ,pmk12,gen02,pmk13,gem_file.gem02,pmk04 ", #darcy:2023/07/04 add
               "      ,inbud02 ",  #darcy:2023/07/12 add s---
               "  FROM axcq775_tmp " #, 
               #darcy:2023/07/04 add s---
               ," left join (",l_str,") on rvv31 = tlf01 and rvv32 = tlf021 ",
               "  left join gen_file on gen01 = pmk12 ",
               "  left join gem_file on gem01 = pmk13 "
               #darcy:2023/07/04 add e---
               #darcy:2023/07/12 add s---
               ,"left join (select inb01,inb04,listagg(inbud02,',')within group(order by inb01,inb04) inbud02",
                "      from inb_file GROUP BY inb01,inb04) on inb01 = tlf026 and inb04 = tlf01 "
                     
               #darcy:2023/07/12 add e---
              # " ORDER BY oga00,oga08,oga01,ogb03,oga02,oga03,oga032,",
              #         "  oga04,occ02,oga14,gen02,oga15,gem02,ogb14t desc,ogb14t_o desc "   


   PREPARE axcq775_pb FROM g_sql
   DECLARE tlf_curs  CURSOR FOR axcq775_pb        #CURSOR

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

   SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0),
          nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0),
          nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0)
          INTO sr1.qty_sum1,sr1.tot_sum1,sr1.cl_sum1,sr1.rg_sum1,sr1.jg_sum1,
               sr1.zf01_sum1,sr1.zf02_sum1,sr1.zf03_sum1,sr1.zf04_sum1,sr1.zf05_sum1
     FROM axcq775_tmp 
    WHERE (tlf907=1 AND (tlf13 <> 'atmt261' AND tlf13 <> 'aimt309') )
           OR (tlf907 = -1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309'))

   SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0),
          nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0),
          nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0)
          INTO sr2.qty_sum2,sr2.tot_sum2,sr2.cl_sum2,sr2.rg_sum2,sr2.jg_sum2,
               sr2.zf01_sum2,sr2.zf02_sum2,sr2.zf03_sum2,sr2.zf04_sum2,sr2.zf05_sum2
     FROM axcq775_tmp 
    WHERE (tlf907=-1 AND (tlf13 <> 'aimt309' AND tlf13 <> 'atmt261') )
           OR (tlf907 = 1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309'))
   
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

FUNCTION q775_b_fill_2()

   CALL g_tlf_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0),
          nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0),
          nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0)
          INTO sr1.qty_sum1,sr1.tot_sum1,sr1.cl_sum1,sr1.rg_sum1,sr1.jg_sum1,
               sr1.zf01_sum1,sr1.zf02_sum1,sr1.zf03_sum1,sr1.zf04_sum1,sr1.zf05_sum1
     FROM axcq775_tmp 
    WHERE (tlf907=1 AND (tlf13 <> 'atmt261' AND tlf13 <> 'aimt309') )
           OR (tlf907 = -1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309'))

   SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0),
          nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0),
          nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0)
          INTO sr2.qty_sum2,sr2.tot_sum2,sr2.cl_sum2,sr2.rg_sum2,sr2.jg_sum2,
               sr2.zf01_sum2,sr2.zf02_sum2,sr2.zf03_sum2,sr2.zf04_sum2,sr2.zf05_sum2
     FROM axcq775_tmp 
    WHERE (tlf907=-1 AND (tlf13 <> 'aimt309' AND tlf13 <> 'atmt261') )
           OR (tlf907 = 1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309'))
   CALL q775_get_sum()
     
END FUNCTION

FUNCTION q775_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,  
          l_sql        STRING, 
          l_sql1       STRING,
          l_sql2       STRING,
          l_tmp        STRING   

   LET l_sql = "SELECT ima12,ima57,ima08,tlf01,ima02,ima021,tlf19,gem02,tlf14,azf03,tlf17, ",
               "       tlf021,tlf06,tlf026,ima39,ima391,tlf930,tlfccost,tlf10,l_ccc23a, ",
               "       l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e,l_ccc23f,l_ccc23g,l_ccc23h,l_tot ",
               "  FROM  axcq775_tmp "
               
   LET l_sql1= "SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0), ",
               "       nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0), ",
               "       nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0) ",
               "  FROM axcq775_tmp  ",
               " WHERE ((tlf907=1 AND (tlf13 <> 'atmt261' AND tlf13 <> 'aimt309') ) ",
               "    OR (tlf907 = -1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309'))) "

   LET l_sql2= "SELECT nvl(SUM(tlf10),0),nvl(SUM(l_tot),0),nvl(SUM(l_ccc23a),0),nvl(SUM(l_ccc23b),0), ",
               "       nvl(SUM(l_ccc23d),0),nvl(SUM(l_ccc23c),0),nvl(SUM(l_ccc23e),0),nvl(SUM(l_ccc23f),0), ",
               "       nvl(SUM(l_ccc23g),0),nvl(SUM(l_ccc23h),0)  ",
               "  FROM axcq775_tmp ", 
               " WHERE ((tlf907=-1 AND (tlf13 <> 'aimt309' AND tlf13 <> 'atmt261')) ",
               "    OR (tlf907 = 1 AND (tlf13 = 'atmt261' OR tlf13  = 'aimt309')))  "

   CASE tm.a 
      WHEN "1" 
         IF cl_null(g_tlf_1[p_ac].ima12) THEN 
            LET g_tlf_1[p_ac].ima12 = ''
            LET l_tmp = " OR ima12 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima12,ima57,ima08,tlf01,tlf19,tlf14 "
         LET l_sql1= l_sql1," AND  (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )"
         LET l_sql2= l_sql2," AND  (ima12 = '",g_tlf_1[p_ac].ima12 CLIPPED,"'",l_tmp," )"

      WHEN "2"
         IF cl_null(g_tlf_1[p_ac].ima57) THEN 
            LET g_tlf_1[p_ac].ima57 = ''
            LET l_tmp = " OR ima57 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima57 = '",g_tlf_1[p_ac].ima57 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima57,ima12,ima08,tlf01,tlf19,tlf14 "
         LET l_sql1= l_sql1," AND  (ima57 = '",g_tlf_1[p_ac].ima57 CLIPPED,"'",l_tmp," )"
         LET l_sql2= l_sql2," AND  (ima57 = '",g_tlf_1[p_ac].ima57 CLIPPED,"'",l_tmp," )"
         
      WHEN "3"
         IF cl_null(g_tlf_1[p_ac].ima08) THEN 
            LET g_tlf_1[p_ac].ima08 = ''
            LET l_tmp = " OR ima08 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (ima08 = '",g_tlf_1[p_ac].ima08 CLIPPED,"'",l_tmp," )",
                           " ORDER BY ima08,ima12,ima57,tlf01,tlf19,tlf14 "
         LET l_sql1= l_sql1," AND  (ima08 = '",g_tlf_1[p_ac].ima08 CLIPPED,"'",l_tmp," )"
         LET l_sql2= l_sql2," AND  (ima08 = '",g_tlf_1[p_ac].ima08 CLIPPED,"'",l_tmp," )"
         
      WHEN "4"
         IF cl_null(g_tlf_1[p_ac].tlf01) THEN 
            LET g_tlf_1[p_ac].tlf01 = ''
            LET l_tmp = " OR tlf01 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )",
                           " ORDER BY tlf01,ima12,ima57,ima08,tlf19,tlf14 "
         LET l_sql1= l_sql1," AND  (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )"
         LET l_sql2= l_sql2," AND  (tlf01 = '",g_tlf_1[p_ac].tlf01 CLIPPED,"'",l_tmp," )"
         
      WHEN "6"
         IF cl_null(g_tlf_1[p_ac].tlf14) THEN 
            LET g_tlf_1[p_ac].tlf14 = ''
            LET l_tmp = " OR tlf14 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (tlf14 = '",g_tlf_1[p_ac].tlf14 CLIPPED,"'",l_tmp," )",
                           " ORDER BY tlf14,ima12,ima57,ima08,tlf01,tlf19 "
         LET l_sql1= l_sql1," AND  (tlf14 = '",g_tlf_1[p_ac].tlf14 CLIPPED,"'",l_tmp," )"
         LET l_sql2= l_sql2," AND  (tlf14 = '",g_tlf_1[p_ac].tlf14 CLIPPED,"'",l_tmp," )"
         
      WHEN "5"
         IF cl_null(g_tlf_1[p_ac].tlf19) THEN 
            LET g_tlf_1[p_ac].tlf19 = ''
            LET l_tmp = " OR tlf19 IS NULL "
         ELSE 
            LET l_tmp = ''
         END IF 
         LET l_sql = l_sql," WHERE (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"'",l_tmp," )",
                           " ORDER BY tlf19,ima12,ima57,ima08,tlf01,tlf14 "
         LET l_sql1= l_sql1," AND  (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"'",l_tmp," )"
         LET l_sql2= l_sql2," AND  (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"'",l_tmp," )"
         
      #FUN-D10022--add--str--
      WHEN "7"
         LET l_sql = l_sql," WHERE (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"' )",
                           "   AND  tlf14 = '",g_tlf_1[p_ac].tlf14 CLIPPED,"'   ",
                           " ORDER BY tlf19,tlf14,ima12,ima57,ima08,tlf01 "
         LET l_sql1= l_sql1," AND  (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"' )"
         LET l_sql2= l_sql2," AND  (tlf19 = '",g_tlf_1[p_ac].tlf19 CLIPPED,"' )"
      #FUN-D10022--add--end--
   END CASE

   PREPARE axcq775_pb_detail FROM l_sql
   DECLARE tlf_curs_detail  CURSOR FOR axcq775_pb_detail        #CURSOR
   
   PREPARE axcq775_pb_det_sr1 FROM l_sql1                                                                                               
   DECLARE axcq775_cs_sr1 CURSOR FOR axcq775_pb_det_sr1                                                                                      
   OPEN axcq775_cs_sr1                                                                                                             
   FETCH axcq775_cs_sr1 INTO sr1.qty_sum1,sr1.tot_sum1,sr1.cl_sum1,sr1.rg_sum1,sr1.jg_sum1,
                             sr1.zf01_sum1,sr1.zf02_sum1,sr1.zf03_sum1,sr1.zf04_sum1,sr1.zf05_sum1

   PREPARE axcq775_pb_det_sr2 FROM l_sql2                                                                                               
   DECLARE axcq775_cs_sr2 CURSOR FOR axcq775_pb_det_sr2                                                                                      
   OPEN axcq775_cs_sr2                                                                                                             
   FETCH axcq775_cs_sr2 INTO sr2.qty_sum2,sr2.tot_sum2,sr2.cl_sum2,sr2.rg_sum2,sr2.jg_sum2,
                             sr2.zf01_sum2,sr2.zf02_sum2,sr2.zf03_sum2,sr2.zf04_sum2,sr2.zf05_sum2

   CALL g_tlf.clear()
   CALL g_tlf_excel.clear()   #No.MOD-D60056
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

FUNCTION q775_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING

   CASE tm.a
      WHEN '1'
         LET l_sql = "SELECT ima12,'','','','','','','','','',",
                     "       SUM(tlf10),SUM(l_ccc23a),SUM(l_ccc23b),SUM(l_ccc23c),SUM(l_ccc23d), ",
                     "       SUM(l_ccc23e),SUM(l_ccc23f),SUM(l_ccc23g),SUM(l_ccc23h),SUM(l_tot) ",
                     "  FROM axcq775_tmp",
                     " GROUP BY ima12 ",
                     " ORDER BY ima12 "
      WHEN '2'
         LET l_sql = "SELECT '',ima57,'','','','','','','','',",
                     "       SUM(tlf10),SUM(l_ccc23a),SUM(l_ccc23b),SUM(l_ccc23c),SUM(l_ccc23d), ",
                     "       SUM(l_ccc23e),SUM(l_ccc23f),SUM(l_ccc23g),SUM(l_ccc23h),SUM(l_tot) ",
                     "  FROM axcq775_tmp",
                     " GROUP BY ima57 ",
                     " ORDER BY ima57 "
      WHEN '3'
         LET l_sql = "SELECT '','',ima08,'','','','','','','',",
                     "       SUM(tlf10),SUM(l_ccc23a),SUM(l_ccc23b),SUM(l_ccc23c),SUM(l_ccc23d), ",
                     "       SUM(l_ccc23e),SUM(l_ccc23f),SUM(l_ccc23g),SUM(l_ccc23h),SUM(l_tot) ",
                     "  FROM axcq775_tmp",
                     " GROUP BY ima08 ",
                     " ORDER BY ima08 "
      WHEN '4'
         LET l_sql = "SELECT '','','',tlf01,ima02,ima021,'','','','',",
                     "       SUM(tlf10),SUM(l_ccc23a),SUM(l_ccc23b),SUM(l_ccc23c),SUM(l_ccc23d), ",
                     "       SUM(l_ccc23e),SUM(l_ccc23f),SUM(l_ccc23g),SUM(l_ccc23h),SUM(l_tot) ",
                     "  FROM axcq775_tmp",
                     " GROUP BY tlf01,ima02,ima021 ",
                     " ORDER BY tlf01,ima02,ima021 "
      WHEN '6'
         LET l_sql = "SELECT '','','','','','','','',tlf14,azf03,",
                     "       SUM(tlf10),SUM(l_ccc23a),SUM(l_ccc23b),SUM(l_ccc23c),SUM(l_ccc23d), ",
                     "       SUM(l_ccc23e),SUM(l_ccc23f),SUM(l_ccc23g),SUM(l_ccc23h),SUM(l_tot) ",
                     "  FROM axcq775_tmp",
                     " GROUP BY tlf14,azf03 ",
                     " ORDER BY tlf14,azf03 "
      WHEN '5'
         LET l_sql = "SELECT '','','','','','',tlf19,gem02,'','',",
                     "       SUM(tlf10),SUM(l_ccc23a),SUM(l_ccc23b),SUM(l_ccc23c),SUM(l_ccc23d), ",
                     "       SUM(l_ccc23e),SUM(l_ccc23f),SUM(l_ccc23g),SUM(l_ccc23h),SUM(l_tot) ",
                     "  FROM axcq775_tmp",
                     " GROUP BY tlf19,gem02 ",
                     " ORDER BY tlf19,gem02 "
      #FUN-D10022--add--str--
      WHEN '7'
         LET l_sql = "SELECT '','','','','','',tlf19,gem02,tlf14,azf03,",
                     "       SUM(tlf10),SUM(l_ccc23a),SUM(l_ccc23b),SUM(l_ccc23c),SUM(l_ccc23d), ",
                     "       SUM(l_ccc23e),SUM(l_ccc23f),SUM(l_ccc23g),SUM(l_ccc23h),SUM(l_tot) ",
                     "  FROM axcq775_tmp",
                     " GROUP BY tlf19,gem02,tlf14,azf03 ",
                     " ORDER BY tlf19,gem02,tlf14,azf03 "
      #FUN-D10022--add--end--
   END CASE 
              
   PREPARE q775_pb FROM l_sql
   DECLARE q775_curs1 CURSOR FOR q775_pb
   FOREACH q775_curs1 INTO g_tlf_1[g_cnt].*
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

FUNCTION q775_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q775_b_fill()
   END IF
   LET g_action_choice = " "
   LET g_flag = ' '
   IF cl_null(tm.a) THEN LET tm.a = '4' END IF 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY tm.bdate TO bdate
   DISPLAY tm.edate TO edate
   DISPLAY tm.type TO TYPE
   DISPLAY tm.tlf907 TO tlf907
   #DISPLAY tm.b TO b  #TQC-CC0118 
   DISPLAY tm.z TO z
   DISPLAY tm.a TO a 
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY BY NAME sr1.*
   DISPLAY BY NAME sr2.*
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q775_b_fill_2()
               CALL q775_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q775_b_fill()
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

FUNCTION q775_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q775_b_fill_2()
   DISPLAY  tm.a TO a
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   DISPLAY BY NAME sr1.*
   DISPLAY BY NAME sr2.*
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q775_b_fill_2()
               CALL q775_set_visible()
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
            CALL q775_detail_fill(l_ac1)
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

FUNCTION q775_table()
   #FUN-D10022--modify--優化--
   # DROP TABLE axcq775_tmp;
   #CREATE TEMP TABLE axcq775_tmp(
   #      ima12    LIKE ima_file.ima12,
   #      ima57    LIKE ima_file.ima57,
   #      ima08    LIKE ima_file.ima08, 
   #      tlf01    LIKE tlf_file.tlf01,
   #      ima02    LIKE ima_file.ima02,
   #      ima021   LIKE ima_file.ima021,
   #      tlf14    LIKE tlf_file.tlf14,
   #      tlf17    LIKE tlf_file.tlf17,
   #      tlf19    LIKE tlf_file.tlf19,
   #      gem02    LIKE gem_file.gem02,
   #      tlf021   LIKE tlf_file.tlf021,
   #      tlf06    LIKE tlf_file.tlf06,
   #      tlf026   LIKE tlf_file.tlf026,    
   #      ima39    LIKE ima_file.ima39,
   #      ima391   LIKE ima_file.ima391,
   #      tlf930   LIKE tlf_file.tlf930,
   #      tlfccost LIKE type_file.chr100, 
   #      tlf10    LIKE tlf_file.tlf10,
   #      ccc23a   LIKE ccc_file.ccc23a,
   #      ccc23b   LIKE ccc_file.ccc23b,
   #      ccc23c   LIKE ccc_file.ccc23c,
   #      ccc23d   LIKE ccc_file.ccc23d,
   #      ccc23e   LIKE ccc_file.ccc23e,
   #      ccc23f   LIKE ccc_file.ccc23f,
   #      ccc23g   LIKE ccc_file.ccc23g,
   #      ccc23h   LIKE ccc_file.ccc23h,
   #      ccc23a2  LIKE ccc_file.ccc23h,
   #      tlf907   LIKE tlf_file.tlf907,  
   #      tlf13    VARCHAR(20)            
   #      )   
   CREATE TEMP TABLE axcq775_tmp(
              order1    LIKE type_file.chr20,   
              tlf037    LIKE    tlf_file.tlf037, 
              tlf907    LIKE    tlf_file.tlf907,
              tlf13     LIKE    tlf_file.tlf13, 
              tlf14     LIKE    tlf_file.tlf14, 
              azf03     LIKE    azf_file.azf03,  
              tlf17     LIKE    tlf_file.tlf17,  
              tlf19     LIKE    tlf_file.tlf19, 
              gem02     LIKE    gem_file.gem02, 
              tlf021    LIKE    tlf_file.tlf021,
              tlf031    LIKE    tlf_file.tlf031, 
              tlf06     LIKE    tlf_file.tlf06,  
              tlf026    LIKE    tlf_file.tlf026, 
              tlf027    LIKE    tlf_file.tlf027, 
              tlf036    LIKE    tlf_file.tlf036,
              ima39     LIKE    ima_file.ima39,
              ima391    LIKE    ima_file.ima391,
              tlf01     LIKE    tlf_file.tlf01,  
              tlf10     LIKE    tlf_file.tlf10,  
              ccc23a    LIKE    ccc_file.ccc23a, 
              ccc23b    LIKE    ccc_file.ccc23b,
              ccc23c    LIKE    ccc_file.ccc23c,
              ccc23d    LIKE    ccc_file.ccc23d, 
              ccc23e    LIKE    ccc_file.ccc23e, 
              ccc23f    LIKE    ccc_file.ccc23f,                                                     
              ccc23g    LIKE    ccc_file.ccc23g,                                                         
              ccc23h    LIKE    ccc_file.ccc23h,
              ima02     LIKE    ima_file.ima02, 
              tlfccost  LIKE    tlfc_file.tlfccost, 
              ima021    LIKE    ima_file.ima021,    
              imaud33   LIKE    ima_file.imaud33,
              imaud34   LIKE    ima_file.imaud34,
              ima12     LIKE    ima_file.ima12,     
              l_ccc23a  LIKE    ccc_file.ccc23a,
              l_ccc23b  LIKE    ccc_file.ccc23b,
              l_ccc23c  LIKE    ccc_file.ccc23c,
              l_ccc23d  LIKE    ccc_file.ccc23d,
              l_ccc23e  LIKE    ccc_file.ccc23e,
              l_ccc23f  LIKE    ccc_file.ccc23f,                                                        
              l_ccc23g  LIKE    ccc_file.ccc23g,                         
              l_ccc23h  LIKE    ccc_file.ccc23h,    
              l_tot     LIKE    ccc_file.ccc23a,
              ima57     LIKE    ima_file.ima57,
              ima08     LIKE    ima_file.ima08,
              tlf032    LIKE    tlf_file.tlf032,
              tlf930    LIKE    tlf_file.tlf930)
             #ina09     LIKE    ina_file.ina09,     #MOD-D30247 mark  因無法mark在中間,故將其移到外面
END FUNCTION 

FUNCTION q775_set_visible()

   CALL cl_set_comp_visible("ima12_1,ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1,
                             tlf14_1,azf03_1,tlf19_1,gem02_1",TRUE)

   CASE tm.a 
      WHEN "1"
         CALL cl_set_comp_visible("ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1,
                                   tlf14_1,azf03_1,tlf19_1,gem02_1",FALSE)
      WHEN "2"
         CALL cl_set_comp_visible("ima12_1,ima08_1,tlf01_1,ima02_1,ima021_1,
                                   tlf14_1,azf03_1,tlf19_1,gem02_1",FALSE)
      WHEN "3"
         CALL cl_set_comp_visible("ima12_1,ima57_1,tlf01_1,ima02_1,ima021_1,
                                   tlf14_1,azf03_1,tlf19_1,gem02_1",FALSE)
      WHEN "4"
         CALL cl_set_comp_visible("ima12_1,ima57_1,ima08_1,
                                   tlf14_1,azf03_1,tlf19_1,gem02_1",FALSE)
      WHEN "6"
         CALL cl_set_comp_visible("ima12_1,ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1,
                                   tlf19_1,gem02_1",FALSE)
      WHEN "5"
         CALL cl_set_comp_visible("ima12_1,ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1,
                                   tlf14_1,azf03_1",FALSE)
      #FUN-D10022--add--str--
      WHEN "7"
         CALL cl_set_comp_visible("ima12_1,ima57_1,ima08_1,tlf01_1,ima02_1,ima021_1",FALSE)
      #FUN-D10022--add--end--
   END CASE
END FUNCTION 
      
