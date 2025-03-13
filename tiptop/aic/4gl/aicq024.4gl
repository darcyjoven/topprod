# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aicq024.4gl
# Descriptions...:
# Date & Author..: 08/01/14 By hellen No.FUN-7B0018
#                  1.主要數量:等同aimq841的取得方式
#                  2.參考數量:換算每一個主要單位和參考單位之比率,
#                             再乘上供需數量
#                    受訂量: (oeb915/oeb12) *受訂量         bcs1
#                    在製量: (sfbiicd06/ sfb08) *在製量     bcs2
#                    請購量: (pml83/pml20) *請購量          bcs3
#                    採購量: (pmn85/pmn20 ) *採購量         bcs4
#                    IQC在驗量: sum(qcs35/qcs06) * IQC      bcs5/bcs5_r
#                    FQC在驗量: sum(qcf35/ qcf06 ) * FQC    bcs51/bcs51_r
#                    備料量: (sfaiicd01/sfa05) * 備料量     bcs6
#                    訂單備置: (oeb915/oeb12)* 訂單備置
#Modify..........: No.FUN-830076 08/03/21 by hellen 新增“相關文件”ACTION
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-9B0164 09/11/19 By sherry 修改sql寫法
# Modify.........: No.FUN-A20044 10/03/22 By vealxu ima26x 調整
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm           RECORD
          ima01        LIKE ima_file.ima01,
          bom          LIKE type_file.chr1
                       END RECORD
   DEFINE g_sw         LIKE type_file.chr1
   DEFINE g_wc         STRING
   DEFINE g_wc2        STRING                             #WHERE CONDICTION
   DEFINE g_sql        STRING
   DEFINE g_rec_b,g_i  LIKE type_file.num5
   DEFINE g_ima        RECORD
                       ima01      LIKE ima_file.ima01,    #料號
                       ima02      LIKE ima_file.ima02,    #品名
                       ima021     LIKE ima_file.ima021,   #品名
                       ima25      LIKE ima_file.ima25,    #單位
#                       ima262     LIKE ima_file.ima262,   #庫存量             #FUN-A20044
#                       ima26      LIKE ima_file.ima26,    #MRP可用庫存量      #FUN-A20044
                       avl_stk        LIKE type_file.num15_3,                  #FUN-A20044
                       avl_stk_mpsmrp LIKE type_file.num15_3,                  #FUN-A20044
                       ima907     LIKE ima_file.ima907,   #第二單位
                       qty_1      LIKE sfb_file.sfb08,    #受訂量
                       qty_2      LIKE sfb_file.sfb08,    #在製量
                       qty_3      LIKE sfb_file.sfb08,    #請購量
                       qty_4      LIKE sfb_file.sfb08,    #採購量
                       qty_5      LIKE sfb_file.sfb08,    #IQC在驗量
                       qty_51     LIKE sfb_file.sfb08,    #FQC在驗量
                       qty_6      LIKE sfb_file.sfb08,    #備料量
                       qty_7      LIKE sfb_file.sfb08,    #訂單備置量
                       #-------------(參考單位)---------------#
#                       ima262_r   LIKE ima_file.ima262,   #庫存量          #FUN-A20044
#                       ima26_r    LIKE ima_file.ima26,    #MRP可用庫存量   #FUN-A20044
                       avl_stk_r  LIKE type_file.num15_3,                   #FUN-A20044
                       avl_stk_mpsmrp_r LIKE type_file.num15_3,             #FUN-A20044
                       qty_1_r    LIKE sfb_file.sfb08,    #受訂量
                       qty_2_r    LIKE sfb_file.sfb08,    #在製量
                       qty_3_r    LIKE sfb_file.sfb08,    #請購量
                       qty_4_r    LIKE sfb_file.sfb08,    #採購量
                       qty_5_r    LIKE sfb_file.sfb08,    #IQC在驗量
                       qty_51_r   LIKE sfb_file.sfb08,    #FQC在驗量
                       qty_6_r    LIKE sfb_file.sfb08,    #備料量
                       qty_7_r    LIKE sfb_file.sfb08     #訂單備置量
                       END RECORD
   DEFINE g_sr         DYNAMIC ARRAY OF RECORD
                       ds_date    LIKE type_file.dat,
                       ds_class   LIKE type_file.chr20,
                       ds_no      LIKE type_file.chr20,
                       ds_cust    LIKE pmm_file.pmm09,
                       ds_qlty    LIKE rpc_file.rpc13,
                       ds_total   LIKE rpc_file.rpc13
                       END RECORD
   DEFINE g_wafer      RECORD                             #(Wafer)
#                       w_ima26    LIKE ima_file.ima26,    #庫存可用量     #FUN-A20044
#                       w_ima262   LIKE ima_file.ima262,   #MRP可用量      #FUN-A20044
                       w_avl_stk_mpsmrp LIKE type_file.num15_3,            #FUN-A20044
                       w_avl_stk        LIKE type_file.num15_3,            #FUN-A20044  
                       w_qty_1    LIKE sfb_file.sfb08,    #受訂量
                       w_qty_2    LIKE sfb_file.sfb08,    #在製量
                       w_qty_3    LIKE sfb_file.sfb08,    #請購量
                       w_qty_4    LIKE sfb_file.sfb08,    #採購量
                       w_qty_5    LIKE sfb_file.sfb08,    #IQC在驗量
                       w_qty_51   LIKE sfb_file.sfb08,    #FQC在驗量
                       w_qty_6    LIKE sfb_file.sfb08,    #備料量
                       w_qty_7    LIKE sfb_file.sfb08,    #訂單備置量
                       #-------------(參考單位)---------------#
#                       w_ima262_r LIKE ima_file.ima262,   #庫存量         #FUN-A20044
#                       w_ima26_r  LIKE ima_file.ima26,    #MRP可用庫存量  #FUN-A20044
                       w_avl_stk_r LIKE type_file.num15_3,                 #FUN-A20044
                       w_avl_stk_mpsmrp_r LIKE type_file.num15_3,          #FUN-A20044
                       w_qty_1_r  LIKE sfb_file.sfb08,    #受訂量
                       w_qty_2_r  LIKE sfb_file.sfb08,    #在製量
                       w_qty_3_r  LIKE sfb_file.sfb08,    #請購量
                       w_qty_4_r  LIKE sfb_file.sfb08,    #採購量
                       w_qty_5_r  LIKE sfb_file.sfb08,    #IQC在驗量
                       w_qty_51_r LIKE sfb_file.sfb08,    #FQC在驗量
                       w_qty_6_r  LIKE sfb_file.sfb08,    #備料量
                       w_qty_7_r  LIKE sfb_file.sfb08     #訂單備置量
                       END RECORD
   DEFINE g_cp         RECORD                             #(CP)
#                       c_ima26    LIKE ima_file.ima26,    #庫存可用量    #FUN-A20044
#                       c_ima262   LIKE ima_file.ima262,   #MRP可用量     #FUN-A20044
                       c_avl_stk  LIKE type_file.num15_3,                 #FUN-A20044
                       c_avl_stk_mpsmrp LIKE type_file.num15_3,           #FUN-A20044
                       c_qty_1    LIKE sfb_file.sfb08,    #受訂量
                       c_qty_2    LIKE sfb_file.sfb08,    #在製量
                       c_qty_3    LIKE sfb_file.sfb08,    #請購量
                       c_qty_4    LIKE sfb_file.sfb08,    #採購量
                       c_qty_5    LIKE sfb_file.sfb08,    #IQC在驗量
                       c_qty_51   LIKE sfb_file.sfb08,    #FQC在驗量
                       c_qty_6    LIKE sfb_file.sfb08,    #備料量
                       c_qty_7    LIKE sfb_file.sfb08,    #訂單備置量
                       #-------------(參考單位)---------------#
#                       c_ima262_r LIKE ima_file.ima262,   #庫存量          #FUN-A20044
#                       c_ima26_r  LIKE ima_file.ima26,    #MRP可用庫存量   #FUN-A20044
                       c_avl_stk_r LIKE type_file.num15_3,                  #FUN-A20044
                       c_avl_stk_mpsmrp_r LIKE type_file.num15_3,           #FUN-A20044
                       c_qty_1_r  LIKE sfb_file.sfb08,    #受訂量
                       c_qty_2_r  LIKE sfb_file.sfb08,    #在製量
                       c_qty_3_r  LIKE sfb_file.sfb08,    #請購量
                       c_qty_4_r  LIKE sfb_file.sfb08,    #採購量
                       c_qty_5_r  LIKE sfb_file.sfb08,    #IQC在驗量
                       c_qty_51_r LIKE sfb_file.sfb08,    #FQC在驗量
                       c_qty_6_r  LIKE sfb_file.sfb08,    #備料量
                       c_qty_7_r  LIKE sfb_file.sfb08     #訂單備置量
                       END RECORD
   DEFINE g_ds         RECORD                             #(DS)
#                       d_ima26    LIKE ima_file.ima26,    #庫存可用量      #FUN-A20044
#                       d_ima262   LIKE ima_file.ima262,   #MRP可用量       #FUN-A20044
                       d_avl_stk   LIKE type_file.num15_3,                  #FUN-A20044
                       d_avl_stk_mpsmrp  LIKE type_file.num15_3,            #FUN-A20044
                       d_qty_1    LIKE sfb_file.sfb08,    #受訂量
                       d_qty_2    LIKE sfb_file.sfb08,    #在製量
                       d_qty_3    LIKE sfb_file.sfb08,    #請購量
                       d_qty_4    LIKE sfb_file.sfb08,    #採購量
                       d_qty_5    LIKE sfb_file.sfb08,    #IQC在驗量
                       d_qty_51   LIKE sfb_file.sfb08,    #FQC在驗量
                       d_qty_6    LIKE sfb_file.sfb08,    #備料量
                       d_qty_7    LIKE sfb_file.sfb08,    #訂單備置量
                       #-------------(參考單位)---------------#
#                       d_ima262_r LIKE ima_file.ima262,   #庫存量             #FUN-A20044
#                       d_ima26_r  LIKE ima_file.ima26,    #MRP可用庫存量      #FUN-A20044
                       d_avl_stk_r LIKE type_file.num15_3,                     #FUN-A20044
                       d_avl_stk_mpsmrp_r  LIKE type_file.num15_3,             #FUN-A20044
                       d_qty_1_r  LIKE sfb_file.sfb08,    #受訂量
                       d_qty_2_r  LIKE sfb_file.sfb08,    #在製量
                       d_qty_3_r  LIKE sfb_file.sfb08,    #請購量
                       d_qty_4_r  LIKE sfb_file.sfb08,    #採購量
                       d_qty_5_r  LIKE sfb_file.sfb08,    #IQC在驗量
                       d_qty_51_r LIKE sfb_file.sfb08,    #FQC在驗量
                       d_qty_6_r  LIKE sfb_file.sfb08,    #備料量
                       d_qty_7_r  LIKE sfb_file.sfb08     #訂單備置量
                       END RECORD
   DEFINE g_ass        RECORD                             #(ASS)
#                       a_ima26    LIKE ima_file.ima26,    #庫存可用量     #FUN-A20044
#                       a_ima262   LIKE ima_file.ima262,   #MRP可用量      #FUN-A20044
                       a_avl_stk  LIKE type_file.num15_3,                  #FUN-A20044
                       a_avl_stk_mpsmrp  LIKE type_file.num15_3,           #FUN-A20044
                       a_qty_1    LIKE sfb_file.sfb08,    #受訂量
                       a_qty_2    LIKE sfb_file.sfb08,    #在製量
                       a_qty_3    LIKE sfb_file.sfb08,    #請購量
                       a_qty_4    LIKE sfb_file.sfb08,    #採購量
                       a_qty_5    LIKE sfb_file.sfb08,    #IQC在驗量
                       a_qty_51   LIKE sfb_file.sfb08,    #FQC在驗量
                       a_qty_6    LIKE sfb_file.sfb08,    #備料量
                       a_qty_7    LIKE sfb_file.sfb08,    #訂單備置量
                       #-------------(參考單位)---------------#
#                       a_ima262_r LIKE ima_file.ima262,   #庫存量           #FUN-A20044
#                       a_ima26_r  LIKE ima_file.ima26,    #MRP可用庫存量    #FUN-A20044
                       a_avl_stk_r  LIKE type_file.num15_3,                  #FUN-A20044
                       a_avl_stk_mpsmrp_r  LIKE type_file.num15_3,           #FUN-A20044
                       a_qty_1_r  LIKE sfb_file.sfb08,    #受訂量
                       a_qty_2_r  LIKE sfb_file.sfb08,    #在製量
                       a_qty_3_r  LIKE sfb_file.sfb08,    #請購量
                       a_qty_4_r  LIKE sfb_file.sfb08,    #採購量
                       a_qty_5_r  LIKE sfb_file.sfb08,    #IQC在驗量
                       a_qty_51_r LIKE sfb_file.sfb08,    #FQC在驗量
                       a_qty_6_r  LIKE sfb_file.sfb08,    #備料量
                       a_qty_7_r  LIKE sfb_file.sfb08     #訂單備置量
                       END RECORD
   DEFINE g_ft         RECORD                             #(FT)
#                       f_ima26    LIKE ima_file.ima26,    #庫存可用量     #FUN-A20044
#                       f_ima262   LIKE ima_file.ima262,   #MRP可用量      #FUN-A20044
                       f_avl_stk  LIKE type_file.num15_3,                  #FUN-A20044
                       f_avl_stk_mpsmrp  LIKE type_file.num15_3,           #FUN-A20044 
                       f_qty_1    LIKE sfb_file.sfb08,    #受訂量
                       f_qty_2    LIKE sfb_file.sfb08,    #在製量
                       f_qty_3    LIKE sfb_file.sfb08,    #請購量
                       f_qty_4    LIKE sfb_file.sfb08,    #採購量
                       f_qty_5    LIKE sfb_file.sfb08,    #IQC在驗量
                       f_qty_51   LIKE sfb_file.sfb08,    #FQC在驗量
                       f_qty_6    LIKE sfb_file.sfb08,    #備料量
                       f_qty_7    LIKE sfb_file.sfb08,    #訂單備置量
                       #-------------(參考單位)---------------#
#                       f_ima262_r LIKE ima_file.ima262,   #庫存量           #FUN-A20044
#                       f_ima26_r  LIKE ima_file.ima26,    #MRP可用庫存量    #FUN-A20044
                       f_avl_stk_r  LIKE type_file.num15_3,                  #FUN-A20044
                       f_avl_stk_mpsmrp_r  LIKE type_file.num15_3,           #FUN-A20044
                       f_qty_1_r  LIKE sfb_file.sfb08,    #受訂量
                       f_qty_2_r  LIKE sfb_file.sfb08,    #在製量
                       f_qty_3_r  LIKE sfb_file.sfb08,    #請購量
                       f_qty_4_r  LIKE sfb_file.sfb08,    #採購量
                       f_qty_5_r  LIKE sfb_file.sfb08,    #IQC在驗量
                       f_qty_51_r LIKE sfb_file.sfb08,    #FQC在驗量
                       f_qty_6_r  LIKE sfb_file.sfb08,    #備料量
                       f_qty_7_r  LIKE sfb_file.sfb08     #訂單備置量
                       END RECORD
   DEFINE g_tky        RECORD                             #(TKY)
#                       t_ima26    LIKE ima_file.ima26,    #庫存可用量     #FUN-A20044
#                       t_ima262   LIKE ima_file.ima262,   #MRP可用量      #FUN-A20044
                       t_avl_stk  LIKE type_file.num15_3,                  #FUN-A20044
                       t_avl_stk_mpsmrp  LIKE type_file.num15_3,           #FUN-A20044
                       t_qty_1    LIKE sfb_file.sfb08,    #受訂量
                       t_qty_2    LIKE sfb_file.sfb08,    #在製量
                       t_qty_3    LIKE sfb_file.sfb08,    #請購量
                       t_qty_4    LIKE sfb_file.sfb08,    #採購量
                       t_qty_5    LIKE sfb_file.sfb08,    #IQC在驗量
                       t_qty_51   LIKE sfb_file.sfb08,    #FQC在驗量
                       t_qty_6    LIKE sfb_file.sfb08,    #備料量
                       t_qty_7    LIKE sfb_file.sfb08,    #訂單備置量
                       #-------------(參考單位)---------------
#                       t_ima262_r LIKE ima_file.ima262,   #庫存量        #FUN-A20044  
#                       t_ima26_r  LIKE ima_file.ima26,    #MRP可用庫存量 #FUN-A20044
                       t_avl_stk_r  LIKE type_file.num15_3,                  #FUN-A20044
                       t_avl_stk_mpsmrp_r  LIKE type_file.num15_3,           #FUN-A20044 
                       t_qty_1_r  LIKE sfb_file.sfb08,    #受訂量
                       t_qty_2_r  LIKE sfb_file.sfb08,    #在製量
                       t_qty_3_r  LIKE sfb_file.sfb08,    #請購量
                       t_qty_4_r  LIKE sfb_file.sfb08,    #採購量
                       t_qty_5_r  LIKE sfb_file.sfb08,    #IQC在驗量
                       t_qty_51_r LIKE sfb_file.sfb08,    #FQC在驗量
                       t_qty_6_r  LIKE sfb_file.sfb08,    #備料量
                       t_qty_7_r  LIKE sfb_file.sfb08     #訂單備置量
                       END RECORD
   DEFINE g_material   DYNAMIC ARRAY OF RECORD
                       ima01      LIKE ima_file.ima01,
                       imaicd10   LIKE imaicd_file.imaicd10
                       END RECORD
 
   DEFINE g_order      LIKE type_file.num5
   DEFINE g_cnt        LIKE type_file.num10
   DEFINE g_msg        STRING
   DEFINE g_row_count  LIKE type_file.num10
   DEFINE g_curs_index LIKE type_file.num10
   DEFINE g_jump       LIKE type_file.num10
   DEFINE g_ima906_i   LIKE ima_file.ima906
 
MAIN
   OPTIONS                                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q024_w WITH FORM "aic/42f/aicq024"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("cnt",FALSE)
 
   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
 
   CALL q024_temp()
 
   CALL q024_menu()
   CLOSE WINDOW q024_w
 
   DROP TABLE q024_temp
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q024_cs()
   DEFINE   l_cnt SMALLINT
 
   DELETE FROM q024_temp
#  IF NOT cl_null(g_argv2) THEN
#     LET tm.ima01 = g_argv2
#     LET tm.bom = g_argv1
#  ELSE
      CLEAR FORM                                          #清除畫面
      CALL cl_opmsg('q')
      CALL g_sr.clear()
      CALL g_material.clear()
      CALL q024_ini()
      LET tm.bom = '3'                                    #預設為3
 
      INPUT BY NAME tm.ima01,tm.bom WITHOUT DEFAULTS
 
         AFTER FIELD ima01
            IF NOT cl_null(tm.ima01) THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM ima_file
                WHERE ima01 = tm.ima01
               IF g_cnt = 0 THEN
                  CALL cl_err(tm.ima01,100,0)
                  NEXT FIELD ima01
               END IF
 
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM idc_file
                WHERE idc01 = tm.ima01
               IF g_cnt = 0 THEN
                  CALL cl_err('idc_file',100,0)
                  NEXT FIELD ima01
               END IF
 
            END IF
 
         AFTER FIELD bom
            IF NOT cl_null(tm.bom) THEN
               IF tm.bom NOT MATCHES '[123]' THEN
                  NEXT FIELD bom
               END IF
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION cancel
            EXIT INPUT
 
         ON ACTION controlp
            CASE
                 WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.where =
                      #" ima01 in (SELECT idc01 FROM idc_file) "  #TQC-9B0164
                      " ima01 in (SELECT DISTINCT idc01 FROM idc_file) " #TQC-9B0164
                  CALL cl_create_qry() RETURNING tm.ima01
                  DISPLAY BY NAME tm.ima01
                  NEXT FIELD ima01
               END CASE
      END INPUT
      IF INT_FLAG THEN RETURN END IF
#  END IF
#   LET g_sql="SELECT ima01,ima02,ima021,ima25,ima262,ima26,ima907",    #FUN-A20044
   LET g_sql="SELECT ima01,ima02,ima021,ima25,ima907",                  #FUN-A20044 
             "  FROM ima_file ",
             " WHERE ima01= '",tm.ima01 CLIPPED,"'"
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                                    #只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                                    #只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q024_prepare FROM g_sql
   DECLARE q024_cs SCROLL CURSOR FOR q024_prepare
 
#  LET g_sql=" SELECT count(*) FROM ima_file ", " WHERE ",g_wc CLIPPED
   LET g_sql=" SELECT count(*) FROM ima_file ", 
             " WHERE ima01= '",tm.ima01 CLIPPED,"'" 
   PREPARE q024_pp  FROM g_sql
   DECLARE q024_cnt CURSOR FOR q024_pp
 
END FUNCTION
 
FUNCTION q024_menu()
 
   #CALL cl_set_act_visible("cancel",FALSE)
   MENU ""
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU
 
      #ON ACTION cancel
      #   LET g_action_choice="exit"
      #   EXIT MENU
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION query
         LET g_action_choice = "query"
         IF cl_chk_act_auth() THEN
            CALL q024_q()
         END IF
 
      ON ACTION aicq025                                   #各段供需查詢
         LET g_action_choice="aicq025"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_ima.ima01) THEN
               CALL q024_ask_win()
            END IF
         END IF
 
      ON ACTION aimq231                                   #料件BIN卡查詢
         LET g_action_choice="aimq231"
         IF cl_chk_act_auth() THEN
            IF NOT cl_null(g_ima.ima01) THEN
               LET g_msg = 'aimq231 "',g_ima.ima01,'"'
               CALL cl_cmdrun_wait(g_msg)
            END IF
         END IF
 
      #No.FUN-830076 add 08/03/21 --begin
      ON ACTION related_document   #相關文件
         LET g_action_choice = "related_document"
         IF cl_chk_act_auth() THEN
            IF g_ima.ima01 IS NOT NULL THEN
               LET g_doc.column1 = "ima01"
               LET g_doc.value1 = g_ima.ima01
               CALL cl_doc()
            END IF
         END IF
      #No.FUN-830076 add 08/03/21 --end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG = FALSE
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION q024_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    DISPLAY '' TO FORMONLY.cnt
    CALL q024_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "Waiting!"
    OPEN q024_cs                                          #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('q024_q:',SQLCA.sqlcode,0)
    ELSE
       OPEN q024_cnt
       FETCH q024_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       FETCH q024_cs INTO g_ima.ima01,g_ima.ima02,g_ima.ima021,
#                         g_ima.ima25,g_ima.ima262,g_ima.ima26,    #FUN-A20044
                          g_ima.ima25,                             #FUN-A20044
                          g_ima.ima907
       IF SQLCA.sqlcode THEN
          CALL cl_err('Fetch:',SQLCA.sqlcode,0)
          RETURN
      END IF
      CALL q024_show()
    END IF
    MESSAGE ""
 
END FUNCTION
 
FUNCTION q024_show()
 
   MESSAGE ' WAIT '
   CALL q024_fill_1()                                     #本料
   CASE WHEN tm.bom = '1' CALL q024_down(0,g_ima.ima01)
        WHEN tm.bom = '2' CALL q024_up(0,g_ima.ima01)
        WHEN tm.bom = '3' CALL q024_up(0,g_ima.ima01)
                          CALL q024_down(0,g_ima.ima01)
   END CASE
   CALL q024_fill_2()
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_ima.*   
#   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25,g_ima.ima262,g_ima.ima26,                 #FUN-A20044
   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima25,g_ima.avl_stk,g_ima.avl_stk_mpsmrp,        #FUN-A20044
                   g_ima.ima907,g_ima.qty_1,g_ima.qty_2,g_ima.qty_3,g_ima.qty_4,g_ima.qty_5,
#                   g_ima.qty_51,g_ima.qty_6,g_ima.qty_7,g_ima.ima262_r,g_ima.ima26_r,g_ima.qty_1_r,             #FUN-A20044
                   g_ima.qty_51,g_ima.qty_6,g_ima.qty_7,g_ima.avl_stk_r,g_ima.avl_stk_mpsmrp_r,g_ima.qty_1_r,    #FUN-A20044
                   g_ima.qty_2_r ,g_ima.qty_3_r,g_ima.qty_4_r,g_ima.qty_5_r,g_ima.qty_51_r,
                   g_ima.qty_6_r,g_ima.qty_7_r   
   #DISPLAY BY NAME g_wafer.*
#   DISPLAY BY NAME g_wafer.w_ima26,g_wafer.w_ima262,g_wafer.w_qty_1,g_wafer.w_qty_2,g_wafer.w_qty_3,           #FUN-A20044
  DISPLAY BY NAME g_wafer.w_avl_stk_mpsmrp,g_wafer.w_avl_stk,g_wafer.w_qty_1,g_wafer.w_qty_2,g_wafer.w_qty_3,   #FUN-A20044              
                   g_wafer.w_qty_4,g_wafer.w_qty_4,g_wafer.w_qty_5,g_wafer.w_qty_51,g_wafer.w_qty_6,
#                   g_wafer.w_qty_7,g_wafer.w_ima262_r,g_wafer.w_ima262_r,g_wafer.w_ima26_r,g_wafer.w_qty_1_r,  #FUN-A20044
                   g_wafer.w_qty_7,g_wafer.w_avl_stk_r,g_wafer.w_avl_stk_r,g_wafer.w_avl_stk_mpsmrp_r,g_wafer.w_qty_1_r,   #FUN-A20044
                   g_wafer.w_qty_2_r,g_wafer.w_qty_3_r,g_wafer.w_qty_4_r,g_wafer.w_qty_5_r,g_wafer.w_qty_51_r,
                   g_wafer.w_qty_6_r,g_wafer.w_qty_7_r 
   #DISPLAY BY NAME g_cp.*
#   DISPLAY BY NAME g_cp.c_ima26,g_cp.c_ima262,g_cp.c_qty_1,g_cp.c_qty_2,g_cp.c_qty_3,g_cp.c_qty_4,g_cp.c_qty_5,g_cp.c_qty_51,g_cp.c_qty_6,            #FUN-A20044
   DISPLAY BY NAME g_cp.c_avl_stk_mpsmrp,g_cp.c_avl_stk,g_cp.c_qty_1,g_cp.c_qty_2,g_cp.c_qty_3,g_cp.c_qty_4,g_cp.c_qty_5,g_cp.c_qty_51,g_cp.c_qty_6,   #FUN-A20044
#                   g_cp.c_qty_7,g_cp.c_ima262_r,g_cp.c_ima26_r,g_cp.c_qty_1_r,g_cp.c_qty_2_r,g_cp.c_qty_3_r,g_cp.c_qty_4_r,g_cp.c_qty_5_r,            #FUN-A20044
                   g_cp.c_qty_7,g_cp.c_avl_stk_r,g_cp.c_avl_stk_mpsmrp_r,g_cp.c_qty_1_r,g_cp.c_qty_2_r,g_cp.c_qty_3_r,g_cp.c_qty_4_r,g_cp.c_qty_5_r,   #FUN-A20044
                   g_cp.c_qty_51_r,g_cp.c_qty_6_r,g_cp.c_qty_7_r
   #DISPLAY BY NAME g_ds.*
#   DISPLAY BY NAME g_ds.d_ima26,g_ds.d_ima262,g_ds.d_qty_1,g_ds.d_qty_2,g_ds.d_qty_3,g_ds.d_qty_4,g_ds.d_qty_5,g_ds.d_qty_51,                    #FUN-A20044
   DISPLAY BY NAME g_ds.d_avl_stk,g_ds.d_avl_stk_mpsmrp,g_ds.d_qty_1,g_ds.d_qty_2,g_ds.d_qty_3,g_ds.d_qty_4,g_ds.d_qty_5,g_ds.d_qty_51,           #FUN-A20044
#                   g_ds.d_qty_6,g_ds.d_qty_7,g_ds.d_ima262_r,g_ds.d_qty_1_r,g_ds.d_qty_2_r,g_ds.d_qty_3_r,g_ds.d_qty_4_r,                        #FUN-A20044
                   g_ds.d_qty_6,g_ds.d_qty_7,g_ds.d_avl_stk_r,g_ds.d_qty_1_r,g_ds.d_qty_2_r,g_ds.d_qty_3_r,g_ds.d_qty_4_r,                        #FUN-A20044
                   g_ds.d_qty_5_r,g_ds.d_qty_51_r,g_ds.d_qty_6_r,g_ds.d_qty_7_r
   #DISPLAY BY NAME g_ass.*
#   DISPLAY BY NAME g_ass.a_ima26,g_ass.a_ima262,g_ass.a_qty_1,g_ass.a_qty_2,g_ass.a_qty_3,g_ass.a_qty_4,g_ass.a_qty_5,                           #FUN-A20044
   DISPLAY BY NAME g_ass.a_avl_stk_mpsmrp,g_ass.a_avl_stk,g_ass.a_qty_1,g_ass.a_qty_2,g_ass.a_qty_3,g_ass.a_qty_4,g_ass.a_qty_5,                  #FUN-A20044
#                   g_ass.a_qty_51,g_ass.a_qty_6,g_ass.a_qty_7,g_ass.a_ima262_r,g_ass.a_ima26_r,g_ass.a_qty_1_r,g_ass.a_qty_2_r,                  #FUN-A20044
                   g_ass.a_qty_51,g_ass.a_qty_6,g_ass.a_qty_7,g_ass.a_avl_stk_r,g_ass.a_avl_stk_mpsmrp_r,g_ass.a_qty_1_r,g_ass.a_qty_2_r,         #FUN-A20044
                   g_ass.a_qty_3_r,g_ass.a_qty_4_r,g_ass.a_qty_5_r,g_ass.a_qty_51_r,g_ass.a_qty_6_r,g_ass.a_qty_7_r      
   #DISPLAY BY NAME g_ft.*
#   DISPLAY BY NAME g_ft.f_ima26,g_ft.f_ima262,g_ft.f_qty_1,g_ft.f_qty_2,g_ft.f_qty_3,g_ft.f_qty_4,g_ft.f_qty_5,          #FUN-A20044     
   DISPLAY BY NAME g_ft.f_avl_stk_mpsmrp,g_ft.f_avl_stk,g_ft.f_qty_1,g_ft.f_qty_2,g_ft.f_qty_3,g_ft.f_qty_4,g_ft.f_qty_5, #FUN-A20044          
#                   g_ft.f_qty_51,g_ft.f_qty_6,g_ft.f_qty_7,g_ft.f_ima262_r,g_ft.f_qty_1_r,g_ft.f_qty_2_r,                #FUN-A20044
                   g_ft.f_qty_51,g_ft.f_qty_6,g_ft.f_qty_7,g_ft.f_avl_stk_r,g_ft.f_qty_1_r,g_ft.f_qty_2_r,                #FUN-A20044
                   g_ft.f_qty_3_r,g_ft.f_qty_4_r,g_ft.f_qty_5_r,g_ft.f_qty_51_r,g_ft.f_qty_6_r,g_ft.f_qty_7_r  
   #DISPLAY BY NAME g_tky.*
#   DISPLAY BY NAME g_tky.t_ima26,g_tky.t_ima262,g_tky.t_qty_1,g_tky.t_qty_2,g_tky.t_qty_3,g_tky.t_qty_4,g_tky.t_qty_5,            #FUN-A20044
   DISPLAY BY NAME g_tky.t_avl_stk_mpsmrp,g_tky.t_avl_stk,g_tky.t_qty_1,g_tky.t_qty_2,g_tky.t_qty_3,g_tky.t_qty_4,g_tky.t_qty_5,   #FUN-A20044
#                   g_tky.t_qty_51,g_tky.t_qty_6,g_tky.t_qty_7,g_tky.t_ima262_r,g_tky.t_ima26_r,g_tky.t_qty_1_r,                   #FUN-A20044
                   g_tky.t_qty_51,g_tky.t_qty_6,g_tky.t_qty_7,g_tky.t_avl_stk_r,g_tky.t_avl_stk_mpsmrp_r,g_tky.t_qty_1_r,          #FUN-A20044 
                   g_tky.t_qty_2_r,g_tky.t_qty_3_r,g_tky.t_qty_4_r,g_tky.t_qty_5_r,g_tky.t_qty_51_r,g_tky.t_qty_6_r,g_tky.t_qty_7_r
   #No.FUN-9A0024--end
   MESSAGE ''
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION q024_fill_1()
   DEFINE l_sfb02     LIKE type_file.num5,
          m_oeb12     LIKE oeb_file.oeb12,
          l_ima55_fac LIKE ima_file.ima55_fac,
          qty_1       LIKE sfb_file.sfb08,
          qty_2       LIKE sfb_file.sfb08,
          qty_3       LIKE sfb_file.sfb08,
          qty_4       LIKE sfb_file.sfb08,
          qty_5       LIKE sfb_file.sfb08,
          qty_51      LIKE sfb_file.sfb08,
          qty_6       LIKE sfb_file.sfb08,
          qty_7       LIKE sfb_file.sfb08,
          qty_1_r     LIKE sfb_file.sfb08,
          qty_2_r     LIKE sfb_file.sfb08,
          qty_3_r     LIKE sfb_file.sfb08,
          qty_4_r     LIKE sfb_file.sfb08,
          qty_5_r     LIKE sfb_file.sfb08,
          qty_51_r    LIKE sfb_file.sfb08,
          qty_6_r     LIKE sfb_file.sfb08,
          qty_7_r     LIKE sfb_file.sfb08
   DEFINE m_oeb915    LIKE oeb_file.oeb915,
          l_rvb01     LIKE rvb_file.rvb01,
          l_rvb02     LIKE rvb_file.rvb02,
          l_sfb01     LIKE sfb_file.sfb01
         ,l_avl_stk_mpsmrp   LIKE type_file.num15_3,   #FUN-A20044
          l_unavl_stk        LIKE type_file.num15_3,   #FUN-A20044
          l_avl_stk          LIKE type_file.num15_3    #FUN-A20044  

   #取得本料的單位使用設定值
   LET g_ima906_i = ''
   SELECT ima906 INTO g_ima906_i
     FROM ima_file
    WHERE ima01 = g_ima.ima01

#FUN-A20044 ---start---
   CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
   LET g_ima.avl_stk_mpsmrp = l_avl_stk_mpsmrp
   LET g_ima.avl_stk = l_avl_stk
#FUN-A20044 ---end---
 
   #庫存可用量的參考數量
#   SELECT SUM(imgg10 * imgg21) INTO g_ima.ima26_r            #FUN-A20044
   SELECT SUM(imgg10 * imgg21) INTO g_ima.avl_stk_mpsmrp_r    #FUN-A20044  
     FROM imgg_file,img_file
    WHERE imgg01 = g_ima.ima01 #AND imgg23 = 'Y'
      AND imgg10 IS NOT NULL AND imgg21 IS NOT NULL
      AND imgg01 = img01
      AND imgg02 = img02
      AND imgg03 = img03
      AND imgg04 = img04
      AND img23 = 'Y'     #是否為可用倉儲
 
#   IF cl_null(g_ima.ima26_r) THEN           #FUN-A20044
#      LET g_ima.ima26_r = 0                 #FUN-A20044
   IF cl_null(g_ima.avl_stk_mpsmrp_r) THEN   #FUN-A20044
      LET g_ima.avl_stk_mpsmrp_r = 0         #FUN-A20044   
   END IF                      
 
   IF g_ima906_i = '1' THEN
#      LET g_ima.ima26_r = ''        #FUN-A20044
      LET g_ima.avl_stk_mpsmrp_r = ''#FUN-A20044
   END IF
 
   #庫存MRP可用量的參考數量
#  SELECT SUM(imgg10 * imgg21) INTO g_ima.ima262_r     #FUN-A20044
   SELECT SUM(imgg10 * imgg21) INTO g_ima.avl_stk_r    #FUN-A20044 
     FROM imgg_file,img_file
    WHERE imgg01 = g_ima.ima01 #AND imgg23 = 'Y' AND imgg24 = 'Y'
      AND imgg10 IS NOT NULL AND imgg21 IS NOT NULL
      AND imgg01 = img01
      AND imgg02 = img02
      AND imgg03 = img03
      AND imgg04 = img04
      AND img24 = 'Y'                                     #是否為ＭＲＰ可用倉儲
#   IF cl_null(g_ima.ima262_r) THEN     #FUN-A20044
#      LET g_ima.ima262_r = 0           #FUN-A20044
    IF cl_null(g_ima.avl_stk_r) THEN    #FUN-A20044
       LET g_ima.avl_stk_r = 0          #FUN-A20044
    END IF
   IF g_ima906_i = '1' THEN
#      LET g_ima.ima262_r = ''          #FUN-A20044
      LET g_ima.avl_stk_r = ''          #FUN-A20044
   END IF
 
   #-->受訂量
   DECLARE q024_bcs1 CURSOR FOR                           #主要單位和參考單位之比率
    SELECT (oeb12 - oeb24 + oeb25 - oeb26) * oeb05_fac,(oeb915 / oeb12)
      FROM oeb_file, oea_file, occ_file
     WHERE oeb04 = g_ima.ima01
       AND oeb01 = oea01
       AND occ01 = oea03
       AND oea00<>'0'
       AND oeb70 = 'N'
       AND oeb12 > oeb24
       AND oeaconf !='X'
     ORDER BY oeb15
 
   #-->在製量
   SELECT ima55_fac INTO l_ima55_fac 
     FROM ima_file 
    WHERE ima01 = g_ima.ima01
   IF cl_null(l_ima55_fac) THEN 
      LET l_ima55_fac = 1 
   END IF
   DECLARE q024_bcs2 CURSOR FOR                           #主要單位和參考單位之比率
    SELECT (sfb08 - sfb09 - sfb10 - sfb11 - sfb12) * l_ima55_fac,(sfbiicd06 / sfb08)
      FROM sfb_file,sfbi_file,OUTER gem_file
     WHERE sfb05 = g_ima.ima01
       AND sfb01 = sfbi01
       AND sfb04 !='8'
       AND sfb_file.sfb82 = gem_file.gem01
       AND sfb08 > (sfb09 + sfb10 + sfb11 + sfb12)
       AND sfb87 != 'X'
     ORDER BY sfb15
 
   #-->請購量
   DECLARE q024_bcs3 CURSOR FOR                           #主要單位和參考單位之比率
    SELECT (pml20 - pml21) * pml09,(pml83 / pml20)
      FROM pml_file, pmk_file, OUTER pmc_file
     WHERE pml04 = g_ima.ima01
       AND pml01 = pmk01
       AND pmk_file.pmk09 = pmc_file.pmc01
       AND pml20 > pml21
       AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W')
       AND pml011 !='SUB' 
       AND pmk18 != 'X'
      ORDER BY pml35
 
   #-->採購量
   DECLARE q024_bcs4 CURSOR FOR                           #主要單位和參考單位之比率
    SELECT (pmn20 - pmn50 + pmn55) * pmn09,(pmn85 / pmn20)
      FROM pmn_file, pmm_file, OUTER pmc_file
     WHERE pmn04 = g_ima.ima01
       AND pmn01 = pmm01
       AND pmm_file.pmm09 = pmc_file.pmc01
       AND pmn20 -(pmn50-pmn55) > 0
       AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
       AND pmn011 !='SUB'
       AND pmm18 != 'X'
     ORDER BY pmn33
 
   #-->IQC 在驗量
   DECLARE q024_bcs5 CURSOR FOR                           #收貨單號,項次
    SELECT (rvb07 - rvb29 - rvb30) * pmn09,rvb01,rvb02
      FROM rvb_file, rva_file, OUTER pmc_file, pmn_file
     WHERE rvb05 = g_ima.ima01
       AND rvb01 = rva01
       AND rva_file.rva05 = pmc_file.pmc01
       AND rvb04 = pmn_file.pmn01
       AND rvb03 = pmn_file.pmn02
       AND rvb07 > (rvb29+rvb30)
       AND rvaconf='Y'
       AND rva10 !='SUB'
     ORDER BY rva06
 
   #-->取得IQC 參考數量與檢驗量換算率(主要單位和參考單位之比率)
   DECLARE q024_bcs5_r CURSOR FOR
    SELECT SUM(qcs35 / qcs06)
      FROM rvb_file, rva_file,qcs_file
     WHERE rvb05 = g_ima.ima01
       AND rvb01 = rva01
       AND rvb07 > (rvb29 + rvb30)
       AND rvaconf='Y'
       AND rva10 !='SUB'
       #-----串iqc單-----#
       AND qcs01 = rvb01                                  #收貨單號
       AND qcs02 = rvb02                                  #收貨項次
       AND qcs14 != 'X'                                   #未作廢
       AND qcs06 > 0
       AND rvb01 = l_rvb01
       AND rvb02 = l_rvb02
     ORDER BY rva06
 
   #-->FQC 在驗量
   DECLARE q024_bcs51 CURSOR FOR                          #工單單號
    SELECT sfb11,sfb01
      FROM sfb_file,OUTER gem_file
     WHERE sfb05 = g_ima.ima01
       AND sfb02 <> '7' AND sfb87!='X'
       AND sfb04 <'8' AND sfb_file.sfb82=gem_file.gem01
       AND sfb11 > 0
 
   #-->取得IQC 在驗量參考數量與檢驗量換算率(主要單位和參考單位之比率)
   DECLARE q024_bcs51_r CURSOR FOR
    SELECT SUM(qcf35 / qcf06 )
      FROM sfb_file,qcf_file
     WHERE sfb05 = g_ima.ima01
       AND sfb02 <> '7'
       AND sfb87!='X'
       AND sfb04 <'8'
       AND sfb11 > 0
       #-----串fqc單-----#
       AND qcf02 = sfb01                                  #工單單號
       AND qcf14 != 'X'                                   #未作廢之FQC單
       AND qcf06 > 0
       AND qcf02 = l_sfb01
 
   #-->備料量
   DECLARE q024_bcs6 CURSOR FOR                           #主要單位和參考單位之比率
    SELECT (sfa05 - sfa06 - sfa065) * sfa13,(sfaiicd01 / sfa05)
      FROM sfb_file,sfa_file,sfai_file,OUTER gem_file
     WHERE sfa03 = g_ima.ima01
       AND sfa01 = sfai01
       AND sfa03 = sfai03
       AND sfa08 = sfai08
       AND sfa12 = sfai12
       AND sfa27 = sfai27 #CHI-7B0034
       AND sfb01 = sfa01
       AND sfb_file.sfb82 = gem_file.gem01
       AND sfb04 !='8'
       AND sfa05 > 0
       AND sfa05 > sfa06 + sfa065
       AND sfb87!='X'
     ORDER BY sfb13
 
   #-->銷售備置量,參考數量:(oeb915/oeb12)* 訂單備置
   SELECT SUM(oeb905 * oeb05_fac),SUM((oeb915 / oeb12) * (oeb905 * oeb05_fac))
     INTO m_oeb12,m_oeb915
     FROM oeb_file, oea_file, occ_file
    WHERE oeb04 = g_ima.ima01 
      AND oeb01 = oea01 
      AND oea00 <>'0' 
      AND oeb19 = 'Y'
      AND oeb70 = 'N' 
      AND oeb12 > oeb24 
      AND oea03 = occ01
      AND oeaconf != 'X'
 
   IF cl_null(m_oeb12) THEN 
      LET m_oeb12 = 0 
   END IF
   IF cl_null(m_oeb915) THEN 
      LET m_oeb915 = 0 
   END IF
   LET qty_7 = m_oeb12
   LET g_ima.qty_7 = m_oeb12
 
   IF g_ima906_i = '1' THEN 
      LET m_oeb915 = '' 
   END IF
   LET qty_7_r = m_oeb915                                 #銷售備置量參考數量
   LET g_ima.qty_7_r = m_oeb915                           #銷售備置量參考數量
 
   #-->受訂量
   FOREACH q024_bcs1 INTO qty_1,qty_1_r
      IF STATUS THEN CALL cl_err('F1:',STATUS,1) 
         EXIT FOREACH 
      END IF
 
      IF cl_null(qty_1) THEN 
         LET qty_1 = 0 
      END IF
      IF cl_null(qty_1_r) THEN 
         LET qty_1_r = 0 
      END IF
 
      LET g_ima.qty_1 = g_ima.qty_1 + qty_1
      #參考數量((oeb915/oeb12) *受訂量)
      LET g_ima.qty_1_r = g_ima.qty_1_r + (qty_1_r * qty_1)
   END FOREACH
   IF g_ima906_i = '1' THEN 
      LET g_ima.qty_1_r = '' 
   END IF
 
   #-->在製量
   FOREACH q024_bcs2 INTO qty_2,qty_2_r
      IF STATUS THEN
         CALL cl_err('F2:',STATUS,1) 
         EXIT FOREACH 
      END IF
 
      IF cl_null(qty_2) THEN 
         LET qty_2 = 0
      END IF
      IF cl_null(qty_2_r) THEN 
         LET qty_2_r = 0
      END IF
 
      LET g_ima.qty_2 = g_ima.qty_2 + qty_2
      #參考數量((sfbiicd06 / sfb08) *在製量)
      LET g_ima.qty_2_r = g_ima.qty_2_r + (qty_2_r * qty_2)
   END FOREACH
   IF g_ima906_i = '1' THEN
      LET g_ima.qty_2_r = ''
   END IF
 
   #-->請購量
   FOREACH q024_bcs3 INTO qty_3,qty_3_r
      IF STATUS THEN
         CALL cl_err('F3:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(qty_3) THEN
         LET qty_3 = 0
      END IF
      IF cl_null(qty_3_r) THEN
         LET qty_3_r = 0
      END IF
 
      LET g_ima.qty_3 = g_ima.qty_3 + qty_3
      #參考數量((pml83/pml20) *請購量)
      LET g_ima.qty_3_r = g_ima.qty_3_r + (qty_3_r * qty_3)
   END FOREACH
   IF g_ima906_i = '1' THEN
      LET g_ima.qty_3_r = ''
   END IF
 
   #-->採購量
   FOREACH q024_bcs4 INTO qty_4,qty_4_r
      IF STATUS THEN
         CALL cl_err('F4:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(qty_4) THEN
         LET qty_4 = 0
      END IF
      IF cl_null(qty_4_r) THEN
         LET qty_4_r = 0
      END IF
 
      LET g_ima.qty_4 = g_ima.qty_4 + qty_4
      #參考數量((pmn85/pmn20 ) *採購量)
      LET g_ima.qty_4_r = g_ima.qty_4_r + (qty_4_r * qty_4)
   END FOREACH
   IF g_ima906_i = '1' THEN
      LET g_ima.qty_4_r = ''
   END IF
 
   #-->IQC 在驗量
   FOREACH q024_bcs5 INTO qty_5,l_rvb01,l_rvb02
      IF STATUS THEN
         CALL cl_err('F5:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(qty_5) THEN
         LET qty_5 = 0
      END IF
 
      LET g_ima.qty_5 = g_ima.qty_5 + qty_5
 
      #參考數量(sum(qcs35/qcs06) * IQC)
      OPEN q024_bcs5_r
      FETCH q024_bcs5_r INTO qty_5_r
 
      IF cl_null(qty_5_r) THEN
         LET qty_5_r = 0
      END IF
 
      LET g_ima.qty_5_r = g_ima.qty_5_r + (qty_5_r * qty_5)
   END FOREACH
   IF g_ima906_i = '1' THEN
      LET g_ima.qty_5_r = ''
   END IF
 
   #-->FQC 在驗量
   FOREACH q024_bcs51 INTO qty_51,l_sfb01
      IF STATUS THEN
         CALL cl_err('F51:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(qty_51) THEN
         LET qty_51 = 0
      END IF
 
      LET g_ima.qty_51 = g_ima.qty_51 + qty_51
 
      #參考數量(sum(qcf35/ qcf06 ) * FQC)
      OPEN q024_bcs51_r
      FETCH q024_bcs51_r INTO qty_51_r
      IF cl_null(qty_51_r) THEN
         LET qty_51_r = 0
      END IF
      LET g_ima.qty_51_r = g_ima.qty_51_r + (qty_51_r * qty_51)
   END FOREACH
   IF g_ima906_i = '1' THEN
      LET g_ima.qty_51_r = ''
   END IF
 
   #-->備料量
   FOREACH q024_bcs6 INTO qty_6,qty_6_r
      IF STATUS THEN
         CALL cl_err('F6:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(qty_6) THEN
         LET qty_6 = 0
      END IF
      IF cl_null(qty_6_r) THEN
         LET qty_6_r = 0
      END IF
 
      LET g_ima.qty_6 = g_ima.qty_6 + qty_6
      #參考數量((sfaiicd01 / sfa05) * 備料量)
      LET g_ima.qty_6_r = g_ima.qty_6_r + (qty_6_r * qty_6)
   END FOREACH
   IF g_ima906_i = '1' THEN
      LET g_ima.qty_6_r = ''
   END IF
 
END FUNCTION
 
#預設:
#0.本料       -->先預設給0(後續再判斷該料若為使用單一單位,再給NULL)
#1.Wafer,2.CP -->參考數量預設給0
#3.DS,4.ASS,5.FT,6.TKY -->使用單一單位,不會有參考數量,預設給NULL
FUNCTION q024_ini()
   INITIALIZE g_ima.* TO NULL
#   LET g_ima.ima26 = 0 LET g_ima.ima262= 0            #FUN-A20044
   LET g_ima.avl_stk_mpsmrp = 0 LET g_ima.avl_stk = 0  #FUN-A20044
   LET g_ima.qty_1 = 0 LET g_ima.qty_2 = 0
   LET g_ima.qty_3 = 0 LET g_ima.qty_4 = 0
   LET g_ima.qty_5 = 0 LET g_ima.qty_51= 0
   LET g_ima.qty_6 = 0 LET g_ima.qty_7 = 0
#   LET g_ima.ima26_r = 0 LET g_ima.ima262_r= 0           #FUN-A20044
   LET g_ima.avl_stk_mpsmrp_r = 0 LET g_ima.avl_stk_r = 0 #FUN-A20044
   LET g_ima.qty_1_r = 0 LET g_ima.qty_2_r = 0
   LET g_ima.qty_3_r = 0 LET g_ima.qty_4_r = 0
   LET g_ima.qty_5_r = 0 LET g_ima.qty_51_r= 0
   LET g_ima.qty_6_r = 0 LET g_ima.qty_7_r = 0
 
   INITIALIZE g_wafer.* TO NULL
#   LET g_wafer.w_ima26 = 0 LET g_wafer.w_ima262= 0           #FUN-A20044
   LET g_wafer.w_avl_stk_mpsmrp = 0 LET g_wafer.w_avl_stk = 0 #FUN-A20044
   LET g_wafer.w_qty_1 = 0 LET g_wafer.w_qty_2 = 0
   LET g_wafer.w_qty_3 = 0 LET g_wafer.w_qty_4 = 0
   LET g_wafer.w_qty_5 = 0 LET g_wafer.w_qty_51= 0
   LET g_wafer.w_qty_6 = 0 LET g_wafer.w_qty_7 = 0
#   LET g_wafer.w_ima26_r = 0 LET g_wafer.w_ima262_r= 0           #FUN-A20044
   LET g_wafer.w_avl_stk_mpsmrp_r = 0 LET g_wafer.w_avl_stk_r = 0 #FUN-A20044
   LET g_wafer.w_qty_1_r = 0 LET g_wafer.w_qty_2_r = 0
   LET g_wafer.w_qty_3_r = 0 LET g_wafer.w_qty_4_r = 0
   LET g_wafer.w_qty_5_r = 0 LET g_wafer.w_qty_51_r= 0
   LET g_wafer.w_qty_6_r = 0 LET g_wafer.w_qty_7_r = 0
 
   INITIALIZE g_cp.*    TO NULL
#   LET g_cp.c_ima26 = 0 LET g_cp.c_ima262= 0            #FUN-A20044
   LET g_cp.c_avl_stk_mpsmrp = 0 LET g_cp.c_avl_stk = 0  #FUN-A20044
   LET g_cp.c_qty_1 = 0 LET g_cp.c_qty_2 = 0
   LET g_cp.c_qty_3 = 0 LET g_cp.c_qty_4 = 0
   LET g_cp.c_qty_5 = 0 LET g_cp.c_qty_51= 0
   LET g_cp.c_qty_6 = 0 LET g_cp.c_qty_7 = 0
#   LET g_cp.c_ima26_r = 0 LET g_cp.c_ima262_r= 0       #FUN-A20044
   LET g_cp.c_avl_stk_mpsmrp_r = 0 LET g_cp.c_avl_stk_r = 0 #FUN-A20044
   LET g_cp.c_qty_1_r = 0 LET g_cp.c_qty_2_r = 0
   LET g_cp.c_qty_3_r = 0 LET g_cp.c_qty_4_r = 0
   LET g_cp.c_qty_5_r = 0 LET g_cp.c_qty_51_r= 0
   LET g_cp.c_qty_6_r = 0 LET g_cp.c_qty_7_r = 0
 
   INITIALIZE g_ds.*    TO NULL
#   LET g_ds.d_ima26 = 0 LET g_ds.d_ima262= 0            #FUN-A20044
   LET g_ds.d_avl_stk_mpsmrp = 0 LET g_ds.d_avl_stk = 0  #FUN-A20044 
   LET g_ds.d_qty_1 = 0 LET g_ds.d_qty_2 = 0
   LET g_ds.d_qty_3 = 0 LET g_ds.d_qty_4 = 0
   LET g_ds.d_qty_5 = 0 LET g_ds.d_qty_51= 0
   LET g_ds.d_qty_6 = 0 LET g_ds.d_qty_7 = 0
#   LET g_ds.d_ima26_r = '' LET g_ds.d_ima262_r= ''         #FUN-A20044
   LET g_ds.d_avl_stk_mpsmrp_r = '' LET g_ds.d_avl_stk = '' #FUN-A20044
   LET g_ds.d_qty_1_r = '' LET g_ds.d_qty_2_r = ''
   LET g_ds.d_qty_3_r = '' LET g_ds.d_qty_4_r = ''
   LET g_ds.d_qty_5_r = '' LET g_ds.d_qty_51_r= ''
   LET g_ds.d_qty_6_r = '' LET g_ds.d_qty_7_r = ''
 
   INITIALIZE g_ass.*   TO NULL
#   LET g_ass.a_ima26 = 0 LET g_ass.a_ima262= 0                #FUN-A20044
   LET g_ass.a_avl_stk_mpsmrp = 0 LET g_ass.a_avl_stk = 0        #FUN-A20044
   LET g_ass.a_qty_1 = 0 LET g_ass.a_qty_2 = 0
   LET g_ass.a_qty_3 = 0 LET g_ass.a_qty_4 = 0
   LET g_ass.a_qty_5 = 0 LET g_ass.a_qty_51= 0
   LET g_ass.a_qty_6 = 0 LET g_ass.a_qty_7 = 0
#   LET g_ass.a_ima26_r = '' LET g_ass.a_ima262_r= ''          #FUN-A20044
   LET g_ass.a_avl_stk_mpsmrp_r = '' LET g_ass.a_avl_stk_r = ''    #FUN-A20044   
   LET g_ass.a_qty_1_r = '' LET g_ass.a_qty_2_r = ''
   LET g_ass.a_qty_3_r = '' LET g_ass.a_qty_4_r = ''
   LET g_ass.a_qty_5_r = '' LET g_ass.a_qty_51_r= ''
   LET g_ass.a_qty_6_r = '' LET g_ass.a_qty_7_r = ''
 
   INITIALIZE g_ft.*    TO NULL
#   LET g_ft.f_ima26 = 0 LET g_ft.f_ima262= 0                  #FUN-A20044
   LET g_ft.f_avl_stk_mpsmrp = 0 LET g_ft.f_avl_stk = 0        #FUN-A20044
   LET g_ft.f_qty_1 = 0 LET g_ft.f_qty_2 = 0
   LET g_ft.f_qty_3 = 0 LET g_ft.f_qty_4 = 0
   LET g_ft.f_qty_5 = 0 LET g_ft.f_qty_51= 0
   LET g_ft.f_qty_6 = 0 LET g_ft.f_qty_7 = 0
#   LET g_ft.f_ima26_r = '' LET g_ft.f_ima262_r= ''            #FUN-A20044
   LET g_ft.f_avl_stk_mpsmrp_r ='' LET g_ft.f_avl_stk_r = ''       #FUN-A20044
   LET g_ft.f_qty_1_r = '' LET g_ft.f_qty_2_r = ''
   LET g_ft.f_qty_3_r = '' LET g_ft.f_qty_4_r = ''
   LET g_ft.f_qty_5_r = '' LET g_ft.f_qty_51_r= ''
   LET g_ft.f_qty_6_r = '' LET g_ft.f_qty_7_r = ''
 
   INITIALIZE g_tky.*   TO NULL
#   LET g_tky.t_ima26 = 0 LET g_tky.t_ima262= 0               #FUN-A20044
   LET g_tky.t_avl_stk_mpsmrp = 0 LET g_tky.t_avl_stk = 0     #FUN-A20044
   LET g_tky.t_qty_1 = 0 LET g_tky.t_qty_2 = 0
   LET g_tky.t_qty_3 = 0 LET g_tky.t_qty_4 = 0
   LET g_tky.t_qty_5 = 0 LET g_tky.t_qty_51= 0
   LET g_tky.t_qty_6 = 0 LET g_tky.t_qty_7 = 0
#   LET g_tky.t_ima26_r = '' LET g_tky.t_ima262_r= ''         #FUN-A20044
   LET g_tky.t_avl_stk_mpsmrp_r = 0 LET g_tky.t_avl_stk_r = 0 #FUN-A20044
   LET g_tky.t_qty_1_r = '' LET g_tky.t_qty_2_r = ''
   LET g_tky.t_qty_3_r = '' LET g_tky.t_qty_4_r = ''
   LET g_tky.t_qty_5_r = '' LET g_tky.t_qty_51_r= ''
   LET g_tky.t_qty_6_r = '' LET g_tky.t_qty_7_r = ''
END FUNCTION
 
#逆展BOM
FUNCTION q024_down(p_level,p_ima01)
   DEFINE p_ima01 LIKE ima_file.ima01,
          p_level LIKE type_file.num5
   DEFINE l_bom   DYNAMIC ARRAY OF RECORD
                  ima01    LIKE ima_file.ima01,
                  imaicd10 LIKE imaicd_file.imaicd10
                  END RECORD
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_i     LIKE type_File.num10
 
   SELECT COUNT(DISTINCT bmb03)
     INTO l_cnt 
     FROM bma_file,bmb_file,ima_file
    WHERE bmb03 = ima01
      AND bma01 = p_ima01
      AND bma01 = bmb01
      AND bma06 = bmb29
      AND bma05 <= g_today
      AND bma05 IS NOT NULL
      AND (bmb04 <= g_today OR bmb04 IS NULL)
      AND (bmb05 >  g_today OR bmb05 IS NULL)
   IF l_cnt = 0 THEN 
      RETURN
   END IF
 
   DECLARE down_cs CURSOR FOR
    SELECT DISTINCT bmb03,imaicd10 
     FROM bma_file,bmb_file,ima_file,imaicd_file
     WHERE bmb03 = ima01
       AND ima01 = imaicd00
       AND bma01 = p_ima01
       AND bma01 = bmb01
       AND bma06 = bmb29
       AND bma05 <= g_today
       AND bma05 IS NOT NULL
       AND (bmb04 <= g_today OR bmb04 IS NULL)
       AND (bmb05 >  g_today OR bmb05 IS NULL)
 
   LET p_level = p_level + 1
   IF p_level > 20 THEN
      RETURN
   END IF
 
   LET l_i = 1
   FOREACH down_cs INTO l_bom[l_i].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH down_cs',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      LET l_i = l_i + 1
   END FOREACH
   CALL l_bom.deleteElement(l_i)
   LET l_cnt = l_i - 1
   FOR l_i = 1 TO l_cnt
      INSERT INTO q024_temp VALUES(l_bom[l_i].*)
 
      #撈取代料
      INSERT INTO q024_temp
      SELECT bmd04,imaicd10
        FROM bmd_file,ima_file,imaicd_file
       WHERE bmd04 = ima01
         AND ima01 = imaicd00
         AND bmd01 = l_bom[l_i].ima01
         AND bmd02 = '1'
         AND (bmd08 = 'ALL ' OR bmd08 = p_ima01)
         AND (bmd05 <= g_today)
         AND (bmd06 > g_today OR bmd06 IS NULL)
         AND bmdacti = 'Y'                                           #CHI-910021
 
      CALL q024_down(p_level,l_bom[l_i].ima01)
   END FOR
   
END FUNCTION
 
#順展BOM
FUNCTION q024_up(p_level,p_ima01)
   DEFINE p_ima01 LIKE ima_file.ima01,
          p_level LIKE type_file.num5
   DEFINE l_bom   DYNAMIC ARRAY OF RECORD
                  ima01    LIKE ima_file.ima01,
                  imaicd10 LIKE imaicd_file.imaicd10
                  END RECORD
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_i     LIKE type_File.num10
 
   SELECT COUNT(DISTINCT bma01)
     INTO l_cnt
     FROM bma_file,bmb_file,ima_file
    WHERE bma01 = ima01
      AND bmb03 = p_ima01
      AND bma01 = bmb01
      AND bma06 = bmb29
      AND bma05 <= g_today
      AND bma05 IS NOT NULL
      AND (bmb04 <= g_today OR bmb04 IS NULL)
      AND (bmb05 >  g_today OR bmb05 IS NULL)
   IF l_cnt = 0 THEN
      RETURN
   END IF
 
   DECLARE up_cs CURSOR FOR
    SELECT DISTINCT bma01,imaicd10
     FROM bma_file,bmb_file,ima_file,imaicd_file
     WHERE bma01 = ima01
       AND ima01 = imaicd00
       AND bmb03 = p_ima01
       AND bma01 = bmb01
       AND bma06 = bmb29
       AND bma05 <= g_today
       AND bma05 IS NOT NULL
       AND (bmb04 <= g_today OR bmb04 IS NULL)
       AND (bmb05 > g_today OR bmb05 IS NULL)
 
   LET p_level = p_level + 1
   IF p_level > 20 THEN
      RETURN
   END IF
   
   LET l_i = 1
   FOREACH up_cs INTO l_bom[l_i].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH up_cs',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      LET l_i = l_i + 1
   END FOREACH
   CALL l_bom.deleteElement(l_i)
   LET l_cnt = l_i - 1
 
   FOR l_i = 1 TO l_cnt
      INSERT INTO q024_temp VALUES(l_bom[l_i].*)
 
      #撈取代料
      INSERT INTO q024_temp
      SELECT bmd04,imaicd10
        FROM bmd_file,ima_file,imaicd_file
       WHERE bmd04 = ima01
         AND ima01 = imaicd00
         AND bmd01 = p_ima01
         AND bmd02 = '1'
         AND (bmd08 = 'ALL ' OR bmd08 = l_bom[l_i].ima01)
         AND (bmd05 <= g_today)
         AND (bmd06 > g_today OR bmd06 IS NULL)
         AND bmdacti = 'Y'                                           #CHI-910021
 
      CALL q024_up(p_level,l_bom[l_i].ima01)
   END FOR
   
END FUNCTION
 
FUNCTION q024_fill_2()
   DEFINE l_sfb02    LIKE type_file.num5
   DEFINE l_ima01    LIKE ima_file.ima01
   DEFINE l_imaicd10 LIKE imaicd_file.imaicd10
   DEFINE m_oeb12    LIKE oeb_file.oeb12
   DEFINE l_ima55_fac LIKE ima_file.ima55_fac
#  DEFINE l_ima26     LIKE ima_file.ima26          #FUN-A20044
#  DEFINE l_ima262    LIKE ima_file.ima262         #FUN-A20044
   DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3  #FUN-A20044
   DEFINE l_avl_stk   LIKE type_file.num15_3       #FUN-A20044      
   DEFINE l_unavl_stk LIKE type_file.num15_3       #FUN-A20044
   DEFINE qty_1       LIKE sfb_file.sfb08
   DEFINE qty_2       LIKE sfb_file.sfb08
   DEFINE qty_3       LIKE sfb_file.sfb08
   DEFINE qty_4       LIKE sfb_file.sfb08
   DEFINE qty_5       LIKE sfb_file.sfb08
   DEFINE qty_51      LIKE sfb_file.sfb08
   DEFINE qty_6       LIKE sfb_file.sfb08
   DEFINE qty_7       LIKE sfb_file.sfb08
#  DEFINE l_ima26_r   LIKE ima_file.ima26         #FUN-A20044   
#  DEFINE l_ima262_r  LIKE ima_file.ima262        #FUN-A20044
   DEFINE l_avl_stk_mpsmrp_r  LIKE type_file.num15_3   #FUN-A20044
   DEFINE l_avl_stk_r LIKE type_file.num15_3           #FUN-A20044       
   DEFINE qty_1_r     LIKE sfb_file.sfb08 
   DEFINE qty_2_r     LIKE sfb_file.sfb08
   DEFINE qty_3_r     LIKE sfb_file.sfb08
   DEFINE qty_4_r     LIKE sfb_file.sfb08
   DEFINE qty_5_r     LIKE sfb_file.sfb08
   DEFINE qty_51_r    LIKE sfb_file.sfb08
   DEFINE qty_6_r     LIKE sfb_file.sfb08
   DEFINE qty_7_r     LIKE sfb_file.sfb08
   DEFINE l_ima906    LIKE ima_file.ima906                #單位使用
   DEFINE l_rvb01     LIKE rvb_file.rvb01                 #收貨單號
   DEFINE l_rvb02     LIKE rvb_file.rvb02                 #收貨項次
   DEFINE l_sfb01     LIKE sfb_file.sfb01                 #工單單號
   DEFINE m_oeb915    LIKE oeb_file.oeb915
 
   DECLARE temp_cs CURSOR FOR
    SELECT DISTINCT ima01,imaicd10 FROM q024_temp
 
   FOREACH temp_cs INTO l_ima01,l_imaicd10
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH temp_cs',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
 
      #取得該料之單位使用設定值
      LET l_ima906 = ''
      SELECT ima906
        INTO l_ima906
        FROM ima_file
       WHERE ima01 = l_ima01
 
#      LET l_ima26 = 0     LET l_ima262 = 0                 #FUN-A20044
#      LET l_ima26_r = 0   LET l_ima262_r = 0               #FUN-A20044
      LET l_avl_stk_mpsmrp = 0 LET l_unavl_stk = 0  LET l_avl_stk = 0          #FUN-A20044
      LET l_avl_stk_mpsmrp_r = 0 LET l_avl_stk_r = 0                         #FUN-A20044
      #庫存可用量/庫存MRP可用量
#      SELECT ima26,ima262                  #FUN-A20044
#       INTO l_ima26,l_ima262               #FUN-A20044
#        FROM ima_file                      #FUN-A20044
#       WHERE ima01 = l_ima01               #FUN-A20044
#      IF cl_null(l_ima26) THEN             #FUN-A20044
#         LET l_ima26 = 0                   #FUN-A20044 
#      END IF                               #FUN-A20044
#      IF cl_null(l_ima262) THEN            #FUN-A20044
#         LET l_ima262 = 0                  #FUN-A20044
#      END IF                               #FUN-A20044

#FUN-A20044 ---start---  
      CALL s_getstock(l_ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   
      IF cl_null(l_avl_stk_mpsmrp) THEN
         LET l_avl_stk_mpsmrp = 0 
      END IF 
      IF cl_null(l_avl_stk ) THEN 
         LET l_avl_stk = 0 
      END IF 
#FUN-A20044 ---end---
 
      #庫存可用量的參考數量
      SELECT SUM(imgg10 * imgg21)
#        INTO l_ima26_r                    #FUN-A20044
        INTO l_avl_stk_mpsmrp_r            #FUN-A20044
        FROM imgg_file,img_file
       WHERE imgg01 = l_ima01
        #AND imgg23 = 'Y'
         AND imgg10 IS NOT NULL
         AND imgg21 IS NOT NULL
         AND imgg01 = img01                               #料
         AND imgg02 = img02                               #倉
         AND imgg03 = img03                               #儲
         AND imgg04 = img04                               #批
         AND img23 = 'Y'
#      IF cl_null(l_ima26_r) THEN      #FUN-A20044
#         LET l_ima26_r = 0            #FUN-A20044
#      END IF                          #FUN-A20044
#      IF l_ima906='1' THEN            #FUN-A20044  
#         LET l_ima26_r = ''           #FUN-A20044
#      END IF                          #FUN-A20044

#FUN-A20044 ---start---
      IF cl_null(l_avl_stk_mpsmrp_r) THEN
         LET l_avl_Stk_mpsmrp_r = 0
      END IF 
      IF l_ima906 = '1' THEN
         LET l_avl_stk_mpsmrp_r = ''
      END IF 
#FUN-A20044 ---end---
 
      #庫存MRP可用量的參考數量
      SELECT SUM(imgg10 * imgg21)
#        INTO l_ima262_r                           #FUN-A20044
        INTO l_avl_stk_r                           #FUN-A20044
        FROM imgg_file,img_file
       WHERE imgg01 = l_ima01
        #AND imgg23 = 'Y'
        #AND imgg24 = 'Y'
         AND imgg10 IS NOT NULL
         AND imgg21 IS NOT NULL
         AND imgg01 = img01                               #料
         AND imgg02 = img02                               #倉
         AND imgg03 = img03                               #儲
         AND imgg04 = img04                               #批
         AND img24 = 'Y'
#      IF cl_null(l_ima262_r) THEN      #FUN-A20044
#         LET l_ima262_r = 0            #FUN-A20044 
#      END IF                           #FUN-A20044
#      IF l_ima906='1' THEN             #FUN-A20044
#         LET l_ima262_r = ''           #FUN-A20044
#      END IF                           #FUN-A20044
#FUN-A20044 ---start---
     IF cl_null(l_avl_stk_r) THEN
        LET l_avl_stk_r = 0
     END IF 
     IF l_ima906 = '1' THEN
        LET l_avl_stk_r = ''
     END IF 
#FUN-A20044 ---end---
 
      CASE l_imaicd10                                     #料件之作業群組
           WHEN '1' #--(Wafer)
#                LET g_wafer.w_ima26 = g_wafer.w_ima26 + l_ima26                                      #FUN-A20044
#                LET g_wafer.w_ima262 = g_wafer.w_ima262 + l_ima262                                   #FUN-A20044 
#                LET g_wafer.w_ima26_r = g_wafer.w_ima26_r + l_ima26_r                                #FUN-A20044 
#                LET g_wafer.w_ima262_r = g_wafer.w_ima262_r + l_ima262_r                             #FUN-A20044
                LET g_wafer.w_avl_stk_mpsmrp = g_wafer.w_avl_stk_mpsmrp + l_avl_stk_mpsmrp            #FUN-A20044
                LET g_wafer.w_avl_stk = g_wafer.w_avl_stk+ l_avl_stk                                 #FUN-A20044
                LET g_wafer.w_avl_stk_mpsmrp_r = g_wafer.w_avl_stk_r + l_avl_stk_mpsmrp_r             #FUN-A20044
                LET g_wafer.w_avl_stk_r = g_wafer.w_avl_stk_r + l_avl_stk_r                           #FUN-A20044
           WHEN '2' #--(CP)
#                LET g_cp.c_ima26 = g_cp.c_ima26 + l_ima26                                            #FUN-A20044
#                LET g_cp.c_ima262 = g_cp.c_ima262 + l_ima262                                         #FUN-A20044
#                LET g_cp.c_ima26_r = g_cp.c_ima26_r + l_ima26_r                                      #FUN-A20044
#                LET g_cp.c_ima262_r = g_cp.c_ima262_r + l_ima262_r                                   #FUN-A20044
                LET g_cp.c_avl_stk_mpsmrp = g_cp.c_avl_stk_mpsmrp + l_avl_stk_mpsmrp                  #FUN-A20044
                LET g_cp.c_avl_stk = g_cp.c_avl_stk + l_avl_stk                                       #FUN-A20044
                LET g_cp.c_avl_stk_mpsmrp_r = g_cp.c_avl_Stk_mpsmrp_r + l_avl_stk_mpsmrp_r            #FUN-A20044
                LET g_cp.c_avl_stk_r = g_cp.c_avl_stk_r + l_avl_stk_r                                 #FUN-A20044  
           WHEN '3' #--(DS)
#                LET g_ds.d_ima26 = g_ds.d_ima26 + l_ima26                                            #FUN-A20044
#                LET g_ds.d_ima262 = g_ds.d_ima262 + l_ima262                                         #FUN-A20044
#                LET g_ds.d_ima26_r = g_ds.d_ima26_r + l_ima26_r                                      #FUN-A20044
#                LET g_ds.d_ima262_r = g_ds.d_ima262_r + l_ima262_r                                   #FUN-A20044
                LET g_ds.d_avl_stk_mpsmrp = g_ds.d_avl_stk_mpsmrp + l_avl_stk_mpsmrp                  #FUN-A20044
                LET g_ds.d_avl_stk = g_ds.d_avl_stk + l_avl_stk                                       #FUN-A20044
                LET g_ds.d_avl_stk_mpsmrp_r = g_ds.d_avl_stk_mpsmrp_r + l_avl_stk_mpsmrp_r            #FUN-A20044
                LET g_ds.d_avl_stk_r = g_ds.d_avl_stk_r + l_avl_stk_r                                 #FUN-A20044
           WHEN '4' #--(ASS)
#                LET g_ass.a_ima26 = g_ass.a_ima26 + l_ima26                                          #FUN-A20044
#                LET g_ass.a_ima262 = g_ass.a_ima262 + l_ima262                                       #FUN-A20044
#                LET g_ass.a_ima26_r = g_ass.a_ima26_r + l_ima26_r                                    #FUN-A20044
#                LET g_ass.a_ima262_r = g_ass.a_ima262_r + l_ima262_r                                 #FUN-A20044 
                LET g_ass.a_avl_stk_mpsmrp = g_ass.a_avl_stk_mpsmrp + l_avl_stk_mpsmrp                #FUN-A20044
                LET g_ass.a_avl_stk  = g_ass.a_avl_stk + l_avl_stk                                          #FUN-A20044
                LET g_ass.a_avl_stk_mpsmrp_r = g_ass.a_avl_stk_mpsmrp_r + l_avl_stk_mpsmrp_r          #FUN-A20044
                LET g_ass.a_avl_stk_r = g_ass.a_avl_stk_r + l_avl_stk_r                               #FUN-A20044
           WHEN '5' #--(FT)
#                LET g_ft.f_ima26 = g_ft.f_ima26 + l_ima26                                            #FUN-A20044
#                LET g_ft.f_ima262 = g_ft.f_ima262 + l_ima262                                         #FUN-A20044
#                LET g_ft.f_ima26_r = g_ft.f_ima26_r + l_ima26_r                                      #FUN-A20044
#                LET g_ft.f_ima262_r = g_ft.f_ima262_r + l_ima262_r                                   #FUN-A20044
                LET g_ft.f_avl_stk_mpsmrp = g_ft.f_avl_stk_mpsmrp + l_avl_stk_mpsmrp                  #FUN-A20044
                LET g_ft.f_avl_stk = g_ft.f_avl_stk + l_avl_stk                                       #FUN-A20044
                LET g_ft.f_avl_stk_mpsmrp_r = g_ft.f_avl_stk_mpsmrp_r + l_avl_stk_mpsmrp_r            #FUN-A20044
                LET g_ft.f_avl_stk_r = g_ft.f_avl_stk_r + l_avl_stk_r                                 #FUN-A20044
           WHEN '6' #--(TKY)
#                LET g_tky.t_ima26 = g_tky.t_ima26 + l_ima26                                          #FUN-A20044
#                LET g_tky.t_ima262 = g_tky.t_ima262 + l_ima262                                       #FUN-A20044
#                LET g_tky.t_ima26_r = g_tky.t_ima26_r + l_ima26_r                                    #FUN-A20044
#                LET g_tky.t_ima262_r = g_tky.t_ima262_r + l_ima262_r                                 #FUN-A20044
                LET g_tky.t_avl_stk_mpsmrp = g_tky.t_avl_stk_mpsmrp + l_avl_stk_mpsmrp                #FUN-A20044
                LET g_tky.t_avl_stk = g_tky.t_avl_stk + l_avl_stk                                           #FUN-A20044
                LET g_tky.t_avl_stk_mpsmrp_r = g_tky.t_avl_stk_mpsmrp_r + l_avl_stk_r                 #FUN-A20044
                LET g_tky.t_avl_stk_r  = g_tky.t_avl_stk_r + l_avl_stk_r                                     #FUN-A20044     
      END CASE
 
      LET m_oeb12 = 0
      LET m_oeb915 = 0
      #-->受訂量
      DECLARE q024_temp_bcs1 CURSOR FOR
       SELECT (oeb12 - oeb24 + oeb25 - oeb26) * oeb05_fac,(oeb915 / oeb12)
         FROM oeb_file,oea_file,occ_file
        WHERE oeb04 = l_ima01
          AND oeb01 = oea01
          AND occ01 = oea03
          AND oea00<>'0'
          AND oeb70 = 'N'
          AND oeb12 - oeb24 + oeb25 - oeb26 > 0
          AND oeaconf !='X'
        ORDER BY oeb15
 
      #-->在製量
      SELECT ima55_fac 
        INTO l_ima55_fac
        FROM ima_file
       WHERE ima01 = g_ima.ima01
      IF cl_null(l_ima55_fac) THEN
         LET l_ima55_fac = 1
      END IF
      DECLARE q024_temp_bcs2 CURSOR FOR
       SELECT (sfb08 - sfb09 - sfb10 - sfb11 - sfb12) * l_ima55_fac,(sfbiicd06 / sfb08)
         FROM sfb_file,OUTER gem_file
        WHERE sfb05 = l_ima01
          AND sfb04 !='8'
          AND sfb_file.sfb82 = gem_file.gem01
          AND sfb08 > (sfb09 + sfb10 + sfb11 + sfb12)
          AND sfb87!='X'
        ORDER BY sfb15
 
      #-->請購量
      DECLARE q024_temp_bcs3 CURSOR FOR
       SELECT (pml20 - pml21) * pml09,(pml83 / pml20)
         FROM pml_file,pmk_file,OUTER pmc_file
        WHERE pml04 = l_ima01
          AND pml01 = pmk01
          AND pmk_file.pmk09 = pmc_file.pmc01
          AND pml20 > pml21
          AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W')
          AND pml011 !='SUB'
          AND pmk18 != 'X'
        ORDER BY pml35
 
      #-->採購量
      DECLARE q024_temp_bcs4 CURSOR FOR
       SELECT (pmn20 - pmn50 + pmn55) * pmn09,(pmn85 / pmn20)
         FROM pmn_file, pmm_file,OUTER pmc_file
        WHERE pmn04 = l_ima01
          AND pmn01 = pmm01
          AND pmm_file.pmm09 = pmc_file.pmc01
          AND pmn20 - (pmn50 - pmn55) > 0
          AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
          AND pmn011 !='SUB'
          AND pmm18 != 'X'
        ORDER BY pmn33
 
      #-->IQC 在驗量
      DECLARE q024_temp_bcs5 CURSOR FOR
       SELECT (rvb07 - rvb29 - rvb30) * pmn09,rvb01,rvb02
         FROM rvb_file,rva_file,OUTER pmc_file,pmn_file
        WHERE rvb05 = l_ima01
          AND rvb01 = rva01
          AND rva_file.rva05 = pmc_file.pmc01
          AND rvb04 = pmn_file.pmn01
          AND rvb03 = pmn_file.pmn02
          AND rvb07 > (rvb29 + rvb30)
          AND rvaconf='Y'
          AND rva10 !='SUB'
        ORDER BY rva06
 
      #-->取得IQC 參考數量與檢驗量換算率
      DECLARE q024_temp_bcs5_r CURSOR FOR
       SELECT sum(qcs35 / qcs06)
         FROM rvb_file,rva_file,qcs_file,OUTER pmc_file,pmn_file
        WHERE rvb05 = l_ima01
          AND rvb01 = rva01
          AND rva_file.rva05 = pmc_file.pmc01
          AND rvb04 = pmn_file.pmn01
          AND rvb03 = pmn_file.pmn02
          AND rvb07 > (rvb29 + rvb30)
          AND rvaconf='Y'
          AND rva10 !='SUB'
          AND qcs01 = rvb01                               #收貨單號
          AND qcs02 = rvb02                               #收貨項次
          AND qcs14 != 'X'                                #未作廢
          AND rvb01 = l_rvb01
          AND rvb02 = l_rvb02
        ORDER BY rva06
 
      #-->FQC 在驗量
      DECLARE q024_temp_bcs51 CURSOR FOR
       SELECT sfb11,sfb01
         FROM sfb_file,OUTER gem_file
        WHERE sfb05 = l_ima01
          AND sfb02 <> '7'
          AND sfb87!='X'
          AND sfb04 <'8'
          AND sfb_file.sfb82=gem_file.gem01
          AND sfb11 > 0
 
      #-->取得FQC 參考數量與檢驗量換算率
      DECLARE q024_temp_bcs51_r CURSOR FOR
       SELECT SUM(qcf35 / qcf06 )
         FROM sfb_file,qcf_file,OUTER gem_file
        WHERE sfb05 = l_ima01
          AND sfb02 <> '7'
          AND sfb87!='X'
          AND sfb04 <'8'
          AND sfb_file.sfb82=gem_file.gem01
          AND sfb11 > 0
          AND qcf02 = sfb01                               #工單單號
          AND qcf14 != 'X'                                #未作廢之FQC單
          AND qcf06 > 0
          AND qcf02 = l_sfb01
 
      #-->備料量
      DECLARE q024_temp_bcs6 CURSOR FOR
       SELECT (sfa05 - sfa06 - sfa065) * sfa13,(sfaiicd01 / sfa05)
         FROM sfb_file,sfa_file,OUTER gem_file
        WHERE sfa03 = l_ima01
          AND sfb01 = sfa01
          AND sfb_file.sfb82 = gem_file.gem01
          AND sfb04 !='8'
          AND sfa05 > 0
          AND sfa05 > sfa06 + sfa065
          AND sfb87!='X'
        ORDER BY sfb13
 
      #-->銷售備置量
      SELECT SUM(oeb905 * oeb05_fac),SUM((oeb915 / oeb12) * (oeb905 * oeb05_fac))
        INTO m_oeb12,m_oeb915
        FROM oeb_file,oea_file,occ_file
       WHERE oeb04 = l_ima01
         AND oeb01 = oea01
         AND oea00 <>'0'
         AND oeb19 = 'Y'
         AND oeb70 = 'N'
         AND oeb12 > oeb24
         AND oea03=occ01
         AND oeaconf != 'X'
 
      IF cl_null(m_oeb12) THEN
         LET m_oeb12 = 0
      END IF
      IF cl_null(m_oeb915) THEN
         LET m_oeb915 = 0
      END IF
      LET qty_7 = m_oeb12
      LET qty_7_r = m_oeb915
      IF l_ima906 = '1' THEN
         LET qty_7_r = ''
      END IF
 
      CASE l_imaicd10
           WHEN '1' #--(Wafer)
                LET g_wafer.w_qty_7 = g_wafer.w_qty_7 + qty_7
           WHEN '2' #--(CP)
                LET g_cp.c_qty_7 = g_cp.c_qty_7 + qty_7
           WHEN '3' #--(DS)
                LET g_ds.d_qty_7 = g_ds.d_qty_7 + qty_7
           WHEN '4' #--(ASS)
                LET g_ass.a_qty_7 = g_ass.a_qty_7 + qty_7
           WHEN '5' #--(FT)
                LET g_ft.f_qty_7 = g_ft.f_qty_7 + qty_7
           WHEN '6' #--(TKY)
                LET g_tky.t_qty_7 = g_tky.t_qty_7 + qty_7
      END CASE
 
      FOREACH q024_temp_bcs1 INTO qty_1,qty_1_r
         IF STATUS THEN
            CALL cl_err('F1:',STATUS,1)
            EXIT FOREACH
         END IF
 
         IF cl_null(qty_1) THEN
            LET qty_1 = 0
         END IF
         IF cl_null(qty_1_r) THEN
            LET qty_1_r = 0
         END IF
 
         LET qty_1_r = qty_1_r * qty_1
         IF l_ima906 = '1' THEN
            LET qty_1_r = ''
         END IF
 
         CASE l_imaicd10
              WHEN '1' #--(Wafer)
                   LET g_wafer.w_qty_1 = g_wafer.w_qty_1 + qty_1
                   LET g_wafer.w_qty_1_r = g_wafer.w_qty_1_r + qty_1_r
              WHEN '2' #--(CP)
                   LET g_cp.c_qty_1 = g_cp.c_qty_1 + qty_1
                   LET g_cp.c_qty_1_r = g_cp.c_qty_1_r + qty_1_r
              WHEN '3' #--(DS)
                   LET g_ds.d_qty_1 = g_ds.d_qty_1 + qty_1
                   LET g_ds.d_qty_1_r = g_ds.d_qty_1_r + qty_1_r
              WHEN '4' #--(ASS)
                   LET g_ass.a_qty_1 = g_ass.a_qty_1 + qty_1
                   LET g_ass.a_qty_1_r = g_ass.a_qty_1_r + qty_1_r
              WHEN '5' #--(FT)
                   LET g_ft.f_qty_1 = g_ft.f_qty_1 + qty_1
                   LET g_ft.f_qty_1_r = g_ft.f_qty_1_r + qty_1_r
              WHEN '6' #--(TKY)
                   LET g_tky.t_qty_1 = g_tky.t_qty_1 + qty_1
                   LET g_tky.t_qty_1_r = g_tky.t_qty_1_r + qty_1_r
         END CASE
      END FOREACH
#---------------------------------------------------------------------------
      FOREACH q024_temp_bcs2 INTO qty_2,qty_2_r
         IF STATUS THEN
            CALL cl_err('F2:',STATUS,1)
            EXIT FOREACH
         END IF
 
         IF cl_null(qty_2) THEN
            LET qty_2 = 0
         END IF
         IF cl_null(qty_2_r) THEN
            LET qty_2_r = 0
         END IF
 
         LET qty_2_r = qty_2_r * qty_2
         IF l_ima906 = '1' THEN
            LET qty_2_r = ''
         END IF
 
         CASE l_imaicd10
              WHEN '1' #--(Wafer)
                   LET g_wafer.w_qty_2 = g_wafer.w_qty_2 + qty_2
                   LET g_wafer.w_qty_2_r = g_wafer.w_qty_2_r + qty_2_r
              WHEN '2' #--(CP)
                   LET g_cp.c_qty_2 = g_cp.c_qty_2 + qty_2
                   LET g_cp.c_qty_2_r = g_cp.c_qty_2_r + qty_2_r
              WHEN '3' #--(DS)
                   LET g_ds.d_qty_2 = g_ds.d_qty_2 + qty_2
                   LET g_ds.d_qty_2_r = g_ds.d_qty_2_r + qty_2_r
              WHEN '4' #--(ASS)
                   LET g_ass.a_qty_2 = g_ass.a_qty_2 + qty_2
                   LET g_ass.a_qty_2_r = g_ass.a_qty_2_r + qty_2_r
              WHEN '5' #--(FT)
                   LET g_ft.f_qty_2 = g_ft.f_qty_2 + qty_2
                   LET g_ft.f_qty_2_r = g_ft.f_qty_2_r + qty_2_r
              WHEN '6' #--(TKY)
                   LET g_tky.t_qty_2 = g_tky.t_qty_2 + qty_2
                   LET g_tky.t_qty_2_r = g_tky.t_qty_2_r + qty_2_r
         END CASE
      END FOREACH
#---------------------------------------------------------------------------
      FOREACH q024_temp_bcs3 INTO qty_3,qty_3_r
         IF STATUS THEN
            CALL cl_err('F3:',STATUS,1)
            EXIT FOREACH
         END IF
 
         IF cl_null(qty_3) THEN
            LET qty_3 = 0
         END IF
         IF cl_null(qty_3_r) THEN
            LET qty_3_r = 0
         END IF
 
         LET qty_3_r = qty_3_r * qty_3
         IF l_ima906 = '1' THEN
            LET qty_3_r = ''
         END IF
 
         CASE l_imaicd10
              WHEN '1' #--(Wafer)
                   LET g_wafer.w_qty_3 = g_wafer.w_qty_3 + qty_3
                   LET g_wafer.w_qty_3_r = g_wafer.w_qty_3_r + qty_3_r
              WHEN '2' #--(CP)
                   LET g_cp.c_qty_3 = g_cp.c_qty_3 + qty_3
                   LET g_cp.c_qty_3_r = g_cp.c_qty_3_r + qty_3_r
              WHEN '3' #--(DS)
                   LET g_ds.d_qty_3 = g_ds.d_qty_3 + qty_3
                   LET g_ds.d_qty_3_r = g_ds.d_qty_3_r + qty_3_r
              WHEN '4' #--(ASS)
                   LET g_ass.a_qty_3 = g_ass.a_qty_3 + qty_3
                   LET g_ass.a_qty_3_r = g_ass.a_qty_3_r + qty_3_r
              WHEN '5' #--(FT)
                   LET g_ft.f_qty_3 = g_ft.f_qty_3 + qty_3
                   LET g_ft.f_qty_3_r = g_ft.f_qty_3_r + qty_3_r
              WHEN '6' #--(TKY)
                   LET g_tky.t_qty_3 = g_tky.t_qty_3 + qty_3
                   LET g_tky.t_qty_3_r = g_tky.t_qty_3_r + qty_3_r
         END CASE
      END FOREACH
#---------------------------------------------------------------------------
      FOREACH q024_temp_bcs4 INTO qty_4,qty_4_r
         IF STATUS THEN
            CALL cl_err('F4:',STATUS,1)
            EXIT FOREACH
         END IF
 
         IF cl_null(qty_4) THEN
            LET qty_4 = 0
         END IF
         IF cl_null(qty_4_r) THEN
            LET qty_4_r = 0
         END IF
 
         LET qty_4_r = qty_4_r * qty_4
         IF l_ima906 = '1' THEN
            LET qty_4 = ''
         END IF
 
         CASE l_imaicd10
              WHEN '1' #--(Wafer)
                   LET g_wafer.w_qty_4 = g_wafer.w_qty_4 + qty_4
                   LET g_wafer.w_qty_4_r = g_wafer.w_qty_4_r + qty_4_r
              WHEN '2' #--(CP)
                   LET g_cp.c_qty_4 = g_cp.c_qty_4 + qty_4
                   LET g_cp.c_qty_4_r = g_cp.c_qty_4_r + qty_4_r
              WHEN '3' #--(DS)
                   LET g_ds.d_qty_4 = g_ds.d_qty_4 + qty_4
                   LET g_ds.d_qty_4_r = g_ds.d_qty_4_r + qty_4_r
              WHEN '4' #--(ASS)
                   LET g_ass.a_qty_4 = g_ass.a_qty_4 + qty_4
                   LET g_ass.a_qty_4_r = g_ass.a_qty_4_r + qty_4_r
              WHEN '5' #--(FT)
                   LET g_ft.f_qty_4 = g_ft.f_qty_4 + qty_4
                   LET g_ft.f_qty_4_r = g_ft.f_qty_4_r + qty_4_r
              WHEN '6' #--(TKY)
                   LET g_tky.t_qty_4 = g_tky.t_qty_4 + qty_4
                   LET g_tky.t_qty_4_r = g_tky.t_qty_4_r + qty_4_r
         END CASE
      END FOREACH
#---------------------------------------------------------------------------
      FOREACH q024_temp_bcs5 INTO qty_5,l_rvb01,l_rvb02
         IF STATUS THEN
            CALL cl_err('F5:',STATUS,1)
            EXIT FOREACH
         END IF
         #取得參考數量
         OPEN q024_temp_bcs5_r
         FETCH q024_temp_bcs5_r INTO qty_5_r
 
         IF cl_null(qty_5) THEN
            LET qty_5 = 0
         END IF
         IF cl_null(qty_5_r) THEN
            LET qty_5_r = 0
         END IF
 
         LET qty_5_r = qty_5_r * qty_5
         IF l_ima906 = '1' THEN
            LET qty_5_r = ''
         END IF
 
         CASE l_imaicd10
              WHEN '1' #--(Wafer)
                   LET g_wafer.w_qty_5 = g_wafer.w_qty_5 + qty_5
                   LET g_wafer.w_qty_5_r = g_wafer.w_qty_5_r + qty_5_r
              WHEN '2' #--(CP)
                   LET g_cp.c_qty_5 = g_cp.c_qty_5 + qty_5
                   LET g_cp.c_qty_5_r = g_cp.c_qty_5_r + qty_5_r
              WHEN '3' #--(DS)
                   LET g_ds.d_qty_5 = g_ds.d_qty_5 + qty_5
                   LET g_ds.d_qty_5_r = g_ds.d_qty_5_r + qty_5_r
              WHEN '4' #--(ASS)
                   LET g_ass.a_qty_5 = g_ass.a_qty_5 + qty_5
                   LET g_ass.a_qty_5_r = g_ass.a_qty_5_r + qty_5_r
              WHEN '5' #--(FT)
                   LET g_ft.f_qty_5 = g_ft.f_qty_5 + qty_5
                   LET g_ft.f_qty_5_r = g_ft.f_qty_5_r + qty_5_r
              WHEN '6' #--(TKY)
                   LET g_tky.t_qty_5 = g_tky.t_qty_5 + qty_5
                   LET g_tky.t_qty_5_r = g_tky.t_qty_5_r + qty_5_r
         END CASE
      END FOREACH
#---------------------------------------------------------------------------
      FOREACH q024_temp_bcs51 INTO qty_51,l_sfb01
         IF STATUS THEN
            CALL cl_err('F51:',STATUS,1)
            EXIT FOREACH
         END IF
 
         OPEN q024_temp_bcs51_r
         FETCH q024_temp_bcs51_r INTO qty_51_r
 
         IF cl_null(qty_51) THEN
            LET qty_51 = 0
         END IF
         IF cl_null(qty_51_r) THEN
            LET qty_51_r = 0
         END IF
 
         LET qty_51_r = qty_51_r * qty_51
         IF l_ima906 = '1' THEN
            LET qty_51_r = ''
         END IF
 
         CASE l_imaicd10
              WHEN '1' #--(Wafer)
                   LET g_wafer.w_qty_51 = g_wafer.w_qty_51 + qty_51
                   LET g_wafer.w_qty_51_r = g_wafer.w_qty_51_r + qty_51_r
              WHEN '2' #--(CP)
                   LET g_cp.c_qty_51 = g_cp.c_qty_51 + qty_51
                   LET g_cp.c_qty_51_r = g_cp.c_qty_51_r + qty_51_r
              WHEN '3' #--(DS)
                   LET g_ds.d_qty_51 = g_ds.d_qty_51 + qty_51
                   LET g_ds.d_qty_51_r = g_ds.d_qty_51_r + qty_51_r
              WHEN '4' #--(ASS)
                   LET g_ass.a_qty_51 = g_ass.a_qty_51 + qty_51
                   LET g_ass.a_qty_51_r = g_ass.a_qty_51_r + qty_51_r
              WHEN '51' #--(FT)
                   LET g_ft.f_qty_51 = g_ft.f_qty_51 + qty_51
                   LET g_ft.f_qty_51_r = g_ft.f_qty_51_r + qty_51_r
              WHEN '6' #--(TKY)
                   LET g_tky.t_qty_51 = g_tky.t_qty_51 + qty_51
                   LET g_tky.t_qty_51_r = g_tky.t_qty_51_r + qty_51_r
         END CASE
      END FOREACH
#---------------------------------------------------------------------------
      FOREACH q024_temp_bcs6 INTO qty_6,qty_6_r
         IF STATUS THEN
            CALL cl_err('F6:',STATUS,1)
            EXIT FOREACH
         END IF
 
         IF cl_null(qty_6) THEN
            LET qty_6 = 0
         END IF
         IF cl_null(qty_6_r) THEN
            LET qty_6_r = 0
         END IF
 
         LET qty_6_r = qty_6_r * qty_6
         IF l_ima906 = '1' THEN
            LET qty_6_r = ''
         END IF
 
         CASE l_imaicd10
              WHEN '1' #--(Wafer)
                   LET g_wafer.w_qty_6 = g_wafer.w_qty_6 + qty_6
                   LET g_wafer.w_qty_6_r = g_wafer.w_qty_6_r + qty_6_r
              WHEN '2' #--(CP)
                   LET g_cp.c_qty_6 = g_cp.c_qty_6 + qty_6
                   LET g_cp.c_qty_6_r = g_cp.c_qty_6_r + qty_6_r
              WHEN '3' #--(DS)
                   LET g_ds.d_qty_6 = g_ds.d_qty_6 + qty_6
                   LET g_ds.d_qty_6_r = g_ds.d_qty_6_r + qty_6_r
              WHEN '4' #--(ASS)
                   LET g_ass.a_qty_6 = g_ass.a_qty_6 + qty_6
                   LET g_ass.a_qty_6_r = g_ass.a_qty_6_r + qty_6_r
              WHEN '5' #--(FT)
                   LET g_ft.f_qty_6 = g_ft.f_qty_6 + qty_6
                   LET g_ft.f_qty_6_r = g_ft.f_qty_6_r + qty_6_r
              WHEN '6' #--(TKY)
                   LET g_tky.t_qty_6 = g_tky.t_qty_6 + qty_6
                   LET g_tky.t_qty_6_r = g_tky.t_qty_6_r + qty_6_r
         END CASE
      END FOREACH
   END FOREACH
 
END FUNCTION
 
#開窗詢問查詢何段
FUNCTION q024_ask_win()
   DEFINE l_sel   LIKE type_file.chr1 
   DEFINE l_ima01 LIKE ima_file.ima01 
   DEFINE l_str   STRING
 
   OPEN WINDOW q024_ask AT 2,2 WITH FORM "aic/42f/aicq024_ask"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("aicq024_ask")
 
   INPUT BY NAME l_sel WITHOUT DEFAULTS
 
      AFTER FIELD l_sel
         IF cl_null(l_sel) THEN
            NEXT FIELD l_sel
         END IF
         IF l_sel NOT MATCHES '[0123456]' THEN
            NEXT FIELD l_sel
         END IF
 
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
   
   IF NOT INT_FLAG THEN
      DECLARE temp_cs2 CURSOR FOR
       SELECT ima01 FROM q024_temp
        WHERE imaicd10 = ?
        
      IF l_sel = '0' THEN
         LET l_str = "\'",g_ima.ima01,"\'"
      ELSE
         OPEN temp_cs2 USING l_sel
         IF SQLCA.sqlcode THEN
            CALL cl_err('OPEN temp_cs2',SQLCA.sqlcode,0)
         ELSE
            FOREACH temp_cs2 USING l_sel INTO l_ima01
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FOREACH temp_cs2',SQLCA.sqlcode,0)
                  EXIT FOREACH
               END IF
               IF cl_null(l_str) THEN
                  LET l_str = "\'",l_ima01,"\'"
               ELSE
                  LET l_str = l_str CLIPPED,"\,\'",l_ima01,"\'"
               END IF
            END FOREACH
         END IF
      END IF
      
      IF NOT cl_null(l_str) THEN
         LET g_msg = 'aicq025 "',l_str,'"'
         CALL cl_cmdrun_wait(g_msg)
      ELSE
         CALL cl_err('','mfg3382',1)
      END IF
   END IF
   
   CLOSE WINDOW q024_ask
   
END FUNCTION
 
FUNCTION q024_temp()
 
   DROP TABLE q024_temp
 
   CREATE TEMP TABLE q024_temp(
          ima01    LIKE ima_file.ima01,
          imaicd10 LIKE imaicd_file.imaicd10)
 
   IF SQLCA.SQLCODE THEN
     CALL cl_err('cretmp',SQLCA.SQLCODE,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
   END IF
   
END FUNCTION
#No.FUN-7B0018 Create this program
