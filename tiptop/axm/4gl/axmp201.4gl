# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmp201.4gl
# Descriptions...: 訂單自動化作業 
# Date & Author..: No.FUN-960071 09/06/09 By chenmoyan
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980010 09/09/03 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/10 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No:MOD-A20107 10/02/25 By Smapmin 產生工單時,要所有項次都產生成功才算完成.故將Transaction的範圍拉大
# Modify.........: No:FUN-A30021 10/03/10 By Smapmin 串查明細資料後,要回到原來record筆數上
# Modify.........: No:MOD-A30168 10/03/23 By Smapmin 將"已轉工單/請購/採購,不可再轉出通/出貨"的控卡拿掉
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.CHI-A70049 10/08/25 By pengu  ±N¦h¾lªºDISPLAYµ{¦¡mark
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No:FUN-BB0083 11/12/28 By xujing 增加數量欄位小數取位 ogb_file
# Modify.........: No:TQC-BC0076 11/12/12 By SunLM 變更oea01開窗查詢,過濾掉合約訂單
# Modify.........: No:TQC-C10124 12/01/31 By destiny axmq200.global单头数组有新加字段,导致axmp200运行时会荡出
# Modify.........: No:MOD-BA0040 12/02/03 By Summer oga50|oga52|oga53的處理方式要與於出貨單直接登打時一樣 
# Modify.........: No:TQC-C30113 12/03/06 By pauline 轉出貨單時 若產品為贈品且為禮券時寫入rxe_file 
# Modify.........: No:TQC-C60075 12/06/08 By zhuhao 增加規格欄位
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No:TQC-CA0007 12/12/10 By jt_chen 修正link錯誤,因MOD-C90187調整FUNCTION t400sub_ins_pmk
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No.FUN-CC0082 12/12/28 By baogc 添加生產門店

DATABASE ds
 
GLOBALS "../../config/top.global"
#GLOBALS "../4gl/axmq200.global"  #TQC-C10124
GLOBALS "../4gl/axmp201.global"  #TQC-C10124
 
DEFINE l_ac_b1  LIKE type_file.num5
DEFINE l_ac_b2  LIKE type_file.num5
DEFINE l_ac_b3  LIKE type_file.num5
DEFINE l_ac_b4  LIKE type_file.num5
DEFINE l_ac_b5  LIKE type_file.num5
DEFINE l_ac_b6  LIKE type_file.num5
DEFINE l_ac_b7  LIKE type_file.num5
DEFINE g_renew  LIKE type_file.num5        
DEFINE g_oeb15  LIKE oeb_file.oeb15
DEFINE begin_no LIKE oga_file.oga01
DEFINE l_ima60  LIKE ima_file.ima60
DEFINE l_ima601 LIKE ima_file.ima601
DEFINE l_oeb05  LIKE oeb_file.oeb05
DEFINE l_ima55   LIKE ima_file.ima55
DEFINE l_ima562  LIKE ima_file.ima562
DEFINE end_no   LIKE oga_file.oga01
DEFINE g_i      LIKE type_file.num5
DEFINE g_gfa    RECORD LIKE gfa_file.*
DEFINE g_oga    RECORD LIKE oga_file.*
DEFINE g_ogb    RECORD LIKE ogb_file.*
DEFINE g_oea    RECORD LIKE oea_file.*
DEFINE g_oeb    RECORD LIKE oeb_file.*
DEFINE g_ogbi   RECORD LIKE ogbi_file.*
DEFINE g_oma    RECORD LIKE oma_file.*
DEFINE g_flag   LIKE type_file.chr1
DEFINE new  RECORD                                                                                                
                oeb01         LIKE oeb_file.oeb01,
                oeb03         LIKE oeb_file.oeb03,
                new_part      LIKE ima_file.ima01,
                ima02         LIKE ima_file.ima02,
                ima910        LIKE ima_file.ima910,
                new_qty       LIKE sfb_file.sfb08,
                b_date        LIKE type_file.dat,
                e_date        LIKE type_file.dat,
                sfb02         LIKE sfb_file.sfb02,
                new_no        LIKE oea_file.oea01,
                ven_no        LIKE pmc_file.pmc01,
                a             LIKE type_file.chr1,
                costcenter    LIKE gem_file.gem01,
                gem02c        LIKE gem_file.gem02
                END RECORD
DEFINE tm RECORD                              #                                                                                     
                slip         LIKE oay_file.oayslip,  #單據別                                                                               
                b_date       LIKE type_file.dat,
                e_date       LIKE type_file.dat,
                sfb02        LIKE sfb_file.sfb02,
                open_sw      LIKE type_file.chr1
                END RECORD
DEFINE g_plant2 LIKE type_file.chr10         #FUN-980020
DEFINE g_field  LIKE type_file.chr10   #FUN-A30021
 
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p201_w AT p_row,p_col WITH FORM "axm/42f/axmp201"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL p201_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL p201()
 
   CLOSE WINDOW p201_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION p201()
 
   CLEAR FORM
   CALL p201_q()
   CALL p201_menu()
END FUNCTION
 
FUNCTION p201_bp()
   LET g_action_choice = " "
   #-----FUN-A30021---------
   #CALL cl_set_act_visible("accept,cancel,so_detail,
   #         da_detail,dn_detail,ar_detail,wo_detail,
   #         pr_detail,po_detail,carry_da,carry_dn,query_ar,
   #         carry_ar,carry_wo,carry_pr,carry_po", FALSE)
   #-----END FUN-A30021-----
   
 
   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_oeb1 TO s_oeb.* 
         BEFORE ROW
            LET l_ac_b1 = ARR_CURR()
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("so_detail", TRUE)
      END DISPLAY
      DISPLAY ARRAY g_ogb1 TO s_ogb1.* 
         BEFORE ROW
            LET l_ac_b2 = ARR_CURR()
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("da_detail,carry_da", TRUE)
      END DISPLAY
      DISPLAY ARRAY g_ogb2 TO s_ogb2.*
         BEFORE ROW
            LET l_ac_b3 = ARR_CURR()
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("dn_detail,carry_dn", TRUE)
      END DISPLAY
      DISPLAY ARRAY g_omb TO s_omb.* 
         BEFORE ROW
            LET l_ac_b4 = ARR_CURR()
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("ar_detail,carry_ar", TRUE)
      END DISPLAY
      DISPLAY ARRAY g_sfb TO s_sfb.*
         BEFORE ROW
            LET l_ac_b5 = ARR_CURR()
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("wo_detail,carry_wo", TRUE)
      END DISPLAY
      DISPLAY ARRAY g_pml TO s_pml.* 
         BEFORE ROW
            LET l_ac_b6 = ARR_CURR()
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("pr_detail,carry_pr", TRUE)
      END DISPLAY
      DISPLAY ARRAY g_pmn TO s_pmn.* 
         BEFORE ROW
            LET l_ac_b7 = ARR_CURR()
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("po_detail,carry_po", TRUE)
      END DISPLAY
      DISPLAY ARRAY g_oea1 TO s_oea.*  
         BEFORE ROW
            #-----FUN-A30021---------
            #CALL cl_set_act_visible("so_detail,query_ar,
            #         da_detail,dn_detail,ar_detail,wo_detail,
            #         pr_detail,po_detail,carry_da,carry_dn,
            #         carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            #-----END FUN-A30021-----
            LET l_ac1 = ARR_CURR()
            LET g_oea1_t.* = g_oea1[l_ac1].*
            IF l_ac1 > 0 THEN
               CALL p201_b_fill_1()  #訂單
               CALL p201_b_fill_2()  #出通單
               CALL p201_b_fill_3()  #出貨單
               CALL p201_b_fill_4()  #應收
               CALL p201_b_fill_5()  #工單
               CALL p201_b_fill_6()  #請購
               CALL p201_b_fill_7()  #採購
            END IF
      END DISPLAY

      #-----FUN-A30021---------
      BEFORE DIALOG   
         IF NOT cl_null(g_field) THEN  
            CALL DIALOG.setCurrentRow("s_oea",l_ac1)   
            CALL DIALOG.setCurrentRow("s_oeb",l_ac_b1)   
            CALL DIALOG.setCurrentRow("s_ogb1",l_ac_b2)   
            CALL DIALOG.setCurrentRow("s_ogb2",l_ac_b3)   
            CALL DIALOG.setCurrentRow("s_omb",l_ac_b4)   
            CALL DIALOG.setCurrentRow("s_sfb",l_ac_b5)   
            CALL DIALOG.setCurrentRow("s_pml",l_ac_b6)   
            CALL DIALOG.setCurrentRow("s_pmn",l_ac_b7)   
            CALL DIALOG.nextField(g_field)   
         END IF 
         CONTINUE DIALOG
      #-----END FUN-A30021-----

         ON ACTION view1
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("so_detail", TRUE)
         ON ACTION view2
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("da_detail,carry_da", TRUE)
         ON ACTION view3
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("dn_detail,carry_dn", TRUE)
         ON ACTION view4
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("ar_detail,carry_ar", TRUE)
         ON ACTION view5
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("wo_detail,carry_wo", TRUE)
         ON ACTION view6
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("pr_detail,carry_pr", TRUE)
         ON ACTION view7
            CALL cl_set_act_visible("so_detail,query_ar,
                     da_detail,dn_detail,ar_detail,wo_detail,
                     pr_detail,po_detail,carry_da,carry_dn,
                     carry_ar,carry_wo,carry_pr,carry_po", FALSE)
            CALL cl_set_act_visible("po_detail,carry_po", TRUE)
         ON ACTION query_ar
            LET g_action_choice = 'query_ar'
         ON ACTION so_detail
            LET g_action_choice = 'so'
            EXIT DIALOG
         ON ACTION carry_da
            LET g_action_choice = 'carry_da'
            EXIT DIALOG
         ON ACTION da_detail
            LET g_action_choice = 'da'
            EXIT DIALOG
         ON ACTION carry_dn
            LET g_action_choice = 'carry_dn'
            EXIT DIALOG
         ON ACTION dn_detail
            LET g_action_choice = 'dn'
            EXIT DIALOG
         ON ACTION carry_ar
            LET g_action_choice = 'carry_ar'
            EXIT DIALOG
         ON ACTION ar_detail
            LET g_action_choice = 'ar'
            EXIT DIALOG
         ON ACTION carry_wo
            LET g_action_choice = 'carry_wo'
            EXIT DIALOG
         ON ACTION wo_detail
            LET g_action_choice = 'wo'
            EXIT DIALOG
         ON ACTION carry_pr
            LET g_action_choice = 'carry_pr'
            EXIT DIALOG
         ON ACTION pr_detail
            LET g_action_choice = 'pr'
            EXIT DIALOG
         ON ACTION carry_po
            LET g_action_choice = 'carry_po'
            EXIT DIALOG
         ON ACTION po_detail
            LET g_action_choice = 'po'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exporttoexcel"
            EXIT DIALOG 
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
            EXIT DIALOG 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
   END DIALOG
{   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_oeb1 TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE ROW
           LET l_ac_b1 = ARR_CURR()
         ON ACTION view1
         ON ACTION so_detail
            LET g_action_choice = 'so'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exporttoexcel"
            EXIT DIALOG 
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
            EXIT DIALOG 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
 
      DISPLAY ARRAY g_ogb1 TO s_ogb1.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac_b2 = ARR_CURR()
         ON ACTION view2
         ON ACTION carry_da
            LET g_action_choice = 'carry_da'
            EXIT DIALOG
         ON ACTION da_detail
            LET g_action_choice = 'da'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exprottoexcel"
            EXIT DIALOG 
         ON ACTION cancel LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
 
      DISPLAY ARRAY g_ogb2 TO s_ogb2.* ATTRIBUTE(COUNT=g_rec_b3)
         BEFORE ROW
            LET l_ac_b3 = ARR_CURR()
         ON ACTION view3
         ON ACTION carry_dn
            LET g_action_choice = 'carry_dn'
            EXIT DIALOG
         ON ACTION dn_detail
            LET g_action_choice = 'dn'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exprottoexcel"
            EXIT DIALOG 
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
 
      DISPLAY ARRAY g_omb TO s_omb.* ATTRIBUTE(COUNT=g_rec_b4)
         BEFORE ROW
            LET l_ac_b4 = ARR_CURR()
         ON ACTION view4
         ON ACTION carry_ar
            LET g_action_choice = 'carry_ar'
            EXIT DIALOG
         ON ACTION ar_detail
            LET g_action_choice = 'ar'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exprottoexcel"
            EXIT DIALOG 
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
      DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b5)
         BEFORE ROW
            LET l_ac_b5 = ARR_CURR()
         ON ACTION view5
     
         ON ACTION carry_wo
            LET g_action_choice = 'carry_wo'
            EXIT DIALOG
         ON ACTION wo_detail
            LET g_action_choice = 'wo'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exprottoexcel"
            EXIT DIALOG 
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
      DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b6)
         BEFORE ROW
            LET l_ac_b6 = ARR_CURR()
         ON ACTION view6
         ON ACTION carry_pr
            LET g_action_choice = 'carry_pr'
            EXIT DIALOG
         ON ACTION pr_detail
            LET g_action_choice = 'pr'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exprottoexcel"
            EXIT DIALOG 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
      DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b7)
         BEFORE ROW
            LET l_ac_b7 = ARR_CURR()
         ON ACTION view7
         ON ACTION carry_po
            LET g_action_choice = 'carry_po'
            EXIT DIALOG
         ON ACTION po_detail
            LET g_action_choice = 'po'
            EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exprottoexcel"
            EXIT DIALOG 
         ON ACTION cancel 
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
      DISPLAY ARRAY g_oea1 TO s_oea.* ATTRIBUTE(COUNT=g_rec_b) #顯示並進行選擇
         BEFORE ROW
            IF g_renew THEN
               LET l_ac1 = ARR_CURR()
               IF l_ac1 = 0 THEN
                  LET l_ac1 = 1
               END IF
            END IF
         CALL fgl_set_arr_curr(l_ac1)
         LET g_renew = 1
         LET l_ac1_t = l_ac1
         LET g_oea1_t.* = g_oea1[l_ac1].*
 
         IF g_rec_b > 0 THEN
            CALL p201_b_fill_1()  #訂單
            CALL p201_b_fill_2()  #出通單
            CALL p201_b_fill_3()  #出貨單
            CALL p201_b_fill_4()  #應收
            CALL p201_b_fill_5()  #工單
            CALL p201_b_fill_6()  #請購
            CALL p201_b_fill_7()  #採購
            CALL cl_set_act_visible("query_ar", TRUE)
         ELSE
            CALL cl_set_act_visible("query_ar", FALSE)
         END IF
         ON ACTION query_ar   #查詢客戶應收帳款
           LET g_action_choice="query_ar"
           EXIT DIALOG
         ON ACTION exporttoexcel
            LET g_action_choice="exprottoexcel"
            EXIT DIALOG 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG 
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         ON ACTION about
            CALL cl_about()
         ON ACTION help    
            CALL cl_show_help()
         ON ACTION controlg 
            CALL cl_cmdask()
         ON ACTION cancel
            LET g_action_choice="exit"
            EXIT DIALOG 
      END DISPLAY
      ON ACTION view1
         CALL ui.Interface.refresh() 
   END DIALOG}
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p201_q()
 
   CALL p201_b_askkey()
END FUNCTION
 
 
FUNCTION p201_b_askkey()
   CLEAR FORM
   CALL g_oea1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   LET g_field = ''   #FUN-A30021
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
#                   LET g_qryparam.form ="q_oea11" #MOD-830025
#                   LET g_qryparam.form ="q_oea11_t" #MOD-830025 #TQC-BC0076  mark
                    LET g_qryparam.form ="q_oea11_a" #TQC-BC0076  add
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
 
   CALL p201_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_oea1_t.* = g_oea1[l_ac1].*
 
   CALL p201_b_fill_1()
   CALL p201_b_fill_2()
   CALL p201_b_fill_3()
   CALL p201_b_fill_4()
   CALL p201_b_fill_5()
   CALL p201_b_fill_6()
   CALL p201_b_fill_7()
END FUNCTION
 
FUNCTION p201_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = "SELECT oea02,oea01,oea00,oea08,oea03,oea032,oea04,'',",
               "       oea10,oea23,oea21,oea31,oea32,oea14,'',oeaconf,oea49", 
               "  FROM oea_file ",
               " WHERE ",p_wc2 CLIPPED,
               "   AND oea00 IN('1','2','3','4','5','6','7') ",
               "   AND (oea901 = 'N' OR oea901 IS NULL) ",
               " ORDER BY oea02,oea03"
 
   PREPARE p201_pb1 FROM g_sql
   DECLARE oea_curs CURSOR FOR p201_pb1
  
   CALL g_oea1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH oea_curs INTO g_oea1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
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
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION p201_b_fill_1()
    LET g_sql =
        #FUN-550103 Start , 下面注掉的是原有程序,新程序增加了20個欄位的空白顯示
        "SELECT oeb03,oeb04,'','','','','','','','','','','','','','','','',",
        "       '','','','','',oeb06,ima021,ima1002,ima135,oeb11,",  
        "       oeb71,oeb1001,oeb1012,",
        "       oeb906,oeb092,oeb15,oeb05,oeb12,",  
        "       oeb913,oeb914,oeb915,oeb910,oeb911,oeb912,",
        "       oeb916,oeb917,oeb24,oeb27,oeb28,oeb1004,oeb1002,",  
        "       oeb13,oeb1006,oeb14,oeb14t,oeb09,oeb091,oeb930,'',",
        "       oeb908,oeb22,oeb19,oeb70,ima15,oeb16 ", 
        " FROM oeb_file,OUTER ima_file ",
        " WHERE oeb01 ='",g_oea1_t.oea01,"'",  #單頭
        " AND oeb04=ima_file.ima01 ",
        " AND oeb1003='1' ",
        " ORDER BY oeb03"
 
   PREPARE p201_pb FROM g_sql
   DECLARE oeb_curs CURSOR FOR p201_pb
  
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
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#出通單
FUNCTION p201_b_fill_2()
    LET g_sql =
        "SELECT oga01,ogb03,ogb1005,ogb31,ogb32,ogb04,",
        "       '','','','','','','','','',",
        "       '','','','','','','','','','','','',",
        "       ogb06,ima021,ima1002,ima135,ogb11,ogb1001,ogb1012,",  
        "       ogb17,ogb09,ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,",
        "       ogb913,ogb914,",  
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917, ",
        "       0,0,0,ogb65,'','',",  
        "       ogb1004,ogb1002,ogb13,ogb1006,ogb14,ogb14t,",   
        "       ogb930,'',ogb908 ", 
        " FROM ogb_file,oga_file,OUTER ima_file ",
        " WHERE ogb01 = oga01 ",  
        " AND ogb04=ima_file.ima01 ",
        " AND ogb1005 ='1'",   
        "  AND oga09 IN ('1','5') ",
        "  AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY oga01,ogb03"
 
    PREPARE p201_pb2 FROM g_sql
    DECLARE ogb1_cs                       #CURSOR
        CURSOR FOR p201_pb2
 
    CALL g_ogb1.clear()
 
    LET g_cnt = 1
    FOREACH ogb1_cs INTO g_ogb1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改                                                             
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                                                                        
                  imx07,imx08,imx09,imx10 INTO                                                                                      
                  g_ogb1[g_cnt].att00_gb1,g_ogb1[g_cnt].att01_gb1,g_ogb1[g_cnt].att02_gb1,                                                         
                  g_ogb1[g_cnt].att03_gb1,g_ogb1[g_cnt].att04_gb1,g_ogb1[g_cnt].att05_gb1,                                                         
                  g_ogb1[g_cnt].att06_gb1,g_ogb1[g_cnt].att07_gb1,g_ogb1[g_cnt].att08_gb1,                                                         
                  g_ogb1[g_cnt].att09_gb1,g_ogb1[g_cnt].att10_gb1                                                                             
           FROM imx_file WHERE imx000 = g_ogb1[g_cnt].ogb04_gb1                                                                          
                                                                                                                                    
           LET g_ogb1[g_cnt].att01_c_gb1 = g_ogb1[g_cnt].att01_gb1                                                                            
           LET g_ogb1[g_cnt].att02_c_gb1 = g_ogb1[g_cnt].att02_gb1                                                                            
           LET g_ogb1[g_cnt].att03_c_gb1 = g_ogb1[g_cnt].att03_gb1                                                                            
           LET g_ogb1[g_cnt].att04_c_gb1 = g_ogb1[g_cnt].att04_gb1                                                                            
           LET g_ogb1[g_cnt].att05_c_gb1 = g_ogb1[g_cnt].att05_gb1                                                                            
           LET g_ogb1[g_cnt].att06_c_gb1 = g_ogb1[g_cnt].att06_gb1                                                                            
           LET g_ogb1[g_cnt].att07_c_gb1 = g_ogb1[g_cnt].att07_gb1                                                                            
           LET g_ogb1[g_cnt].att08_c_gb1 = g_ogb1[g_cnt].att08_gb1                                                                            
           LET g_ogb1[g_cnt].att09_c_gb1 = g_ogb1[g_cnt].att09_gb1                                                                            
           LET g_ogb1[g_cnt].att10_c_gb1 = g_ogb1[g_cnt].att10_gb1                                                                            
        END IF  
 
        IF cl_null(g_ogb1[g_cnt].ogb910_gb1) THEN 
           LET g_ogb1[g_cnt].ogb911_gb1 = NULL
           LET g_ogb1[g_cnt].ogb912_gb1 = NULL
        END IF
        IF cl_null(g_ogb1[g_cnt].ogb913_gb1) THEN 
           LET g_ogb1[g_cnt].ogb914_gb1 = NULL
           LET g_ogb1[g_cnt].ogb915_gb1 = NULL
        END IF
        IF g_ogb1[g_cnt].ogb04_gb1[1,4]!='MISC' THEN 
           SELECT ima1002,ima135 INTO g_ogb1[g_cnt].ima1002_gb1,g_ogb1[g_cnt].ima135_gb1                                                    
             FROM ima_file                                                                                                    
            WHERE ima01 = g_ogb1[g_cnt].ogb04_gb1                                                                                  
        END IF                                            
        LET g_ogb1[g_cnt].gem02c_gb1=s_costcenter_desc(g_ogb1[g_cnt].ogb930_gb1) 
        LET g_cnt = g_cnt + 1
    END FOREACH
 
   CALL g_ogb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b2 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#出貨單
FUNCTION p201_b_fill_3()
    DEFINE l_oga65    LIKE oga_file.oga65
 
 
    LET g_sql =
        "SELECT oga01,ogb03,ogb1005,ogb31,ogb32,ogb04,",
        "       '','','','','','','','','',",
        "       '','','','','','','','','','','','',",
        "       ogb06,ima021,ima1002,ima135,ogb11,ogb1001,ogb1012,",  
        "       ogb17,ogb09,ogb091,ogb092,ogb1003,ogb19,ogb05,ogb12,",
        "       ogb913,ogb914,",  
        "       ogb915,ogb910,ogb911,ogb912,ogb916,ogb917, ",
        "       0,0,0,ogb65,'','',",  
        "       ogb1004,ogb1002,ogb13,ogb1006,ogb14,ogb14t,",   
        "       ogb930,'',ogb908 ", 
        " FROM ogb_file,oga_file,OUTER ima_file ",
        " WHERE ogb01 = oga01 ",  
        " AND ogb04=ima_file.ima01 ",
        " AND ogb1005 ='1'",   
        "  AND oga09 IN ('2','3','4','6') ",
        "  AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY oga01,ogb03"
 
    PREPARE p201_pb3 FROM g_sql
    DECLARE ogb2_cs                       #CURSOR
        CURSOR FOR p201_pb3
 
    CALL g_ogb2.clear()
 
    LET g_cnt = 1
    FOREACH ogb2_cs INTO g_ogb2[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        ##如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改                                                             
        IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                                                                           
           #得到該料件對應的父料件和所有屬性                                                                                        
           SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                                                                        
                  imx07,imx08,imx09,imx10 INTO                                                                                      
                  g_ogb2[g_cnt].att00_gb2,g_ogb2[g_cnt].att01_gb2,g_ogb2[g_cnt].att02_gb2,                                                         
                  g_ogb2[g_cnt].att03_gb2,g_ogb2[g_cnt].att04_gb2,g_ogb2[g_cnt].att05_gb2,                                                         
                  g_ogb2[g_cnt].att06_gb2,g_ogb2[g_cnt].att07_gb2,g_ogb2[g_cnt].att08_gb2,                                                         
                  g_ogb2[g_cnt].att09_gb2,g_ogb2[g_cnt].att10_gb2                                                                             
           FROM imx_file WHERE imx000 = g_ogb2[g_cnt].ogb04_gb2                                                                          
                                                                                                                                    
           LET g_ogb2[g_cnt].att01_c_gb2 = g_ogb2[g_cnt].att01_gb2                                                                            
           LET g_ogb2[g_cnt].att02_c_gb2 = g_ogb2[g_cnt].att02_gb2                                                                            
           LET g_ogb2[g_cnt].att03_c_gb2 = g_ogb2[g_cnt].att03_gb2                                                                            
           LET g_ogb2[g_cnt].att04_c_gb2 = g_ogb2[g_cnt].att04_gb2                                                                            
           LET g_ogb2[g_cnt].att05_c_gb2 = g_ogb2[g_cnt].att05_gb2                                                                            
           LET g_ogb2[g_cnt].att06_c_gb2 = g_ogb2[g_cnt].att06_gb2                                                                            
           LET g_ogb2[g_cnt].att07_c_gb2 = g_ogb2[g_cnt].att07_gb2                                                                            
           LET g_ogb2[g_cnt].att08_c_gb2 = g_ogb2[g_cnt].att08_gb2                                                                            
           LET g_ogb2[g_cnt].att09_c_gb2 = g_ogb2[g_cnt].att09_gb2                                                                            
           LET g_ogb2[g_cnt].att10_c_gb2 = g_ogb2[g_cnt].att10_gb2                                                                            
        END IF  
 
        IF cl_null(g_ogb2[g_cnt].ogb910_gb2) THEN 
           LET g_ogb2[g_cnt].ogb911_gb2 = NULL
           LET g_ogb2[g_cnt].ogb912_gb2 = NULL
        END IF
        IF cl_null(g_ogb2[g_cnt].ogb913_gb2) THEN 
           LET g_ogb2[g_cnt].ogb914_gb2 = NULL
           LET g_ogb2[g_cnt].ogb915_gb2 = NULL
        END IF
        IF g_ogb2[g_cnt].ogb04_gb2[1,4]!='MISC' THEN 
           SELECT ima1002,ima135 INTO g_ogb2[g_cnt].ima1002_gb2,g_ogb2[g_cnt].ima135_gb2                                                    
             FROM ima_file                                                                                                    
            WHERE ima01 = g_ogb2[g_cnt].ogb04_gb2                                                                                  
        END IF   
 
        LET l_oga65 = ''                                         
         SELECT oga65 INTO l_oga65 FROM oga_file 
          WHERE oga01 = g_ogb2[g_cnt].ogb01_gb2
        IF l_oga65='Y' THEN
           SELECT ogb01 INTO g_ogb2[g_cnt].ogb01a_gb2
             FROM ogb_file,oga_file
            WHERE ogb01 =oga01
              AND oga011=g_ogb2[g_cnt].ogb01_gb2
              AND oga09 = '8'
              AND ogb03 = g_ogb2[g_cnt].ogb03_gb2
           SELECT ogb01 INTO g_ogb2[g_cnt].ogb01b_gb2
             FROM ogb_file,oga_file
            WHERE ogb01 =oga01
              AND oga011=g_ogb2[g_cnt].ogb01_gb2
              AND oga09 = '9'
              AND ogb03 = g_ogb2[g_cnt].ogb03_gb2
        END IF
        LET g_ogb2[g_cnt].gem02c_gb2=s_costcenter_desc(g_ogb2[g_cnt].ogb930_gb2) 
        LET g_cnt = g_cnt + 1
    END FOREACH
   CALL g_ogb2.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b3 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
#應收
FUNCTION p201_b_fill_4()
    LET g_sql =
        "SELECT omb01,omb03,omb38,omb31,omb32,omb39,omb04,omb06,ima021_omb06,",    #TQC-C60075 add 
        "       omb40,omb05,omb12,omb33,omb331,", 
        "       omb13,omb14,omb14t,omb15,omb16,omb16t,",
        "       omb17,omb18,omb18t,omb930,''", 
        " FROM omb_file,oga_file,ogb_file LEFT OUTER JOIN  ima_file ON omb04 = ima01 ",  #TQC-C60075 add
        " WHERE omb01 = oga10 ",  
        "   AND oga01 = ogb01 ",
        "   AND omb31 = ogb01 ",
        "   AND omb32 = ogb03 ",
        "   AND ogb31 = '", g_oea1_t.oea01 CLIPPED,"'",
        " ORDER BY omb03"
 
    PREPARE p201_pb4 FROM g_sql
    DECLARE omb_curs CURSOR FOR p201_pb4      #SCROLL CURSOR
    CALL g_omb.clear()
    LET g_cnt = 1
    FOREACH omb_curs INTO g_omb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        LET g_omb[g_cnt].gem02c_omb=s_costcenter_desc(g_omb[g_cnt].omb930)
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_omb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b4 = g_cnt - 1
    CALL ui.Interface.refresh()
    LET g_cnt = 0
END FUNCTION
 
#工單
FUNCTION p201_b_fill_5()
   LET g_sql = " SELECT sfb01,sfb81,sfb02,sfb221,sfb05,",
               "        '','',sfb08,sfb13,sfb15,sfb25,sfb081,",
               "        sfb09,sfb12,sfb87,sfb04",
               " FROM sfb_file ",
               " WHERE sfb22 = '", g_oea1_t.oea01 CLIPPED, "'"
   PREPARE p201_pb5 FROM g_sql
   DECLARE sfb_curs CURSOR FOR p201_pb5
  
   CALL g_sfb.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH sfb_curs INTO g_sfb[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
     
      IF NOT cl_null(g_sfb[g_cnt].sfb05) THEN
         SELECT ima02,ima021 INTO g_sfb[g_cnt].ima02_sfb,
                                  g_sfb[g_cnt].ima021_sfb
           FROM ima_file
          WHERE ima01 = g_sfb[g_cnt].sfb05
      END IF 
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_sfb.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b5 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
 
#請購單
FUNCTION p201_b_fill_6()
   LET g_sql="SELECT pml01,pml02,pml24,pml25,pml04,",
             "      '','','','','','','','','','','','','','','','','','','','','', ",  #NO.FUN-670007 add pml24/pml25
             "       pml041,ima021,pml07,pml20,",
             "       pml83,pml84,pml85,pml80,pml81,pml82,pml86,pml87,",
             "       pml21,pml35,pml34,pml33,pml41,",   
             "       pml190,pml191,pml192,",     
             "       pml12,pml121,pml122,pml930,'',pml06,pml38,pml11 ", 
             " FROM pml_file,OUTER ima_file ",
             " WHERE pml04=ima_file.ima01",
             "   AND pml24 = '",g_oea1_t.oea01 CLIPPED,"'",
             " ORDER BY pml01,pml02 " 
 
   PREPARE p201_pb6 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE pml_cnts CURSOR FOR p201_pb6
 
   CALL g_pml.clear()
   LET g_cnt=1
   FOREACH pml_cnts INTO g_pml[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      IF cl_null(g_pml[g_cnt].pml80) THEN
         LET g_pml[g_cnt].pml81 = NULL
         LET g_pml[g_cnt].pml82 = NULL
      END IF
      IF cl_null(g_pml[g_cnt].pml83) THEN
         LET g_pml[g_cnt].pml84 = NULL
         LET g_pml[g_cnt].pml85 = NULL
      END IF
      SELECT gem02 INTO g_pml[g_cnt].gem02a_ml FROM gem_file
                            WHERE gem01=g_pml[g_cnt].pml930
                             
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改         
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                       
         #得到該料件對應的父料件和所有屬性                                    
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                    
                imx07,imx08,imx09,imx10 INTO                                  
                g_pml[g_cnt].att00_ml,g_pml[g_cnt].att01_ml,g_pml[g_cnt].att02_ml,     
                g_pml[g_cnt].att03_ml,g_pml[g_cnt].att04_ml,g_pml[g_cnt].att05_ml,     
                g_pml[g_cnt].att06_ml,g_pml[g_cnt].att07_ml,g_pml[g_cnt].att08_ml,     
                g_pml[g_cnt].att09_ml,g_pml[g_cnt].att10_ml                         
         FROM imx_file WHERE imx000 = g_pml[g_cnt].pml04      
 
         LET g_pml[g_cnt].att01_c_ml = g_pml[g_cnt].att01_ml                        
         LET g_pml[g_cnt].att02_c_ml = g_pml[g_cnt].att02_ml                        
         LET g_pml[g_cnt].att03_c_ml = g_pml[g_cnt].att03_ml                        
         LET g_pml[g_cnt].att04_c_ml = g_pml[g_cnt].att04_ml                        
         LET g_pml[g_cnt].att05_c_ml = g_pml[g_cnt].att05_ml                        
         LET g_pml[g_cnt].att06_c_ml = g_pml[g_cnt].att06_ml                        
         LET g_pml[g_cnt].att07_c_ml = g_pml[g_cnt].att07_ml                        
         LET g_pml[g_cnt].att08_c_ml = g_pml[g_cnt].att08_ml                        
         LET g_pml[g_cnt].att09_c_ml = g_pml[g_cnt].att09_ml                        
         LET g_pml[g_cnt].att10_c_ml = g_pml[g_cnt].att10_ml                        
                                                                              
      END IF                                                                  
                               
      LET g_cnt = g_cnt +1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pml.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b6 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
 
#採購單
FUNCTION p201_b_fill_7()
 
   LET g_sql ="SELECT pmn01,pmn02,pmn24,pmn25,pmn65,pmn41,pmn42,pmn16,pmn04,",
             #"       '','','','','','','','','','','','','','','','','','','','','',",#No.TQC-650108
              "       pmn041,ima021,pmn07,pmn20,pmn83,pmn84,pmn85,",
              "       pmn80,pmn81,pmn82,pmn86,pmn87,pmn68,pmn69,pmn31,",
              "       pmn31t,pmn64,pmn63,pmn33,pmn34,pmn122,pmn930,'',",
              "       pmn43,pmn431 ",  
              "      ,pmn38 ,pmn90",   
              #"      ,pmn94,pmn95 ",  #FUN-740046
              " FROM pmn_file,OUTER ima_file ",
              " WHERE pmn04=ima_file.ima01 ",
              #"   AND pmn94 ='", g_oea1_t.oea01 CLIPPED, "'",   #FUN-740046
              "   AND pmn24 ='", g_oea1_t.oea01 CLIPPED, "'",    #FUN-740046
              " ORDER BY pmn01,pmn02"
 
   PREPARE p201_pb7 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE pmn_cs CURSOR FOR p201_pb7
   CALL g_pmn.clear()
   LET g_cnt = 1
   FOREACH pmn_cs INTO g_pmn[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_pmn[g_cnt].att00_mn,g_pmn[g_cnt].att01_mn,g_pmn[g_cnt].att02_mn,
                g_pmn[g_cnt].att03_mn,g_pmn[g_cnt].att04_mn,g_pmn[g_cnt].att05_mn,
                g_pmn[g_cnt].att06_mn,g_pmn[g_cnt].att07_mn,g_pmn[g_cnt].att08_mn,
                g_pmn[g_cnt].att09_mn,g_pmn[g_cnt].att10_mn
           FROM imx_file WHERE imx000 = g_pmn[g_cnt].pmn04
 
           LET g_pmn[g_cnt].att01_c_mn = g_pmn[g_cnt].att01_mn
           LET g_pmn[g_cnt].att02_c_mn = g_pmn[g_cnt].att02_mn
           LET g_pmn[g_cnt].att03_c_mn = g_pmn[g_cnt].att03_mn
           LET g_pmn[g_cnt].att04_c_mn = g_pmn[g_cnt].att04_mn
           LET g_pmn[g_cnt].att05_c_mn = g_pmn[g_cnt].att05_mn
           LET g_pmn[g_cnt].att06_c_mn = g_pmn[g_cnt].att06_mn
           LET g_pmn[g_cnt].att07_c_mn = g_pmn[g_cnt].att07_mn
           LET g_pmn[g_cnt].att08_c_mn = g_pmn[g_cnt].att08_mn
           LET g_pmn[g_cnt].att09_c_mn = g_pmn[g_cnt].att09_mn
           LET g_pmn[g_cnt].att10_c_mn = g_pmn[g_cnt].att10_mn
                                   
      END IF                       
 
      SELECT gem02 INTO g_pmn[g_cnt].gem02a_mn 
        FROM gem_file
       WHERE gem01= g_pmn[g_cnt].pmn930
     
      LET g_cnt = g_cnt+1
      IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 1 ) #MOD-640492 0->1
       EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_pmn.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b7 = g_cnt - 1
   CALL ui.Interface.refresh()
   LET g_cnt = 0
END FUNCTION
 
 
 
FUNCTION p201_menu()
   DEFINE l_oga01       LIKE oga_file.oga01
   WHILE TRUE
      #-----FUN-A30021---------
      CASE  
          WHEN g_action_choice = "so"
               LET g_field = 'oeb03'
          WHEN g_action_choice = "da" OR g_action_choice = "carry_da"
               LET g_field = 'ogb01_gb1'
          WHEN g_action_choice = "dn" OR g_action_choice = "carry_dn"
               LET g_field = 'ogb01_gb2'
          WHEN g_action_choice = "ar" OR g_action_choice = "carry_ar"
               LET g_field = 'omb01'
          WHEN g_action_choice = "wo" OR g_action_choice = "carry_wo"
               LET g_field = 'sfb01'
          WHEN g_action_choice = "po" OR g_action_choice = "carry_po"
               LET g_field = 'pml01'
          WHEN g_action_choice = "pr" OR g_action_choice = "carry_pr"
               LET g_field = 'pmn01'
      END CASE
      #-----END FUN-A30021-----
      CALL p201_bp()
      CASE g_action_choice
         WHEN "query"                                                                                                               
            IF cl_chk_act_auth() THEN                                                                                               
               CALL p201_q()                                                                                                        
            END IF
         WHEN "query_ar"   #全部選取
            CALL p201_qry_ar()
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oea1),'','')
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "carry_da"
            IF cl_chk_act_auth() THEN
               LET g_flag = 'Y'
               CALL s_showmsg_init()
               #CALL p201_chk_oea()   #MOD-A30168
               IF g_flag = 'Y' THEN
                  CALL p201_dis_oga("2")
                  CALL s_showmsg()
                  IF g_success = 'Y' THEN
                     CALL t600sub_y_upd(g_oga.oga01,"confirm")
                     CALL p201_b_fill_2()
                  END IF
               END IF
            END IF
         WHEN "carry_dn"
            IF cl_chk_act_auth() THEN
               LET g_flag = 'Y'
               CALL s_showmsg_init()
               #CALL p201_chk_oea()   #MOD-A30168
               IF g_flag = 'Y' THEN
                  CALL p201_chk_oga() RETURNING l_oga01
                  IF NOT cl_null(l_oga01) THEN
                     CALL p201_carry_oga1(l_oga01)
                  ELSE
                     CALL p201_dis_oga("1")
                  END IF
                  CALL s_showmsg()
                  IF g_success = 'Y' THEN
                     IF NOT cl_null(begin_no) THEN
                        LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
                        CALL cl_err(g_msg CLIPPED,"mfg0101",1)
                     END IF
                     CALL t600sub_y_upd(g_oga.oga01,"confirm")
                     IF g_success='Y' THEN
                        CALL t600sub_s('2',FALSE,g_oga.oga01,FALSE)
                     END IF
                     CALL p201_b_fill_3()
                  END IF
               END IF
            END IF
         WHEN "carry_ar"
            IF cl_chk_act_auth() THEN
               CALL p201_carry_ar()
               CALL p201_b_fill_3()
               CALL p201_b_fill_4()
            END IF
 
         WHEN "carry_wo"
            IF cl_chk_act_auth() THEN
               LET g_flag = 'Y'
               CALL p201_chk_oea1() 
               CALL p201_chk_oea2()
               IF g_flag = 'Y' THEN
                  LET g_success='Y'
                  CALL p201_dis_sfb()
                  CALL p201_b_fill_5()
               END IF
            END IF
         WHEN "carry_pr"
            IF cl_chk_act_auth() THEN
               LET g_flag = 'Y'
               CALL p201_chk_oea1()
               IF g_flag = 'Y' THEN
                  IF g_oea.oea00 = '4' THEN
                    CALL cl_err('','axm-054',1)
                    CONTINUE WHILE
                  END IF
                   
                  IF cl_null(g_oea.oeahold) THEN
                    CALL t201_exp(g_oea1_t.oea01)
                    IF g_success='Y' THEN
                       CALL p201_b_fill_6()
                    END IF
                  ELSE
                    CALL cl_err('','axm-296',1)
                  END IF
               END IF
            END IF
         WHEN "carry_po"
            IF cl_chk_act_auth() THEN          
               LET g_flag = 'Y'
               CALL p201_chk_oea1()
               IF g_flag='Y' THEN
                  IF g_oea.oea00 = '4' THEN            
                    CALL cl_err('','axm-054',1)             
                    CONTINUE WHILE
                  END IF  
                  IF cl_null(g_oea.oeahold) THEN
                    CALL t201sub_exp_po(g_oea1_t.oea01)
                    CALL p201_b_fill_7()
                  ELSE
                    CALL cl_err('','axm-296',1)
                  END IF
               END IF
            END IF
         WHEN "so"  #訂單
            IF l_ac_b1>0 THEN
               LET g_msg = " axmt410 '",g_oea1_t.oea01 CLIPPED,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "da"  #出通
            IF l_ac_b2>0 THEN
               LET g_msg = " axmt610 '",g_ogb1[l_ac_b2].ogb01_gb1 CLIPPED,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "dn"  #出貨
            IF l_ac_b3>0 THEN
               LET g_msg = " axmt620 '",g_ogb2[l_ac_b3].ogb01_gb2 CLIPPED,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "ar"  #應收
            IF l_ac_b4>0 THEN
               LET g_msg = " axrt300 '",g_omb[l_ac_b4].omb01 CLIPPED,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "wo"  #工單
            IF l_ac_b5>0 THEN
               LET g_msg = " asfi301 '",g_sfb[l_ac_b5].sfb01 CLIPPED,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "pr"  #請購
            IF l_ac_b6>0 THEN
               LET g_msg = " apmt420 '",g_pml[l_ac_b6].pml01 CLIPPED,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         WHEN "po"  #採購
            IF l_ac_b7>0 THEN
               LET g_msg = " apmt540 '",g_pmn[l_ac_b7].pmn01 CLIPPED,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
      END CASE
   END WHILE
END FUNCTION 
 
FUNCTION p201_refresh_detail()
  DEFINE l_cntompare          LIKE oay_file.oay22    
  DEFINE li_col_cntount       LIKE type_file.num5    #No.FUN-680137 SMALLINT
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
         SELECT imaag INTO l_cntompare FROM ima_file WHERE ima01 = g_oeb1[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_cntompare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_cntompare <> lg_group THEN
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
     SELECT COUNT(*) INTO li_col_cntount FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替oeb04子料件編號來顯示
     #得到當前語言別下oeb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'oeb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'ogb04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00_gb1",l_gae04)
     CALL cl_set_comp_att_text("att00_gb2",l_gae04)
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'pml04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00_ml",l_gae04)
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'pmn04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00_mn",l_gae04)
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'oeb04,oeb06'
        LET ls_show = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn'
     ELSE
        LET ls_hide = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn'
        LET ls_show = 'oeb04,oeb06,ogb04_gb1,ogb04_gb2,ogb06_gb1,ogb06_gb2,pml041,pmn041'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_cntount
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
             LET ls_show = ls_show || ",att" || lc_index || "_gb1"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb1"
             LET ls_show = ls_show || ",att" || lc_index || "_gb2"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb2"
             LET ls_show = ls_show || ",att" || lc_index || "_ml"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_ml"
             LET ls_show = ls_show || ",att" || lc_index || "_mn"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_mn"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index|| "_mn",lr_agc[li_i].agc02)
             
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             LET ls_show = ls_show || ",att" || lc_index || "_c_gb1"
             LET ls_hide = ls_hide || ",att" || lc_index || "_gb1"
             LET ls_show = ls_show || ",att" || lc_index || "_c_gb2"
             LET ls_hide = ls_hide || ",att" || lc_index || "_gb2"
             LET ls_show = ls_show || ",att" || lc_index || "_c_ml"
             LET ls_hide = ls_hide || ",att" || lc_index || "_ml"
             LET ls_show = ls_show || ",att" || lc_index || "_c_mn"
             LET ls_hide = ls_hide || ",att" || lc_index || "_mn"
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_c_mn",lr_agc[li_i].agc02)
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
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_gb1",ls_combo_vals,ls_combo_txts)
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_gb2",ls_combo_vals,ls_combo_txts)
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_ml",ls_combo_vals,ls_combo_txts)
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c_mn",ls_combo_vals,ls_combo_txts)
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             LET ls_show = ls_show || ",att" || lc_index || "_gb1"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb1"
             LET ls_show = ls_show || ",att" || lc_index || "_gb2"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_gb2"
             LET ls_show = ls_show || ",att" || lc_index || "_ml"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_ml"
             LET ls_show = ls_show || ",att" || lc_index || "_mn"
             LET ls_hide = ls_hide || ",att" || lc_index || "_c_mn"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_gb1",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_gb2",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_ml",lr_agc[li_i].agc02)
             CALL cl_set_comp_att_text("att" || lc_index || "_mn",lr_agc[li_i].agc02)
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00,att00_gb1,att00_gb2,att00_ml,att00_mn'
    LET ls_show = 'oeb04,ogb04_gb1,ogb04_gb2,pml041,pmn041'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
      LET ls_hide = ls_hide || ",att" || lc_index || "_gb1" || ",att" || lc_index || "_c_gb1"
      LET ls_hide = ls_hide || ",att" || lc_index || "_gb2" || ",att" || lc_index || "_c_gb2"
      LET ls_hide = ls_hide || ",att" || lc_index || "_ml"  || ",att" || lc_index || "_c_ml"
      LET ls_hide = ls_hide || ",att" || lc_index || "_mn"  || ",att" || lc_index || "_c_mn"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
 
 
FUNCTION p201_init()
   IF g_sma.sma120 = 'Y'  THEN                                                                                                      
      LET lg_oay22 = ''                                                                                                             
      LET lg_group = ''                                                                                                             
      CALL p201_refresh_detail()                                                                                                    
   END IF                                                                                                                           
 
   LET g_plant2 = g_plant        #FUN-980020
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
 
 
   IF g_aza.aza50='Y' THEN
       CALL cl_chg_comp_att("ima1002_oeb,ima135_oeb,oeb11,oeb1012,oeb1004,oeb1002,   
                                 oeb1006,oeb09,oeb091","HIDDEN","0")
   ELSE
       CALL cl_chg_comp_att("ima1002_oeb,ima135_oeb,oeb11,oeb1012,oeb1004,oeb1002,   
                                 oeb1006,oeb09,oeb091","HIDDEN","1")
   END IF
 
    CALL cl_chg_comp_att("oeb911,oeb914","HIDDEN","1")
    IF g_sma.sma115 ='N' THEN
       CALL cl_chg_comp_att("oeb913,oeb915","HIDDEN","1")   
       CALL cl_chg_comp_att("oeb910,oeb912","HIDDEN","1")   
    ELSE
       CALL cl_chg_comp_att("oeb05,oeb12","HIDDEN","1")
    END IF
    IF g_sma.sma116 MATCHES '[01]' THEN  
       CALL cl_chg_comp_att("oeb916,oeb917","HIDDEN","1")
    END IF
    
    
    CALL cl_chg_comp_att("oeb930,gem02c","HIDDEN",g_aaz.aaz90!='Y')  #FUN-670063
 
#出通/出貨
   CALL cl_chg_comp_att("ogb12b_gb1,ogb65_gb1,ogb915b_gb1,ogb912b_gb1","HIDDEN","1")
   CALL cl_chg_comp_att("ogb01a_gb1,ogb01b_gb1","HIDDEN","1") 
   CALL cl_chg_comp_att("ogb12b_gb2,ogb65_gb2,ogb915b_gb2,ogb912b_gb2","HIDDEN","1")
   CALL cl_chg_comp_att("ogb01a_gb2,ogb01b_gb2","HIDDEN","1") 
 
   CALL cl_chg_comp_att("ogb911_gb1,ogb914_gb1","HIDDEN","1")
   CALL cl_chg_comp_att("ogb1005_gb1","HIDDEN","1")   
   CALL cl_chg_comp_att("ogb911_gb2,ogb914_gb2","HIDDEN","1")
   CALL cl_chg_comp_att("ogb1005_gb2","HIDDEN","1")   
 
   CALL cl_chg_comp_att("ogb1005_gb1","HIDDEN","1")   
 
   CALL cl_chg_comp_att("ogb930_gb1,gem02c_gb1","HIDDEN",g_aaz.aaz90!='Y') 
   CALL cl_chg_comp_att("ogb930_gb2,gem02c_gb2","HIDDEN",g_aaz.aaz90!='Y') 
 
   IF (g_aza.aza50='N') THEN
      CALL cl_chg_comp_att("ogb11_gb1,ogb13_gb1,ogb14_gb1,ogb14t_gb1,ogb1002_gb1,ogb1003_gb1,ogb1004_gb1,ogb1005_gb1,ogb1006_gb1,ogb1012_gb1,ima1002_gb1,ima135_gb1","HIDDEN","1")   
      CALL cl_chg_comp_att("ogb11_gb2,ogb13_gb2,ogb14_gb2,ogb14t_gb2,ogb1002_gb2,ogb1003_gb2,ogb1004_gb2,ogb1005_gb2,ogb1006_gb2,ogb1012_gb2,ima1002_gb2,ima135_gb2","HIDDEN","1")   
   END IF
 
   CALL cl_chg_comp_att("ogb1005_gb1","HIDDEN","1")   
 
 
   CALL cl_chg_comp_att("ogb914_gb1,ogb911_gb1,ogb914_gb2,ogb911_gb2","HIDDEN","1")   
   IF g_sma.sma115 ='N' THEN
      CALL cl_chg_comp_att("ogb913_gb1,ogb915_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb910_gb1,ogb912_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb913_gb2,ogb915_gb2","HIDDEN","1")
      CALL cl_chg_comp_att("ogb910_gb2,ogb912_gb2","HIDDEN","1")
   ELSE
      CALL cl_chg_comp_att("ogb05_gb1,ogb12_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb05_gb2,ogb12_gb2","HIDDEN","1")
   END IF
 
   IF g_sma.sma116 MATCHES '[01]' THEN    
      CALL cl_chg_comp_att("ogb916_gb1,ogb917_gb1","HIDDEN","1")
      CALL cl_chg_comp_att("ogb916_gb2,ogb917_gb2","HIDDEN","1")
   END IF
   #-----END CHI-8C0026-----
 
   IF g_oaz.oaz23 = 'Y' THEN
      CALL cl_getmsg('axm-042',g_lang) RETURNING g_msg 
      CALL cl_set_comp_att_text("ogb17_gb1",g_msg CLIPPED)   
      CALL cl_set_comp_att_text("ogb17_gb2",g_msg CLIPPED)   
   END IF
  ############
 
    #初始化界面的樣式(沒有任何默認屬性組)
    LET lg_oay22 = ''
    LET lg_group = ''
    CALL p201_refresh_detail()
END FUNCTION
 
 
 
FUNCTION p201_qry_ar()
   LET g_msg = " axrq320 '",g_oea1_t.oea03 CLIPPED,"'"
   CALL cl_cmdrun_wait(g_msg CLIPPED)
END FUNCTION
 
FUNCTION p201_dis_oga(p_type)
   DEFINE p_type         LIKE type_file.chr1     #1、轉出貨單 2、轉出通單
   DEFINE l_oea00   LIKE oea_file.oea00        #類別 
   DEFINE l_oea03   LIKE oea_file.oea03        #帳款客戶編號  
   DEFINE l_oea04   LIKE oea_file.oea04        #送貨客戶編號 
   DEFINE l_oea044  LIKE oea_file.oea044       #送貨地址碼  
   DEFINE l_oea05   LIKE oea_file.oea05        #發票別     
   DEFINE l_oea06   LIKE oea_file.oea06        #訂單維護作業預設起始版本編號
   DEFINE l_oea07   LIKE oea_file.oea07        #出貨是否計入未開發票的銷貨待驗收
   DEFINE l_oea08   LIKE oea_file.oea08        #內/外銷                       
   DEFINE l_oea1001 LIKE oea_file.oea1001                                    
   DEFINE l_oea1002 LIKE oea_file.oea1002 
   DEFINE l_oea1003 LIKE oea_file.oea1003
   DEFINE l_oea1004 LIKE oea_file.oea1004
   DEFINE l_oea1005 LIKE oea_file.oea1005
   DEFINE l_oea1009 LIKE oea_file.oea1009
   DEFINE l_oea1010 LIKE oea_file.oea1010
   DEFINE l_oea1011 LIKE oea_file.oea1011
   DEFINE l_oea1015 LIKE oea_file.oea1015
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
                                          
   DEFINE l_i,l_n       LIKE type_file.num5
   LET begin_no = NULL
   LET end_no = NULL                                     
   IF NOT  p201_chk_oea3(p_type) THEN RETURN END IF         
   CASE p_type                                              
      WHEN "1" #出貨單                                         
        SELECT COUNT(*) INTO l_n FROM oga_file WHERE oga16=g_oea1_t.oea01
                                        AND oga09='2'
        IF l_n>0 THEN 
           CALL cl_err(g_oea1_t.oea01,'axm-648',0)
           RETURN 
        END IF
                                                          
      WHEN "2" #出通單             
        SELECT COUNT(*) INTO l_n FROM oga_file WHERE oga16=g_oea1_t.oea01                   
        IF l_n>0 THEN
           CALL cl_err(g_oea1_t.oea01,'axm-649',0)
           RETURN 
        END IF
   END CASE                                            
   CALL p201_slip(p_type)
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   LET l_n = 0                 
   LET g_sql = "SELECT DISTINCT oea_file.*",                                                           
               "  FROM oea_file,oeb_file ",                                                                                         
               " WHERE oea01 = oeb01 ",                                                                                              
               "   AND (oeb12-oeb24+oeb25) > 0",                                                                                     
               "   AND oeb70 = 'N'",                                                                                                 
               "   AND oea01 = '",g_oea1_t.oea01,"'",
               "  ORDER BY oea03"                                                                                                    
   PREPARE oea_pre FROM g_sql                                                                                                        
   DECLARE oea_cur2 CURSOR FOR oea_pre
   FOREACH oea_cur2 INTO  g_oea.* 
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
  END IF   
         
  
END FUNCTION
 
FUNCTION p201_chk_oea3(p_type)                                                                                                       
   DEFINE p_type         LIKE type_file.chr1  #1:出貨單  2:出通單                                                                    
   DEFINE l_i,l_n,l_cnt  LIKE type_file.num5                                                                                         
   DEFINE l_occ56        LIKE occ_file.occ56   #TQC-780007                                                                           
   LET l_n=0
                                                                                                                                    
   #要是"已確認"且"已核准"的資料
   IF NOT (g_oea1[l_ac1].oeaconf = 'Y' AND g_oea1[l_ac1].oea49 = '1')  THEN                                                          
      CALL s_errmsg('oea01',g_oea1[l_ac1].oea01,'','axm-651',1)
   ELSE
   #CHECK 是否已轉過資料 如果有轉過的就不能再轉
      LET l_cnt = 0
      IF p_type = '1' THEN #出貨單
         SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
          WHERE oga01 = ogb01
            AND ogaconf <> 'X'
            AND ogb31 = g_oea1_t.oea01
            AND oga09 IN ('2','3','4','6')
      ELSE
         SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
          WHERE oga01 = ogb01
            AND ogaconf <> 'X'
            AND ogb31 = g_oea1_t.oea01
            AND oga09 IN ('1','5')
      END IF
      IF l_cnt > 0 THEN
         CALL s_errmsg('oea01',g_oea1[l_ac1].oea01,'','axm-652',1)
      ELSE
         IF p_type = '1' THEN  #判斷客戶如要走出通流程，則不可直接拋出貨單
            SELECT occ56 INTO l_occ56 FROM occ_file
             WHERE occ01 = g_oea1[l_ac1].oea03
            IF l_occ56 = 'Y' THEN   #要走出通流程，不可拋出貨單
               SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
                WHERE oga01 = ogb01
                AND ogaconf <> 'X'
                AND ogb31 = g_oea1_t.oea01
                AND oga09 IN ('1','5')
                IF l_cnt = 0 THEN
                   CALL s_errmsg('oea01',g_oea1[l_ac1].oea01,'','axm-653',1)
                END IF
            ELSE
#           #判斷是否已拋過出通單，如已拋過則不可再拋出貨單
#              SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
#               WHERE oga01 = ogb01
#                 AND ogaconf <> 'X'
#                 AND ogb31 = g_oea1_t.oea01
#                 AND oga09 IN ('1','5')
#              IF l_cnt > 0 THEN
#                 CALL s_errmsg('oea01',g_oea1[l_ac1].oea01,'','axm-654',1)
#              ELSE
                  LET l_n = l_n + 1
#              END IF
            END IF
         ELSE
            LET l_n = l_n + 1
         END IF
      END IF
   END IF
  IF l_n > 0 THEN                                                                                                                   
    RETURN TRUE                                                                                                                     
  ELSE                                                                                                                              
    LET g_success = 'N'
    RETURN FALSE                                                                                                                    
  END IF                                                                                                                            
END FUNCTION
 
FUNCTION p200_ins_oga(p_type)                                                                                                       
   DEFINE p_type    LIKE type_file.chr1   #1:轉出貨單 2:轉出通單
   DEFINE l_oax01   LIKE oax_file.oax01,   #三角貿易使用匯率 S/B/C/D
          l_oaz52   LIKE oaz_file.oaz52,   #內銷使用匯率 B/S/C/D
          l_oaz70   LIKE oaz_file.oaz70,   #外銷使用匯率 B/S/C/D
          li_result LIKE type_file.num5,
          exT       LIKE type_file.chr1,
          l_date1   LIKE type_file.dat,
          l_date2   LIKE type_file.dat
   DEFINE l_ogb03   LIKE type_file.num5
   DEFINE l_oga01   LIKE oga_file.oga01
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_cnt     LIKE type_file.num5
                                     
   #Default初植
      INITIALIZE g_oga.* TO NULL
 
      LET g_oga.oga00  = g_oea.oea00        #類別
      LET g_oga.oga011 = ''                 #出貨通知單號
      IF p_type='1' THEN
         SELECT oga01 INTO l_oga01
           FROM oga_file 
          WHERE oga16=g_oea.oea01 AND oga09='1'
         IF NOT cl_null(l_oga01) THEN
            LET g_oga.oga011=l_oga01
         END IF
      END IF
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
      LET g_oga.oga1016= g_oea.oea1015
      LET g_oga.oga14  = g_oea.oea14        #人員編號
      LET g_oga.oga15  = g_oea.oea15        #部門編號
      LET g_oga.oga16  = g_oea.oea01        #訂單號碼
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
         #LET exT = l_oaz32
         LET exT = l_oax01
      END IF
      CALL s_curr3(g_oga.oga23,g_oga.oga021,exT)
         RETURNING g_oga.oga24
      IF p_type = '1' THEN                 #訂單轉出貨單
         LET g_oga.oga09  = '2'            #單據別:一般出貨單
      ELSE                                 #訂單轉通知單
         LET g_oga.oga09  = '1'            #單據別:出貨通知單 
         LET g_oga.oga1015 = '0'                                                                                                    
      END IF
   LET g_oga.oga02  = g_today            #出貨日期
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
   LET g_oga.ogamksg= 'N'                #簽核
   LET g_oga.oga85  = ' '
   LET g_oga.oga94  = 'N'
   LET g_oga.ogaplant = g_oea.oeaplant
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
                 #g_oea.oea02,g_dbs2)              #FUN-980020 mark
                 g_oea.oea02,g_plant2)             #FUN-980020 
      RETURNING l_date1,l_date2
   IF cl_null(g_oga.oga11) THEN
      LET g_oga.oga11 = l_date1
   END IF
   IF cl_null(g_oga.oga12) THEN
      LET g_oga.oga12 = l_date2
   END IF
                                                                                                                                    
   CALL s_auto_assign_no("axm",tm.slip,g_oga.oga02,"","oga_file","oga01","","","")
     RETURNING li_result,g_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   #FUN-980010 add plant & legal 
   LET g_oga.ogaplant = g_plant 
   LET g_oga.ogalegal = g_legal 
   #FUN-980010 end plant & legal 
 
   LET g_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES(g_oga.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','','',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   LET g_sql = "SELECT * FROM oeb_file WHERE oeb01 = '",g_oea1_t.oea01,"'"
   LET l_ogb03 = 0
   PREPARE p200_prepare1 FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE p200_cs1 CURSOR WITH HOLD FOR p200_prepare1
   FOREACH p200_cs1 INTO g_oeb.*
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
         IF g_oeb.oeb1003 = '2' AND (g_oeb.oeb14 = 0 OR g_oeb.oeb14t = 0) THEN
            CONTINUE FOREACH
         END IF
         LET g_ogb.ogb03  = l_ogb03     #項次
         CALL p200_ins_ogb()
         INITIALIZE g_ogb.* LIKE ogb_file.*   #DEFAULT 設定
         INITIALIZE g_oeb.* LIKE oeb_file.*   #DEFAULT 設定
   END FOREACH
END FUNCTION
                                                                                                                                    
FUNCTION p200_ins_ogb()
   DEFINE l_flag   LIKE type_file.num5,
          l_ima25  LIKE ima_file.ima25
              
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
   LET g_ogb.ogb12  = g_oeb.oeb12     #實際出貨數量
   LET g_ogb.ogb13  = g_oeb.oeb13     #原幣單價
   LET g_ogb.ogb14  = g_oeb.oeb14     #原幣未稅金額
   LET g_ogb.ogb14t = g_oeb.oeb14t    #原幣含稅金額
   LET g_ogb.ogb31  = g_oeb.oeb01     #訂單單號
   LET g_ogb.ogb32  = g_oeb.oeb03     #訂單項次
   LET g_ogb.ogb908 = g_oeb.oeb908    #手冊編號
   LET g_ogb.ogb910 = g_oeb.oeb910
   LET g_ogb.ogb911 = g_oeb.oeb911
   LET g_ogb.ogb912 = g_oeb.oeb912
   LET g_ogb.ogb913 = g_oeb.oeb913
   LET g_ogb.ogb914 = g_oeb.oeb914
   LET g_ogb.ogb915 = g_oeb.oeb915
   LET g_ogb.ogb916 = g_oeb.oeb916
   LET g_ogb.ogb917 = g_oeb.oeb917
   LET g_ogb.ogb19  = g_oeb.oeb906
   LET g_ogb.ogb1007= g_oeb.oeb1007
   LET g_ogb.ogb1008= g_oeb.oeb1008
   LET g_ogb.ogb1009= g_oeb.oeb1009
   LET g_ogb.ogb1010= g_oeb.oeb1010
   LET g_ogb.ogb1011= g_oeb.oeb1011
   LET g_ogb.ogb1012= g_oeb.oeb1012
   LET g_ogb.ogb41 = g_oeb.oeb41
   LET g_ogb.ogb42 = g_oeb.oeb42
   LET g_ogb.ogb43 = g_oeb.oeb43
   LET g_ogb.ogb1001 = g_oeb.oeb1001
   LET g_ogb.ogb17  = 'N'             #多倉儲批出貨否
   LET g_ogb.ogb60  = 0               #已開發票數量
   LET g_ogb.ogb63  = 0               #銷退數量
   LET g_ogb.ogb64  = 0               #銷退數量 (不需換貨出貨)
   LET g_ogb.ogb930 = g_oeb.oeb930
   LET g_ogb.ogb1014   = 'N'          #保稅放行否
   LET g_ogb.ogb44  = ' '
   LET g_ogb.ogb47  = 0
#FUN-AB0061 -----------add start----------------  
   LET g_ogb.ogb37 = g_oeb.oeb37                            
   IF cl_null(g_ogb.ogb37) OR g_ogb.ogb37=0 THEN           
      LET g_ogb.ogb37=g_ogb.ogb13                         
   END IF                                                                             
#FUN-AB0061 -----------add end----------------  
   IF cl_null(g_ogb.ogb091) THEN LET g_ogb.ogb091 = ' ' END IF  #出貨儲位編號
   IF cl_null(g_ogb.ogb092) THEN LET g_ogb.ogb092 = ' ' END IF  #出貨批號
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
   #FUN-980010 add plant & legal 
   LET g_ogb.ogbplant = g_plant 
   LET g_ogb.ogblegal = g_legal 
   #FUN-980010 end plant & legal 
   #FUN-AC0055 mark ---------------------begin-----------------------
   ##FUN-AB0096 ------------add start---------
   #IF cl_null(g_ogb.ogb50) THEN
   #   LET g_ogb.ogb50 = '1'
   #END IF
   ##FUN-AB0096 -----------add end-----------
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
   IF g_aza.aza115 = 'Y' AND g_oga.oga09 ='2' THEN
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
            RETURN
         END IF
      END IF
   END IF
  #TQC-C30113 add START
   IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32)THEN
      IF NOT cl_null(g_ogb.ogb1001) AND g_ogb.ogb1001 = g_oaz.oaz88 THEN
         CALL p201_ins_rxe(g_ogb.ogb01,g_ogb.ogb04,g_ogb.ogb31,g_ogb.ogb03)
      END IF
   END IF
  #TQC-C30113 add END
END FUNCTION
 
FUNCTION p200_upd_oga()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_oea61   LIKE oea_file.oea61    #MOD-BA0040 add
   DEFINE l_oea1008 LIKE oea_file.oea1008  #MOD-BA0040 add
   DEFINE l_oea261  LIKE oea_file.oea261   #MOD-BA0040 add
   DEFINE l_oea262  LIKE oea_file.oea262   #MOD-BA0040 add
   DEFINE l_oea263  LIKE oea_file.oea263   #MOD-BA0040 add

   LET l_i = 0
   SELECT COUNT(DISTINCT ogb31) INTO l_i FROM ogb_file
    WHERE ogb01 = g_oga.oga01
   IF l_i = 1 THEN
      SELECT DISTINCT ogb31 INTO g_oga.oga16 FROM ogb_file
       WHERE ogb01 = g_oga.oga01
   ELSE
      LET g_oga.oga16 = ''
   END IF

   #MOD-BA0040 add --start--
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_oga.oga23
   LET g_oga.oga50 = NULL
        
   SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file WHERE ogb01 = g_oga.oga01
           
   CALL cl_digcut(g_oga.oga50,t_azi04) RETURNING g_oga.oga50 
   IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
           
   SELECT oea61,oea1008,oea261,oea262,oea263
     INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
     FROM oea_file
    WHERE oea01 = g_oga.oga16
   IF g_oga.oga213 = 'Y' THEN
      LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea1008
      LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea1008
   ELSE 
      LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea61
      LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea61
   END IF
   CALL cl_digcut(g_oga.oga52,t_azi04) RETURNING g_oga.oga52  
   CALL cl_digcut(g_oga.oga53,t_azi04) RETURNING g_oga.oga53 
   #MOD-BA0040 add --end--

   UPDATE oga_file SET oga50   = g_oga.oga50,
                       oga51   = g_oga.oga51,
                       oga52   = g_oga.oga52, #MOD-BA0040 add
                       oga53   = g_oga.oga53, #MOD-BA0040 add
                       oga16   = g_oga.oga16,
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
 
FUNCTION t201_exp(p_oea01)
   DEFINE p_oea01  LIKE oea_file.oea01
   DEFINE l_pmk RECORD LIKE pmk_file.*
 
   DEFINE l_pmk01  LIKE pmk_file.pmk01,
          l_oea40  LIKE oea_file.oea40
   DEFINE l_oeb12  LIKE oeb_file.oeb12
   DEFINE l_oeb28  LIKE oeb_file.oeb28
   DEFINE l_oeb24  LIKE oeb_file.oeb24
   DEFINE l_oeb03  LIKE oeb_file.oeb03
   DEFINE l_sql    STRING 
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_cnt1   LIKE type_file.num5
   DEFINE l_slip  LIKE oay_file.oayslip
   DEFINE l_prog_t STRING
   DEFINE l_oea   RECORD LIKE oea_file.*
   DEFINE l_gfa   RECORD LIKE gfa_file.*
   DEFINE p_row,p_col LIKE type_file.num5
   DEFINE li_cnt   LIKE type_file.num5
   DEFINE li_success   STRING
 
   WHENEVER ERROR CONTINUE
   #重新讀取資料
   SELECT * INTO l_oea.* FROM oea_file
    WHERE oea01=p_oea01
   IF cl_null(l_oea.oea01) THEN RETURN END IF
   IF l_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF l_oea.oeaconf = 'N' THEN
      CALL cl_err('','axm-184',0)
      RETURN
   END IF
  #此訂單已拋采購單,就不可以再次拋轉
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM pmn_file,pmm_file
    WHERE pmn24 = l_oea.oea01
      AND pmm01 = pmn01
      AND pmm18 != 'X' #作廢
   IF l_cnt >0  THEN
       CALL cl_err('','axm-581',0)
       RETURN
   END IF
 
   #此訂單已拋請購單,就不可以再次拋轉
   LET l_cnt = 0
   LET l_sql ="SELECT COUNT(*)",
               "  FROM pml_file,oea_file",
               " WHERE oea01 = pml24",
               "   AND oea01 = '",l_oea.oea01,"'"
   PREPARE t400sub_sel_pml FROM l_sql
   EXECUTE t400sub_sel_pml INTO l_cnt
      IF l_cnt >0  THEN
         CALL cl_err('','axm-001',0)
         RETURN
      END IF
   CALL p201_slip('5')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   #訂單數量-己轉請購量>0 才可拋轉
   LET l_oeb12 = 0
   LET l_oeb28 = 0
   LET l_oeb24 = 0
   LET l_sql = "SELECT oeb03,oeb12,oeb28,oeb24 ",
               "  FROM oeb_file ",
               " WHERE oeb01 = '",l_oea.oea01,"'"
 
   PREPARE t400sub_exp_pre FROM l_sql
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_pre',STATUS,1) END IF
   DECLARE t400sub_exp_c CURSOR FOR t400sub_exp_pre
   IF SQLCA.sqlcode THEN CALL cl_err('t400sub_exp_c',STATUS,1) END IF
   LET l_cnt = 1
   #TQC-CA0007 add --start--
   CALL s_auto_assign_no("apm",tm.slip,g_today,"","pmk_file","pmk01","","","")
        RETURNING li_result,l_pmk01
   IF (NOT li_result) THEN
      LET g_success ='N'
      ROLLBACK WORK
      RETURN
   END IF
   #TQC-CA0007 add --end--
   CALL s_showmsg_init()
   FOREACH t400sub_exp_c INTO l_oeb03,l_oeb12,l_oeb28,l_oeb24  #訂單數量/己轉請購量/己交量
      IF g_success = "N" THEN
         LET g_totsuccess = "N"
         LET g_success = "Y"
      END IF
      IF l_oeb12 - l_oeb28 <= 0 THEN                                                                                                 
         CONTINUE FOREACH                                                                                                           
      ELSE                                                                                                                           
         #有出貨紀錄不可再拋請購單                                                                                                   
         IF l_oea.oea62 != 0 THEN
            LET l_cnt1=0
            SELECT COUNT(*) INTO l_cnt1
              FROM ogb_file,oga_file
             WHERE ogb31=l_oea.oea01
               AND ogb32=l_oeb03
               AND ogb01=oga01
               AND ogaconf != 'X'
            IF l_cnt1 >0 THEN
               IF g_bgerr THEN
                  LET g_showmsg = l_oea.oea01,"/",l_oeb03
                  CALL s_errmsg('oea01,oeb03',g_showmsg,'oea01/oeb03','axm-002',1)
               ELSE
                  CALL cl_err('l_oea.oea01/l_oeb03','axm-002',1)
               END IF
               LET li_success = 'N'
               CONTINUE FOREACH
            END IF
         END IF                                                                                                                      
         IF l_cnt = 1 THEN                                                                                                          
           #CALL t400sub_ins_pmk(tm.slip,l_oea.oea84) RETURNING l_pmk01   #TQC-CA0007 mark
           #CALL t400sub_ins_pmk(l_pmk01,l_oea.oea84)                     #TQC-CA0007 add   #FUN-CC0082 Mark
            CALL t400sub_ins_pmk(l_pmk01,l_oea.oea84,l_oea.oea95)                           #FUN-CC0082 Add
            CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)
         ELSE                                                                                                                       
            CALL t400sub_ins_pml_exp(l_pmk01,p_oea01,l_oeb03)
         END IF                                                                                                                     
         LET l_cnt = l_cnt + 1                                                                                                      
      END IF                                                                                                                         
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()
   IF li_success = 'N' OR g_success = 'N' THEN
       CALL cl_err('','axm-558',1)
   ELSE
      CALL t400sub_upd_oea(l_pmk01,l_oea.oea01)
      IF g_success = 'Y' THEN
         COMMIT WORK
         LET l_prog_t = g_prog
         LET g_prog = 'apmt420'
         CALL cl_flow_notify(l_pmk01,'I')
         LET g_prog = l_prog_t
         #MESSAGE "已轉請購單號:",l_pmk01
         CALL cl_err(l_pmk01,'axm-559',1)
      ELSE                                                                                                                             
         ROLLBACK WORK                                                                                                                
         LET l_oea.oea40 = ''                                                                                                         
      END IF                                                                                                                           
   END IF
END FUNCTION
 
FUNCTION p201_slip(p_type)
DEFINE p_type       LIKE type_file.chr1
DEFINE li_result    LIKE type_file.chr1
DEFINE s_date       LIKE type_file.dat
   OPEN WINDOW p201_exp WITH FORM "axm/42f/axmp201a"     
      ATTRIBUTE (STYLE = g_win_style CLIPPED)      
                                                  
   CALL cl_ui_locale("axmp201a")                    
                                             
   DISPLAY BY NAME tm.slip,tm.b_date,tm.e_date,tm.sfb02,tm.open_sw
    INPUT BY NAME tm.sfb02,tm.slip,tm.b_date,tm.e_date,tm.open_sw
              WITHOUT DEFAULTS
      BEFORE INPUT
         LET tm.slip = ' '
         LET tm.b_date = g_today
         LET tm.e_date = g_today
         LET tm.sfb02 = '1'
         LET tm.open_sw = 'N'
         DISPLAY BY NAME tm.slip,tm.b_date,tm.e_date,tm.sfb02,tm.open_sw
         CALL cl_set_comp_visible("b_date,e_date,sfb02,open_sw",FALSE)
         IF p_type='4' THEN
            CALL cl_set_comp_visible("b_date,e_date,sfb02",TRUE)
         END IF
         IF p_type='3' THEN
            CALL cl_set_comp_visible("open_sw",TRUE)
         END IF
      AFTER FIELD slip                               
         IF NOT cl_null(tm.slip) THEN                  
            LET g_cnt = 0                               
            CASE p_type
               WHEN "1"
                  SELECT COUNT(*) INTO g_cnt FROM oay_file    
                   WHERE oayslip = tm.slip AND oaytype = '50'  
               WHEN "2"
                  SELECT COUNT(*) INTO g_cnt FROM oay_file       
                   WHERE oayslip = tm.slip AND oaytype = '40'     
               WHEN "3" 
                  SELECT COUNT(*) INTO g_cnt FROM ooy_file
                   WHERE ooyslip = tm.slip AND ooytype = '12'
               WHEN "4"
                  SELECT COUNT(*) INTO g_cnt FROM smy_file 
                   WHERE smyslip = tm.slip AND smysys = 'asf'
                     AND smykind = tm.sfb02
               WHEN "5"
                  SELECT COUNT(*) INTO g_cnt FROM smy_file                                                                             
                   WHERE smyslip = tm.slip AND smysys = 'apm' 
                     AND smykind = '1'
               WHEN "6"
                  SELECT COUNT(*) INTO g_cnt FROM smy_file
                   WHERE smyslip = tm.slip AND smysys = 'apm' 
                     AND smykind = '2'
            END CASE
            IF SQLCA.sqlcode OR cl_null(tm.slip) OR (NOT li_result) THEN
               LET g_cnt = 0     
            END IF
            IF g_cnt = 0 THEN                                        
               CALL cl_err(tm.slip,'aap-010',0)                       
               NEXT FIELD slip                                         
            END IF                                                      
            CASE p_type
               WHEN "1"
                  CALL s_check_no("axm",tm.slip,"",'50',"oga_file","oga01","")
                  RETURNING li_result,tm.slip                               
               WHEN "2"
                  CALL s_check_no("axm",tm.slip,"",'40',"oga_file","oga01","")
                  RETURNING li_result,tm.slip   
               WHEN "3"
                  CALL s_check_no("axr",tm.slip,"",'12',"oma_file","oma01","")
                  RETURNING li_result,tm.slip
            END CASE
            DISPLAY BY NAME tm.slip   
         END IF              
         AFTER FIELD b_date
            IF tm.b_date IS NULL OR (tm.b_date < g_today) THEN
               CALL cl_err('','asf-372','1')
               NEXT FIELD b_date
            END IF
  
         AFTER FIELD e_date
            IF tm.e_date IS NULL OR (tm.e_date < g_today) THEN
               CALL cl_err('','asf-373','1')
               NEXT FIELD e_date
            END IF
            IF tm.e_date < tm.b_date THEN
               CALL cl_err('','asf-310','1')
               NEXT FIELD e_date
            END IF
                           
         IF INT_FLAG THEN      
            CLOSE WINDOW p201_exp 
            RETURN       
         END IF           
                                                                                
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)                       
               CASE p_type                              
                  WHEN "1"  #出貨單                       
                     CALL q_oay(FALSE,FALSE,'','50','AXM')
                     RETURNING tm.slip                  
                  WHEN "2"  #出通單                          
                     CALL q_oay(FALSE,FALSE,'','40','AXM')   
                     RETURNING tm.slip   
                  WHEN "3"
                     CALL q_ooy(FALSE,FALSE,'','12','AXR')
                     RETURNING tm.slip                                                  
                  WHEN "4"
                     CALL q_smy(FALSE,FALSE,tm.slip,'ASF','1')
                     RETURNING tm.slip
                  WHEN "5"  #請購單
                     CALL q_smy(FALSE,TRUE,tm.slip,'APM','1') 
                     RETURNING tm.slip                                                        
                  WHEN "6"  #采購單
                     CALL q_smy(FALSE,TRUE,tm.slip,'APM','2')
                     RETURNING tm.slip
 
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
      CLOSE WINDOW p201_exp
      RETURN              
   END IF                  
   CLOSE WINDOW p201_exp
END FUNCTION
 
FUNCTION t201sub_exp_po(p_oea01)
  DEFINE p_oea01  LIKE oea_file.oea01
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmm01  LIKE pmm_file.pmm01,
         l_oea40  LIKE oea_file.oea40
  DEFINE l_oeb01  LIKE oeb_file.oeb01
  DEFINE l_oeb03  LIKE oeb_file.oeb03
  DEFINE l_oeb12  LIKE oeb_file.oeb12
  DEFINE l_oeb28  LIKE oeb_file.oeb28
  DEFINE l_sql    LIKE type_file.chr1000 
  DEFINE l_cnt    LIKE type_file.num5
  DEFINE li_cnt   LIKE type_file.num5
  DEFINE l_ima54  LIKE ima_file.ima54
  DEFINE l_pmm01_conf DYNAMIC ARRAY OF  LIKE pmm_file.pmm01
  DEFINE l_i,l_n      LIKE type_file.num5
  DEFINE l_gfa   RECORD LIKE gfa_file.*
  DEFINE l_oea   RECORD LIKE oea_file.*
  DEFINE l_slip  LIKE oay_file.oayslip
  DEFINE p_row,p_col LIKE type_file.num5
  DEFINE l_prog_t LIKE type_file.chr1000
                                                                                                                                    
  WHENEVER ERROR CONTINUE                #忽略一切錯誤
                                                                                                                                    
  #重新讀取資料
  SELECT * INTO l_oea.* FROM oea_file
   WHERE oea01=p_oea01
  IF cl_null(l_oea.oea01) THEN RETURN END IF                                                                                       
 
  IF l_oea.oeaconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
  IF l_oea.oea62 != 0 THEN CALL cl_err('','axm-582',0) RETURN END IF
  IF l_oea.oeaconf = 'N' THEN
     CALL cl_err('','axm-184',0)
     RETURN
  END IF
# #此訂單已拋請購單,就不可以再次拋轉
#  LET li_cnt = 0
#  SELECT COUNT(*) INTO li_cnt
#    FROM pmk_file,oea_file
#   WHERE oea01 = l_oea.oea01
#     AND pmk01 = oea40
#     AND pmk18 != 'X' #作廢
#  IF li_cnt >0  THEN
#      CALL cl_err('','axm-001',0)
#      RETURN
#  END IF
   LET li_cnt = 0
  #檢查是否都有設定主供應商
   SELECT COUNT(*) INTO li_cnt
     FROM oeb_file,ima_file
    WHERE ima01 = oeb04
      AND (ima54 IS NULL OR ima54 = '')
      AND oeb01 = l_oea.oea01
   IF li_cnt > 0 THEN
      CALL cl_err('','apm-571',0)
      RETURN
   END IF
   #此訂單已拋采購單,就不可以再次拋轉
   LET l_cnt = 0
   LET l_sql ="SELECT COUNT(*)",
              "  FROM pmn_file,oeb_file",
              " WHERE oeb01 = pmn24",
              "   AND oeb03 = pmn25",
              "   AND oeb01 = '",l_oea.oea01,"'"
   PREPARE t400sub_sel_pmn FROM l_sql
   EXECUTE t400sub_sel_pmn INTO l_cnt
   IF l_cnt >0  THEN
      CALL cl_err('','axm-581',0)
      RETURN
   END IF
   CALL p201_slip('6')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_totsuccess = "N"
      RETURN
   END IF
 
   LET g_success = 'Y'
   LET l_oeb12 = 0
   LET l_oeb28 = 0
   LET l_i = 0
   LET l_sql = "SELECT DISTINCT ima54 FROM ima_file,oeb_file ",
               " WHERE ima01 = oeb04 ",
               "   AND oeb01 = '",l_oea.oea01 CLIPPED,"'"
   PREPARE ima_pre  FROM l_sql
   DECLARE ima_cur CURSOR FOR ima_pre
   CALL s_showmsg_init()
   FOREACH ima_cur INTO l_ima54
      IF g_success = "N" THEN
         LET g_totsuccess = "N"
         LET g_success = "Y"
      END IF
      CALL t400sub_ins_pmm(tm.slip,l_ima54,l_oea.*) RETURNING l_pmm01
      IF g_success = 'Y' THEN
         CALL t400sub_ins_pmn_exp(l_pmm01,l_ima54,l_oea.*,' 1=1')
         IF g_success = 'N' THEN  EXIT FOREACH  END IF
      ELSE
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET l_prog_t = g_prog
      LET g_prog = 'apmt540'
      CALL cl_flow_notify(l_pmm01,'I')
      LET g_prog = l_prog_t
      CALL cl_err(l_pmm01,'axm-560',1)
   ELSE
      ROLLBACK WORK
   END IF
                                                                                                                                    
END FUNCTION
 
FUNCTION p201_dis_sfb()
   DEFINE l_oea00       LIKE oea_file.oea00
   DEFINE l_gem02c      LIKE gem_file.gem02
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_cntostcenter  LIKE gem_file.gem01
   DEFINE l_oea         RECORD LIKE oea_file.*
   DEFINE l_cntmd         LIKE type_file.chr1000
   DEFINE l_slip        LIKE sfb_file.sfb01
   DEFINE l_za05        LIKE type_file.chr1000
   DEFINE l_sfb         RECORD LIKE sfb_file.*
   DEFINE l_sfc         RECORD LIKE sfc_file.*
   DEFINE l_sfd         RECORD LIKE sfd_file.*
   DEFINE l_minopseq    LIKE ecb_file.ecb03
   DEFINE new_part      LIKE ima_file.ima01
   DEFINE i,j           LIKE type_file.num10
   DEFINE ask           LIKE type_file.num5
   DEFINE s_date        LIKE type_file.num5
   DEFINE l_time        LIKE ima_file.ima58
   DEFINE l_item        LIKE ima_file.ima01
   DEFINE l_smy57       LIKE smy_file.smy57
   DEFINE l_ima910      LIKE ima_file.ima910
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   l_max_no    LIKE sfb_file.sfb01
   DEFINE   l_min_no    LIKE sfb_file.sfb01
   DEFINE l_sfb08       LIKE sfb_file.sfb08
   DEFINE l_qty         LIKE oeb_file.oeb12
   DEFINE l_ima55_fac   LIKE ima_file.ima55_fac
   DEFINE l_check       LIKE type_file.num5
   DEFINE l_cn          LIKE type_file.num5
   DEFINE l_ima59       LIKE ima_file.ima59
   DEFINE l_ima61       LIKE ima_file.ima61                                                                                         
   DEFINE l_oeb15       LIKE oeb_file.oeb15
   DEFINE l_btflg       LIKE type_file.chr1
   DEFINE l_proc        LIKE type_file.chr1
   DEFINE l_sfbi        RECORD LIKE sfbi_file.*
   DEFINE l_flag        LIKE type_file.chr1
   LET l_flag='Y'
   LET l_ima59=0
   LET l_ima60=0
   LET l_ima61=0
   INITIALIZE l_sfb.* TO NULL
   SELECT COUNT(*) INTO l_cnt FROM sfb_file
    WHERE sfb22 = g_oea1_t.oea01
   IF l_cnt>0 THEN
      CALL cl_err('','axm-583',0)
      RETURN
   END IF
   
 
   INITIALIZE l_sfb.* TO NULL
   LET l_cntostcenter=s_costcenter(g_grup)
   LET l_gem02c=s_costcenter_desc(l_cntostcenter)
   LET l_sfb.sfb81 = g_today
   CALL p201_slip('4')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   IF s_industry('slk') THEN
      LET g_sql = "SELECT oeb01,oeb03,oeb04,ima02,ima910,oeb12-oeb905,0,oeb15, ",
                  " '1',ima111,' ','Y',oeb930,'',oeb05,ima55,((100+ima562)/100),ima60,ima601 ",
                  "  FROM oeb_file,ima_file,oebi_file,oea_file ",
                  " WHERE oeb01 = oebi01 ",
                  "   AND oeb03 = oebi03 ",
                  "   AND oeb12>(oeb24-oeb25+oeb905) ",
                  "   AND oeb01 = oea01 ",
                  "   AND  oea61>(oea62+oea63)",
                  "   AND oeb04 = ima01 ",
                  "   AND ima911<>'Y' ",
                  "   AND oea01 = '",g_oea1[l_ac1].oea01,"'",
   #              "   AND oebi03 = '",l_oeb.oeb03,"'",
                  "   AND NOT EXISTS(SELECT * from sfb_file where sfb22= oeb01 and sfb221 =oeb03)"
   ELSE
      LET g_sql = "SELECT oeb01,oeb03,oeb04,ima02,ima910,oeb12-oeb905,0,oeb15, ",
                  " '1',ima111,' ','Y',oeb930,'',oeb05,ima55,((100+ima562)/100),ima60,ima601 ",
                  " FROM oeb_file,ima_file,oea_file ",
                  " WHERE oea01 = '",g_oea1[l_ac1].oea01,"'",
                  "  AND oeb12>(oeb24-oeb25+oeb905) ",
                  "  AND oeb04 = ima01 ",
                  "  AND oeb01 = oea01 ",
                  "  AND  oea61>(oea62+oea63)",
                  "  AND ima911<>'Y' "
   END IF
   PREPARE q_oeb_prepare FROM g_sql
   DECLARE oeb_curs1 CURSOR FOR q_oeb_prepare
   CALL s_showmsg_init()
   BEGIN WORK   #MOD-A20107
   FOREACH oeb_curs1 INTO new.*,l_oeb05,l_ima55,l_ima562,l_ima60,l_ima601
      IF STATUS THEN
         EXIT FOREACH
      END IF
      LET l_sfb08 = 0
      IF s_industry('std') THEN
         LET l_oea.oea01 = new.oeb01
         LET l_oea00 = NULL
         SELECT oea00 INTO l_oea00 FROM oea_file
          WHERE oea01 = l_oea.oea01
         IF l_oea00 = '4' THEN
            CALL s_errmsg('oea00',l_oea.oea01,'sel oea00','axm-155',1)
            CONTINUE FOREACH
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM oea_file
          WHERE oea01 = l_oea.oea01
            AND oeaconf = 'Y'
         IF l_cnt <=0 THEN
            CALL s_errmsg('oea01',l_oea.oea01,'','asf-959',1)
            CONTINUE FOREACH
         ELSE
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt
              FROM oea_file
             WHERE oea61>(oea62+oea63)
               AND oea00 <> '4'
               AND oeaconf = 'Y'
               AND oea01 = l_oea.oea01
            IF l_cnt=0 THEN
               CALL s_errmsg('',l_oea.oea01,'','asf-005',1)
               CONTINUE FOREACH
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt  FROM oeb_file
             WHERE oeb01 = l_oea.oea01
               AND oeb12>(oeb24-oeb25+oeb905)   #oeb905:已備置量
            IF l_cnt <=0 THEN
               CALL s_errmsg('',l_oea.oea01,'','asf-962',1)
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      CALL s_umfchk(new.new_part,l_oeb05,l_ima55)
         RETURNING l_check,l_ima55_fac
      LET new.new_qty = new.new_qty * l_ima55_fac * l_ima562
      IF cl_null(l_ima55_fac) THEN
         LET l_ima55_fac = 1
      END IF
      SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file
       WHERE sfb22  =  l_oea.oea01
         AND sfb221 =  new.oeb03
         AND (sfb04 <> '8' OR (sfb04 = '8' AND sfb08 = sfb09))
         AND sfb87!='X'
      IF l_sfb08 IS NULL THEN
         LET l_sfb08 = 0
      END IF
      IF l_sfb08 >= new.new_qty THEN
         CONTINUE FOREACH
      ELSE
         LET new.new_qty = new.new_qty - l_sfb08
      END IF
 #-計算開工日
      SELECT ima59,ima61 INTO l_ima59,l_ima61 FROM ima_file
       WHERE ima01 = new.new_part
      IF new.e_date IS NULL THEN
         LET new.e_date = 0
      END IF
      LET l_time= (new.new_qty * l_ima60/l_ima601)+ l_ima59 + l_ima61
      IF cl_null(l_time) THEN
         LET l_time=0
      END IF
      LET s_date=l_time+0.5
      IF cl_null(s_date) THEN
         LET s_date=0
      END IF
      LET new.b_date=new.e_date - s_date
 
      #計算開工日時須扣掉非工作日                                                                                      
      SELECT COUNT(*) INTO l_cn FROM sme_file
       WHERE sme01 BETWEEN new.b_date AND new.e_date AND sme02 ='N'
      IF cl_null(l_cn) THEN
         LET l_cn=0
      END IF
      LET new.b_date = new.b_date - l_cn
      IF new.b_date < l_sfb.sfb81 THEN
         LET new.b_date = l_sfb.sfb81
      END IF
      IF new.b_date > new.e_date THEN
         LET new.e_date = new.b_date
      END IF
      LET new.gem02c=l_gem02c
      #BEGIN WORK   #MOD-A20107
      CALL s_auto_assign_no("asf",tm.slip,l_sfb.sfb81,"","","","","","")
      RETURNING li_result,new.new_no
      IF (NOT li_result) THEN
         CALL cl_err('','asf-963','1')
         LET g_success='N'
      END IF
 
      LET l_sfb.sfb01 = new.new_no
      LET l_sfb.sfb02 = new.sfb02
      LET l_sfb.sfb04 = '1'
      LET l_sfb.sfb05 = new.new_part
     #先不給"制程編號"(sfb06)，到後面再根據sfb93判斷要不要給值
      SELECT ima35,ima36,ima571
           INTO l_sfb.sfb30,l_sfb.sfb31,l_item
           FROM ima_file
          WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","ima_file",l_sfb.sfb05,"","aom-198","","",1)
         LET g_success = 'N'
      END IF
 
      LET l_ima910=new.ima910
      IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
      SELECT bma01 FROM bma_file
       WHERE bma01=l_sfb.sfb05
         AND bma05 IS NOT NULL
         AND bma05 <=l_sfb.sfb81
         AND bma06 = l_ima910
         AND bmaacti = 'Y'
      IF STATUS THEN
         CALL cl_err3("sel","bma_file",l_sfb.sfb05,"","mfg5071","","",1)
         LET g_success = 'N'
         #RETURN   #MOD-A20107
      END IF
      #--(1)產生工單檔(sfb_file)---------------------------
      LET l_sfb.sfb071= l_sfb.sfb81
      LET l_sfb.sfb08 = new.new_qty
      LET l_sfb.sfb081= 0
      LET l_sfb.sfb09 = 0
      LET l_sfb.sfb10 = 0
      LET l_sfb.sfb11 = 0
      LET l_sfb.sfb111= 0
      LET l_sfb.sfb121= 0
      LET l_sfb.sfb122= 0
      LET l_sfb.sfb12 = 0
      LET l_sfb.sfb13 = new.b_date
      LET l_sfb.sfb15 = new.e_date
      LET l_sfb.sfb23 = 'Y'
      LET l_sfb.sfb24 = 'N'
      LET l_sfb.sfb251= l_sfb.sfb81
      IF s_industry('slk') THEN
         LET l_sfb.sfb22 = new.oeb01
      ELSE
         LET l_sfb.sfb22 = l_oea.oea01
      END IF
      LET l_sfb.sfb221= new.oeb03
      LET l_sfb.sfb27 = ' '
      LET l_sfb.sfb29 = 'Y'
      LET l_sfb.sfb39 = '1'
      LET l_sfb.sfb81 = l_sfb.sfb81
      LET l_sfb.sfb82 = new.ven_no
      LET l_sfb.sfb85 = ' '
      LET l_sfb.sfb86 = ' '
      LET l_sfb.sfb87 = 'N'
      LET l_sfb.sfb91 = ' '
      LET l_sfb.sfb92 = NULL
      LET l_sfb.sfb87 = 'N'
      LET l_sfb.sfb41 = 'N'
      IF l_sfb.sfb02='11' THEN #拆件式工單=>sfb99='Y'
         LET l_sfb.sfb99 = 'Y'
      ELSE
         LET l_sfb.sfb99 = 'N'
      END IF
      LET l_sfb.sfb17 = NULL
      LET l_sfb.sfb95=l_ima910
      LET l_sfb.sfb98 = new.costcenter
      LET l_sfb.sfbacti = 'Y'
      LET l_sfb.sfbuser = g_user
      LET l_sfb.sfbgrup = g_grup
      LET l_sfb.sfbdate = g_today
      LET l_sfb.sfb1002='N' #保稅核銷否
      LET l_slip = s_get_doc_no(l_sfb.sfb01)
      SELECT smy57 INTO l_smy57 FROM smy_file WHERE smyslip=l_slip
      LET l_sfb.sfb93 = l_smy57[1,1]
      LET l_sfb.sfb94 = l_smy57[2,2]
      IF l_sfb.sfb93='Y' AND (
         l_sfb.sfb02!='7' AND l_sfb.sfb02!='8' AND l_sfb.sfb02!='15') THEN
         SELECT ima94 INTO l_sfb.sfb06 FROM ima_file
          WHERE ima01=l_sfb.sfb05 AND imaacti= 'Y'
      END IF
      #FUN-980010 add plant & legal 
      LET l_sfb.sfbplant = g_plant 
      LET l_sfb.sfblegal = g_legal 
      #FUN-980010 end plant & legal 
      LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
      LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
      LET l_sfb.sfb104 = 'N'          #TQC-A50087 add
      INSERT INTO sfb_file VALUES(l_sfb.*)
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","sfb_file",l_sfb.sfb01,"","asf-738","","",1)
         LET g_success='N'
      END IF
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfbi.* TO NULL
         LET l_sfbi.sfbi01 = l_sfb.sfb01
         IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
            LET g_success='N'
            LET new.new_no = NULL
         END IF
      END IF
      IF l_sfb.sfb93='Y' THEN
         CALL s_schdat(0,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb071,l_sfb.sfb01,
                       l_sfb.sfb06,l_sfb.sfb02,l_item,l_sfb.sfb08,2)
         RETURNING g_cnt,l_sfb.sfb13,l_sfb.sfb15,l_sfb.sfb32,l_sfb.sfb24
      END IF
      IF l_sfb.sfb24 IS NOT NULL THEN
         UPDATE sfb_file
            SET sfb24= l_sfb.sfb24
          WHERE sfb01=l_sfb.sfb01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","",1)
            LET g_success='N'
         END IF
      END IF
      #-->(2)產生備料檔
      LET l_minopseq=0
      CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071) RETURNING l_minopseq
      CASE
         WHEN l_sfb.sfb02='1' OR l_sfb.sfb02='7' #一般工單 or 委外工單 (保留原本asfp304的處理方式)
            LET l_minopseq = 0
#           IF s_industry('slk') AND l_sfb.sfb02='1' AND NOT cl_null(tm.bmb09) THEN
#              CALL s_cralc5(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
#                            l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95,tm.bmb09)
#                   RETURNING g_cnt
#           ELSE
              #CALL s_cralc4(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
               CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',  #FUN-BC0008 mod
                             l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                             new.a,l_sfb.sfb95)
                    RETURNING g_cnt
#           END IF
         WHEN l_sfb.sfb02='13'     #預測工單展至尾階
            CALL s_cralc2(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                          l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
                          ' 1=1',l_sfb.sfb95)
                    RETURNING g_cnt
         WHEN l_sfb.sfb02='15'     #試產性工單
            CALL s_cralc3(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,'Y',
                          l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
                          l_sfb.sfb07,g_sma.sma883,l_sfb.sfb95)
                    RETURNING g_cnt
         OTHERWISE                 #一般工單展單階
            IF l_sfb.sfb02 = 11 THEN
               LET l_btflg = 'N'
            ELSE
               LET l_btflg = 'Y'
            END IF
            CALL s_cralc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,l_btflg,
                        #l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,l_sfb.sfb95)
                         l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',l_sfb.sfb95)  #FUN-BC0008 mod
                    RETURNING g_cnt
      END CASE
      IF g_cnt = 0 THEN
         CALL cl_err('s_cralc error','asf-385',1)
         LET g_success = 'N'
      END IF
      #-----MOD-A20107---------
      #IF g_success='Y' THEN
      #   COMMIT WORK
      #ELSE
      #   ROLLBACK WORK
      #   RETURN
      #END IF
      #-----END MOD-A20107----- 
      #判斷sfb02若為'5，11'時不產生子工單
      IF l_sfb.sfb02 != '5' AND l_sfb.sfb02 != '11' THEN
         LET g_msg="asfp301 '",l_sfb.sfb01,"' '",
                   l_sfb.sfb81,"' '99' 'N'"
         CALL cl_cmdrun_wait(g_msg)
      END IF
      ERROR ""
   END FOREACH
   #-----MOD-A20107---------
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   #-----END MOD-A20107----- 
END FUNCTION 
FUNCTION p201_carry_ar()
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_wc         LIKE type_file.chr1000
DEFINE l_msg        LIKE type_file.chr1000
DEFINE l_oga RECORD LIKE oga_file.*
   SELECT oga_file.* INTO l_oga.* FROM oga_file WHERE oga16=g_oea1_t.oea01
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt 
     FROM oga_file 
    WHERE oga16=g_oea1_t.oea01
   IF l_cnt=0 THEN
      CALL cl_err('','axm-136',0)
      RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt 
     FROM oma_file,oga_file 
    WHERE oga16=g_oea1_t.oea01
      AND oma16=oga01
   IF l_cnt>0 THEN
      CALL cl_err('','axm-137',0)
      RETURN
   END IF
   IF l_oga.oga65='Y' THEN  RETURN END IF
   IF l_oga.oga00 MATCHES '[237]' THEN  RETURN END IF
   IF l_oga.ogapost='N' THEN CALL cl_err('post=N','axm-206',0) RETURN END IF
   CALL p201_slip('3')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   LET l_wc = 'oga01 = "',l_oga.oga01,'"'
   LET l_msg="axrp310 ",
             " ''",
             " '",l_wc CLIPPED,"'",
             " '2'", 
             " '",tm.slip,"'",
             " '",g_today,"'",
             " 'Y'",
             " '",tm.open_sw,"'",
             " '",l_oga.oga02,"'",
             " '",l_oga.oga05,"'",
             " ' '",
             " 'Y'",
             " 'Y'"
   CALL cl_cmdrun_wait(l_msg)
 
END FUNCTION
FUNCTION p201_carry_oga1(p_no1)
   DEFINE p_no1       LIKE oga_file.oga01
   DEFINE l_ogc       RECORD LIKE ogc_file.*   
   DEFINE l_ogb04     LIKE ogb_file.ogb04
   DEFINE l_ogb12     LIKE ogb_file.ogb12     
   DEFINE l_sum_ogb12 LIKE ogb_file.ogb12 
   DEFINE l_sql       STRING                  
   DEFINE l_ogb03     LIKE ogb_file.ogb03
   DEFINE l_ogd13a    LIKE ogd_file.ogd13
   DEFINE l_chr       LIKE type_file.chr1                 #是否產生單頭
   DEFINE l_ogb31     LIKE ogb_file.ogb31
   DEFINE l_ogb32     LIKE ogb_file.ogb32
   DEFINE l_ogb       RECORD LIKE ogb_file.*
   LET g_success = 'Y'
 
  
   LET l_sql = " SELECT ogb04,ogb12,ogb31,ogb32 FROM ogb_file,oga_file ",
               "  WHERE ogb01='",p_no1,"' ",
               "    AND ogb01=oga01 ",
               "    AND oga09='1'   ",
               "    AND ogaconf <> 'X'   "
   
   DECLARE p620_foreach CURSOR FROM l_sql
  #DISPLAY l_sql                        #CHI-A70049 mark
   
   LET l_chr='Y'
   FOREACH p620_foreach INTO l_ogb04,l_ogb12,l_ogb31,l_ogb32
      IF SQLCA.SQLCODE THEN
         CALL cl_err('l_ogb04',SQLCA.SQLCODE,1)
         LET l_chr='N'
         EXIT FOREACH
      ELSE
         SELECT sum(ogb12) INTO l_sum_ogb12 FROM oga_file,ogb_file
          WHERE oga011= g_no1
            AND oga01 = ogb01
            AND ogb04 = l_ogb04
            AND ogaconf <> 'X'
            AND ogb31 = l_ogb31
            AND ogb32 = l_ogb32
         IF cl_null(l_sum_ogb12) THEN
            LET l_sum_ogb12 = 0
         END IF
  
         IF l_sum_ogb12 < l_ogb12 THEN  #出貨單比出單數量少
            LET l_chr='Y'
            EXIT FOREACH                #可再產單頭
         ELSE
            LET l_chr='N'
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
   IF l_chr='N' THEN
      LET g_success='N'
      CALL cl_err('','axm-123',1)
      RETURN
   END IF
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=p_no1
   CALL p201_slip('1')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   BEGIN WORK
   
   CALL s_auto_assign_no("axm",tm.slip,g_oga.oga02,"","oga_file","oga01","","","")
     RETURNING li_result,g_oga.oga01
 
   LET g_oga.oga02 = g_today
   LET g_oga.oga011 = p_no1
   LET g_oga.oga09 = '2'
   LET g_oga.ogaconf = 'N'
   LET g_oga.ogapost = 'N'
   LET g_oga.ogaprsw = 0
   LET g_oga.oga55 = '0'
   LET g_oga.oga57 = '1'          #FUN-AC0055 add
   LET g_oga.ogamksg = g_oay.oayapr
   
   #FUN-980010 add plant & legal 
   LET g_oga.ogaplant = g_plant 
   LET g_oga.ogalegal = g_legal 
   #FUN-980010 end plant & legal 
 
   LET g_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES (g_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
      CALL cl_err3("ins","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","ins oga",1)
      LET g_success='N' 
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL p201_dis_ogb1(p_no1)
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
   CALL p201_delall(g_oga.oga01) #若沒有單身資料,就將單頭資料也刪除
                      #並將出貨通知單上的出貨單號恢復成舊值
                      #加入p620_delall()這段程式會有出貨單號跳號的缺點
 
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN 
   END IF
 
#  若有包裝單抓包裝單數量 , 否則抓出貨通知單數
   DECLARE p620_ogb_curs CURSOR FOR SELECT * FROM ogb_file
                                     WHERE ogb01 = g_no2
   IF STATUS THEN
      CALL cl_err('declare',STATUS,1)
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN 
   END IF
 
   FOREACH p620_ogb_curs INTO l_ogb.*
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)       
         LET g_success = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      SELECT ogb03 INTO l_ogb03 
        FROM  ogb_file
        WHERE ogb01 = p_no1
          AND ogb31 = l_ogb.ogb31
          AND ogb32 = l_ogb.ogb32
      SELECT SUM(ogd13) INTO l_ogd13a FROM ogd_file
       WHERE ogd01 = p_no1            # 通知單號
         AND ogd03 = l_ogb03          # 項次
      IF STATUS = 0 AND NOT cl_null(l_ogd13a) THEN
         UPDATE ogb_file SET ogb16 = g_ogd13
          WHERE ogb01 = g_oga.oga01
            AND ogb03 = l_ogb.ogb03
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
            CALL cl_err3("upd","ogb_file",g_oga.oga02,l_ogb.ogb03,SQLCA.SQLCODE,"","upd ogb_file",1)
            LET g_success='N'
            ROLLBACK WORK
            RETURN         
         END IF
      END IF
   END FOREACH
 
   DROP TABLE x
   SELECT * FROM ogc_file WHERE ogc01 = p_no1 INTO TEMP x
   UPDATE x SET ogc01=g_oga.oga01
   INSERT INTO ogc_file SELECT * FROM x
   
   DROP TABLE x
   SELECT * FROM oao_file WHERE oao01 = p_no1 INTO TEMP x
   UPDATE x SET oao01=g_oga.oga01
   INSERT INTO oao_file SELECT * FROM x
   
   DROP TABLE x
   SELECT * FROM oap_file WHERE oap01 = p_no1 INTO TEMP x
   UPDATE x SET oap01=g_oga.oga01
   INSERT INTO oap_file SELECT * FROM x
   
END FUNCTION
 
FUNCTION p201_delall(p_no2)
DEFINE p_no2       LIKE oga_file.oga01
 
   SELECT COUNT(*) INTO g_cnt
     FROM ogb_file
    WHERE ogb01 = p_no2 #出貨單號
 
   #沒有單身資料,就將單頭資料也刪除
   IF g_cnt <=0 THEN
      DELETE FROM oga_file
       WHERE oga01 = g_no2
      LET g_oga.oga01 = NULL
 
      #轉出貨單不成功,因單身無轉出資料!
      CALL cl_err('','axm-620',1) 
      LET g_success = 'N'
   END IF
   
END FUNCTION
FUNCTION p201_chk_oga()
DEFINE l_oga01       LIKE oga_file.oga01
DEFINE l_ogaconf     LIKE oga_file.ogaconf
   SELECT oga01,ogaconf INTO l_oga01,l_ogaconf
     FROM oga_file 
    WHERE oga16 = g_oea1_t.oea01
      AND oga09 = '1'
   IF NOT cl_null(l_oga01) THEN
      IF l_ogaconf<>'Y' THEN
         CALL cl_err(l_oga01,'axm-642',0)
         LET l_oga01 = ''
         RETURN l_oga01 
      END IF
   END IF
   RETURN l_oga01
END FUNCTION
FUNCTION p201_dis_ogb1(p_no1)
DEFINE p_no1        LIKE oga_file.oga01
DEFINE g_a_ogb912   LIKE ogb_file.ogb912
DEFINE g_a_ogb915   LIKE ogb_file.ogb915
DEFINE g_n_ogb912   LIKE ogb_file.ogb912
DEFINE g_n_ogb915   LIKE ogb_file.ogb915
 
   DECLARE s_g_ogb1_c CURSOR FOR
       SELECT * FROM ogb_file WHERE ogb01=p_no1 ORDER BY ogb03
 
 
   FOREACH s_g_ogb1_c INTO g_ogb.*
      SELECT SUM(ogb912),SUM(ogb915) 
        INTO g_a_ogb912,g_a_ogb915          #已轉數量
        FROM oga_file, ogb_file
       WHERE oga01    = ogb01
         AND oga011   = p_no        #出貨通知單
         AND ogb31    = g_ogb.ogb31
         AND ogb32    = g_ogb.ogb32
         AND ogb04    = g_ogb.ogb04 #產品編號
         AND ogaconf != 'X'
         AND ogb09    = g_ogb.ogb09
         AND ogb091   = g_ogb.ogb091
         AND ogb092   = g_ogb.ogb092
#     IF cl_null(g_a_ogb912) THEN LET g_a_ogb912 = 0 END IF
#     IF cl_null(g_a_ogb915) THEN LET g_a_ogb915 = 0 END IF
#     IF cl_null(g_ogb.ogb912) THEN LET g_ogb.ogb912 = 0 END IF
#     IF cl_null(g_ogb.ogb915) THEN LET g_ogb.ogb915 = 0 END IF
#     #未轉數量
#     LET g_n_ogb912 = g_ogb.ogb912 - g_a_ogb912
#     LET g_n_ogb915 = g_ogb.ogb915 - g_a_ogb915
#     IF g_n_ogb912 = 0 AND g_n_ogb915 = 0 THEN 
#         #此出貨通知單的所有料件早已轉成出貨單,異動更新不成功!
#         CONTINUE FOREACH 
#     END IF
 
 
      LET g_success='Y' #代表此出貨通知單尚有料件未轉成出貨單! 
      LET g_errno=''
      
      LET g_ogb.ogb01 = g_oga.oga01
#FUN-AB0061 -----------add start----------------                             
      IF cl_null(g_ogb.ogb37) OR g_ogb.ogb37=0 THEN           
         LET g_ogb.ogb37=g_ogb.ogb13                         
      END IF                                                                             
#FUN-AB0061 -----------add end----------------   
      #FUN-980010 add plant & legal 
      LET g_ogb.ogbplant = g_plant 
      LET g_ogb.ogblegal = g_legal 
      #FUN-980010 end plant & legal 
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
      IF g_aza.aza115 = 'Y' THEN
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
         CALL s_errmsg('','','',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
 
      IF g_success='N' THEN EXIT FOREACH END IF
 
   END FOREACH
  #TQC-C30113 add START
   IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32)THEN
      IF NOT cl_null(g_ogb.ogb1001) AND g_ogb.ogb1001 = g_oaz.oaz88 THEN
         CALL p201_ins_rxe(g_ogb.ogb01,g_ogb.ogb04,g_ogb.ogb31,g_ogb.ogb03)
      END IF
   END IF
  #TQC-C30113 add END
   IF NOT cl_null(g_errno) THEN 
       IF g_bgerr THEN
          CALL s_errmsg('','',p_no1,g_errno,1)
       ELSE
          CALL cl_err(p_no1,g_errno,1)
       END IF
   END IF
END FUNCTION
FUNCTION p201_chk_oea()
DEFINE l_cnt LIKE type_file.num5
   SELECT COUNT(*) INTO l_cnt
     FROM sfb_file
    WHERE sfb22=g_oea1_t.oea01
   IF l_cnt>0 THEN
      CALL cl_err(g_oea1_t.oea01,'axm-643',1)
      LET g_flag='N'
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt
     FROM pmk_file,pml_file
    WHERE pml24 = g_oea1_t.oea01
      AND pmk01 = pml01
   IF l_cnt>0 THEN
      CALL cl_err(g_oea1_t.oea01,'axm-644',1)
      LET g_flag='N'
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt
     FROM pmn_file,pmm_file
    WHERE pmn24 = g_oea1_t.oea01
      AND pmn01 = pmm01
   IF l_cnt>0 THEN
      CALL cl_err(g_oea1_t.oea01,'axm-645',1)
      LET g_flag='N'
      RETURN
   END IF
  
END FUNCTION
FUNCTION p201_chk_oea1()
DEFINE l_cnt LIKE type_file.num5
   SELECT COUNT(*) INTO l_cnt
     FROM oga_file
    WHERE oga16=g_oea1_t.oea01
   IF l_cnt>0 THEN
      CALL cl_err(g_oea1_t.oea01,'axm-646',1)
      LET g_flag='N'
   END IF
END FUNCTION
FUNCTION p201_chk_oea2()
DEFINE l_cnt LIKE type_file.num5
   SELECT COUNT(*) INTO l_cnt
     FROM pml_file,pmk_file
    WHERE pml24 = g_oea1_t.oea01
      AND pml01 = pmk01
   IF l_cnt>0 THEN
      CALL cl_err(g_oea1_t.oea01,'axm-647',1)
      LET g_flag='N'
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt
     FROM pmn_file,pmm_file
    WHERE pmn24 = g_oea1_t.oea01
      AND pmm01 = pmn01
   IF l_cnt>0 THEN
      CALL cl_err(g_oea1_t.oea01,'axm-647',1)
      LET g_flag='N'
      RETURN
   END IF
END FUNCTION 
 
#No.FUN-960071
#TQC-C30113 add START
FUNCTION p201_ins_rxe(p_ogb01,p_ogb04,p_ogb31,p_ogb03)
DEFINE l_n              LIKE type_file.num10
DEFINE p_ogb01          LIKE ogb_file.ogb01  #單號
DEFINE p_ogb04          LIKE ogb_file.ogb04  #產品編號
DEFINE p_ogb31          LIKE ogb_file.ogb31  #訂單單號
DEFINE p_ogb03          LIKE ogb_file.ogb03  #項次
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
