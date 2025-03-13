# Prog. Version..: '5.30.06-13.03.26(00001)'     #
#
# Pattern name...: aimq103.4gl
# Descriptions...: 料件數量動態資料清單作業
#                g_argv1      # 1.依料號 2.依工單 3.依訂單 4.依BOM
#                g_argv2      # 1.料號   2.工單   3.訂單   4.產品
# Date & Author..: 13/02/05 By xianghui
# Modify.........: No.FUN-D20019 13/02/05 By xianghui 
# Modify.........: No.MOD-D70081 13/07/11 By fengmy 单身变量错误

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE tm     RECORD
                 wc       STRING,    
                 wc2      LIKE type_file.chr1000  
              END RECORD,
       m_ima  DYNAMIC ARRAY OF RECORD
                 ima02    LIKE ima_file.ima02,
                 ima021   LIKE ima_file.ima021,
                 ima01    LIKE ima_file.ima01
              END RECORD,
       g_ima  RECORD
                 ima01    LIKE ima_file.ima01, # 料件編號
                 ima02    LIKE ima_file.ima02, # 品名規格
                 ima021   LIKE ima_file.ima02, # 品名規格
                 ima25    LIKE ima_file.ima25, #
                 ima05    LIKE ima_file.ima05, # 版本
                 ima06    LIKE ima_file.ima06, # 分群碼
                 ima08    LIKE ima_file.ima08, # 來源碼
                 ima37    LIKE ima_file.ima37, #
                 ima70    LIKE ima_file.ima70, #
                 ima15    LIKE ima_file.ima15, #
                 ima906   LIKE ima_file.ima906, #單位管制方式   
                 ima907   LIKE ima_file.ima907, #第二單位      
                 unavl_stk  LIKE type_file.num15_3, 
                 avl_stk    LIKE type_file.num15_3, 
                 oeb_q      LIKE type_file.num15_3, 
                 sfa_q1     LIKE type_file.num15_3, 
                 sfa_q2     LIKE type_file.num15_3, 
                 sie_q      LIKE type_file.num15_3, 
                 pml_q      LIKE type_file.num15_3, 
                 pmn_q      LIKE type_file.num15_3, 
                 rvb_q2     LIKE type_file.num15_3, 
                 rvb_q      LIKE type_file.num15_3, 
                 sfb_q1     LIKE type_file.num15_3, 
                 sfb_q2     LIKE type_file.num15_3, 
                 qcf_q      LIKE type_file.num15_3, 
                 atp_qty    LIKE type_file.num15_3  
              END RECORD,
       g_imaa DYNAMIC ARRAY OF RECORD
                 ima01    LIKE ima_file.ima01, # 料件編號
                 ima02    LIKE ima_file.ima02, # 品名規格
                 ima021   LIKE ima_file.ima02, # 品名規格
                 ima05    LIKE ima_file.ima05, # 版本
                 ima06    LIKE ima_file.ima06, # 分群碼
                 ima25    LIKE ima_file.ima25, #
                 ima08    LIKE ima_file.ima08, # 來源碼
                 ima37    LIKE ima_file.ima37, #
                 ima70    LIKE ima_file.ima70, #
                 ima15    LIKE ima_file.ima15, #
                 ima906   LIKE ima_file.ima906, #單位管制方式  
                 ima907   LIKE ima_file.ima907, #第二單位       
                 avl_stk    LIKE type_file.num15_3, 
                 oeb_q      LIKE type_file.num15_3,
                 sfa_q1     LIKE type_file.num15_3, 
                 sfa_q2     LIKE type_file.num15_3, 
                 pml_q      LIKE type_file.num15_3, 
                 pmn_q      LIKE type_file.num15_3,
                 sfb_q1     LIKE type_file.num15_3, 
                 sfb_q2     LIKE type_file.num15_3,                 
                 rvb_q2     LIKE type_file.num15_3, 
                 rvb_q      LIKE type_file.num15_3, 
                 qcf_q      LIKE type_file.num15_3, 
                 atp_qty    LIKE type_file.num15_3,
                 unavl_stk  LIKE type_file.num15_3,
                 sie_q      LIKE type_file.num15_3 
              END RECORD,        
       g_img  DYNAMIC ARRAY OF RECORD
                 img02    LIKE img_file.img02,   #倉庫編號
                 imd02    LIKE imd_file.imd02,
                 img03    LIKE img_file.img03,   #儲位
                 ime03    LIKE ime_file.ime03, 
                 img04    LIKE img_file.img04,   #批號 
                 img23    LIKE img_file.img23,   #是否為可用倉庫
                 img10    LIKE img_file.img10,   #庫存數量
                 sig05    LIKE sig_file.sig05, 
                 img09    LIKE img_file.img09,   #庫存單位
                 img38    LIKE img_file.img38    #備註
              END RECORD,
       g_bbb1 DYNAMIC ARRAY OF RECORD
                 tlf06    LIKE tlf_file.tlf06,
                 tlf026   LIKE tlf_file.tlf026,
                 tlf036   LIKE tlf_file.tlf036,
                 msg      LIKE ze_file.ze03,   
                 tlf19    LIKE tlf_file.tlf19,
                 gem02    LIKE gem_file.gem02, 
                 tlf902   LIKE tlf_file.tlf902,
                 tlf903   LIKE tlf_file.tlf903,
                 tlf904   LIKE tlf_file.tlf904,
                 tlf10    LIKE tlf_file.tlf10,
                 tlf11    LIKE tlf_file.tlf11
              END RECORD,
       g_bbb2 DYNAMIC ARRAY OF RECORD
                 pmm04    LIKE pmm_file.pmm04,
                 pmm01    LIKE pmm_file.pmm01,
                 pmc03    LIKE pmc_file.pmc03,
                 pmm22    LIKE pmm_file.pmm22,
                 pmn20    LIKE pmn_file.pmn20,
                 pmn07    LIKE pmn_file.pmn07,
                 pmn86    LIKE pmn_file.pmn86,
                 pmn31    LIKE pmn_file.pmn31,
                 pmn33    LIKE pmn_file.pmn33,
                 pmm20    LIKE pmm_file.pmm20
              END RECORD,
       g_bbb3 DYNAMIC ARRAY OF RECORD
                 bmx07    LIKE bmx_file.bmx07,
                 bmx01    LIKE bmx_file.bmx01,
                 bmz03    LIKE bmz_file.bmz03,
                 bmz02    LIKE bmz_file.bmz02,
                 bmg03    LIKE bmg_file.bmg03,
                 bmy03    LIKE bmy_file.bmy03,
                 bmy19    LIKE bmy_file.bmy19,
                 bmy06    LIKE bmy_file.bmy06
              END RECORD,
       g_bbb4 DYNAMIC ARRAY OF RECORD
                 bmb01    LIKE bmb_file.bmb01,
                 ima02    LIKE ima_file.ima02,  
                 ima021   LIKE ima_file.ima021,
                 bmb02    LIKE bmb_file.bmb02,
                 bmb04    LIKE bmb_file.bmb04,
                 bmb05    LIKE bmb_file.bmb05,
                 bmb16    LIKE bmb_file.bmb16,
                 bmb06    LIKE bmb_file.bmb06,
                 bmb08    LIKE bmb_file.bmb08
              END RECORD,
       g_bbb5 DYNAMIC ARRAY OF RECORD
                 imm01    LIKE imm_file.imm01,
                 imm02    LIKE imm_file.imm02,
                 imn04    LIKE imn_file.imn04,
                 imn05    LIKE imn_file.imn05,
                 imn06    LIKE imn_file.imn06,
                 imn15    LIKE imn_file.imn15,
                 imn16    LIKE imn_file.imn16,
                 imn17    LIKE imn_file.imn17,
                 imn10    LIKE imn_file.imn10,
                 imn09    LIKE imn_file.imn09
              END RECORD,
       g_sw               LIKE type_file.chr1,    #VARCHAR(1)
       g_argv1            LIKE type_file.chr20,   # 1.依料號 2.依工單 3.依訂單 4.依BOM 
       g_argv2            LIKE ima_file.ima01,    # 1.料號   2.工單   3.訂單   4.產品  
       g_query_flag       LIKE type_file.num5,    #第一次進入程式時即進入Query之後進入next 
       g_wc3,g_wc4        STRING,                 #WHERE CONDITION 
       g_sql              STRING,                 #WHERE CONDITION 
       g_line1,g_line2    LIKE type_file.num5,    #SMALLINT
       g_refresh          LIKE type_file.chr1,    #VARCHAR(1)
       g_chr              LIKE type_file.chr1,    #VARCHAR(1)
       g_cmd              LIKE type_file.chr1000, #VARCHAR(100)
       l_za05             LIKE za_file.za05,      #VARCHAR(40)
       g_rec_b            LIKE type_file.num5,     #單身筆數 
       g_rec_b1            LIKE type_file.num5,    #單身筆數
       g_rec_b2            LIKE type_file.num5,    #單身筆數
       l_ac               LIKE type_file.num5,     #目前處理的ARRAY CNT   
       l_ac1               LIKE type_file.num5,    #目前處理的ARRAY CNT   
       l_ac2               LIKE type_file.num5     #目前處理的ARRAY CNT    
DEFINE p_row,p_col        LIKE type_file.num5    #SMALLINT
DEFINE g_count            LIKE type_file.num5    #SMALLINT
DEFINE g_cnt              LIKE type_file.num10   #INTEGER
DEFINE g_unavl_stk        LIKE type_file.num15_3 
DEFINE g_avl_stk          LIKE type_file.num15_3 
DEFINE g_msg              LIKE type_file.chr1000 #VARCHAR(72)
DEFINE g_row_count        LIKE type_file.num10   #INTEGER
DEFINE g_curs_index       LIKE type_file.num10   #INTEGER
DEFINE g_jump             LIKE type_file.num10   #INTEGER
DEFINE g_no_ask          LIKE type_file.num5     #SMALLINT
DEFINE lc_qbe_sn          LIKE gbm_file.gbm01    
DEFINE g_plant_t          LIKE type_file.chr21                                                                                       
DEFINE g_flag             LIKE type_file.chr1   
DEFINE g_curs_index_t     LIKE type_file.num10  
DEFINE w ui.Window                        
DEFINE n om.DomNode                       
DEFINE f ui.Form                         
DEFINE page om.DomNode                   
DEFINE g_action_excel     STRING  
DEFINE g_imgs,g_imgs_t   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  imgs02  LIKE imgs_file.imgs02,
                  im02    LIKE imd_file.imd02,   
                  imgs03  LIKE imgs_file.imgs03,
                  im03    LIKE ime_file.ime03,  
                  imgs04  LIKE imgs_file.imgs04,
                  imgs06  LIKE imgs_file.imgs06,
                  imgs05  LIKE imgs_file.imgs05,
                  imgs09  LIKE imgs_file.imgs09,
                  imgs07  LIKE imgs_file.imgs07,
                  imgs08  LIKE imgs_file.imgs08,
                  imgs10  LIKE imgs_file.imgs10,
                  imgs11  LIKE imgs_file.imgs11                  
                END RECORD

FUNCTION aimq103(p_argv1,p_argv2)
   DEFINE p_argv1   LIKE type_file.chr1000, # 1.依料號 2.依工單 3.依訂單 4.依BOM 
          p_argv2   LIKE ima_file.ima01     # 1.料號   2.工單   3.訂單   4.產品  

   WHENEVER ERROR CONTINUE
 
   LET g_sw = p_argv1
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   LET g_query_flag = 1
   LET g_line1 = 3
   LET g_line2 = 4
   LET g_refresh = 'Y'                    #功能 'D.切換 Database'
 
   WHILE g_refresh = 'Y'
      LET g_refresh = 'N'                    
 
      LET p_row = 1 LET p_col = 6
      LET g_line1 = 1
      LET g_line2 = 2
 
      OPEN WINDOW q103_w WITH FORM "aim/42f/aimq103"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)       
      CALL cl_ui_init()      
      CALL q103_mu_ui() 
      IF NOT cl_null(g_argv1) THEN
         CALL q103_q()
      END IF 
      LET g_flag = 0 
      IF NOT cl_null(g_plant_t) THEN
         IF g_plant_t = g_plant THEN
            LET g_flag = 1
            CALL q103_q()
         END IF
      END IF 
      CALL q103_menu()
      DROP TABLE q103_tmp; 
      CLOSE WINDOW q103_w 
   END WHILE
 
END FUNCTION
 
#QBE 查詢資料
FUNCTION q103_cs()
   DEFINE l_cnt        LIKE type_file.num5  
 
   IF NOT cl_null(g_argv1) THEN
      CASE WHEN g_argv1='1' LET tm.wc = "ima01 = '",g_argv2,"'"
           WHEN g_argv1='2' LET tm.wc = "ima01 IN",
                                       " (SELECT sfa03 FROM sfa_file WHERE ",
                                       "  sfa01='",g_argv2,"')"
           WHEN g_argv1='3' LET tm.wc = "ima01 IN",
                                       " (SELECT oeb04 FROM oeb_file WHERE ",
                                       "  oeb01='",g_argv2,"')"
      END CASE
      LET tm.wc2=' 1=1'
   ELSE
      CLEAR FORM #清除畫面
      CALL g_img.clear()
      CALL g_imaa.clear() 
      CALL cl_opmsg('q')
      IF g_sw = 1 THEN             #1.依料號 
         INITIALIZE g_ima.* TO NULL  
         CALL g_imaa.clear()  
         CALL cl_set_head_visible("","YES")  
         IF g_flag = 0 THEN  
            DIALOG ATTRIBUTES(UNBUFFERED)
               CONSTRUCT tm.wc ON ima01,ima02,ima021 
                    FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021  
                  BEFORE CONSTRUCT
                     CALL cl_qbe_init()
   
                  ON ACTION CONTROLP
                     CASE
                        WHEN INFIELD(ima01)
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_ima"
                           LET g_qryparam.state = 'c'
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO ima01
                           NEXT FIELD ima01
                     END CASE
   
                  ON ACTION qbe_select
                     CALL cl_qbe_list() RETURNING lc_qbe_sn
                     CALL cl_qbe_display_condition(lc_qbe_sn)
   
               END CONSTRUCT
               CONSTRUCT tm.wc2 ON img02,img03,img04,img23,img10 FROM   
                     s_img[1].img02,s_img[1].img03,s_img[1].img04,s_img[1].img23,s_img[1].img10 
                  BEFORE CONSTRUCT
                     CALL cl_qbe_display_condition(lc_qbe_sn)
         
               END CONSTRUCT            
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE DIALOG   
          
               ON ACTION about         
                  CALL cl_about()    
          
               ON ACTION HELP        
                  CALL cl_show_help() 
          
               ON ACTION controlg    
                  CALL cl_cmdask()   
         
               ON ACTION qbe_save
                  CALL cl_qbe_save()
               ON ACTION accept
                  EXIT DIALOG 

               ON ACTION cancel
                  LET INT_FLAG=1 
                  EXIT DIALOG 
            END DIALOG
         END IF 
         IF INT_FLAG THEN RETURN END IF
      END IF
 
      IF g_sw = 2 THEN     #2.依工單 
         OPEN WINDOW q103_w2 AT 6,3 WITH FORM "aim/42f/aimq841_2"
              ATTRIBUTE (STYLE = g_win_style CLIPPED) 
         CALL cl_ui_locale("aimq841_2")
         WHILE TRUE
            CONSTRUCT BY NAME g_wc3 ON sfa01
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

            ON ACTION CONTROLP   
               IF INFIELD(sfa01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfa6"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfa01
                  NEXT FIELD sfa01
               END IF

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
            IF INT_FLAG THEN EXIT WHILE END IF
            IF g_wc3<>' 1=1' THEN EXIT WHILE END IF
         END WHILE
         CLOSE WINDOW q103_w2
         IF INT_FLAG THEN RETURN END IF
         LET tm.wc = "ima01 IN (SELECT sfa03 FROM sfa_file WHERE ",
                                       g_wc3 CLIPPED,")"
      END IF
      IF g_sw = 3 THEN       #3.依訂單 
         OPEN WINDOW q103_w3 AT 6,3 WITH FORM "aim/42f/aimq841_3"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)   
         CALL cl_ui_locale("aimq841_3")
         WHILE TRUE
            CONSTRUCT BY NAME g_wc3 ON oeb01
               BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
               ON ACTION CONTROLP   
                  IF INFIELD(oeb01) THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oeb01"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oeb01
                     NEXT FIELD oeb01
                  END IF
 
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
            IF INT_FLAG THEN EXIT WHILE END IF
            IF g_wc3<>' 1=1' THEN EXIT WHILE END IF
         END WHILE
         CLOSE WINDOW q103_w3
         IF INT_FLAG THEN RETURN END IF
         LET tm.wc = "ima01 IN (SELECT oeb04 FROM oeb_file WHERE ",
                                       g_wc3 CLIPPED,")"
      END IF
      IF g_sw = 4 THEN      #4.依BOM
         OPEN WINDOW q103_w4 AT 6,3 WITH FORM "aim/42f/aimq841_4"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)  
         CALL cl_ui_locale("aimq841_4")
         CONSTRUCT BY NAME g_wc3 ON bmb01
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about         
               CALL cl_about()   
 
            ON ACTION HELP        
               CALL cl_show_help()  
 
            ON ACTION controlg   
               CALL cl_cmdask()  
 
            ON ACTION CONTROLP    
               IF INFIELD(bmb01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima5"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmb01
                  NEXT FIELD bmb01
               END IF
 
                 ON ACTION qbe_select
                  CALL cl_qbe_select()
                 ON ACTION qbe_save
               CALL cl_qbe_save()
         END CONSTRUCT
         CLOSE WINDOW q103_w4
         IF INT_FLAG THEN RETURN END IF 
         LET tm.wc = "ima01 IN ",
                     " (SELECT bmb03 FROM bmb_file ",
                     "   WHERE ",g_wc3 CLIPPED,
                     "     AND bmb04 <= '",g_today,"'",
                     "     AND (bmb05 > '",g_today,"'",
                     "      OR bmb05 IS NULL ))"
      END IF
   END IF
END FUNCTION
 
FUNCTION q103_b_askkey()
 
   IF g_flag = 0 THEN 
      CONSTRUCT tm.wc2 ON img02,img03,img04,img23,img10 FROM   
            s_img[1].img02,s_img[1].img03,s_img[1].img04,s_img[1].img23,s_img[1].img10 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
                  
   
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about         
            CALL cl_about()    
    
         ON ACTION HELP        
            CALL cl_show_help() 
    
         ON ACTION controlg    
            CALL cl_cmdask()   
   
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
   END IF  
END FUNCTION
 
FUNCTION q103_menu()
   WHILE TRUE
      LET INT_FLAG=0   
      CASE 
         WHEN (g_action_excel IS NULL) OR (g_action_excel ='3')
            CALL q103_bp("G")
         WHEN (g_action_excel = '1') 
            CALL q103_bp2()
         WHEN (g_action_excel = '2') 
            CALL q103_bp3()   
      END CASE     
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query"
            LET g_sw = 1
            CALL q103_q()
#@         WHEN "依工單查"
         WHEN "query_by_w_o"
            LET g_sw = 2
            CALL q103_q()
#@         WHEN "依訂單查"
         WHEN "query_by_order"
            LET g_sw = 3
            CALL q103_q()
#@         WHEN "依BOM查"
         WHEN "query_by_bom"
            LET g_sw = 4
            CALL q103_q()
#@         WHEN "期間異動"
         WHEN "period_tran"
            IF cl_chk_act_auth() THEN
               CALL s_aimq102_q1(g_ima.ima01,'','','1') 
            END IF
#@         WHEN "最近採購"
         WHEN "latest_pur"
            IF cl_chk_act_auth() THEN
               CALL q103_q2()
            END IF
#@         WHEN "在途調撥"
         WHEN "transfer_in_transit"
            CALL q103_q5()
#@         WHEN "合格供應商"
         WHEN "approved_vender"
            LET g_msg='apmi254 "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "取替代"
         WHEN "rep_sub"
            LET g_msg='abmi604 "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "BOM用途"
         WHEN "bom_usage"
            IF cl_chk_act_auth() THEN
               CALL q103_q4()
            END IF
#@         WHEN "ECN"
         WHEN "ecn"
            IF cl_chk_act_auth() THEN
               CALL q103_q3()
            END IF
#@         WHEN "BIN卡"
         WHEN "bin_card"
            LET g_msg='aimq231 "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "供需明細"
         WHEN "demand_Supply"
            LET g_msg='aimq841 "1" "',g_ima.ima01,'"'
            CALL cl_cmdrun(g_msg)
#@         WHEN "細項查詢"
         WHEN "query_detail"
            CALL q103_d('0')
         WHEN "query_lot_data"  #查詢批/序號資料
            IF l_ac > 0 THEN
               CALL q103_q_imgs()
            END IF
         WHEN "Stocks_detail"
            IF cl_chk_act_auth() THEN
               IF g_ima.sie_q>0 THEN 
                  CALL q103_detail()
               ELSE
                  CALL cl_err('','aim-050',0)
               END IF
            END IF
         WHEN "du_detail"
            LET g_cmd = "aimq410 '",g_ima.ima01,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         WHEN "1"
            CALL q103_d('1')
         WHEN "2"
            CALL q103_d('2')
         WHEN "3"
            CALL q103_d('3')
         WHEN "4"
            CALL q103_d('4')
         WHEN "5"
            CALL q103_d('5')
         WHEN "6"
            CALL q103_d('6')
         WHEN "7"
            CALL q103_d('7')
         WHEN "8"
            CALL q103_d('8')
         WHEN "exporttoexcel" 
            LET w = ui.Window.getCurrent()
            LET f = w.getForm()
            IF cl_chk_act_auth() THEN
               IF g_action_excel = '1' THEN 
                  LET page = f.FindNode("Page","page1")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_img),'','')
               END IF 
               IF g_action_excel = '2' THEN 
                  LET page = f.FindNode("Page","page2")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imgs),'','')
               END IF
               IF g_action_excel = '3' THEN 
                  LET page = f.FindNode("Page","page3")
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imaa),'','')
               END IF
            END IF
       END CASE
    END WHILE
END FUNCTION
 
 
FUNCTION q103_F1()
   DEFINE p_key            LIKE ima_file.ima01 
   LET p_key=q103_F1_p()
 
    SELECT ima01, ima02, ima021, ima25, ima05, ima06,
           ima08, ima37, ima70,  ima15, ima906,img907,0,0
           INTO g_ima.*
           FROM ima_file WHERE ima01=p_key
   CALL q103_show()
END FUNCTION
 
FUNCTION q103_F1_p()
   DEFINE l_n,l_ac,l_sl    LIKE type_file.num5    
   DEFINE p_key            LIKE ima_file.ima01  
 
   IF cl_null(g_argv1) THEN
      CALL cl_init_qry_var()
      LET g_qryparam.form ="q_ima"
      LET g_qryparam.default1 = " "
      CALL cl_create_qry() RETURNING p_key
   END IF
   OPEN WINDOW q103_F1_w AT 3,2
     WITH FORM "aim/42f/aimq102f"  ATTRIBUTE (STYLE = g_win_style CLIPPED)  
 
   CALL cl_ui_locale("aimq102f")
 
   CALL SET_COUNT(1000)
 
   INPUT ARRAY m_ima WITHOUT DEFAULTS FROM s_ima.*
 
          BEFORE INPUT
             CALL fgl_set_arr_curr(l_ac)
 
          BEFORE ROW
             LET l_ac = ARR_CURR()
 
          ON ACTION accept
             LET l_ac = ARR_CURR()
             LET p_key=m_ima[l_ac].ima01
           EXIT INPUT
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
   CLOSE WINDOW q103_F1_w
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF
   RETURN p_key
END FUNCTION
 
FUNCTION q103_q()
 DEFINE l_null   LIKE type_file.chr1   
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q103_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q103()   
    LET g_action_excel = '3'
    MESSAGE ''
END FUNCTION

FUNCTION q103_table()
     DROP TABLE q103_tmp;
     CREATE TEMP TABLE q103_tmp(
                 ima01    LIKE ima_file.ima01, # 料件編號
                 ima02    LIKE ima_file.ima02, # 品名規格
                 ima021   LIKE ima_file.ima02, # 品名規格
                 ima05    LIKE ima_file.ima05, # 版本
                 ima06    LIKE ima_file.ima06, # 分群碼
                 ima25    LIKE ima_file.ima25, #
                 ima08    LIKE ima_file.ima08, # 來源碼
                 ima37    LIKE ima_file.ima37, #
                 ima70    LIKE ima_file.ima70, #
                 ima15    LIKE ima_file.ima15, #
                 ima906   LIKE ima_file.ima906, #單位管制方式  
                 ima907   LIKE ima_file.ima907, #第二單位       
                 avl_stk    LIKE type_file.num15_3, 
                 oeb_q      LIKE type_file.num15_3,
                 sfa_q1     LIKE type_file.num15_3, 
                 sfa_q2     LIKE type_file.num15_3, 
                 pml_q      LIKE type_file.num15_3, 
                 pmn_q      LIKE type_file.num15_3,
                 sfb_q1     LIKE type_file.num15_3, 
                 sfb_q2     LIKE type_file.num15_3,                 
                 rvb_q2     LIKE type_file.num15_3, 
                 rvb_q      LIKE type_file.num15_3, 
                 qcf_q      LIKE type_file.num15_3, 
                 atp_qty    LIKE type_file.num15_3,
                 unavl_stk  LIKE type_file.num15_3,
                 sie_q      LIKE type_file.num15_3);    
END FUNCTION

FUNCTION q103()
DEFINE l_sql         STRING
DEFINE lr_sfa        RECORD LIKE sfa_file.*
DEFINE g_short_qty   LIKE sfa_file.sfa07
DEFINE l_rvv17       LIKE rvv_file.rvv17 
DEFINE l_n1          LIKE type_file.num15_3 
DEFINE l_n2          LIKE type_file.num15_3 
DEFINE l_n3          LIKE type_file.num15_3
  
   DISPLAY TIME
   CALL q103_table()
   IF tm.wc2=' 1=1' OR tm.wc2 IS NULL THEN
      LET l_sql=" SELECT UNIQUE ima01, ima02, ima021, ima05, ima06,ima25,",
                "       ima08, ima37, ima70, ima15, ima906,ima907, ",
                "       0,0,0,0,0, 0,0,0,0,0,  0,0,0,0 ",
                "  FROM ima_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND imaacti='Y'"  
    ELSE
      LET l_sql=" SELECT UNIQUE ima01, ima02, ima021, ima05, ima06, ima25,",
                "       ima08, ima37, ima70, ima15, ima906,ima907, ",
                "       0,0,0,0,0, 0,0,0,0,0,  0,0,0,0 ",
                "  FROM ima_file,img_file ",
                " WHERE ima_file.ima01=img_file.img01 AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                "   AND img10<>0",        
                "   AND imaacti='Y' "     
   END IF 
   LET l_sql = " INSERT INTO q103_tmp ",l_sql CLIPPED
   PREPARE q103_ins FROM l_sql
   EXECUTE q103_ins


   LET l_sql = " MERGE INTO q103_tmp o",
               " USING(SELECT oeb04,SUM((oeb12-oeb24+oeb25-oeb26)*oeb05_fac) oeb_q ", 
               "          FROM oeb_file, oea_file ",
               "         WHERE oeb01 = oea01 AND oea00<>'0' ",
               "           AND oeb12-oeb24+oeb25-oeb26>0 AND oeb70 = 'N' ",  
               "           AND oeaconf = 'Y' GROUP BY oeb04 ) x ",
               "    ON(o.ima01 = x.oeb04 )",
               " WHEN MATCHED ",
               " THEN ",
               "   UPDATE ",
               "      SET o.oeb_q = x.oeb_q"
   PREPARE upd_oeb_q FROM l_sql
   EXECUTE upd_oeb_q               


   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT pml04,SUM((pml20-pml21)*pml09) pml_q ", 
              "         FROM pml_file, pmk_file ",
              "        WHERE pml01 = pmk01 AND pml20 > pml21",
              "          AND ( pml16 <='2' OR pml16='S' OR pml16='R' OR pml16='W')",
              "          AND pml011 !='SUB' AND pmk18 != 'X' GROUP BY pml04 ) x",
              "    ON(o.ima01 = x.pml04 ) ",  
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.pml_q = x.pml_q"
   PREPARE upd_pml_q FROM l_sql
   EXECUTE upd_pml_q   

   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT sig01,SUM(sig05) sie_q ", 
              "         FROM sig_file GROUP BY sig01 ) x",
              "    ON(o.ima01 = x.sig01 ) ",  
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.sie_q = x.sie_q"
   PREPARE upd_sie_q FROM l_sql
   EXECUTE upd_sie_q  

   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT pmn04,SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) pmn_q",    
              "         FROM pmn_file, pmm_file ",
              "        WHERE pmn01 = pmm01",
              "          AND pmn20 > pmn50-pmn55-pmn58 ",
              "          AND ( pmn16 <='2' OR pmn16='S' OR pmn16='R' OR pmn16='W') ",
              "          AND pmn011 !='SUB' ",
              "          AND pmm18 != 'X' GROUP BY pmn04 )x ",
              "    ON(o.ima01=x.pmn04) ",
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.pmn_q = x.pmn_q"
   PREPARE upd_pmn_q FROM l_sql
   EXECUTE upd_pmn_q               

   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT sfb05,SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac) sfb_q1",    
              "         FROM sfb_file,ima_file ",
              "        WHERE sfb05=ima01 AND sfb04 <'8'",
              "          AND ( sfb02 <>'7' AND sfb02 <>'8' AND sfb02 <>'11' AND sfb02 <> '15' ) ",
              "          AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87<>'X' GROUP BY sfb05 ) x",
              "    ON(o.ima01=x.sfb05) ",
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.sfb_q1 = x.sfb_q1 ",
              "                     - (SELECT NVL(SUM(shb114),0) FROM shb_file,sfb_file  ",
              "                         WHERE shb10=o.ima01 AND shb05 = sfb01 AND shb10 = sfb05 ",
              "                           AND sfb04 < '8' AND sfb87 <> 'X' ",
              "                           AND ( sfb02 <>'7' AND sfb02 <>'8' AND sfb02 <>'11' AND sfb02 <> '15' ))"
   PREPARE upd_sfb_q1 FROM l_sql
   EXECUTE upd_sfb_q1 

   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT sfb05,SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac) sfb_q2",    
              "         FROM sfb_file,ima_file ",
              "        WHERE ima01=sfb05 AND sfb04 <'8'",
              "          AND ( sfb02 ='7' OR sfb02 ='8') ",
              "          AND sfb08 > (sfb09+sfb10+sfb11+sfb12) AND sfb87!='X' GROUP BY sfb05 ) x",
              "    ON(o.ima01=x.sfb05) ",
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.sfb_q2 = x.sfb_q2 ",
              "                     - (SELECT NVL(SUM(shb114),0) FROM shb_file,sfb_file ",
              "                         WHERE shb10=o.ima01 AND shb05 = sfb01 AND shb10 = sfb05 ",
              "                           AND sfb04 < '8' AND sfb87 != 'X' ",
              "                           AND ( sfb02 ='7' AND sfb02 ='8'))"
   PREPARE upd_sfb_q2 FROM l_sql
   EXECUTE upd_sfb_q2   

   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT rvb05,SUM((rvb07-rvb29-rvb30)*pmn09) rvb_q2",    
              "         FROM rvb_file, rva_file, pmn_file ",
              "        WHERE rvb01=rva01 AND rvb04 = pmn01 AND rvb03 = pmn02",
              "          AND rvb07 > (rvb29+rvb30) AND rvaconf='Y'  ",
              "          AND rva10 ='SUB' AND pmn43 = 0 GROUP BY rvb05 ) x ",
              "    ON(o.ima01=x.rvb05) ",
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.rvb_q2 = x.rvb_q2"
   PREPARE upd_rvb_q2 FROM l_sql
   EXECUTE upd_rvb_q2  

   UPDATE q103_tmp SET sfb_q2 = sfb_q2 + rvb_q2

   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT rvb05,SUM((rvb07-rvb29-rvb30)*pmn09) rvb_q ",
              "         FROM rvb_file, rva_file, pmn_file",
              "        WHERE rvb01=rva01",
              "          AND rvb04 = pmn01 AND rvb03 = pmn02",
              "          AND rvb07 > (rvb29+rvb30) ",
              "          AND rvaconf='Y'",
              "          AND rva10 != 'SUB' GROUP BY rvb05 ) x",  
              "    ON(o.ima01=x.rvb05) ",
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.rvb_q = x.rvb_q"
   PREPARE upd_rvb_q FROM l_sql
   EXECUTE upd_rvb_q            
   
   LET l_sql= " MERGE INTO q103_tmp o",
              " USING(SELECT sfb05,SUM(sfb11*ima55_fac) qcf_q ",
              "         FROM sfb_file,ima_file ",
              "        WHERE ima01=sfb05 AND sfb02 <> '7' AND sfb87!='X' AND sfb02 <> '8' ",
              "          AND sfb02 <> '11' AND sfb04 <'8' GROUP BY sfb05) x",  
              "    ON(o.ima01=x.sfb05) ",
              " WHEN MATCHED ",
              " THEN ",
              "   UPDATE ",
              "      SET o.qcf_q = x.qcf_q"
   PREPARE upd_qcf_q FROM l_sql
   EXECUTE upd_qcf_q       



    LET l_sql = "SELECT sfa_file.*",
                "  FROM sfb_file,sfa_file",
                " WHERE sfa03 = ? ",
                "   AND sfb01 = sfa01",
                "   AND sfb04 !='8'",
                "   AND sfb87!='X'",
                "   AND sfb02 != '15'"
   PREPARE q103_sum_pre FROM l_sql
   DECLARE q103_sum CURSOR FOR q103_sum_pre


   LET g_cnt = 1
   LET l_sql = "SELECT * FROM q103_tmp ORDER BY ima01"
   PREPARE q103_pr FROM l_sql
   DECLARE q103_cur CURSOR FOR q103_pr
   FOREACH q103_cur INTO g_imaa[g_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF  
      #CALL s_getstock(g_ima.ima01,g_plant) RETURNING  l_n1,l_n2,l_n3   #MOD-D70081 mark
      CALL s_getstock(g_imaa[g_cnt].ima01,g_plant) RETURNING  l_n1,l_n2,l_n3   #MOD-D70081
      LET g_imaa[g_cnt].unavl_stk = l_n2                                 
      LET g_imaa[g_cnt].avl_stk = l_n3
      
      FOREACH q103_sum USING g_imaa[g_cnt].ima01 INTO lr_sfa.* 
         CALL s_shortqty(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                            lr_sfa.sfa12,lr_sfa.sfa27,
                         lr_sfa.sfa012,lr_sfa.sfa013)  
              RETURNING g_short_qty 
         IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
         IF (lr_sfa.sfa05 > (lr_sfa.sfa06+ g_short_qty- lr_sfa.sfa063+ lr_sfa.sfa065 -lr_sfa.sfa062)) OR (g_short_qty > 0) THEN  
            LET l_rvv17 = 0        
            SELECT SUM(rvv17) INTO l_rvv17 FROM rvv_file WHERE rvv18=lr_sfa.sfa01 AND rvv31=lr_sfa.sfa03 
            IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF   
            LET g_imaa[g_cnt].sfa_q1= g_imaa[g_cnt].sfa_q1 + ((lr_sfa.sfa05-lr_sfa.sfa06-lr_sfa.sfa065+lr_sfa.sfa063-lr_sfa.sfa062+l_rvv17)*lr_sfa.sfa13) 
            LET g_imaa[g_cnt].sfa_q2= g_imaa[g_cnt].sfa_q2 + (g_short_qty * lr_sfa.sfa13)
         END IF            
      END FOREACH  
      #MOD-D70081 begin-------------
#      LET g_ima.atp_qty=g_avl_stk - g_ima.oeb_q - g_ima.sfa_q1  
#                         + g_ima.pml_q + g_ima.pmn_q + g_ima.rvb_q
#                                  + g_ima.sfb_q1+ g_ima.sfb_q2+ g_ima.qcf_q 
       LET g_imaa[g_cnt].atp_qty=g_imaa[g_cnt].avl_stk - g_imaa[g_cnt].oeb_q - g_imaa[g_cnt].sfa_q1  
                                 + g_imaa[g_cnt].pml_q + g_imaa[g_cnt].pmn_q + g_imaa[g_cnt].rvb_q
                                 + g_imaa[g_cnt].sfb_q1+ g_imaa[g_cnt].sfb_q2+ g_imaa[g_cnt].qcf_q
      #MOD-D70081 end----------------
      LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
      END IF
   END FOREACH
   CALL g_imaa.deleteElement(g_cnt)  
   LET g_rec_b2 = (g_cnt-1)
   DISPLAY g_rec_b2 TO cnt
   DISPLAY TIME 
END FUNCTION
 
FUNCTION q103_show()
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!','!' TO ima70,ima15
   END IF
   CALL q103_b_fill()
   MESSAGE ''
    CALL cl_show_fld_cont()                 
END FUNCTION
 
FUNCTION q103_b_fill()              #BODY FILL UP
   DEFINE l_sql          LIKE type_file.chr1000  
 
   IF tm.wc2 IS NULL OR tm.wc2=' ' THEN LET tm.wc2=" 1=1" END IF
   LET l_sql =
        "SELECT img02,'',img03,'',img04,img23,img10,'',img09,img38",  
        " FROM  img_file",
        " WHERE img01 = '",g_ima.ima01,"'",
        "   AND img10<>0",
        "   AND ",tm.wc2,  
        " ORDER BY img02,img03,img04"
    PREPARE q103_pb FROM l_sql
    DECLARE q103_bcs CURSOR FOR q103_pb
 
    CALL g_img.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q103_bcs INTO g_img[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT imd02 INTO g_img[g_cnt].imd02 FROM imd_file WHERE imd01=g_img[g_cnt].img02
       SELECT ime03 INTO g_img[g_cnt].ime03 FROM ime_file WHERE ime01=g_img[g_cnt].img02
                                                             AND ime02=g_img[g_cnt].img03
       SELECT sig05 INTO g_img[g_cnt].sig05 FROM sig_file
         WHERE sig01 = g_ima.ima01 AND sig02 = g_img[g_cnt].img02
               AND sig04 = g_img[g_cnt].img04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_img.deleteElement(g_cnt)    
    LET g_rec_b=(g_cnt-1)

    LET g_sql = " SELECT imgs02,'',imgs03,'',imgs04,imgs06,imgs05,imgs09,imgs07,imgs08,imgs10,imgs11",
                "  FROM imgs_file ",
                "  WHERE imgs01 = '",g_ima.ima01,"' ",
                "  ORDER BY imgs02,imgs03,imgs04 "
    PREPARE sel_imgs_pre FROM g_sql
    DECLARE imgs_curs CURSOR FOR sel_imgs_pre

    CALL g_imgs.clear()

    LET g_rec_b1=0
    LET g_cnt = 1
    FOREACH imgs_curs INTO g_imgs[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT imd02 INTO g_imgs[g_cnt].im02 FROM imd_file WHERE imd01=g_imgs[g_cnt].imgs02
        SELECT ime03 INTO g_imgs[g_cnt].im03 FROM ime_file WHERE ime01=g_imgs[g_cnt].imgs02
                                                             AND ime02=g_imgs[g_cnt].imgs03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_imgs.deleteElement(g_cnt)
    LET g_rec_b1=(g_cnt-1)       
END FUNCTION
 
 
FUNCTION q103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
   LET g_action_excel ='3'  
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_rec_b2 TO cnt
    DIALOG ATTRIBUTES(UNBUFFERED) 
       DISPLAY ARRAY g_imaa TO s_ima.* ATTRIBUTE(COUNT=g_rec_b2)            
          BEFORE DISPLAY
            #當使用雙單位時,才顯示"多單位庫存明細查詢"這個ACTION
             IF g_sma.sma115 = 'N' THEN
                CALL cl_set_act_visible("du_detail",FALSE)
             ELSE
                CALL cl_set_act_visible("du_detail",TRUE)
             END IF
             CALL cl_navigator_setting( g_curs_index, g_row_count )
             CALL fgl_set_arr_curr(g_curs_index)

          BEFORE ROW                             
             LET l_ac2 = ARR_CURR() 
             LET g_curs_index = l_ac2
             CALL cl_show_fld_cont()               
      END DISPLAY     
      
      ON ACTION page1
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL fgl_set_arr_curr(g_curs_index) 
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
            CALL q103_show()         
         END IF
         LET g_action_excel = '1'
         EXIT DIALOG

      ON ACTION page2
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL fgl_set_arr_curr(g_curs_index)  
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
            CALL q103_show()         
         END IF      
         LET g_action_excel = '2'
         EXIT DIALOG
                      
      ON ACTION help
         LET g_action_choice="help"
         
         EXIT DIALOG   
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         CALL q103_mu_ui() 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
#@      ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG  
#@      ON ACTION 依工單查詢
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
         EXIT DIALOG  
#@      ON ACTION 依訂單查詢
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         EXIT DIALOG 
#@      ON ACTION 依BOM查詢
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         EXIT DIALOG   
#@      ON ACTION 期間異動
      ON ACTION period_tran
         LET g_action_choice="period_tran"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
#@      ON ACTION 最近採購
      ON ACTION latest_pur
         LET g_action_choice="latest_pur"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
#@      ON ACTION 在途調撥
      ON ACTION transfer_in_transit
         LET g_action_choice="transfer_in_transit"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG  
#@      ON ACTION 合格供應商
      ON ACTION approved_vender
         LET g_action_choice="approved_vender"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
#@      ON ACTION 取替代
      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
#@      ON ACTION BOM用途
      ON ACTION bom_usage
         LET g_action_choice="bom_usage"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG
#@      ON ACTION ECN
      ON ACTION ecn
         LET g_action_choice="ecn"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
#@      ON ACTION BIN卡
      ON ACTION bin_card
         LET g_action_choice="bin_card"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG  
#@      ON ACTION 供需明細
      ON ACTION demand_Supply
         LET g_action_choice="demand_Supply"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG  
      ON ACTION Stocks_detail
         LET g_action_choice="Stocks_detail"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG
#@      ON ACTION 細項查詢
      ON ACTION query_detail
         LET g_action_choice="query_detail"
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
#@    ON ACTION 多單位庫存明細查詢
      ON ACTION du_detail
         LET g_action_choice = 'du_detail'
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
      ON ACTION query_lot_data  #查詢批/序號資料
         LET g_action_choice = 'query_lot_data'
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01 = g_imaa[l_ac2].ima01
         END IF
         EXIT DIALOG 
      ON ACTION accept
         IF g_action_excel = '3' AND l_ac2<>0 THEN 
            LET l_ac2 = ARR_CURR()
            LET g_ima.ima01=g_imaa[l_ac2].ima01 
            CALL q103_show() 
         END IF
         LET g_action_excel = '1' 
         DISPLAY g_rec_b TO FORMONLY.cnt
         EXIT DIALOG 
 
      ON ACTION cancel
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"
         EXIT DIALOG 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  
 
      ON ACTION about   
         CALL cl_about() 

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

   END DIALOG    
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q103_bp2() 
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
   LET g_action_excel ='1'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_rec_b TO cnt
    DIALOG ATTRIBUTES(UNBUFFERED)     
       DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b)            
          BEFORE DISPLAY
            #當使用雙單位時,才顯示"多單位庫存明細查詢"這個ACTION
             IF g_sma.sma115 = 'N' THEN
                CALL cl_set_act_visible("du_detail",FALSE)
             ELSE
                CALL cl_set_act_visible("du_detail",TRUE)
             END IF
             CALL cl_navigator_setting( g_curs_index, g_row_count )

          BEFORE ROW                              
              LET l_ac = ARR_CURR() 
              CALL cl_show_fld_cont()                 

         AFTER DISPLAY        
           CONTINUE DIALOG    
      END DISPLAY                      

      ON ACTION page2
         LET g_action_excel = '2'
         EXIT DIALOG
         
      ON ACTION page3
         LET g_action_excel = '3'
         EXIT DIALOG            

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG  
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()            
         CALL q103_mu_ui()  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG    
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG    
 
#@      ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG    
#@      ON ACTION 依工單查詢
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
        EXIT DIALOG    
#@      ON ACTION 依訂單查詢
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         EXIT DIALOG    
#@      ON ACTION 依BOM查詢
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         EXIT DIALOG   
#@      ON ACTION 期間異動
      ON ACTION period_tran
         LET g_action_choice="period_tran"
         EXIT DIALOG    
#@      ON ACTION 最近採購
      ON ACTION latest_pur
         LET g_action_choice="latest_pur"
         EXIT DIALOG   
#@      ON ACTION 在途調撥
      ON ACTION transfer_in_transit
         LET g_action_choice="transfer_in_transit"
         EXIT DIALOG 
#@      ON ACTION 合格供應商
      ON ACTION approved_vender
         LET g_action_choice="approved_vender"
         EXIT DIALOG    
#@      ON ACTION 取替代
      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
         EXIT DIALOG   
#@      ON ACTION BOM用途
      ON ACTION bom_usage
         LET g_action_choice="bom_usage"
         EXIT DIALOG    
#@      ON ACTION ECN
      ON ACTION ecn
         LET g_action_choice="ecn"
         EXIT DIALOG  
#@      ON ACTION BIN卡
      ON ACTION bin_card
         LET g_action_choice="bin_card"
         EXIT DIALOG    
#@      ON ACTION 供需明細
      ON ACTION demand_Supply
         LET g_action_choice="demand_Supply"
         EXIT DIALOG    

      ON ACTION Stocks_detail
         LET g_action_choice="Stocks_detail"
         EXIT DIALOG  

#@      ON ACTION 細項查詢
      ON ACTION query_detail
         LET g_action_choice="query_detail"
         EXIT DIALOG   
#@    ON ACTION 多單位庫存明細查詢
      ON ACTION du_detail
         LET g_action_choice = 'du_detail'
         EXIT DIALOG   
      ON ACTION query_lot_data  #查詢批/序號資料
         LET g_action_choice = 'query_lot_data'
         EXIT DIALOG   
      ON ACTION accept
         LET g_action_excel = '1' 
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page2,page3", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page2,page3", TRUE) 
         DISPLAY g_rec_b TO FORMONLY.cnt
         CONTINUE DIALOG 
 
      ON ACTION cancel
         LET INT_FLAG=FALSE            
         LET g_action_choice="exit"
         EXIT DIALOG    
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG    
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG   
 
      ON ACTION about         
         CALL cl_about()    
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

   END DIALOG   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q103_bp3() 
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
   LET g_action_excel ='2'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY g_rec_b1 TO cnt
    DIALOG ATTRIBUTES(UNBUFFERED)     
       DISPLAY ARRAY g_imgs TO s_imgs.* ATTRIBUTE(COUNT=g_rec_b1)            

          BEFORE DISPLAY
            #當使用雙單位時,才顯示"多單位庫存明細查詢"這個ACTION
             IF g_sma.sma115 = 'N' THEN
                CALL cl_set_act_visible("du_detail",FALSE)
             ELSE
                CALL cl_set_act_visible("du_detail",TRUE)
             END IF
             CALL cl_navigator_setting( g_curs_index, g_row_count )

          BEFORE ROW                      
              LET l_ac1 = ARR_CURR() 
              CALL cl_show_fld_cont()                

         AFTER DISPLAY      
           CONTINUE DIALOG  
      END DISPLAY             

      ON ACTION page1
         LET g_action_excel = '1'
         EXIT DIALOG
         
      ON ACTION page3
         LET g_action_excel = '3'
         EXIT DIALOG            

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG  
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()            
         CALL q103_mu_ui()  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG    
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG    
 
#@      ON ACTION 查詢
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG    
#@      ON ACTION 依工單查詢
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
        EXIT DIALOG    
#@      ON ACTION 依訂單查詢
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         EXIT DIALOG    
#@      ON ACTION 依BOM查詢
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         EXIT DIALOG   
#@      ON ACTION 期間異動
      ON ACTION period_tran
         LET g_action_choice="period_tran"
         EXIT DIALOG    
#@      ON ACTION 最近採購
      ON ACTION latest_pur
         LET g_action_choice="latest_pur"
         EXIT DIALOG   
#@      ON ACTION 在途調撥
      ON ACTION transfer_in_transit
         LET g_action_choice="transfer_in_transit"
         EXIT DIALOG 
#@      ON ACTION 合格供應商
      ON ACTION approved_vender
         LET g_action_choice="approved_vender"
         EXIT DIALOG    
#@      ON ACTION 取替代
      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
         EXIT DIALOG   
#@      ON ACTION BOM用途
      ON ACTION bom_usage
         LET g_action_choice="bom_usage"
         EXIT DIALOG    
#@      ON ACTION ECN
      ON ACTION ecn
         LET g_action_choice="ecn"
         EXIT DIALOG  
#@      ON ACTION BIN卡
      ON ACTION bin_card
         LET g_action_choice="bin_card"
         EXIT DIALOG    
#@      ON ACTION 供需明細
      ON ACTION demand_Supply
         LET g_action_choice="demand_Supply"
         EXIT DIALOG    

      ON ACTION Stocks_detail
         LET g_action_choice="Stocks_detail"
         EXIT DIALOG  

#@      ON ACTION 細項查詢
      ON ACTION query_detail
         LET g_action_choice="query_detail"
         EXIT DIALOG   
#@    ON ACTION 多單位庫存明細查詢
      ON ACTION du_detail
         LET g_action_choice = 'du_detail'
         EXIT DIALOG   
      ON ACTION query_lot_data  #查詢批/序號資料
         LET g_action_choice = 'query_lot_data'
         EXIT DIALOG   
      ON ACTION accept
         LET g_action_excel = '1' 
         CALL cl_set_comp_visible("page2,page3", FALSE)
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page2,page3", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page2,page3", TRUE) 
         DISPLAY g_rec_b TO FORMONLY.cnt
         CONTINUE DIALOG 
 
      ON ACTION cancel
         LET INT_FLAG=FALSE            
         LET g_action_choice="exit"
         EXIT DIALOG    
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG    
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG   
 
      ON ACTION about         
         CALL cl_about()    
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

   END DIALOG   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q103_d(d_no)
   DEFINE d_no      LIKE type_file.chr1    
   DEFINE t_no      LIKE type_file.chr1    
   DEFINE l_cmd      LIKE type_file.chr1000
 
   LET t_no = d_no
   WHILE TRUE
     IF d_no = '0' THEN
        OPEN WINDOW aimq103_w2 AT 5,15
           WITH FORM "aim/42f/aimq1021"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("aimq1021")
 
        INPUT BY NAME d_no
           AFTER FIELD d_no
               IF d_no IS NULL OR d_no NOT MATCHES '[0123456789]' THEN
                  NEXT FIELD d_no
               END IF
           AFTER INPUT
             IF INT_FLAG THEN EXIT INPUT END IF
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
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
     END IF
     IF d_no IS NULL OR d_no = ' ' THEN LET d_no ='0' END IF
     CASE WHEN d_no ='1' LET l_cmd='aimq131 "',g_ima.ima01,'"'        
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
          WHEN d_no ='2' LET l_cmd='aimq138 "',g_ima.ima01,'"'                 
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
          WHEN d_no ='3' LET l_cmd='aimq140 "',g_ima.ima01,'"'        
                         CALL cl_cmdrun(l_cmd) EXIT WHILE             
          WHEN d_no ='4' LET l_cmd='aimq134 "',g_ima.ima01,'"'        
                         CALL cl_cmdrun(l_cmd) EXIT WHILE             
          WHEN d_no ='5' LET l_cmd='aimq136 "',g_ima.ima01,'"'        
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
          WHEN d_no ='6' LET l_cmd='aimq137 "',g_ima.ima01,'"'        
                         CALL cl_cmdrun(l_cmd) EXIT WHILE
          WHEN d_no ='7' LET l_cmd='aimq132 "',g_ima.ima01,'"'        
                         CALL cl_cmdrun(l_cmd) EXIT WHILE            
          WHEN d_no ='0' EXIT WHILE
          OTHERWISE LET d_no ='0'
     END CASE
   END WHILE
   if t_no ='0' then CLOSE WINDOW aimq103_w2 end iF
END FUNCTION

FUNCTION q103_detail()
  DEFINE tm RECORD
         a               LIKE type_file.chr1   
         END RECORD
DEFINE  l_cmd           LIKE type_file.chr1000  

  OPEN WINDOW q103_detail_w WITH FORM "aim/42f/aimq102a"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("aimq102a")
  LET tm.a='1' 
   DISPLAY BY NAME tm.a 
 
   INPUT BY NAME tm.a WITHOUT DEFAULTS
      AFTER FIELD a
            IF tm.a NOT MATCHES '[1234]' THEN 
               NEXT FIELD a
            END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW q103_detail_w
      RETURN
   END IF
   
   CLOSE WINDOW q103_detail_w
   CASE tm.a
      WHEN '1'
        LET l_cmd = "asfq610"," '1' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd) 
      WHEN '2'
        LET l_cmd = "axmq611"," '2' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
      WHEN '3'
        LET l_cmd = "aimq611"," '3' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
      WHEN '4'
        LET l_cmd = "asfq612"," '4' "," '",g_ima.ima01,"'"
        CALL cl_cmdrun(l_cmd)
   END CASE
END FUNCTION

FUNCTION q103_q2()
   DEFINE sr      RECORD
               pmm04      LIKE pmm_file.pmm04,
               pmm01      LIKE pmm_file.pmm01,
               pmc03      LIKE pmc_file.pmc03,
               pmm22      LIKE pmm_file.pmm22,
               pmn20      LIKE pmn_file.pmn20,
               pmn07      LIKE pmn_file.pmn07,
                pmn86   LIKE pmn_file.pmn86,  
               pmn31      LIKE pmn_file.pmn31,
               pmn33      LIKE pmn_file.pmn33,
               pmm20      LIKE pmm_file.pmm20
               END RECORD
 
   LET p_row = 6 LET p_col = 2
   OPEN WINDOW q103_q2_w AT p_row,p_col
     WITH FORM "aim/42f/aimq1022"  ATTRIBUTE (STYLE = g_win_style CLIPPED)  
 
   CALL cl_ui_locale("aimq1022")
   IF g_sma.sma116 MATCHES '[02]' THEN   
      CALL cl_set_comp_visible("pmn86",FALSE)
   END IF
 
   DECLARE q103_q2_c CURSOR FOR SELECT pmm04,pmm01,pmc03,pmm22,pmn20,pmn07,pmn86, 
                                       pmn31,pmn33,pmm20
                                  FROM pmm_file, pmn_file, OUTER pmc_file
                                 WHERE pmn04 = g_ima.ima01
                                   AND pmn01 = pmm01
                                   AND pmm09 = pmc01
                                   AND pmm18 != 'X'
                                 ORDER BY pmm04 DESC
 
   CALL g_bbb2.clear()
   LET g_cnt=1
 
   FOREACH q103_q2_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb2[g_cnt].pmm04 = sr.pmm04
      LET g_bbb2[g_cnt].pmm01 = sr.pmm01
      LET g_bbb2[g_cnt].pmc03 = sr.pmc03
      LET g_bbb2[g_cnt].pmm22 = sr.pmm22
      LET g_bbb2[g_cnt].pmn20 = sr.pmn20 USING '--------&'
      LET g_bbb2[g_cnt].pmn07 = sr.pmn07
      LET g_bbb2[g_cnt].pmn86 = sr.pmn86                 
      LET g_bbb2[g_cnt].pmn31 = sr.pmn31    
      LET g_bbb2[g_cnt].pmn33 = sr.pmn33
      LET g_bbb2[g_cnt].pmm20 = sr.pmm20[1,6]
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb2 TO s_bbb2.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
   CLOSE WINDOW q103_q2_w
 
END FUNCTION
 
FUNCTION q103_q3()
   DEFINE sr      RECORD
               bmx07      LIKE bmx_file.bmx07,
               bmx01      LIKE bmx_file.bmx01,
               bmz03      LIKE bmz_file.bmz03,
                bmz02   LIKE bmz_file.bmz02,  
                bmg03   LIKE bmg_file.bmg03, 
               bmy03      LIKE bmy_file.bmy03,
               bmy19      LIKE bmy_file.bmy19,
               bmy06      LIKE bmy_file.bmy06
               END RECORD
   DEFINE l_sql LIKE type_file.chr1000  
 
   LET p_row = 6 LET p_col = 2
   OPEN WINDOW q103_q3_w AT p_row,p_col
     WITH FORM "aim/42f/aimq1023"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aimq1023")
 
   LET l_sql="SELECT bmx07,bmx01,bmz03,bmz02,bmg03,bmy03,bmy19,bmy06 ",
             "  FROM bmx_file,bmy_file,bmz_file, bmg_file ",
             " WHERE bmy05='",g_ima.ima01 ,"'",
             "   AND bmy01=bmx01 AND bmx04 <> 'X' ",
             "   AND bmy01=bmg01 AND bmg02=1 ",
             "   AND bmx01=bmz01 ",
             "   AND bmx06='1' ",
             " UNION ",
             "SELECT bmx07,bmx01,bmy17,bmy14,bmg03,bmy03,bmy19,bmy06",
             "  FROM bmx_file,bmy_file,  bmg_file ",
             " WHERE bmy05='",g_ima.ima01 ,"'",
             "   AND bmy01=bmx01 AND bmx04 <> 'X' ",
             "   AND bmy01=bmg01 AND bmg02=1 ",
             "   AND bmx06='2' ",
             " ORDER BY 1 DESC "
   PREPARE q103_q3_prepare FROM l_sql
   DECLARE q103_q3_c CURSOR FOR q103_q3_prepare
 
   CALL g_bbb3.clear()
   LET g_cnt=1
 
   FOREACH q103_q3_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb3[g_cnt].bmx07 = sr.bmx07
      LET g_bbb3[g_cnt].bmx01 = sr.bmx01
      LET g_bbb3[g_cnt].bmz03 = sr.bmz03
      LET g_bbb3[g_cnt].bmz02 = sr.bmz02
      LET g_bbb3[g_cnt].bmg03 = sr.bmg03
      LET g_bbb3[g_cnt].bmy03 = sr.bmy03
      LET g_bbb3[g_cnt].bmy19 = sr.bmy19
      LET g_bbb3[g_cnt].bmy06 = sr.bmy06 USING '---&'
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb3 TO s_bbb3.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY     
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY     
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE                                                                            
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
   CLOSE WINDOW q103_q3_w                    
 
END FUNCTION
 
FUNCTION q103_q4()
   DEFINE sr      RECORD
               bmb01      LIKE bmb_file.bmb01,
               ima02      LIKE ima_file.ima02,  
               ima021     LIKE ima_file.ima021,
               bmb02      LIKE bmb_file.bmb02,
               bmb04      LIKE bmb_file.bmb04,
               bmb05      LIKE bmb_file.bmb05,
               bmb16      LIKE bmb_file.bmb16,
               bmb06      LIKE bmb_file.bmb06,
               bmb08      LIKE bmb_file.bmb08
               END RECORD
 
   LET p_row = 6 LET p_col = 2
    OPEN WINDOW q103_q4_w AT p_row,p_col  
     WITH FORM "aim/42f/aimq1024"  ATTRIBUTE (STYLE = g_win_style CLIPPED)  
 
   CALL cl_ui_locale("aimq1024")
 
   DECLARE q103_q4_c CURSOR FOR SELECT bmb01,'','',bmb02,bmb04,bmb05,bmb16,bmb06/bmb07,bmb08
                                  FROM bmb_file
                                 WHERE bmb03=g_ima.ima01
                                 ORDER BY bmb01,bmb02,bmb04
 
   CALL g_bbb4.clear()
   LET g_cnt=1
 
   FOREACH q103_q4_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb4[g_cnt].bmb01 = sr.bmb01
      LET g_bbb4[g_cnt].bmb02 = sr.bmb02 USING '###&'
      LET g_bbb4[g_cnt].bmb04 = sr.bmb04
      LET g_bbb4[g_cnt].bmb05 = sr.bmb05
      LET g_bbb4[g_cnt].bmb16 = sr.bmb16
      LET g_bbb4[g_cnt].bmb06 = sr.bmb06 USING '#####&.######'
      LET g_bbb4[g_cnt].bmb08 = sr.bmb08
      SELECT ima02,ima021 INTO g_bbb4[g_cnt].ima02,g_bbb4[g_cnt].ima021
        FROM ima_file WHERE ima01 = g_bbb4[g_cnt].bmb01
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb4 TO s_bbb4.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           

            ON ACTION CONTROLP    
               IF INFIELD(bmb01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima5"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bmb01
               END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
 
   CLOSE WINDOW q103_q4_w
 
END FUNCTION
 
FUNCTION q103_q5()
   DEFINE sr      RECORD
               imm01      LIKE imm_file.imm01,
               imm02      LIKE imm_file.imm02,
               imn04      LIKE imn_file.imn04,
               imn05      LIKE imn_file.imn05,
               imn06      LIKE imn_file.imn06,
               imn15      LIKE imn_file.imn15,
               imn16      LIKE imn_file.imn16,
               imn17      LIKE imn_file.imn17,
               imn10      LIKE imn_file.imn10,
               imn09      LIKE imn_file.imn09
               END RECORD
 
   LET p_row = 6 LET p_col = 2
   OPEN WINDOW q103_q5_w AT p_row,p_col
     WITH FORM "aim/42f/aimq1025"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aimq1025")
 
   DECLARE q103_q5_c CURSOR FOR
      SELECT imm01,imm02,imn04,imn05,imn06,
             imn15,imn16,imn17,imn10,imn09
        FROM imm_file, imn_file
       WHERE imn03=g_ima.ima01
         AND imn01=imm01 AND imm03='N'
         AND immconf!='X'   
       ORDER BY imm01,imm02
 
   CALL g_bbb5.clear()
   LET g_cnt=1
 
   FOREACH q103_q5_c INTO sr.*
      IF STATUS THEN
         CALL cl_err('for:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_bbb5[g_cnt].imm01 = sr.imm01
      LET g_bbb5[g_cnt].imm02 = sr.imm02
      LET g_bbb5[g_cnt].imn04 = sr.imn04
      LET g_bbb5[g_cnt].imn05 = sr.imn04
      LET g_bbb5[g_cnt].imn06 = sr.imn04
      LET g_bbb5[g_cnt].imn15 = sr.imn15
      LET g_bbb5[g_cnt].imn16 = sr.imn15
      LET g_bbb5[g_cnt].imn17 = sr.imn15
      LET g_bbb5[g_cnt].imn10 = sr.imn10 USING '#######&'
      LET g_bbb5[g_cnt].imn09 = sr.imn09[1,4]
 
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_bbb5 TO s_bbb5.*
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
      CALL cl_show_fld_cont() 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   AFTER DISPLAY 
     CONTINUE DISPLAY 
   END DISPLAY 
 
   CLOSE WINDOW q103_q5_w
 
END FUNCTION
 
FUNCTION q103_mu_ui()
   CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
END FUNCTION
 
 
FUNCTION q103_q_imgs()
   DEFINE l_imgs01  LIKE imgs_file.imgs01
   DEFINE l_imgs02  LIKE imgs_file.imgs02
   DEFINE l_imgs03  LIKE imgs_file.imgs03
   DEFINE l_imgs04  LIKE imgs_file.imgs04
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE g_imgs DYNAMIC ARRAY OF RECORD
                    imgs05   LIKE imgs_file.imgs05,
                    imgs06   LIKE imgs_file.imgs06,
                    imgs07   LIKE imgs_file.imgs07,
                    imgs08   LIKE imgs_file.imgs08,
                    imgs09   LIKE imgs_file.imgs09,
                    imgs10   LIKE imgs_file.imgs10,
                    imgs11   LIKE imgs_file.imgs11,
                    att01    LIKE inj_file.inj04,
                    att02    LIKE inj_file.inj04,
                    att03    LIKE inj_file.inj04,
                    att04    LIKE inj_file.inj04,
                    att05    LIKE inj_file.inj04,
                    att06    LIKE inj_file.inj04,
                    att07    LIKE inj_file.inj04,
                    att08    LIKE inj_file.inj04,
                    att09    LIKE inj_file.inj04,
                    att10    LIKE inj_file.inj04
                 END RECORD
   DEFINE g_inj03 DYNAMIC ARRAY OF RECORD
                    inj03      LIKE inj_file.inj03,
                    ini02      LIKE ini_file.ini02
                  END RECORD
  DEFINE li_i, li_j            LIKE type_file.num5
  DEFINE lc_index                     STRING
  DEFINE ls_show,ls_hide              STRING
  DEFINE l_inj04               LIKE inj_file.inj04
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = g_ima.ima01
   
   IF cl_null(l_ima918) THEN
      LET l_ima918="N"
   END IF
 
   IF cl_null(l_ima921) THEN
      LET l_ima921="N"
   END IF
 
   IF l_ima918 <> "Y" AND l_ima921 <> "Y" THEN
      RETURN
   END IF
 
   LET p_row = 6 LET p_col = 2
 
   OPEN WINDOW q103_q_imgs_w AT p_row,p_col WITH FORM "aim/42f/aimq1026"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aimq1026")
 
   DISPLAY g_ima.ima01,g_img[l_ac].img02,g_img[l_ac].img03,g_img[l_ac].img04 
        TO imgs01,imgs02,imgs03,imgs04 
 
   DECLARE q103_q_imgs_c CURSOR FOR SELECT imgs05,imgs06,imgs07,imgs08,
                                           imgs09,imgs10,imgs11
                                           ,'','','','',''
                                           ,'','','','',''
                                      FROM imgs_file
                                     WHERE imgs01 = g_ima.ima01
                                       AND imgs02 = g_img[l_ac].img02
                                       AND imgs03 = g_img[l_ac].img03
                                       AND imgs04 = g_img[l_ac].img04
                                       AND imgs08 > 0
                                     ORDER BY imgs05,imgs06 
   CALL g_imgs.clear()
   LET g_cnt=1
 
   DECLARE inj_curs  CURSOR FOR 
                  SELECT DISTINCT inj03,'' FROM inj_file
                   WHERE inj01 = g_ima.ima01
   #依料件特性資料動態顯示隱藏欄位名稱及內容
   LET ls_hide = ' '
   LET ls_show = ' '
   LET li_i    = 1
   FOREACH inj_curs INTO g_inj03[li_i].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF       

      SELECT ini02 INTO g_inj03[li_i].ini02 FROM ini_file     
       WHERE ini01 = g_inj03[li_i].inj03
      LET lc_index = li_i USING '&&'
      CALL cl_set_comp_att_text("att" || lc_index,g_inj03[li_i].ini02)
      IF li_i = 1 THEN
         LET  ls_show = ls_show || "att" || lc_index
      ELSE
         LET  ls_show = ls_show || ",att" || lc_index
      END IF
      LET li_i = li_i + 1
   END FOREACH 
   CALL g_inj03.deleteElement(li_i)
   LET li_i = li_i - 1
   FOR li_j = li_i TO 10
       LET lc_index = li_j USING '&&'
       IF li_j = li_i THEN
          LET ls_hide = ls_hide || "att" || lc_index
       ELSE
          LET ls_hide = ls_hide || ",att" || lc_index
       END IF
   END FOR      
   CALL cl_set_comp_visible(ls_hide,FALSE)
   CALL cl_set_comp_visible(ls_show,TRUE)

   FOREACH q103_q_imgs_c INTO g_imgs[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach imgs:',STATUS,1)
         EXIT FOREACH
      END IF

      FOR li_j = 1 TO li_i
          LET l_inj04 = NULL
          SELECT inj04 INTO l_inj04 FROM inj_file
           WHERE inj01 = g_ima.ima01
             AND inj02 = g_imgs[g_cnt].imgs06
             AND inj03 = g_inj03[li_j].inj03

            CASE li_j
               WHEN 1
                  LET g_imgs[g_cnt].att01 = l_inj04
               WHEN 2
                  LET g_imgs[g_cnt].att02 = l_inj04
               WHEN 3
                  LET g_imgs[g_cnt].att03 = l_inj04
               WHEN 4
                  LET g_imgs[g_cnt].att04 = l_inj04
               WHEN 5
                  LET g_imgs[g_cnt].att05 = l_inj04
               WHEN 6
                  LET g_imgs[g_cnt].att06 = l_inj04
               WHEN 7
                  LET g_imgs[g_cnt].att07 = l_inj04
               WHEN 8
                  LET g_imgs[g_cnt].att08 = l_inj04
               WHEN 9
                  LET g_imgs[g_cnt].att09 = l_inj04
               WHEN 10
                  LET g_imgs[g_cnt].att10 = l_inj04
            END CASE
         END FOR
      LET g_cnt=g_cnt+1
   END FOREACH
 
   DISPLAY ARRAY g_imgs TO s_imgs.*
 
      BEFORE ROW                                                                                                                    
         LET l_ac = ARR_CURR()                                                                                                      
         CALL cl_show_fld_cont() 
 
      ON ACTION detail                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = 1                                                                                                               
         CONTINUE DISPLAY      
 
      ON ACTION accept                                                                                                              
         LET g_action_choice="detail"                                                                                               
         LET l_ac = ARR_CURR()                                                                                                      
         CONTINUE DISPLAY    
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG=FALSE  
         LET g_action_choice="exit"                                                                                                 
         EXIT DISPLAY           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      AFTER DISPLAY 
         CONTINUE DISPLAY 
 
   END DISPLAY 
 
   CLOSE WINDOW q103_q_imgs_w
 
END FUNCTION
#No.FUN-D20019 
 
