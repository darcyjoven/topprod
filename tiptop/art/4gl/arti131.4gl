# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Pattern name..:"arti131.4gl"
#Descriptions..:採購協議維護作業
#Date & Author..:FUN-870007 08/07/24 By Zhangyajun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-960130 09/11/17 By bnlent where条件补齐
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach add oriu/orig 
# Modify.........: No:FUN-A50102 10/07/14 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No:FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No:TQC-A90069 10/10/09 By lilingyu 重新過單
# Modify.........: No:FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No:FUN-AB0021 10/11/04 By chenying 料號開窗控管
# Modify.........: No:FUN-AB0101 10/11/26 By vealxu 料號檢查部份邏輯修改：如果對應營運中心有設產品策略，則抓產品策略的料號
# Modify.........: No:TQC-AB0216 10/11/29 By shenyang GP5.2 SOP流程修改
# Modify.........: No:TQC-AC0008 10/12/01 By Carrier 同一产品+同一供应商若采购协议生效期间重叠,需管控
# Modify.........: No:TQC-AC0104 10/12/13 By huangtao 
# Modify.........: No:TQC-AC0134 10/12/29 By huangtao 添加單身料號的管控
# Modify.........: No:TQC-B20029 11/02/11 By huangtao 查詢時供應商未帶出
# Modify.........: No:FUN-B40031 11/04/20 By shiwuying 增加协议生效、截止日期
# Modify.........: No:TQC-B50048 11/05/11 By destiny AFTER FIELD 栏位错误，导致无法新增
# Modify.........: No:TQC-B50146 11/05/25 By shiwuying 查询sql错误
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60008 11/06/13 By lixia 修改產品分類管控
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.TQC-B80035 11/07/05 By zhangll 单身若无资料，单头更新单号时将不成功
# Modify.........: No.TQC-B80045 11/08/03 By zhangll 單頭合同號增加控管
# Modify.........: No.FUN-B90092 11/09/15 By pauline 單身新增開窗時可以多選
# Modify.........: No.FUN-B90094 11/09/21 By pauline 修改錯誤訊息內容
# Modify.........: No.FUN-B90123 11/09/23 By pauline 多筆新增時有效default為Y,當無產品策略時,開窗是產品過濾合約條件
# Modify.........: No.FUN-BC0010 12/01/16 By pauline 當經營方是為經銷/成本代銷單身未稅單價/含稅單價不可為null,扣率代銷/聯營單身扣率不可為null
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20197 12/02/23 by fanbj 單身新增，料號應符合採購合約中限定的產品分類和品牌
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/17 By bart 複製後停在新資料畫面
# Modify.........: No.FUN-C90046 12/09/11 By xumeimei 隐藏rtt07,rtt08,rtt09,rtt12,rtt13栏位
# Modify.........: No.CHI-C80041 13/02/06 By bart 無單身刪除單頭
# Modify.........: No:FUN-D30033 13/04/09 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rts    RECORD LIKE rts_file.*,   #TQC-A90069 
        g_rts_t  RECORD LIKE rts_file.*,
        g_rtt   DYNAMIC ARRAY OF RECORD 
                rtt03   LIKE rtt_file.rtt03,
                rtt04   LIKE rtt_file.rtt04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                ima1004 LIKE ima_file.ima1004,
                tqa02a  LIKE tqa_file.tqa02,
                ima1005 LIKE ima_file.ima1005,
                tqa02b  LIKE tqa_file.tqa02,
                ima1009 LIKE ima_file.ima1009,
                tqa02c  LIKE tqa_file.tqa02,
                ima1007 LIKE ima_file.ima1007,
                tqa02d  LIKE tqa_file.tqa02,
                rtt05   LIKE rtt_file.rtt05,
                rtt05_desc LIKE pmc_file.pmc03,
                rtt14   LIKE rtt_file.rtt14,
                rtt14_desc LIKE pmc_file.pmc03,
                rtt06   LIKE rtt_file.rtt06,
                rtt06t  LIKE rtt_file.rtt06t,
                rtt07   LIKE rtt_file.rtt07,
                rtt08   LIKE rtt_file.rtt08,
                rtt09   LIKE rtt_file.rtt09,
                rtt10   LIKE rtt_file.rtt06,
                rtt11   LIKE rtt_file.rtt07,
                rtt12   LIKE rtt_file.rtt08,
                rtt13   LIKE rtt_file.rtt09,               
                rtt15   LIKE rtt_file.rtt15
                        END RECORD,
        g_rtt_t RECORD
                rtt03   LIKE rtt_file.rtt03,
                rtt04   LIKE rtt_file.rtt04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                ima1004 LIKE ima_file.ima1004,
                tqa02a  LIKE tqa_file.tqa02,
                ima1005 LIKE ima_file.ima1005,
                tqa02b  LIKE tqa_file.tqa02,
                ima1009 LIKE ima_file.ima1009,
                tqa02c  LIKE tqa_file.tqa02,
                ima1007 LIKE ima_file.ima1007,
                tqa02d  LIKE tqa_file.tqa02,
                rtt05   LIKE rtt_file.rtt05,
                rtt05_desc LIKE pmc_file.pmc03,
                rtt14   LIKE rtt_file.rtt14,
                rtt14_desc LIKE pmc_file.pmc03,
                rtt06   LIKE rtt_file.rtt06,
                rtt06t  LIKE rtt_file.rtt06t,
                rtt07   LIKE rtt_file.rtt07,
                rtt08   LIKE rtt_file.rtt08,
                rtt09   LIKE rtt_file.rtt09,
                rtt10   LIKE rtt_file.rtt06,
                rtt11   LIKE rtt_file.rtt07,
                rtt12   LIKE rtt_file.rtt08,
                rtt13   LIKE rtt_file.rtt09,
                rtt15   LIKE rtt_file.rtt15
                        END RECORD,
        g_rtt_o RECORD
                rtt03   LIKE rtt_file.rtt03,
                rtt04   LIKE rtt_file.rtt04,
                ima02   LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
                ima1004 LIKE ima_file.ima1004,
                tqa02a  LIKE tqa_file.tqa02,
                ima1005 LIKE ima_file.ima1005,
                tqa02b  LIKE tqa_file.tqa02,
                ima1009 LIKE ima_file.ima1009,
                tqa02c  LIKE tqa_file.tqa02,
                ima1007 LIKE ima_file.ima1007,
                tqa02d  LIKE tqa_file.tqa02,
                rtt05   LIKE rtt_file.rtt05,
                rtt05_desc LIKE pmc_file.pmc03,
                rtt14   LIKE rtt_file.rtt14,
                rtt14_desc LIKE pmc_file.pmc03,
                rtt06   LIKE rtt_file.rtt06,
                rtt06t  LIKE rtt_file.rtt06t,
                rtt07   LIKE rtt_file.rtt07,
                rtt08   LIKE rtt_file.rtt08,
                rtt09   LIKE rtt_file.rtt09,
                rtt10   LIKE rtt_file.rtt06,
                rtt11   LIKE rtt_file.rtt07,
                rtt12   LIKE rtt_file.rtt08,
                rtt13   LIKE rtt_file.rtt09,
                rtt15   LIKE rtt_file.rtt15
                        END RECORD
 
DEFINE  g_sql   STRING,
        g_wc    STRING,
        g_wc2   STRING,
        g_rec_b LIKE type_file.num5,
        l_ac    LIKE type_file.num5
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1
DEFINE  g_cnt                LIKE type_file.num10
DEFINE  g_msg                LIKE ze_file.ze03
DEFINE  g_row_count          LIKE type_file.num10
DEFINE  g_curs_index         LIKE type_file.num10
DEFINE  g_jump               LIKE type_file.num10
DEFINE  mi_no_ask            LIKE type_file.num5
DEFINE  l_table   STRING
DEFINE  g_rto     RECORD LIKE rto_file.*
DEFINE  g_t1       LIKE oay_file.oayslip   #自動編號
DEFINE  g_gec07    LIKE gec_file.gec07     
DEFINE  g_pmc47    LIKE pmc_file.pmc47
DEFINE  g_rtz04    LIKE rtz_file.rtz04  #商品策略
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
       
    LET g_forupd_sql="SELECT * FROM rts_file WHERE rts01=? AND rts02=? AND rts03=? AND rtsplant=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i131_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i131_w AT p_row,p_col WITH FORM "art/42f/arti131"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    #FUN-C90046--------add----str
    CALL cl_set_comp_visible("rtt07",FALSE)
    CALL cl_set_comp_visible("rtt08",FALSE)
    CALL cl_set_comp_visible("rtt09",FALSE)
    CALL cl_set_comp_visible("rtt12",FALSE)
    CALL cl_set_comp_visible("rtt13",FALSE)
    #FUN-C90046--------add----end 
    CALL cl_ui_init()
   
    SELECT rtz04 INTO g_rtz04 FROM rtz_file
     WHERE rtz01 = g_plant
    CALL i131_menu()
    
    CLOSE WINDOW i131_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i131_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtt TO s_rtt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i131_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i131_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i131_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i131_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL i131_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#        LET g_action_choice="output"
#         EXIT DISPLAY
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
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
  
END FUNCTION
 
FUNCTION i131_menu()
 
   WHILE TRUE
      CALL i131_bp("G")
      CASE g_action_choice
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                  CALL i131_y()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i131_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i131_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL i131_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL i131_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL i131_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL i131_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL i131_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL i131_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rtt),'','')
             END IF      
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rts.rts01 IS NOT NULL THEN
                    LET g_doc.column1 = "rts01"
                    LET g_doc.column1 = "rts02"
                    LET g_doc.column1 = "rts03"
                    LET g_doc.value1 = g_rts.rts01
                    LET g_doc.value1 = g_rts.rts02
                    LET g_doc.value1 = g_rts.rts03
                    CALL cl_doc()
                 END IF
              END IF  
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL i131_v()
               CALL i131_show()
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i131_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
       
    CONSTRUCT BY NAME g_wc ON                               
      # rts01,rts02,rts03,rts04,rts06,rts07,rtsplant,          #TQC-AC0104 mark
        rts01,rts02,rts03,rts04,rts06,rto06,rts07,rtsplant,    #TQC-AC0104
        rts08,rts09,                                           #FUN-B40031
      # rtsmksg,rts900,rtsconf,rtscond,rtsconu,rts05,          #TQC-AB0216
        rtsconf,rtscond,rtsconu,rts05,                         #TQC-AB0216 
        rtsuser,rtsgrup,rtsmodu,rtsdate,rtsacti,rtscrat
       ,rtsoriu,rtsorig                                        #TQC-A30041 ADD
             
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(rts01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rts01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rts01
                 NEXT FIELD rts01
              WHEN INFIELD(rts02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rts02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rts02
                 NEXT FIELD rts02
              WHEN INFIELD(rts04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rts04"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rts04
                 NEXT FIELD rts04
              WHEN INFIELD(rts06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rts06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rts06
                 NEXT FIELD rts06
              WHEN INFIELD(rtsconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtsconu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtsconu
                 NEXT FIELD rtsconu
              WHEN INFIELD(rtsplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtsplant
                 NEXT FIELD rtsplant
              OTHERWISE
                 EXIT CASE
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
           CALL cl_qbe_list() RETURNING lc_qbe_sn
           CALL cl_qbe_display_condition(lc_qbe_sn)          
		
    END CONSTRUCT
    IF INT_FLAG THEN 
        RETURN
    END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rtsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc CLIPPED," AND rtsgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN              
    #        LET g_wc = g_wc clipped," AND rtsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtsuser', 'rtsgrup')
    #End:FUN-980030
   
    CONSTRUCT g_wc2 ON rtt03,rtt04,rtt05,rtt14,rtt06,rtt06t,rtt07,rtt08,rtt09,
                       rtt10,rtt11,rtt12,rtt13,rtt15
                   FROM s_rtt[1].rtt03,s_rtt[1].rtt04,s_rtt[1].rtt05,s_rtt[1].rtt14,
                        s_rtt[1].rtt06,s_rtt[1].rtt06t,s_rtt[1].rtt07,s_rtt[1].rtt08,
                        s_rtt[1].rtt09,s_rtt[1].rtt10,s_rtt[1].rtt11,s_rtt[1].rtt12,
                        s_rtt[1].rtt13,s_rtt[1].rtt15
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
           CASE
              WHEN INFIELD(rtt04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtt041"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtt04
                 NEXT FIELD rtt04
             WHEN INFIELD(rtt05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtt05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtt05
                 NEXT FIELD rtt05
             WHEN INFIELD(rtt14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rtt14"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rtt14
                 NEXT FIELD rtt14
              OTHERWISE
                 EXIT CASE
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
 
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
		
    END CONSTRUCT
    
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    LET g_wc2 = g_wc2 CLIPPED
#TQC-B50146 Begin---
#   IF  g_wc2 = " 1=1" THEN      
##TQC-AC0104 -------------------STA 
##       LET g_sql = "SELECT rts01,rts02,rts03,rtsplant FROM rts_file ", 
##                   " WHERE ",g_wc CLIPPED," AND rtsplant IN ",g_auth,
##                   " ORDER BY rts01,rts02"
#        LET g_sql = "SELECT rts01,rts02,rts03,rtsplant FROM rts_file LEFT OUTER JOIN rto_file ",
#                    " ON rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant ",
#                    " WHERE ",g_wc CLIPPED," AND rtsplant IN ",g_auth,
#                    " ORDER BY rts01,rts02"
##TQC-AC0104 -------------------END
#   ELSE
##TQC-AC0104 -------------------STA
##      LET g_sql = "SELECT UNIQUE rts01,rts02,rts03,rtsplant",
##                  "  FROM rts_file,rtt_file",
##                  " WHERE rts01=rtt01 AND rts02=rtt02",
##                  "   AND rtsplant=rttplant",
##                  "   AND rtsplant IN ",g_auth,
##                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
##                  " ORDER BY rts01,rts02"
#       LET g_sql = "SELECT UNIQUE rts01,rts02,rts03,rtsplant",
#                   "  FROM rts_file LEFT OUTER JOIN rto_file ",
#                   " ON rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant,rtt_file ",
#                   " WHERE rts01=rtt01 AND rts02=rtt02",
#                   "   AND rtsplant=rttplant",
#                   "   AND rtsplant IN ",g_auth,
#                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
#                   " ORDER BY rts01,rts02"
##TQC-AC0104 -------------------END
#   END IF
#   
#   PREPARE i131_prepare FROM g_sql
#   DECLARE i131_cs SCROLL CURSOR WITH HOLD FOR i131_prepare
#   IF g_wc2=" 1=1" THEN
##TQC-AC0104 -------------------STA
##       LET g_sql="SELECT COUNT(*) FROM rts_file WHERE rtsplant IN ",g_auth," AND ",g_wc CLIPPED
#        LET g_sql="SELECT COUNT(*) FROM rts_file  LEFT OUTER JOIN rto_file ",
#                  " ON rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant ",
#                  " WHERE rtsplant IN ",g_auth," AND ",g_wc CLIPPED
##TQC-AC0104 -------------------END
#   ELSE
##TQC-AC0104 -------------------STA
##      LET g_sql="SELECT COUNT(*) FROM rts_file,rtt_file",
##                " WHERE rts01=rtt01 AND rts02=rtt02 ",
##                "   AND rtsplant=rttplant ",
##                "   AND rtsplant IN ",g_auth,
##                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
#       LET g_sql="SELECT COUNT(*) FROM rts_file LEFT OUTER JOIN rto_file ",
#                 " ON rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant,rtt_file ",
#                 " WHERE rts01=rtt01 AND rts02=rtt02 ",
#                 "   AND rtsplant=rttplant ",
#                 "   AND rtsplant IN ",g_auth,
#                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
##TQC-AC0104 -------------------END
#   END IF 
    IF g_wc.getIndexOf("rto",1) > 0 THEN
       IF g_wc2 = " 1=1" THEN      
          LET g_sql = "SELECT rts01,rts02,rts03,rtsplant FROM rts_file,rto_file ",
                      " WHERE rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant ",
                      "   AND rto02 IN (SELECT MAX(rto02) FROM rto_file a WHERE rts04 = a.rto01 AND rts02 = a.rto03 AND rtsplant = a.rtoplant)",
                      "   AND ",g_wc CLIPPED," AND rtsplant IN ",g_auth,
                      " ORDER BY rts01,rts02"
       ELSE
          LET g_sql = "SELECT UNIQUE rts01,rts02,rts03,rtsplant",
                      "  FROM rts_file,rto_file,rtt_file ",
                      " WHERE rts01=rtt01 AND rts02=rtt02",
                      "   AND rtsplant=rttplant",
                      "   AND rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant ",
                      "   AND rto02 IN (SELECT MAX(rto02) FROM rto_file a WHERE rts04 = a.rto01 AND rts02 = a.rto03 AND rtsplant = a.rtoplant)",
                      "   AND rtsplant IN ",g_auth,
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY rts01,rts02"
       END IF
    ELSE
       IF g_wc2=" 1=1" THEN
          LET g_sql = "SELECT rts01,rts02,rts03,rtsplant FROM rts_file ",
                      " WHERE ",g_wc CLIPPED," AND rtsplant IN ",g_auth,
                      " ORDER BY rts01,rts02"
       ELSE
          LET g_sql = "SELECT UNIQUE rts01,rts02,rts03,rtsplant",
                      "  FROM rts_file,rtt_file ",
                      " WHERE rts01=rtt01 AND rts02=rtt02",
                      "   AND rtsplant=rttplant",
                      "   AND rtsplant IN ",g_auth,
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY rts01,rts02"
       END IF
    END IF
    PREPARE i131_prepare FROM g_sql
    DECLARE i131_cs SCROLL CURSOR WITH HOLD FOR i131_prepare
    IF g_wc.getIndexOf("rto",1) > 0 THEN
       IF g_wc2=" 1=1" THEN
          LET g_sql="SELECT COUNT(*) FROM rts_file,rto_file ",
                    " WHERE rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant ",
                    "   AND rto02 IN (SELECT MAX(rto02) FROM rto_file a WHERE rts04 = a.rto01 AND rts02 = a.rto03 AND rtsplant = a.rtoplant)",
                    "   AND rtsplant IN ",g_auth," AND ",g_wc CLIPPED
       ELSE
          LET g_sql="SELECT COUNT(*) FROM rts_file,rto_file,rtt_file ",
                    " WHERE rts04 = rto01 AND rts02 = rto03 AND rtsplant = rtoplant ",
                    "   AND rto02 IN (SELECT MAX(rto02) FROM rto_file a WHERE rts04 = a.rto01 AND rts02 = a.rto03 AND rtsplant = a.rtoplant)",
                    "   AND rts01=rtt01 AND rts02=rtt02 ",
                    "   AND rtsplant=rttplant ",
                    "   AND rtsplant IN ",g_auth,
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       END IF
    ELSE
       IF g_wc2=" 1=1" THEN
          LET g_sql="SELECT COUNT(*) FROM rts_file ",
                    " WHERE rtsplant IN ",g_auth," AND ",g_wc CLIPPED
       ELSE
          LET g_sql="SELECT COUNT(*) FROM rts_file,rtt_file ",
                    " WHERE rts01=rtt01 AND rts02=rtt02 ",
                    "   AND rtsplant=rttplant ",
                    "   AND rtsplant IN ",g_auth,
                    "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
       END IF
    END IF
#TQC-B50146 End-----
    PREPARE i131_precount FROM g_sql
    DECLARE i131_count CURSOR FOR i131_precount
END FUNCTION
 
FUNCTION i131_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rtt.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL i131_cs()              
            
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rts.* TO NULL
        CALL g_rtt.clear()
        RETURN
    END IF
    
    OPEN i131_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        CALL g_rtt.clear()
    ELSE
        OPEN i131_count
        FETCH i131_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt     
           CALL i131_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
        END IF             
    END IF
END FUNCTION
 
FUNCTION i131_fetch(p_flrts)
DEFINE p_flrts         LIKE type_file.chr1           
    CASE p_flrts
        WHEN 'N' FETCH NEXT     i131_cs INTO g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
        WHEN 'P' FETCH PREVIOUS i131_cs INTO g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
        WHEN 'F' FETCH FIRST    i131_cs INTO g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
        WHEN 'L' FETCH LAST     i131_cs INTO g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
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
                   LET g_jump = g_curs_index
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i131_cs INTO g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rts.rts01,SQLCA.sqlcode,0)
        INITIALIZE g_rts.* TO NULL  
        RETURN
    ELSE
      CASE p_flrts
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rts.* FROM rts_file    
     WHERE rts01 = g_rts.rts01 AND rts02 = g_rts.rts02
       AND rts03 = g_rts.rts03 AND rtsplant = g_rts.rtsplant
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rts_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rts.rtsuser           
        LET g_data_group=g_rts.rtsgrup
        LET g_data_plant=g_rts.rtsplant  #TQC-A10128 ADD
        CALL i131_show()                   
    END IF
END FUNCTION
 
FUNCTION i131_rts02(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_azp02    LIKE azp_file.azp02
          
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02
     FROM azp_file 
    WHERE azp01 = g_rts.rts02
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                                 LET l_azp02=NULL 
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.rts02_desc
  END IF
 
END FUNCTION
 
FUNCTION i131_rts04(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1
DEFINE l_rto05_desc LIKE pmc_file.pmc03
 
    SELECT rto_file.* INTO g_rto.*
      FROM rto_file
     WHERE rto01 = g_rts.rts04 AND rto03 = g_rts.rts02
       AND rto02 = (SELECT MAX(rto02) FROM rto_file 
                     WHERE rto01 = g_rts.rts04 
                       AND rtoplant = g_rts.rtsplant                       #TQC-B20029 add
                       AND rto03 = g_rts.rts02)
       AND rtoplant = g_rts.rtsplant
    CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='atm-123' 
                                 INITIALIZE g_rto.* TO NULL
        WHEN g_rto.rtoacti='N'   LET g_errno='9028'    
        WHEN g_rto.rtoconf<>'Y'  LET g_errno='art-195'
        WHEN g_rto.rto03<>g_rts.rts02 LET g_errno='art-163'
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
    END CASE
   #FUN-B40031 Begin---
    IF cl_null(g_errno) AND p_cmd='a' THEN
       LET g_rts.rts08=g_rto.rto08
       LET g_rts.rts09=''
    END IF
   #FUN-B40031 End-----
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY g_rto.rto05 TO FORMONLY.rto05
       SELECT pmc03,pmc47 INTO l_rto05_desc,g_pmc47
         FROM pmc_file 
        WHERE pmc01 = g_rto.rto05 AND pmcacti='Y'
       DISPLAY l_rto05_desc TO FORMONLY.rto05_desc   
       DISPLAY g_rto.rto06 TO FORMONLY.rto06
       DISPLAY g_rto.rto08 TO FORMONLY.rto08
       DISPLAY g_rto.rto09 TO FORMONLY.rto09
       DISPLAY g_rto.rto10 TO FORMONLY.rto10
       DISPLAY g_rto.rto11 TO FORMONLY.rto11
    END IF
     
END FUNCTION
 
FUNCTION i131_rts06(p_cmd)  #稅別
    DEFINE  l_gec04   LIKE gec_file.gec04,
            l_gecacti LIKE gec_file.gecacti,
            p_cmd     LIKE type_file.chr1    
	
    LET g_errno = " "
    SELECT gec04,gecacti,gec07 
      INTO l_gec04,l_gecacti,g_gec07
      FROM gec_file
     WHERE gec01 = g_rts.rts06 AND gec011='1'  #進項
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                   LET l_gec04 = 0
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_gec07) THEN
       LET g_gec07 = 'N'
    END IF
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_rts.rts07 = l_gec04
       DISPLAY BY NAME g_rts.rts07
       DISPLAY g_gec07 TO FORMONLY.gec07
    END IF
END FUNCTION
 
FUNCTION i131_rtsplant(p_cmd)         
DEFINE    l_azp02    LIKE azp_file.azp02,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02 
     FROM azp_file
    WHERE azp01 = g_rts.rtsplant
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                                 LET l_azp02=NULL 
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.rtsplant_desc
  END IF
 
END FUNCTION
 
FUNCTION i131_rtsconu(p_cmd)         
DEFINE    l_genacti  LIKE gen_file.genacti, 
          l_gen02    LIKE gen_file.gen02,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_rts.rtsconu
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-075' 
                                 LET l_gen02=NULL 
        WHEN l_genacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.rtsconu_desc
  END IF
 
END FUNCTION
 
FUNCTION i131_rtt04(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_ima RECORD LIKE ima_file.*
DEFINE l_rtdconf LIKE rtd_file.rtdconf
DEFINE l_rte04 LIKE rte_file.rte04
DEFINE l_rte07 LIKE rte_file.rte07
DEFINE l_n LIKE type_file.num5                          #TQC-AC0134 
   #TQC-C20197--start add-------------------------------------------
   DEFINE l_rtq06   LIKE rtq_file.rtq06              
   DEFINE l_rtq06_1 LIKE rtq_file.rtq06             
   DEFINE l_n1      LIKE type_file.num5
   DEFINE l_flag    LIKE type_file.chr1
   #TQC-C20197--end add---------------------------------------------   

     LET g_errno=''
      SELECT DISTINCT ima_file.*
        INTO l_ima.*
        FROM ima_file
       WHERE ima01 = g_rtt[l_ac].rtt04 
     CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-030' 
                                 INITIALIZE l_ima.* TO NULL
        WHEN l_ima.imaacti='N'   LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
     END CASE   
     
   # IF cl_null(g_errno) THEN                            #FUN-AB0101 mark
     IF cl_null(g_errno) AND NOT cl_null(g_rtz04) THEN   #FUN-AB0101 
        SELECT rtdconf,rte04,rte07 
          INTO l_rtdconf,l_rte04,l_rte07
          FROM rtd_file,rte_file
         WHERE rtd01=rte01
           AND rtd01=g_rtz04
           AND rte03=g_rtt[l_ac].rtt04
        CASE 
           WHEN SQLCA.sqlcode=100 LET g_errno='art-054'
           WHEN l_rtdconf<>'Y'    LET g_errno='art-170'
           WHEN l_rte04='N'       LET g_errno='art-523'
           WHEN l_rte07='N'       LET g_errno='9028'
           OTHERWISE
               LET g_errno=SQLCA.sqlcode USING '------'
        END CASE
     END IF
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        LET g_rtt[l_ac].ima02   = l_ima.ima02
        LET g_rtt[l_ac].ima021  = l_ima.ima021
        LET g_rtt[l_ac].ima1004 = l_ima.ima1004
        LET g_rtt[l_ac].ima1005 = l_ima.ima1005
        LET g_rtt[l_ac].ima1007 = l_ima.ima1007
        LET g_rtt[l_ac].ima1009 = l_ima.ima1009
#TQC-AC0134 ------------STA
        #TQC-C20197--start mark----------------------------------
       # SELECT COUNT(*) INTO l_n FROM rtq_file
       #  WHERE rtq01 = g_rts.rts04
       #    AND rtq03 = g_rts.rts02
       #    #AND rtq06 IN (l_ima.ima1004,l_ima.ima1005)
       #    AND rtq06 IN (l_ima.ima131,l_ima.ima1005)  #TQC-B60008
        #TQC-C20197--end mark------------------------------------- 

       #TQC-C20197--start add------------------------------------- 
       SELECT rtq06 INTO l_rtq06 
         FROM rtq_file
        WHERE rtq01 = g_rts.rts04
          AND rtq03 = g_rts.rts02
          AND rtq05 = '1'
          AND rtqplant = g_plant

       SELECT rtq06 INTO l_rtq06_1
         FROM rtq_file
        WHERE rtq01 = g_rts.rts04
          AND rtq03 = g_rts.rts02
          AND rtq05 = '2'
          AND rtqplant = g_plant     

       CASE 
          WHEN NOT cl_null(l_rtq06) AND NOT cl_null(l_rtq06_1)
             IF cl_null(l_ima.ima131) OR cl_null(l_ima.ima1005) THEN
                LET l_flag = '1' 
             ELSE
                SELECT COUNT(*) INTO l_n
                  FROM rtq_file
                 WHERE rtq01 = g_rts.rts04
                   AND rtq03 = g_rts.rts02
                   AND rtq05 = '1'
                   AND rtq06 = l_ima.ima131
                    
                SELECT COUNT(*) INTO l_n1
                  FROM rtq_file
                 WHERE rtq01 = g_rts.rts04
                   AND rtq03 = g_rts.rts02
                   AND rtq05 = '2'
                   AND rtq06 = l_ima.ima1005
                IF l_n = 0 OR l_n1 = 0 THEN
                   LET l_flag = '1' 
                END IF 
             END IF 
          WHEN NOT cl_null(l_rtq06) AND cl_null(l_rtq06_1)
             IF cl_null(l_ima.ima131) THEN
                LET l_flag = '1'
             ELSE
                SELECT COUNT(*) INTO l_n1
                  FROM rtq_file
                 WHERE rtq01 = g_rts.rts04
                   AND rtq03 = g_rts.rts02
                   AND rtq05 = '1'
                   AND rtq06 = l_ima.ima131
                IF l_n1 = 0 THEN
                   LET l_flag = '1'
                END IF 
             END IF  
          WHEN cl_null(l_rtq06) AND NOT cl_null(l_rtq06_1) 
             IF cl_null(l_ima.ima1005) THEN
                LET l_flag = '1'
             ELSE
                SELECT COUNT(*) INTO l_n1
                  FROM rtq_file
                 WHERE rtq01 = g_rts.rts04
                   AND rtq03 = g_rts.rts02
                   AND rtq05 = '2'
                   AND rtq06 = l_ima.ima1005           
                IF l_n1 = 0 THEN
                   LET l_flag = '1'
                END IF  
             END IF   
       END CASE
       #TQC-C20197--end add---------------------------------------     
        #IF l_n = 0 THEN    #TQC-C20197 mark
        IF l_flag = '1' THEN   #TQC-C20197 add
           LET g_errno = 'art-851'
           RETURN
        END IF
#TQC-AC0134 ------------END
        SELECT (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[l_ac].ima1004 AND tqa03='1' AND tqaacti='Y'),
               (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[l_ac].ima1005 AND tqa03='2' AND tqaacti='Y'),
               (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[l_ac].ima1009 AND tqa03='6' AND tqaacti='Y'),
               (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[l_ac].ima1007 AND tqa03='4' AND tqaacti='Y')
          INTO g_rtt[l_ac].tqa02a,g_rtt[l_ac].tqa02b,g_rtt[l_ac].tqa02c,g_rtt[l_ac].tqa02d
          FROM tqa_file
        LET g_rtt[l_ac].rtt05 = l_ima.ima25
        LET g_rtt[l_ac].rtt14 = l_ima.ima44
        DISPLAY BY NAME g_rtt[l_ac].ima02,g_rtt[l_ac].ima021,g_rtt[l_ac].ima1004,
                        g_rtt[l_ac].ima1005,g_rtt[l_ac].ima1007,g_rtt[l_ac].ima1009,
                        g_rtt[l_ac].rtt05,g_rtt[l_ac].rtt14,
                        g_rtt[l_ac].tqa02a,g_rtt[l_ac].tqa02b,g_rtt[l_ac].tqa02c,g_rtt[l_ac].tqa02d
        SELECT gfe02 INTO g_rtt[l_ac].rtt05_desc FROM gfe_file
         WHERE gfe01 = g_rtt[l_ac].rtt05 AND gfeacti='Y'
     END IF  
END FUNCTION
 
FUNCTION i131_rtt14(p_cmd)         
DEFINE    l_gfeacti  LIKE gfe_file.gfeacti, 
          l_gfe02    LIKE gfe_file.gfe02,    
          p_cmd      LIKE type_file.chr1,
          l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac    
          
   LET g_errno = ' '
   
   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti FROM gfe_file
    WHERE gfe01 = g_rtt[l_ac].rtt14
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-031' 
                                 LET l_gfe02=NULL 
        WHEN l_gfeacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) THEN
     CALL s_umfchk('',g_rtt[l_ac].rtt05,g_rtt[l_ac].rtt14) RETURNING l_flag,l_fac
     IF l_flag = 1 THEN
        LET g_errno = 'art-032'
     END IF    
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_rtt[l_ac].rtt14_desc = l_gfe02
     DISPLAY BY NAME g_rtt[l_ac].rtt14_desc
  END IF
 
END FUNCTION
 
FUNCTION i131_set_visible()
 
    IF g_rto.rto06 MATCHES '[12]' THEN
       CALL cl_set_comp_visible("rtt06,rtt06t,rtt07,rtt08,rtt09,rtt10,rtt12,rtt13",TRUE)
       CALL cl_set_comp_visible("rtt11",FALSE)
    END IF
    IF g_rto.rto06 ='3' THEN
       CALL cl_set_comp_visible("rtt06,rtt06t,rtt07,rtt08,rtt09,rtt10",FALSE)
       CALL cl_set_comp_visible("rtt11,rtt12,rtt13",TRUE)
    END IF
    IF g_rto.rto06 ='4' THEN
       CALL cl_set_comp_visible("rtt06,rtt06t,rtt07,rtt08,rtt09,rtt10,rtt12,rtt13",FALSE)
       CALL cl_set_comp_visible("rtt11",TRUE)
    END IF
    
END FUNCTION
 
FUNCTION i131_show()
    LET g_rts_t.* = g_rts.*
    DISPLAY BY NAME g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rts04,g_rts.rts06, g_rts.rtsoriu,g_rts.rtsorig,
                    g_rts.rtsplant,g_rts.rtsconf,g_rts.rtsconu,g_rts.rtscond,
                   #g_rts.rtsmksg,g_rts.rts900,g_rts.rts05,g_rts.rtsuser,#TQC-AB0216
                    g_rts.rts05,g_rts.rtsuser,#TQC-AB0216  
                    g_rts.rtsgrup,g_rts.rtsmodu,g_rts.rtscrat,g_rts.rtsdate,
                    g_rts.rts08,g_rts.rts09,  #FUN-B40031
                    g_rts.rtsacti
    CALL i131_rts02('d')
    CALL i131_rts04('d')
    CALL i131_rts06('d')
    CALL i131_set_visible()
    CALL i131_rtsplant('d')
    CALL i131_rtsconu('d')
    CASE g_rts.rtsconf
        WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
        WHEN "N"
          CALL cl_set_field_pic("","","","","",g_rts.rtsacti)
        WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
    CALL i131_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i131_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        "SELECT rtt03,rtt04,'','','','','','','','','','',rtt05,'',rtt14,'',rtt06,rtt06t,",
        "rtt07,rtt08,rtt09,rtt10,rtt11,rtt12,rtt13,rtt15 FROM rtt_file ",
        " WHERE rtt01='",g_rts.rts01,"' AND rtt02='",g_rts.rts02,"'",
        "   AND rttplant='",g_rts.rtsplant,"'" 
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE i131_pb FROM g_sql
    DECLARE rtt_cs CURSOR FOR i131_pb
 
    CALL g_rtt.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtt_cs INTO g_rtt[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT ima02,ima021,ima1004,ima1005,ima1009,ima1007 
          INTO g_rtt[g_cnt].ima02,g_rtt[g_cnt].ima021,g_rtt[g_cnt].ima1004,
               g_rtt[g_cnt].ima1005,g_rtt[g_cnt].ima1009,g_rtt[g_cnt].ima1007
           FROM ima_file WHERE ima01=g_rtt[g_cnt].rtt04
        SELECT (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[g_cnt].ima1004 AND tqa03='1' AND tqaacti='Y'),
               (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[g_cnt].ima1005 AND tqa03='2' AND tqaacti='Y'),
               (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[g_cnt].ima1009 AND tqa03='6' AND tqaacti='Y'),
               (SELECT tqa02 FROM tqa_file WHERE tqa01=g_rtt[g_cnt].ima1007 AND tqa03='4' AND tqaacti='Y')
          INTO g_rtt[g_cnt].tqa02a,g_rtt[g_cnt].tqa02b,g_rtt[g_cnt].tqa02c,g_rtt[g_cnt].tqa02d
          FROM tqa_file
        SELECT a.gfe02,b.gfe02 INTO g_rtt[g_cnt].rtt05_desc,g_rtt[g_cnt].rtt14_desc
          FROM gfe_file a,gfe_file b
         WHERE a.gfe01=g_rtt[g_cnt].rtt05 AND b.gfe01=g_rtt[g_cnt].rtt14
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_rtt.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i131_a()
DEFINE li_result   LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rtt.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rts.* LIKE rts_file.*                  
 
   LET g_rts_t.* = g_rts.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      
      LET g_rts.rts02 = g_plant
      LET g_rts.rts03 = 0
      LET g_rts.rtsplant = g_plant
      LET g_rts.rtsconf = 'N'
      LET g_rts.rtsmksg = 'N'       #TQC-AB0216
      LET g_rts.rts900 = '0' 
      LET g_rts.rtsuser = g_user
      LET g_rts.rtsoriu = g_user #FUN-980030
      LET g_rts.rtsorig = g_grup #FUN-980030
      LET g_data_plant  = g_plant #TQC-A10128 ADD
      LET g_rts.rtsgrup = g_grup
      LET g_rts.rtscrat = g_today
      LET g_rts.rtsacti ='Y'                    
      SELECT azw02 INTO g_rts.rtslegal FROM azw_file
       WHERE azw01 = g_plant
      DISPLAY BY NAME g_rts.rts02,g_rts.rts03,g_rts.rtsplant,
                #     g_rts.rtsconf,g_rts.rts900,g_rts.rtsuser,#TQC-AB0216 
                      g_rts.rtsconf,g_rts.rtsuser,#TQC-AB0216
                      g_rts.rtsgrup,g_rts.rtscrat,g_rts.rtsacti
                     ,g_rts.rtsoriu,g_rts.rtsorig         #TQC-A30041 ADD
      CALL i131_rtsplant('d')
      CALL i131_rts02('d')
      CALL i131_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rts.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rts.rts01) THEN       
         CONTINUE WHILE
      END IF
      
      BEGIN WORK
#      CALL s_auto_assign_no("axm",g_rts.rts01,g_today,"","rts_file","rts01,rts02,rts03,rtsplant","","","")  #FUN-A70130 mark
       CALL s_auto_assign_no("art",g_rts.rts01,g_today,"A4","rts_file","rts01,rts02,rts03,rtsplant","","","")  #FUN-A70130 mod
          RETURNING li_result,g_rts.rts01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_rts.rts01
       
      INSERT INTO rts_file VALUES (g_rts.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","rts_file",g_rts.rts01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rts.* FROM rts_file
       WHERE rts01 = g_rts.rts01 AND rts02 = g_rts.rts02
         AND rts03 = g_rts.rts03 AND rtsplant = g_rts.rtsplant
      LET g_rts_t.* = g_rts.*
      CALL g_rtt.clear()
 
      LET g_rec_b = 0  
      CALL i131_b()                   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i131_i(p_cmd)
DEFINE     p_cmd     LIKE type_file.chr1,                
           l_n       LIKE type_file.num5           
DEFINE l_sql STRING 
DEFINE l_azp03 LIKE azp_file.azp03
DEFINE li_result    LIKE type_file.num5   
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_rts.rtsoriu,g_rts.rtsorig, 
    #FUN-B40031 Begin---
     #g_rts.rts01,g_rts.rts04,g_rts.rts06,g_rts.rtsmksg,g_rts.rts05 #TQC-AB0216
    # g_rts.rts01,g_rts.rts04,g_rts.rts06,g_rts.rts05               #TQC-AB0216     
     g_rts.rts01,g_rts.rts04,g_rts.rts06,g_rts.rts08,g_rts.rts09,g_rts.rts05
    #FUN-B40031 End-----
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         
          LET g_before_input_done = FALSE
          CALL i131_set_entry(p_cmd)
          CALL i131_set_no_entry(p_cmd)
          CALL cl_set_docno_format("rts01")
          LET g_before_input_done = TRUE
	
      AFTER FIELD rts01
         IF NOT cl_null(g_rts.rts01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rts.rts01 <> g_rts_t.rts01) THEN
              #CALL s_check_no("axm",g_rts.rts01,g_rts_t.rts01,"A4","rts_file","rts01,rts02,rtsplant","") #FUN-A70130 mark
               CALL s_check_no("art",g_rts.rts01,g_rts_t.rts01,"A4","rts_file","rts01,rts02,rtsplant","") #FUN-A70130 mod
                    RETURNING li_result,g_rts.rts01
                 IF (NOT li_result) THEN                                                            
                    LET g_rts.rts01=g_rts_t.rts01                                                                 
                    NEXT FIELD rts01                                                                                      
                 END IF 
            END IF
         END IF
      AFTER FIELD rts04
        IF NOT cl_null(g_rts.rts04) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rts.rts04 != g_rts_t.rts04) THEN
               SELECT COUNT(*) INTO l_n FROM rto_file LEFT JOIN rts_file 
                    ON rts04=rto01 AND rtsplant=rtoplant
                  WHERE rto01=g_rts.rts04 AND rtoconf = 'Y' AND rts01 IS NOT NULL
               IF l_n>0 THEN
                  CALL cl_err('','art-164',0)
                  LET g_rts.rts04=g_rts_t.rts04
                  NEXT FIELD rts04
               ELSE
                 CALL i131_rts04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rts.rts04,g_errno,0)
                    LET g_rts.rts04=g_rts_t.rts04
                    NEXT FIELD rts04
                 ELSE
                    IF cl_null(g_pmc47) THEN
                       CALL cl_err('','art-493',0)
                    ELSE
                       IF cl_null(g_rts.rts06) THEN
                          LET g_rts.rts06 = g_pmc47
                          DISPLAY BY NAME g_rts.rts06
                          CALL i131_rts06('a')
                          IF NOT cl_null(g_errno) THEN
                             CALL cl_err(g_rts.rts06,g_errno,0)
                          END IF
                       END IF
                    END IF
                    #No.TQC-AC0008  --Begin
                    CALL i131_check2()
                    IF NOT cl_null(g_errno) THEN
                       LET g_rts.rts04=g_rts_t.rts04
                       NEXT FIELD rts04
                    END IF
                    #No.TQC-AC0008  --End  
                    CALL i131_set_visible()
                 END IF
               END IF
            END IF
         END IF     

     #FUN-B40031 Begin---
      #AFTER FIELD rts008  #TQC-B50048
      AFTER FIELD rts08    #TQC-B50048
         IF NOT cl_null(g_rts.rts08) AND NOT cl_null(g_rts.rts04) THEN
            SELECT COUNT(*) INTO g_cnt FROM rto_file
             WHERE rto01 = g_rts.rts04 AND rto03 = g_rts.rts02
               AND rto02 = (SELECT MAX(rto02) FROM rto_file
                             WHERE rto01 = g_rts.rts04
                               AND rtoplant = g_rts.rtsplant
                               AND rto03 = g_rts.rts02)
               AND rtoplant = g_rts.rtsplant
	       AND rto08 <= g_rts.rts08
               AND rto09 >= g_rts.rts08
            IF g_cnt = 0 THEN
               CALL cl_err(g_rts.rts08,'art-693',0)
               NEXT FIELD rts08
            END IF
         END IF
     #FUN-B40031 End-----
      AFTER FIELD rts06
        IF NOT cl_null(g_rts.rts06) THEN
            LET g_errno = ''
            IF p_cmd = "a" THEN                    
                 CALL i131_rts06('a')
            ELSE
              IF g_rts.rts06 != g_rts_t.rts06 THEN
                 IF cl_confirm2('axm-415',g_rts.rts06) THEN
                    CALL i131_rts06(p_cmd)
                 ELSE
                    LET g_rts.rts06=g_rts_t.rts06
                    NEXT FIELD rts06
                 END IF
              END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rts.rts06,g_errno,0)
               LET g_rts.rts06=g_rts_t.rts06
               NEXT FIELD rts06
            END IF
        END IF
               
      AFTER INPUT
         LET g_rts.rtsuser = s_get_data_owner("rts_file") #FUN-C10039
         LET g_rts.rtsgrup = s_get_data_group("rts_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rts.rts01) OR cl_null(g_rts.rts02) THEN
               NEXT FIELD rts01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rts01) THEN
            LET g_rts.* = g_rts_t.*
            CALL i131_show()
            NEXT FIELD rts01
         END IF
 
     ON ACTION controlp
        CASE
          WHEN INFIELD(rts01)  #協議編號
                LET g_t1=s_get_doc_no(g_rts.rts01)
                CALL q_oay(FALSE,FALSE,g_t1,'A4','art') RETURNING g_t1   #FUN-A70130  
                LET g_rts.rts01=g_t1                                                                                             
                DISPLAY BY NAME g_rts.rts01                                                                                      
                NEXT FIELD rts01
          WHEN INFIELD(rts04) #合同編號
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rto01"
              LET g_qryparam.default1 = g_rts.rts04
              LET g_qryparam.where=" rto03='",g_rts.rts02,"' AND ",
                                  "rto01 not in (select rts04 from rts_file where rts04=rto01)"
              CALL cl_create_qry() RETURNING g_rts.rts04
              DISPLAY BY NAME g_rts.rts04
              CALL i131_rts04('d')
              NEXT FIELD rts04
           WHEN INFIELD(rts06) #稅种
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gec"
              LET g_qryparam.default1 = g_rts.rts06
              LET g_qryparam.arg1 = "1"
              CALL cl_create_qry() RETURNING g_rts.rts06
              DISPLAY BY NAME g_rts.rts06
              CALL i131_rts06('d')
              NEXT FIELD rts06
           OTHERWISE
              EXIT CASE
        END CASE
 
     ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION i131_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rts01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i131_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1         
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rts01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i131_set_entry_b(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
 
       CALL cl_set_comp_entry("rtt06",g_gec07='N')
       CALL cl_set_comp_entry("rtt06t",g_gec07='Y')
END FUNCTION
 
FUNCTION i131_b()
DEFINE          l_ac_t LIKE type_file.num5,
                l_n     LIKE type_file.num5,
                l_lock_sw       LIKE type_file.chr1,
                p_cmd   LIKE type_file.chr1,
                l_allow_insert  LIKE type_file.num5,
                l_allow_delete  LIKE type_file.num5
#FUN-B90092 add START-------------------------------
DEFINE tok         base.StringTokenizer
DEFINE l_rtt04     LIKE rtt_file.rtt04
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_i         LIKE type_file.num5
DEFINE l_rtz04     LIKE rtz_file.rtz04
DEFINE l_count     LIKE type_file.num5
#FUN-B90092 add END---------------------------------
DEFINE l_count1    LIKE type_file.num5   #FUN-BC0010 add
DEFINE l_sql       STRING  #FUN-BC0010 add
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        
        IF cl_null(g_rts.rts01) THEN
                RETURN 
        END IF
        
        SELECT * INTO g_rts.* FROM rts_file
         WHERE rts01=g_rts.rts01 AND rts02=g_rts.rts02
           AND  rts03=g_rts.rts03 AND rtsplant=g_rts.rtsplant
 
        IF g_rts.rtsacti='N' THEN 
                CALL cl_err(g_rts.rts01,'mfg1000',0)
                RETURN 
        END IF
        IF g_rts.rtsconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
        END IF
       
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT rtt03,rtt04,'','','','','','','','','','',rtt05,'',rtt14,'',rtt06,",
                        "rtt06t,rtt07,rtt08,rtt09,rtt10,rtt11,rtt12,rtt13,rtt15",
                        " FROM rtt_file",
                        " WHERE rtt01 = ? AND rtt02 = ?",
                        "   AND rtt03 = ? AND rttplant = ?",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i131_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_rtt WITHOUT DEFAULTS FROM s_rtt.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET l_flag = ' '  #FUN-BC0010 add
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i131_cl USING g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
                IF STATUS THEN
                        CALL cl_err("OPEN i131_cl:",STATUS,1)
                        CLOSE i131_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i131_cl INTO g_rts.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rts.rts01,SQLCA.sqlcode,0)
                        CLOSE i131_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtt_t.*=g_rtt[l_ac].*
                        LET g_rtt_o.*=g_rtt[l_ac].*        #FUN-BC0010 add
                        OPEN i131_bcl USING g_rts.rts01,g_rts.rts02,
                                            g_rtt_t.rtt03,g_rts.rtsplant
                        IF STATUS THEN
                                CALL cl_err("OPEN i131_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i131_bcl INTO g_rtt[l_ac].*
                                IF SQLCA.sqlcode THEN
                                    CALL cl_err(g_rtt_t.rtt03,SQLCA.sqlcode,1)
                                    LET l_lock_sw="Y"
                                END IF
                                CALL i131_rtt04('d')
                                CALL i131_rtt14('d')
                                CALL i131_set_entry_b(p_cmd)
                        END IF
                END IF
                
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtt[l_ac].* TO NULL
                LET g_rtt[l_ac].rtt15='Y'
                LET g_rtt_t.*=g_rtt[l_ac].*
                LET g_rtt_o.*=g_rtt[l_ac].*        #FUN-BC0010 add 
                CALL cl_show_fld_cont()
                CALL i131_set_entry_b(p_cmd)
                NEXT FIELD rtt03
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                INSERT INTO rtt_file(rtt01,rtt02,rtt16,rtt03,rtt04,rtt05,rtt06,rtt06t,rtt07,rtt08, #FUN-B40031 add rtt16
                                     rtt09,rtt10,rtt11,rtt12,rtt13,rtt14,rtt15,rttplant,rttlegal)
                              VALUES(g_rts.rts01,g_rts.rts02,0,g_rtt[l_ac].rtt03,g_rtt[l_ac].rtt04,#FUN-B40031
                                     g_rtt[l_ac].rtt05,g_rtt[l_ac].rtt06,g_rtt[l_ac].rtt06t,
                                     g_rtt[l_ac].rtt07,g_rtt[l_ac].rtt08,g_rtt[l_ac].rtt09,
                                     g_rtt[l_ac].rtt10,g_rtt[l_ac].rtt11,g_rtt[l_ac].rtt12,
                                     g_rtt[l_ac].rtt13,g_rtt[l_ac].rtt14,g_rtt[l_ac].rtt15,
                                     g_rts.rtsplant,g_rts.rtslegal)
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtt_file",g_rts.rts01,g_rtt[l_ac].rtt03,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT O.K.'
                        COMMIT WORK
                        LET g_rec_b=g_rec_b+1
                        DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                
      BEFORE FIELD rtt03
        IF cl_null(g_rtt[l_ac].rtt03) OR g_rtt[l_ac].rtt03 = 0 THEN 
            SELECT MAX(rtt03)+1 INTO g_rtt[l_ac].rtt03 FROM rtt_file
             WHERE rtt01=g_rts.rts01 AND rtt02=g_rts.rts02
               AND rttplant=g_rts.rtsplant
            IF g_rtt[l_ac].rtt03 IS NULL THEN
               LET g_rtt[l_ac].rtt03=1
            END IF
         END IF
         
      AFTER FIELD rtt03
        IF NOT cl_null(g_rtt[l_ac].rtt03) THEN 
           IF g_rtt[l_ac].rtt03<= 0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtt[l_ac].rtt03=g_rtt_t.rtt03
              NEXT FIELD rtt03
           END IF
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                             g_rtt[l_ac].rtt03 <> g_rtt_t.rtt03) THEN
              SELECT COUNT(*) INTO l_n FROM rtt_file
               WHERE rtt01=g_rts.rts01 AND rtt02=g_rts.rts02 
                 AND rtt03=g_rtt[l_ac].rtt03 AND rttplant=g_rts.rtsplant
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 LET g_rtt[l_ac].rtt03=g_rtt_t.rtt03
                 NEXT FIELD rtt03
              END IF
           END IF
         END IF
      
      AFTER FIELD rtt04
        IF NOT cl_null(g_rtt[l_ac].rtt04) THEN
#FUN-AA0059 ---------------------start----------------------------
           IF NOT s_chk_item_no(g_rtt[l_ac].rtt04,"") THEN
              CALL cl_err('',g_errno,1)
              LET g_rtt[l_ac].rtt04= g_rtt_t.rtt04
              NEXT FIELD rtt04
           END IF
#FUN-AA0059 ---------------------end-------------------------------
           IF p_cmd = 'a' OR (p_cmd = 'u' AND 
                              g_rtt[l_ac].rtt04 <> g_rtt_t.rtt04) THEN 
              SELECT COUNT(*) INTO l_n FROM rtt_file 
                 WHERE rtt01=g_rts.rts01 AND rtt02=g_rts.rts02
                   AND rtt04=g_rtt[l_ac].rtt04 AND rttplant=g_rts.rtsplant
              IF l_n>0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD rtt04
              ELSE  
                 #No.TQC-AC0008  --Begin
                 #同供应商+产品编号若采购协议生效期间重复时,为不OK
                 CALL i131_check1(g_rts.rts04,g_rtt[l_ac].rtt04)
                 IF NOT cl_null(g_errno) THEN
                    LET g_msg = g_rts.rts04,'+',g_rtt[l_ac].rtt04
                    CALL cl_err(g_msg,g_errno,0)
                    LET g_rtt[l_ac].rtt04=g_rtt_t.rtt04
                    NEXT FIELD rtt04
                 END IF 
                 #No.TQC-AC0008  --End  
              SELECT COUNT(DISTINCT rto_file.rto06) INTO l_n 
                 FROM rto_file,rts_file,rtt_file
                WHERE ((rto08 BETWEEN g_rto.rto08 AND g_rto.rto09) OR
                 (rto09 BETWEEN g_rto.rto08 AND g_rto.rto09))
                 AND rto01=rts04 AND rts01=rtt01 
                 AND rts02=rtt02 AND rtsconf='Y' 
                 AND rtt04=g_rtt[l_ac].rtt04 AND rtt15='Y'
                 AND rtsplant=rtoplant AND rtsplant=rttplant  #No.FUN-960130
                 AND rtoplant=g_rts.rtsplant                  #No.FUN-960130
              IF l_n>0 THEN
                 CALL cl_err('','art-156',0) 
                 LET g_rtt[l_ac].rtt04=g_rtt_t.rtt04
                 NEXT FIELD rtt04
              ELSE 
               CALL i131_rtt04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rtt[l_ac].rtt04,g_errno,0)
                  LET g_rtt[l_ac].rtt04=g_rtt_t.rtt04
                  NEXT FIELD rtt04
               END IF
              END IF
             END IF
          END IF
        END IF
       
      AFTER FIELD rtt14
        IF NOT cl_null(g_rtt[l_ac].rtt14) THEN
              CALL i131_rtt14('a')
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rtt[l_ac].rtt14,g_errno,0)
                  LET g_rtt[l_ac].rtt14=g_rtt_t.rtt14
                  NEXT FIELD rtt14
              END IF
        END IF
        
      AFTER FIELD rtt06,rtt06t,rtt07,rtt08,rtt09,rtt10,rtt11,rtt12,rtt13
           IF FGL_DIALOG_GETBUFFER()<=0 THEN
              CALL cl_err('','aic-054',0)
              NEXT FIELD CURRENT
           ELSE
              IF INFIELD(rtt06) THEN
                 IF g_rtt_o.rtt06 <> g_rtt[l_ac].rtt06 OR cl_null(g_rtt_o.rtt06) THEN
                    LET g_rtt_o.rtt06 = g_rtt[l_ac].rtt06
                    LET g_rtt[l_ac].rtt06t= g_rtt[l_ac].rtt06 * (1 + g_rts.rts07/100)
                    LET g_rtt_o.rtt06t = g_rtt[l_ac].rtt06t
                 END IF
              END IF
              IF INFIELD(rtt06t) THEN
                 IF g_rtt_o.rtt06t <> g_rtt[l_ac].rtt06t OR cl_null(g_rtt_o.rtt06t) THEN
                    LET g_rtt_o.rtt06t = g_rtt[l_ac].rtt06t
                    LET g_rtt[l_ac].rtt06= g_rtt[l_ac].rtt06t / (1 + g_rts.rts07/100)
                    LET g_rtt_o.rtt06 = g_rtt[l_ac].rtt06
                 END IF
              END IF
           END IF
#TQC-AC0104 ---------------STA
     ON CHANGE rtt07
         IF NOT cl_null(g_rtt[l_ac].rtt07) THEN
            CALL cl_set_comp_entry("rtt08",FALSE)
         ELSE
            CALL cl_set_comp_entry("rtt08",TRUE)
         END IF

     ON CHANGE rtt08
         IF NOT cl_null(g_rtt[l_ac].rtt08) THEN
            CALL cl_set_comp_entry("rtt07",FALSE)
         ELSE
            CALL cl_set_comp_entry("rtt07",TRUE)
         END IF
#TQC-AC0104 ---------------END           
       BEFORE DELETE                      
           IF g_rtt_t.rtt03 > 0 AND NOT cl_null(g_rtt_t.rtt03) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtt_file
               WHERE rtt01 = g_rts.rts01 AND rtt02=g_rts.rts02
                 AND rtt03 = g_rtt_t.rtt03
                      
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtt_file",g_rts.rts01,g_rtt_t.rtt03,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtt[l_ac].* = g_rtt_t.*
              CLOSE i131_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rtt[l_ac].rtt03,-263,1)
              LET g_rtt[l_ac].* = g_rtt_t.*
           ELSE
             
              UPDATE rtt_file SET  rtt03 = g_rtt[l_ac].rtt03,
                                   rtt04 = g_rtt[l_ac].rtt04,
                                   rtt05 = g_rtt[l_ac].rtt05,
                                   rtt06 = g_rtt[l_ac].rtt06,
                                   rtt06t = g_rtt[l_ac].rtt06t,
                                   rtt07 = g_rtt[l_ac].rtt07,
                                   rtt08 = g_rtt[l_ac].rtt08,
                                   rtt09 = g_rtt[l_ac].rtt09,
                                   rtt10 = g_rtt[l_ac].rtt10,
                                   rtt11 = g_rtt[l_ac].rtt11,
                                   rtt12 = g_rtt[l_ac].rtt12,
                                   rtt13 = g_rtt[l_ac].rtt13,
                                   rtt14 = g_rtt[l_ac].rtt14,
                                   rtt15 = g_rtt[l_ac].rtt15
                 WHERE rtt01=g_rts.rts01   AND rtt02=g_rts.rts02
                   AND rtt03=g_rtt_t.rtt03 AND rttplant=g_rts.rtsplant
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtt_file",g_rts.rts01,g_rtt_t.rtt03,SQLCA.sqlcode,"","",1) 
                 LET g_rtt[l_ac].* = g_rtt_t.*
              ELSE
                 LET g_rts.rtsmodu = g_user
                 LET g_rts.rtsdate = g_today
                 UPDATE rts_file SET rtsmodu = g_rts.rtsmodu,rtsdate = g_rts.rtsdate
                  WHERE rts01 = g_rts.rts01 AND rts02=g_rts.rts02 
                    AND rts03 = g_rts.rts03 AND rtsplant=g_rts.rtsplant
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     CALL cl_err3("upd","rts_file",g_rts.rtsmodu,g_rts.rtsdate,SQLCA.sqlcode,"","",1)
                 END IF
                 DISPLAY BY NAME g_rts.rtsmodu,g_rts.rtsdate
                 MESSAGE 'UPDATE O.K.'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac    #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtt[l_ac].* = g_rtt_t.*
             #FUN-D30033--add--str--
              ELSE
                 CALL g_rtt.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
             #FUN-D30033--add--end--
              END IF
              CLOSE i131_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033 add
           CLOSE i131_bcl
           COMMIT WORK
         #FUN-BC0010 add START
           LET l_flag = 'N'
           #為經銷或成本代銷時單身稅前/稅後單價不可為null
           IF g_rto.rto06 MATCHES '[12]' THEN
              LET l_count  = 0
              SELECT COUNT(*) INTO l_count FROM rtt_file   #計算單身有幾筆資料
                    WHERE rtt01=g_rts.rts01   AND rtt02=g_rts.rts02
                      AND rttplant=g_rts.rtsplant
              FOR l_i = 1 TO l_count
                 LET l_count1 = 0
                 SELECT COUNT(*) INTO l_count1 FROM rtt_file
                       WHERE rtt01=g_rts.rts01   AND rtt02=g_rts.rts02
                         AND rttplant=g_rts.rtsplant
                         AND rtt03 = g_rtt[l_i].rtt03
                         AND (rtt06=0 OR rtt06t=0 OR rtt06 IS NULL OR rtt06t IS NULL)
                 IF l_count1 > 0 THEN  #未輸入稅前/稅後單價
                    CALL cl_err('','art-892',0)
                    LET l_flag = 'Y'
                 END IF
              END FOR
           END IF
           #為扣率代銷或聯營單身扣率不可為null,且要大於0
           IF g_rto.rto06 MATCHES '[34]' THEN
              LET l_count  = 0
              SELECT COUNT(*) INTO l_count FROM rtt_file   #計算單身有幾筆資料
                    WHERE rtt01=g_rts.rts01   AND rtt02=g_rts.rts02
                      AND rttplant=g_rts.rtsplant
              FOR l_i = 1 TO l_count
                 LET l_count1 = 0
                 SELECT COUNT(*) INTO l_count1 FROM rtt_file
                       WHERE rtt01=g_rts.rts01   AND rtt02=g_rts.rts02
                         AND rttplant=g_rts.rtsplant
                         AND rtt03 = g_rtt[l_i].rtt03
                         AND (rtt11=0 OR rtt11 IS NULL)
                 IF l_count1 > 0 THEN
                    CALL cl_err('','art-892',0)
                    LET l_flag = 'Y'
                 END IF
              END FOR
           END IF
         #FUN-BC0010 add END
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtt03) AND l_ac > 1 THEN
              LET g_rtt[l_ac].* = g_rtt[l_ac-1].*
              LET g_rtt[l_ac].rtt03 = g_rec_b + 1
              NEXT FIELD rtt03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtt04)      
#FUN-AB0021-------mod-----------------str-----------               
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_rte03_3"
#              LET g_qryparam.arg1=g_rtz04 
#              LET g_qryparam.default1 = g_rtt[l_ac].rtt04
#              CALL cl_create_qry() RETURNING g_rtt[l_ac].rtt04
#FUN-B90092 mark START-----------------------------
#              CALL q_sel_ima(FALSE, "q_ima","",g_rtt[l_ac].rtt04,"","","","","",'' )  
#                 RETURNING g_rtt[l_ac].rtt04  
#FUN-AB0021-------mod-----------------end-----------
#              DISPLAY BY NAME g_rtt[l_ac].rtt04     
#               CALL i131_rtt04('d')
#               NEXT FIELD rtt04
#FUN-B90092 mark END-------------------------------
#FUN-B90092 add START-------------------------------
               CALL cl_init_qry_var()
               SELECT MAX(rtt03) INTO l_i FROM rtt_file WHERE rtt01 = g_rts.rts01 AND rtt16 = g_rts.rts03 
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
               SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rts.rtsplant AND rtz28 = 'Y'
#FUN-B90123 add START
              IF cl_null(l_rtz04) OR l_rtz04 = '' THEN
                 LET g_qryparam.form ="q_ima"
              ELSE
#FUN-B90123 add END
                 LET g_qryparam.form ="q_rte03_3"
              END IF                    #FUN-B90123 add
              LET g_qryparam.arg1=g_rtz04

             #限定產品分類
              SELECT COUNT(*) INTO l_count FROM rtq_file,rto_file
               WHERE rto01 = rtq01 AND rto02 = rtq02
                 AND  rtq01 = g_rts.rts04
                 AND rtoconf='Y'   AND  rtq05 = '1'
              IF l_count > 0 THEN
                 #IF NOT cl_null(g_qryparam.where) THEN LET g_qryparam.where = g_qryparam.where , " AND" END IF
                 LET g_qryparam.where = " ima131 IN (SELECT rtq06 FROM rtq_file,rto_file ",
                                        "             WHERE rto01 = rtq01 AND rto02 = rtq02",
                                        "               AND rtq01 = '",g_rts.rts04 CLIPPED,"'",
                                        "               AND rtoconf='Y' AND rtq05 = '1')"
              END IF


             #限定品牌
              SELECT COUNT(*) INTO l_count FROM rtq_file,rto_file
               WHERE rto01 = rtq01 AND rto02 = rtq02
                 AND  rtq01 = g_rts.rts04
                 AND rtoconf='Y'   AND  rtq05 = '2'
              IF l_count > 0 THEN
                 IF NOT cl_null(g_qryparam.where) THEN LET g_qryparam.where = g_qryparam.where , " AND" END IF
                 LET g_qryparam.where = g_qryparam.where," ima1005 IN (SELECT rtq06 FROM rtq_file,rto_file ",
                                                         "              WHERE rto01 = rtq01 AND rto02 = rtq02 ",
                                                         "                AND rtq01 ='",g_rts.rts04 CLIPPED,"' ",
                                                         "                AND rtoconf='Y' AND rtq05 = '2')"
              END IF
               IF NOT cl_null(g_rtt[l_ac].rtt04) THEN
                  LET g_qryparam.default1 = g_rtt[l_ac].rtt04
                  CALL cl_create_qry() RETURNING g_rtt[l_ac].rtt04
                  DISPLAY g_rtt[l_ac].rtt04 TO tt04
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_rtt04 = tok.nextToken()
                       IF cl_null(l_rtt04) THEN
                          CONTINUE WHILE
                       ELSE
                       END IF
                 #FUN-BC0010 add START
                  SELECT COUNT(*) INTO l_n FROM rtt_file
                     WHERE rtt01=g_rts.rts01 AND rtt02=g_rts.rts02
                     AND rtt04=l_rtt04 AND rttplant=g_rts.rtsplant
                  IF l_n>0 THEN
                     CONTINUE WHILE
                  END IF
                 #FUN-BC0010 add END
                       INSERT INTO rtt_file(rtt01,rtt02,rtt16,rtt03,rtt04,rtt05,rtt06,rtt06t,rtt07,rtt08, #FUN-B40031 add rtt16
                                     rtt09,rtt10,rtt11,rtt12,rtt13,rtt14,rtt15,rttplant,rttlegal)
                              VALUES(g_rts.rts01,g_rts.rts02,g_rts.rts03,l_i,l_rtt04,
                                     '','','',
                                     '','','',
                                     '','','',
                                     '','','Y',             #FUN-B90123 add 'Y'
                                     g_rts.rtsplant,g_rts.rtslegal)
                       LET l_i = l_i+1
                    END WHILE
                   LET l_flag = 'Y'
                   EXIT INPUT
               END IF
#FUN-B90092 add END---------------------------------
            WHEN INFIELD(rtt14)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe02" 
               LET g_qryparam.default1 = g_rtt[l_ac].rtt14
               LET g_qryparam.arg1=g_rtt[l_ac].rtt05
               CALL cl_create_qry() RETURNING g_rtt[l_ac].rtt14
               DISPLAY BY NAME g_rtt[l_ac].rtt14
               CALL i131_rtt14('d')
               NEXT FIELD rtt14
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
#FUN-B90092 add START-------------------------------
   IF l_flag = 'Y' THEN
       CALL i131_b_fill(" 1=1")
       CALL i131_b()
   END IF
#FUN-B90092 add END---------------------------------  
    CLOSE i131_bcl
    COMMIT WORK
#   CALL i131_delall() #CHI-C30002 mark
    CALL i131_delHeader()     #CHI-C30002 add
    CALL i131_show()
END FUNCTION                 
 
#CHI-C30002 -------- add -------- begin
FUNCTION i131_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rts.rts01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rts_file ",
                  "  WHERE rts01 LIKE '",l_slip,"%' ",
                  "    AND rts01 > '",g_rts.rts01,"'"
      PREPARE i131_pb1 FROM l_sql 
      EXECUTE i131_pb1 INTO l_cnt      
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL i131_v()
         CALL i131_show()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM rts_file WHERE rts01 = g_rts.rts01 AND rts02 = g_rts.rts02
                                AND rts03 = g_rts.rts03 AND rtsplant = g_rts.rtsplant
         INITIALIZE g_rts.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i131_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM rtt_file
#   WHERE rtt01 = g_rts.rts01 AND rtt02 = g_rts.rts02
#     AND rttplant = g_rts.rtsplant
#  IF g_cnt = 0 THEN                  
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM rts_file WHERE rts01 = g_rts.rts01 AND rts02 = g_rts.rts02
#                            AND rts03 = g_rts.rts03 AND rtsplant = g_rts.rtsplant
#     CLEAR FORM
#  END IF
#
#END FUNCTION                 
#CHI-C30002 -------- mark -------- end
                            
FUNCTION i131_upd_price()
DEFINE g_gec07_t LIKE gec_file.gec07
 
    LET g_errno = ''
    
    SELECT gec07 INTO g_gec07_t
      FROM gec_file
     WHERE gec01 = g_rts_t.rts06 AND gec011='1'  
    IF g_gec07 = 'N' THEN 
       IF g_gec07_t = 'Y' THEN
          UPDATE rtt_file SET rtt06 = rtt06t,rtt06t = rtt06t * (1 + g_rts.rts07/100)
           WHERE rtt01 = g_rts.rts01 AND rtt02 = g_rts.rts02 
             AND rttplant = g_rts.rtsplant
       ELSE
          UPDATE rtt_file SET rtt06t = rtt06 * (1 + g_rts.rts07/100)
           WHERE rtt01 = g_rts.rts01 AND rtt02 = g_rts.rts02
             AND rttplant = g_rts.rtsplant
       END IF
    ELSE
       IF g_gec07_t = 'N' THEN
          UPDATE rtt_file SET rtt06t = rtt06,rtt06 = rtt06 / (1 + g_rts.rts07/100)
           WHERE rtt01 = g_rts.rts01 AND rtt02 = g_rts.rts02
             AND rttplant = g_rts.rtsplant
       ELSE
           UPDATE rtt_file SET rtt06 = rtt06t / (1 + g_rts.rts07/100)
            WHERE rtt01 = g_rts.rts01 AND rtt02 = g_rts.rts02
              AND rttplant = g_rts.rtsplant
       END IF
    END IF
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       LET g_errno = 'art-393'
    END IF
END FUNCTION
                                
FUNCTION i131_u()
DEFINE l_cnt     LIKE type_file.num5   #TQC-B80035 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rts.rts01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rts.* FROM rts_file
    WHERE rts01=g_rts.rts01 AND rts02 = g_rts.rts02
      AND rts03=g_rts.rts03 AND rtsplant=g_rts.rtsplant
   IF g_rts.rtsacti ='N' THEN    
      CALL cl_err('','mfg1000',0)
      RETURN
   END IF
   LET g_rts_t.* = g_rts.*  #FUN-B50026 add
   IF g_rts.rtsconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
 
   OPEN i131_cl USING g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
   IF STATUS THEN
      CALL cl_err("OPEN i131_cl:", STATUS, 1)
      CLOSE i131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i131_cl INTO g_rts.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)    
       CLOSE i131_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i131_show()
 
   WHILE TRUE
  
      LET g_rts.rtsmodu=g_user
      LET g_rts.rtsdate=g_today
      DISPLAY BY NAME g_rts.rtsmodu,g_rts.rtsdate
      
      CALL i131_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rts.*=g_rts_t.*
         CALL i131_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      #TQC-B80035 add
      SELECT COUNT(*) INTO l_cnt FROM rtt_file
       WHERE rtt01 = g_rts_t.rts01 AND rtt02 = g_rts_t.rts02
         AND rttplant = g_rts_t.rtsplant
      #TQC-B80035 add--end
     #IF g_rts.rts01 <> g_rts_t.rts01 THEN            
      IF g_rts.rts01 <> g_rts_t.rts01 AND l_cnt > 0 THEN    #TQC-B80035 mod
         UPDATE rtt_file SET rtt01 = g_rts.rts01
          WHERE rtt01 = g_rts_t.rts01 AND rtt02 = g_rts_t.rts02
            AND rttplant = g_rts_t.rtsplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtt_file",g_rts_t.rts01,"",SQLCA.sqlcode,"","rtt",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE rts_file SET rts_file.* = g_rts.*
      #TQC-B80035 mod
      #WHERE rts01=g_rts.rts01 AND rts02=g_rts.rts02
      #  AND rts03=g_rts.rts03 AND rtsplant=g_rts.rtsplant
       WHERE rts01=g_rts_t.rts01 AND rts02=g_rts_t.rts02
         AND rts03=g_rts_t.rts03 AND rtsplant=g_rts_t.rtsplant
      #TQC-B80035 mod--end
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rts_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         IF g_rts.rts06 <> g_rts_t.rts06 THEN
            CALL i131_upd_price()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rts.rts06,g_errno,1)
               CONTINUE WHILE
            END IF
         END IF
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i131_cl
   COMMIT WORK
   CALL i131_show()
   CALL i131_b_fill(g_wc2)
   CALL i131_bp_refresh()
 
END FUNCTION          
                
FUNCTION i131_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rts.rts01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rts.* FROM rts_file
    WHERE rts01=g_rts.rts01 AND rts02=g_rts.rts02
      AND rts03=g_rts.rts03 AND rtsplant=g_rts.rtsplant
 
   IF g_rts.rtsacti ='N' THEN    
      CALL cl_err('','mfg1000',0)
      RETURN
   END IF
   
   IF g_rts.rtsconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
   END IF
       
   BEGIN WORK
 
   OPEN i131_cl USING g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
   IF STATUS THEN
      CALL cl_err("OPEN i131_cl:", STATUS, 1)
      CLOSE i131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i131_cl INTO g_rts.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rts.rts01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i131_show()
 
   IF cl_delh(0,0) THEN                   
      DELETE FROM rts_file WHERE rts01 = g_rts.rts01 AND rts02 = g_rts.rts02
                             AND rts03 = g_rts.rts03 AND rtsplant = g_rts.rtsplant
      DELETE FROM rtt_file WHERE rtt01 = g_rts.rts01 AND rtt02 = g_rts.rts02
                             AND rttplant = g_rts.rtsplant
      CLEAR FORM
      CALL g_rtt.clear()
      OPEN i131_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i131_cs
         CLOSE i131_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH i131_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i131_cs
         CLOSE i131_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i131_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i131_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i131_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE i131_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i131_copy()
DEFINE  l_newno1    LIKE rts_file.rts01,
        l_newno2    LIKE rts_file.rts04,
        l_oldno1    LIKE rts_file.rts01,
        l_oldno2    LIKE rts_file.rts04,
        l_cnt       LIKE type_file.num5,
        g_rto_t     RECORD LIKE rto_file.*,
        l_n         LIKE type_file.num5,
        li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rts.rts01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL cl_set_comp_entry("rts04",TRUE)
   
   LET l_oldno1=g_rts.rts01
   LET l_oldno2=g_rts.rts04
   LET g_rto_t.*=g_rto.*
   
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno1,l_newno2 FROM rts01,rts04
       BEFORE INPUT
          CALL cl_set_docno_format("rts01")
       AFTER FIELD rts01
          IF NOT cl_null(l_newno1) THEN                                          
             SELECT COUNT(*) INTO l_cnt FROM rts_file                          
              WHERE rts01 = l_newno1 AND rts02 = g_rts.rts02
             IF l_cnt > 0 THEN                                                 
                CALL cl_err('',-239,0)                                    
                NEXT FIELD rts01                   
             END IF                                                                                                                        
             #FUN-B50026 add
             CALL s_check_no("art",l_newno1,"","A4","rts_file","rts01,rts02,rtsplant","")
                  RETURNING li_result,l_newno1
               IF (NOT li_result) THEN                                                            
                  NEXT FIELD rts01                                                                                      
               END IF 
             #FUN-B50026 add-end
          END IF   
                               
      AFTER FIELD rts04
        IF NOT cl_null(l_newno2) THEN
               SELECT COUNT(*) INTO l_n FROM rto_file LEFT JOIN rts_file 
                    ON rts04=rto01 
                  WHERE rto01=l_newno2 AND rts01 IS NOT NULL
               IF l_n>0 THEN
                  CALL cl_err('','art-164',0)
                  NEXT FIELD rts04
               ELSE
                 LET g_rts.rts04=l_newno2
                 CALL i131_rts04('a')
                 IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rts.rts04,g_errno,0)
                  LET g_rts.rts04=l_oldno2
                  NEXT FIELD rts04
                 ELSE
                  IF (g_rto.rto08>=g_rto_t.rto08 AND g_rto.rto08<=g_rto_t.rto09) OR
                     (g_rto.rto09>=g_rto_t.rto08 AND g_rto.rto09<=g_rto_t.rto09) THEN
                     IF g_rto.rto06<>g_rto_t.rto06 THEN
                        CALL cl_err('','art-156',0)
                        LET g_rts.rts04=l_oldno2
                        NEXT FIELD rts04
                     END IF
                  END IF                    
                  CALL i131_set_visible()
                  LET g_rts.rts04=l_oldno2
                 END IF
               END IF
         END IF     
         
     ON ACTION controlp
        CASE
          WHEN INFIELD(rts01)  #協議編號
                LET g_t1=s_get_doc_no(l_newno1)
                CALL q_oay(FALSE,FALSE,g_t1,'A4','art') RETURNING g_t1      #FUN-A70130
                LET l_newno1=g_t1                                                                                             
                DISPLAY l_newno1 TO rts01                                                                                      
                NEXT FIELD rts01
          WHEN INFIELD(rts04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rto01"
              LET g_qryparam.default1 = g_rts.rts04
              LET g_qryparam.arg1=" rto03='",g_rts.rts02,"' AND ",
                                  "rto01 not in (select rts04 from rts_file where rts04=rto01)"
              CALL cl_create_qry() RETURNING l_newno2
              DISPLAY l_newno2 TO rts04
              LET l_oldno2 = g_rts.rts04
              LET g_rts.rts04 = l_newno2
              CALL i131_rts04('d')
              LET g_rts.rts04=l_oldno2
              NEXT FIELD rts04
           OTHERWISE
              EXIT CASE
        END CASE    
        
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
 
   BEGIN WORK
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_rts.rts01,g_rts.rts04   
      ROLLBACK WORK 
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM rts_file         
    WHERE rts01=g_rts.rts01 AND rts02=g_rts.rts02
      AND rts03=g_rts.rts03 AND rtsplant=g_rts.rtsplant
     INTO TEMP y
#  CALL s_auto_assign_no("axm",l_newno1,g_today,"","rts_file","rts01,rts02,rts03,rtsplant","","","")  #FUN-A70130 mark
   CALL s_auto_assign_no("art",l_newno1,g_today,"A4","rts_file","rts01,rts02,rts03,rtsplant","","","")  #FUN-A70130 mod
          RETURNING li_result,l_newno1
   IF (NOT li_result) THEN                                                                           
      ROLLBACK WORK 
      RETURN                                                                    
   END IF
   UPDATE y
       SET rts01=l_newno1,
           rts04=l_newno2,    
           rtsuser=g_user,   
           rtsgrup=g_grup,  
           rtsoriu=g_user,          #TQC-A30041 ADD
           rtsorig=g_grup,          #TQC-A30041 ADD
           rtscrat=g_today, 
           rtsmodu=NULL,     
           rtsdate=NULL,  
           rtsacti='Y',
           rtsconf='N',
           rtsconu=NULL,
           rtscond=NULL     
 
   INSERT INTO rts_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rts_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rtt_file         
    WHERE rtt01=g_rts.rts01 AND rtt02=g_rts.rts02
      AND rttplant=g_rts.rtsplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rtt01=l_newno1
   INSERT INTO rtt_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtt_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
   LET l_oldno1 = g_rts.rts01
   SELECT rts_file.* INTO g_rts.* FROM rts_file 
    WHERE rts01 = l_newno1 AND rts02=g_rts.rts02
   CALL cl_set_comp_entry("rts04",FALSE)
   CALL i131_u()
   CALL i131_b()
   #SELECT rts_file.* INTO g_rts.* FROM rts_file   #FUN-C80046
   # WHERE rts01 = l_oldno1 AND rts02=g_rts.rts02  #FUN-C80046
   #CALL i131_show()   #FUN-C80046
 
END FUNCTION
 
FUNCTION i131_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rts.rts01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i131_cl USING g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
   IF STATUS THEN
      CALL cl_err("OPEN i131_cl:", STATUS, 1)
      CLOSE i131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i131_cl INTO g_rts.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rts.rts01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
   IF g_rts.rtsconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
   END IF
   
   LET g_success = 'Y'
 
   CALL i131_show()
 
   IF cl_exp(0,0,g_rts.rtsacti) THEN                   
      LET g_chr=g_rts.rtsacti
      IF g_rts.rtsacti='Y' THEN
         LET g_rts.rtsacti='N'
      ELSE
         LET g_rts.rtsacti='Y'
      END IF
 
      UPDATE rts_file SET rtsacti=g_rts.rtsacti,
                          rtsmodu=g_user,
                          rtsdate=g_today
       WHERE rts01=g_rts.rts01 AND rts02=g_rts.rts02
         AND rts03=g_rts.rts03 AND rtsplant=g_rts.rtsplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rts_file",'',"",SQLCA.sqlcode,"","",1)  
         LET g_rts.rtsacti=g_chr
      END IF
   END IF
 
   CLOSE i131_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rtsacti,rtsmodu,rtsdate
     INTO g_rts.rtsacti,g_rts.rtsmodu,g_rts.rtsdate FROM rts_file
    WHERE rts01=g_rts.rts01 AND rts02=g_rts.rts02
      AND rts03=g_rts.rts03 AND rtsplant=g_rts.rtsplant
   DISPLAY BY NAME g_rts.rtsacti,g_rts.rtsmodu,g_rts.rtsdate
   CALL cl_set_field_pic('','','','','',g_rts.rtsacti)
END FUNCTION
 
FUNCTION i131_bp_refresh()
 
  DISPLAY ARRAY g_rtt TO s_rtt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION                                             
                  
FUNCTION i131_transfer() #拋轉
DEFINE  l_dbname  LIKE azp_file.azp03
DEFINE  l_sql STRING 
DEFINE  l_n   LIKE type_file.num5
DEFINE  l_rtp05 LIKE rtp_file.rtp05
DEFINE  l_no  LIKE rts_file.rts01
DEFINE  li_result LIKE type_file.num5
DEFINE  l_rts01 LIKE rts_file.rts01
DEFINE  l_legal LIKE rts_file.rtslegal
 
   LET l_sql = "SELECT azp03,rtp05 FROM azp_file,rtp_file ",
               " WHERE azp01=rtp05 ",
               " AND rtp01=? AND rtp02=?",
               " AND rtp03=? AND rtpplant=?"
   PREPARE trans_pre FROM l_sql
   DECLARE trans_cs  CURSOR FOR trans_pre
 
   FOREACH trans_cs USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant 
                    INTO l_dbname,l_rtp05
      IF l_rtp05 <> g_rts.rtsplant THEN        
        #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbname CLIPPED),"rts_file ",        #FUN-A50102 mark
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_rtp05,'rts_file'),         #FUN-A50102           
                   " WHERE rts01=? AND rts02=? AND rts03=? AND rtsplant=?"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102 
         CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql    #FUN-A50102
         PREPARE trans_sel_rts FROM l_sql
         EXECUTE trans_sel_rts USING g_rts.rts01,g_rts.rts02,g_rts.rts03,l_rtp05 INTO l_n
         IF l_n=0 THEN 
            DELETE FROM rts_temp
            INSERT INTO rts_temp
            SELECT * FROM rts_file WHERE rts01 = g_rts.rts01 AND rts02= g_rts.rts02
                                     AND rts03 = g_rts.rts03 AND rtsplant=g_rts.rtsplant
            SELECT azw02 INTO l_legal FROM azw_file WHERE azw01=l_rtp05
            UPDATE rts_temp SET rtslegal=l_legal,
                                rtsplant=l_rtp05
           #LET l_sql = "INSERT INTO ",s_dbstring(l_dbname CLIPPED),"rts_file",  #FUN-A50102  mark
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtp05,'rts_file'),  #FUN-A50102  
                        " SELECT * FROM rts_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql   #FUN-A50102 
            PREPARE trans_ins_rts FROM l_sql
            EXECUTE trans_ins_rts           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rts_file","","",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            ELSE
               DELETE FROM rtt_temp
               INSERT INTO rtt_temp
               SELECT * FROM rtt_file WHERE rtt01 = g_rts.rts01 AND rtt02= g_rts.rts02
                                        AND rttplant=g_rts.rtsplant
               UPDATE rtt_temp SET rttlegal=l_legal,
                                   rttplant=l_rtp05
              #LET l_sql = "INSERT INTO ",s_dbstring(l_dbname CLIPPED),"rtt_file",     #FUN-A50102 mark
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtp05,'rtt_file'),     #FUN-A50102
                           " SELECT * FROM rtt_temp"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
               CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql      #FUN-A50102
               PREPARE trans_ins_rtt FROM l_sql
               EXECUTE trans_ins_rtt
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","rtt_file","","",SQLCA.sqlcode,"","",1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
         END IF
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i131_y() #審核
DEFINE l_count     LIKE type_file.num5    #FUN-BC0010 add 
   IF cl_null(g_rts.rts01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF   
#CHI-C30107 ------------- add ----------------  begin
   IF g_rts.rtsacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF

   IF g_rts.rtsconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF

   IF g_rts.rtsconf='X' THEN
      CALL cl_err('','art-868',0)  
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN
        RETURN
   END IF
#CHI-C30107 ------------- add ---------------- end
   DROP TABLE rts_temp
   SELECT * FROM rts_file WHERE 1=0 INTO TEMP rts_temp
   DROP TABLE rtt_temp
   SELECT * FROM rtt_file WHERE 1=0 INTO TEMP rtt_temp
   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   OPEN i131_cl USING g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
   IF STATUS THEN
      CALL cl_err("OPEN i131_cl:", STATUS, 1)
      CLOSE i131_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i131_cl INTO g_rts.*    
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE i131_cl
      ROLLBACK WORK
      RETURN
     END IF
     
   IF g_rts.rtsacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_rts.rtsconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
   IF g_rts.rtsconf='X' THEN
    #  CALL cl_err('',9024,0)     #FUN-B90094 mark
      CALL cl_err('','art-868',0)  #FUN-B90094 add
      RETURN
   END IF
   
#FUN-BC0010 add START
   #為經銷或成本代銷時單身稅前/稅後單價不可為null
   IF g_rto.rto06 MATCHES '[12]' THEN
      LET l_count  = 0
      SELECT COUNT(*) INTO l_count FROM rtt_file  #計算單身是否有未輸入單價
         WHERE rtt01=g_rts.rts01   AND rtt02=g_rts.rts02
           AND rttplant=g_rts.rtsplant
           AND (rtt06=0 OR rtt06t=0 OR rtt06 IS NULL OR rtt06t IS NULL)
      IF l_count > 0 THEN  #未輸入稅前/稅後單價
         CALL cl_err('','art-892',0)
         RETURN
      END IF
   END IF
   #為扣率代銷或聯營單身扣率不可為null,且要大於0
   IF g_rto.rto06 MATCHES '[34]' THEN
      LET l_count = 0
      SELECT COUNT(*) INTO l_count FROM rtt_file
         WHERE rtt01=g_rts.rts01   AND rtt02=g_rts.rts02
           AND rttplant=g_rts.rtsplant
           AND (rtt11=0 OR rtt11 IS NULL)
      IF l_count > 0 THEN
         CALL cl_err('','art-892',0)
         RETURN
      END IF
   END IF
#FUN-BC0010 add END
#CHI-C30107 -------------- mark ------------ begin
#  IF NOT cl_confirm('axm-108') THEN 
#       RETURN
#  END IF      
#CHI-C30107 -------------- mark ------------ end
        UPDATE rts_file SET rtsconf = 'Y',
                            rtsconu = g_user,
                            rtscond = g_today,
                            rtsmodu = g_user,
                            rtsdate = g_today
         WHERE rts01 = g_rts.rts01 AND rts02 = g_rts.rts02
           AND rts03 = g_rts.rts03 AND rtsplant=g_rts.rtsplant
            IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rts_file",g_rts.rts01,"",STATUS,"","",1) 
              LET g_success = 'N'
            ELSE
             IF SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","rts_file",g_rts.rts01,"","9050","","",1) 
              LET g_success = 'N'
             ELSE
              CALL i131_transfer()             
             END IF
            END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rts.rtsconf = 'Y'
      LET g_rts.rtsconu = g_user
      LET g_rts.rtscond = g_today
      LET g_rts.rtsmodu = g_user
      LET g_rts.rtsdate = g_today
      DISPLAY BY NAME g_rts.rtsconf,g_rts.rtsconu,g_rts.rtscond,
                      g_rts.rtsmodu,g_rts.rtsdate
     CALL i131_rtsconu('d')
     CALL cl_set_field_pic(g_rts.rtsconf,"","","","","")
     CALL cl_err('','art-169',0)
   ELSE
     CALL s_showmsg()
      ROLLBACK WORK
   END IF
   
END FUNCTION           
#FUN-870007
#No.TQC-AC0008  --Begin
FUNCTION i131_check2()
   DEFINE l_rtt04            LIKE rtt_file.rtt04
    
   LET g_errno=''
   DECLARE i131_rtt04 CURSOR FOR
    SELECT rtt04 FROM rtt_file
     WHERE rtt01 = g_rts.rts01
       AND rtt02 = g_rts.rts02
       AND rttplant = g_rts.rtsplant
   FOREACH i131_rtt04 INTO l_rtt04
       CALL i131_check1(g_rts.rts04,l_rtt04)
       IF NOT cl_null(g_errno) THEN
          LET g_msg = g_rts.rts04,'+',l_rtt04
          CALL cl_err(g_msg,g_errno,1)
          EXIT FOREACH
       END IF
   END FOREACH

END FUNCTION

#同供应商+产品编号若采购协议生效期间重复时,为不OK
FUNCTION i131_check1(p_rts04,p_rtt04)
   DEFINE p_rts04            LIKE rts_file.rts04
   DEFINE p_rtt04            LIKE rtt_file.rtt04
   DEFINE l_rto05            LIKE rto_file.rto05
   DEFINE l_rto08            LIKE rto_file.rto08
   DEFINE l_rto09            LIKE rto_file.rto09
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_rto01            LIKE rto_file.rto01
   DEFINE l_ima131           LIKE ima_file.ima131  #TQC-B80045 add
   DEFINE l_ima1005          LIKE ima_file.ima1005 #TQC-B80045 add
   DEFINE l_rtq06            LIKE rtq_file.rtq06   #FUN-C90046 add

   LET g_errno=''
   #TQC-B80045 add
   #检查產品分類和經營品牌
   #FUN-C90046---add---str
   SELECT rtq06 INTO l_rtq06
     FROM rtq_file
    WHERE rtq01 = g_rts.rts04
   IF NOT cl_null(l_rtq06) THEN
   #FUN-C90046---add---end
      SELECT ima131,ima1005 INTO l_ima131,l_ima1005
        FROM ima_file
       WHERE ima01=p_rtt04
      SELECT COUNT(*) INTO l_cnt FROM rtq_file
       WHERE rtq01 = g_rts.rts04
         AND rtq03 = g_rts.rts02
         AND rtq06 IN (l_ima131,l_ima1005)
      IF l_cnt = 0 THEN
         LET g_errno = 'art-851'
         RETURN
      END IF
   END IF       #FUN-C90046 add
   #TQC-B80045 add--end

   #1.当前厂商编号/生效日期/失效日期
   SELECT rto05,rto08,rto09 INTO l_rto05,l_rto08,l_rto09
     FROM rto_file
    WHERE rto01 = p_rts04 AND rto03 = g_rts.rts02
      AND rto02 = (SELECT MAX(rto02) FROM rto_file 
                    WHERE rto01 = p_rts04
                      AND rto03 = g_rts.rts02
                      AND rtoplant = g_rts.rtsplant
                  )
      AND rtoplant = g_rts.rtsplant

   #2.同一厂商编号且生效日期/失效日期与当前笔有交叉的合同编号
   DECLARE i131_rto01 CURSOR FOR
    SELECT rto01 FROM rto_file a
     WHERE rto05 = l_rto05
       AND rto03 = g_rts.rts02
       AND rtoplant = g_rts.rtsplant
       AND rto02 = ( SELECT MAX(rto02) FROM rto_file b
                      WHERE b.rto01 = a.rto01
                        AND rto03 = g_rts.rts02
                        AND rtoplant = g_rts.rtsplant )
       AND ( rto09 >= l_rto08 AND rto08 <= l_rto09)   #交叉                         
       AND rtoconf = 'Y'

   #有交叉的合同编号
   FOREACH i131_rto01 INTO l_rto01
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM rts_file,rtt_file
        WHERE rts01 = rtt01 AND rts02 = rtt02
          AND rtsplant = rttplant
          AND rts04 = l_rto01
          AND rtt04 = p_rtt04   #产品
       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF

       IF l_cnt > 0 THEN
          LET g_errno = 'art-690'
          EXIT FOREACH
       END IF

   END FOREACH

END FUNCTION
#No.TQC-AC0008  --End  
#CHI-C80041---begin
FUNCTION i131_v()
DEFINE l_chr  LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rts.rts01) OR cl_null(g_rts.rts02) OR cl_null(g_rts.rts03) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN i131_cl USING g_rts.rts01,g_rts.rts02,g_rts.rts03,g_rts.rtsplant
   IF STATUS THEN
      CALL cl_err("OPEN i131_cl:", STATUS, 1)
      CLOSE i131_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i131_cl INTO g_rts.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rts.rts01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i131_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_rts.rtsconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_rts.rtsconf) THEN 
        LET l_chr=g_rts.rtsconf
        IF g_rts.rtsconf='N' THEN 
            LET g_rts.rtsconf='X' 
        ELSE
            LET g_rts.rtsconf='N'
        END IF
        UPDATE rts_file
            SET rtsconf=g_rts.rtsconf,  
                rtsmodu=g_user,
                rtsdate=g_today
            WHERE rts01=g_rts.rts01
              AND rts02=g_rts.rts02
              AND rts03=g_rts.rts03
              AND rtsplant=g_rts.rtsplant
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rts_file",g_rts.rts01,"",SQLCA.sqlcode,"","",1)  
            LET g_rts.rtsconf=l_chr 
        END IF
        DISPLAY BY NAME g_rts.rtsconf
   END IF
 
   CLOSE i131_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rts.rts01,'V')
 
END FUNCTION
#CHI-C80041---end
