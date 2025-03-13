# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axmq003
# Descriptions...: 出貨明細狀態查詢作業
# Date & Author..: 12/09/26 NO.FUN-C90076 By lixh1
# Modify.........: No:MOD-D10133 13/01/15 By SunLM 匯總單身的品名規格未抓出
# Modify.........: No.FUN-D10105 13/01/22 By fengrui axmq003增加客戶分類(occ03)和產品分類(ima131)
# Modify.........: No.MOD-D20135 13/02/22 By SunLM 立帳數量和金額翻倍，在多倉儲批的時候
# Modify.........: No.MOD-D50172 13/05/21 By SunLm 增加帳單編號開窗查詢
# Modify.........: No.TQC-D50098 13/05/21 By fengrui g_filter_wc赋值为' 1=1'

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                              
                 wc2 STRING,                                     
                 a   LIKE type_file.chr10       #合計選項  #FUN-D10105
              END RECORD     
   DEFINE g_filter_wc     STRING   
   DEFINE g_filter_wc1    STRING
   DEFINE g_filter_wc2    STRING   
   DEFINE l_where         STRING 
   DEFINE g_sql           STRING                                                                                    
   DEFINE g_str           STRING    
   DEFINE l_table         STRING   
   DEFINE g_msg           LIKE type_file.chr1000
   DEFINE g_rec_b         LIKE type_file.num10
   DEFINE g_cnt           LIKE type_file.num10                  
   DEFINE g_qbe_oga011,g_qbe_oga011_f    LIKE oga_file.oga011 
   DEFINE g_qbe_oga65 ,g_qbe_oga65_f     LIKE oga_file.oga65 
   DEFINE g_qbe_ogb11 ,g_qbe_ogb11_f     LIKE ogb_file.ogb11 
   DEFINE g_qbe_ogb17 ,g_qbe_ogb17_f     LIKE ogb_file.ogb17 
   DEFINE g_qbe_ogb50 ,g_qbe_ogb50_f     LIKE ogb_file.ogb12
   DEFINE g_qbe_ogb51 ,g_qbe_ogb51_f     LIKE ogb_file.ogb12
   DEFINE g_qbe_ogb41 ,g_qbe_ogb41_f     LIKE ogb_file.ogb41
   DEFINE g_qbe_oga00 ,g_qbe_oga00_f     LIKE oga_file.oga00
   DEFINE g_oga,g_oga_excel   DYNAMIC ARRAY OF RECORD  
                oea00     LIKE oea_file.oea00,
                ogb31     LIKE ogb_file.ogb31,
                ogb32     LIKE ogb_file.ogb32,
                oea10     LIKE oea_file.oea10,
                oga011    LIKE oga_file.oga011,
                oga00     LIKE oga_file.oga00,           
                oga08     LIKE oga_file.oga08,
                oga01     LIKE oga_file.oga01,
                oga02     LIKE oga_file.oga02,
                oga03     LIKE oga_file.oga03,                     
                oga032    LIKE oga_file.oga032,
                oha48     like oha_file.oha48,   #darcy:2024/01/30 add
                occ03     LIKE occ_file.occ03,   #FUN-D10105
                oca02     LIKE oca_file.oca02,   #FUN-D10105
                oga04     LIKE oga_file.oga04,
                occ02     LIKE occ_file.occ02,
                oga14     LIKE oga_file.oga14,
                gen02     LIKE gen_file.gen02,
                oga15     LIKE oga_file.oga15,
                gem02     LIKE gem_file.gem02,
                oga23     LIKE oga_file.oga23,
                oga21     LIKE oga_file.oga21,
                oga211    LIKE oga_file.oga211,
                oga213    LIKE oga_file.oga213,
                oga65     LIKE oga_file.oga65,                
                oga10     LIKE oga_file.oga10,
                ogaconf   LIKE oga_file.ogaconf,
                oga55     LIKE oga_file.oga55,
                ogapost   LIKE oga_file.ogapost,
                ogb03     LIKE ogb_file.ogb03,
                ogb04     LIKE ogb_file.ogb04,
                ogb06     LIKE ogb_file.ogb06,
                ima021    LIKE ima_file.ima021,
                ima131    LIKE ima_file.ima131,   #FUN-D10105
                oba02     LIKE oba_file.oba02,    #FUN-D10105
                ogb11     LIKE ogb_file.ogb11,
                ogb17     LIKE ogb_file.ogb17,
                ogb09     LIKE ogb_file.ogb09,
                ogb091    LIKE ogb_file.ogb091,
                ogb092    LIKE ogb_file.ogb092,
                ogb05     LIKE ogb_file.ogb05,
                ogb12     LIKE ogb_file.ogb12,
                ogb13     LIKE ogb_file.ogb13,
                ogb13e    LIKE ogb_file.ogb13,
                ogb14t    LIKE ogb_file.ogb14t,
                ogb14t_2  LIKE ogb_file.ogb14t,  #add by huanglf170204
                ogb14t_o  LIKE ogb_file.ogb14t, 
                ogb50     LIKE ogb_file.ogb12,
                ogb51     LIKE ogb_file.ogb12,
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t,
                ogb41     LIKE ogb_file.ogb41,
                ogb19     LIKE ogb_file.ogb19,
                oga02_2   LIKE oga_file.oga02,   #add by huanglf170314
                ogaud04   LIKE oga_file.ogaud04, #add by huanglf170314
                ogaud05   LIKE oga_file.ogaud05  #add by huanglf170314 
                ,ogaud03  LIKE oga_file.ogaud03  #add by qianyuan170420
                ,ogaud01  LIKE oga_file.ogaud01  #add by qianyuan170420
                         END RECORD
   DEFINE g_oga_attr     DYNAMIC ARRAY OF RECORD
                oea00     STRING,   
                ogb31     STRING,
                ogb32     STRING,
                oea10     STRING,
                oga011    STRING,
                oga00     STRING,
                oga08     STRING,
                oga01     STRING,
                oga02     STRING,
                oga03     STRING,
                oga032    STRING,
                oha48     STRING,   #darcy:2024/01/30 add
                occ03     STRING,   #FUN-D10105
                oca02     STRING,   #FUN-D10105
                oga04     STRING,
                occ02     STRING,
                oga14     STRING,
                gen02     STRING,
                oga15     STRING,
                gem02     STRING,
                oga23     STRING,
                oga21     STRING,
                oga211    STRING,
                oga213    STRING,
                oga65     STRING,
                oga10     STRING,
                ogaconf   STRING,
                oga55     STRING,
                ogapost   STRING,
                ogb03     STRING,
                ogb04     STRING,
                ogb06     STRING,
                ima021    STRING,
                ima131    STRING,    #FUN-D10105
                oba02     STRING,    #FUN-D10105
                ogb11     STRING,
                ogb17     STRING,
                ogb09     STRING,
                ogb091    STRING,
                ogb092    STRING,
                ogb05     STRING,
                ogb12     STRING,
                ogb13     STRING,
                ogb13e    STRING,
                ogb14t    STRING,
                ogb14t_2  STRING,
                ogb14t_o  STRING, 
                ogb50     STRING,
                ogb51     STRING,
                omb12     STRING,
                omb14t    STRING,
                ogb41     STRING,
                ogb19     STRING,
                oga02_2   STRING, #add by huanglf170314
                ogaud04   STRING, #add by huanglf170314
                ogaud05   STRING  #add by huanglf170314
                ,ogaud03  STRING  #add by qianyuan170420
                ,ogaud01  STRING  #add by qianyuan170420
                         END RECORD
    DEFINE g_oga_1          DYNAMIC ARRAY OF RECORD  
                oga00     LIKE oga_file.oga00,
                oga08     LIKE oga_file.oga08,
                oga02     LIKE oga_file.oga02,
                oga03     LIKE oga_file.oga03,
                oga032    LIKE oga_file.oga032,
                occ03     LIKE occ_file.occ03,   #FUN-D10105
                oca02     LIKE oca_file.oca02,   #FUN-D10105
                oga04     LIKE oga_file.oga04,
                occ02     LIKE occ_file.occ02,
                oga14     LIKE oga_file.oga14,
                gen02     LIKE gen_file.gen02,
                oga15     LIKE oga_file.oga15,
                gem02     LIKE gem_file.gem02,
                ogb04     LIKE ogb_file.ogb04,
                ogb06     LIKE ogb_file.ogb06,
                ima021    LIKE ima_file.ima021,
                ima131    LIKE ima_file.ima131,   #FUN-D10105
                oba02     LIKE oba_file.oba02,    #FUN-D10105
                oga23     LIKE oga_file.oga23,
                ogb12     LIKE ogb_file.ogb12,
                ogb14t    LIKE ogb_file.ogb14t,
                ogb14t_2  LIKE ogb_file.ogb14t,  #add by huanglf170204
                ogb14t_o  LIKE ogb_file.ogb14t,               
                ogb50     LIKE ogb_file.ogb12,
                ogb51     LIKE ogb_file.ogb12,                
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t
                         END RECORD
   TYPE sr1_t            RECORD  
                oea00     LIKE oea_file.oea00,
                ogb31     LIKE ogb_file.ogb31,
                ogb32     LIKE ogb_file.ogb32,
                oea10     LIKE oea_file.oea10,
                oga011    LIKE oga_file.oga011,
                oga00     LIKE oga_file.oga00,           
                oga08     LIKE oga_file.oga08,
                oga01     LIKE oga_file.oga01,
                oga02     LIKE oga_file.oga02,
                oga03     LIKE oga_file.oga03,                     
                oga032    LIKE oga_file.oga032,
                oha48     like oha_file.oha48,   #darcy:2024/01/30 add
                occ03     LIKE occ_file.occ03,   #FUN-D10105
                oca02     LIKE oca_file.oca02,   #FUN-D10105
                oga04     LIKE oga_file.oga04,
                occ02     LIKE occ_file.occ02,
                oga14     LIKE oga_file.oga14,
                gen02     LIKE gen_file.gen02,
                oga15     LIKE oga_file.oga15,
                gem02     LIKE gem_file.gem02,
                oga23     LIKE oga_file.oga23,
                oga21     LIKE oga_file.oga21,
                oga211    LIKE oga_file.oga211,
                oga213    LIKE oga_file.oga213,
                oga65     LIKE oga_file.oga65,                
                oga10     LIKE oga_file.oga10,
                ogaconf   LIKE oga_file.ogaconf,
                oga55     LIKE oga_file.oga55,
                ogapost   LIKE oga_file.ogapost,
                ogb03     LIKE ogb_file.ogb03,
                ogb04     LIKE ogb_file.ogb04,
                ogb06     LIKE ogb_file.ogb06,
                ima021    LIKE ima_file.ima021,
                ima131    LIKE ima_file.ima131,   #FUN-D10105
                oba02     LIKE oba_file.oba02,    #FUN-D10105
                ogb11     LIKE ogb_file.ogb11,
                ogb17     LIKE ogb_file.ogb17,
                ogb09     LIKE ogb_file.ogb09,
                ogb091    LIKE ogb_file.ogb091,
                ogb092    LIKE ogb_file.ogb092,
                ogb05     LIKE ogb_file.ogb05,
                ogb12     LIKE ogb_file.ogb12,
                ogb13     LIKE ogb_file.ogb13,
                ogb13e    LIKE ogb_file.ogb13,
                ogb14t    LIKE ogb_file.ogb14t,
                ogb14t_2  LIKE ogb_file.ogb14t,#add by huanglf170204
                ogb14t_o  LIKE ogb_file.ogb14t, 
                ogb50     LIKE ogb_file.ogb12,
                ogb51     LIKE ogb_file.ogb12,
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t,
                ogb41     LIKE ogb_file.ogb41,
                ogb19     LIKE ogb_file.ogb19,
                oga02_2   LIKE oga_file.oga02,   #add by huanglf170314
                ogaud04   LIKE oga_file.ogaud04, #add by huanglf170314
                ogaud05   LIKE oga_file.ogaud05, #add by huanglf170314 
                ogaud03  LIKE oga_file.ogaud03,  #add by qianyuan170420
                ogaud01  LIKE oga_file.ogaud01,  #add by qianyuan170420
                oga24     LIKE oga_file.oga24,
                type      LIKE type_file.chr1
                         END RECORD
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    
   DEFINE l_ac,l_ac1     LIKE type_file.num5                                                                                        
   DEFINE g_tot_qty      LIKE type_file.num20_6      #出貨數量總計
   DEFINE g_tot_sum      LIKE type_file.num20_6      #出貨本幣金額總計
   DEFINE g_tot_ori_sum  LIKE type_file.num20_6      #出貨原幣金額總計
   DEFINE g_tot_ws_sum   LIKE type_file.num20_6      #本币未税金额合计
   DEFINE g_tot_qty1     LIKE type_file.num20_6      #出貨數量總計
   DEFINE g_tot_sum1     LIKE type_file.num20_6      #出貨本幣金額總計
   DEFINE g_tot_ori_sum1 LIKE type_file.num20_6      #出貨原幣金額總計
   DEFINE g_tot_ws_sum1  LIKE type_file.num20_6      #本币未税金额合计
   DEFINE g_cmd          LIKE type_file.chr1000  
   DEFINE g_rec_b2       LIKE type_file.num10   
   DEFINE g_flag         LIKE type_file.chr1 
   DEFINE g_action_flag  LIKE type_file.chr100
   DEFINE g_wc1,g_wc2,g_wc3,g_wc4,g_wc5,g_wc6,g_wc7,g_wc8 STRING
   DEFINE   w    ui.Window      
   DEFINE   f    ui.Form       
   DEFINE   page om.DomNode 
     
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("axm")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q003_w AT 5,10
        WITH FORM "axm/42f/axmq003" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   CALL cl_set_act_visible("revert_filter",FALSE)
   CALL q003_table()  #FUN-D10105 add
   CALL q003_q()  
   LET g_action_flag = "page1"
   CALL q003_menu()
   DROP TABLE axmq003_tmp;
   CLOSE WINDOW q003_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q003_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
   DEFINE   l_msg   STRING   

   WHILE TRUE
      IF cl_null(g_action_choice) THEN
         IF g_action_flag = "page1" THEN
            CALL q003_bp("G")
         END IF
         IF g_action_flag = "page2" THEN
            CALL q003_bp2()
         END IF
      END IF
      CASE g_action_choice
         WHEN "page1"
            CALL q003_bp("G")
         
         WHEN "page2"
            CALL q003_bp2()
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q003_q()    
            END IF    
            LET g_action_choice = " "
         WHEN "data_filter"       #資料過濾
            IF cl_chk_act_auth() THEN
               CALL q003_filter_askkey()
               CALL q003()        #重填充新臨時表
               CALL q003_show()
            END IF            
            LET g_action_choice = " "
         WHEN "revert_filter"     # 過濾還原
            IF cl_chk_act_auth() THEN
               LET g_filter_wc = ''
               LET g_filter_wc1 = ''
               LET g_filter_wc2 = ''
               LET g_qbe_oga011_f = NULL
               LET g_qbe_oga65_f = NULL
               LET g_qbe_ogb11_f = NULL
               LET g_qbe_ogb17_f = NULL
               LET g_qbe_ogb50_f = NULL
               LET g_qbe_ogb51_f = NULL
               LET g_qbe_ogb41_f = NULL
               LET g_qbe_oga00_f = NULL
               CALL cl_set_act_visible("revert_filter",FALSE) 
               CALL q003()        #重填充新臨時表
               CALL q003_show() 
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
         WHEN "exporttoexcel"     #匯出Excel
            IF cl_chk_act_auth() THEN
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_action_flag 
                  WHEN 'page1'
                     LET page = f.FindNode("Page","page1")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_oga_excel),'','')
                  WHEN 'page2'
                     LET page = f.FindNode("Page","page2")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_oga_1),'','')
               END CASE
            END IF
            LET g_action_choice = " "
         #darcy:2024/01/30 add s---
         when "fastexcel"
            let w = ui.window.getcurrent()
            let f = w.getform()
            call cl_download_by_explorer(
               cl_expexcel(
                     "s_oga",base.typeinfo.create(g_oga_excel),
                     "s_oga_1",base.typeinfo.create(g_oga_1), 
                     "",""
               )) 
            let g_action_choice = " "
         #darcy:2024/01/30 add e---
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "oga01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
            LET g_action_choice = " "
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q003_b_fill()
   DEFINE l_oga24       LIKE oga_file.oga24
   DEFINE l_type        LIKE type_file.chr1
   DEFINE l_oga01_t     LIKE oga_file.oga01
   DEFINE l_ogb03_t     LIKE ogb_file.ogb03
   DEFINE l_ogb04       LIKE ogb_file.ogb04
   DEFINE l_ogb06       LIKE ogb_file.ogb06
   DEFINE l_ogb12       LIKE ogb_file.ogb12
   DEFINE l_ogb09       LIKE ogb_file.ogb09
   DEFINE l_ogb091      LIKE ogb_file.ogb091
   DEFINE l_ogb092      LIKE ogb_file.ogb092
   DEFINE l_oga213      LIKE oga_file.oga213  #lixh1 20121031
   DEFINE l_oga65       LIKE oga_file.oga65
   DEFINE l_ogapost     LIKE oga_file.ogapost
   DEFINE l_ogb17       LIKE ogb_file.ogb17
   DEFINE l_ogb19       LIKE ogb_file.ogb19
DEFINE l_lz LIKE type_file.num5#add by gupx 20170331
DEFINE l_oga01 LIKE oga_file.oga01#add by gupx 20170331
DEFINE l_oga065 LIKE oga_file.oga65#add by gupx 20170331
   #LET g_sql = "SELECT * FROM axmq003_tmp ",     #mark by wangxy 10121120

   #modify by wangxy 20121120 - begin
   LET g_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
               "        oga00,oga08,oga01,oga02,oga03,",
               "        oga032,oha48,occ03,oca02,oga04,occ02,oga14,gen02,",      #FUN-D10105 #darcy:2024/01/30 add oha48
               "        oga15,gem02,oga23,oga21,oga211,",
               "        oga213,oga65,oga10,ogaconf,oga55,",
               "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02, ",  #FUN-D10105
               "        ogb11,ogb17,ogb09,ogb091,ogb092,",
               "        ogb05,ogb12,ogb13,ogb13e,ogb14t,ogb14t_2,ogb14t_o,",  #add by huanglf170204
               "        ogb50,ogb51,omb12,omb14t,ogb41,",
               "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ",  #oga02,ogaud04,ogaud05 add by huanglf170314   #ogaud03,ogaud01 add by qianyuan170420
               "   FROM axmq003_tmp ",
   #modify by wangxy 20121120 - end  
               " ORDER BY oga00,oga08,oga01,ogb03,oga02,oga03,oga032,",
               "          oga04,occ02,oga14,gen02,oga15,gem02,ogb14t desc,ogb14t_2 desc,ogb14t_o desc " #add by huanglf170204  #lixh121107 add
               #       "  oga04,occ02,oga14,gen02,oga15,gem02,", #lixh121107 mark
               #       "  ogb04,ogb06,ima021"                    #lixh121107 mark


   PREPARE axmq003_pb FROM g_sql
   DECLARE oga_curs  CURSOR FOR axmq003_pb        #CURSOR


   CALL g_oga.clear()
   CALL g_oga_excel.clear()
   CALL g_oga_attr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   LET l_oga01_t = NULL
   LET l_ogb03_t = NULL
   LET l_type = NULL 
   LET g_tot_qty1 = 0
   LET g_tot_sum1 = 0
   LET g_tot_ori_sum1 = 0
   LET g_tot_ws_sum1 = 0  #add by huanglf170209

   FOREACH oga_curs INTO g_oga_excel[g_cnt].*,l_oga24,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_tot_qty1 = g_tot_qty1 + g_oga_excel[g_cnt].ogb12
       #LET g_tot_sum1 = g_tot_sum1 + g_oga_excel[g_cnt].ogb14t_o     #lihx1
       #LET g_tot_ori_sum1 = g_tot_ori_sum1 + g_oga_excel[g_cnt].ogb14t #lixh1
#add by gupx 20170331----------------------------------s--------------因为账单编号来源于单头档，单身项次有的没立账也会带出，所以修正。
#1.根据出货单号确认出货单是否需要签收(oga65=Y表示这个出货单要签收 否则就是不要签收)
#2.若出货单需要签收，则检查是否有签收单，没有签收单，则肯定不会有立账；有签收单，根据签收单确认是否在axmt670中立账
#3.若出货单不需要签收，则直接以出货单号检查是否已在axmt670里中立账

#第一步：根据出货单号查询oga65看是否走出货签收.

LET l_lz=0
LET l_oga065='N'
SELECT oga65  INTO l_oga065 FROM oga_file WHERE oga01=g_oga_excel[g_cnt].oga01
#第一步：根据出货单号查询oga65看是否走出货签收.

#第二步：如果走就是根据出货单找到签收单号，项次一样不用查，最后和axmt670中的omf11和对应omf12。
  IF l_oga065='Y' THEN 
      SELECT oga01 INTO l_oga01 FROM oga_file WHERE oga011=g_oga_excel[g_cnt].oga01 AND oga09='8'
       #可能走出货签收，但是没做签收没签收单号，。这样下面肯定查询不到，所以不再单独写判断。
      SELECT count(*) INTO l_lz FROM omf_file WHERE omf11=l_oga01 AND omf12=g_oga_excel[g_cnt].ogb03
         IF l_lz<1 THEN 
          LET g_oga_excel[g_cnt].oga10=''
         END IF 
  ELSE 
      SELECT count(*) INTO l_lz  FROM omf_file WHERE omf11=g_oga_excel[g_cnt].oga01 AND omf12=g_oga_excel[g_cnt].ogb03
       IF l_lz<1 THEN 
          LET g_oga_excel[g_cnt].oga10=''
         END IF 
      
  END IF 
#第二步：如果走就是根据出货单找到签收单号，项次一直不用查，最后和axmt670中的omf11和对应omf12。


#add by gupx 20170331----------------------------------s--------------因为账单编号来源于单头档，单身项次有的没立账也会带出，所以修正。

      IF g_oga_excel[g_cnt].ogb17 = 'Y' THEN   #多倉儲批出貨
         IF (cl_null(l_oga01_t) AND cl_null(l_ogb03_t)) OR 
            (g_oga_excel[g_cnt].oga01 <> l_oga01_t OR g_oga_excel[g_cnt].ogb03 <> l_ogb03_t) THEN
            LET l_oga01_t = g_oga_excel[g_cnt].oga01 
            LET l_ogb03_t = g_oga_excel[g_cnt].ogb03
         ELSE
            LET l_ogb04 = g_oga_excel[g_cnt].ogb04
            LET l_ogb06 = g_oga_excel[g_cnt].ogb06
            LET l_ogb09 = g_oga_excel[g_cnt].ogb09
            LET l_ogb091 = g_oga_excel[g_cnt].ogb091
            LET l_ogb092 = g_oga_excel[g_cnt].ogb092       
            LET l_ogb12 = g_oga_excel[g_cnt].ogb12
            LET l_oga213 = g_oga_excel[g_cnt].oga213
            LET l_oga65 = g_oga_excel[g_cnt].oga65
            LET l_ogapost = g_oga_excel[g_cnt].ogapost
            LET l_ogb17 = g_oga_excel[g_cnt].ogb17
            LET l_ogb19 = g_oga_excel[g_cnt].ogb19
            INITIALIZE g_oga_excel[g_cnt].* TO NULL
            LET g_oga_excel[g_cnt].ogb04 = l_ogb04
            LET g_oga_excel[g_cnt].ogb06 = l_ogb06
            LET g_oga_excel[g_cnt].ogb09 = l_ogb09
            LET g_oga_excel[g_cnt].ogb091 = l_ogb091
            LET g_oga_excel[g_cnt].ogb092 = l_ogb092
            LET g_oga_excel[g_cnt].ogb12 = l_ogb12 
            LET g_oga_excel[g_cnt].oga213 = l_oga213
            LET g_oga_excel[g_cnt].oga65 = l_oga65
            LET g_oga_excel[g_cnt].ogapost = l_ogapost
            LET g_oga_excel[g_cnt].ogb17 = l_ogb17
            LET g_oga_excel[g_cnt].ogb19 = l_ogb19   
         END IF
      END IF   
     IF NOT cl_null(g_oga_excel[g_cnt].ogb14t) THEN   #lixh1
        LET g_tot_ori_sum1 = g_tot_ori_sum1 + g_oga_excel[g_cnt].ogb14t
     END IF
     IF NOT cl_null(g_oga_excel[g_cnt].ogb14t_o) THEN
        LET g_tot_sum1 = g_tot_sum1 + g_oga_excel[g_cnt].ogb14t_o
     END IF
    #str---add by huanglf170209
     IF NOT cl_null(g_oga_excel[g_cnt].ogb14t_2) THEN
        LET g_tot_ws_sum1 = g_tot_ws_sum1 + g_oga_excel[g_cnt].ogb14t_2
     END IF
    #str---end by huanglf170209
     SELECT ima021 INTO g_oga_excel[g_cnt].ima021 FROM ima_file #add by MOD-D10133  13/01/15
      WHERE ima01 = g_oga_excel[g_cnt].ogb04 
      IF l_type = 'Y' THEN           #銷退
         CALL q003_color()
      END IF

      IF g_cnt < = g_max_rec THEN
         LET g_oga[g_cnt].* = g_oga_excel[g_cnt].*
      END IF
      LET g_cnt = g_cnt + 1

   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_oga.deleteElement(g_cnt)
   END IF
   CALL g_oga_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec AND (g_bgjob = 'N' OR cl_null(g_bgjob)) THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt 
END FUNCTION

FUNCTION q003_b_fill_2()
#  DEFINE l_oga_excel    DYNAMIC ARRAY OF RECORD
#               oea00     LIKE oea_file.oea00,
#               ogb31     LIKE ogb_file.ogb31,
#               ogb32     LIKE ogb_file.ogb32,
#               oea10     LIKE oea_file.oea10,
#               oga011    LIKE oga_file.oga011,
#               oga00     LIKE oga_file.oga00,
#               oga08     LIKE oga_file.oga08,
#               oga01     LIKE oga_file.oga01,
#               oga02     LIKE oga_file.oga02,
#               oga03     LIKE oga_file.oga03,
#               oga032    LIKE oga_file.oga032,
#               oga04     LIKE oga_file.oga04,
#               occ02     LIKE occ_file.occ02,
#               oga14     LIKE oga_file.oga14,
#               gen02     LIKE gen_file.gen02,
#               oga15     LIKE oga_file.oga15,
#               gem02     LIKE gem_file.gem02,
#               oga23     LIKE oga_file.oga23,
#               oga21     LIKE oga_file.oga21,
#               oga211    LIKE oga_file.oga211,
#               oga213    LIKE oga_file.oga213,
#               oga65     LIKE oga_file.oga65,
#               oga10     LIKE oga_file.oga10,
#               ogaconf   LIKE oga_file.ogaconf,
#               oga55     LIKE oga_file.oga55,
#               ogapost   LIKE oga_file.ogapost,
#               ogb03     LIKE ogb_file.ogb03,
#               ogb04     LIKE ogb_file.ogb04,
#               ogb06     LIKE ogb_file.ogb06,
#               ima021    LIKE ima_file.ima021,
#               ogb11     LIKE ogb_file.ogb11,
#               ogb17     LIKE ogb_file.ogb17,
#               ogb09     LIKE ogb_file.ogb09,
#               ogb091    LIKE ogb_file.ogb091,
#               ogb092    LIKE ogb_file.ogb092,
#               ogb05     LIKE ogb_file.ogb05,
#               ogb12     LIKE ogb_file.ogb12,
#               ogb13     LIKE ogb_file.ogb13,
#               ogb14t    LIKE ogb_file.ogb14t,
#               ogb14t_o  LIKE ogb_file.ogb14t,
#               ogb50     LIKE ogb_file.ogb12,
#               ogb51     LIKE ogb_file.ogb12,
#               omb12     LIKE omb_file.omb12,
#               omb14t    LIKE omb_file.omb14t,
#               ogb41     LIKE ogb_file.ogb41,
#               ogb19     LIKE ogb_file.ogb19
#                        END RECORD
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_oga01_t     LIKE oga_file.oga01
   DEFINE l_ogb03_t     LIKE ogb_file.ogb03
   define  l_oga24      LIKE oga_file.oga24
   DEFINE  l_type       LIKE type_file.chr1   

   CALL g_oga_1.clear()
   LET g_rec_b2 = 0
   LET g_cnt = 1
   LET g_tot_qty = 0
   LET g_tot_sum = 0
   LET g_tot_ori_sum = 0
   LET g_tot_ws_sum = 0 #add by huanglf170209

   SELECT SUM(ogb12),SUM(ogb14t_o),SUM(ogb14t),SUM(ogb14t_2) 
   INTO g_tot_qty,g_tot_sum,g_tot_ori_sum,g_tot_ws_sum
     FROM axmq003_tmp
#  LET g_sql = "SELECT * FROM axmq003_tmp ",
#              " ORDER BY oga00,oga08,oga01,ogb03,oga02,oga03,oga032,",
#                      "  oga04,occ02,oga14,gen02,oga15,gem02,",
#              #       "  ogb04,ogb06,ima021"


#  PREPARE axmq003_pb1 FROM g_sql
#  DECLARE oga_curs1  CURSOR FOR axmq003_pb1        #CURSOR


#  LET l_oga01_t = NULL
#  LET l_ogb03_t = NULL
#  LET l_type = NULL 

#  LET l_cnt=1
#  FOREACH oga_curs1 INTO l_oga_excel[l_cnt].*,l_oga24,l_type


#     IF l_oga_excel[l_cnt].ogb17 = 'Y' THEN   #多倉儲批出貨
#        IF (cl_null(l_oga01_t) AND cl_null(l_ogb03_t)) OR 
#           (l_oga_excel[l_cnt].oga01 <> l_oga01_t OR l_oga_excel[l_cnt].ogb03 <> l_ogb03_t) THEN
#           LET l_oga01_t = l_oga_excel[l_cnt].oga01 
#           LET l_ogb03_t = l_oga_excel[l_cnt].ogb03
#        ELSE
#           LET l_oga_excel[l_cnt].ogb14t_o =0
#           LET l_oga_excel[l_cnt].ogb14t =0
#        END IF
#     END IF   
#    IF NOT cl_null(l_oga_excel[l_cnt].ogb14t) THEN   #lixh1
#       LET g_tot_ori_sum = g_tot_ori_sum + l_oga_excel[l_cnt].ogb14t
#    END IF
#    IF NOT cl_null(l_oga_excel[l_cnt].ogb14t_o) THEN
#       LET g_tot_sum = g_tot_sum + l_oga_excel[l_cnt].ogb14t_o
#    END IF
#    LET l_cnt=l_cnt+1
#  END FOREACH
   
   DISPLAY g_tot_qty TO FORMONLY.tot_qty
   DISPLAY g_tot_sum TO FORMONLY.tot_sum
   DISPLAY g_tot_ori_sum TO FORMONLY.tot_ori_sum
   DISPLAY g_tot_ws_sum TO FORMONLY.tot_ws_sum  #add by huanglf170209
   CALL q003_get_sum()
     
END FUNCTION


FUNCTION q003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_flag = 'page1'
   IF g_action_choice = "page1" AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      CALL q003_b_fill()
   END IF
   
   LET g_action_choice = " "
   LET g_flag = ' '
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME tm.a
   DISPLAY g_tot_qty1 TO FORMONLY.tot_qty1
   DISPLAY g_tot_sum1 TO FORMONLY.tot_sum1
   DISPLAY g_tot_ori_sum1 TO FORMONLY.tot_ori_sum1
   DISPLAY g_tot_ws_sum1 TO FORMONLY.tot_ws_sum1  #add by huanglf170209
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         BEFORE INPUT
            CALL DIALOG.setArrayAttributes("s_oga",g_oga_attr)    #参数：屏幕变量,属性数组
            CALL ui.Interface.refresh()
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q003_b_fill_2()
               CALL q003_set_visible()
               CALL cl_set_comp_visible("page1", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               LET g_action_choice = "page2"
            ELSE
               CALL q003_b_fill()
               CALL g_oga_1.clear()
               DISPLAY 0 TO FORMONLY.cnt1
               DISPLAY g_tot_qty1 TO FORMONLY.tot_qty1
               DISPLAY g_tot_sum1 TO FORMONLY.tot_sum1
               DISPLAY g_tot_ori_sum1 TO FORMONLY.tot_ori_sum1
               DISPLAY g_tot_ws_sum1 TO FORMONLY.tot_ws_sum1  #add by huanglf170209
            END IF
            DISPLAY BY NAME tm.a
            EXIT DIALOG
            DISPLAY g_tot_qty1 TO FORMONLY.tot_qty1
            DISPLAY g_tot_sum1 TO FORMONLY.tot_sum1
            DISPLAY g_tot_ori_sum1 TO FORMONLY.tot_ori_sum1
            DISPLAY g_tot_ws_sum1 TO FORMONLY.tot_ws_sum1 #add by huanglf170209
      END INPUT
      DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL DIALOG.setArrayAttributes("s_oga",g_oga_attr)    #参数：屏幕变量,属性数组
            CALL ui.Interface.refresh() 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
               DISPLAY g_tot_qty TO FORMONLY.tot_qty1
               DISPLAY g_tot_sum TO FORMONLY.tot_sum1
               DISPLAY g_tot_ori_sum TO FORMONLY.tot_ori_sum1
               DISPLAY g_tot_ws_sum1 TO FORMONLY.tot_ws_sum1  #add by huanglf170209
      END DISPLAY

      ON ACTION page2
         LET g_action_choice = 'page2'
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG      
 
      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
         EXIT DIALOG
   
      ON ACTION data_filter
         LET g_action_choice="data_filter"
         EXIT DIALOG     

      ON ACTION revert_filter         
         LET g_action_choice="revert_filter"
         EXIT DIALOG 

      ON ACTION refresh_detail          #明細資料刷新
         #CALL q003_b_fill()  #FUN-D10105 mark
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
      #darcy:2024/01/30 add s---
      on action fastexcel
         let g_action_choice = 'fastexcel'
         exit dialog
      #darcy:2024/01/30 add e---

      ON ACTION related_document 
         LET g_action_choice="related_document"          
         EXIT DIALOG

      AFTER DIALOG
         CONTINUE DIALOG

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")
      &include "qry_string.4gl"
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q003_bp2()
       
   LET g_flag = ' '
   LET g_action_flag = 'page2'
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL q003_b_fill_2()
   DISPLAY  tm.a TO a
   DISPLAY g_tot_qty TO FORMONLY.tot_qty
   DISPLAY g_tot_sum TO FORMONLY.tot_sum
   DISPLAY g_tot_ori_sum TO FORMONLY.tot_ori_sum
   DISPLAY g_tot_ws_sum TO FORMONLY.tot_ws_sum #add by huanglf170209
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS)
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN 
               CALL q003_b_fill_2()
               CALL q003_set_visible()
               LET g_action_choice = "page2"
            ELSE
               CALL q003_b_fill()
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page2", TRUE)
               LET g_action_choice = "page1"
               CALL g_oga_1.clear()
               DISPLAY 0 TO FORMONLY.cnt1
               DISPLAY 0,0,0 TO FORMONLY.tot_qty,FORMONLY.tot_sum,FORMONLY.tot_ori_sum 
            END IF
            DISPLAY  tm.a TO a
            EXIT DIALOG
      END INPUT
      DISPLAY ARRAY g_oga_1 TO s_oga_1.* ATTRIBUTE(COUNT=g_rec_b2)
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
            CALL q003_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page2", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page2", TRUE)
            LET g_action_choice= "page1"  
            LET g_flag = '1'             
            EXIT DIALOG 
         END IF
   

      ON ACTION refresh_detail
         #CALL q003_b_fill()  #FUN-D10105 mark
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
      
      #darcy:2024/01/30 add s---
      on action fastexcel
         let g_action_choice = 'fastexcel'
         exit dialog
      #darcy:2024/01/30 add e---

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

FUNCTION q003_cs()
   DEFINE  l_cnt           LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01     
   DEFINE  li_chk_bookno   LIKE type_file.num5
 
   CLEAR FORM   #清除畫面
   CALL g_oga.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition 
   LET g_qbe_oga011 = NULL
   LET g_qbe_oga65 = NULL
   LET g_qbe_ogb11 = NULL
   LET g_qbe_ogb17 = NULL
   LET g_qbe_ogb50 = NULL
   LET g_qbe_ogb51 = NULL
   LET g_qbe_ogb41 = NULL
   LET g_qbe_oga00 = NULL
   LET g_qbe_oga011_f = NULL
   LET g_qbe_oga65_f = NULL
   LET g_qbe_ogb11_f = NULL
   LET g_qbe_ogb17_f = NULL
   LET g_qbe_ogb50_f = NULL
   LET g_qbe_ogb51_f = NULL
   LET g_qbe_ogb41_f = NULL
   LET g_qbe_oga00_f = NULL   
   LET g_filter_wc  = ' 1=1'  #TQC-D50098
   LET g_filter_wc1 = ' 1=1'  #TQC-D50098
   LET g_filter_wc2 = ' 1=1'  #TQC-D50098
   LET g_wc1 = NULL
   LET g_wc2 = NULL
   LET g_wc3 = NULL
   LET g_wc4 = NULL
   LET g_wc5 = NULL
   LET g_wc6 = NULL
   LET g_wc7 = NULL
   LET g_wc8 = NULL
   LET tm.a = '4'   
   #FUN-D10105--add--str--
   CALL cl_set_comp_visible("page2", FALSE)
   CALL ui.interface.refresh()
   CALL cl_set_comp_visible("page2", TRUE)
   #FUN-D10105--add--end--
   CALL cl_set_act_visible("revert_filter",FALSE) #FUN-D10105 add
   DIALOG ATTRIBUTE(UNBUFFERED)    
      INPUT BY NAME tm.a ATTRIBUTE(WITHOUT DEFAULTS)
        
         BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)    
         END INPUT

         CONSTRUCT tm.wc2 ON oea00,ogb31,ogb32,oea10,oga011,oga00,oga08,oga01,oga02,oga03,oga032,occ03,oga04,     #FUN-D10105 occ03
                             oga14,oga15,oga23,oga21, oga211,oga213,oga65,oga10,ogaconf,
                             oga55,ogapost,ogb03,ogb04,ima131,ogb11,ogb17,ogb09,ogb091,ogb092,ogb05,ogb12, ogb13,  #FUN-D10105 ima131
                          #  ogb14t,ogb50,ogb51,ogb41,ogb19
                             ogb14t,ogb41,ogb19,ogaud04,ogaud05,ogaud03  #add by huanglf170314   #,ogaud03 add by qianyuan170420

                        FROM s_oga[1].oea00, s_oga[1].ogb31,  s_oga[1].ogb32, s_oga[1].oea10, s_oga[1].oga011,s_oga[1].oga00,
                             s_oga[1].oga08, s_oga[1].oga01,  s_oga[1].oga02, s_oga[1].oga03, s_oga[1].oga032,s_oga[1].occ03,  #FUN-D10105 occ03
                             s_oga[1].oga04, s_oga[1].oga14, s_oga[1].oga15,  s_oga[1].oga23,
                             s_oga[1].oga21, s_oga[1].oga211, s_oga[1].oga213,s_oga[1].oga65, s_oga[1].oga10, s_oga[1].ogaconf,
                             s_oga[1].oga55, s_oga[1].ogapost,s_oga[1].ogb03, s_oga[1].ogb04, s_oga[1].ima131, s_oga[1].ogb11,   #FUN-D10105 ima131
                             s_oga[1].ogb17, s_oga[1].ogb09, s_oga[1].ogb091,s_oga[1].ogb092, s_oga[1].ogb05, s_oga[1].ogb12, 
                           # s_oga[1].ogb14t,s_oga[1].ogb50, s_oga[1].ogb51,  s_oga[1].ogb41, s_oga[1].ogb19
                             s_oga[1].ogb13, s_oga[1].ogb14t,s_oga[1].ogb41, s_oga[1].ogb19,s_oga[1].ogaud04,s_oga[1].ogaud05  #add by huanglf170314
                             ,s_oga[1].ogaud03        #add by qianyuan170420

              
            BEFORE CONSTRUCT
               CALL cl_qbe_init()

            AFTER FIELD oga011
               CALL GET_FLDBUF(oga011) RETURNING g_qbe_oga011              
	 
            AFTER FIELD oga00 
               CALL GET_FLDBUF(oga00) RETURNING g_qbe_oga00

            AFTER FIELD oga65
               CALL GET_FLDBUF(oga65) RETURNING g_qbe_oga65

            AFTER FIELD ogb11
               CALL GET_FLDBUF(ogb11) RETURNING g_qbe_ogb11
           
            AFTER FIELD ogb17
               CALL GET_FLDBUF(ogb17) RETURNING g_qbe_ogb17

#           AFTER FIELD ogb50
#              CALL GET_FLDBUF(ogb50) RETURNING g_qbe_ogb50

#           AFTER FIELD ogb51
#              CALL GET_FLDBUF(ogb51) RETURNING g_qbe_ogb51

            AFTER FIELD ogb41
               CALL GET_FLDBUF(ogb41) RETURNING g_qbe_ogb41

         END CONSTRUCT
         #出貨單欄位
#        CONSTRUCT BY NAME g_wc1 ON oga011
#           AFTER FIELD oga011
#              CALL GET_FLDBUF(oga011) RETURNING g_qbe_oga011
#              NEXT FIELD oga00

#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

#        CONSTRUCT BY NAME g_wc8 ON oga00
#           AFTER FIELD oga00
#              CALL GET_FLDBUF(oga00) RETURNING g_qbe_oga00
#              NEXT FIELD oga08

#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

#        CONSTRUCT BY NAME g_wc2 ON oga65
#           AFTER FIELD oga65
#              CALL GET_FLDBUF(oga65) RETURNING g_qbe_oga65
#              NEXT FIELD oga10
         
#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

#        CONSTRUCT BY NAME g_wc3 ON ogb11
#           AFTER FIELD ogb11
#              CALL GET_FLDBUF(ogb11) RETURNING g_qbe_ogb11
#              NEXT FIELD ogb17

#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

#        CONSTRUCT BY NAME g_wc4 ON ogb17
#           AFTER FIELD ogb17
#              CALL GET_FLDBUF(ogb17) RETURNING g_qbe_ogb17
#              NEXT FIELD ogb09

#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

#        CONSTRUCT BY NAME g_wc5 ON ogb50
#           AFTER FIELD ogb50
#              CALL GET_FLDBUF(ogb50) RETURNING g_qbe_ogb50
#              NEXT FIELD ogb51

#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

#        CONSTRUCT BY NAME g_wc6 ON ogb51
#           AFTER FIELD ogb51
#              CALL GET_FLDBUF(ogb51) RETURNING g_qbe_ogb51
#              NEXT FIELD ogb41

#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

#        CONSTRUCT BY NAME g_wc7 ON ogb41
#           AFTER FIELD ogb41
#              CALL GET_FLDBUF(ogb41) RETURNING g_qbe_ogb41
#              NEXT FIELD ogb19
#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#        END CONSTRUCT

         ON ACTION controlp
            CASE
               WHEN INFIELD(ogb31)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oea03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ogb31
                  NEXT FIELD ogb31
            WHEN INFIELD(oea10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oea10_1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea10
                 NEXT FIELD oea10
             WHEN INFIELD(oga03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF g_aza.aza50='Y' THEN
                     LET g_qryparam.form ="q_occ3"
                  ELSE
                     LET g_qryparam.form ="q_occ"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga03
                  NEXT FIELD oga03
             WHEN INFIELD(oga04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF g_aza.aza50='Y' THEN
                     LET g_qryparam.form ="q_occ4"
                  ELSE
                     LET g_qryparam.form ="q_occ"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga04
                  NEXT FIELD oga04
             WHEN INFIELD(oga14)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gen"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga14
                NEXT FIELD oga14
             #MOD-D50172 add beg--------
             WHEN INFIELD(oga10)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_oga10_1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga10
                NEXT FIELD oga10
             #MOD-D50172 add end---------   
             WHEN INFIELD(oga15)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
             WHEN INFIELD(oga15)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
            WHEN INFIELD(oga23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga23
                 NEXT FIELD oga23
            WHEN INFIELD(oga21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN
                    LET g_qryparam.form ="q_gec9"
                 ELSE   
                    LET g_qryparam.form ="q_gec"
                 END IF 
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga21
                 NEXT FIELD oga21

               WHEN INFIELD(ogb09)
                    CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ogb09
                    NEXT FIELD ogb09

               WHEN INFIELD(ogb091)
                    CALL q_ime_1(TRUE,TRUE,g_oga[1].ogb091,g_oga[1].ogb09,"","","","","") RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ogb091
                    NEXT FIELD ogb091

            WHEN INFIELD(ogb05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogb05
                   NEXT FIELD ogb05
            WHEN INFIELD(ogb04) 
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogb04
                   NEXT FIELD ogb04

                WHEN INFIELD(ogb41)  #專案代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ogb41
                  NEXT FIELD ogb41

                WHEN INFIELD(oga011) #通知單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_oga5"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO oga011
                     NEXT FIELD oga011
                #FUN-D10105---add---str---
                WHEN INFIELD(occ03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_occ03_1"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO occ03
                     NEXT FIELD occ03
                WHEN INFIELD(ima131)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_ima131_1"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ima131
                     NEXT FIELD ima131
               #FUN-D10105---add---end---
            END CASE
       
       #FUN-D10101--mark--str--
       #ON ACTION locale
       #   CALL cl_show_fld_cont()
       #   LET g_action_choice = "locale"
       #   EXIT DIALOG
       #FUN-D10101--mark--str--
          
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      #FUN-D10105--modify--str--
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time
      #EXIT PROGRAM
      LET INT_FLAG = 0
      INITIALIZE tm.* TO NULL
      DELETE FROM axcq003_tmp
      #FUN-D10105--modify--end--
   END IF

   CALL q003()   
END FUNCTION 

FUNCTION q003_q() 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q003_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    MESSAGE ""
    CALL q003_show()
END FUNCTION

FUNCTION q003_show()
   DISPLAY tm.a TO a
   CALL q003_b_fill()    #FUN-D10105 mark
   CALL q003_b_fill_2()  #FUN-D10105 mark
   --IF cl_null(tm.a)  THEN   
      --LET g_action_choice = "page1"
      --CALL cl_set_comp_visible("page2", FALSE)
      --CALL ui.interface.refresh()
      --CALL cl_set_comp_visible("page2", TRUE)
      --LET g_action_flag = "page1"  
      --CALL q003_b_fill()    #FUN-D10105 add
   --ELSE
      --LET g_action_choice = "page2"
      --CALL cl_set_comp_visible("page1", FALSE)
      --CALL ui.interface.refresh()
      --CALL cl_set_comp_visible("page1", TRUE)
      --LET g_action_flag = "page2"  #FUN-D10105 add 
      --CALL q003_b_fill_2()  #FUN-D10105 add 
      --CALL q003_b_fill()
   --END IF
   CALL q003_set_visible()
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION q003_filter_askkey()
DEFINE l_wc   STRING
   CLEAR FORM
         CONSTRUCT l_wc ON oea00,ogb31,ogb32,oea10,oga011,oga00,oga08,oga01,oga02,oga03, oga032,occ03,oga04,       #FUN-D10105 occ03
                             oga14,oga15,oga23,oga21, oga211,oga213,oga65,oga10,ogaconf,
                             oga55,ogapost,ogb03,ogb04,ima131,ogb11,ogb17,ogb09,ogb091,ogb092,ogb05,ogb12, ogb13,  #FUN-D10105 ima131
         #                   ogb14t,ogb50,ogb51,ogb41,ogb19
                             ogb14t,ogb41,ogb19,ogaud04,ogaud05,ogaud03  #add by huanglf170314   #ogaud03  add by qianyuan170420

                        FROM s_oga[1].oea00, s_oga[1].ogb31,  s_oga[1].ogb32, s_oga[1].oea10, s_oga[1].oga011, s_oga[1].oga00,
                             s_oga[1].oga08, s_oga[1].oga01,  s_oga[1].oga02, s_oga[1].oga03, s_oga[1].oga032, s_oga[1].occ03,   #FUN-D10105 occ03
                             s_oga[1].oga04, s_oga[1].oga14, s_oga[1].oga15,  s_oga[1].oga23,
                             s_oga[1].oga21, s_oga[1].oga211, s_oga[1].oga213,s_oga[1].oga65, s_oga[1].oga10, s_oga[1].ogaconf,
                             s_oga[1].oga55, s_oga[1].ogapost,s_oga[1].ogb03, s_oga[1].ogb04, s_oga[1].ima131, s_oga[1].ogb11,   #FUN-D10105 ima131  
                             s_oga[1].ogb17, s_oga[1].ogb09, s_oga[1].ogb091,s_oga[1].ogb092, s_oga[1].ogb05, s_oga[1].ogb12,
         #                   s_oga[1].ogb14t,s_oga[1].ogb50, s_oga[1].ogb51,  s_oga[1].ogb41, s_oga[1].ogb19
                             s_oga[1].ogb13, s_oga[1].ogb14t,s_oga[1].ogb41, s_oga[1].ogb19,s_oga[1].ogaud04,s_oga[1].ogaud05  #add by huanglf170314
                             ,s_oga[1].ogaud03         #add by qianyuan170420

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

         AFTER FIELD oga011
            CALL GET_FLDBUF(oga011) RETURNING g_qbe_oga011_f

         AFTER FIELD oga00
            CALL GET_FLDBUF(oga00) RETURNING g_qbe_oga00_f

         AFTER FIELD oga65
            CALL GET_FLDBUF(oga65) RETURNING g_qbe_oga65_f

         AFTER FIELD ogb11
            CALL GET_FLDBUF(ogb11) RETURNING g_qbe_ogb11_f

         AFTER FIELD ogb17
            CALL GET_FLDBUF(ogb17) RETURNING g_qbe_ogb17_f

#        AFTER FIELD ogb50
#           CALL GET_FLDBUF(ogb50) RETURNING g_qbe_ogb50_f

#        AFTER FIELD ogb51
#           CALL GET_FLDBUF(ogb51) RETURNING g_qbe_ogb51_f

         AFTER FIELD ogb41
            CALL GET_FLDBUF(ogb41) RETURNING g_qbe_ogb41_f
             
         ON ACTION controlp
            CASE
               WHEN INFIELD(ogb31)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_oea03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ogb31
                  NEXT FIELD ogb31
            WHEN INFIELD(oea10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_oea10_1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea10
                 NEXT FIELD oea10
             WHEN INFIELD(oga03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF g_aza.aza50='Y' THEN
                     LET g_qryparam.form ="q_occ3"
                  ELSE
                     LET g_qryparam.form ="q_occ"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga03
                  NEXT FIELD oga03
             WHEN INFIELD(oga04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  IF g_aza.aza50='Y' THEN
                     LET g_qryparam.form ="q_occ4"
                  ELSE
                     LET g_qryparam.form ="q_occ"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oga04
                  NEXT FIELD oga04
             WHEN INFIELD(oga14)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gen"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga14
                NEXT FIELD oga14
             WHEN INFIELD(oga15)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
             WHEN INFIELD(oga15)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oga15
                NEXT FIELD oga15
            WHEN INFIELD(oga23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga23
                 NEXT FIELD oga23
            WHEN INFIELD(oga21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 IF g_aza.aza26 = '2' THEN
                    LET g_qryparam.form ="q_gec9"
                 ELSE   
                    LET g_qryparam.form ="q_gec"
                 END IF 
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oga21
                 NEXT FIELD oga21

               WHEN INFIELD(ogb09)
                    CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ogb09
                    NEXT FIELD ogb09

               WHEN INFIELD(ogb091)
                    CALL q_ime_1(TRUE,TRUE,g_oga[1].ogb091,g_oga[1].ogb09,"","","","","") RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ogb091
                    NEXT FIELD ogb091

               WHEN INFIELD(ogb05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ogb05
                    NEXT FIELD ogb05
               WHEN INFIELD(ogb04) 
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ogb04
                    NEXT FIELD ogb04

               WHEN INFIELD(ogb41)  #專案代號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pja2"
                    LET g_qryparam.state = "c"   #多選
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ogb41
                    NEXT FIELD ogb41

               WHEN INFIELD(oga011) #通知單號      
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_oga5"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oga011
                    NEXT FIELD oga011
              #FUN-D10105---add---str---
              WHEN INFIELD(occ03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ03_1"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO occ03
                    NEXT FIELD occ03
              WHEN INFIELD(ima131)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_ima131_1"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima131
                    NEXT FIELD ima131
              #FUN-D10105---add---end---
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
      LET g_filter_wc1 = ''
      LET g_filter_wc2 = ''
      LET g_qbe_oga011_f = NULL
      LET g_qbe_oga65_f = NULL
      LET g_qbe_ogb11_f = NULL
      LET g_qbe_ogb17_f = NULL
      LET g_qbe_ogb50_f = NULL
      LET g_qbe_ogb51_f = NULL
      LET g_qbe_ogb41_f = NULL
      LET g_qbe_oga00_f = NULL
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
   LET g_filter_wc1 = cl_replace_str(g_filter_wc,'ogb04','ogc17')  #字符替換--多倉儲批
   LET g_filter_wc1 = cl_replace_str(g_filter_wc1,'ogb12','ogc16')
   LET g_filter_wc1 = cl_replace_str(g_filter_wc1,'ogb09','ogc09')
   LET g_filter_wc1 = cl_replace_str(g_filter_wc1,'ogb091','ogc091')
   LET g_filter_wc1 = cl_replace_str(g_filter_wc1,'ogb092','ogc092')
   LET g_filter_wc2 = cl_replace_str(g_filter_wc,'oga00','oha05')  #字符替換
   LET g_filter_wc2 = cl_replace_str(g_filter_wc2,'oga','oha')
   LET g_filter_wc2 = cl_replace_str(g_filter_wc2,'ogb31','ohb33')
   LET g_filter_wc2 = cl_replace_str(g_filter_wc2,'ogb32','ohb34')
   LET g_filter_wc2 = cl_replace_str(g_filter_wc2,'ogb19','ohb61')
   LET g_filter_wc2 = cl_replace_str(g_filter_wc2,'ogb','ohb')
END FUNCTION

FUNCTION q003_table()
  # DROP TABLE axmq003_tmp;  #FUN-D10105 mark
   CREATE TEMP TABLE axmq003_tmp(
                oea00     LIKE oea_file.oea00,
                ogb31     LIKE ogb_file.ogb31,
                ogb32     LIKE ogb_file.ogb32,
                oea10     LIKE oea_file.oea10,
                oga011    LIKE oga_file.oga011,
                oga00     LIKE oga_file.oga00,           
                oga08     LIKE oga_file.oga08,
                oga01     LIKE oga_file.oga01, 
                oga02     LIKE oga_file.oga02,
                oga03     LIKE oga_file.oga03,                     
                oga032    LIKE oga_file.oga032,
                oha48     LIKE oha_file.oha48, #darcy:2024/01/30 add
                occ03     LIKE occ_file.occ03,
                oca02     LIKE oca_file.oca02,
                oga04     LIKE oga_file.oga04,
                occ02     LIKE occ_file.occ02,
                oga14     LIKE oga_file.oga14,
                gen02     LIKE gen_file.gen02,
                oga15     LIKE oga_file.oga15,
                gem02     LIKE gem_file.gem02,
                oga23     LIKE oga_file.oga23,
                oga21     LIKE oga_file.oga21,
                oga211    LIKE oga_file.oga211,
                oga213    LIKE oga_file.oga213,
                oga65     LIKE oga_file.oga65,                
                oga10     LIKE oga_file.oga10,
                ogaconf   LIKE oga_file.ogaconf,
                oga55     LIKE oga_file.oga55,
                ogapost   LIKE oga_file.ogapost,
                ogb03     LIKE ogb_file.ogb03,
                ogb04     LIKE ogb_file.ogb04,
                ogb06     LIKE ogb_file.ogb06,
                ima021    LIKE ima_file.ima021,
                ima131    LIKE ima_file.ima131,
                oba02     LIKE oba_file.oba02,
                ogb11     LIKE ogb_file.ogb11,
                ogb17     LIKE ogb_file.ogb17,
                ogb09     LIKE ogb_file.ogb09,
                ogb091    LIKE ogb_file.ogb091,
                ogb092    LIKE ogb_file.ogb092,
                ogb05     LIKE ogb_file.ogb05,
                ogb12     LIKE ogb_file.ogb12,
                ogb13     LIKE ogb_file.ogb13,
                ogb13e    LIKE ogb_file.ogb13,
                ogb14t    LIKE ogb_file.ogb14t,
                ogb14t_2  LIKE ogb_file.ogb14t,#add by huanglf170204
                ogb14t_o  LIKE ogb_file.ogb14t, 
                ogb50     LIKE ogb_file.ogb12,
                ogb51     LIKE ogb_file.ogb12,
                omb12     LIKE omb_file.omb12,
                omb14t    LIKE omb_file.omb14t,
                ogb41     LIKE ogb_file.ogb41,
                ogb19     LIKE ogb_file.ogb19,
                oga24     LIKE oga_file.oga24,
                oga02_2   LIKE oga_file.oga02,
                ogaud04   LIKE oga_file.ogaud04,   #add by huanglf170314
                ogaud05   LIKE oga_file.ogaud05,   #add by huanglf170314
                ogaud03   LIKE oga_file.ogaud03,   #add by qianyuan170420
                ogaud01   LIKE oga_file.ogaud01,   #add by qianyuan170420
                type      LIKE type_file.chr1,
                rowno     LIKE type_file.num10)     #add by wangxy 20121120  
    #FUN-D10105 add occ03,oca02,ima131,oba02
END FUNCTION 

FUNCTION q003()
 DEFINE   l_name      LIKE type_file.chr20,           
          l_sql       STRING,                
          l_chr       LIKE type_file.chr1,         
          l_order     ARRAY[5] OF LIKE abb_file.abb11,   #排列順序    
          l_i         LIKE type_file.num5,                    
          l_cnt       LIKE type_file.num5                  
   DEFINE sr,sr_t  sr1_t
   DEFINE l_wc,l_msg,g_wc,l_sql1,l_sql2,l_sql3   STRING 
   DEFINE l_sic06a,l_sic06b  LIKE sic_file.sic06
   DEFINE l_order1     LIKE type_file.chr100
   DEFINE l_num        LIKE type_file.num5
   DEFINE l_ogc        RECORD LIKE ogc_file.*
   DEFINE l_oga01_t    LIKE oga_file.oga01      #lixh1121107 add
   DEFINE l_ogb03_t    LIKE ogb_file.ogb03      #lixh1121107 add
   DEFINE l_chr1       LIKE type_file.chr100

   DISPLAY TIME   #add by wangxy 20121120                  
   LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
  # LET tm.wc2 = cl_replace_str(tm.wc2,'oga02','a.oga02')
   LET g_wc = cl_replace_str(tm.wc2,'ogb04','ogc17')      #字符替換
   LET g_wc = cl_replace_str(g_wc,'ogb12','ogc16')
   LET g_wc = cl_replace_str(g_wc,'ogb09','ogc09')
   LET g_wc = cl_replace_str(g_wc,'ogb091','ogc091')
   LET g_wc = cl_replace_str(g_wc,'ogb092','ogc092')   
   LET g_wc = cl_replace_str(g_wc,'oga02','a.oga02')
#  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')        #lixh1 
   LET l_where = cl_replace_str(tm.wc2,'oga00','oha05')   #字符替換
   LET l_where = cl_replace_str(l_where,'oga','oha')
   LET l_where = cl_replace_str(l_where,'ogb31','ohb33')
   LET l_where = cl_replace_str(l_where,'ogb32','ohb34')
   LET l_where = cl_replace_str(l_where,'ogb19','ohb61')
   LET l_where = cl_replace_str(l_where,'ogb','ohb')
   LET tm.wc2 = cl_replace_str(tm.wc2,'oga02','a.oga02')
   

#  LET l_where = l_where CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup')  #lixh1
   
   #CALL q003_table()  #FUN-D10105 mark

   DELETE FROM axmq003_tmp

   #mark by wangxy 20121120 - begin
   #LET g_sql = "INSERT INTO axmq003_tmp",
   #            " VALUES(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
   #            "        ?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,",
   #            "        ?,?,?,?,?,   ?,?,?)"
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN                                                                                                                   
   #   CALL cl_err('insert_prep:',status,1)
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time        
   #   EXIT PROGRAM                                                                                                                 
   #END IF
   #mark by wangxy 20121120 - end 
   IF cl_null(g_filter_wc) THEN LET g_filter_wc=" 1=1" END IF 
   IF cl_null(g_filter_wc1) THEN LET g_filter_wc1=" 1=1" END IF
   IF cl_null(g_filter_wc2) THEN LET g_filter_wc2=" 1=1" END IF 

   #不考慮多倉儲批
   LET l_sql = "SELECT oea00,ogb31,ogb32,oea10,a.oga011 oga011,a.oga00 oga00,a.oga08 oga08,a.oga01 oga01,nvl(trim(a.oga02),'') oga02,nvl(trim(a.oga03),'') oga03,nvl(trim(a.oga032),'') oga032,",
               "  '' oha48, ",
               " nvl(trim(occ03),'') occ03,nvl(trim(oca02),'') oca02,a.oga04 oga04,occ02,a.oga14 oga14,gen02,a.oga15 oga15,",  #FUN-D10105 occ03,oca02 
                  #"       gem02,oga23,oga21,oga211,oga213,oga65,oga10,ogaconf,oga55,ogapost,ogb03,ogb04,ogb06,'',",   #mark by wangxy 20121120
                  #"       gem02,oga23,oga21,oga211,oga213,oga65,oga10,ogaconf,oga55,ogapost,ogb03,ogb04,ogb06,'' ima021,",   #modify by wangxy 20121120 #FUN-D10105 mark
                  "       gem02,a.oga23 oga23,a.oga21 oga21,a.oga211 oga211,a.oga213 oga213,a.oga65 oga65,a.oga10 oga10,a.ogaconf ogaconf,a.oga55 oga55,a.ogapost ogapost,ogb03,ogb04,ogb06,ima021,nvl(trim(ima131),'') ima131,oba02,",    #FUN-D10105 add
   #              "       ogb11,ogb17,ogb09,ogb091,ogb092,ogb05,ogb12,ogb13,ogb14t,0,ogb50,ogb51,0,0,",
                  #"       ogb11,ogb17,ogb09,ogb091,ogb092,ogb05,ogb12,ogb13,ogb14t,0,0,0,0,0,",   #mark by wangxy 20121120
                  "       ogb11,ogb17,ogb09,ogb091,ogb092,ogb05,ogb12,ogb13,ogb13*oea24 ogb13e,ogb14t,0 ogb14t_2,0 ogb14t_o,0 ogb50,0 ogb51,0 omb12,0 omb14t,",    #modify by wangxy 20121120
                  #"       ogb41,ogb19,oga24,'N'",   #mark by wangxy 20121120 #add by huanglf170204
                  "       ogb41,ogb19,a.oga24 oga24,b.oga02 oga02_1,a.ogaud04 ogaud04,a.ogaud05 ogaud05,a.ogaud03 ogaud03, a.ogaud01 ogaud01,'N' type", #add by huanglf170314  #modify by wangxy 20121120   #ogaud03,ogaud01 add by qianyuan170420
#                 "  FROM oga_file LEFT OUTER JOIN occ_file ON occ01 = oga04,",
#                 "       ogb_file LEFT OUTER JOIN oea_file ON ogb31=oea01,gen_file,gem_file",
#                 " WHERE oga01=ogb01 AND gen01=oga14 AND gem01=oga15 AND oga09 IN ('2','3') " 
                  "  FROM oga_file a LEFT OUTER JOIN occ_file ON occ01 = a.oga04 ",
                  "                LEFT OUTER JOIN oca_file ON occ03 = oca01 ",  #FUN-D10105 add
                  "                LEFT OUTER JOIN gen_file ON gen01 = a.oga14 ",
                  "                LEFT OUTER JOIN gem_file ON gem01 = a.oga15 ",
                  "  LEFT OUTER JOIN (select  MAX(oga02) oga02,oga011 from oga_file 
                     where  oga011 in (select oga01 from oga_file WHERE oga09 ! = '1') 
                     AND oga09 != '1' group by oga011) b ON b.oga011 = a.oga01,",
                  "       ogb_file LEFT OUTER JOIN oea_file ON ogb31 = oea01 ",
                  "                LEFT OUTER JOIN ima_file ON ogb04 = ima01 ",  #FUN-D10105 add
                  "                LEFT OUTER JOIN oba_file ON ima131= oba01 ",  #FUN-D10105 add
                  " WHERE oga01=ogb01 AND oga09 IN ('2','3','4','6') "
   #考慮多倉儲批

   #mark by wangxy 20121120 - begin
   #LET l_sql1= "SELECT oea00,ogb31,ogb32,oea10,oga011,oga00,oga08,oga01,oga02,oga03,oga032,oga04,occ02,oga14,gen02,oga15,", 
   #               "       gem02,oga23,oga21,oga211,oga213,oga65,oga10,ogaconf,oga55,ogapost,ogb03,ogc17,'','',",
   ##              "       ogb11,ogb17,ogc09,ogc091,ogc092,ogb05,ogc16,ogb13,ogb14t,0,ogb50,ogb51,0,0,",
   #               "       ogb11,ogb17,ogc09,ogc091,ogc092,ogb05,ogc16,ogb13,ogb14t,0,0,0,0,0,",
   #               "       ogb41,ogb19,oga24,'N'",
   #mark by wangxy 20121120 - end
#                 "  FROM oga_file LEFT OUTER JOIN occ_file ON occ01 = oga04,",
#                 "       ogb_file LEFT OUTER JOIN oea_file ON ogb31 = oea01",
#                 "  LEFT OUTER JOIN ogc_file ON ogc01 = ogb01 AND ogc03 = ogb03,gen_file,gem_file",
#                 " WHERE oga01=ogb01 AND gen01=oga14 AND gem01=oga15 AND oga09 IN ('2','3') "

   #modify by wangxy 20121120 - begin
   LET l_sql1 = " SELECT oea00,ogb31,ogb32,oea10,a.oga011 oga011,",
                "        a.oga00 oga00,a.oga08 oga08,a.oga01 oga01,nvl(trim(a.oga02),'') oga02,nvl(trim(a.oga03),'') oga03,",
                "        nvl(trim(a.oga032),'') oga032,",
                "        '' oha48 ,", #darcy:2024/01/30 add
                "nvl(trim(occ03),'') occ03,nvl(trim(oca02),'') oca02,a.oga04 oga04,occ02,a.oga14 oga14,gen02,",  #FUN-D10105 occ03,oca02
                "        a.oga15 oga15,gem02,a.oga23 oga23,a.oga21 oga21,a.oga211 oga211,",
                "        a.oga213 oga213,a.oga65 oga65,a.oga10 oga10,a.ogaconf ogaconf,a.oga55 oga55,",
                #"        ogapost,ogb03,ogc17 ogb04,'' ogb06,'' ima021,",                       #FUN-D10105 mark
                "        a.ogapost ogapost,ogb03,ogc17 ogb04,ima02 ogb06,ima021 ima021,nvl(trim(ima131),'') ima131,oba02, ",   #FUN-D10105 add
                "        ogb11,ogb17,ogc09 ogb09,ogc091 ogb091,ogc092 ogb092,",
                "        ogb05,ogc16 ogb12,ogb13,ogb13*oea24 ogb13e,ogb14t,0 ogb14t_2,0 ogb14t_o,",  #add by huanglf170204
                "        0 ogb50,0 ogb51,0 omb12,0 omb14t,ogb41,",
                "        ogb19,a.oga24 oga24,b.oga02 oga02_1,a.ogaud04 ogaud04,a.ogaud05 ogaud05,a.ogaud03 ogaud03, a.ogaud01 ogaud01,'N' type ",    #add by huanglf170314  #ogaud03,ogaud01 add by qianyuan170420
   #modify by wangxy 20121120 - end 
                  "  FROM oga_file a LEFT OUTER JOIN occ_file ON occ01 = a.oga04 ",
                  "                LEFT OUTER JOIN oca_file ON occ03 = oca01 ",  #FUN-D10105 add
                  "                LEFT OUTER JOIN gen_file ON gen01 = a.oga14 ",
                  "                LEFT OUTER JOIN gem_file ON gem01 = a.oga15",
                  "                LEFT OUTER JOIN (select  MAX(oga02) oga02,oga011 from oga_file where  oga011 in 
                                                   (select oga01 from oga_file WHERE oga09 ! = '1' ) 
                                                    AND oga09 != '1' group by oga011) b ON b.oga011 = a.oga01,",
                  "       ogb_file LEFT OUTER JOIN oea_file ON ogb31 = oea01 ",
                  "                LEFT OUTER JOIN ogc_file ON ogc01 = ogb01 AND ogc03 = ogb03 ",
                  "                LEFT OUTER JOIN ima_file ON ima01 = ogc17 ",  #FUN-D10105 add
                  "                LEFT OUTER JOIN oba_file ON ima131= oba01 ",  #FUN-D10105 add
                  " WHERE oga01=ogb01  AND oga09 IN ('2','3','4','6') "
               
   IF (cl_null(g_qbe_oga011) AND cl_null(g_qbe_oga65) AND cl_null(g_qbe_ogb11) AND cl_null(g_qbe_ogb17) AND 
      cl_null(g_qbe_ogb50) AND cl_null(g_qbe_ogb51) AND cl_null(g_qbe_ogb41) AND
      (g_qbe_oga00 NOT MATCHES '[1]' OR cl_null(g_qbe_oga00))) 
      AND (cl_null(g_qbe_oga011_f) AND cl_null(g_qbe_oga65_f) AND cl_null(g_qbe_ogb11_f) AND cl_null(g_qbe_ogb17_f) AND
      cl_null(g_qbe_ogb50_f) AND cl_null(g_qbe_ogb51_f) AND cl_null(g_qbe_ogb41_f) AND
      (g_qbe_oga00_f NOT MATCHES '[1]' OR cl_null(g_qbe_oga00_f))) THEN    #需要從出貨+銷退資料撈取資料or只從銷退單抓取資料
      
      LET l_sql = l_sql," AND ogb17 = 'N'","  AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
      #g_wc/g_filter_wc1 ogb_file 的字段已經被ogc_file對應的字段替換掉了
      LET l_sql1 = l_sql1," AND ogb17 = 'Y'"," AND ogc17 <> ' '"," AND ogc17 IS NOT NULL",
                          " AND ",g_wc CLIPPED," AND ",g_filter_wc1 CLIPPED

      #mark by wangxy 20121120 - begin
      #LET l_sql2 = "SELECT oea00,ohb33,ohb34,oea10,'',oha05,oha08,oha01,oha02,oha03,oha032,oha04,occ02,oha14,gen02,oha15,",  #銷退檔
      #                "gem02,oha23,oha21,oha211,oha213,'N',oha10,ohaconf,oha55,ohapost,ohb03,ohb04,ohb06,'',",
      #                "'','N',ohb09,ohb091,ohb092,ohb05,ohb12,ohb13,ohb14t,0,0,0,0,0,",
      #                "'',ohb61,oha24,'Y'",
      #mark by wangxy 20121120 - end

      #modify by wangxy 20121120 - begin 
      LET l_sql2 = " SELECT oea00,ohb33 ogb31,ohb34 ogb32,oea10,'' oga011,",
                   "        CASE WHEN oha05 = '1' THEN '2' ELSE oha05 END oga00,oha08 oga08,oha01 oga01,nvl(trim(oha02),'') oga02,nvl(trim(oha03),'') oga03,",#add by huanglf170320
                   "        nvl(trim(oha032),'') oga032,",
                   "        oha48 , ", #darcy:2024/01/30 add
                   " nvl(trim(occ03),'') occ03,nvl(trim(oca02),'') oca02,oha04 oga04,occ02,oha14 oga14,gen02,",      #FUN-D10105 occ03,oca02
                   "        oha15 oga15,gem02,oha23 oga23,oha21 oga21,oha211 oga211,",
                   "        oha213 oga213,'N' oga65,oha10 oga10,ohaconf ogaconf,oha55 oga55,",
                   #"        ohapost ogapost,ohb03 ogb03,ohb04 ogb04,ohb06 ogb06,'' ima021,",     #FUN-D10105 mark
                   "        ohapost ogapost,ohb03 ogb03,ohb04 ogb04,ohb06 ogb06,ima021 ima021,nvl(trim(ima131),'') ima131,oba02, ",  #FUN-D10105 add
                   "        '' ogb11,'N' ogb17,ohb09 ogb09,ohb091 ogb091,ohb092 ogb092,",
                   "        ohb05 ogb05,ohb12*(-1) ogb12,ohb13 ogb13,ohb13*oea24 ogb13e,ohb14t*(-1) ogb14t,0 ogb14t_2,0 ogb14t_o,",
                   "        0 ogb50,0 ogb51,0 omb12,0 omb14t,'' ogb41,",
                   "        ohb61 ogb19,oha24 oga24,to_date('99/12/30','YY/MM/DD') oga02_1,'' ogaud04,'' ogaud05,'' ogaud03,'' ogaud01, 'Y' type",#add by huanglf170314   #ogaud03,ogaud01 add by qianyuan170420
      #modify by wangxy 20121120 - end

      #               "  FROM oha_file LEFT OUTER JOIN occ_file ON occ01 = oha04,",
      #               "       ohb_file LEFT OUTER JOIN oea_file ON ohb33=oea01,gen_file,gem_file",
      #               " WHERE oha01=ohb01 AND gen01=oha14 AND gem01=oha15 ",
                      "  FROM oha_file LEFT OUTER JOIN occ_file ON occ01 = oha04 ",
                      "                LEFT OUTER JOIN oca_file ON occ03 = oca01 ",  #FUN-D10105 add
                      "                LEFT OUTER JOIN gen_file ON gen01 = oha14 ",
                      "                LEFT OUTER JOIN gem_file ON gem01 = oha15,",
                      "       ohb_file LEFT OUTER JOIN oea_file ON ohb33 = oea01 ",
                      "                LEFT OUTER JOIN ima_file ON ima01 = ohb04 ",  #FUN-D10105 add
                      "                LEFT OUTER JOIN oba_file ON ima131= oba01 ",  #FUN-D10105 add
                      " WHERE ohaconf='Y' and  oha01=ohb01 ",
                      "   AND ",l_where CLIPPED," AND ",g_filter_wc2 CLIPPED
      IF cl_null(g_qbe_oga00) AND cl_null(g_qbe_oga00_f) THEN  #不指定出貨別 
         LET l_sql3 = l_sql," UNION ",l_sql1," UNION ",l_sql2
      END IF
      IF g_qbe_oga00 MATCHES '[45]' OR g_qbe_oga00_f MATCHES '[45]' THEN  #銷退僅從銷退資料檔抓取
      #  LET l_sql3 = l_sql2," AND oha05 = '",g_qbe_oga00,"'"," AND oha05 = '",g_qbe_oga00_f,"'"
         LET l_sql3 = l_sql2 CLIPPED     #lixh121108
      END IF
      #銷退僅從銷退資料檔抓取,此處必須替換,否则这种情况会抓不到资料,oha05 = '2' AND oha05 = '1'衝突 
      IF g_qbe_oga00 = '2' OR g_qbe_oga00_f = '2' THEN   
         LET l_sql2 = cl_replace_str(l_sql2,'oha05','2')  #字符替換 
         LET l_sql3 = l_sql2," AND oha05 = '1'"
      END IF
   ELSE  #只從出貨單抓取資料
      IF g_qbe_oga00 = '1' OR cl_null(g_qbe_oga00) THEN   #出貨
      #  LET l_sql = l_sql," AND oga00 = '1'"
      #  IF NOT cl_null(g_qbe_oga011) THEN
      #     LET l_sql = l_sql," AND ",g_wc1 CLIPPED
      #     LET l_sql1 = l_sql1," AND ",g_wc1 CLIPPED 
      #  END IF
      #  IF NOT cl_null(g_qbe_oga65) THEN
      #     LET l_sql = l_sql," AND ",g_wc2 CLIPPED
      #     LET l_sql1 = l_sql1," AND ",g_wc2 CLIPPED
      #  END IF
      #  IF NOT cl_null(g_qbe_ogb11) THEN
      #     LET l_sql = l_sql," AND ",g_wc3 CLIPPED
      #     LET l_sql1 = l_sql1," AND ",g_wc3 CLIPPED
      #  END IF
      #  IF NOT cl_null(g_qbe_ogb50) THEN
      #     LET l_sql = l_sql," AND ",g_wc5 CLIPPED
      #     LET l_sql1 = l_sql1," AND ",g_wc5 CLIPPED
      #  END IF
      #  IF NOT cl_null(g_qbe_ogb51) THEN
      #     LET l_sql = l_sql," AND ",g_wc6 CLIPPED
      #     LET l_sql1 = l_sql1," AND ",g_wc6 CLIPPED
      #  END IF
      #  IF NOT cl_null(g_qbe_ogb41) THEN
      #     LET l_sql = l_sql," AND ",g_wc7 CLIPPED
      #     LET l_sql1 = l_sql1," AND ",g_wc7 CLIPPED
      #  END IF
         IF g_qbe_ogb17 = 'Y' THEN 
      #     LET l_sql3 = l_sql1," AND ogb17 = 'Y'"," AND ogc17 <> ' '"," AND ogc17 IS NOT NULL",
            LET l_sql3 = l_sql1," AND ogc17 <> ' '"," AND ogc17 IS NOT NULL",
                                " AND ",g_wc CLIPPED," AND ",g_filter_wc1 CLIPPED
         END IF
         IF g_qbe_ogb17 = 'N' THEN
      #     LET l_sql3 = l_sql," AND ogb17 = 'N'","  AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED        
            LET l_sql3 = l_sql,"  AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
         END IF
         IF cl_null(g_qbe_ogb17) THEN
            LET l_sql1 = l_sql1," AND ogb17 = 'Y'","  AND ",g_wc CLIPPED," AND ",g_filter_wc1 CLIPPED
            LET l_sql = l_sql," AND ogb17 = 'N'","  AND ",tm.wc2 CLIPPED," AND ",g_filter_wc CLIPPED
            LET l_sql3 = l_sql," UNION ",l_sql1
         END IF
      END IF
   END IF

   IF (g_qbe_oga00 NOT MATCHES '[245]' AND  g_qbe_oga00_f NOT MATCHES '[245]') OR            #lixh121107
      (cl_null(g_qbe_oga00) AND cl_null(g_qbe_oga00_f)) THEN  #銷退僅從銷退資料檔抓取
       LET l_sql3 = l_sql3 CLIPPED," ORDER BY oga00,oga08,oga01,ogb03,oga02,oga03,oga032,",  #lixh121107
                                   "  oga04,occ02,oga14,gen02,oga15,gem02"
   END IF
   
   #mark by wangxy 20121120 - begin

   #PREPARE q003_prepare FROM l_sql3
   #DECLARE q003_curs CURSOR FOR q003_prepare
   #FOREACH q003_curs INTO sr.*
   #   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
   #   IF cl_null(sr.oga24) OR sr.oga24 = 0 THEN   #匯率默認為1
   #      LET sr.oga24 = 1
   #   END IF
   #   IF cl_null(sr.ogb14t) THEN
   #      LET sr.ogb14t = 0
   #   END IF
   #   LET sr.ogb14t_o = sr.ogb14t * sr.oga24    #本幣金額

   #   #已簽收數量
   #   SELECT SUM(ogb12) INTO sr.ogb50 FROM ogb_file,oga_file
   #      WHERE ogb31=sr.ogb31 AND ogb32=sr.ogb32
   #        AND ogb01=oga01 AND ogapost='Y' AND oga09='8'
   #   IF cl_null(sr.ogb50) THEN LET sr.ogb50=0 END IF

   #   #已簽退數量
   #   SELECT SUM(ogb12) INTO sr.ogb51 FROM ogb_file,oga_file
   #      WHERE ogb31=sr.ogb31 AND ogb32=sr.ogb32
   #        AND ogb01=oga01 AND ogapost='Y' AND oga09='9'
   #   IF cl_null(sr.ogb51) THEN LET sr.ogb51=0 END IF  

   #   #立賬數量
   #   IF sr.oga65='N' THEN     #考虑签收
   #      SELECT SUM(omb12) INTO sr.omb12 FROM omb_file,oma_file
   #       WHERE omb31=sr.oga01 AND omb32=sr.ogb03
   #         AND omb01=oma01 AND omaconf='Y'
   #   ELSE
   #      SELECT SUM(omb12) INTO sr.omb12 FROM omb_file,oma_file,oga_file,ogb_file
   #       WHERE oga01=ogb01 AND omb31=ogb01 AND omb32=ogb03 AND omb01=oma01
   #         AND ogb31=sr.ogb31 AND ogb32=sr.ogb32 AND oga09='8'
   #         AND omaconf='Y'
   #   END IF
   #   IF cl_null(sr.omb12) THEN LET sr.omb12=0 END IF

   #   #立賬金額
   #   IF sr.oga65='N' THEN     #考虑签收
   #      SELECT SUM(omb14t) INTO sr.omb14t FROM omb_file,oma_file
   #       WHERE omb31=sr.oga01 AND omb32=sr.ogb03
   #         AND omb01=oma01 AND omaconf='Y'
   #   ELSE
   #      SELECT SUM(omb14t) INTO sr.omb14t FROM omb_file,oma_file,oga_file,ogb_file
   #       WHERE oga01=ogb01 AND omb31=ogb01 AND omb32=ogb03 AND omb01=oma01
   #         AND ogb31=sr.ogb31 AND ogb32=sr.ogb32 AND oga09='8'
   #         AND omaconf='Y'
   #   END IF
   #   IF cl_null(sr.omb14t) THEN LET sr.omb14t=0 END IF

   #   IF sr.type = 'Y' THEN  #銷退數量/金額為負數
   #      LET sr.ogb12 = sr.ogb12 * -1         #實際出貨數量
   #      LET sr.ogb14t = sr.ogb14t * -1       #原幣金額
   #      LET sr.ogb14t_o = sr.ogb14t_o * -1   #本幣金額
   #      LET sr.ogb50 = sr.ogb50 * -1         #已簽收數量
   #      LET sr.ogb51 = sr.ogb51 * -1         #已簽退數量
   #      LET sr.omb12 = sr.omb12 * -1         #立賬數量
   #      LET sr.omb14t = sr.omb14t * -1       #立賬金額
   #      IF sr.oga00 = '1' THEN     #oga00 = '2' 為一般銷退 oga00 = '2' <=> oha05 = '1' 為一般銷退
   #         LET sr.oga00 = '2' 
   #      END IF
   #   END IF
   #   IF sr.ogb17 = 'Y' THEN   #多倉儲批出貨(ogc_file) 
   #      SELECT ima02 INTO sr.ogb06 FROM ima_file WHERE ima01 = sr.ogb04
   #      #lixh121107 ------begin--------
   #      IF (cl_null(l_oga01_t) AND cl_null(l_ogb03_t)) OR
   #         (sr.oga01 <> l_oga01_t OR sr.ogb03 <> l_ogb03_t) THEN
   #         LET l_oga01_t = sr.oga01
   #         LET l_ogb03_t = sr.ogb03
   #      ELSE        
   #         LET sr.ogb14t = 0
   #         LET sr.ogb14t_o = 0
   #      END IF      
   #      #lixh121107 ------end----------
   #   END IF

   #   EXECUTE insert_prep USING sr.*
   #   INITIALIZE sr.* TO NULL   #初始化
   #END FOREACH

   #mark by wangxy 20121120 - end

   #modify by wangxy 20121120 - begin

   LET l_sql = " INSERT INTO axmq003_tmp ",
               "   SELECT x.*,ROW_NUMBER() OVER (PARTITION BY oga00,oga08,oga01,ogb03 ORDER BY oga02) ",
               "     FROM (",l_sql3 CLIPPED,") x "
   PREPARE q003_ins FROM l_sql
   EXECUTE q003_ins

   LET l_sql = " UPDATE axmq003_tmp ",
               "    SET oga24 = 1 ",
               "  WHERE TRIM(oga24) IS NULL OR oga24 = 0 "
   PREPARE q003_pre1 FROM l_sql
   EXECUTE q003_pre1

   LET l_sql = " UPDATE axmq003_tmp ",
               "    SET ogb14t = 0 ",
               "  WHERE TRIM(ogb14t) IS NULL "

   PREPARE q003_pre2 FROM l_sql
   EXECUTE q003_pre2

   
#str----add by huanglf170204
{
   LET l_sql = " UPDATE axmq003_tmp ",
               "    SET ogb14t_2 = ogb13 * oga24 * ogb12"
   PREPARE q003_pre12 FROM l_sql
   EXECUTE q003_pre12
   }
    LET l_sql = " UPDATE axmq003_tmp ",
               "    SET ogb14t_2 =ogb14t * oga24*100/(100+oga211)  "
   PREPARE q003_pre12 FROM l_sql
   EXECUTE q003_pre12
#str----end by huanglf170204

#str----add by huanglf170314
   LET l_chr1 = '99/12/30'
   LET l_sql = " UPDATE axmq003_tmp ",
               "    SET oga02_2 = '' ",
               " WHERE oga02_2 = to_date ('",l_chr1,"' ,'YY/MM/DD')"
   PREPARE q003_pre13 FROM l_sql
   EXECUTE q003_pre13

#str----end by huanglf170314
   --LET l_sql = " UPDATE axmq003_tmp ",
               --"    SET ogb14t_2 = ogb13 * oga24 * ogb12 * (-1)",
               --" WHERE oga00 != '1' "
   --PREPARE q003_pre14 FROM l_sql
   --EXECUTE q003_pre14

#str----add by huanglf170320



#str----end by huanglf170320

   LET l_sql = " UPDATE axmq003_tmp ",
               #"    SET ogb14t = ogb14t * oga24 "   #FUN-D10105 mark
               "    SET ogb14t_o = ogb14t * oga24 "  #FUN-D10105 add
   PREPARE q003_pre3 FROM l_sql
   EXECUTE q003_pre3

   LET l_sql = " MERGE INTO axmq003_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ", 
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 = '8' ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.ogb31 = n.ogb31 AND o.ogb32 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb50 = NVL(n.ogb12_sum,0) "
   PREPARE q003_pre4 FROM l_sql
   EXECUTE q003_pre4

   LET l_sql = " MERGE INTO axmq003_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(ogb12) ogb12_sum ",
               "               FROM oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 ",
               "                AND ogapost = 'Y' AND oga09 = '9' ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.ogb31 = n.ogb31 AND o.ogb32 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.ogb51 = NVL(n.ogb12_sum,0) "
   PREPARE q003_pre5 FROM l_sql
   EXECUTE q003_pre5

   LET l_sql = " MERGE INTO axmq003_tmp o ",
               "      USING (SELECT omb31,omb32,SUM(omb12) omb12_sum ",
               "               FROM oma_file,omb_file ",
               "              WHERE oma01 = omb01 ",
               "                AND omaconf = 'Y' ",
               "              GROUP BY omb31,omb32) n ",
               "         ON (o.oga01 = n.omb31 AND o.ogb03 = n.omb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.omb12 = NVL(n.omb12_sum,0) ",
               "     WHERE o.oga65 = 'N' "
   PREPARE q003_pre6 FROM l_sql
   EXECUTE q003_pre6

   LET l_sql = " MERGE INTO axmq003_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(omb12) omb12_sum ",
               "               FROM oma_file,omb_file,oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 AND oma01 = omb01 ",
               "                AND omb31 = ogb01 AND omb32 = ogb03 ",
               "                AND oga09 = '8' AND omaconf = 'Y' ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.ogb31 = n.ogb31 AND o.ogb32 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.omb12 = NVL(n.omb12_sum,0) ",
               "     WHERE o.oga65 <> 'N' "
   PREPARE q003_pre7 FROM l_sql
   EXECUTE q003_pre7

   LET l_sql = " MERGE INTO axmq003_tmp o ",
               "      USING (SELECT omb31,omb32,SUM(omb14t) omb14t_sum ",
               "               FROM oma_file,omb_file ",
               "              WHERE oma01 = omb01 ",
               "                AND omaconf = 'Y' ",
               "              GROUP BY omb31,omb32) n ",
               "         ON (o.oga01 = n.omb31 AND o.ogb03 = n.omb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.omb14t = NVL(n.omb14t_sum,0) ",
               "     WHERE o.oga65 = 'N' "
   PREPARE q003_pre8 FROM l_sql
   EXECUTE q003_pre8

{   #tianry addd 170108
   LET l_sql =" MERGE INTO axmq003_tmp o",
              "      USING (SELECT omb01,omb31,omb32  ",
              "               FROM omb_file,oma_file ",
              "              WHERE omaconf='Y'  ",
              "              ) n ",
              "         ON (o.oga01 = n.omb31 AND o.ogb03 = n.omb32) ",
              " WHEN MATCHED ",
              " THEN ",
              "    UPDATE ",
              "       SET o.oga10 = n.omb01 "
   PREPARE q003_pre888 FROM l_sql
   EXECUTE q003_pre888

   #tianry add end 
}

   LET l_sql = " MERGE INTO axmq003_tmp o ",
               "      USING (SELECT ogb31,ogb32,SUM(omb14t) omb14t_sum ",
               "               FROM oma_file,omb_file,oga_file,ogb_file ",
               "              WHERE oga01 = ogb01 AND oma01 = omb01 ",
               "                AND omb31 = ogb01 AND omb32 = ogb03 ",
               "                AND oga09 = '8' AND omaconf = 'Y' ",
               "              GROUP BY ogb31,ogb32) n ",
               "         ON (o.ogb31 = n.ogb31 AND o.ogb32 = n.ogb32) ",
               " WHEN MATCHED ",
               " THEN ",
               "    UPDATE ",
               "       SET o.omb14t = NVL(n.omb14t_sum,0) ",
               "     WHERE o.oga65 <> 'N' "
   PREPARE q003_pre9 FROM l_sql
   EXeCUTE q003_pre9

   LET l_sql = " UPDATE axmq003_tmp ",
               "    SET ogb12 = ogb12 * (-1), ",
               "        ogb14t = ogb14t * (-1), ",
               "        ogb14t_2 = ogb14t_2 * (-1) ",  #add by huanglf170204
               "        ogb14t_o = ogb14t_o * (-1), ",
               "        ogb50 = ogb50 * (-1), ",
               "        ogb51 = ogb51 * (-1), ",
               "        omb12 = omb12 * (-1), ",
               "        omb14t = omb14t * (-1), ",
#              "        oga00 = DECODE(oga00,'1','2',oga00) ",           #xj sql mod
               "        oga00 = CASE WHEN oga00='1' THEN '2' ELSE oga00 END",
               "  WHERE type = 'Y' "
   PREPARE q003_pre10 FROM l_sql
   EXECUTE q003_pre10

   LET l_sql = " UPDATE axmq003_tmp ",
               "    SET ogb14t = 0,",
               "        ogb14t_2 = 0 ",
               "        ogb14t_o = 0 ",
               "  WHERE ogb17 = 'Y' ",
               "    AND rowno <> 1 "
   PREPARE q003_pre11 FROM l_sql
   EXECUTE q003_pre11

   #modify by wangxy 20121120 -end

   DISPLAY TIME   #add by wangxy 20121120


END FUNCTION 

FUNCTION q003_get_sum()
   DEFINE l_wc     STRING
   DEFINE l_sql    STRING

   CASE tm.a
      WHEN '1'
         LET l_sql = "SELECT oga00,'','','','','','','','','','',",    #FUN-D10105 add 4*''
                     "       '','','','','','','',oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),", #add by huanglf170204
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp", 
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY oga00,oga23,omb12,omb14t ",
                     " ORDER BY oga00,oga23 "
      WHEN '2'
         LET l_sql = "SELECT '',oga08,'','','','','','','','','',",      #FUN-D10105 add 4*''
                     "       '','','','','','','',oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY oga08,oga23,omb12,omb14t ",
                     " ORDER BY oga08,oga23 "
      WHEN '3'
         LET l_sql = "SELECT '','',oga02,'','','','','','','','',",      #FUN-D10105 add 4*''
                     "       '','','','','','','',oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY oga02,oga23,omb12,omb14t ",
                     " ORDER BY oga02,oga23 "
      WHEN '4'
         LET l_sql = "SELECT '','','',oga03,oga032,'','','','','','',",  #FUN-D10105 add 4*''
                     "       '','','','','','','',oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY oga03,oga032,oga23,omb12,omb14t ",
                     " ORDER BY oga03,oga032,oga23 "
      WHEN '5'
         LET l_sql = "SELECT '','','','','','','',oga04,occ02,'','',",    #FUN-D10105 add 4*''    
                     "       '','','','','','','',oga23,", 
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_1),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY oga04,occ02,oga23,omb12,omb14t ",
                     " ORDER BY oga04,occ02,oga23 "
      WHEN '6'
         LET l_sql = "SELECT '','','','','','','','','',oga14,gen02,",    #FUN-D10105 add 4*''
                     "       '','','','','','','',oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY oga14,gen02,oga23,omb12,omb14t ",
                     " ORDER BY oga14,gen02,oga23 "
      WHEN '7'
         LET l_sql = "SELECT '','','','','','','','','','','',",          #FUN-D10105 add 4*''
                     "       oga15,gem02,'','','','','',oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY oga15,gem02,oga23,omb12,omb14t ",
                     " ORDER BY oga15,gem02,oga23 "
      WHEN '8'
         LET l_sql = "SELECT '','','','','','','','','','','',",          #FUN-D10105 add 4*''
                     "'','',ogb04,ogb06,ima021,'','',oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY ogb04,ogb06,ima021,oga23,omb12,omb14t ",
                     " ORDER BY ogb04,ogb06,ima021,oga23 "
      #FUN-D10105---add---str---
      WHEN '9'
         LET l_sql = "SELECT '','','','','',occ03,oca02,'','','','',",   
                     "       '','','','','','','',oga23,", 
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY occ03,oca02,oga23,omb12,omb14t ",
                     " ORDER BY occ03,oca02,oga23 "
      WHEN '10'
         LET l_sql = "SELECT '','','','','','','','','','','',",         
                     "'','','','','',ima131,oba02,oga23,",
                     "SUM(ogb12),SUM(ogb14t),SUM(ogb14t_2),SUM(ogb14t_o),SUM(ogb50),",
                     #"SUM(ogb51),SUM(omb12),SUM(omb14t) FROM axmq003_tmp",
                     "SUM(ogb51),omb12,omb14t FROM axmq003_tmp", #MOD-D20135 add
                     " GROUP BY ima131,oba02,oga23,omb12,omb14t ",
                     " ORDER BY ima131,oba02,oga23 "
      #FUN-D10105---add---end---
   END CASE 
              
   PREPARE q003_pb FROM l_sql
   DECLARE q003_curs1 CURSOR FOR q003_pb
   FOREACH q003_curs1 INTO g_oga_1[g_cnt].*
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
   DISPLAY ARRAY g_oga_1 TO s_oga_1.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   CALL g_oga_1.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cnt1 
   IF cl_null(tm.a) THEN 
      LET g_tot_qty = 0
      LET g_tot_sum = 0
      LET g_tot_ori_sum = 0
      LET g_tot_ws_sum = 0 #add by huanglf170209
   END IF 
END FUNCTION  

FUNCTION q003_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,
          l_oga24      LIKE oga_file.oga24,
          l_type       LIKE type_file.chr1,   
          l_sql        STRING, 
          l_tmp        STRING, #FUN-D10105
          l_tmp2       STRING  #FUN-D10105

   #FUN-D10105--add--str--
   IF cl_null(g_oga_1[p_ac].oga23) THEN
      LET g_oga_1[p_ac].oga23=''
      LET l_tmp = " OR oga23 IS NULL "
   ELSE
      LET l_tmp = ''
   END IF
   #FUN-D10105--add--end--

   CASE tm.a 
      WHEN "1" 
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].oga00) THEN
            LET l_tmp2 = " OR oga00 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",    #mark by wangxy 20121120

         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,",
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ",#add by huanglf170314 #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",  
         #modify by wangxy 20121120 - end
 
                     " WHERE (oga00 = '",g_oga_1[p_ac].oga00,"' ",l_tmp2,")",  #FUN-D10105
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",   #FUN-D10105
                     " ORDER BY oga00,oga23,ogb05"
      WHEN "2"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].oga08) THEN
            LET l_tmp2 = " OR oga08 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",   #mark by wangxy 20121120

         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,", #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ", #add by huanglf170314  #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
         #modify by wangxy 20121120 - end
 
                     #" WHERE oga00 = '",g_oga_1[p_ac].oga00,"'",   #mark by zhangym 121121
                     " WHERE (oga08 = '",g_oga_1[p_ac].oga08,"' ",l_tmp2,")",  #FUN-D10105
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",   #FUN-D10105
                     " ORDER BY oga08,oga23,ogb05"
      WHEN "3"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].oga02) THEN
            LET l_tmp2 = " OR oga02 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",   #mark by wangxy 20121120

         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,",  #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ", #add by huanglf170314  #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
         #modify by wangxy 20121120 - end
 
                     #" WHERE oga00 = '",g_oga_1[p_ac].oga00,"'",
                     " WHERE (trim(oga02) = '",g_oga_1[p_ac].oga02,"' ",l_tmp2,")",  #FUN-D10105
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",   #FUN-D10105
                     " ORDER BY oga02,oga23,ogb05"
      WHEN "4"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].oga03) THEN
            LET l_tmp2 = " OR oga03 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",   #mark by wangxy 20121120

         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,",  #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ", #add by huanglf170314   #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
         #modify by wangxy 20121120 - end
 
                     #" WHERE oga00 = '",g_oga_1[p_ac].oga00,"'",
                     " WHERE (oga03 = '",g_oga_1[p_ac].oga03,"' ",l_tmp2,")",  #FUN-D10105
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",   #FUN-D10105
                     " ORDER BY oga03,oga23,ogb05"
      WHEN "5"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].oga14) THEN
            LET l_tmp2 = " OR oga14 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",   #mark by wangxy 20121120

         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,", #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ",  #add by huanglf170314   #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
         #modify by wangxy 20121120 - end
 
                     #" WHERE oga00 = '",g_oga_1[p_ac].oga00,"'",
                     " WHERE (oga04 = '",g_oga_1[p_ac].oga04,"' ",l_tmp2,")",  #FUN-D10105
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",   #FUN-D10105
                     " ORDER BY oga04,oga23,ogb05"
      WHEN "6"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].oga14) THEN
            LET l_tmp2 = " OR oga14 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",   #mark by wangxy 20121120

         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,",  #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ",  #add by huanglf170314   #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
         #modify by wangxy 20121120 - end
 
                     #" WHERE oga00 = '",g_oga_1[p_ac].oga00,"'",
                     " WHERE (oga14 = '",g_oga_1[p_ac].oga14,"' ",l_tmp2,")",  #FUN-D10105
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",   #FUN-D10105
                     " ORDER BY oga14,oga23,ogb05"
      WHEN "7"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].oga15) THEN
            LET l_tmp2 = " OR oga15 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF 
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",   #mark by wangxy 20121120

         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,", #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ",  #add by huanglf170314  #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
         #modify by wangxy 20121120 - end
 
                     #" WHERE oga00 = '",g_oga_1[p_ac].oga00,"'",
                     " WHERE (oga15 = '",g_oga_1[p_ac].oga15,"' ",l_tmp2,")",  #FUN-D10105
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",   #FUN-D10105
                     " ORDER BY oga15,oga23,ogb05"
      WHEN "8"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].ogb04) THEN
            LET l_tmp2 = " OR ogb04 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         #LET l_sql = "SELECT * FROM axmq003_tmp ",    #mark by wangxy 20121120
         #modify by wangxy 20121120 - begin
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    #FUN-D10105 occ03 oca02
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", #FUN-D10105 ima131 oba02
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,",  #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ", #add by huanglf170314  #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
         #modify by wangxy 20121120 - end
 
                     #" WHERE oga00 = '",g_oga_1[p_ac].oga00,"'",
                     #FUN-D10105--modify--str--
                     #" WHERE ogb04 = '",g_oga_1[p_ac].ogb04,"'",
                     #"   AND oga23 = '",g_oga_1[p_ac].oga23,"'",
                     " WHERE (ogb04 = '",g_oga_1[p_ac].ogb04,"' ",l_tmp2,")", 
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",
                     #FUN-D10105--modify--end--
                     " ORDER BY ogb04,oga23,ogb05"
      #FUN-D10105--add--str--               
      WHEN "9"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].occ03) THEN
            LET l_tmp2 = " OR occ03 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",   
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", 
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,",  #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ",     #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
                     " WHERE (occ03 = '",g_oga_1[p_ac].occ03 CLIPPED,"' ",l_tmp2,")",
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",
                     " ORDER BY occ03,oga23,ogb05"
      WHEN "10"
         #FUN-D10105--add--str--
         IF cl_null(g_oga_1[p_ac].ima131) THEN
            LET l_tmp2 = " OR ima131 IS NULL "
         ELSE
            LET l_tmp2 = ''
         END IF
         #FUN-D10105--add--end--
         LET l_sql = " SELECT oea00,ogb31,ogb32,oea10,oga011,",
                     "        oga00,oga08,oga01,oga02,oga03,",
                     "        oga032,occ03,oca02,oga04,occ02,oga14,gen02,",    
                     "        oga15,gem02,oga23,oga21,oga211,",
                     "        oga213,oga65,oga10,ogaconf,oga55,",
                     "        ogapost,ogb03,ogb04,ogb06,ima021,ima131,oba02,", 
                     "        ogb11,ogb17,ogb09,ogb091,ogb092,",
                     "        ogb05,ogb12,ogb13,ogb14t,ogb14t_2,ogb14t_o,", #add by huanglf170204
                     "        ogb50,ogb51,omb12,omb14t,ogb41,",
                     "        ogb19,oga02_2,ogaud04,ogaud05,ogaud03,ogaud01,oga24,type ", #add by huanglf170314  #ogaud03,ogaud01 add by qianyuan170420
                     "   FROM axmq003_tmp ",
                     " WHERE (ima131 = '",g_oga_1[p_ac].ima131,"' ",l_tmp2,")",
                     "   AND (oga23 = '",g_oga_1[p_ac].oga23,"' ",l_tmp,")",
                     " ORDER BY ima131,oga23,ogb05"
      #FUN-D10105--add--end--               
   END CASE

   PREPARE axmq003_pb_detail FROM l_sql
   DECLARE oga_curs_detail  CURSOR FOR axmq003_pb_detail        #CURSOR
   CALL g_oga.clear()
   CALL g_oga_attr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   LET g_tot_qty1 = 0
   LET g_tot_sum1 = 0
   LET g_tot_ori_sum1 = 0
   LET g_tot_ws_sum1 = 0 #add by huanglf170209
   
   FOREACH oga_curs_detail INTO g_oga_excel[g_cnt].*,l_oga24,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_tot_qty1 = g_tot_qty1 + g_oga_excel[g_cnt].ogb12
      LET g_tot_sum1 = g_tot_sum1 + g_oga_excel[g_cnt].ogb14t_o
      LET g_tot_ori_sum1 = g_tot_ori_sum1 + g_oga_excel[g_cnt].ogb14t
      LET g_tot_ws_sum1 = g_tot_ws_sum1 + g_oga_excel[g_cnt].ogb14t_2
      IF g_cnt < = g_max_rec THEN
         LET g_oga[g_cnt].* = g_oga_excel[g_cnt].*
      END IF
      IF l_type = 'Y' THEN
         CAll q003_color()
      END IF
      LET g_cnt = g_cnt + 1  
   END FOREACH
   IF g_cnt <= g_max_rec THEN
      CALL g_oga.deleteElement(g_cnt)
   END IF
   CALL g_oga_excel.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF g_rec_b > g_max_rec THEN
      CALL cl_err_msg(NULL,"axc-131",g_rec_b||"|"||g_max_rec,10)
      LET g_rec_b  = g_max_rec   #筆數顯示畫面檔的筆數
   END IF
   DISPLAY g_rec_b TO FORMONLY.cnt
   DISPLAY g_tot_qty1 TO FORMONLY.tot_qty1
   DISPLAY g_tot_sum1 TO FORMONLY.tot_sum1
   DISPLAY g_tot_ori_sum1 TO FORMONLY.tot_ori_sum1
   DISPLAY g_tot_ws_sum1 TO FORMONLY.tot_ws_sum1 #add by huanglf170209
END FUNCTION 

FUNCTION q003_color()
         LET g_oga_attr[g_cnt].oea00 = "red"
         LET g_oga_attr[g_cnt].ogb31 = "red"
         LET g_oga_attr[g_cnt].ogb32 = "red"
         LET g_oga_attr[g_cnt].oea10 = "red"
         LET g_oga_attr[g_cnt].oga011 = "red"
         LET g_oga_attr[g_cnt].oga00 = "red"
         LET g_oga_attr[g_cnt].oga08 = "red"
         LET g_oga_attr[g_cnt].oga01 = "red"
         LET g_oga_attr[g_cnt].oga02 = "red"
         LET g_oga_attr[g_cnt].oga03 = "red"
         LET g_oga_attr[g_cnt].oga032 = "red"
         LET g_oga_attr[g_cnt].occ03 = "red"   #FUN-D10105
         LET g_oga_attr[g_cnt].oca02 = "red"   #FUN-D10105
         LET g_oga_attr[g_cnt].oga04 = "red"
         LET g_oga_attr[g_cnt].occ02 = "red"
         LET g_oga_attr[g_cnt].oga14 = "red"
         LET g_oga_attr[g_cnt].gen02 = "red"
         LET g_oga_attr[g_cnt].oga15 = "red"
         LET g_oga_attr[g_cnt].gem02 = "red"
         LET g_oga_attr[g_cnt].oga23 = "red"
         LET g_oga_attr[g_cnt].oga21 = "red"
         LET g_oga_attr[g_cnt].oga211 = "red"
         LET g_oga_attr[g_cnt].oga213 = "red"
         LET g_oga_attr[g_cnt].oga65 = "red"
         LET g_oga_attr[g_cnt].oga10 = "red"
         LET g_oga_attr[g_cnt].ogaconf = "red"
         LET g_oga_attr[g_cnt].oga55 = "red"
         LET g_oga_attr[g_cnt].ogapost = "red"
         LET g_oga_attr[g_cnt].ogb03 = "red"
         LET g_oga_attr[g_cnt].ogb04 = "red"
         LET g_oga_attr[g_cnt].ogb06 = "red"
         LET g_oga_attr[g_cnt].ima021 = "red"
         LET g_oga_attr[g_cnt].ima131 = "red"   #FUN-D10105
         LET g_oga_attr[g_cnt].oba02 = "red"    #FUN-D10105
         LET g_oga_attr[g_cnt].ogb11 = "red"
         LET g_oga_attr[g_cnt].ogb09 = "red"
         LET g_oga_attr[g_cnt].ogb091 = "red"
         LET g_oga_attr[g_cnt].ogb092 = "red"
         LET g_oga_attr[g_cnt].ogb05 = "red"
         LET g_oga_attr[g_cnt].ogb12 = "red"
         LET g_oga_attr[g_cnt].ogb13 = "red"
         LET g_oga_attr[g_cnt].ogb14t = "red"
         LET g_oga_attr[g_cnt].ogb14t_2 = "red"  #add by huanglf170204
         LET g_oga_attr[g_cnt].ogb14t_o = "red"
         LET g_oga_attr[g_cnt].ogb50 = "red"
         LET g_oga_attr[g_cnt].ogb51 = "red"
         LET g_oga_attr[g_cnt].omb12 = "red"
         LET g_oga_attr[g_cnt].omb14t = "red"
         LET g_oga_attr[g_cnt].ogb41 = "red"
         LET g_oga_attr[g_cnt].ogb19 = "red"
         LET g_oga_attr[g_cnt].oga02_2 = "red" #add by huanglf170314
         LET g_oga_attr[g_cnt].ogaud04 = "red"
         LET g_oga_attr[g_cnt].ogaud05 = "red"
         LET g_oga_attr[g_cnt].ogaud03 = "red"
         LET g_oga_attr[g_cnt].ogaud01 = "red"
END FUNCTION

FUNCTION q003_set_visible()
   DEFINE l_wc     LIKE type_file.chr20
   CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                             oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",TRUE)   #FUN-D10105 occ03 oca02 ima131 oba02

   CASE tm.a 
      WHEN "1"
         CALL cl_set_comp_visible("oga08_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE) #FUN-D10105
      WHEN "2"
         CALL cl_set_comp_visible("oga00_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE) #FUN-D10105
      WHEN "3"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE) #FUN-D10105
      WHEN "4"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE) #FUN-D10105
      WHEN "5"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE) #FUN-D10105
      WHEN "6"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE) #FUN-D10105
      WHEN "7"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE) #FUN-D10105
      WHEN "8"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ima131_1,oba02_1",FALSE)          #FUN-D10105 
      WHEN "9"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,oga03_1,oga032_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1,ima131_1,oba02_1",FALSE)   #FUN-D10105
      WHEN "10"
         CALL cl_set_comp_visible("oga00_11,oga08_11,oga02_1,oga03_1,oga032_1,occ03_1,oca02_1,oga04_1,occ02_1,
                                   oga14_1,gen02_1,oga15_1,gem02_1,ogb04_1,ogb06_1,ima021_1",FALSE)  #FUN-D10105 
   END CASE
END FUNCTION 
 
#FUN-C90076
