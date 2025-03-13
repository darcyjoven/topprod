# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp200.4gl
# Descriptions...: 訂單整批處理作業
# Date & Author..: No.TQC-730022 07/03/13 By rainy
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.TQC-780007 07/08/02 By rainy 判斷axmi221如有勾走出通流程，則不能直接拋出貨單
#                                                   "         如沒勾出通流程，則在拋出貨單時，判斷已拋出通單的就不能再拋
# Modify.........: No.TQC-780059 07/08/17 By rainy TO_DATE informix不支援
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-810045 08/02/14 By rainy 拋轉出通/出貨單將項目相關欄位帶入
# Modify.........: No.MOD-820019 08/02/22 By claire 在IFX任意條件按確定會有-1316的錯誤
# Modify.........: No.FUN-7B0018 08/03/07 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-850221 08/05/28 By Smapmin 單身訂單資料訂金比率或尾款比率>0，不可合併出貨
# Modify.........: No.CHI-8B0007 08/11/07 By Smapmin 檢核是否允許拋轉出通/出貨單時,要做訊息的顯示
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/10 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.MOD-990225 09/09/25 By Dido 依彙總方式調整排序;並帶備註資料 
# Modify.........: No.MOD-990171 09/10/09 By mike 若訂單有走簽核，且出通單單別也有設定簽核，使用axmp200拋轉該訂單資料到出通單時，簽>
# Modify.........: No.TQC-9A0161 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0043 09/11/06 By wujie   5.2SQL转标准语法
# Modify.........: No:FUN-9C0071 10/01/08 By huangrh 精簡程式
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:MOD-B70106 11/07/17 By JoHung 1.不同的訂單類型不能一起選
#                                                   2.依據類別對應單別開窗
# Modify.........: No:CHI-B80050 11/09/09 By johung t400sub_y_upd增加參數p_inTransaction
# Modify.........: No:FUN-BB0083 11/12/21 By xujing 增加數量欄位小數取位
# Modify.........: No:TQC-C30113 12/03/06 By pauline 轉出貨單時 若產品為贈品且為禮券時寫入rxe_file 
# Modify.........: No:TQC-BC0066 12/05/10 By SunLM  已經部份拋轉出通/出貨單的訂單,不能進行批處理操作的問題
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No:FUN-C30085 12/07/10 By nanbing CR改串GR
# Modify.........: No:TQC-C80088 12/08/14 By zhuhao 點擊xx關不不了畫面
# Modify.........: No:TQC-C80100 12/08/28 By dongsz 1.參數Y改為空值
#                                                   2.字段類型chr1000->string
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea1   DYNAMIC ARRAY OF RECORD
                  a         LIKE type_file.chr1,   #選擇
                  oea02     LIKE oea_file.oea02,   #訂單日期
                  oea01     LIKE oea_file.oea01,   
                  oea00     LIKE oea_file.oea00,
                  oea08     LIKE oea_file.oea08,
                  oea03     LIKE oea_file.oea03,
                  oea032    LIKE oea_file.oea032,
                  oea04     LIKE oea_file.oea04,
                  occ02     LIKE occ_file.occ02,
                  oea10     LIKE oea_file.oea10,
                  oea23     LIKE oea_file.oea23,
                  oea21     LIKE oea_file.oea21,
                  oea31     LIKE oea_file.oea31,
                  oea32     LIKE oea_file.oea32,
                  oea14     LIKE oea_file.oea14,
                  gen02     LIKE gen_file.gen02,
                  oeaconf   LIKE oea_file.oeaconf,
                  oea49     LIKE oea_file.oea49
               END RECORD,
       g_oea1_t RECORD
                  a         LIKE type_file.chr1,   #選擇
                  oea02     LIKE oea_file.oea02,   #訂單日期
                  oea01     LIKE oea_file.oea01,   
                  oea00     LIKE oea_file.oea00,
                  oea08     LIKE oea_file.oea08,
                  oea03     LIKE oea_file.oea03,
                  oea032    LIKE oea_file.oea032,
                  oea04     LIKE oea_file.oea04,
                  occ02     LIKE occ_file.occ02,
                  oea10     LIKE oea_file.oea10,
                  oea23     LIKE oea_file.oea23,
                  oea21     LIKE oea_file.oea21,
                  oea31     LIKE oea_file.oea31,
                  oea32     LIKE oea_file.oea32,
                  oea14     LIKE oea_file.oea14,
                  gen02     LIKE gen_file.gen02,
                  oeaconf   LIKE oea_file.oeaconf,
                  oea49     LIKE oea_file.oea49
               END RECORD,
       g_oeb1   DYNAMIC ARRAY OF RECORD
                    oeb03     LIKE oeb_file.oeb03,
                    oeb04     LIKE oeb_file.oeb04,
                    att00     LIKE imx_file.imx00,  
                    att01     LIKE imx_file.imx03, 
                    att01_c   LIKE imx_file.imx03, 
                    att02     LIKE imx_file.imx03, 
                    att02_c   LIKE imx_file.imx03, 
                    att03     LIKE imx_file.imx03, 
                    att03_c   LIKE imx_file.imx03, 
                    att04     LIKE imx_file.imx03, 
                    att04_c   LIKE imx_file.imx03, 
                    att05     LIKE imx_file.imx03, 
                    att05_c   LIKE imx_file.imx03, 
                    att06     LIKE imx_file.imx03, 
                    att06_c   LIKE imx_file.imx03, 
                    att07     LIKE imx_file.imx03, 
                    att07_c   LIKE imx_file.imx03, 
                    att08     LIKE imx_file.imx03, 
                    att08_c   LIKE imx_file.imx03, 
                    att09     LIKE imx_file.imx03, 
                    att09_c   LIKE imx_file.imx03, 
                    att10     LIKE imx_file.imx03, 
                    att10_c   LIKE imx_file.imx03, 
                    oeb06     LIKE oeb_file.oeb06,
                    ima021    LIKE ima_file.ima021,
                    ima1002   LIKE ima_file.ima1002,
                    ima135    LIKE ima_file.ima135,
                    oeb11     LIKE oeb_file.oeb11,
                    oeb71     LIKE oeb_file.oeb71,
                    oeb1001   LIKE oeb_file.oeb1001,  
                    oeb1012   LIKE oeb_file.oeb1012,  
                    oeb906    LIKE oeb_file.oeb906,   
                    oeb092    LIKE oeb_file.oeb092,
                    oeb15     LIKE oeb_file.oeb15,     
                    oeb05     LIKE oeb_file.oeb05,
                    oeb12     LIKE oeb_file.oeb12,
                    oeb913    LIKE oeb_file.oeb913,
                    oeb914    LIKE oeb_file.oeb914,
                    oeb915    LIKE oeb_file.oeb915,
                    oeb910    LIKE oeb_file.oeb910,
                    oeb911    LIKE oeb_file.oeb911,
                    oeb912    LIKE oeb_file.oeb912,
                    oeb916    LIKE oeb_file.oeb916,
                    oeb917    LIKE oeb_file.oeb917,
                    oeb24     LIKE oeb_file.oeb24,
                    oeb27     LIKE oeb_file.oeb27,     
                    oeb28     LIKE oeb_file.oeb28,    
                    oeb1004   LIKE oeb_file.oeb1004,
                    oeb1002   LIKE oeb_file.oeb1002,
                    oeb13     LIKE oeb_file.oeb13,
                    oeb1006   LIKE oeb_file.oeb1006,  
                    oeb14     LIKE oeb_file.oeb14,
                    oeb14t    LIKE oeb_file.oeb14t,
                    oeb09     LIKE oeb_file.oeb09,
                    oeb091    LIKE oeb_file.oeb091,
                    oeb930    LIKE oeb_file.oeb930, 
                    gem02c    LIKE gem_file.gem02 , 
                    oeb908    LIKE oeb_file.oeb908, 
                    oeb22     LIKE oeb_file.oeb22,
                    oeb19     LIKE oeb_file.oeb19,
                    oeb70     LIKE oeb_file.oeb70,
                    ima15     LIKE ima_file.ima15,
                    oeb16     LIKE oeb_file.oeb16
               END RECORD,
       g_oeb1_t RECORD
                    oeb03     LIKE oeb_file.oeb03,
                    oeb04     LIKE oeb_file.oeb04,
                    att00     LIKE imx_file.imx00,  
                    att01     LIKE imx_file.imx03, 
                    att01_c   LIKE imx_file.imx03, 
                    att02     LIKE imx_file.imx03, 
                    att02_c   LIKE imx_file.imx03, 
                    att03     LIKE imx_file.imx03, 
                    att03_c   LIKE imx_file.imx03, 
                    att04     LIKE imx_file.imx03, 
                    att04_c   LIKE imx_file.imx03, 
                    att05     LIKE imx_file.imx03, 
                    att05_c   LIKE imx_file.imx03, 
                    att06     LIKE imx_file.imx03, 
                    att06_c   LIKE imx_file.imx03, 
                    att07     LIKE imx_file.imx03, 
                    att07_c   LIKE imx_file.imx03, 
                    att08     LIKE imx_file.imx03, 
                    att08_c   LIKE imx_file.imx03, 
                    att09     LIKE imx_file.imx03, 
                    att09_c   LIKE imx_file.imx03, 
                    att10     LIKE imx_file.imx03, 
                    att10_c   LIKE imx_file.imx03, 
                    oeb06     LIKE oeb_file.oeb06,
                    ima021    LIKE ima_file.ima021,
                    ima1002   LIKE ima_file.ima1002,
                    ima135    LIKE ima_file.ima135,
                    oeb11     LIKE oeb_file.oeb11,
                    oeb71     LIKE oeb_file.oeb71,
                    oeb1001   LIKE oeb_file.oeb1001,  
                    oeb1012   LIKE oeb_file.oeb1012,  
                    oeb906    LIKE oeb_file.oeb906,   
                    oeb092    LIKE oeb_file.oeb092,
                    oeb15     LIKE oeb_file.oeb15,     
                    oeb05     LIKE oeb_file.oeb05,
                    oeb12     LIKE oeb_file.oeb12,
                    oeb913    LIKE oeb_file.oeb913,
                    oeb914    LIKE oeb_file.oeb914,
                    oeb915    LIKE oeb_file.oeb915,
                    oeb910    LIKE oeb_file.oeb910,
                    oeb911    LIKE oeb_file.oeb911,
                    oeb912    LIKE oeb_file.oeb912,
                    oeb916    LIKE oeb_file.oeb916,
                    oeb917    LIKE oeb_file.oeb917,
                    oeb24     LIKE oeb_file.oeb24,
                    oeb27     LIKE oeb_file.oeb27,     
                    oeb28     LIKE oeb_file.oeb28,    
                    oeb1004   LIKE oeb_file.oeb1004,
                    oeb1002   LIKE oeb_file.oeb1002,
                    oeb13     LIKE oeb_file.oeb13,
                    oeb1006   LIKE oeb_file.oeb1006,  
                    oeb14     LIKE oeb_file.oeb14,
                    oeb14t    LIKE oeb_file.oeb14t,
                    oeb09     LIKE oeb_file.oeb09,
                    oeb091    LIKE oeb_file.oeb091,
                    oeb930    LIKE oeb_file.oeb930, 
                    gem02c    LIKE gem_file.gem02 , 
                    oeb908    LIKE oeb_file.oeb908, 
                    oeb22     LIKE oeb_file.oeb22,
                    oeb19     LIKE oeb_file.oeb19,
                    oeb70     LIKE oeb_file.oeb70,
                    ima15     LIKE ima_file.ima15,
                    oeb16     LIKE oeb_file.oeb16
               END RECORD,
       g_oea  RECORD       LIKE oea_file.*,       #訂單單頭
       g_oeb  RECORD       LIKE oeb_file.*,       #訂單單身
       g_oga  RECORD       LIKE oga_file.*,       #出貨單頭
       g_ogb  RECORD       LIKE ogb_file.*,       #出貨單身
       g_oga1 RECORD       LIKE oga_file.*,       #出貨單頭
       g_ogb1 RECORD       LIKE ogb_file.*,       #出貨單身
       g_oga01             LIKE oga_file.oga01,   #出貨單號
       begin_no,end_no     LIKE oga_file.oga01,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
       g_wc2,g_sql,g_ws1,g_ws2    STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5          
DEFINE lg_oay22      LIKE oay_file.oay22   #在oay_file中定義的與當前單別關聯的組別   
DEFINE lg_group      LIKE oay_file.oay22   #當前單身中采用的組別
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
#DEFINE g_msg          LIKE type_file.chr1000 #TQC-C80100 mark      
DEFINE g_msg          STRING                  #TQC-C80100 add
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   #TQC-680074
DEFINE tm RECORD			      #
          slip         LIKE oay_file.oayslip, #單據別
          dt           LIKE oeb_file.oeb16,   #出通/出貨日期
          g            LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_gfa  RECORD    LIKE gfa_file.*
DEFINE g_oeb15   LIKE oeb_file.oeb15        #預計交貨日
DEFINE g_wc_oea  STRING 
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
DEFINE g_renew   LIKE type_file.num5        
DEFINE g_ogbi    RECORD LIKE ogbi_file.*    #No.FUN-7B0018
DEFINE g_plant2  LIKE type_file.chr10       #FUN-980020
DEFINE g_type    LIKE type_file.chr1        #MOD-B70106 add
 
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   OPEN WINDOW p200_w WITH FORM "axm/42f/axmp200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   IF g_sma.sma120 = 'Y'  THEN                                                                                                      
      LET lg_oay22 = ''                                                                                                             
      LET lg_group = ''                                                                                                             
      CALL p200_refresh_detail()                                                                                                    
   END IF                                                                                                                           
 
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    #FUN-920166
 
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
 
   CALL p200_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL p200()
 
   CLOSE WINDOW p200_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION p200()
 
   
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p200_q()
      END IF
      CALL p200_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p200_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p200_sel_all('N')
 
         WHEN "order_detail" #訂單明細
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              LET g_msg = ' axmt410 "' , g_oea1_t.oea01 ,'"'
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
         WHEN "batch_confirm" #整批確認
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p200_batch_confirm()
           END IF
 
         WHEN "batch_print"  #列印訂單確認書
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p200_batch_out()
           END IF
 
         WHEN "carry_da"      #轉出通單
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL s_showmsg_init()    #MOD-850221
             CALL p200_dis_oga("2")
             CALL s_showmsg()       #MOD-850221
           END IF
 
         WHEN "carry_dn"      #轉出貨單
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL s_showmsg_init()    #MOD-850221
             CALL p200_dis_oga("1")
             CALL s_showmsg()       #MOD-850221
           END IF
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p200_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_oea1 WITHOUT DEFAULTS FROM s_oea.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
         BEFORE ROW
             IF g_renew THEN
               LET l_ac1 = ARR_CURR()
               IF l_ac1 = 0 THEN
                  LET l_ac1 = 1
               END IF
             END IF
             CALL fgl_set_arr_curr(l_ac1)
             LET g_renew = 1
             CALL cl_show_fld_cont()
             LET l_ac1_t = l_ac1
             LET g_oea1_t.* = g_oea1[l_ac1].*
 
             IF g_rec_b1 > 0 THEN
               CALL p200_b_fill()
               CALL p200_bp2('')
               CALL cl_set_act_visible("select_all,select_non,order_detail,batch_confirm,batch_print,carry_da,carry_dn", TRUE)
             ELSE
               CALL cl_set_act_visible("select_all,select_non,order_detail,batch_confirm,batch_print,carry_da,carry_dn", FALSE)
             END IF
 
         ON CHANGE a
            IF cl_null(g_oea1[l_ac1].a) THEN 
               LET g_oea1[l_ac1].a = 'Y'
            END IF
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT
 
         ON ACTION select_all   #全部選取
            LET g_action_choice="select_all"
            EXIT INPUT
 
         ON ACTION select_non   #全部不選
            LET g_action_choice="select_non"
            EXIT INPUT
 
         ON ACTION order_detail #訂單明細
            LET g_action_choice="order_detail"
            EXIT INPUT
 
         ON ACTION batch_confirm #整批確認
            LET g_action_choice="batch_confirm"
            EXIT INPUT
 
         ON ACTION batch_print   #列印訂單確認書
            LET g_action_choice="batch_print"
            EXIT INPUT
 
         ON ACTION carry_da      #轉出通單
            LET g_action_choice="carry_da"
            EXIT INPUT
 
         ON ACTION carry_dn      #轉出貨單
            LET g_action_choice="carry_dn"
            EXIT INPUT
 
         ON ACTION view
            CALL p200_bp2('V')
 
         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT     
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p200_q()
 
   CALL p200_b_askkey()
END FUNCTION
 
 
FUNCTION p200_b_askkey()
   CLEAR FORM
   CALL g_oea1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON oea02,oea01,oea00,oea08,oea03,oea04,oea10,oea23,oea21,
                      oea31,oea32,oea14,oeaconf,oea49
                 FROM s_oea[1].oea02,s_oea[1].oea01,s_oea[1].oea00,
                      s_oea[1].oea08,s_oea[1].oea03,s_oea[1].oea04,
                      s_oea[1].oea10,s_oea[1].oea23,s_oea[1].oea21,
                      s_oea[1].oea31,s_oea[1].oea32,s_oea[1].oea14,
                      s_oea[1].oeaconf,s_oea[1].oea49
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea03
                    NEXT FIELD oea03
               WHEN INFIELD(oea01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oea11"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea01
                    NEXT FIELD oea01
               WHEN INFIELD(oea04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    IF g_aza.aza50='Y' THEN
                       LET g_qryparam.form ="q_occ4"    
                    ELSE
                       LET g_qryparam.form ="q_occ" 
                    END IF
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea04
                    NEXT FIELD oea04
               WHEN INFIELD(oea14)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea14
                    NEXT FIELD oea14
               WHEN INFIELD(oea21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gec"
                    LET g_qryparam.arg1 = '2'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea21
                    NEXT FIELD oea21
               WHEN INFIELD(oea23)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea23
                    NEXT FIELD oea23
               WHEN INFIELD(oea31)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oah"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea31
                    NEXT FIELD oea31
               WHEN INFIELD(oea32)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oag"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO oea32
                    NEXT FIELD oea32
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL p200_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_oea1_t.* = g_oea1[l_ac1].*
 
   CALL p200_b_fill()
END FUNCTION
 
FUNCTION p200_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = "SELECT 'N',oea02,oea01,oea00,oea08,oea03,oea032,oea04,'',",
               "       oea10,oea23,oea21,oea31,oea32,oea14,'',oeaconf,oea49", 
               "  FROM oea_file ",
               " WHERE ",p_wc2 CLIPPED,
               "   AND oea00 IN ('1','2','3','4','6','7')",
               "   AND (oea901 = 'N' OR oea901 IS NULL) ",
               " ORDER BY oea02 DESC"
 
   PREPARE p200_pb1 FROM g_sql
   DECLARE oea_curs CURSOR FOR p200_pb1
  
   CALL g_oea1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oea_curs INTO g_oea1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   #No.FUN-660167
         EXIT FOREACH
      END IF
 
      SELECT occ02 INTO g_oea1[g_cnt].occ02
        FROM occ_file
       WHERE occ01 = g_oea1[g_cnt].oea04
 
      SELECT gen02 INTO g_oea1[g_cnt].gen02
        FROM gen_file
       WHERE gen01 = g_oea1[g_cnt].oea14
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_oea1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION p200_b_fill()
 
    LET g_sql =
        "SELECT oeb03,oeb04,'','','','','','','','','','','','','','','','',",
        "       '','','','','',oeb06,ima021,ima1002,ima135,oeb11,",  
        "       oeb71,oeb1001,oeb1012,",
        "       oeb906,oeb092,oeb15,oeb05,oeb12,",  
        "       oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,",
        "       oeb916,oeb917,oeb24,oeb27,oeb28,oeb1004,oeb1002,",  
        "       oeb13,oeb1006,oeb14,oeb14t,oeb09,oeb091,oeb930,'',",
        "       oeb908,oeb22,oeb19,oeb70,ima15,oeb16 ", 
        " FROM oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01 ",
        " WHERE oeb01 ='",g_oea1_t.oea01,"'",  #單頭
        " AND oeb1003='1' ",
        " ORDER BY oeb03"
 
   PREPARE p200_pb FROM g_sql
   DECLARE oeb_curs CURSOR FOR p200_pb
  
   CALL g_oeb1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oeb_curs INTO g_oeb1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_oeb1[g_cnt].att00,g_oeb1[g_cnt].att01,g_oeb1[g_cnt].att02,
                g_oeb1[g_cnt].att03,g_oeb1[g_cnt].att04,g_oeb1[g_cnt].att05,
                g_oeb1[g_cnt].att06,g_oeb1[g_cnt].att07,g_oeb1[g_cnt].att08,
                g_oeb1[g_cnt].att09,g_oeb1[g_cnt].att10
         FROM imx_file WHERE imx000 = g_oeb1[g_cnt].oeb04
 
         LET g_oeb1[g_cnt].att01_c = g_oeb1[g_cnt].att01
         LET g_oeb1[g_cnt].att02_c = g_oeb1[g_cnt].att02
         LET g_oeb1[g_cnt].att03_c = g_oeb1[g_cnt].att03
         LET g_oeb1[g_cnt].att04_c = g_oeb1[g_cnt].att04
         LET g_oeb1[g_cnt].att05_c = g_oeb1[g_cnt].att05
         LET g_oeb1[g_cnt].att06_c = g_oeb1[g_cnt].att06
         LET g_oeb1[g_cnt].att07_c = g_oeb1[g_cnt].att07
         LET g_oeb1[g_cnt].att08_c = g_oeb1[g_cnt].att08
         LET g_oeb1[g_cnt].att09_c = g_oeb1[g_cnt].att09
         LET g_oeb1[g_cnt].att10_c = g_oeb1[g_cnt].att10
                
      END IF
      LET g_oeb1[g_cnt].gem02c=s_costcenter_desc(g_oeb1[g_cnt].oeb930) 
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_oeb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p200_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   
  #CALL cl_set_act_visible("accept,cancel", FALSE)     #TQC-C80088 mark
   DISPLAY ARRAY g_oeb1 TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION return
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
      
      ON ACTION controlg 
         CALL cl_cmdask()
   END DISPLAY
 
END FUNCTION
 
FUNCTION p200_refresh_detail()
  DEFINE l_compare          LIKE oay_file.oay22    
  DEFINE li_col_count       LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_i, li_j         LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' ) AND NOT cl_null(lg_oay22) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_oay22來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_oeb1.getLength() = 0 THEN
        LET lg_group = lg_oay22
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_oeb1.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_oeb1[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_oeb1[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_compare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_oay22 THEN                                                                                               
            LET lg_group = ''                                                                                                       
            EXIT FOR                                                                                                                
         END IF
       END FOR 
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替oeb04子料件編號來顯示
     #得到當前語言別下oeb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'oeb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'oeb04,oeb06'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'oeb04,oeb06'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'oeb04'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
FUNCTION p200_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_oea1[l_i].a = p_flag
    DISPLAY BY NAME g_oea1[l_i].a
  END FOR
END FUNCTION
 
 
FUNCTION p200_init()
 
   IF g_aza.aza50 = 'N'THEN
       CALL cl_set_comp_visible("oeb11,oeb1012,oeb1004,oeb1002,
                                 oeb1006,oeb09,oeb091,tqa02_a,tqa02_b,tqb02_b,
                                 oea1011,occ02_d,oea1010,tqb02_a,ttl2,ttl1,
                                 ttl3,oea1006,dummy01,dummy02,page07,",FALSE)
   END IF
   IF g_aza.aza50='Y' THEN
       CALL cl_set_comp_visible("ima1002,ima135,oeb11,oeb1012,oeb1004,oeb1002,
                                 oeb1006,oeb09,oeb091,",TRUE)
   ELSE
       CALL cl_set_comp_visible("ima1002,ima135,oeb11,oeb1012,oeb1004,oeb1002,
                                 oeb1006,oeb09,oeb091,",FALSE)
   END IF
 
    CALL cl_set_comp_visible("oeb911,oeb914",FALSE)
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("oeb913,oeb914,oeb915",FALSE)
       CALL cl_set_comp_visible("oeb910,oeb911,oeb912",FALSE)
    ELSE
       CALL cl_set_comp_visible("oeb05,oeb12",FALSE)
    END IF
    IF g_sma.sma116 MATCHES '[01]' THEN  
       CALL cl_set_comp_visible("oeb916,oeb917",FALSE)
    END IF
    
    
    CALL cl_set_comp_visible("oeb930,gem02c",g_aaz.aaz90='Y')  #FUN-670063
 
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_oay22 = ''
    LET lg_group = ''
    CALL p200_refresh_detail()
    
END FUNCTION
 
#批次列印訂單確認書
FUNCTION p200_batch_out()
  DEFINE l_wc STRING
  DEFINE l_i,l_n  LIKE type_file.num5
         
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
    IF g_oea1[l_i].a = 'Y' THEN
      LET l_n = l_n + 1
    END IF
  END FOR 
 
  IF l_n = 0 THEN RETURN END IF  #都沒勾選
  
  LET l_n = 0 
  LET l_wc = " oea01 IN ("
  FOR l_i = 1 TO g_rec_b1
     IF g_oea1[l_i].a = 'Y' THEn
        LET l_n = l_n + 1
        IF l_n = 1 THEN
           LET l_wc = l_wc CLIPPED,"'",g_oea1[l_i].oea01 CLIPPED,"'"
        ELSE
           LET l_wc = l_wc CLIPPED,",'",g_oea1[l_i].oea01 CLIPPED,"'"
        END IF
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED,")"                                                                                     
  LET l_wc = cl_replace_str( l_wc , "'" , "\"" )
 
  #LET g_msg = " axmr400", #FUN-C30085 mark
  LET g_msg = " axmg400", #FUN-C30085 add
        " '",g_today CLIPPED,"' ''", #1 2
        " '",g_lang CLIPPED ,"'",   #3
        " 'Y' '' '1'",              #4 5 6
        " '",l_wc CLIPPED,"'",      #7
        " 'Y' 'Y'",               #8 9 
        " '' '' ''",
      # " 'Y' 'Y'",               #13 14          #TQC-C80100 mark
        " '' 'Y'",                #13 14          #TQC-C80100 add
        " '' '' ''"                #15 16 17
  CALL cl_cmdrun(g_msg)
END FUNCTION
 
 
FUNCTION p200_chk_oea(p_type)
  DEFINE p_type         LIKE type_file.chr1  #1:出貨單  2:出通單
  DEFINE l_i,l_n,l_cnt  LIKE type_file.num5
  DEFINE l_occ56        LIKE occ_file.occ56   #TQC-780007
  DEFINE l_oea00_o      LIKE oea_file.oea00  #MOD-B70106 add
  DEFINE l_oea00_n      LIKE oea_file.oea00  #MOD-B70106 add
  DEFINE l_oeb     DYNAMIC ARRAY OF RECORD   #TQC-BC0066
                 oeb01  LIKE oeb_file.oeb01,
                 oeb03  LIKE oeb_file.oeb03,
                 oeb12  LIKE oeb_file.oeb12
                   END RECORD
  DEFINE l_sql          STRING               #TQC-BC0066
  DEFINE l_ac           LIKE type_file.num5  #TQC-BC0066
  DEFINE l_ogb12        LIKE ogb_file.ogb12  #TQC-BC0066
  
  LET l_n = 0  
  FOR l_i = 1 TO g_rec_b1
    IF g_oea1[l_i].a = 'Y' THEN  #有勾選
#MOD-B70106 -- start --
       #CHECK 是否類型訂單類型是否有不同 如果有就不能轉
        LET g_type = p_type
        LET l_oea00_n = g_oea1[l_i].oea00
        IF l_oea00_n <> l_oea00_o AND l_i > 1 THEN
           LET l_n = 0
           CALL s_errmsg('oea01',g_oea1[l_i].oea01,'','axm-092',1)
           EXIT FOR
        ELSE
           IF l_oea00_n = '3' AND p_type = '1' THEN
              LET g_type = '3'  #出至境外倉出貨單
           END IF
           IF l_oea00_n = '3' AND p_type = '2' THEN
              LET g_type = '4'  #出至境外倉出通單
           END IF
           IF l_oea00_n = '4' AND p_type = '1' THEN
              LET g_type = '5'  #境外倉出貨單
           END IF
           IF l_oea00_n = '4' AND p_type = '2' THEN
              LET g_type = '6'  #境外倉出通單
           END IF
        END IF
        LET l_oea00_o = l_oea00_n
#MOD-B70106 -- end --
      #要是"已確認"且"已核准"的資料
      IF NOT (g_oea1[l_i].oeaconf = 'Y' AND g_oea1[l_i].oea49 = '1')  THEN
        LET g_oea1[l_i].a = 'N'  #將勾勾拿掉
        DISPLAY BY NAME g_oea1[l_i].a
        CALL s_errmsg('oea01',g_oea1[l_i].oea01,'','axm-651',1)   #CHI-8B0007
      ELSE
       #CHECK 是否已轉過資料 如果有轉過的就不能再轉
        LET l_cnt = 0
#TQC-BC0066 mark begin"
#        IF p_type = '1' THEN #出貨單
#          SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
#           WHERE oga01 = ogb01
#             AND ogaconf <> 'X'
#             AND ogb31 = g_oea1[l_i].oea01
#             AND oga09 IN ('2','3','4','6')
#        ELSE
#          SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
#           WHERE oga01 = ogb01
#             AND ogaconf <> 'X'
#             AND ogb31 = g_oea1[l_i].oea01
#             AND oga09 IN ('1','5')
#        END IF
#        IF l_cnt > 0 THEN
#          LET g_oea1[l_i].a = 'N'  #將勾勾拿掉
#          CALL s_errmsg('oea01',g_oea1[l_i].oea01,'','axm-652',1)   #CHI-8B0007
#        ELSE
#TQC-BC0066 mark end
#TQC-BC0066 add begin
        LET g_oea1[l_i].a = 'N' #初始化N
        LET l_ac = 1
        LET l_sql = " SELECT oeb01,oeb03,oeb12 FROM oeb_file ",
                    "  WHERE oeb01= '",g_oea1[l_i].oea01,"'"
        PREPARE p200_prepare2  FROM l_sql
        DECLARE p200_chk_oeb CURSOR FOR p200_prepare2 
        FOREACH p200_chk_oeb INTO l_oeb[l_ac].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           LET l_ogb12 = 0
           IF p_type = '1' THEN #出貨單
             SELECT SUM(ogb12) INTO l_ogb12 FROM oga_file,ogb_file
              WHERE oga01 = ogb01
                AND ogaconf <> 'X'
                AND ogb31 = g_oea1[l_i].oea01
                AND ogb32 = l_oeb[l_ac].oeb03
                AND oga09 IN ('2','3','4','6')
           ELSE
             SELECT SUM(ogb12) INTO l_ogb12 FROM oga_file,ogb_file
              WHERE oga01 = ogb01
                AND ogaconf <> 'X'
                AND ogb31 = g_oea1[l_i].oea01
                AND ogb32 = l_oeb[l_ac].oeb03
                AND oga09 IN ('1','5')
           END IF           
           IF cl_null(l_ogb12) THEN 
              LET l_ogb12 = 0
           END IF    
           #整筆訂單單身,只要有一筆未拋轉完,就將其賦值Y
           IF l_ogb12 < l_oeb[l_ac].oeb12 THEN #未完全拋轉完訂單
              LET g_oea1[l_i].a = 'Y'  #將勾勾打上
              EXIT FOREACH                 
           END IF    
           LET l_ac = l_ac + 1
        END FOREACH         
        IF g_oea1[l_i].a = 'N' THEN
           CALL s_errmsg('oea01',g_oea1[l_i].oea01,'','axm-652',1) 
           DISPLAY BY NAME g_oea1[l_i].a
        END IF   
#TQC-BC0066 add end
        IF g_oea1[l_i].a = 'Y' THEN  #TQC-BC0066 add
#          IF p_type = '1' THEN  #判斷客戶如要走出通流程，則不可直接拋出貨單   #MOD-B70106 mark 
           IF g_type = '1' OR g_type = '3' OR g_type = '5' THEN #出貨單        #MOD-B70106 add
              SELECT occ56 INTO l_occ56 FROM occ_file
               WHERE occ01 = g_oea1[l_i].oea03
              IF l_occ56 = 'Y' THEN   #要走出通流程，不可拋出貨單
                 LET g_oea1[l_i].a = 'N'  #將勾勾拿掉
                 CALL s_errmsg('oea01',g_oea1[l_i].oea01,'','axm-653',1)   #CHI-8B0007
              ELSE
                 #判斷是否已拋過出通單，如已拋過則不可再拋出貨單
                 SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
                  WHERE oga01 = ogb01
                    AND ogaconf <> 'X'
                    AND ogb31 = g_oea1[l_i].oea01
                    AND oga09 IN ('1','5')
                 IF l_cnt > 0 THEN
                   LET g_oea1[l_i].a = 'N'  #將勾勾拿掉
                   CALL s_errmsg('oea01',g_oea1[l_i].oea01,'','axm-654',1)   #CHI-8B0007
                 ELSE
                   LET l_n = l_n + 1
                 END IF
              END IF
           ELSE
             LET l_n = l_n + 1
           END IF
        END IF 
      END IF 
    END IF
  END FOR
 
  IF l_n > 0 THEN
    RETURN TRUE
  ELSE
    RETURN FALSE
  END IF
END FUNCTION
 
 
 
FUNCTION p200_dis_oga(p_type)
   DEFINE p_type    LIKE  type_file.chr1    #1:轉出貨單   2:轉出通單
 
  DEFINE l_oea00   LIKE oea_file.oea00        #類別
  DEFINE l_oea03   LIKE oea_file.oea03        #帳款客戶編號
  DEFINE l_oea04   LIKE oea_file.oea04        #送貨客戶編號
  DEFINE l_oea044  LIKE oea_file.oea044       #送貨地址碼
  DEFINE l_oea05   LIKE oea_file.oea05        #發票別
  DEFINE l_oea06   LIKE oea_file.oea06        #訂單維護作業預設起始版本編號
  DEFINE l_oea07   LIKE oea_file.oea07        #出貨是否計入未開發票的銷貨待驗收入
  DEFINE l_oea08   LIKE oea_file.oea08        #內/外銷
  DEFINE l_oea1001 LIKE oea_file.oea1001
  DEFINE l_oea1002 LIKE oea_file.oea1002
  DEFINE l_oea1003 LIKE oea_file.oea1003
  DEFINE l_oea1004 LIKE oea_file.oea1004
  DEFINE l_oea1005 LIKE oea_file.oea1005
  DEFINE l_oea1009 LIKE oea_file.oea1009
  DEFINE l_oea1010 LIKE oea_file.oea1010
  DEFINE l_oea1011 LIKE oea_file.oea1011
  DEFINE l_oea1015 LIKE oea_file.oea1015      #FUN-630102 add
  DEFINE l_oea14   LIKE oea_file.oea14        #人員編號
  DEFINE l_oea15   LIKE oea_file.oea15        #部門編號
  DEFINE l_oea161  LIKE oea_file.oea161       #訂金應收比率
  DEFINE l_oea162  LIKE oea_file.oea162       #出貨應收比率
  DEFINE l_oea163  LIKE oea_file.oea163       #尾款應收比率
  DEFINE l_oea17   LIKE oea_file.oea17        #收款客戶編號
  DEFINE l_oea21   LIKE oea_file.oea21        #稅別
  DEFINE l_oea211  LIKE oea_file.oea211       #稅率
  DEFINE l_oea212  LIKE oea_file.oea212       #聯數
  DEFINE l_oea213  LIKE oea_file.oea213       #含稅否
  DEFINE l_oea23   LIKE oea_file.oea23        #幣別
  DEFINE l_oea25   LIKE oea_file.oea25        #銷售分類一
  DEFINE l_oea26   LIKE oea_file.oea26        #銷售分類二
  DEFINE l_oea31   LIKE oea_file.oea31        #價格條件編碼
  DEFINE l_oea32   LIKE oea_file.oea32        #收款條件編碼
  DEFINE l_oea41   LIKE oea_file.oea41        #起運地
  DEFINE l_oea42   LIKE oea_file.oea42        #到達地
  DEFINE l_oea43   LIKE oea_file.oea43        #交運方式
  DEFINE l_oea44   LIKE oea_file.oea44        #嘜頭編號
  DEFINE l_oea45   LIKE oea_file.oea45        #聯絡人
  DEFINE l_oea46   LIKE oea_file.oea46        #專案編號
  DEFINE l_oea901  LIKE oea_file.oea901       #三角貿易否
  DEFINE l_oea65   LIKE oea_file.oea65
  DEFINE l_oea01   LIKE oea_file.oea01        #訂單單號
  DEFINE l_buf1    LIKE oea_file.oea01        #單別
 
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_wc    STRING
  LET begin_no = NULL
  LET end_no = NULL
  IF NOT  p200_chk_oea(p_type) THEN RETURN END IF
# CASE p_type                                                    #MOD-B70106 mark
#  WHEN "1" #出貨單                                              #MOD-B70106 mark
  CASE                                                           #MOD-B70106 add
   WHEN g_type = "1" OR g_type = "3" OR g_type = "5"   #出貨單   #MOD-B70106 add
     DECLARE p200_gfa_1 CURSOR FOR
      SELECT * FROM gfa_file 
       WHERE gfa01 = '1'  AND gfa03 ='axmt620'
     FOREACH p200_gfa_1 INTO g_gfa.*
        EXIT FOREACH
     END FOREACH
 
#  WHEN "2" #出通單                                              #MOD-B70106 mark
   WHEN g_type = "2" OR g_type = "4" OR g_type = "6"   #出通單   #MOD-B70106 add

     DECLARE p200_gfa_2 CURSOR FOR
      SELECT * FROM gfa_file 
       WHERE gfa01 = '1'  AND gfa03 ='axmt610'
     FOREACH p200_gfa_2 INTO g_gfa.*
        EXIT FOREACH
     END FOREACH
  END CASE
 
  OPEN WINDOW p200_exp WITH FORM "axm/42f/axmp200a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale("axmp200a")
   
  IF p_type = "2" THEN
      CALL cl_getmsg('axm-371',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("dt",g_msg CLIPPED)
  END IF
 
# LET tm.slip = g_gfa.gfa05  #預設單據別   #MOD-B70106 mark
#MOD-B70106 -- start --
  IF g_type < '3' THEN
     LET tm.slip = g_gfa.gfa05  #預設單據別
  ELSE
     LET tm.slip = null  #預設單據別
  END IF
#MOD-B70106 -- end --
  LET tm.dt = g_today        
  LET tm.g = "3"
  DISPLAY BY NAME tm.slip,tm.dt,tm.g
  LET g_success = 'Y'
  BEGIN WORK
  INPUT BY NAME tm.slip,tm.dt,tm.g  WITHOUT DEFAULTS
    AFTER FIELD slip
      IF NOT cl_null(tm.slip) THEN  
         LET g_cnt = 0
#MOD-B70106 -- begin --
#        IF p_type = "1" THEN
#          SELECT COUNT(*) INTO g_cnt FROM oay_file
#           WHERE oayslip = tm.slip AND oaytype = '50' 
#        ELSE
#          SELECT COUNT(*) INTO g_cnt FROM oay_file
#           WHERE oayslip = tm.slip AND oaytype = '40' 
#        END IF
         CASE g_type
           WHEN "1"
             SELECT COUNT(*) INTO g_cnt FROM oay_file
             WHERE oayslip = tm.slip AND oaytype = '50'
           WHEN "2"
             SELECT COUNT(*) INTO g_cnt FROM oay_file
             WHERE oayslip = tm.slip AND oaytype = '40'
           WHEN "3"
             SELECT COUNT(*) INTO g_cnt FROM oay_file
             WHERE oayslip = tm.slip AND oaytype = '53'
           WHEN "4"
             SELECT COUNT(*) INTO g_cnt FROM oay_file
             WHERE oayslip = tm.slip AND oaytype = '43'
           WHEN "5"
             SELECT COUNT(*) INTO g_cnt FROM oay_file
             WHERE oayslip = tm.slip AND oaytype = '54'
           WHEN "6"
             SELECT COUNT(*) INTO g_cnt FROM oay_file
             WHERE oayslip = tm.slip AND oaytype = '44'
         END CASE
#MOD-B70106 -- end
         IF SQLCA.sqlcode OR cl_null(tm.slip) THEN  
            LET g_cnt = 0
         END IF
         IF g_cnt = 0 THEN
            CALL cl_err(tm.slip,'aap-010',0)       
            NEXT FIELD slip
         END IF
#MOD-B70106 -- begin --
#        IF p_type = "1" THEN
#          CALL s_check_no("axm",tm.slip,"",'50',"oga_file","oga01","")
#             RETURNING li_result,tm.slip
#        ELSE
#          CALL s_check_no("axm",tm.slip,"",'40',"oga_file","oga01","")
#             RETURNING li_result,tm.slip
#        END IF
         CASE g_type
           WHEN "1"
             CALL s_check_no("axm",tm.slip,"",'50',"oga_file","oga01","")
               RETURNING li_result,tm.slip
           WHEN "2"
             CALL s_check_no("axm",tm.slip,"",'40',"oga_file","oga01","")
               RETURNING li_result,tm.slip
           WHEN "3"
             CALL s_check_no("axm",tm.slip,"",'53',"oga_file","oga01","")
               RETURNING li_result,tm.slip
           WHEN "4"
             CALL s_check_no("axm",tm.slip,"",'43',"oga_file","oga01","")
               RETURNING li_result,tm.slip
           WHEN "5"
             CALL s_check_no("axm",tm.slip,"",'54',"oga_file","oga01","")
               RETURNING li_result,tm.slip
           WHEN "6"
             CALL s_check_no("axm",tm.slip,"",'44',"oga_file","oga01","")
               RETURNING li_result,tm.slip
         END CASE
#MOD-B70106 -- end --
         DISPLAY BY NAME tm.slip
#MOD-B70106 -- begin --
      ELSE
        CALL cl_err(tm.slip,'aar-011',0)
        NEXT FIELD slip
#MOD-B70106 -- end --
      END IF
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW p200_exp
         RETURN
      END IF
  
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
#             CASE p_type   #MOD-B70106 mark
              CASE g_type   #MOD-B70106
                WHEN "1"  #出貨單
                    CALL q_oay(FALSE,FALSE,'','50','AXM')   
                       RETURNING tm.slip
                WHEN "2"  #出通單
                    CALL q_oay(FALSE,FALSE,'','40','AXM')   
                       RETURNING tm.slip
#MOD-B70106 -- begin --
                WHEN "3"  #出貨單
                    CALL q_oay(FALSE,FALSE,'','53','AXM')
                       RETURNING tm.slip
                WHEN "4"  #出貨單
                    CALL q_oay(FALSE,FALSE,'','43','AXM')
                       RETURNING tm.slip
                WHEN "5"  #出貨單
                    CALL q_oay(FALSE,FALSE,'','54','AXM')
                       RETURNING tm.slip
                WHEN "6"  #出貨單
                    CALL q_oay(FALSE,FALSE,'','44','AXM')
                       RETURNING tm.slip
#MOD-B70106 -- end --
              END CASE
              DISPLAY BY NAME tm.slip   
              NEXT FIELD slip
            OTHERWISE EXIT CASE
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
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     LET g_success = 'N'
     ROLLBACK WORK      
     CLOSE WINDOW p200_exp
     RETURN
  END IF
  CLOSE WINDOW p200_exp
 
 
  LET l_wc = " oea01 in ("
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
     IF g_oea1[l_i].a = 'Y' THEN
        LET l_n = l_n + 1
        IF l_n = 1 THEN
          LET l_wc = l_wc CLIPPED,"'",g_oea1[l_i].oea01,"'"
        ELSE
          LET l_wc = l_wc CLIPPED,",'",g_oea1[l_i].oea01,"'"
        END IF
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED ,")"
  
 
 
  CASE tm.g
    WHEN "1"   #客戶+預計出貨日 (oea03+oeb15)
      LET g_sql = "SELECT DISTINCT '','',oeb15,"
    WHEN "2"   #客戶+單別      (oea03+substr(oea01,1,aza41)  #依系統設定抓單據位數
      LET g_sql = "SELECT DISTINCT oea01[1,",t_aza41,"],'','',"     #No.FUN-9B0043
    WHEN "3"   #不匯總         (oea01)
      LET g_sql = "SELECT DISTINCT '',oea01,'',"
  END CASE 
 
  LEt g_sql = g_sql ,"oea00,oea03,oea04,oea044,oea05,oea06,oea07,oea08,",  
              "       oea1001,oea1002,oea1003,oea1004,oea1005,oea1009,oea1010,",
              "       oea1011,oea1015,oea14,oea15,oea161,oea162,oea163,oea17,oea21,",
              "       oea211,oea212,oea213,oea23,oea25,oea26,oea31,oea32,oea41,",
              "       oea42,oea43,oea44,oea45,oea46,oea901,oea65",
              "  FROM  oea_file,oeb_file ",
              " WHERE oea01 = oeb01 ",
              "   AND (oeb12-oeb24+oeb25) > 0",
              "   AND oeb70 = 'N'",
              "   AND ",l_wc 
  CASE 
    WHEN (tm.g = "1" OR tm.g = "2")   
      LET g_sql = g_sql,"  ORDER BY oea03"
    WHEN tm.g = "3"  
      LET g_sql = g_sql,"  ORDER BY oea01"
  END CASE 
  PREPARE oea_pre FROM g_sql
  DECLARE oea_cur2 CURSOR FOR oea_pre
  FOREACH oea_cur2 INTO  l_buf1 ,  l_oea01,  g_oeb15,
                         l_oea00,l_oea03,  l_oea04,  l_oea044, l_oea05,  l_oea06,  
                         l_oea07,  l_oea08,  l_oea1001,l_oea1002,l_oea1003,
                         l_oea1004,l_oea1005,l_oea1009,l_oea1010,l_oea1011,
                         l_oea1015,l_oea14,  l_oea15,  l_oea161, l_oea162, 
                         l_oea163, l_oea17,  l_oea21,  l_oea211, l_oea212,
                         l_oea213, l_oea23,  l_oea25,  l_oea26,  l_oea31, 
                         l_oea32,l_oea41,    l_oea42,  l_oea43,  l_oea44,
                         l_oea45,  l_oea46,  l_oea901, l_oea65
 
      ###在這一個foreach迴圈中就已經決定了要併成幾張出通/出貨單
       LET g_ws2 = ' '
       IF NOT cl_null(l_oea04) THEN 
          LET g_ws2 = g_ws2,"   AND oea04 = '", l_oea04,"'"
       ELSE 
          LET g_ws2 = g_ws2, "  AND oea04 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea044) THEN 
          LET g_ws2 = g_ws2,"   AND oea044 = '",l_oea044,"'"
       ELSE
          LET g_ws2 = g_ws2,"   AND oea044 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea05) THEN 
          LET g_ws2=g_ws2,"   AND oea05 = '", l_oea05, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea05 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea06) THEN 
          LET g_ws2=g_ws2,"   AND oea06 = ",  l_oea06 
       ELSE
          LET g_ws2=g_ws2,"   AND oea06 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea07) THEN 
          LET g_ws2=g_ws2,"   AND oea07 = '", l_oea07, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND oea07 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea08) THEN 
          LET g_ws2=g_ws2,"   AND oea08 = '", l_oea08, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea08 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1001) THEN 
          LET g_ws2=g_ws2,"   AND oea1001='", l_oea1001,"'"
       ELSE
          LET g_ws2=g_ws2,"   ANd oea1001 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1002) THEN 
          LET g_ws2=g_ws2,"   AND oea1002='", l_oea1002,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea1002 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1003) THEN 
          LET g_ws2=g_ws2,"   AND oea1003='", l_oea1003,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea1003 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1004) THEN 
          LET g_ws2=g_ws2,"   AND oea1004='", l_oea1004,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea1004 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1005) THEN 
          LET g_ws2=g_ws2,"   AND oea1005='", l_oea1005,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea1005 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1009) THEN 
          LET g_ws2=g_ws2,"   AND oea1009='", l_oea1009,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea1009 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1010) THEN 
          LET g_ws2=g_ws2,"   AND oea1010='", l_oea1010,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea1010 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1011) THEN 
          LET g_ws2=g_ws2,"   AND oea1011='", l_oea1011,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea1011 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea1015) THEN 
          LET g_ws2=g_ws2,"   AND oea1015='", l_oea1015,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND (oea1015 = ' ' OR oea1015 IS NULL) "
       END IF
 
       IF NOT cl_null(l_oea14) THEN 
          LET g_ws2=g_ws2,"   AND oea14 = '", l_oea14,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea14 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea15) THEN 
          LET g_ws2=g_ws2,"   AND oea15 = '", l_oea15,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea15 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea161) THEN 
          LET g_ws2=g_ws2,"   AND oea161= ",  l_oea161
       ELSE
          LET g_ws2=g_ws2,"   AND oea161 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea162) THEN 
          LET g_ws2=g_ws2,"   AND oea162= ",  l_oea162 
       ELSE
          LET g_ws2=g_ws2,"   AND oea162 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea163) THEN 
          LET g_ws2=g_ws2,"   AND oea163= ",  l_oea163
       ELSE
          LET g_ws2=g_ws2,"   AND oea163 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea17) THEN 
          LET g_ws2=g_ws2,"   AND oea17 = '", l_oea17, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea17 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea21) THEN 
          LET g_ws2=g_ws2,"   AND oea21 = '", l_oea21, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea21 IS NULL "
       END IF
 
       IF NOT cl_null(l_oea211) THEN 
          LET g_ws2=g_ws2,"   AND oea211= ",  l_oea211
       ELSE
          LET g_ws2=g_ws2,"   AND oea211 IS NULL "
       END IF
       IF NOT cl_null(l_oea212) THEN 
          LET g_ws2=g_ws2,"   AND oea212= '", l_oea212,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea212 IS NULL "
       END IF
       IF NOT cl_null(l_oea213) THEN 
          LET g_ws2=g_ws2,"   AND oea213= '", l_oea213,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea213 IS NULL "
       END IF
       IF NOT cl_null(l_oea23) THEN 
          LET g_ws2=g_ws2,"   AND oea23 = '", l_oea23, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea23 IS NULL "
       END IF
       IF NOT cl_null(l_oea25) THEN 
          LET g_ws2=g_ws2,"   AND oea25 = '", l_oea25, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea25 IS NULL "
       END IF
       IF NOT cl_null(l_oea26) THEN 
          LET g_ws2=g_ws2,"   AND oea26 = '", l_oea26, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea26 IS NULL "
       END IF
       IF NOT cl_null(l_oea31) THEN 
          LET g_ws2=g_ws2,"   AND oea31 = '", l_oea31, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea31 IS NULL "
       END IF
       IF NOT cl_null(l_oea32) THEN 
          LET g_ws2=g_ws2,"   AND oea32 = '", l_oea32, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea32 IS NULL "
       END IF
       IF NOT cl_null(l_oea41) THEN 
          LET g_ws2=g_ws2,"   AND oea41 = '", l_oea41, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea41 IS NULL "
       END IF
       IF NOT cl_null(l_oea42) THEN 
          LET g_ws2=g_ws2,"   AND oea42 = '", l_oea42, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea42 IS NULL "
       END IF
       IF NOT cl_null(l_oea43) THEN 
          LET g_ws2=g_ws2,"   AND oea43 = '", l_oea43, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea43 IS NULL "
       END IF
       IF NOT cl_null(l_oea44) THEN 
          LET g_ws2=g_ws2,"   AND oea44 = '", l_oea44, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea44 IS NULL "
       END IF
       IF NOT cl_null(l_oea45) THEN 
          LET g_ws2=g_ws2,"   AND oea45 = '", l_oea45, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea45 IS NULL "
       END IF
       IF NOT cl_null(l_oea46) THEN 
          LET g_ws2=g_ws2,"   AND oea46 = '", l_oea46, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea46 IS NULL "
       END IF
       IF NOT cl_null(l_oea901) THEN 
          LET g_ws2=g_ws2,"   AND oea901= '", l_oea901,"'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea901 IS NULL "
       END IF
       IF NOT cl_null(l_oea65) THEN 
          LET g_ws2=g_ws2,"   AND oea65 = '", l_oea65, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND oea65 IS NULL "
       END IF
 
      CASE tm.g
        WHEN "1"  #依客戶+日期
          LET g_sql = "SELECT oea_file.* FROM oea_file,oeb_file",
                      " WHERE oea01 = oeb01 "
 
          LET g_ws1 = "   AND oea03 = '", l_oea03,"'",
                            "   AND oeb15 = '", g_oeb15,"' ",                         #TQC-780059
                            "   AND ",l_wc,
                            "   AND (oeb12-oeb24+oeb25) > 0",
                            "   AND oeb70 = 'N'",
                            "   AND oea00 = '", l_oea00,"'"
          LET g_sql = g_sql ,g_ws1 CLIPPED ,g_ws2 CLIPPED
 
        WHEN "2"  #依客戶+單別
          LET g_sql = "SELECT oea_file.* FROM oea_file,oeb_file ",
                      " WHERE oea01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'",   #No.FUN-9B0043 
                      "   AND oea01 = oeb01"
          LET g_ws1 = "   AND oea03 = '", l_oea03,"'",
                      "   AND ",l_wc,
                      "   AND (oeb12-oeb24+oeb25) > 0",
                      "   AND oeb70 = 'N'",
                      "   AND oea00 = '", l_oea00,"'"
          LET g_sql = g_sql ,g_ws1 CLIPPED ,g_ws2 CLIPPED
 
        WHEN "3"  #不匯總   
          LET g_sql = "SELECT * FROM oea_file ",
                      " WHERE oea01 ='", l_oea01, "'"
      END CASE
 
      LET g_wc_oea = NULL   
      PREPARE oea_pre1  FROM g_sql
      DECLARE p200_oea_cs                         #SCROLL CURSOR
        SCROLL CURSOR FOR oea_pre1
      FOREACH p200_oea_cs INTO g_oea.*
         IF cl_null(g_wc_oea) THEN
           LET g_wc_oea = " oea01 IN('",g_oea.oea01,"'"
         ELSE
           LET g_wc_oea = g_wc_oea,",'",g_oea.oea01,"'"
         END IF
      END FOREACH
      IF NOT cl_null(g_wc_oea) THEN LET g_wc_oea=g_wc_oea,")" END IF
 
      CALL p200_ins_oga(p_type)
      CALL p200_upd_oga()
      IF g_success = 'N' THEN
        EXIT FOREACH
      END IF
  END FOREACH
 
  IF g_success = 'N' THEN
     ROLLBACK WORK
     CALL cl_err('','abm-020',1)
  ELSE
     COMMIT WORK
     IF NOT cl_null(begin_no) THEN
       LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
       CALL cl_err(g_msg CLIPPED,"mfg0101",1)
     END IF
  END IF
END FUNCTION
 
FUNCTION p200_ins_oga(p_type)
   DEFINE p_type    LIKE type_file.chr1   #1:轉出貨單 2:轉出通單
   DEFINE l_oax01   LIKE oax_file.oax01,   #三角貿易使用匯率 S/B/C/D      #NO.FUN-670007
          l_oaz52   LIKE oaz_file.oaz52,   #內銷使用匯率 B/S/C/D
          l_oaz70   LIKE oaz_file.oaz70,   #外銷使用匯率 B/S/C/D
          li_result LIKE type_file.num5,             
          exT       LIKE type_file.chr1,             
          l_date1   LIKE type_file.dat,              
          l_date2   LIKE type_file.dat               
   DEFINE l_ogb03   LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5   #MOD-850221
   DEFINE l_t       LIKE oay_file.oayslip #MOD-990171 
   DEFINE l_ogb12   LIKE ogb_file.ogb12   #TQC-BC0066    
   #Default初植
      INITIALIZE g_oga.* TO NULL    #TQC-780007
 
      LET g_oga.oga00  = g_oea.oea00        #類別
      LET g_oga.oga011 = ''                 #出貨通知單號
      LET g_oga.oga021 = ''                 #結關日期 
      LET g_oga.oga03  = g_oea.oea03        #帳款客戶編號
      LET g_oga.oga04  = g_oea.oea04        #送貨客戶編號
      LET g_oga.oga044 = g_oea.oea044       #送貨地址碼
      LET g_oga.oga05  = g_oea.oea05        #發票別
      LET g_oga.oga06  = g_oea.oea06        #訂單維護作業預設起始版本編號
      LET g_oga.oga07  = g_oea.oea07        #出貨是否計入未開發票的銷貨待驗收入
      LET g_oga.oga08  = g_oea.oea08        #內/外銷
      LET g_oga.oga1001= g_oea.oea1001
      LET g_oga.oga1002= g_oea.oea1002
      LET g_oga.oga1003= g_oea.oea1003
      LET g_oga.oga1004= g_oea.oea1004
      LET g_oga.oga1005= g_oea.oea1005
      LET g_oga.oga1007= 0
      LET g_oga.oga1008= 0
      LET g_oga.oga1009= g_oea.oea1009
      LET g_oga.oga1010= g_oea.oea1010
      LET g_oga.oga1011= g_oea.oea1011
      LET g_oga.oga1016= g_oea.oea1015      #FUN-630102 add
      LET g_oga.oga14  = g_oea.oea14        #人員編號
      LET g_oga.oga15  = g_oea.oea15        #部門編號
     #不匯總的才是一張訂單拋一張出貨/出通單
     IF tm.g = "3" THEN
       LET g_oga.oga16  = g_oea.oea01        #訂單號碼
     END IF
      LET g_oga.oga161 = g_oea.oea161       #訂金應收比率
      LET g_oga.oga162 = g_oea.oea162       #出貨應收比率
      LET g_oga.oga163 = g_oea.oea163       #尾款應收比率
      LET g_oga.oga18  = g_oea.oea17        #收款客戶編號
      LET g_oga.oga21  = g_oea.oea21        #稅別
      LET g_oga.oga211 = g_oea.oea211       #稅率
      LET g_oga.oga212 = g_oea.oea212       #聯數
      LET g_oga.oga213 = g_oea.oea213       #含稅否
      LET g_oga.oga23  = g_oea.oea23        #幣別
      LET g_oga.oga25  = g_oea.oea25        #銷售分類一
      LET g_oga.oga26  = g_oea.oea26        #銷售分類二
      LET g_oga.oga31  = g_oea.oea31        #價格條件編碼
      LET g_oga.oga32  = g_oea.oea32        #收款條件編碼
      LET g_oga.oga41  = g_oea.oea41        #起運地
      LET g_oga.oga42  = g_oea.oea42        #到達地
      LET g_oga.oga43  = g_oea.oea43        #交運方式
      LET g_oga.oga44  = g_oea.oea44        #嘜頭編號
      LET g_oga.oga45  = g_oea.oea45        #聯絡人
      LET g_oga.oga46  = g_oea.oea46        #專案編號
      LET g_oga.oga55  = '0'                #狀況碼
      LET g_oga.oga57  = '1'                #FUN-AC0055 add
      LET g_oga.oga903 = 'N'                #信用查核放行否
      LET g_oga.oga909 = g_oea.oea901       #三角貿易否
      LET g_oga.oga65  = g_oea.oea65
      #匯率
      SELECT oax01 INTO l_oax01 FROM oax_file
      SELECT oaz52,oaz70 INTO l_oaz52,l_oaz70 FROM oaz_file
      IF g_oga.oga08='1' THEN 
         LET exT = l_oaz52 
      ELSE 
         LET exT = l_oaz70 
      END IF
      IF g_oga.oga909 = 'Y' THEN 
         LET exT = l_oax01       
      END IF
      CALL s_curr3(g_oga.oga23,g_oga.oga021,exT)
         RETURNING g_oga.oga24
      IF p_type = '1' THEN                 #訂單轉出貨單
         LET g_oga.oga09  = '2'             #單據別:一般出貨單
      ELSE                                  #訂單轉通知單
         LET g_oga.oga09  = '1'             #單據別:出貨通知單
         LET g_oga.oga1015 = '0'
      END IF
   LET g_oga.oga02  = tm.dt  #g_today    #出貨日期
   LET g_oga.oga69  = g_today            #輸入日期
   LET g_oga.oga022 = ''                 #裝船日期
   LET g_oga.oga10  = ''                 #帳單編號
   LET g_oga.oga1006= 0
   LET g_oga.oga1013= 'N'
   SELECT occ67 INTO g_oga.oga13 FROM occ_file WHERE occ01=g_oga.oga03   
   IF cl_null(g_oga.oga13) THEN LET g_oga.oga13  = '' END IF             
   LET g_oga.oga17  = ''                 #排貨模擬順序 
   LET g_oga.oga20  = 'Y'                #分錄底稿是否可重新產生
   LET g_oga.oga27  = ''                 #Invoice No.
   LET g_oga.oga28  = ''                 #立帳時采用訂單匯率
   LET g_oga.oga29  = ''                 #信用額度余額
   LET g_oga.oga30  = 'N'                #包裝單確認碼
   LET g_oga.oga50  = 0                  #原幣出貨金額
   LET g_oga.oga501 = 0                  #本幣出貨金額
   LET g_oga.oga51  = 0                  #原幣出貨金額(含稅)
   LET g_oga.oga511 = 0                  #本幣出貨金額 
   LET g_oga.oga52  = 0                  #原幣預收訂金轉銷貨收入金額
   LET g_oga.oga53  = 0                  #原幣應開發票未稅金額
   LET g_oga.oga54  = 0                  #原幣已開發票未稅金額 
   LET g_oga.oga905 = 'N'                #已轉三角貿易出貨單否
   LET g_oga.oga906 = 'Y'                #起始出貨單否
   LET g_oga.oga99  = ''                 #多角貿易流程序號
   LET g_oga.ogaconf= 'N'                #確認否/作廢碼
   LET g_oga.ogapost= 'N'                #出貨扣帳否
   LET g_oga.ogaprsw= 0                  #列印次數
   LET g_oga.ogauser= g_user             #資料所有者
   LET g_oga.ogagrup= g_grup             #資料所有部門
   LET g_oga.ogamodu= ''                 #資料修改者
   LET g_oga.ogadate= g_today            #最近修改日
   LET l_t = s_get_doc_no(tm.slip)       #MOD-990171                                                                                
   SELECT oayapr INTO g_oga.ogamksg FROM oay_file WHERE oayslip=l_t #MOD-990171     
   #帳款客戶簡稱,帳款客戶統一編號
   SELECT occ02,occ11    
     INTO g_oga.oga032,g_oga.oga033
     FROM occ_file
    WHERE occ01 = g_oga.oga03
   #待扺帳款-預收單號
   SELECT oma01 INTO g_oga.oga19 
     FROM oma_file 
    WHERE oma10 = g_oga.oga16
   #應收款日,容許票據到期日
   CALL s_rdatem(g_oga.oga03,g_oga.oga32,g_oga.oga02,g_oga.oga02,
                 g_oea.oea02,g_plant2)            #FUN-980020 
      RETURNING l_date1,l_date2
   IF cl_null(g_oga.oga11) THEN 
      LET g_oga.oga11 = l_date1 
   END IF
   IF cl_null(g_oga.oga12) THEN 
      LET g_oga.oga12 = l_date2 
   END IF
   IF cl_null(g_oga.oga85) THEN
      LET g_oga.oga85=' '
   END IF
   IF cl_null(g_oga.oga94) THEN
      LET g_oga.oga94='N'
   END IF
   
   CALL s_auto_assign_no("axm",tm.slip,g_oga.oga02,"","oga_file","oga01","","","")
     RETURNING li_result,g_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   LET g_oga.ogaplant = g_plant 
   LET g_oga.ogalegal = g_legal 
 
   LET g_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES(g_oga.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','','',SQLCA.sqlcode,1)      
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(begin_no) THEN 
      LET begin_no = g_oga.oga01
   END IF
   LET end_no=g_oga.oga01
 
   CASE tm.g
    WHEN "1"  #依客戶+出貨日
      LET g_sql = "SELECT oeb_file.* FROM oeb_file,oea_file ",
                  " WHERE oeb01 = oea01 "
      LET g_sql = g_sql, g_ws1, " AND ",g_wc_oea
    WHEN "2"  #依客戶+單別
      LET g_sql = "SELECT oeb_file.* FROM oeb_file,oea_file ",
                  " WHERE oeb01 = oea01 "
      LET g_sql = g_sql, g_ws1, " AND ",g_wc_oea
    WHEN "3"  #不匯總
      LET g_sql = "SELECT * FROM oeb_file WHERE oeb01 = '",g_oea.oea01,"' "
   END CASE
    
   LET l_ogb03 = 0
   PREPARE p200_prepare1 FROM g_sql
   IF SQLCA.sqlcode THEN 
      CALL s_errmsg('','','',SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p200_cs1 CURSOR WITH HOLD FOR p200_prepare1
   FOREACH p200_cs1 INTO g_oeb.* 
         IF tm.g ='1' OR tm.g = '2' THEN 
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt FROM oea_file,oeb_file
              WHERE oea01=oeb01 AND oeb01 = g_oeb.oeb01 AND 
                    (oea161 > 0 OR oea163 > 0) 
            IF l_cnt > 0 THEN 
               CALL s_errmsg('','','','axm-076',1)
               LET g_success='N'
               RETURN
            END IF
         END IF
         LET l_ogb03 = l_ogb03 + 1
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)  
            LET g_success = 'N'
            RETURN 
         END IF
         IF g_oeb.oeb1003 = '1' AND g_oeb.oeb12 <= 0 THEN
            CONTINUE FOREACH
         END IF
         #現返
	       IF g_oeb.oeb1003 = '2' AND (g_oeb.oeb14 = 0 OR g_oeb.oeb14t = 0) THEN  #TQC-640088
            CONTINUE FOREACH
         END IF
         #TQC-BC0066 add begin"
           LET l_ogb12 = 0
           IF p_type = '1' THEN #出貨單
             SELECT SUM(ogb12) INTO l_ogb12 FROM oga_file,ogb_file
              WHERE oga01 = ogb01
                AND ogaconf <> 'X'
                AND ogb31 = g_oeb.oeb01
                AND ogb32 = g_oeb.oeb03
                AND oga09 IN ('2','3','4','6')
           ELSE
             SELECT SUM(ogb12) INTO l_ogb12 FROM oga_file,ogb_file
              WHERE oga01 = ogb01
                AND ogaconf <> 'X'
                AND ogb31 = g_oeb.oeb01
                AND ogb32 = g_oeb.oeb03
                AND oga09 IN ('1','5')
           END IF           
           IF cl_null(l_ogb12) THEN 
              LET l_ogb12 = 0
           END IF    
           #此項次訂單拋轉完continue foreach
           IF l_ogb12 >= g_oeb.oeb12 THEN
              CONTINUE FOREACH                 
           END IF             
         #TQC-BC0066 add end
         LET g_ogb.ogb03  = l_ogb03     #項次
         CALL p200_ins_ogb()
         INITIALIZE g_ogb.* LIKE ogb_file.*   #DEFAULT 設定
         INITIALIZE g_oeb.* LIKE oeb_file.*   #DEFAULT 設定
   END FOREACH
   IF tm.g = '3' THEN 
      DROP TABLE x
      SELECT * FROM oao_file WHERE oao01 = g_oea.oea01 INTO TEMP x
      UPDATE x SET oao01 = g_oga.oga01 
      INSERT INTO oao_file SELECT * FROM x
      
      DROP TABLE x
      SELECT * FROM oap_file WHERE oap01 = g_oea.oea01 INTO TEMP x
      UPDATE x SET oap01 = g_oga.oga01 
      INSERT INTO oap_file SELECT * FROM x
   END IF
END FUNCTION

 
FUNCTION p200_ins_ogb()
   DEFINE l_flag   LIKE type_file.num5,           
          l_ima25  LIKE ima_file.ima25
   DEFINE l_cnt    LIKE type_file.num5, #TQC-BC0066 
          l_ogb12  LIKE ogb_file.ogb12,
          l_ogb14  LIKE ogb_file.ogb14,
          l_ogb14t LIKE ogb_file.ogb14t,
          l_ogb917 LIKE ogb_file.ogb917
   #Default初植
   LET g_ogb.ogb01  = g_oga.oga01     #出貨單號
   LET g_ogb.ogb04  = g_oeb.oeb04     #產品編號
   LET g_ogb.ogb05  = g_oeb.oeb05     #銷售單位
   LET g_ogb.ogb05_fac = g_oeb.oeb05_fac
   LET g_ogb.ogb06  = g_oeb.oeb06     #品名規格
   LET g_ogb.ogb07  = g_oeb.oeb07     #額外品名編號
   LET g_ogb.ogb08  = g_oeb.oeb08     #出貨營運中心編號
   LET g_ogb.ogb09  = g_oeb.oeb09     #出貨倉庫編號
   LET g_ogb.ogb091 = g_oeb.oeb091    #出貨儲位編號
   LET g_ogb.ogb092 = g_oeb.oeb092    #出貨批號
   LET g_ogb.ogb1001= g_oeb.oeb1001  
   LET g_ogb.ogb1002= g_oeb.oeb1002
   LET g_ogb.ogb1003= g_oeb.oeb15
   LET g_ogb.ogb1004= g_oeb.oeb1004
   LET g_ogb.ogb1005= g_oeb.oeb1003
   LET g_ogb.ogb1006= g_oeb.oeb1006
   LET g_ogb.ogb11  = g_oeb.oeb11     #客戶產品編號
   #LET g_ogb.ogb12  = g_oeb.oeb12     #實際出貨數量 #TQC-BC0066 mark
   LET g_ogb.ogb13  = g_oeb.oeb13     #原幣單價      
   #LET g_ogb.ogb14  = g_oeb.oeb14     #原幣未稅金額 #TQC-BC0066 mark
   #LET g_ogb.ogb14t = g_oeb.oeb14t    #原幣含稅金額 #TQC-BC0066 mark
   LET g_ogb.ogb31  = g_oeb.oeb01     #訂單單號
   LET g_ogb.ogb32  = g_oeb.oeb03     #訂單項次
   LET g_ogb.ogb908 = g_oeb.oeb908    #手冊編號
   LET g_ogb.ogb910 = g_oeb.oeb910
   LET g_ogb.ogb911 = g_oeb.oeb911
   LET g_ogb.ogb912 = g_oeb.oeb912
   LET g_ogb.ogb913 = g_oeb.oeb913
   LET g_ogb.ogb914 = g_oeb.oeb914
   LET g_ogb.ogb915 = g_oeb.oeb915
   LET g_ogb.ogb916 = g_oeb.oeb916   #計價單位
   #LET g_ogb.ogb917 = g_oeb.oeb917   #計價數量    #TQC-BC0066 mark
   LET g_ogb.ogb19  = g_oeb.oeb906
   LET g_ogb.ogb1007= g_oeb.oeb1007
   LET g_ogb.ogb1008= g_oeb.oeb1008
   LET g_ogb.ogb1009= g_oeb.oeb1009
   LET g_ogb.ogb1010= g_oeb.oeb1010
   LET g_ogb.ogb1011= g_oeb.oeb1011                
   LET g_ogb.ogb1012= g_oeb.oeb1012                
   LET g_ogb.ogb41  = g_oeb.oeb41
   LET g_ogb.ogb42  = g_oeb.oeb42
   LET g_ogb.ogb43  = g_oeb.oeb43
   LET g_ogb.ogb1001 = g_oeb.oeb1001
   LET g_ogb.ogb17  = 'N'             #多倉儲批出貨否
   LET g_ogb.ogb60  = 0               #已開發票數量
   LET g_ogb.ogb63  = 0               #銷退數量
   LET g_ogb.ogb64  = 0               #銷退數量 (不需換貨出貨)
   LET g_ogb.ogb930 = g_oeb.oeb930    #FUN-680006
   LET g_ogb.ogb1014   = 'N'                 #保稅放行否  #FUN-6B0044
   IF cl_null(g_ogb.ogb091) THEN LET g_ogb.ogb091 = ' ' END IF  #出貨儲位編號
   IF cl_null(g_ogb.ogb092) THEN LET g_ogb.ogb092 = ' ' END IF  #出貨批號
   #TQC-BC0066 add begin #添加部份訂單某項次,已轉出貨/出通,批處理程序邏輯
   LET l_cnt = 0
   IF g_oga.oga09 = '2' THEN #出貨單
     SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
      WHERE oga01 = ogb01
        AND ogaconf <> 'X'
        AND ogb31 = g_ogb.ogb31
        AND ogb32 = g_ogb.ogb32
        AND oga09 IN ('2','3','4','6')
        IF l_cnt >0 THEN #說明已經有部份出貨
           SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb917) 
             INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb917 FROM oga_file,ogb_file
            WHERE oga01 = ogb01
              AND ogaconf <> 'X'
              AND ogb31 = g_ogb.ogb31
              AND ogb32 = g_ogb.ogb32
              AND oga09 IN ('2','3','4','6')
            IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
            IF cl_null(l_ogb14) THEN LET l_ogb14 = 0 END IF
            IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
            IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF                                
            LET g_ogb.ogb12 = g_oeb.oeb12 - l_ogb12      #訂單量 - 已拋轉出貨單量
            LET g_ogb.ogb14   = g_oeb.oeb14  - l_ogb14   #原幣未稅金額 
            LET g_ogb.ogb14t  = g_oeb.oeb14t - l_ogb14t  #原幣含稅金額 
            LET g_ogb.ogb917  = g_oeb.oeb917 - l_ogb917  #計價數量 
            IF g_ogb.ogb12 <= 0 THEN LET g_ogb.ogb12 = 0 END IF  
            IF g_ogb.ogb14 <= 0 THEN LET g_ogb.ogb14 = 0 END IF
            IF g_ogb.ogb14t <= 0 THEN LET g_ogb.ogb14t = 0 END IF
            IF g_ogb.ogb917 <= 0 THEN LET g_ogb.ogb917 = 0 END IF
        ELSE #從未拋轉過出貨單
        	 LET g_ogb.ogb12  = g_oeb.oeb12     #實際出貨數量
        	 LET g_ogb.ogb14  = g_oeb.oeb14     #原幣未稅金額 
        	 LET g_ogb.ogb14t = g_oeb.oeb14t    #原幣含稅金額
        	 LET g_ogb.ogb917 = g_oeb.oeb917   #計價數量 
        END IF 
   ELSE #出通單
     SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
      WHERE oga01 = ogb01
        AND ogaconf <> 'X'
        AND ogb31 = g_ogb.ogb31
        AND ogb32 = g_ogb.ogb32
        AND oga09 IN ('1','5')
        IF l_cnt >0 THEN #說明此訂單項次,已經有部份出通
           SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb917) 
             INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb917 FROM oga_file,ogb_file
            WHERE oga01 = ogb01
              AND ogaconf <> 'X'
              AND ogb31 = g_ogb.ogb31
              AND ogb32 = g_ogb.ogb32
              AND oga09 IN ('1','5')
            IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
            IF cl_null(l_ogb14) THEN LET l_ogb14 = 0 END IF
            IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
            IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF                                
            LET g_ogb.ogb12 = g_oeb.oeb12 - l_ogb12      #訂單量 - 已拋轉出貨通量
            LET g_ogb.ogb14   = g_oeb.oeb14  - l_ogb14   #原幣未稅金額 
            LET g_ogb.ogb14t  = g_oeb.oeb14t - l_ogb14t  #原幣含稅金額 
            LET g_ogb.ogb917  = g_oeb.oeb917 - l_ogb917  #計價數量 
            IF g_ogb.ogb12 <= 0 THEN LET g_ogb.ogb12 = 0 END IF  
            IF g_ogb.ogb14 <= 0 THEN LET g_ogb.ogb14 = 0 END IF
            IF g_ogb.ogb14t <= 0 THEN LET g_ogb.ogb14t = 0 END IF
            IF g_ogb.ogb917 <= 0 THEN LET g_ogb.ogb917 = 0 END IF
        ELSE #此訂單項次,從未拋轉過出通單
        	 LET g_ogb.ogb12  = g_oeb.oeb12     #實際出通數量
        	 LET g_ogb.ogb14  = g_oeb.oeb14     #原幣未稅金額 
        	 LET g_ogb.ogb14t = g_oeb.oeb14t    #原幣含稅金額
        	 LET g_ogb.ogb917 = g_oeb.oeb917   #計價數量 
        END IF 
   END IF   
   
   #TQC-BC0066 add end
   IF g_ogb.ogb1005 = '1' THEN        #出貨
      #庫存明細單位由廠/倉/儲/批自動得出
      SELECT img09  INTO g_ogb.ogb15 
        FROM img_file
       WHERE img01 = g_ogb.ogb04 
         AND img02 = g_ogb.ogb09 
         AND img03 = g_ogb.ogb091
         AND img04 = g_ogb.ogb092
      CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,g_ogb.ogb15) 
         RETURNING l_flag,g_ogb.ogb15_fac
      IF l_flag > 0 THEN 
         LET g_ogb.ogb15_fac = 1 
      END IF
      #銷售/庫存匯總單位換算率
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_ogb.ogb04
      CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,l_ima25)
         RETURNING l_flag,g_ogb.ogb05_fac
      IF l_flag > 0 THEN 
         LET g_ogb.ogb05_fac = 1
      END IF
      LET g_ogb.ogb16 = g_ogb.ogb12 * g_ogb.ogb15_fac  #數量
      LET g_ogb.ogb16 = s_digqty(g_ogb.ogb16,g_ogb.ogb15) #FUN-BB0083 add
      LET g_ogb.ogb18 = g_ogb.ogb12                    #預計出貨數量  
      #更新出貨單頭檔
      LET g_oga.oga50  = g_oga.oga50 + g_ogb.ogb14     #原幣出貨金額
      LET g_oga.oga51  = g_oga.oga51 + g_ogb.ogb14t    #原幣出貨金額(含稅)
      LET g_oga.oga1008= g_oga.oga1008 + g_ogb.ogb14t
   ELSE
      LET g_oga.oga1006= g_oga.oga1006 + g_ogb.ogb14
      LET g_oga.oga1007= g_oga.oga1007 + g_ogb.ogb14t
   END IF
   IF cl_null(g_ogb.ogb18) THEN
      LET g_ogb.ogb18 = 0
   END IF
   IF cl_null(g_ogb.ogb16) THEN
      LET g_ogb.ogb16 = 0
   END IF
   IF cl_null(g_ogb.ogb15) THEN
      LET g_ogb.ogb15 = g_ogb.ogb05 
   END IF
   IF cl_null(g_ogb.ogb15_fac) THEN
      LET g_ogb.ogb15_fac = 1 
   END IF
   IF cl_null(g_ogb.ogb44) THEN
      LET g_ogb.ogb44='1'
   END IF
   IF cl_null(g_ogb.ogb47) THEN
      LET g_ogb.ogb47=0
   END IF
#FUN-AB0061 -----------add start---------------- 
   LET g_ogb.ogb37 = g_oeb.oeb37                            
   IF cl_null(g_ogb.ogb37) OR g_ogb.ogb37=0 THEN           
      LET g_ogb.ogb37=g_ogb.ogb13                         
   END IF                                                                             
#FUN-AB0061 -----------add end----------------   
   LET g_ogb.ogbplant = g_plant 
   LET g_ogb.ogblegal = g_legal 
 
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 ----------add start---------------
#   IF cl_null(g_ogb.ogb50) THEN
#      LET g_ogb.ogb50 = '1'
#   END IF
##FUN-AB0096 ----------add end-----------------     
#FUN-AC0055 mark ----------------------end------------------------
   #FUN-C50097 ADD BEGIN-----
   IF cl_null(g_ogb.ogb50) THEN
     LET g_ogb.ogb50 = 0
   END IF
   IF cl_null(g_ogb.ogb51) THEN
     LET g_ogb.ogb51 = 0
   END IF
   IF cl_null(g_ogb.ogb52) THEN
     LET g_ogb.ogb52 = 0
   END IF
   IF cl_null(g_ogb.ogb53) THEN
     LET g_ogb.ogb53 = 0
   END IF
   IF cl_null(g_ogb.ogb54) THEN
     LET g_ogb.ogb54 = 0
   END IF
   IF cl_null(g_ogb.ogb55) THEN
     LET g_ogb.ogb55 = 0
   END IF   
   #FUN-C50097 ADD END-------  
   #FUN-CB0087--add--str--
   IF g_aza.aza115 = 'Y' AND g_oga.oga09 = '2' THEN
      CALL s_reason_code(g_ogb.ogb01,g_ogb.ogb31,'',g_ogb.ogb04,g_ogb.ogb09,g_oga.oga14,g_oga.oga15) RETURNING g_ogb.ogb1001
      IF cl_null(g_ogb.ogb1001) THEN
         CALL cl_err(g_ogb.ogb1001,'aim-425',1)
         LET g_success="N"
         RETURN
      END IF
   END IF
   #FUN-CB0087--add--end--
   INSERT INTO ogb_file VALUES(g_ogb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p200_ins_ogb():",SQLCA.sqlcode,1)  
      LET g_success = 'N'
      RETURN
   ELSE
      IF NOT s_industry('std') THEN
         LET g_ogbi.ogbi01 = g_ogb.ogb01
         LET g_ogbi.ogbi03 = g_ogb.ogb03
         IF NOT s_ins_ogbi(g_ogbi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #TQC-C30113 add START
   IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32)THEN
      IF NOT cl_null(g_ogb.ogb1001) AND g_ogb.ogb1001 = g_oaz.oaz88 THEN
         CALL p200_ins_rxe(g_ogb.ogb01,g_ogb.ogb04,g_ogb.ogb31,g_ogb.ogb03)
      END IF
   END IF
  #TQC-C30113 add END
END FUNCTION
 
FUNCTION p200_upd_oga()
  DEFINE l_i     LIKE type_file.num5
   LET l_i = 0
   IF tm.g <> "3" THEN
      SELECT COUNT(DISTINCT ogb31) INTO l_i FROM ogb_file
       WHERE ogb01 = g_oga.oga01
      IF l_i = 1 THEN
        SELECT DISTINCT ogb31 INTO g_oga.oga16 FROM ogb_file
         WHERE ogb01 = g_oga.oga01
      ELSE
        LET g_oga.oga16 = ''
      END IF
   END IF
   UPDATE oga_file SET oga50   = g_oga.oga50,
                       oga51   = g_oga.oga51,
                       oga16   = g_oga.oga16,   #TQC-780007
                       oga1006 = g_oga.oga1006,
                       oga1007 = g_oga.oga1007,
                       oga1008 = g_oga.oga1008
                 WHERE oga01   = g_oga.oga01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p200_upd_oga():",SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
 
FUNCTION p200_batch_confirm()
  DEFINE l_i,l_n   LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_oea1[l_i].a = 'Y' THEN
       IF g_oea1[l_i].oeaconf <> 'N' THEN
          LET g_oea1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('axm-596') THEN
      RETURN
    END IF
  ELSE RETURN
  END IF
 
  FOR l_i = 1 TO g_rec_b1
    IF g_oea1[l_i].a = 'Y' THEN
         SELECT oea_file.* INTO g_oea.* FROM oea_file
          WHERE oea01 = g_oea1[l_i].oea01
         CALL t400sub_y_chk('1',g_oea1[l_i].oea01) #FUN-740034
         IF g_success = "Y" THEN
           #CALL t400sub_y_upd(g_oea.oea01,'') #CALL 原確認的 update 段 #FUN-740034   #CHI-B80050 mark
            CALL t400sub_y_upd(g_oea.oea01,'',FALSE)                    #CHI-B80050
            CALL t400sub_refresh(g_oea.oea01)  RETURNING g_oea.* 
            LET g_oea1[l_i].oeaconf = g_oea.oeaconf
            LET g_oea1[l_i].oea49   = g_oea.oea49
         END IF
         INITIALIZE g_oea.* TO NULL
    END IF
  END FOR
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#TQC-C30113 add START
FUNCTION p200_ins_rxe(p_ogb01,p_ogb04,p_ogb31,p_ogb03)
DEFINE l_n              LIKE type_file.num10
DEFINE p_ogb01          LIKE ogb_file.ogb01
DEFINE p_ogb04          LIKE ogb_file.ogb04
DEFINE p_ogb31          LIKE ogb_file.ogb31
DEFINE p_ogb32          LIKE ogb_file.ogb32
DEFINE p_ogb03          LIKE ogb_file.ogb03
DEFINE l_sql            STRING
DEFINE l_lqw08          LIKE lqw_file.lqw08
DEFINE l_lpx32          LIKE lpx_file.lpx32
DEFINE l_rxe     RECORD LIKE rxe_file.*
DEFINE l_lqw     RECORD LIKE lqw_file.*

   SELECT COUNT(*) INTO l_n
      FROM lqw_file
        WHERE lqw01 = p_ogb31
   IF l_n > 0 THEN
      LET l_sql = " SELECT DISTINCT lqw08 FROM lqw_file ",
                  "   WHERE lqw01 = '",p_ogb31,"'"
      PREPARE lqw_pre FROM l_sql
      DECLARE lqw_cur CURSOR FOR lqw_pre
      FOREACH lqw_cur INTO l_lqw08
         IF cl_null(l_lqw08) THEN CONTINUE FOREACH END IF
         SELECT lpx32 INTO l_lpx32 FROM lpx_file
            WHERE lpx01 = l_lqw08
         IF cl_null(l_lpx32) THEN CONTINUE FOREACH END IF
         IF l_lpx32 = p_ogb04 THEN
            LET l_sql  = "SELECT * FROM lqw_file" ,
                         "   WHERE lqw00 = '01' AND lqw01 = '",p_ogb31,"'" ,
                         "     AND lqw08 = '",l_lqw08,"'"
            PREPARE ins_rxe_pre FROM l_sql
            DECLARE ins_rxe_cur CURSOR FOR ins_rxe_pre
            SELECT MAX(rxe03) INTO l_rxe.rxe03 FROM rxe_file
               WHERE rxe00 = '01' AND rxe01 = p_ogb01
                 AND rxeplant = g_plant
            FOREACH ins_rxe_cur  INTO l_lqw.*
               IF cl_null(l_rxe.rxe03) OR l_rxe.rxe03 = 0 THEN
                  LET l_rxe.rxe03 = 1
               ELSE
                  LET l_rxe.rxe03 = l_rxe.rxe03 + 1
               END IF
               LET l_rxe.rxe02 = p_ogb03
               LET l_rxe.rxe00 = '02'
               LET l_rxe.rxe01 = g_oga.oga01
               LET l_rxe.rxe04 = l_lqw.lqw09
               LET l_rxe.rxe05 = l_lqw.lqw10
               LET l_rxe.rxe06 = l_lqw.lqw08
               LET l_rxe.rxe07 = l_lqw.lqw11
               LET l_rxe.rxe08 = l_lqw.lqw12
               LET l_rxe.rxe09 = l_lqw.lqw13
               LET l_rxe.rxeplant = g_plant
               LET l_rxe.rxelegal = g_legal
               INSERT INTO rxe_file VALUES(l_rxe.*)
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","rxe_file",'','',SQLCA.sqlcode,"","",1)
               END IF
            END FOREACH
         END IF
      END FOREACH
   END IF
END FUNCTION
#TQC-C30113 add END
