# Prog. Version..: '5.30.06-13.04.19(00004)'     #
#
# Pattern name...: cxcq761.4gl
# Descriptions...: 銷貨毛利查詢
# Date & Author..: 17/03/10 By liming


 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,   
           cb1     LIKE type_file.chr1,         
           bdate   LIKE type_file.dat,          
           edate   LIKE type_file.dat
 		   END RECORD
DEFINE g_ckk       RECORD LIKE ckk_file.* 
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
DEFINE m_plant     ARRAY[10] OF LIKE azp_file.azp01   #FUN-A70084
DEFINE m_legal     ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084 
DEFINE g_rec_b     LIKE type_file.num10
DEFINE g_cnt       LIKE type_file.num10
DEFINE g_rec_b1    LIKE type_file.num10
DEFINE g_tot       LIKE tlf_file.tlf10
DEFINE g_sum1      LIKE tlf_file.tlf21
DEFINE g_sum2      LIKE tlf_file.tlf21
DEFINE g_sum3      LIKE tlf_file.tlf21
DEFINE g_rate      LIKE type_file.num20_6
DEFINE g_tlfa      DYNAMIC ARRAY OF RECORD
                   gbno_1         LIKE tlf_file.tlf01,        #料号
                   tlf10a         LIKE tlf_file.tlf10,        #异动数量 
                   chdj_1         LIKE type_file.num20_6,
                   gbdj_1         LIKE type_file.num20_6, 
                   smtdj_1        LIKE type_file.num20_6, 
                   gbsr_1         LIKE type_file.num20_6,  
                   smtsr_1        LIKE type_file.num20_6,  
                   ccc23a_1       LIKE ccc_file.ccc23a,        
                   ccc23b_1       LIKE ccc_file.ccc23b, 
                   ccc23c_3       LIKE ccc_file.ccc23c, 
                   ccc23d_1       LIKE ccc_file.ccc23d, 
                   ccc23_3        LIKE ccc_file.ccc23,
                   ccc23a_2       LIKE ccc_file.ccc23a,
                   ccc23b_2       LIKE ccc_file.ccc23b,  
                   ccc23c_2       LIKE ccc_file.ccc23c,
                   ccc23d_2       LIKE ccc_file.ccc23d,
                   ccc23_2        LIKE ccc_file.ccc23, 
                   cy1            LIKE type_file.num20_6, 
                   cy2            LIKE type_file.num20_6,  
                   cy3            LIKE type_file.num20_6,  
                   cy4            LIKE type_file.num20_6, 
                   cy5            LIKE type_file.num20_6,  
                   gbml_1         LIKE type_file.num20_6, 
                   gbmll_1        LIKE type_file.num20_6, 
                   smtml_1        LIKE type_file.num20_6,  
                   smtmll_1       LIKE type_file.num20_6, 
                   ml_total       LIKE type_file.num20_6,  
                   mll_total      LIKE type_file.num20_6 
                   END RECORD                   
DEFINE g_tlf       DYNAMIC ARRAY OF RECORD
                   tlf026        LIKE tlf_file.tlf026,       #出货单号
                   tlf027        LIKE tlf_file.tlf027,       #出货单项次
                   tlf19         LIKE tlf_file.tlf19,
                   wocc02        LIKE occ_file.occ02,        #客户简称
                   oma08         LIKE oma_file.oma08,        #销售类型                   
                   tlf01         LIKE tlf_file.tlf01,        #料号
                   ima02         LIKE ima_file.ima02,
                   tlf10         LIKE tlf_file.tlf10,        #异动数量
                    dj           LIKE type_file.num20_6,     #单价 
                   ccc23         LIKE ccc_file.ccc23,
                   xssr          LIKE tlf_file.tlf10,        #出货销售收入
                   xscb          LIKE ccc_file.ccc23,        #出货销售成本  
                   xsml          LIKE tlf_file.tlf10,        #销售毛利
                   xsmll         LIKE type_file.num20_6,     #毛利率
                   gbno          LIKE tlf_file.tlf01,        #料号
                   ima02_1       LIKE ima_file.ima02,        #品名
                   ta_xmf03      LIKE xmf_file.ta_xmf03,     #光板销售单价
                   ccc23_1       LIKE ccc_file.ccc23, 
                   gbxssr        LIKE ccc_file.ccc23, 
                   gbxscb        LIKE ccc_file.ccc23, 
                   gbxsml        LIKE ccc_file.ccc23,
                   gbxsmll       LIKE type_file.num20_6,
                   smtno         LIKE tlf_file.tlf01, 
                   ima02_2       LIKE ima_file.ima02, 
                   smtclsr       LIKE type_file.num20_6, 
                   smtzzsr       LIKE type_file.num20_6,
                   smtxssr       LIKE type_file.num20_6, 
                   smtxscb       LIKE type_file.num20_6,
                   smtxsml       LIKE type_file.num20_6, 
                   smtxsmll      LIKE type_file.num20_6, 
                   occ04         LIKE occ_file.occ04, 
                   gen02         LIKE gen_file.gen02,        #业务员
                   tlf036        LIKE tlf_file.tlf036       #订单单号                     
                   END RECORD
DEFINE g_tlf_excel DYNAMIC ARRAY OF RECORD
                   tlf026        LIKE tlf_file.tlf026,       #出货单号
                   tlf027        LIKE tlf_file.tlf027,       #出货单项次
                   tlf19         LIKE tlf_file.tlf19,
                   wocc02        LIKE occ_file.occ02,        #客户简称
                   oma08         LIKE oma_file.oma08,        #销售类型                   
                   tlf01         LIKE tlf_file.tlf01,        #料号
                   ima02         LIKE ima_file.ima02,
                   tlf10         LIKE tlf_file.tlf10,        #异动数量
                    dj           LIKE type_file.num20_6,     #单价 
                   ccc23         LIKE ccc_file.ccc23,
                   xssr          LIKE tlf_file.tlf10,        #出货销售收入
                   xscb          LIKE ccc_file.ccc23,        #出货销售成本  
                   xsml          LIKE tlf_file.tlf10,        #销售毛利
                   xsmll         LIKE type_file.num20_6,     #毛利率
                   gbno          LIKE tlf_file.tlf01,        #料号
                   ima02_1       LIKE ima_file.ima02,        #品名
                   ta_xmf03      LIKE xmf_file.ta_xmf03,     #光板销售单价
                   ccc23_1       LIKE ccc_file.ccc23, 
                   gbxssr        LIKE ccc_file.ccc23, 
                   gbxscb        LIKE ccc_file.ccc23, 
                   gbxsml        LIKE ccc_file.ccc23,
                   gbxsmll       LIKE type_file.num20_6,
                   smtno         LIKE tlf_file.tlf01, 
                   ima02_2       LIKE ima_file.ima02, 
                   smtclsr       LIKE type_file.num20_6, 
                   smtzzsr       LIKE type_file.num20_6,
                   smtxssr       LIKE type_file.num20_6, 
                   smtxscb       LIKE type_file.num20_6,
                   smtxsml       LIKE type_file.num20_6, 
                   smtxsmll      LIKE type_file.num20_6, 
                   occ04         LIKE occ_file.occ04, 
                   gen02         LIKE gen_file.gen02,        #业务员
                   tlf036        LIKE tlf_file.tlf036       #订单单号 
                   END RECORD
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE l_ac           LIKE type_file.num5
DEFINE g_abb24        LIKE abb_file.abb24
DEFINE g_bdate,g_edate   LIKE type_file.dat            #No.FUN-680122DATE
DEFINE g_cka00        LIKE cka_file.cka00              #FUN-C80092
DEFINE g_argv8        LIKE type_file.num5               #No.FUN-C80092
DEFINE g_argv9        LIKE type_file.num5              #No.FUN-C80092
DEFINE g_argv13       LIKE type_file.chr1              #No.FUN-C80092
DEFINE g_action_flag  LIKE type_file.chr100
DEFINE g_filter_wc    STRING
DEFINE   w    ui.Window      
DEFINE   f    ui.Form       
DEFINE   page om.DomNode

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 

   IF cl_null(g_bgjob) or g_bgjob = 'N'THEN
      OPEN WINDOW q761_w AT 5,10  
           WITH FORM "cxc/42f/cxcq761" ATTRIBUTE(STYLE = g_win_style)  #FUN-C80092 add
      CALL cl_ui_init()           #FUN-C80092 add
      CALL cl_set_act_visible("revert_filter",FALSE)
      CALL cxcq761_tm(0,0)
      CALL q761_menu()            
      DROP TABLE cxcq761_tmp;     
      CLOSE WINDOW q761_w         
   ELSE
      CALL cxcq761()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q761_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q761_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL cxcq761_tm(0,0)
            END IF
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q761_filter_askkey()
               CALL cxcq761()        #重填充新臨時表
            END IF            
    
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL cxcq761()        #重填充新臨時表
            END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_action_flag 
                  WHEN 'page2'
                     LET page = f.FindNode("Page","page2")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlfa),'','')
                  WHEN 'page3'
                     LET page = f.FindNode("Page","page3")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_tlf_excel),'','')
               END CASE
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               CALL cl_doc()
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION cxcq761_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag            LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_cmd             LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400)
   DEFINE l_cnt             LIKE type_file.num5          #FUN-A70084
 
   CALL cl_opmsg('p')

   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
      RETURNING l_flag,g_bdate,g_edate
   CLEAR FORM
   INITIALIZE tm.* TO NULL
   LET g_filter_wc=''
   CALL g_tlfa.clear()
   IF cl_null(tm.bdate) THEN LET tm.bdate= g_bdate END IF        
   IF cl_null(tm.edate) THEN LET tm.edate= g_edate END IF            
   LET tm.cb1 = '1'  
   LET g_pdate= g_today

 
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT BY NAME tm.cb1,tm.bdate,tm.edate     
                     
         ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         BEFORE FIELD bdate
           
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
            
      
            
         AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate END IF

           
         ON CHANGE bdate
            IF tm.bdate <> g_bdate THEN
               LET tm.c = 'N'
               DISPLAY tm.c TO c
               
            END IF
        
         AFTER FIELD type                                              
            IF tm.type NOT MATCHES '[12]' THEN NEXT FIELD type END IF


            #FUN-A70084--add--end
            IF NOT s_chk_demo(g_user,tm.p7) THEN
               NEXT FIELD p7
            END IF            
         END IF
      
                
      END INPUT

      CONSTRUCT tm.wc ON tlf01
                            FROM s_tlfa[1].gbno_1
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

      END CONSTRUCT
      ON ACTION controlp
         CASE
            WHEN INFIELD(gbno_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gbno_1
               NEXT FIELD gbno_1
   
         END CASE                        

      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
         
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG    
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION ACCEPT
         ACCEPT DIALOG 

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT DIALOG 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
         
      ON ACTION qbe_save
         CALL cl_qbe_save()
         
   END DIALOG
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      RETURN
   END IF 

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cxcq761'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('cxcq761','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",                
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.cb1 CLIPPED,"'",                
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"                             
 
         CALL cl_cmdat('cxcq761',g_time,l_cmd)    # Execute cmd at later time
      END IF
   END IF
   CALL cxcq761()
END FUNCTION

FUNCTION q761_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
   CONSTRUCT l_wc ON tlf01,occ03,ima131,occ04,tlf19
                 FROM s_tlfa[1].tlf01a,s_tlfa[1].occ03a,s_tlfa[1].ima131a,s_tlfa[1].occ04a,s_tlfa[1].tlf19a
      BEFORE CONSTRUCT 
         CALL cl_qbe_init()


      ON ACTION controlp
         CASE
            WHEN INFIELD(gbno_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gbno_1
               NEXT FIELD gbno_1
            WHEN INFIELD(occ03a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oca"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO occ03a
               NEXT FIELD occ03a
            WHEN INFIELD(occ04a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO occ04a
               NEXT FIELD occ04a
            WHEN INFIELD(ima131a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_oba"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131a
               NEXT FIELD ima131a
            WHEN INFIELD(tlf19a)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tlf19a
               NEXT FIELD tlf19a
         END CASE

      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION ACCEPT
         ACCEPT CONSTRUCT

      ON ACTION CANCEL
         LET INT_FLAG=1
         EXIT CONSTRUCT
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

FUNCTION cxcq761()
   DEFINE l_name    LIKE type_file.chr20,         
          l_sql     STRING,                      
          l_chr     LIKE type_file.chr1,        
          l_za05    LIKE type_file.chr1000        
  DEFINE wima201    LIKE type_file.chr2          
  DEFINE l_ogb01 LIKE tlf_file.tlf905       
  DEFINE l_ogb03 LIKE tlf_file.tlf906     
  DEFINE l_oga00    LIKE oga_file.oga00           
  DEFINE l_oha09    LIKE oha_file.oha09
  DEFINE l_oga65    LIKE oga_file.oga65               
  DEFINE warea_name LIKE oab_file.oab01,          
    sr  RECORD
        ima01   LIKE ima_file.ima01,
        ima02   LIKE ima_file.ima02,
        ima021  LIKE ima_file.ima021,
        ima131  LIKE ima_file.ima131,
        occ02   LIKE occ_file.occ02,
        occ03   LIKE occ_file.occ03,
        occ04   LIKE occ_file.occ04,
        occ37   LIKE occ_file.occ37,
        tlf026  LIKE tlf_file.tlf026,
        tlf027  LIKE tlf_file.tlf027,
        tlf036  LIKE tlf_file.tlf036,
        tlf01   LIKE tlf_file.tlf01,
        tlf10   LIKE tlf_file.tlf10,
        tlfc21  LIKE tlfc_file.tlfc21,
        tlf13   LIKE tlf_file.tlf13,
        tlf19   LIKE tlf_file.tlf19,
        tlf66   LIKE tlf_file.tlf66,
        tlf902 LIKE tlf_file.tlf902,
        tlf903 LIKE tlf_file.tlf903,
        tlf904 LIKE tlf_file.tlf904,
        tlf905  LIKE tlf_file.tlf905,
        tlf906  LIKE tlf_file.tlf906,
        tlf907    LIKE tlf_file.tlf907,
        tlfc221   LIKE tlfc_file.tlfc221,    #材料金額   amt01
        tlfc222   LIKE tlfc_file.tlfc222,    #人工金額   amt02
        tlfc2231  LIKE tlfc_file.tlfc2231,   #製造費用一 amt03
        tlfc2232  LIKE tlfc_file.tlfc2232,   #委外加工費 amt_d
        tlfc224   LIKE tlfc_file.tlfc224,    #製造費用二 amt05
        tlfc2241  LIKE tlfc_file.tlfc2241,   #製造費用三 amt06
        tlfc2242  LIKE tlfc_file.tlfc2242,   #製造費用四 amt06
        tlfc2243  LIKE tlfc_file.tlfc2243,   #製造費用五 amt08
        wsaleamt  LIKE type_file.num20_6
        END RECORD
   DEFINE l_tlf905 LIKE tlf_file.tlf905       #MOD-710150 mod
   DEFINE l_tlf906 LIKE tlf_file.tlf906       #MOD-710150 mod
   DEFINE l_tlf905_1 LIKE tlf_file.tlf905       #No:TQC-A60085 add
   DEFINE l_tlf906_1 LIKE tlf_file.tlf906       #No:TQC-A60085 add
   DEFINE l_wsale_tlf21 LIKE tlf_file.tlf21
   DEFINE l_rate        LIKE type_file.num20_6
   DEFINE wocc02        LIKE occ_file.occ02
   DEFINE wticket       LIKE oma_file.oma33
   DEFINE l_i           LIKE type_file.num5                 #No.FUN-8A0065 SMALLINT
   DEFINE l_cnt         LIKE type_file.num5                 #No.MOD-8C0092 add
   DEFINE l_dbs         LIKE azp_file.azp03                 #No.FUN-8A0065
   DEFINE l_azp03       LIKE azp_file.azp03                 #No.FUN-8A0065
   DEFINE l_occ04       LIKE occ_file.occ04
   DEFINE l_gen02       LIKE gen_file.gen02
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_occ37       LIKE occ_file.occ37                 #No.FUN-8A0065
   DEFINE i             LIKE type_file.num5                 #No.FUN-8A0065   
   DEFINE l_oma00       LIKE oma_file.oma00                 #No:TQC-A60085
   DEFINE l_oma08       LIKE oma_file.oma08
   DEFINE l_omb16       LIKE omb_file.omb16                 #No:TQC-A60085
   DEFINE l_omb38       LIKE omb_file.omb38                 #No:TQC-A60085
   DEFINE l_saleamt     LIKE omb_file.omb16                 #No:TQC-A60085
   DEFINE l_oct12       LIKE oct_file.oct12                 #No:FUN-9B0017
   DEFINE l_oct14       LIKE oct_file.oct14                 #No:FUN-9B0017
   DEFINE l_oct15       LIKE oct_file.oct15                 #No:FUN-9B0017
   DEFINE l_byear       LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_bmonth      LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_bdate       LIKE type_file.num10                #No:FUN-9B0017
   DEFINE l_eyear       LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_emonth      LIKE type_file.num5                 #No:FUN-9B0017
   DEFINE l_edate       LIKE type_file.num10                #No:FUN-9B0017
   DEFINE l_flag        LIKE type_file.chr1                 #MOD-B10194 add
   DEFINE l_n           LIKE type_file.num10                #free 5->10
   DEFINE l_msg         STRING
   DEFINE l_azf08       LIKE azf_file.azf08                 #FUN-C10015
   DEFINE l_num1,l_num2,l_num3  LIKE tlf_file.tlf10
   DEFINE l_cost1,l_cost2,l_cost3,l_wsaleamt,l_wsaleamt1,l_wsaleamt2 LIKE tlf_file.tlf21  #FUN-D10022 add l_wsaleamt1,l_wsaleamt2
   DEFINE l_gem01       LIKE gem_file.gem01,
          l_occ03       LIKE occ_file.occ03,
          l_ima02       LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021,
          l_omf10       LIKE omf_file.omf10
   DEFINE l_sql1        STRING
   DEFINE l_sql2        STRING
         
  SELECT oaz92,oaz93 INTO g_oaz.oaz92,g_oaz.oaz93 FROM oaz_file    #yinhy150504

   LET l_msg = "tm.bdate = '",tm.bdate,"'",";","tm.edate = '",tm.edate,"'",";",
               "tm.cb1 = '",tm.cb1,"'"
   CALL s_log_ins(g_prog,'','',tm.wc,l_msg)
        RETURNING g_cka00

   IF cl_null(g_filter_wc) THEN LET g_filter_wc =' 1=1' END IF 
   CALL cxcq761_table()
   
   FOR i = 1 TO 8 LET m_plant[i] = NULL END FOR 
 
   LET l_n = 1
   FOR l_i = 1 to 8
      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_plant[l_i]   
      LET l_dbs = s_dbstring(l_dbs CLIPPED) 
      IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF  
      CALL q761_set_entry() RETURNING l_cnt
      IF l_cnt>1 THEN LET m_plant[1] = g_plant END IF   #Single DB 


      LET l_sql = "SELECT tlf905,tlf906,tlf19,occ02,tlf01,ima02,NVL(SUM(tlf10*tlf60*tlf907),0),0 dj,ccc23,0 xssr,",
                  "        0 xscb,0 xsml,0 xsmll,'','',ta_xmf03,ccc23,0 gbxssr,0 gbxscb,0 gbxsml,0 gbxsmll,tlf01,ima02,0 smtclsr,0 smtzzsr,0 smtxssr,0 smtxscb,0 smtxsml,0 smtxsmll, ",
                  "        occ04,'' gen02,tlf036,",               
                  "  FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),",",cl_get_target_table(m_plant[l_i],'tlf_file'),
                  "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'occ_file')," ON tlf19=occ01 ",
                  "  LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'ccc_file')," ON tlf01=ccc01 ",
                  " WHERE ima01 = tlf01" 
         
         LET l_sql1 ="   AND (tlf13 LIKE 'axmt%' OR tlf13 LIKE 'aomt%')"


         LET l_sql2 ="   AND ",tm.wc CLIPPED,
                     "   AND ",g_filter_wc CLIPPED,
                     "   AND tlf902 not in (SELECT jce02 from ",cl_get_target_table(m_plant[l_i],'jce_file'),")",            
                     "   AND (tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                     "   AND tlf905 LIKE TRIM(smyslip)||'-%' AND smydmy1 ='Y' ",    #No.MOD-D30160
                     " GROUP BY tlf01,ima02,occ02,occ04,tlf036,tlf905,tlf906",
                     "   ORDER BY tlf01,tlf905,tlf906 "  
        
      LET l_sql = l_sql,l_sql1,l_sql2        

      LET l_sql = " INSERT INTO cxcq761_tmp ",
                  "    SELECT x.*,ROW_NUMBER() OVER (PARTITION BY tlf905,tlf906 ORDER BY tlf01,tlf905,tlf906) ",
                  "   FROM (",l_sql CLIPPED,") x "
      PREPARE cxcq761_ins FROM l_sql
      EXECUTE cxcq761_ins
 
      LET l_sql = " DELETE FROM cxcq761_tmp ",
                  "  WHERE tlf905 IN (SELECT oga01 FROM oga_file WHERE oga00 IN ('3','A','7') OR oga65 = 'Y')"
      PREPARE cxcq761_del FROM l_sql
      EXECUTE cxcq761_del                  
 
      LET l_byear=YEAR(tm.bdate)
      LET l_bmonth=MONTH(tm.bdate)
      LET l_bdate=(l_byear*12)+l_bmonth
      LET l_eyear=YEAR(tm.edate)
      LET l_emonth=MONTH(tm.edate)
      LET l_edate=(l_eyear*12)+l_emonth
      LET sr.wsaleamt = 0
 
      LET l_sql = "MERGE INTO cxcq761_tmp o",
                  "  USING( SELECT DISTINCT oma08,omb31,omb32 ",
                  "           FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",", 
                                     cl_get_target_table(m_plant[l_i],'omb_file'),
                  "          WHERE oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                  "                AND omaconf = 'Y' AND omavoid != 'Y') x ",
                  "  ON (o.tlf905=x.omb31 AND o.tlf906=x.omb32 )",  
                  " WHEN MATCHED ",
                  " THEN ",
                  "   UPDATE ",
                  "      SET o.oma08 = x.oma08 ",
                  "    WHERE (o.rowno=1 OR o.tlf66 = 'X')"
      PREPARE q761_oma0801 FROM l_sql          
      EXECUTE q761_oma0801
     
#      UPDATE cxcq761_tmp SET ogb01 = tlf905,
#                             ogb03 = tlf906
      

      LET l_sql = "MERGE INTO cxcq761_tmp o",
                  "  USING( SELECT DISTINCT oma00,NVL(omb16,0) omb16,omb38,omb31,omb32,oma76 ",   #MOD-D90121 add
                  "           FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",", 
                                     cl_get_target_table(m_plant[l_i],'omb_file'),
                  "          WHERE oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                  "                AND omaconf = 'Y' AND omavoid != 'Y' AND oma00 LIKE '1%' AND omb38 ='3' ) x ",
                   "  ON (o.ogb01 =x.omb31 AND o.ogb03 =x.omb32 AND (o.tlf905 = x.omb31 OR x.oma76 IS NULL))", #MOD-D90121 add
                  " WHEN MATCHED ",
                  " THEN ",
                  "   UPDATE ",
                  "      SET o.xssr = o.xssr+ x.omb16 *(-1) ",
                  "                       -(SELECT NVL(SUM(oct12),0) FROM oct_file ",
                  "                             WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                                   AND oct16='3' AND oct00='0') ",
                  "                       + (SELECT NVL(SUM(oct15),0) FROM oct_file ",
                  "                               WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                               AND oct16 = '4' ",
                  "                               AND (oct09*12)+oct10 BETWEEN ",l_bdate," AND ",l_edate,
                  "                               AND oct00 = '0')",
                  "    WHERE (o.rowno=1 OR o.tlf66 = 'X')  AND o.tlf10 >0 "
      PREPARE q761_wsaleamt01 FROM l_sql          
      EXECUTE q761_wsaleamt01 
 
      LET l_sql = "MERGE INTO cxcq761_tmp o",
                  "  USING( SELECT DISTINCT oma00,NVL(omb16,0) omb16,omb38,omb31,omb32,oma76 ",   #MOD-D90121 add
                  "           FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",", 
                                     cl_get_target_table(m_plant[l_i],'omb_file'),
                  "          WHERE oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                  "                AND omaconf = 'Y' AND omavoid != 'Y' AND oma00 LIKE '1%' AND omb38 ='3' ) x ",
                  "  ON (o.ogb01 =x.omb31 AND o.ogb03 =x.omb32 AND (o.tlf905 = x.omb31 OR x.oma76 IS NULL))", #MOD-D90121 add
                  " WHEN MATCHED ",
                  " THEN ",
                  "   UPDATE ",
                  "      SET o.xssr = o.xssr+ x.omb16 *(-1) ",
                  "                       -(SELECT NVL(SUM(oct12),0) FROM oct_file ",
                  "                             WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                                   AND oct16='1' AND oct00='0') ",
                  "                       + (SELECT NVL(SUM(oct14),0) FROM oct_file ",
                  "                               WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                               AND oct16 = '2' ",
                  "                               AND (oct09*12)+oct10 BETWEEN ",l_bdate," AND ",l_edate,
                  "                               AND oct00 = '0')",
                  "    WHERE (o.rowno=1 OR o.tlf66 = 'X') AND o.tlf10 <=0 "
      PREPARE q761_wsaleamt02 FROM l_sql          
      EXECUTE q761_wsaleamt02 
      
      LET l_sql = "MERGE INTO cxcq761_tmp o",
                  "  USING( SELECT DISTINCT oma00,NVL(omb16,0) omb16,omb38,omb31,omb32,oma76 ",   #MOD-D90121 add
                  "           FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",", 
                                     cl_get_target_table(m_plant[l_i],'omb_file'),
                  "          WHERE oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                  "                AND omaconf = 'Y' AND omavoid != 'Y' AND (oma00 NOT LIKE '1%' OR omb38 <> '3') ) x ",
                   "  ON (o.ogb01 =x.omb31 AND o.ogb03 =x.omb32 AND (o.tlf905 = x.omb31 OR x.oma76 IS NULL))", #MOD-D90121 add
                  " WHEN MATCHED ",
                  " THEN ",
                  "   UPDATE ",
                  "      SET o.xssr = o.xssr+ x.omb16 ",
                  "                       -(SELECT NVL(SUM(oct12),0) FROM oct_file ",
                  "                             WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                                   AND oct16='3' AND oct00='0') ",
                  "                       + (SELECT NVL(SUM(oct15),0) FROM oct_file ",
                  "                               WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                               AND oct16 = '4' ",
                  "                               AND (oct09*12)+oct10 BETWEEN ",l_bdate," AND ",l_edate,
                  "                               AND oct00 = '0')",
                  "    WHERE (o.rowno=1 OR o.tlf66 = 'X')  AND o.tlf10 >0 "
      PREPARE q761_wsaleamt03 FROM l_sql          
      EXECUTE q761_wsaleamt03 
      
      #NO.160804--add by yangw---B----
      LET l_sql = "MERGE INTO cxcq761_tmp o",
                 #"  USING( SELECT DISTINCT oma00,NVL(omb16,0) omb16,omb38,omb31,omb32 ",         #MOD-D90121 mark
                  "  USING( SELECT DISTINCT SUM(NVL(omb16,0)) omb16,omb31,omb32 ",   #MOD-D90121 add
                  "           FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",", 
                                     cl_get_target_table(m_plant[l_i],'omb_file'),
                  "          WHERE oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
                  "                AND omaconf = 'Y' AND omavoid != 'Y' AND (oma00  LIKE '1%' OR omb38 <> '3') group by omb31,omb32 ) x ",
                  "  ON (o.ogb01 =x.omb31 AND o.ogb03 =x.omb32 AND (o.tlf905 = x.omb31))", #MOD-D90121 add
                  " WHEN MATCHED ",
                  " THEN ",
                  "   UPDATE ",
                  "      SET o.xssr = o.xssr+ x.omb16 ",
                  "                       -(SELECT NVL(SUM(oct12),0) FROM oct_file ",
                  "                             WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                                   AND oct16='3' AND oct00='0') ",
                  "                       + (SELECT NVL(SUM(oct15),0) FROM oct_file ",
                  "                               WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                               AND oct16 = '4' ",
                  "                               AND (oct09*12)+oct10 BETWEEN ",l_bdate," AND ",l_edate,
                  "                               AND oct00 = '0')",
                  "    WHERE (o.rowno=1 OR o.tlf66 = 'X') AND o.tlf10 <=0 "
      PREPARE q761_wsaleamt03_1 FROM l_sql          
      EXECUTE q761_wsaleamt03_1
      #NO.160804--add by yangw---E----       
               
      LET l_sql = "MERGE INTO cxcq761_tmp o",
                 #"  USING( SELECT DISTINCT oma00,NVL(omb16,0) omb16,omb38,omb31,omb32 ",         #MOD-D90121 mark
                  "  USING( SELECT DISTINCT oma00,NVL(omb16,0) omb16,omb38,omb31,omb32,oma76 ",   #MOD-D90121 add 
                  "           FROM ",cl_get_target_table(m_plant[l_i],'oma_file'),",", 
                                     cl_get_target_table(m_plant[l_i],'omb_file'),
                  "          WHERE oma01=omb01 AND (oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"')",
             #     "                AND omaconf = 'Y' AND omavoid != 'Y' AND (oma00 NOT LIKE '1%' OR omb38 <> '3') ) x ",
                 "                AND omaconf = 'Y' AND omavoid != 'Y' AND (oma00 NOT LIKE '1%' ) ) x ",
                  "  ON (o.ogb01 =x.omb31 AND o.ogb03 =x.omb32 AND (o.tlf905 = x.omb31 OR x.oma76 IS NULL))", #MOD-D90121 add
                  " WHEN MATCHED ",
                  " THEN ",
                  "   UPDATE ",
                  "      SET o.xssr = o.xssr + x.omb16 ",
                  "                       -(SELECT NVL(SUM(oct12),0) FROM oct_file ",
                  "                             WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                                   AND oct16='1' AND oct00='0') ",
                  "                       + (SELECT NVL(SUM(oct14),0) FROM oct_file ",
                  "                               WHERE oct04 = o.tlf905 AND oct05 = o.tlf906 ",
                  "                               AND oct16 = '2' ",
                  "                               AND (oct09*12)+oct10 BETWEEN ",l_bdate," AND ",l_edate,
                  "                               AND oct00 = '0')",
                  "    WHERE (o.rowno=1 OR o.tlf66 = 'X') AND o.tlf10 <=0 "
      PREPARE q761_wsaleamt04 FROM l_sql          
      EXECUTE q761_wsaleamt04

 #---str---add by qianyuan170111---
      IF g_oaz.oaz93='N' THEN 
        
         LET l_sql = "MERGE INTO cxcq761_tmp o",
                    "  USING(SELECT ohb01,ohb03,ohb04,(ohb14*oha24) ohb14_1  ",   #MOD-D90121 add 
                    "           FROM ",cl_get_target_table(m_plant[l_i],'ohb_file'),
                    "           LEFT JOIN (",cl_get_target_table(m_plant[l_i],'omb_file')," LEFT JOIN ",cl_get_target_table(m_plant[l_i],'oma_file')," ON omb01=oma01 AND omaconf = 'Y' AND omavoid != 'Y' AND omb38='2' )  ON omb31=ohb01 AND omb32=ohb03 ,",
                                       cl_get_target_table(m_plant[l_i],'oha_file'),   
                    "          WHERE ohb01=oha01 AND ohapost='Y' ",
                   # "                AND ohb01 NOT IN (SELECT omb31 from omb_file LEFT JOIN oma_file ON oma01=omb01 where omaconf = 'Y' AND omavoid != 'Y' AND omb38='3' ) ) x ",
                    "          AND (omb31 IS NuLL OR omb31=' ') AND (omb32 IS NULL OR omb32 = ' ') ) x ",
                    "  ON (o.ogb01 =x.ohb01 AND o.ogb03=x.ohb03 )", 
                    " WHEN MATCHED ",
                    " THEN ",
                    "   UPDATE ",
                    "      SET o.xssr = o.xssr + x.ohb14_1 ",
                    "    WHERE o.ogb01 =x.ohb01 AND o.ogb03=x.ohb03  "
         PREPARE q761_wsaleamt06 FROM l_sql
         EXECUTE q761_wsaleamt06
      END IF 
      #---end---add by qianyuan170111---

      #add by ly 20170223--s
      LET l_sql = "MERGE INTO cxcq761_tmp o",
                  "  USING(SELECT DISTINCT ogb01,ogb03,ogb04,(ogb14*oga24) ogb14_1 ",   #MOD-D90121 add 
                  "           FROM ",cl_get_target_table(m_plant[l_i],'ogb_file'),",",
                 # "           LEFT JOIN (",cl_get_target_table(m_plant[l_i],'omb_file')," LEFT JOIN ",cl_get_target_table(m_plant[l_i],'oma_file')," ON omb01=oma01 AND omaconf = 'Y' AND omavoid != 'Y' AND omb38='2' ) ON omb31=ogb01 AND omb32=ogb03 ,",
                                         cl_get_target_table(m_plant[l_i],'oga_file'),
                  "          WHERE ogb01=oga01 AND ogapost='Y' ",
                  "                AND oga02 >= '",tm.bdate,"'",
                  "                AND oga02 <= '",tm.edate,"' ) x ",
                  "  ON (o.ogb01 =x.ogb01 AND o.ogb03=x.ogb03 )", 
                  " WHEN MATCHED ",
                  " THEN ",
                  "   UPDATE ",
                  "      SET o.xssr = o.xssr + x.ogb14_1 ",
                  "    WHERE o.xssr = 0 "
      PREPARE q761_wsaleamt07 FROM l_sql
      EXECUTE q761_wsaleamt07
      #add by ly 20170223--e
      UPDATE cxcq761_tmp SET xssr = xssr*-1 WHERE tlf907='1'  #MOD-D90159 add

      j
      UPDATE cxcq761_tmp SET tlf10 = tlf10 * -1,
                             xscb= xscb * -1       
      
      
      LET l_sql = "UPDATE cxcq761_tmp SET dj = xssr/tlf10 " ,
                  "WHERE xtlf10 <> 0"
      PREPARE upd_dj FROM l_sql
      EXECUTE upd_dj
      
      UPDATE cxcq761_tmp SET xsml = xssr - xscb
      
      LET l_sql = "UPDATE cxcq761_tmp SET xsmll = xsml/xscb " ,
                  "WHERE xscb <> 0"
      PREPARE upd_l_rate FROM l_sql
      EXECUTE upd_l_rate                   
 
      DELETE FROM cxcq761_tmp WHERE tlf10 = 0 AND xssr= 0 AND (xscb=0 OR xscb IS NULL)
              

      LET l_sql = " MERGE INTO cxcq761_tmp o ",
                  " USING (SELECT DISTINCT gen01,gen02 FROM ",cl_get_target_table(m_plant[l_i],'gen_file'),
                  "          WHERE gen03 = gem01) x ",
                  "    ON (o.occ04 = x.gen01) " ,
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.gen02 = x.gen02,"
      PREPARE upd_genm FROM l_sql
      EXECUTE upd_genm  
      
   END FOR    


   CALL cxcq761_show()
   CALL s_log_upd(g_cka00,'Y')             #更新日誌 
   
END FUNCTION

FUNCTION cxcq761_table()
     DROP TABLE cxcq761_tmp;
     CREATE TEMP TABLE cxcq761_tmp(
                   tlf905        LIKE tlf_file.tlf905,       #出货单号   #主SQL捞出的tlf026,tlf027是tlf905,tlf906赋值的，故这里可以改成tlf905,tlf906
                   tlf906        LIKE tlf_file.tlf906,       #出货单项次
                   tlf19         LIKE tlf_file.tlf19,
                   wocc02        LIKE occ_file.occ02,        #客户简称
                   oma08         LIKE oma_file.oma08,        #销售类型                   
                   tlf01         LIKE tlf_file.tlf01,        #料号
                   ima02         LIKE ima_file.ima02,
                   tlf10         LIKE tlf_file.tlf10,        #异动数量
                    dj           LIKE type_file.num20_6,     #单价 
                   ccc23         LIKE ccc_file.ccc23,
                   xssr          LIKE tlf_file.tlf10,        #出货销售收入
                   xscb          LIKE ccc_file.ccc23,        #出货销售成本  
                   xsml          LIKE tlf_file.tlf10,        #销售毛利
                   xsmll         LIKE type_file.num20_6,     #毛利率
                   gbno          LIKE tlf_file.tlf01,        #料号
                   ima02_1       LIKE ima_file.ima02,        #品名
                   ta_xmf03      LIKE xmf_file.ta_xmf03,     #光板销售单价
                   ccc23_1       LIKE ccc_file.ccc23, 
                   gbxssr        LIKE ccc_file.ccc23, 
                   gbxscb        LIKE ccc_file.ccc23, 
                   gbxsml        LIKE ccc_file.ccc23,
                   gbxsmll       LIKE type_file.num20_6,
                   smtno         LIKE tlf_file.tlf01, 
                   ima02_2       LIKE ima_file.ima02, 
                   smtclsr       LIKE type_file.num20_6, 
                   smtzzsr       LIKE type_file.num20_6,
                   smtxssr       LIKE type_file.num20_6, 
                   smtxscb       LIKE type_file.num20_6,
                   smtxsml       LIKE type_file.num20_6, 
                   smtxsmll      LIKE type_file.num20_6, 
                   occ04         LIKE occ_file.occ04, 
                   gen02         LIKE gen_file.gen02,        #业务员
                   tlf036        LIKE tlf_file.tlf036);         #订单单号      


END FUNCTION

FUNCTION q761_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page2'
   DISPLAY g_rec_b  TO FORMONLY.cn 
   DISPLAY g_rec_b1 TO FORMONLY.cnt 
   DISPLAY g_tot TO FORMONLY.tot
   DISPLAY g_rate TO FORMONLY.a_rate
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)

      DISPLAY ARRAY g_tlfa TO s_tlfa.* ATTRIBUTE(COUNT=g_rec_b)
       #  BEFORE DISPLAY
       #     CALL cl_navigator_setting( g_curs_index, g_row_count )
       #     IF g_rec_b != 0 AND l_ac != 0 THEN
       #        CALL fgl_set_arr_curr(l_ac)
       #     END IF
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY  

      DISPLAY ARRAY g_tlf TO s_tlf.* ATTRIBUTE(COUNT=g_rec_b)
      #  BEFORE DISPLAY
      #     CALL cl_navigator_setting( g_curs_index, g_row_count )
      #     IF g_rec_b != 0 AND l_ac != 0 THEN
      #        CALL fgl_set_arr_curr(l_ac)
      #     END IF
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

    
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG

      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG       
       
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION page2
         LET g_action_flag ="page2"
 
      ON ACTION page3
         LET g_action_flag ="page3"

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
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
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      AFTER DIALOG
         CONTINUE DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION cxcq761_show()
   DISPLAY tm.type,tm.bdate,tm.edate
        TO type,bdate,edate
   LET g_tot = 0 
   CALL cxcq761_b_fill()  
   CALL cxcq761_b_fill_2()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION cxcq761_b_fill()
DEFINE l_str  STRING
DEFINE l_str1 STRING
DEFINE l_str2 STRING   #FUN-D10022 add 
DEFINE l_cb  ARRAY[5] OF LIKE type_file.chr1
DEFINE i     LIKE type_file.num5

   LET l_cb[1] = tm.cb1

   LET g_sql = "SELECT w1,wi,wb,w2,w3,w4,w5,w6,wc,w7,wd,w8,we "   
   FOR i=1 TO 4
      IF NOT cl_null(l_cb[i]) THEN 
         IF i=1 THEN
            LET l_str = " GROUP BY "
            LET l_str1= " ORDER BY "
         ELSE
            LET l_str = l_str CLIPPED,","
            LET l_str1= l_str1 CLIPPED,","
         END IF
         CASE l_cb[i]
       
            WHEN '1' LET l_str = l_str," tlf01"
                     LET l_str1= l_str1," tlf01"
                     LET g_sql = cl_replace_str(g_sql,'w1','tlf01')
                     
            WHEN '2' LET l_str = l_str," tlf19,d.occ02"
                     LET l_str1= l_str1," tlf19"
                     LET l_str2= l_str2," LEFT OUTER JOIN occ_file d ON d.occ01 = x.tlf19 "
                     LET g_sql = cl_replace_str(g_sql,'w8','tlf19')
                     LET g_sql = cl_replace_str(g_sql,'we','d.occ02')
           
                   
         END CASE
      END IF
   END FOR
   LET g_sql = cl_replace_str(g_sql,"w1","''") 
   LET g_sql = cl_replace_str(g_sql,"w2","''") 
   LET g_sql = cl_replace_str(g_sql,"w3","''") 
   LET g_sql = cl_replace_str(g_sql,"w4","''") 
   LET g_sql = cl_replace_str(g_sql,"w5","''") 
   LET g_sql = cl_replace_str(g_sql,"w6","''") 
   LET g_sql = cl_replace_str(g_sql,"w7","''") 
   LET g_sql = cl_replace_str(g_sql,"w8","''")
   #FUN-D10022--add--str-- 
   LET g_sql = cl_replace_str(g_sql,"wi","''")
   LET g_sql = cl_replace_str(g_sql,"wb","''") 
   LET g_sql = cl_replace_str(g_sql,"wc","''") 
   LET g_sql = cl_replace_str(g_sql,"wd","''") 
   LET g_sql = cl_replace_str(g_sql,"we","''") 
   #FUN-D10022--add--end--
   
   CALL g_tlfa.clear()
   LET g_cnt =1
  
   LET g_sql = g_sql CLIPPED,",NVL(SUM(tlf10),0),NVL(SUM(tlfc21),0),",
               "       NVL(SUM(wsaleamt),0),'',NVL(SUM(tlfc221a),0),NVL(SUM(tlfc222a),0),",
               "       NVL(SUM(tlfc2231a),0),NVL(SUM(tlfc224a),0),NVL(SUM(tlfc2241a),0),",
               "       NVL(SUM(tlfc2242a),0),NVL(SUM(tlfc2243a),0),NVL(SUM(tlfc2232a),0),",
               "       NVL(SUM(l_wsale_tlf21),0),'',''",
               "  FROM cxcq761_tmp x ",l_str2,l_str,l_str1 
              
   PREPARE cxcq761_pb1 FROM g_sql
   DECLARE tlfa_curs  CURSOR FOR cxcq761_pb1
   FOREACH tlfa_curs INTO g_tlfa[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF   

      LET g_tlfa[g_cnt].salerata = g_tlfa[g_cnt].saleamta / g_sum2 
      LET g_tlfa[g_cnt].salerata = cl_digcut(g_tlfa[g_cnt].salerata,5)
      LET g_tlfa[g_cnt].salerata = g_tlfa[g_cnt].salerata * 100
      LET g_tlfa[g_cnt].raterata = g_tlfa[g_cnt].wsale_tlf21a / g_sum3 
      LET g_tlfa[g_cnt].raterata = cl_digcut(g_tlfa[g_cnt].raterata,5)
      LET g_tlfa[g_cnt].raterata = g_tlfa[g_cnt].raterata *100
      LET g_tlfa[g_cnt].ratea = g_tlfa[g_cnt].wsale_tlf21a/g_tlfa[g_cnt].saleamta
      LET g_tlfa[g_cnt].ratea = cl_digcut(g_tlfa[g_cnt].ratea,5)
      LET g_tlfa[g_cnt].ratea = g_tlfa[g_cnt].ratea * 100
      
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_tlfa.deleteElement(g_cnt)
   CALL cl_show_fld_cont()
   LET g_cnt=g_cnt-1
   LET g_rec_b1 = g_cnt
END FUNCTION
 
FUNCTION cxcq761_b_fill_2()

DEFINE l_tlf13         LIKE tlf_file.tlf13,
       l_tlf66         LIKE tlf_file.tlf66,
       l_azf08         LIKE azf_file.azf08,
       l_rowno         LIKE type_file.num5,             
       l_ogb01         LIKE ogb_file.ogb01, #FUN-CC0157
       l_ogb03         LIKE ogb_file.ogb03  #FUN-CC0157
DEFINE l_tlf907        LIKE tlf_file.tlf907 #MOD-D90159 add
DEFINE l_nn            LIKE type_file.chr10
DEFINE l_ta_xmf03      LIKE xmf_file.ta_xmf03
DEFINE l_ta_xmf04      LIKE xmf_file.ta_xmf04
DEFINE l_ta_xmf05      LIKE xmf_file.ta_xmf05

   LET g_sql = "SELECT * ",           
               "  FROM cxcq761_tmp ORDER BY tlf905 "   
               
   PREPARE cxcq761_pb FROM g_sql
   DECLARE tlf_curs  CURSOR FOR cxcq761_pb
 
   CALL g_tlf.clear()
   CALL g_tlfc.clear()
   CALL g_tlf_excel.clear() 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH tlf_curs INTO g_tlf[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
    
    SELECT distinct substr(g_tlfc[g_cnt].tlf01,7,1) into l_nn from dual
    
      IF l_nn <> 'A' THEN  #当为smt料号时
         LET g_tlf[g_cnt].gbno=' '
         LET g_tlf[g_cnt].im02_1=' '
         LET g_tlf[g_cnt].ta_xmf03= 0
         LET g_tlf[g_cnt].ccc23_1= 0 
         LET g_tlf[g_cnt].gbxssr= 0 
         LET g_tlf[g_cnt].gbxscb= 0
         LET g_tlf[g_cnt].gbxsml= 0
         LET g_tlf[g_cnt].gbxsmll= 0
         LET g_tlf[g_cnt].smtno = g_tlf[g_cnt].tlf01 
         LET g_tlf[g_cnt].ima02_2 = g_tlf[g_cnt].ima02
         SELECT ta_xmf04,ta_xmf05 INTO l_ta_xmf04,l_ta_xmf05 WHERE xmf03= g_tlf[g_cnt].smtno 
         LET g_tlf[g_cnt].smtclsr = l_ta_xmf04 * g_tlf[g_cnt].tlf10
         LET g_tlf[g_cnt].smtzzsr = l_ta_xmf05 * g_tlf[g_cnt].tlf10
         LET g_tlf[g_cnt].smtxssr = g_tlf[g_cnt].xssr - g_tlf[g_cnt].smtclsr
         LET g_tlf[g_cnt].smtxscb = g_tlf[g_cnt].xscb - g_tlf[g_cnt].smtzzsr
         LET g_tlf[g_cnt].smtxsml = g_tlf[g_cnt].smtxssr - g_tlf[g_cnt].smtxscb
         LET g_tlf[g_cnt].smtxsmll = g_tlf[g_cnt].smtxsml/g_tlf[g_cnt].smtxscb 
      ELSE
       	 LET g_tlf[g_cnt].gbno= g_tlf[g_cnt].tlf01      #光板料号
         LET g_tlf[g_cnt].im02_1= g_tlf[g_cnt].ima02
         SELECT ta_xmf03 INTO l_ta_xmf03 WHERE xmf03= g_tlf[g_cnt].gbno AND xmf05 
         LET g_tlf[g_cnt].ta_xmf03= l_ta_xmf03
         LET g_tlf[g_cnt].ccc23_1= g_tlf[g_cnt].ccc23
         LET g_tlf[g_cnt].gbxssr= g_tlf[g_cnt].tlf10 * g_tlf[g_cnt].ta_xmf03
         LET g_tlf[g_cnt].gbxscb= g_tlf[g_cnt].tlf10 * g_tlf[g_cnt].ccc23_1 
         LET g_tlf[g_cnt].gbxsml= g_tlf[g_cnt].gbxssr - g_tlf[g_cnt].gbxscb
         LET g_tlf[g_cnt].gbxsmll= g_tlf[g_cnt].gbxsml/g_tlf[g_cnt].gbxscb
         LET g_tlf[g_cnt].smtno = g_tlf[g_cnt].tlf01 
         LET g_tlf[g_cnt].ima02_2 = g_tlf[g_cnt].ima02
         SELECT ta_xmf04,ta_xmf05 INTO l_ta_xmf04,l_ta_xmf05 WHERE xmf03= g_tlf[g_cnt].smtno 
         LET g_tlf[g_cnt].smtclsr = l_ta_xmf04 * g_tlf[g_cnt].tlf10
         LET g_tlf[g_cnt].smtzzsr = l_ta_xmf05 * g_tlf[g_cnt].tlf10
         LET g_tlf[g_cnt].smtxssr = g_tlf[g_cnt].xssr - g_tlf[g_cnt].smtclsr
         LET g_tlf[g_cnt].smtxscb = g_tlf[g_cnt].xscb - g_tlf[g_cnt].smtzzsr
         LET g_tlf[g_cnt].smtxsml = g_tlf[g_cnt].smtxssr - g_tlf[g_cnt].smtxscb
         LET g_tlf[g_cnt].smtxsmll = g_tlf[g_cnt].smtxsml/g_tlf[g_cnt].smtxscb 
      END IF     	         
   
       LET g_cnt = g_cnt + 1   
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 90035, 00 )
           EXIT FOREACH
        END IF
      
   END FOREACH

   CALL g_tlf.deleteElement(g_cnt)  
   CALL cl_show_fld_cont()
   LET g_cnt=g_cnt-1
   LET g_rec_b = g_cnt
   #FUN-C80092--add--str--
   IF g_rec_b > g_max_rec AND (g_bgjob='N' OR g_bgjob is null) THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b = g_max_rec
   END IF
   #FUN-C80092--add--end--

END FUNCTION

FUNCTION q761_set_no_entry()
   IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN
      IF tm.bdate <> g_bdate OR tm.edate <> g_edate THEN
         LET tm.c = 'N'
         CALL cl_set_comp_entry("c",FALSE)
      END IF
   END IF
END FUNCTION


FUNCTION q761_chklegal(l_legal,n)
DEFINE l_legal  LIKE azw_file.azw02
DEFINE l_idx,n  LIKE type_file.num5

   FOR l_idx = 1 TO n
       IF m_legal[l_idx]! = l_legal THEN
          LET g_errno = 'axc-600'
          RETURN 0
       END IF  
   END FOR 
   RETURN 1
END FUNCTION

