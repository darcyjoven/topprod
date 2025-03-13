# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: almi555.4gl
# Descriptions...: 会员积分规则设置作业
# Date & Author..: NO.FUN-960058 09/10/19 By destiny  
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:TQC-A10129 10/01/15 By shiwuying 卡種開窗加條件可積分
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60016 10/06/04 By houlia 輸入重負資料時，清空名稱欄位
# Modify.........: No.MOD-A60121 10/06/21 By Carrier SELECT tqa_file时没有给tqa03的值
# Modify.........: No.FUN-A70130 10/08/09 By huangtao 取消lrk_file所有相關資料
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-A80022 10/09/15 BY suncx add lrppos已傳POS否
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AB0025 10/11/10 By huangtao 增加after field 料號控管
# Modify.........: No.TQC-B10195 11/01/20 By Carrier lrp02='4'时,开窗会报 lib-307的错误
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60211 11/06/21 By huangtao 新增時，已傳pos未顯示
# Modify.........: No.FUN-B80060 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.FUN-B70075 11/10/26 By nanbing 更新已傳POS否的狀態
# Modify.........: No.FUN-BC0058 11/12/21 By yangxf 更改表字段
# Modify.........: No.FUN-BC0079 11/12/23 By yangxf 加入會員紀念日優惠積分
# Modify.........: No.FUN-BC0112 12/01/06 By yuhuabao 加入會員儲值加值促銷規則設定作業(almi558)
# Modify.........: No.TQC-C20534 12/02/29 By chenwei 删除的时候要把会员纪念日代码的资料一起删掉
# Modify.........: No.MOD-C30335 12/03/14 By nanbing "修改“時 更新 "lrp_file" BUG 的修改
# Modify.........: No.FUN-C40094 12/05/02 By pauline 新增會員紀念日前後區間設定
# Modify.........: No.FUN-C40084 12/04/28 By baogc 單身添加有效碼欄位
# Modify.........: No.FUN-C40109 12/05/04 By baogc 排除明細單身添加生效日期(lrr03)和失效日期(lrr04)字段
# Modify.........: No.FUN-C50036 12/05/31 By yangxf 如果aza88=Y， 已传pos否<>'1'，更改时把key值noentry
# Modify.........: No.FUN-C60056 12/06/21 By Lori 卡管理-卡積分、折扣、儲值加值規則功能優化
# Modify.........: No.FUN-C70003 12/07/03 By Lori 接續FUN-C60056功能
# Modify.........: No.FUN-C90046 12/09/11 By xumeimei 充值基准(lrq06)改为Key值
# Modify.........: No.FUN-CB0025 12/11/12 By yangxf pos状态及sql调整
# Modify.........: No.FUN-C90020 13/01/21 By Lori 優化發佈時寫資料的效能
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
 
DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-960058--begin
DEFINE g_lrp         RECORD LIKE lrp_file.*,
       g_lrp_t       RECORD LIKE lrp_file.*,
       g_lrp_o       RECORD LIKE lrp_file.*,     #FUN-C70003 add
       g_lrp01_t     LIKE lrp_file.lrp01,
       g_lrp06       LIKE lrp_file.lrp06,        #FUN-C60056 add
       g_lrp00       LIKE lrp_file.lrp00,
       g_lrq         DYNAMIC ARRAY OF RECORD
          lrq02      LIKE lrq_file.lrq02,
          lrq02_1    LIKE ima_file.ima02,
          lrq03      LIKE lrq_file.lrq03,
          lrq04      LIKE lrq_file.lrq04,
          lrq05      LIKE lrq_file.lrq05,
#FUN-BC0112 -----add-----begin
          lrq06      LIKE lrq_file.lrq06,
          lrq07      LIKE lrq_file.lrq07,
          lrq08      LIKE lrq_file.lrq08,
          lrq09      LIKE lrq_file.lrq09,   #FUN-C40084 Add ,
#FUN-BC0112 -----add-----end
          lrqacti    LIKE lrq_file.lrqacti  #FUN-C40084 Add
                     END RECORD,
       g_lrq_t       RECORD
          lrq02      LIKE lrq_file.lrq02,
          lrq02_1    LIKE ima_file.ima02,
          lrq03      LIKE lrq_file.lrq03,
          lrq04      LIKE lrq_file.lrq04,
          lrq05      LIKE lrq_file.lrq05,
#FUN-BC0112 -----add-----begin
          lrq06      LIKE lrq_file.lrq06,
          lrq07      LIKE lrq_file.lrq07,
          lrq08      LIKE lrq_file.lrq08,
          lrq09      LIKE lrq_file.lrq09,   #FUN-C40084 Add ,
#FUN-BC0112 -----add-----end
          lrqacti    LIKE lrq_file.lrqacti  #FUN-C40084 Add
                     END RECORD,
#FUN-BC0079 add begin-----
       g_lth         DYNAMIC ARRAY OF RECORD
          lth05      LIKE lth_file.lth05,
          lth05_desc LIKE lpc_file.lpc02,
          lth06      LIKE lth_file.lth06,
          lth11      LIKE lth_file.lth11,  #FUN-C40094 add
          lth12      LIKE lth_file.lth12,  #FUN-C40094 add
          lth15      LIKE lth_file.lth15,  #FUN-C60056 add
          lth16      LIKE lth_file.lth16,  #FUN-C60056 add
          lth17      LIKE lth_file.lth17,  #FUN-C60056 add
          lth18      LIKE lth_file.lth18,  #FUN-C60056 add
          lth19      LIKE lth_file.lth19,  #FUN-C60056 add
          lth20      LIKE lth_file.lth20,  #FUN-C60056 add
          lth07      LIKE lth_file.lth07,
          lth08      LIKE lth_file.lth08,
          lth09      LIKE lth_file.lth09,
          lth10      LIKE lth_file.lth10,      #FUN-C40084 Add ,
          lthacti    LIKE lth_file.lthacti     #FUN-C40084 Add
                     END RECORD,
       g_lth_t       RECORD
          lth05      LIKE lth_file.lth05,
          lth05_desc LIKE lpc_file.lpc02,
          lth06      LIKE lth_file.lth06,
          lth11      LIKE lth_file.lth11,  #FUN-C40094 add
          lth12      LIKE lth_file.lth12,  #FUN-C40094 add
          lth15      LIKE lth_file.lth15,  #FUN-C60056 add
          lth16      LIKE lth_file.lth16,  #FUN-C60056 add
          lth17      LIKE lth_file.lth17,  #FUN-C60056 add
          lth18      LIKE lth_file.lth18,  #FUN-C60056 add
          lth19      LIKE lth_file.lth19,  #FUN-C60056 add
          lth20      LIKE lth_file.lth20,  #FUN-C60056 add
          lth07      LIKE lth_file.lth07,
          lth08      LIKE lth_file.lth08,
          lth09      LIKE lth_file.lth09,
          lth10      LIKE lth_file.lth10,   #FUN-C40084 Add ,
          lthacti    LIKE lth_file.lthacti  #FUN-C40084 Add
                     END RECORD,
#FUN-BC0079 add end ---
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_wc3         STRING,                #FUN-BC0079  add
       g_rec_b       LIKE type_file.num5,
       g_rec_b1      LIKE type_file.num5,   #FUN-BC0079  add 
       g_str         LIKE type_file.chr1000,
       l_ac          LIKE type_file.num5,
       l_ac1         LIKE type_file.num5    #FUN-BC0079  add
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_void              LIKE type_file.chr1
#DEFINE g_kindtype         LIKE lrk_file.lrkkind     #FUN-A70130  mark
#DEFINE g_t1               LIKE lrk_file.lrkslip     #FUN-A70130  mark
DEFINE g_argv1             LIKE lrp_file.lrp00          
DEFINE g_argv2             LIKE lrp_file.lrp01           
DEFINE g_b_flag            STRING                    #FUN-BC0079  add 
DEFINE g_cb                ui.ComboBox               #FUN-BC0112 add
DEFINE g_lrppos            LIKE lrp_file.lrppos      #FUN-C50036
DEFINE g_ckmult            LIKE type_file.chr1       #FUN-C60056 add
DEFINE g_t1                LIKE oay_file.oayslip     #FUN-C60056 add
DEFINE g_gee02             LIKE gee_file.gee02       #FUN-C70003 add

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   LET g_argv1=ARG_VAL(1)                #虫沮摸
   LET g_argv2=ARG_VAL(2)                #虫沮絪腹

   IF cl_null(g_argv1) THEN LET g_argv1 = '1' END IF    #No.FUN-9B0136
   CASE g_argv1
        WHEN '1' LET g_prog = "almi555"
                 LET g_lrp00= "1" 
                 LET g_gee02= 'Q4'       #FUN-C70003 add
        WHEN '2' LET g_prog = "almi556"
                 LET g_lrp00= "2"
                 LET g_gee02= 'Q5'       #FUN-C70003 add
        WHEN '3' LET g_prog = "almi558"  #FUN-BC0112 add
                 LET g_lrp00= "3"        #FUN-BC0112 add
                 LET g_gee02= 'Q6'       #FUN-C70003 add
   END CASE

   LET g_lrp06 = g_plant                 #FUN-C60056 add
   LET g_lrp.lrp00=g_lrp00
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

#  LET g_forupd_sql = "SELECT * FROM lrp_file WHERE lrp00= ? AND lrp01 = ? FOR UPDATE "  #FUN-BC0079 MARK
#  LET g_forupd_sql = "SELECT * FROM lrp_file WHERE lrp00= ? AND lrp01 = ? AND lrp04 = ? AND lrp05 = ? FOR UPDATE "  #FUN-C60056 mark #FUN-BC0079 

   LET g_forupd_sql = "SELECT * FROM lrp_file WHERE lrp06= ? AND lrp07 = ? AND lrp08 = ? AND lrpplant = ? FOR UPDATE "   #FUN-C60056 add
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE i555_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i555_w WITH FORM "alm/42f/almi555"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #FUN-A80022 -------------------add start---------------------
   IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("lrppos",TRUE)
    ELSE
      CALL cl_set_comp_visible("lrppos",FALSE)
    END IF
    #FUN-A80022 -------------------add end by vealxu ---------------   

   IF g_argv1 = '1' THEN  #
      CALL cl_set_comp_visible("lrq05",FALSE)  
      CALL cl_set_comp_visible("lth10",FALSE)    #FUN-BC0079  add
      CALL cl_set_comp_visible("lrp11",FALSE)               #FUN-C60056 add
   END IF
   
   IF g_argv1 = '2' THEN  #
      CALL cl_set_comp_visible("lrq03,lrq04",FALSE)  
      CALL cl_set_comp_visible("lth07,lth08,lth09",FALSE)  #FUN-BC0079  add
      CALL cl_getmsg('alm1492',g_lang) RETURNING g_msg     #FUN-BC0079  add
      CALL cl_set_comp_att_text("lth06",g_msg CLIPPED)     #FUN-BC0079  add
      CALL cl_set_comp_visible("lrp11",TRUE)                #FUN-C60056 add
   END IF
#FUN-BC0112 -----add-----begin
   IF g_argv1 = '3' THEN
      LET g_cb = ui.ComboBox.forName("lrp02")
      CALL g_cb.clear()
      CALL cl_getmsg('art-774',g_lang) RETURNING g_msg
      CALL g_cb.addItem('1',"1:" || g_msg CLIPPED)
      CALL cl_getmsg('art-775',g_lang) RETURNING g_msg
      CALL g_cb.addItem('2',"2:" || g_msg CLIPPED)
      CALL cl_set_comp_visible("lrp03",FALSE)
      CALL cl_set_comp_visible("lrq03,lrq04,lrq05",FALSE)
      CALL cl_set_comp_visible("Folder1",FALSE)
      CALL cl_set_comp_visible("cn3,hl1",FALSE)
      CALL cl_set_act_visible("excludedetail",FALSE)
      CALL cl_set_comp_visible("lrp11",FALSE)               #FUN-C60056 add
   ELSE
      CALL cl_set_comp_visible("lrq06,lrq07,lrq08,lrq09",FALSE)
   END IF
   CALL cl_set_comp_entry("lrp00",FALSE)  #FUN-C60056 add
#FUN-BC0112 -----add-----end   
   IF NOT cl_null(g_argv2) THEN
      IF cl_chk_act_auth() THEN
         CALL i555_q()
      END IF
   ELSE
      CALL i555_menu()
   END IF
   CLOSE WINDOW i555_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i555_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

      CLEAR FORM
      CALL g_lrq.clear()
      CALL g_lth.clear()               #FUN-BC0079  add

   DISPLAY g_lrp00 TO lrp00            #FUN-BC0112 add
   CALL cl_set_comp_entry("lrp00",FALSE)  #FUN-C60056 add   

   IF NOT cl_null(g_argv2) THEN
      LET g_wc = " lrp01 = '",g_argv2,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lrp.* TO NULL
      CONSTRUCT BY NAME g_wc ON lrp06,lrp07,lrp08,                                     #FUN-C60056 add lrp06,lrp07,lrp08 
                                #lrp00,                                                #FUN-C60056 mark
                                lrp01,lrp04,lrp05,lrp02,lrp03,lrp11,                   #FUN-C60056 add lrp11   #FUN-A80022 add lrppos #FUN-BC0079 add lrp04,lrp05
                                lrppos,
                                lrpconf,lrpconu,lrpcond,lrp09,lrp10,                   #FUN-C60056 add
                                lrpuser,lrpmodu,lrpacti,lrpgrup,lrpdate,               #FUN-C60056 add
                                lrpcrat,lrporiu,lrporig                                #FUN-C60056 add
                                
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               #FUN-C60056 add begin---
               WHEN INFIELD(lrp06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                 #LET g_qryparam.arg1= g_lrp06    #FUN-C70003 mark
                  LET g_qryparam.form ="q_lrp02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrp06
                  NEXT FIELD lrp06
               #FUN-C60056 add end-----
               #FUN-C70003 add begin---
               WHEN INFIELD(lrp07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrp03"
                  LET g_qryparam.arg1 = g_lrp00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrp07
                  NEXT FIELD lrp07
               WHEN INFIELD(lrpconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrp04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrpconu
                  NEXT FIELD lrpconu
               #FUN-C70003 add end-----
               WHEN INFIELD(lrp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1= g_lrp00
                  LET g_qryparam.form ="q_lrp01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrp01
                  NEXT FIELD lrp01
                
               OTHERWISE EXIT CASE
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
   END IF 
   
   IF NOT cl_null(g_argv2) THEN
      LET g_wc2 = ' 1=1'
   ELSE
      CONSTRUCT g_wc2 ON lrq02,lrq03,lrq04,lrq05,
                        #lrq06,lrq07,lrq08,lrq09         #FUN-BC0112 add #FUN-C40084 Mark
                         lrq06,lrq07,lrq08,lrq09,lrqacti                 #FUN-C40084 Add
                    FROM s_lrq[1].lrq02,s_lrq[1].lrq03,
                         s_lrq[1].lrq04, s_lrq[1].lrq05,
                         s_lrq[1].lrq06,s_lrq[1].lrq07,  #FUN-BC0112 add
                        #s_lrq[1].lrq08,s_lrq[1].lrq09   #FUN-BC0112 add #FUN-C40084 Mark
                         s_lrq[1].lrq08,s_lrq[1].lrq09,s_lrq[1].lrqacti  #FUN-C40084 Add

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION controlp
            CASE
               WHEN INFIELD(lrq02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1= g_lrp00
                  LET g_qryparam.form ="q_lrq02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrq02
                  NEXT FIELD lrq02
               OTHERWISE EXIT CASE  
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
#FUN-BC0079  add -begin----
      IF g_argv1 = '3' THEN  #FUN-BC0112 add
         LET g_wc3 = ' 1=1'  #FUN-BC0112 add
      ELSE                   #FUN-BC0112 add
        #FUN-C40084 Mark&Add Begin ---
        #CONSTRUCT g_wc3 ON lth05,lth06,lth11,lth12,lth07,lth08,lth09,lth10  #FUN-C40094 add lth11,lth12
        #              FROM s_lth[1].lth05,s_lth[1].lth06,s_lth[1].lth11,s_lth[1].lth12,s_lth[1].lth07,  #FUN-C40094 add lth11, lth12
        #                   s_lth[1].lth08,s_lth[1].lth09,s_lth[1].lth10  

         CONSTRUCT g_wc3 ON lth05,lth06,lth11,lth12,
                            lth15,lth16,lth17,lth18,lth19,lth20,                                         #FUN-C60056 add
                            lth07,lth08,lth09,lth10,lthacti
                       FROM s_lth[1].lth05,s_lth[1].lth06,s_lth[1].lth11,s_lth[1].lth12,
                            s_lth[1].lth15,s_lth[1].lth16,s_lth[1].lth17,s_lth[1].lth18,s_lth[1].lth19,s_lth[1].lth20,   #FUN-C60056 add
                            s_lth[1].lth07,s_lth[1].lth08,s_lth[1].lth09,s_lth[1].lth10,s_lth[1].lthacti
        #FUN-C40084 Mark&Add End -----

            BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

            ON ACTION controlp
               CASE
                  WHEN INFIELD(lth05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_lth05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO lth05
                     NEXT FIELD lth05
                  OTHERWISE EXIT CASE
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
      END IF            #FUN-BC0112 add
      IF INT_FLAG THEN
         RETURN
      END IF
#FUN-BC0079  add -end----
   END IF
 
#FUN-C60056 mark begin---                         
#  LET g_wc2 = g_wc2 CLIPPED
#  IF g_wc3 = " 1=1" THEN   #FUN-BC0079  add ---
#     IF g_wc2 = " 1=1" THEN                  # 璝虫ōゼ块兵ン
#         LET g_sql = "SELECT lrp01,lrp04,lrp05 FROM lrp_file ",               #FUN-BC0079 add lrp04,lrp05
#                     " WHERE lrp00='",g_lrp00,"' AND ", g_wc CLIPPED,
#                     " ORDER BY lrp01"
#     ELSE                              # 璝虫ōΤ块兵ン
#         LET g_sql = "SELECT UNIQUE lrp01,lrp04,lrp05 ",                      #FUN-BC0079 add lrp04,lrp05
#                     "  FROM lrp_file, lrq_file ",
#                     " WHERE lrp00='",g_lrp00,"' AND lrp01 = lrq01",
#                     "   AND lrp00 = lrq00 AND lrp04 = lrq10 AND lrp05 = lrq11 ",   #FUN-BC0079 add   
#                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#                     " ORDER BY lrp01"
#     END IF
#  ELSE         #FUN-BC0079 add -------begin
#     IF g_wc2 = " 1=1" THEN   
#         LET g_sql = "SELECT lrp01,lrp04,lrp05 FROM lrp_file,lth_file ",    
#                     " WHERE lrp00='",g_lrp00,"' AND ", g_wc CLIPPED,
#                     "   AND lrp00 = lth01 AND lrp01 = lth02 AND lrp04 = lth03 AND lrp05 = lth04 ",               #FUN-BC0079 add   
#                     "   AND ",g_wc3 CLIPPED,                
#                     " ORDER BY lrp01"
#     ELSE           
#        LET g_sql = "SELECT UNIQUE lrp01,lrp04,lrp05 ",                   
#                    "  FROM lrp_file, lrq_file,lth_file ", 
#                    " WHERE lrp00='",g_lrp00,"' AND lrp01 = lrq01",
#                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#                    "   AND lrp00 = lrq00 AND lrp00 = lth01",                                        #FUN-BC0079 add   
#                    "   AND lrp04 = lrq10 AND lrp05 = lrq11 AND lrp04 = lth03 AND lrp05 = lth04 ",   #FUN-BC0079 add   
#                    "   AND lrp01 = lth02 AND ",g_wc3 CLIPPED,                                       
#                    " ORDER BY lrp01"
#     END IF
#  END IF       #FUN-BC0079  add end--- 
#FUN-C60056 mark end-----

  ##FUN-C60056 add begin---
  #LET g_sql = "SELECT lrp06,lrp07,lrp08,lrpplant ",
  #            "  FROM lrp_file LEFT JOIN lrq_file ON (lrp06 = lrq12 AND lrp07 = lrq13 AND lrpplant = lrqplant) ",
  #            "                LEFT JOIN lth_file ON (lrp06 = lth13 AND lrp07 = lth14 AND lrpplant = lthplant) ",
  #            " WHERE ", g_wc CLIPPED,
  #            "   AND ", g_wc2 CLIPPED,
  #            "   AND ", g_wc3 CLIPPED,
  #            "   AND lrpplant = '",g_plant,"' ",
  #            "   AND lrqplant = '",g_plant,"' ",
  #            "   AND lthplant = '",g_plant,"' " ,             
  #            " ORDER BY lrp07"
  ##FUN-C60056 add end-----

   #FUN-C70003 add begin---
   LET g_wc2 = g_wc2 CLIPPED
   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN              
          LET g_sql = "SELECT lrp06,lrp07,lrp08,lrpplant FROM lrp_file ",               
                      " WHERE lrpplant='",g_plant,"' AND ", g_wc CLIPPED,
                      "   AND lrp00 = '",g_lrp00,"' ",
                      " ORDER BY lrp07"
      ELSE                            
          LET g_sql = "SELECT UNIQUE lrp06,lrp07,lrp08,lrpplant ",                     
                      "  FROM lrp_file, lrq_file ",
                      " WHERE lrp06 = lrq12 AND lrp07 = lrq13 AND lrpplant = lrqplant",
                      "   AND lrpplant = '",g_plant,"' ",
                      "   AND lrqplant = '",g_plant,"' ",
                      "   AND lrp00 = '",g_lrp00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc2 CLIPPED,
                      " ORDER BY lrp07"
      END IF
   ELSE        
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT lrp06,lrp07,lrp08,lrpplant FROM lrp_file,lth_file ",
                      " WHERE lrp06 = lth13 AND lrp07 = lth14 AND lrpplant = lthplant",
                      "   AND lrpplant = '",g_plant,"' ",
                     #"   AND lrqplant = '",g_plant,"' ",    #FUN-C70003 mark
                      "   AND lthplant = '",g_plant,"' " ,
                      "   AND lrp00 = '",g_lrp00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc3 CLIPPED,
                      " ORDER BY lrp07"
      ELSE
         LET g_sql = "SELECT UNIQUE lrp06,lrp07,lrp08,lrpplant ",
                     "  FROM lrp_file, lrq_file,lth_file ",
                     " WHERE lrp06 = lrq12 AND lrp07 = lrq13 AND lrpplant = lrqplant",
                     "   AND lrp06 = lth13 AND lrp07 = lth14 AND lrpplant = lthplant",
                     "   AND lrpplant = '",g_plant,"' ",
                     "   AND lrqplant = '",g_plant,"' ",
                     "   AND lthplant = '",g_plant,"' ",
                     "   AND lrp00 = '",g_lrp00,"' ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY lrp07"
      END IF
   END IF       
   #FUN-C70003 add end-----

   PREPARE i555_prepare FROM g_sql
   DECLARE i555_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i555_prepare

#FUN-C60056 mark begin---
#  #FUN-BC0079  add ---
#  IF g_wc3 = " 1=1" THEN 
#     IF g_wc2 = " 1=1" THEN                  # 兵ン掸计
#        LET g_sql="SELECT COUNT(*) FROM lrp_file WHERE lrp00='",g_lrp00,"' and ",g_wc CLIPPED
#     ELSE
#        LET g_sql="SELECT COUNT(lrp01) FROM lrp_file,lrq_file WHERE ",           
#                  "lrp00=lrq00 and lrp01 = lrq01 and lrp00='",g_lrp00,"' AND  ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,       
#                  " AND lrp04 = lrq10 AND lrp05 = lrq11 "                                              #FUN-BC0079 add    
#     END IF
#  ELSE
#     IF g_wc2 = " 1=1" THEN                  # 兵ン掸计
#        LET g_sql="SELECT COUNT(lrp01) FROM lrp_file,lth_file WHERE lrp00='",g_lrp00,"' and ",g_wc CLIPPED," AND ",g_wc3 ,
#                  " AND lrp00 = lth01 AND lrp01 = lth02 AND lrp04 = lth03 AND lrp05 = lth04 "                             
#     ELSE
#        LET g_sql="SELECT COUNT(lrp01) FROM lrp_file,lrq_file,lth_file WHERE ",
#                  "lrp00=lrq00 and lrp00 = lth01 and lrp01 = lrq01 and lrp01 = lth02 ",                                        
#                  " AND lrp04 = lrq10 AND lrp05 = lrq11 AND lrp04 = lth03 AND lrp05 = lth04 ",                            
#                  " and lrp00='",g_lrp00,"' ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED                    
#     END IF
#  END IF      
#  #FUN-BC0079  add ---
#FUN-C60056 mark end---

  ##FUN-C60056 add begin---
  #LET g_sql = "SELECT COUNT(*) FROM ( SELECT DISTINCT lrp07 ",
  #            "  FROM lrp_file LEFT JOIN lrq_file ON (lrp06 = lrq12 AND lrp07 = lrq13 AND lrpplant = lrqplant) ",
  #            "                LEFT JOIN lth_file ON (lrp06 = lth13 AND lrp07 = lth14 AND lrpplant = lthplant) ",
  #            " WHERE ", g_wc CLIPPED,
  #            "   AND ", g_wc2 CLIPPED,
  #            "   AND ", g_wc3 CLIPPED,
  #            "   AND lrpplant = '",g_plant,"' ",
  #            "   AND lrqplant = '",g_plant,"' ",
  #            "   AND lthplant = '",g_plant,"' "," )" 
  ##FUN-C60056 add end-----

   #FUN-C70003 add begin---
   IF g_wc3 = " 1=1" THEN
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(*) FROM lrp_file ",
                      " WHERE lrpplant='",g_plant,"' AND ", g_wc CLIPPED,
                      "   AND lrp00 = '",g_lrp00,"' ",
                      " ORDER BY lrp07"
      ELSE
          LET g_sql = "SELECT COUNT(*) ",
                      "  FROM lrp_file, lrq_file ",
                      " WHERE lrp06 = lrq12 AND lrp07 = lrq13 AND lrpplant = lrqplant",
                      "   AND lrpplant = '",g_plant,"' ",
                      "   AND lrqplant = '",g_plant,"' ",
                      "   AND lrp00 = '",g_lrp00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc2 CLIPPED,
                      " ORDER BY lrp07"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN
          LET g_sql = "SELECT COUNT(*) lrp_file, lth_file",
                      " WHERE lrp06 = lth13 AND lrp07 = lth14 AND lrpplant = lthplant",
                      "   AND lrpplant = '",g_plant,"' ",
                      "   AND lrqplant = '",g_plant,"' ",
                      "   AND lthplant = '",g_plant,"' " ,
                      "   AND lrp00 = '",g_lrp00,"' ",
                      "   AND ", g_wc CLIPPED,
                      "   AND ", g_wc3 CLIPPED,
                      " ORDER BY lrp07"
      ELSE
         LET g_sql = "SELECT COUNT(*) ",
                     "  FROM lrp_file, lrq_file,lth_file ",
                     " WHERE lrp06 = lrq12 AND lrp07 = lrq13 AND lrpplant = lrqplant",
                     "   AND lrp06 = lth13 AND lrp07 = lth14 AND lrpplant = lthplant",
                     "   AND lrpplant = '",g_plant,"' ",
                     "   AND lrqplant = '",g_plant,"' ",
                     "   AND lthplant = '",g_plant,"' " ,
                     "   AND lrp00 = '",g_lrp00,"' ",
                     "   AND ", g_wc CLIPPED,
                     "   AND ", g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     " ORDER BY lrp07"
      END IF
   END IF
   #FUN-C70003 add end-----

   PREPARE i555_precount FROM g_sql
   DECLARE i555_count CURSOR FOR i555_precount
END FUNCTION

FUNCTION i555_menu()
DEFINE l_msg        LIKE type_file.chr1000
#DEFINE l_lrkdmy2    LIKE lrk_file.lrkdmy2     #FUN-A70130 mark
   WHILE TRUE
      CALL i555_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i555_a()
               #LET g_t1=s_get_doc_no(g_lrp.lrp01)
               #IF NOT cl_null(g_t1) THEN
               #   SELECT lrkdmy2
               #     INTO l_lrkdmy2
               #     FROM lrk_file
               #    WHERE lrkslip = g_t1  
               #   IF l_lrkdmy2 = 'Y' THEN
               #      CALL i555_confirm()
               #   END IF    
               #END IF                       
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i555_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               #IF cl_chk_mach_auth(g_lrp.lrpplant,g_plant) THEN
                  CALL i555_r()    
               #END IF 
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
                 #IF cl_chk_mach_auth(g_lrp.lrpplant,g_plant) THEN
                   CALL i555_u() 
                 #END IF
            END IF
            
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i555_copy()
            END IF
            
         WHEN "excludedetail"
            IF cl_chk_act_auth() THEN
               CALL i555_exclude_detail()
            END IF
                        
         WHEN "detail"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lrp.lrpplant,g_plant) THEN
                  IF g_b_flag IS NULL OR g_b_flag ='1' THEN    #FUN-BC0058 ADD 
                     CALL i555_b()
                  ELSE
                     CALL i555_b1()
                  END IF 
#               END IF 
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrq),'','')
            END IF

         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lrp.lrp01 IS NOT NULL THEN
                    #LET g_doc.column1 = "lrp01"      #FUN-C60056 mark
                    #LET g_doc.value1 = g_lrp.lrp01   #FUN-C60056 mark
                    #FUN-C60056 add begin---
                    LET g_doc.column1 = "lrp06"
                    LET g_doc.value1  = g_lrp.lrp06
                    LET g_doc.column2 = "lrp07"
                    LET g_doc.value2  = g_lrp.lrp07
                    LET g_doc.column3 = "lrp08"
                    LET g_doc.value3  = g_lrp.lrp08
                    LET g_doc.column4 = "lrpplant"
                    LET g_doc.value4  = g_lrp.lrpplant
                    #FIN-C60056 add end-----
                    CALL cl_doc()
                  END IF
              END IF
         
         #FUN-C60056 add begin---
          WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i555_x()
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i555_conf()
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i555_unconf()
            END IF

         WHEN "release"
            IF cl_chk_act_auth() THEN
               CALL i555_release()
            END IF           
         WHEN "eff_plant" 
            IF cl_chk_act_auth() THEN
               CALL i555_eff_plant()
            END IF 
         #FUN-C60056 add end-----
      END CASE
   END WHILE
   
   #FUN-C60056 add begin---
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
   END IF
   #FUN-C60056 add end-----
END FUNCTION

FUNCTION i555_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-BC0079 ---mark--- 
#   DISPLAY ARRAY g_lrq TO s_lrq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()
#
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#         
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
#
#      ON ACTION excludedetail
#         LET g_action_choice="excludedetail"
#         EXIT DISPLAY
#                  
#      ON ACTION first
#         CALL i555_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY
#
#      ON ACTION previous
#         CALL i555_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY
#
#      ON ACTION jump
#         CALL i555_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY
#
#      ON ACTION next
#         CALL i555_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY
#
#      ON ACTION last
#         CALL i555_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
#         ACCEPT DISPLAY
#
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()
#
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
#
#      ON ACTION cancel
#         LET INT_FLAG=FALSE
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#
#      ON ACTION related_document
#         LET g_action_choice="related_document"
#         EXIT DISPLAY
#
#   END DISPLAY
#FUN-BC0079 ---mark--- 
#FUN-BC0079 ---begin---
    DIALOG ATTRIBUTES(UNBUFFERED)
    DISPLAY ARRAY g_lrq TO s_lrq.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
          LET g_b_flag='1'
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()
    END DISPLAY

    DISPLAY ARRAY g_lth TO s_lth.* ATTRIBUTE(COUNT=g_rec_b1)
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
          LET g_b_flag='2'

       BEFORE ROW
          LET l_ac1 = ARR_CURR()
          CALL cl_show_fld_cont()
    END DISPLAY
    BEFORE DIALOG
       ON ACTION insert
          LET g_action_choice="insert"
          EXIT DIALOG 
 
       ON ACTION query
          LET g_action_choice="query"
          EXIT DIALOG 
 
       ON ACTION delete
          LET g_action_choice="delete"
          EXIT DIALOG 
 
       ON ACTION modify
          LET g_action_choice="modify"
          EXIT DIALOG 
 
       ON ACTION reproduce
          LET g_action_choice="reproduce"
          EXIT DIALOG 
 
       ON ACTION excludedetail
          LET g_action_choice="excludedetail"
          EXIT DIALOG 
 
       ON ACTION first
          CALL i555_fetch('F')
          CALL cl_navigator_setting(g_curs_index, g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DIALOG 
 
       ON ACTION previous
          CALL i555_fetch('P')
          CALL cl_navigator_setting(g_curs_index, g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DIALOG 
 
       ON ACTION jump
          CALL i555_fetch('/')
          CALL cl_navigator_setting(g_curs_index, g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DIALOG 
 
       ON ACTION next
          CALL i555_fetch('N')
          CALL cl_navigator_setting(g_curs_index, g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DIALOG 
 
       ON ACTION last
          CALL i555_fetch('L')
          CALL cl_navigator_setting(g_curs_index, g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DIALOG 
 
       ON ACTION detail
          LET g_action_choice="detail"
          LET l_ac = 1
          EXIT DIALOG 
 
       ON ACTION help
          LET g_action_choice="help"
          EXIT DIALOG 
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         #FUN-BC0112 -----add-----begin
          IF g_argv1 = '3' THEN
             CALL g_cb.clear()
             CALL cl_getmsg('art-774',g_lang) RETURNING g_msg
             CALL g_cb.addItem('1',"1:" || g_msg CLIPPED)
             CALL cl_getmsg('art-775',g_lang) RETURNING g_msg
             CALL g_cb.addItem('2',"2:" || g_msg CLIPPED)
          END IF
         #FUN-BC0112 -----add-----end

       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DIALOG 
 
       ON ACTION controlg
          LET g_action_choice="controlg"
          EXIT DIALOG 
 
       ON ACTION accept
          LET g_action_choice="detail"
          LET l_ac = ARR_CURR()
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

       #FUN-C60056 add begin---
       ON ACTION invalid
          LET g_action_choice="invalid"
          EXIT DIALOG

       ON ACTION confirm
          LET g_action_choice="confirm"
          EXIT DIALOG

       ON ACTION undo_confirm
          LET g_action_choice="undo_confirm"
          EXIT DIALOG

       ON ACTION release
          LET g_action_choice="release"
          EXIT DIALOG

       ON ACTION eff_plant
          LET g_action_choice="eff_plant" 
          EXIT DIALOG
       #FUN-C60056 add end-----

       AFTER DIALOG
          CONTINUE DIALOG
   END DIALOG
#FUN-BC0079 ---end ---
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i555_bp_refresh()
  #SELECT lrq_file.* INTO g_lrq.* FROM lrq_file 
  # WHERE lrq00=g_lrp00
  #   AND lrq01=g_lrp.lrp01
  DISPLAY ARRAY g_lrq TO s_lrq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

FUNCTION i555_a()
   DEFINE l_count     LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10 
   DEFINE l_rtz13     LIKE rtz_file.rtz13   #FUN-A80148 add
   DEFINE l_azt02     LIKE azt_file.azt02
   
   
   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'

   CALL g_lrq.clear()
   LET g_wc = NULL
   LET g_wc2= NULL

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lrp.* LIKE lrp_file.*
   LET g_lrp01_t = NULL
   #LET g_lrp.lrppos = 'N'            #FUN-A80022 add lrppos
   LET g_lrp.lrppos = '1'            #FUN-B40071  

   #FUN-BC0112 -----add-----begin
   IF g_argv1 = '3' THEN
      LET g_lrp.lrp02 = '1'
      LET g_lrp.lrp03 = '1'
   END IF
   #FUN-BC0112 -----add-----end

   #FUN-C60056 add begin---
   IF g_argv1 <> '2' THEN
      LET g_lrp.lrp11 = ' '
   ELSE
      LET g_lrp.lrp11 = '1'
   END IF
   LET g_lrp.lrp09    = 'N'
   LET g_lrp.lrpacti  = 'Y'
   LET g_lrp.lrpconf  = 'N'
   LET g_lrp.lrpcrat  = g_today
   LET g_lrp.lrpdate  = g_today
   LET g_lrp.lrpgrup  = g_grup
   LET g_lrp.lrplegal = g_legal
   LET g_lrp.lrpmodu  = g_user
   LET g_lrp.lrporig  = g_grup
   LET g_lrp.lrporiu  = g_user
   LET g_lrp.lrpplant = g_plant
   LET g_lrp.lrpuser  = g_user
   #FUN-C60056 add end-----

   LET g_lrp_t.* = g_lrp.*
   LET g_lrp.lrp00=g_lrp00
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL i555_i("a")                   #块虫繷
      IF INT_FLAG THEN
         INITIALIZE g_lrp.* TO NULL
         CALL g_lrq.clear()     #FUN-BC0079  add
         CALL g_lth.clear()     #FUN-BC0079  add
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_lrp.lrp01) THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK

      #FUN-C60056 add begin---
      #CALL s_auto_assign_no("alm",g_lrp.lrp07,g_today,"Q4","lrp_file","lrp01","","","")   #FUN-C70003 mark
      CALL s_auto_assign_no("alm",g_lrp.lrp07,g_today,g_gee02,"lrp_file","lrp01","","","")   #FUN-C70003 add
        RETURNING li_result,g_lrp.lrp07
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lrp.lrp07
      #FUN-C60056 add end-----       
      INSERT INTO lrp_file VALUES (g_lrp.*)
      IF SQLCA.sqlcode THEN                     #竚戈畐ぃΘ
      #   ROLLBACK WORK             # FUN-B80060---回滾放在報錯後---
         CALL cl_err3("ins","lrp_file",g_lrp.lrp07,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK              # FUN-B80060--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF

      SELECT lrp01 INTO g_lrp.lrp01 FROM lrp_file
       WHERE lrp00=g_lrp00 
         AND lrp01 = g_lrp.lrp01 
      LET g_lrp01_t = g_lrp.lrp01        #玂痙侣
      LET g_lrp_t.* = g_lrp.*
      CALL g_lrq.clear()
      CALL g_lth.clear()     #FUN-BC0079  add            
      LET g_rec_b = 0
      LET g_rec_b1 = 0       #FUN-BC0079  add
      CALL i555_b()                   #块虫ō
      IF g_argv1 != '3' THEN    #FUN-BC0112 add
         CALL i555_b1()         #FUN-BC0079  add
      END IF                    #FUN-BC0112 add
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION i555_u()
DEFINE   l_n     LIKE type_file.num5
DEFINE   l_lrppos        LIKE lrp_file.lrppos               #FUN-B70075

   IF s_shut(0) THEN
      RETURN
   END IF

  #FUN-C60056 mark begin---
  #IF  g_lrp.lrp01 IS NULL THEN
  #   CALL cl_err('',-400,0)
  #   RETURN
  #END IF
  #FUN-C60056 mark end---

   #FUN-C60056 add begin---
   CALL i555_msg('mod')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   #FUN-C60056 add end-----
  
   SELECT * INTO g_lrp.* FROM lrp_file
    WHERE lrp06 = g_lrp.lrp06        #FUN-C60056 add   
      AND lrp07 = g_lrp.lrp07        #FUN-C60056 add  
      AND lrp08 = g_lrp.lrp08        #FUN-C60056 add
      AND lrpplant = g_lrp.lrpplant  #FUN-C60056 add   
   #WHERE lrp00=g_lrp00              #FUN-C60056 mark                      
   #  AND lrp01=g_lrp.lrp01          #FUN-C60056 mark    
   #  AND lrp04 = g_lrp.lrp04        #FUN-C60056 mark  #FUN-BC0079  add
   #  AND lrp05 = g_lrp.lrp05        #FUN-C60056 mark  #FUN-BC0079  add

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lrp01_t = g_lrp.lrp01
#FUN-CB0025 mark begin ---
#   #FUN-B70075  Begin--------------
#    IF g_aza.aza88 = 'Y' THEN
#      #FUN-C40084 Add Begin ---
#       BEGIN WORK
#       #OPEN i555_cl USING g_lrp00,g_lrp.lrp01,g_lrp_t.lrp04,g_lrp_t.lrp05   #FUN-C60056 mark   #FUN-BC0079 add
#       OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant            #FUN-C60056 add
#       IF STATUS THEN
#          CALL cl_err("OPEN i555_cl:", STATUS, 1)
#          CLOSE i555_cl
#          ROLLBACK WORK
#          RETURN
#       END IF
#
#       FETCH i555_cl INTO g_lrp.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)
#          CLOSE i555_cl
#          ROLLBACK WORK
#          RETURN
#       END IF
#      #FUN-C40084 Add End -----
#
#       LET g_lrp_t.* = g_lrp.*
#       LET g_lrppos = g_lrp.lrppos #FUN-C50036
#       UPDATE lrp_file SET lrppos = '4'
#        WHERE lrp06 = g_lrp_t.lrp06                  #FUN-C60056 add
#          AND lrp07 = g_lrp_t.lrp07                  #FUN-C60056 add
#          AND lrp08 = g_lrp_t.lrp08                  #FUN-C60056 add
#          AND lrpplant = g_lrp_t.lrpplant            #FUN-C60056 add
#       #WHERE lrp00=g_lrp00 AND lrp01 = g_lrp01_t    #FUN-C60056 mark
#       #  AND lrp04=g_lrp_t.lrp04                    #FUN-C60056 mark        #FUN-BC0079  add
#       #  AND lrp05=g_lrp_t.lrp05                    #FUN-C60056 mark       #FUN-BC0079  add
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL cl_err3("upd","lrp_file",g_lrp01_t,"",SQLCA.sqlcode,"","",1)
#          ROLLBACK WORK  #FUN-C40084 Add
#          RETURN
#       END IF
#       LET g_lrp.lrppos = '4'
#       DISPLAY BY NAME g_lrp.lrppos
#       CLOSE i555_cl #FUN-C40084 Add
#       COMMIT WORK   #FUN-C40084 Add
#    END IF
#   #FUN-B70075  End ---------------   
#FUN-CB0025 mark end ---
   BEGIN WORK

   #OPEN i555_cl USING g_lrp00,g_lrp01_t,g_lrp_t.lrp04,g_lrp_t.lrp05   #FUN-C60056 mark   #FUN-BC0079 add lrp04,lrp05
   OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant           #FUN-C60056 add
   IF STATUS THEN
      CALL cl_err("OPEN i555_cl:", STATUS, 1)
      CLOSE i555_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i555_cl INTO g_lrp.*                      # 玛盢砆э┪戈
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)    # 戈砆LOCK
       CLOSE i555_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL i555_show()

   WHILE TRUE
      LET g_lrp01_t = g_lrp.lrp01

      CALL i555_i("u")                      #逆э

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lrp.*=g_lrp_t.*
        #FUN-CB0025 mark begin --- 
        ##FUN-B70075  Begin ---------
        # IF g_aza.aza88 = 'Y' THEN   #FUN-C50036
        #    LET g_lrp.lrppos = g_lrppos #FUN-C50036
        #    UPDATE lrp_file SET lrppos = g_lrp.lrppos
        #     WHERE lrp06 = g_lrp_t.lrp06                     #FUN-C60056 add   
        #       AND lrp07 = g_lrp_t.lrp07                     #FUN-C60056 add   
        #       AND lrp08 = g_lrp_t.lrp08                     #FUN-C60056 add      
        #       AND lrpplant = g_lrp_t.lrpplant               #FUN-C60056 add 
        #    #WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01     #FUN-C60056 mark
        #    #  AND lrp04 = g_lrp.lrp04    #FUN-BC0079  ADD   #FUN-C60056 mark      
        #    #  AND lrp05 = g_lrp.lrp05    #FUN-BC0079  ADD   #FUN-C60056 mark  
        #    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #       CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
        #       CONTINUE WHILE
        #    END IF
        #    DISPLAY BY NAME g_lrp.lrppos
        # END IF   #FUN-C50036
        ##FUN-B70075 End ------------         
        #FUN-CB0025 mark end ---
         CALL i555_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

         #FUN-CB0025 mark begin ---
         ##FUN-A80022 --------------add start--------------
         #IF g_aza.aza88 = 'Y' THEN
         #  #FUN-B40071 --START--  
         #   #LET g_lrp.lrppos = 'N'                          
         #  #FUN-B70075 Begin -----            
         #  #IF g_lrp.lrppos = '1' THEN
         #   IF g_lrppos = '1' THEN #FUN-C50036
         #  #FUN-B70075 End--------
         #      LET g_lrp.lrppos = '1'
         #   ELSE
         #      LET g_lrp.lrppos = '2'
         #   END IF              
         # #FUN-B40071 --END--              
         #   DISPLAY g_lrp.lrppos TO lrppos 
         #END IF
         ##FUN-A80022 ---------------add end------------------
         #FUN-CB0025 mark end ---
#        IF g_lrp.lrp01 != g_lrp01_t THEN            # э虫腹    #FUN-BC0079 MARK
        #FUN-C60056 mark begin---
        #IF g_lrp.lrp01 != g_lrp01_t                             #FUN-BC0079
        #   OR g_lrp_t.lrp04 != g_lrp.lrp04                      #FUN-BC0079
        #   OR g_lrp_t.lrp05 != g_lrp.lrp05 THEN                 #FUN-BC0079
        #   #MOD-C30335 STA
        #   SELECT COUNT(*) INTO l_n FROM lrq_file
        #    WHERE lrq00=g_lrp00
        #      AND lrq01 = g_lrp01_t
        #      AND lrq10 = g_lrp_t.lrp04                   
        #      AND lrq11 = g_lrp_t.lrp05                   
        #   IF l_n > 0 THEN 
        #   #MOD-C30335 END
        #FUN-C60056 mark end-----

        #FUN-C60056 add begin---
         IF g_lrp.lrp01 != g_lrp_t.lrp01
            OR g_lrp.lrp02 != g_lrp_t.lrp02
            OR  g_lrp.lrp03 != g_lrp_t.lrp03 
            OR g_lrp.lrp04 != g_lrp_t.lrp04 
            OR g_lrp_t.lrp05 != g_lrp.lrp05
            OR g_lrp_t.lrp11 != g_lrp.lrp11 THEN
     
            SELECT COUNT(*) INTO l_n FROM lrq_file
             WHERE lrq12 = g_lrp_t.lrp06
               AND lrq13 = g_lrp_t.lrp07
               AND lrqplant = g_lrp_t.lrpplant
          
            IF l_n > 0 THEN
        #FUN-C60056 add end-----

               UPDATE lrq_file SET lrq01 = g_lrp.lrp01,      
                                   lrq10 = g_lrp.lrp04,            #FUN-BC0079
                                   lrq11 = g_lrp.lrp05             #FUN-BC0079
                WHERE lrq12 = g_lrp_t.lrp06                        #FUN-C60056 add     
                  AND lrq13 = g_lrp_t.lrp07                        #FUN-C60056 add     
                  AND lrqplant = g_lrp_t.lrpplant                  #FUN-C60056 add 
               #WHERE lrq00=g_lrp00                                #FUN-C60056 mark 
               #  AND lrq01 = g_lrp01_t                            #FUN-C60056 mark   
               #  AND lrq10 = g_lrp_t.lrp04    #FUN-BC0079  ADD    #FUN-C60056 mark
               #  AND lrq11 = g_lrp_t.lrp05    #FUN-BC0079  ADD    #FUN-C60056 mark  
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","lrq_file",g_lrp01_t,"",SQLCA.sqlcode,"","lrq",1)
                  CONTINUE WHILE
               END IF
            END IF #MOD-C30335 add 

            #FUN-BC0079 add begin ---
            UPDATE lth_file SET lth02 = g_lrp.lrp01,
                                lth03 = g_lrp.lrp04,
                                lth04 = g_lrp.lrp05
            #WHERE lth01 = g_lrp00         #FUN-C60056 mark  
            #  AND lth02 = g_lrp01_t       #FUN-C60056 mark 
            #  AND lth03 = g_lrp_t.lrp04   #FUN-C60056 mark
            #  AND lth04 = g_lrp_t.lrp05   #FUN-C60056 mark
             WHERE lth13 = g_lrp_t.lrp06   #FUN-C60056 add
               AND lth14 = g_lrp_t.lrp07   #FUN-C60056 add
               AND lthplant = g_lrp_t.lrpplant   #FUN-C60056 add       
               
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","lth_file",g_lrp01_t,"",SQLCA.sqlcode,"","lth",1)
               CONTINUE WHILE
            END IF
            #FUN-BC0079 add end -----

            #FUN-C60056 add begin---
            UPDATE lrr_file SET lrr01 = g_lrp.lrp01,
                                lrr03 = g_lrp.lrp04,
                                lrr04 = g_lrp.lrp05
             WHERE lrr05 = g_lrp_t.lrp06
               AND lrr06 = g_lrp_t.lrp07
               AND lrrplant = g_lrp_t.lrpplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","lrr_file",g_lrp01_t,"",SQLCA.sqlcode,"","lth",1)
               CONTINUE WHILE
            END IF
            #FUN-C60056 add end-----
         END IF
      #END IF 
        #FUN-C40109 Mark&Add Begin ---
        #IF g_lrp.lrp01 != g_lrp01_t THEN
        #   UPDATE lrr_file SET lrr01=g_lrp.lrp01
        #    WHERE lrr00=g_lrp00
        #      AND lrr01=g_lrp01_t
        #END IF  

        #FUN-C60056 mark begin---
        #IF g_lrp.lrp01 != g_lrp01_t OR
        #   g_lrp_t.lrp04 != g_lrp.lrp04 OR
        #   g_lrp_t.lrp05 != g_lrp.lrp05 THEN
        #   UPDATE lrr_file SET lrr01 = g_lrp.lrp01,
        #                       lrr03 = g_lrp.lrp04,
        #                       lrr04 = g_lrp.lrp05
        #    WHERE lrr00 = g_lrp00
        #      AND lrr01 = g_lrp01_t
        #      AND lrr03 = g_lrp_t.lrp04
        #      AND lrr04 = g_lrp_t.lrp05
        #   IF SQLCA.sqlcode THEN
        #      CALL cl_err3("upd","lrr_file",g_lrp01_t,"",SQLCA.sqlcode,"","lth",1)
        #      CONTINUE WHILE
        #   END IF
        #END IF
        #FUN-C60056 mark end-----
        #FUN-C40109 Mark&Add End -----

        #FUN-C60056 mark begin--- 
        #UPDATE lrp_file SET lrp_file.* = g_lrp.*
        # WHERE lrp00=g_lrp00
        #   AND lrp01 = g_lrp01_t
        #   AND lrp04 = g_lrp_t.lrp04    #FUN-BC0079  ADD
        #   AND lrp05 = g_lrp_t.lrp05    #FUN-BC0079  ADD 
        #FUN-C60056 mark end-----

         #FUN-C60056 add begin---
          UPDATE lrp_file SET lrp_file.* = g_lrp.*
           WHERE lrp06 = g_lrp_t.lrp06
             AND lrp07 = g_lrp_t.lrp07
             AND lrp08 = g_lrp_t.lrp08
             AND lrpplant = g_lrp_t.lrpplant
         #FUN-C60056 add end-----
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lrp_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF     
      EXIT WHILE
   END WHILE

   CLOSE i555_cl
   COMMIT WORK
#FUN-BC0079 MARK ----   
#   SELECT COUNT(*) INTO l_n FROM lrq_file 
#    WHERE lrq00=g_lrp00
#      AND lrq01=g_lrp.lrp01
#      AND lrp04 = g_lrp.lrp04    #FUN-BC0079  ADD
#      AND lrp05 = g_lrp.lrp05    #FUN-BC0079  ADD
#   IF l_n=0 THEN 
#      CALL i555_b()
#      CALL i555_b1()     #FUN-BC0058  add
#   END IF 
#   CALL i555_b_fill("1=1")
#   CALL i555_b1_fill("1=1")     #FUN-BC0079  add
#   CALL i555_bp_refresh()
#FUN-BC0079 MARK ----	
END FUNCTION

FUNCTION i555_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1
DEFINE    li_result   LIKE type_file.num5
DEFINE    l_rtz13     LIKE rtz_file.rtz13  #FUN-A80148  add
DEFINE    l_rtz28     LIKE rtz_file.rtz28  #FUN-A80148  add
DEFINE    l_lph24     LIKE lph_file.lph24
DEFINE    l_lph03     LIKE lph_file.lph03
DEFINE    l_lmf03     LIKE lmf_file.lmf03
DEFINE    l_lmf04     LIKE lmf_file.lmf04
DEFINE    l_lni10     LIKE lni_file.lni10
DEFINE    l_azp02     LIKE azp_file.azp02  #FUN-C60056  add
#DEFINE    l_gee02     LIKE gee_file.gee02  #FUN-C60056 add   #FUN-C70003 mark

   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY g_lrp00 TO lrp00
   DISPLAY g_lrp.lrp02 TO lrp02     #FUN-BC0112 add

#  INPUT BY NAME g_lrp.lrp01,g_lrp.lrp02,g_lrp.lrp03  #FUN-BC0079 mark 
   INPUT BY NAME g_lrp.lrp07,g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05,g_lrp.lrp02,g_lrp.lrp03,g_lrp.lrp11,   #FUN-C70003 add lrp11   #FUN-C60056 add lrp07   #FUN-BC0079
                 g_lrp.lrpuser,g_lrp.lrpmodu,g_lrp.lrpacti,g_lrp.lrpgrup,g_lrp.lrpdate,g_lrp.lrpcrat,   #FUN-C70003 add
                 g_lrp.lrporiu,g_lrp.lrporig                                                            #FUN-C70003 add 
           WITHOUT DEFAULTS

      BEFORE INPUT
        #NO.FUN-B40071 --STATR--
         #LET g_lrp.lrppos = 'N'          #NO.FUN-A80022 已傳POS否的值為'N'
        #FUN-B70075 Begin Mark-----
        #IF g_lrp.lrppos = '1' THEN
        #   LET g_lrp.lrppos = '1'
        #ELSE
        #   LET g_lrp.lrppos = '2'
        #END IF
        #NO.FUN-B40071 --END--
        #FUN-B70075 End Mark-------
         DISPLAY BY NAME g_lrp.lrppos                    #TQC-B60211 add
         LET g_before_input_done = FALSE
         CALL i555_set_entry(p_cmd)
         CALL i555_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

         #FUN-C60056 add begin---
         #FUN-C70003 mark begin---
         #CASE
         #   WHEN g_argv1 = '1'
         #      LET l_gee02 = 'Q4'
         #   WHEN g_argv1 = '2'
         #      LET l_gee02 = 'Q5'
         #   WHEN g_argv1 = '3'
         #      LET l_gee02 = 'Q6'
         #END CASE
         #FUN-C70003 mark end---
         
         LET g_lrp.lrp06 = g_plant                                      
         SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_plant  
         DISPLAY BY NAME g_lrp.lrp06                                    
         DISPLAY l_azp02 TO azp02
                                             
         #FUN-C60056 add end-----
         

      AFTER FIELD lrp07
         IF NOT cl_null(g_lrp.lrp07) THEN
            #CALL s_check_no("alm",g_lrp.lrp07,g_lrp.lrp07,l_gee02,"lrp_file","lrp07","")    #FUN-C70003 mark
            CALL s_check_no("alm",g_lrp.lrp07,g_lrp.lrp07,g_gee02,"lrp_file","lrp07","")    #FUN-C70003  add
                 RETURNING li_result,g_lrp.lrp07
            IF (NOT li_result) THEN
               LET g_lrp.lrp07 = g_lrp_t.lrp01
               NEXT FIELD lrp07
            END IF
            LET g_t1=s_get_doc_no(g_lrp.lrp01)
            LET g_lrp.lrp08 = 0
            DISPLAY g_lrp.lrp08 TO lrp08
         END IF

      AFTER FIELD lrp01
       IF NOT cl_null(g_lrp.lrp01) THEN
          IF p_cmd='a' OR (p_cmd='u' AND g_lrp.lrp01 != g_lrp_t.lrp01) THEN     
             CALL i555_lrp01('a',g_lrp.lrp01)
             IF NOT cl_null(g_errno) THEN 
                CALL cl_err('',g_errno,1)
                LET g_lrp.lrp01=g_lrp_t.lrp01
                NEXT FIELD lrp01
             ELSE 
                IF NOT cl_null(g_lrp.lrp04) AND NOT cl_null(g_lrp.lrp05) THEN    #FUN-BC0079 add IF 
                   SELECT COUNT(*) INTO l_n 
                     FROM lrp_file 
                    WHERE lrp00=g_lrp00 
                      AND lrp01=g_lrp.lrp01
                   #FUN-BC0079 add begin---
                      AND (lrp04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                       OR  lrp05 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                       OR  g_lrp.lrp04 BETWEEN lrp04 AND lrp05)
                   #FUN-BC0079 add end --- 
                   #FUN-C70003 add begin---
                      AND lrp09 = 'Y'
                      AND lrpconf = 'Y'
                      AND lrpacti = 'Y'
                   #FUN-C70003 add end-----  
                   IF l_n>0 THEN 
   #                  CALL cl_err('','-239',1)          #FUN-BC0079   mark
                      CALL cl_err('','alm1519',1)       #FUN-BC0079
                      LET g_lrp.lrp01=g_lrp_t.lrp01  
   #TQC-A60016 --add
                     DISPLAY '' TO FORMONLY.lph02
   #TQC-A60016 --end
                      NEXT FIELD lrp01
                   END IF              	     
                END IF         #FUN-BC0079 add END IF 
             END IF 
          END IF      
       ELSE 
       	  DISPLAY '' TO FORMONLY.lph02     
       END IF
      
      #FUN-C60056 add begin---
       ON CHANGE lrp01
          CALL i555_ckmult()
          #FUN-C70003 mark begin---
          #IF g_ckmult = 'Y' THEN
          #   CALL cl_err('','alm-h58',0)
          #   RETURN
          #END IF
          #FUN-C70003 mark end-----
          IF g_success = 'N' THEN RETURN END IF #FUN-C70003 add
      #FUN-C60056 add end-----

      AFTER FIELD lrp02 
       IF p_cmd='u' AND g_lrp.lrp02 != g_lrp_t.lrp02 THEN 
          IF NOT cl_confirm('alm-816') THEN 
             LET g_lrp.lrp02=g_lrp_t.lrp02
          ELSE 
             DELETE FROM lrq_file
              WHERE lrq12 = g_lrp.lrp06         #FUN-C60056 add      
                AND lrq13 = g_lrp.lrp07         #FUN-C60056 add 
                AND lrqplant = g_lrp.lrpplant   #FUN-C60056 add 
             #WHERE lrq00 = g_lrp00             #FUN-C60056 mark 
             #  AND lrq01 = g_lrp.lrp01         #FUN-C60056 mark  
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lrq_file",g_lrp.lrp01,g_lrp00,SQLCA.sqlcode,"","",1)
              ELSE 
              	# INITIALIZE g_lrq[l_ac].* TO NULL 
              	#LET g_rec_b=0
                CALL g_lrq.clear()
                CALL i555_b_fill(g_wc2)
                CALL i555_bp_refresh()
              # CALL i555_b_fill(g_wc2)
              END IF             
          END IF     
       END IF    
      
      AFTER FIELD lrp03
       IF g_lrp_t.lrp03 !='1' THEN 
          IF p_cmd='u' AND g_lrp.lrp03 != g_lrp_t.lrp03 THEN 
             IF NOT cl_confirm('alm-817') THEN 
                LET g_lrp.lrp03=g_lrp_t.lrp03
             ELSE 
             	 DELETE FROM lrr_file
                  WHERE lrr05 = g_lrp.lrp06         #FUN-C60056 add    
                    AND lrr06 = g_lrp.lrp07         #FUN-C60056 add  
                    AND lrrplant = g_lrp.lrpplant   #FUN-C60056 add
                 #WHERE lrr00 = g_lrp00        #FUN-C60056 mark
                 #  AND lrr01 = g_lrp.lrp01    #FUN-C60056 mark
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","lrr_file",g_lrp.lrp01,g_lrp00,SQLCA.sqlcode,"","",1)
                 END IF          
             END IF                         
          END IF   
       END IF                
       
#FUN-BC0079  begin ---
       AFTER FIELD lrp04
          IF NOT cl_null(g_lrp.lrp04) THEN
             IF NOT cl_null(g_lrp.lrp05) THEN
                IF g_lrp.lrp04 > g_lrp.lrp05 THEN
                   CALL cl_err('','art-711',0)                      #失效日期不可小于生效日期
                   LET g_lrp.lrp04=g_lrp_t.lrp04
                   NEXT FIELD lrp04
                END IF
             END IF
             IF p_cmd='a' OR (p_cmd='u' AND g_lrp.lrp04 != g_lrp_t.lrp04) THEN
                IF NOT cl_null(g_lrp.lrp01) AND NOT cl_null(g_lrp.lrp05) THEN
                   IF p_cmd = 'a' THEN   
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  lrp05 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  g_lrp.lrp04 BETWEEN lrp04 AND lrp05)
                       #FUN-c70003 add begin---
                         AND lrp09 = 'Y'
                         AND lrpconf = 'Y'
                         AND lrpacti = 'Y'
                       #FUN-C70003 add end-----
                   ELSE 
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  lrp05 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  g_lrp.lrp04 BETWEEN lrp04 AND lrp05)
                         AND lrp04 <> g_lrp_t.lrp04
                         AND lrp05 <> g_lrp_t.lrp05
                       #FUN-C70003 add begin---
                         AND lrp09 = 'Y'
                         AND lrpconf = 'Y'
                         AND lrpacti = 'Y'
                       #FUN-C70003 add end-----
                   END IF 
                   IF l_n>0  THEN
                      CALL cl_err('','alm1519',1)
                      LET g_lrp.lrp04=g_lrp_t.lrp04
                      NEXT FIELD lrp04
                   END IF
                END IF       
             END IF                 
          END IF 

       #FUN-C60056 add begin---
       ON CHANGE lrp04
          CALL i555_ckmult()
          #FUN-C70003 mark begin---
          #IF g_ckmult = 'Y' THEN
          #   CALL cl_err('','alm-h58',0)
          #   RETURN
          #END IF
          #FUN-C70003 mark end-----
           IF g_success = 'N' THEN RETURN END IF #FUN-C70003 add
       #FUN-C60056 add end-----
            
       AFTER FIELD lrp05
          IF NOT cl_null(g_lrp.lrp05) THEN
             IF NOT cl_null(g_lrp.lrp04) THEN 
                IF g_lrp.lrp04 > g_lrp.lrp05 THEN
                   CALL cl_err('','art-711',0)                      #失效日期不可小于生效日期
                   LET g_lrp.lrp05=g_lrp_t.lrp05
                   NEXT FIELD lrp05 
                END IF  
             END IF 
             IF p_cmd='a' OR (p_cmd='u' AND g_lrp.lrp05 != g_lrp_t.lrp05) THEN
                IF NOT cl_null(g_lrp.lrp01) AND NOT cl_null(g_lrp.lrp04) THEN    
                   IF p_cmd = 'a' THEN 
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  lrp05 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  g_lrp.lrp04 BETWEEN lrp04 AND lrp05)
                       #FUN-C70003 add begin---
                         AND lrp09 = 'Y'
                         AND lrpconf = 'Y'
                         AND lrpacti = 'Y'
                       #FUN-C70003 add end-----
                   ELSE 
                      SELECT COUNT(*) INTO l_n
                        FROM lrp_file
                       WHERE lrp00=g_lrp00
                         AND lrp01=g_lrp.lrp01
                         AND (lrp04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  lrp05 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                          OR  g_lrp.lrp04 BETWEEN lrp04 AND lrp05)
                         AND lrp04 <> g_lrp_t.lrp04
                         AND lrp05 <> g_lrp_t.lrp05
                       #FUN-C70003 add begin---
                         AND lrp09 = 'Y'
                         AND lrpconf = 'Y'
                         AND lrpacti = 'Y'
                       #FUN-C70003 add end----- 
                   END IF 
                   IF l_n>0 THEN
                      CALL cl_err('','alm1519',1)
                      LET g_lrp.lrp05=g_lrp_t.lrp05
                      NEXT FIELD lrp05
                   END IF
                END IF         
             END IF
          END IF

#FUN-BC0079  end ---

      #FUN-C60056 add begin---
      ON CHANGE lrp05
          CALL i555_ckmult()
          #FUN-C70003 mark begin---
          #IF g_ckmult = 'Y' THEN
          #   CALL cl_err('','alm-h58',0)
          #END IF
          #FUN-C70003 mark end-----
           IF g_success = 'N' THEN RETURN END IF #FUN-C70003 add

      #FUN-C60056 add end-----

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION controlp
         CASE
            #FUN-C60056 add begin---
            WHEN INFIELD(lrp07)
               LET g_t1 = s_get_doc_no(g_lrp.lrp01)
               #CALL q_oay(FALSE,FALSE,'',l_gee02,'ALM') RETURNING g_t1   #FUN-C70003 mark
               CALL q_oay(FALSE,FALSE,'',g_gee02,'ALM') RETURNING g_t1   #FUN-C70003 add
               LET g_lrp.lrp07 = g_t1
               DISPLAY BY NAME g_lrp.lrp07
               NEXT FIELD lrp07
            #FUN-C60056 add end-----
            WHEN INFIELD(lrp01)    
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lph1"
              #No.TQC-A10129 -BEGIN-----
               IF g_lrp.lrp00 = '1' THEN
                  LET g_qryparam.where = " lph06 = 'Y' "
               END IF
              #No.TQC-A10129 -END-------
               LET g_qryparam.default1 = g_lrp.lrp01
               CALL cl_create_qry() RETURNING g_lrp.lrp01
               DISPLAY BY NAME g_lrp.lrp01
               NEXT FIELD lrp01
            OTHERWISE EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

END FUNCTION

FUNCTION i555_lrp01(p_cmd,l_lph01)
 DEFINE  p_cmd       LIKE type_file.chr1
 DEFINE  l_lph01     LIKE lph_file.lph01
 DEFINE  l_lph02     LIKE lph_file.lph02
 DEFINE  l_lph24     LIKE lph_file.lph24
 DEFINE  l_lph06     LIKE lph_file.lph06 #No.TQC-A10129

   LET g_errno=''
   SELECT lph02,lph24,lph06 INTO l_lph02,l_lph24,l_lph06  #No.TQC-A10129
     FROM lph_file WHERE lph01=l_lph01
   CASE WHEN SQLCA.sqlcode=100 LET g_errno = 'anm-027' 
                               LET l_lph02 = NULL
        WHEN l_lph24 != 'Y'    LET g_errno = '9029'
        WHEN l_lph06 <> 'Y' AND g_lrp.lrp00 = '1'      #No.TQC-A10129
                               LET g_errno = 'alm-829' #No.TQC-A10129
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
     
   IF cl_null(g_errno) OR p_cmd= 'd' THEN
      DISPLAY l_lph02 TO FORMONLY.lph02
   END IF 
END FUNCTION

FUNCTION i555_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lrq.clear()
   CALL g_lth.clear()    #FUN-BC0079
   DISPLAY ' ' TO FORMONLY.cnt

   DISPLAY g_lrp00 TO lrp00    #FUN-C60056 add
   CALL cl_set_comp_entry("lrp00",FALSE)  #FUN-C60056 add

   CALL i555_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lrp.* TO NULL
      RETURN
   END IF

   OPEN i555_cs                            # 眖DB玻ネ兵ンTEMP(0-30)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lrp.* TO NULL
   ELSE
      OPEN i555_count
      FETCH i555_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i555_fetch('F')                  # 弄TEMP材掸陪ボ
   END IF

END FUNCTION

FUNCTION i555_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #矪瞶よΑ

   CASE p_flag
     #FUN-C60056 mark begin---
     #WHEN 'N' FETCH NEXT     i555_cs INTO g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05    #FUN-BC0079  add lrp04,lrp05
     #WHEN 'P' FETCH PREVIOUS i555_cs INTO g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05    #FUN-BC0079  add lrp04,lrp05
     #WHEN 'F' FETCH FIRST    i555_cs INTO g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05    #FUN-BC0079  add lrp04,lrp05
     #WHEN 'L' FETCH LAST     i555_cs INTO g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05    #FUN-BC0079  add lrp04,lrp05
     #FUN-C60056 mark end-----

     #FUN-C60056 add begin---
      WHEN 'N' FETCH NEXT     i555_cs INTO g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant     
      WHEN 'P' FETCH PREVIOUS i555_cs INTO g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant    
      WHEN 'F' FETCH FIRST    i555_cs INTO g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant    
      WHEN 'L' FETCH LAST     i555_cs INTO g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant    
     #FUN-C60056 add end-----
      WHEN '/'
            IF (NOT g_no_ask) THEN
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
                   EXIT CASE
                END IF
            END IF
           #FETCH ABSOLUTE g_jump i555_cs INTO g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05    #FUN-BC0079  add lrp04,lrp05   #FUN-C60056 mark
            FETCH ABSOLUTE g_jump i555_cs INTO g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant                    #FUN-C60056 add
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)
      INITIALIZE g_lrp.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx   
   END IF

  #FUN-C60056 mark begin---
  #SELECT * INTO g_lrp.* FROM lrp_file WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01 
  #                                      AND lrp04 = g_lrp.lrp04        #FUN-BC0079  add
  #                                      AND lrp05 = g_lrp.lrp05        #FUN-BC0079  add 
  #FUN-C60056 mark end-----

  #FUN-C60056 add begin---
   SELECT * INTO g_lrp.* FROM lrp_file WHERE lrp06 = g_lrp.lrp06
                                         AND lrp07 = g_lrp.lrp07
                                         AND lrp08 = g_lrp.lrp08
                                         AND lrpplant = g_lrp.lrpplant
  #FUN-C60056 add end----- 

   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lrp_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lrp.* TO NULL
      RETURN
   END IF

   CALL i555_show()

END FUNCTION

FUNCTION i555_show()
DEFINE l_rtz13     LIKE rtz_file.rtz13   #FUN-A80148 add
DEFINE l_lmb03     LIKE lmb_file.lmb03
DEFINE l_lmc04     LIKE lmc_file.lmc04
DEFINE l_azt02     LIKE azt_file.azt02
DEFINE l_azp02     LIKE azp_file.azp02   #FUN-C60056 add

   LET g_lrp_t.* = g_lrp.*
   DISPLAY BY NAME g_lrp.lrp06,g_lrp.lrp00,g_lrp.lrp07,g_lrp.lrp08,                             #FUN-C60056 add lrp06,lrp07,lrp08
                   g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05,g_lrp.lrp02,g_lrp.lrp03,g_lrp.lrp11,     #FUN-C60056 add lrp11    #FUN=A80022 add lrppos #FUN-BC0079 add lrp04,lrp05
                   g_lrp.lrppos,
                   g_lrp.lrpconf,g_lrp.lrpconu,g_lrp.lrpcond,g_lrp.lrp09,g_lrp.lrp10,           #FUN-C60056 add
                   g_lrp.lrpuser,g_lrp.lrpmodu,g_lrp.lrpacti,g_lrp.lrpgrup,g_lrp.lrpdate,       #FUN-C60056 add
                   g_lrp.lrpcrat,g_lrp.lrporiu,g_lrp.lrporig                                    #FUN-C60056 add
   DISPLAY g_lrp00 TO lrp00

   #FUN-C60056 add begin---
   SELECT azp02 INTO l_azp02 FROM azp_file where azp01 = g_lrp.lrp06
   DISPLAY l_azp02 TO azp02
   #FUN-C60056 add end-----
   
   CALL i555_lrp01('d',g_lrp.lrp01)
   CALL i555_b_fill(g_wc2)                 #虫ō
   CALL i555_b1_fill(g_wc3)     #FUN-BC0079  add
   CALL cl_show_fld_cont()
   CALL i555_pic()        #FUN-C60056 add
END FUNCTION

FUNCTION i555_r()
DEFINE l_count1   LIKE type_file.num5 #FUN-C40084 Add 
DEFINE l_count2   LIKE type_file.num5 #FUN-C40084 Add
DEFINE l_count3   LIKE type_file.num5 #FUN-C40084 Add
DEFINE l_count4   LIKE type_file.num5 #FUN-C60056 add

   IF s_shut(0) THEN
      RETURN
   END IF

  #FUN-C60056 mark begin---
  #IF g_lrp.lrp01 IS NULL THEN
  #   CALL cl_err("",-400,0)
  #   RETURN
  #END IF
  #FUN-C60056 mark end-----

   #FUN-C60056 add begin---
   CALL i555_msg('del')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   #FUN-C60056 add end-----

   #FUN-C60056 mark begin---
   #SELECT * INTO g_lrp.* FROM lrp_file
   # WHERE lrp01=g_lrp.lrp01
   #   AND lrp00=g_lrp00
   #   AND lrp04 = g_lrp.lrp04    #FUN-BC0079 add
   #   AND lrp05 = g_lrp.lrp05    #FUN-BC0079 add
   # LET g_lrp01_t=g_lrp.lrp01
   #FUN-C60056 mark end-----
 
   #FUN-C40084 Mark&Add Begin ---
   ##FUN-B70075 Begin -----
   #IF g_aza.aza88  = 'Y' THEN
   #   IF g_lrp.lrppos <> '1' THEN  
   #      CALL cl_err('','apc-139',0)            
   #      RETURN
   #   END IF     
   #END IF
   ##FUN-B70075 End ---

   #FUN-C60056 add begin---
   SELECT * INTO g_lrp.* FROM lrp_file
    WHERE lrp06=g_lrp.lrp06
      AND lrp07 = g_lrp.lrp07
      AND lrp08 = g_lrp.lrp08 
      AND lrpplant = g_lrp.lrpplant
   
    LET g_lrp01_t=g_lrp.lrp01
   #FUN-C60056 end-----

   #FUN-CB0025 mark begin ---
   # IF g_aza.aza88 = 'Y' THEN
   #    LET l_count1 = 0
   #    LET l_count2 = 0
   #    LET l_count3 = 0
   #    LET l_count4 = 0

   #    IF g_lrp.lrppos = '3' THEN
   #       #FUN-C60056 mark begin---
   #       #SELECT COUNT(*) INTO l_count1
   #       #  FROM lrq_file
   #       # WHERE lrq00=g_lrp00 AND lrq01 = g_lrp01_t
   #       #   AND lrq10 = g_lrp.lrp04
   #       #   AND lrq11 =  g_lrp.lrp05 AND lrqacti = 'Y'
   #       #SELECT COUNT(*) INTO l_count2
   #       #  FROM lth_file
   #       # WHERE lth01 = g_lrp00
   #       #   AND lth02 = g_lrp01_t AND lth03 = g_lrp.lrp04
   #       #   AND lth04 = g_lrp.lrp05 AND lthacti = 'Y'
   #       #SELECT COUNT(*) INTO l_count3
   #       #  FROM lrr_file
   #       # WHERE lrr00=g_lrp00 AND lrr01 = g_lrp01_t AND lrracti = 'Y'
   #       #   AND lrr03=g_lrp.lrp04 AND lrr04 = g_lrp.lrp05  #FUN-C40109 Add
   #       #FUN-C60056 mark end-----
   # 
   #       #FUN-C60056 add begin---
   #       SELECT COUNT(*) INTO l_count1
   #         FROM lrq_file
   #        WHERE lrq12 = g_lrp.lrp06
   #          AND lrq13 = g_lrp.lrp07
   #          AND lrqplant = g_lrp.lrpplant
   #          AND lrqacti = 'Y'
   #        
   #       SELECT COUNT(*) INTO l_count2
   #         FROM lth_file
   #        WHERE lth13 = g_lrp.lrp06
   #          AND lth14 = g_lrp.lrp07
   #          AND lthplant = g_lrp.lrpplant
   #          AND lthacti = 'Y'

   #       SELECT COUNT(*) INTO l_count3
   #         FROM lrr_file
   #        WHERE lrr05 = g_lrp.lrp06
   #          AND lrr06 = g_lrp.lrp07
   #          AND lrrplqnt = g_lrp.lrpplant
   #          AND lrracti = 'Y'

   #       SELECT COUNT(*) INTO l_count4
   #         FROM lso_file
   #        WHERE lso01 = g_lrp.lrp06
   #          AND lso02 = g_lrp.lrp07
   #          AND lsoplant = g_lrp.lrpplant
   #          AND lsoacti = 'Y'
   #       #FUN-C60056 add enb-----
   #    END IF
   #    IF g_lrp.lrppos = '1' OR
   #       (g_lrp.lrppos = '3' AND l_count1 = 0 AND l_count2 = 0 AND l_count3 = 0 AND l_count4 = 0) THEN    #FUN-C60056 add l_count4
   #    ELSE
   #       CALL cl_err('','apc-156',0) #資料的狀態須已傳POS否為'1.新增未下傳'，或者已傳POS否為'3.已下傳'且單身資料都無效，才能刪除！
   #       RETURN
   #    END IF
   # END IF
   ##FUN-C40084 Mark&Add Begin -----
   #FUN-CB0025 mark end --- 

    BEGIN WORK

   #OPEN i555_cl USING g_lrp00,g_lrp01_t,g_lrp_t.lrp04,g_lrp_t.lrp05   #FUN-C60056 mark   #FUN-BC0079 add lrp04,lrp05 
   OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant      #FUN-C60056 add
   IF STATUS THEN
      CALL cl_err("OPEN i555_cl:", STATUS, 1)
      CLOSE i555_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i555_cl INTO g_lrp.*               # 玛盢砆э┪戈
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)          #戈砆LOCK
      ROLLBACK WORK
      RETURN
   END IF
   
   CALL i555_show()

   IF cl_delh(0,0) THEN                   #絋粄
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
      #LET g_doc.column1 = "lrp01"         #No.FUN-9B0098 10/02/24   #FUN-C60056 mark
      #LET g_doc.value1 = g_lrp.lrp01      #No.FUN-9B0098 10/02/24   #FUN-C60056 mark
       LET g_doc.column1 = "lrp06"         #FUN-C60056 add
       LET g_doc.column2 = "lrp07"         #FUN-C60056 add
       LET g_doc.column3 = "lrp08"         #FUN-C60056 add
       LET g_doc.column4 = "lrpplant"      #FUN-C60056 add
       LET g_doc.value1 = g_lrp.lrp06      #FUN-C60056 add
       LET g_doc.value2 = g_lrp.lrp07      #FUN-C60056 add
       LET g_doc.value3 = g_lrp.lrp08      #FUN-C60056 add
       LET g_doc.value4 = g_lrp.lrpplant   #FUN-C60056 add
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
 
    #FUN-C60056 mark begin---
    #  DELETE FROM lrp_file WHERE lrp00=g_lrp00 AND lrp01 = g_lrp01_t 
    #                         AND lrp04 = g_lrp.lrp04    #FUN-BC0079 add 
    #                         AND lrp05 = g_lrp.lrp05    #FUN-BC0079 add
    #  DELETE FROM lrq_file WHERE lrq00=g_lrp00 AND lrq01 = g_lrp01_t
    #                         AND lrq10 = g_lrp.lrp04    #FUN-BC0079 add  
    #                         AND lrq11 =  g_lrp.lrp05    #FUN-BC0079 add
    # #FUN-C40109 Mark&Add Begin ---
    # #DELETE FROM lrr_file WHERE lrr00=g_lrp00 AND lrr01 = g_lrp01_t
    #  DELETE FROM lrr_file WHERE lrr00 = g_lrp00
    #                         AND lrr01 = g_lrp01_t
    #                         AND lrr03 = g_lrp.lrp04
    #                         AND lrr04 = g_lrp.lrp05
    # #FUN-C40109 Mark&Add End -----
    # #FUN-BC0079 add begin ---
    #  DELETE FROM lth_file WHERE lth01 = g_lrp00
    #                         AND lth02 = g_lrp01_t
    #                         AND lth03 = g_lrp.lrp04
    #                         AND lth04 = g_lrp.lrp05
    # #FUN-BC0079 add end -----
    #FUN-C60056 mark end-----
 
    #FUN-C60056 add begin---
    #DELETE FROM lrp_file WHERE lrp06 = g_lrp.lrp06 AND lrp07 = g_lrp.lrp07 AND lrpplant = g_lrp.lrpplant
     DELETE FROM lrq_file WHERE lrq12 = g_lrp.lrp06 AND lrq13 = g_lrp.lrp07 AND lrqplant = g_lrp.lrpplant
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("DELETE ","lrq_file",g_lrp_t.lrp07,"",SQLCA.sqlcode,"","lrq",1)
     END IF

     DELETE FROM lth_file WHERE lth13 = g_lrp.lrp06 AND lth14 = g_lrp.lrp07 AND lthplant = g_lrp.lrpplant
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("DELETE ","lrq_file",g_lrp_t.lrp07,"",SQLCA.sqlcode,"","lrq",1)
     END IF
 
     CALL i555_delall()
    #FUN-C60056 add end-----

      CLEAR FORM
      CALL g_lrq.clear()
      CALL g_lth.clear()                   #NO.TQC-C20534   add
      OPEN i555_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i555_cs
         CLOSE i555_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i555_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i555_cs
         CLOSE i555_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i555_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i555_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No:FUN-6A0067
         CALL i555_fetch('/')
      END IF
   END IF

   CLOSE i555_cl
   COMMIT WORK

END FUNCTION

FUNCTION i555_copy()
   DEFINE l_newno     LIKE lrp_file.lrp01,
          l_oldno     LIKE lrp_file.lrp01,
          l_n         LIKE type_file.num5,
          l_n1        LIKE type_file.num5
   DEFINE li_result   LIKE type_file.num5  

   IF s_shut(0) THEN RETURN END IF

   IF g_lrp.lrp01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   LET l_oldno = g_lrp.lrp01
   LET g_before_input_done = FALSE
   CALL i555_set_entry('a')
   LET g_before_input_done = TRUE               #FUN-C70003 add
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 

   #FUN-C70003 add begin---
   SELECT * INTO g_lrp.* FROM lrp_file WHERE lrp06 = g_lrp.lrp06 AND lrp07 = g_lrp.lrp07 AND lrp08 = g_lrp.lrp08 AND lrpplant = g_lrp.lrpplant
   LET g_lrp_o.*     = g_lrp.*
   LET g_lrp.lrp04   = NULL
   LET g_lrp.lrp05   = NULL
   LET g_lrp.lrp06   = g_plant
   LET g_lrp.lrp07   = NULL
   LET g_lrp.lrp08   = 0
   LET g_lrp.lrp09   = 'N'
   LET g_lrp.lrp10   = NULL
   LET g_lrp.lrppos  = '1'
   LET g_lrp.lrpconf = 'N'
   LET g_lrp.lrpconu = NULL
   LET g_lrp.lrpcond = NULL
   LET g_lrp.lrpplant = g_plant
   LET g_lrp.lrplegal = g_legal
   LET g_lrp.lrporiu  = g_user
   LET g_lrp.lrporig  = g_grup
   LET g_lrp.lrpuser  = g_user
   LET g_lrp.lrpmodu  = g_user
   LET g_lrp.lrpcrat  = g_today
   LET g_lrp.lrpgrup  = g_grup
   LET g_lrp.lrpacti  = 'Y'
   CALL i555_pic()

   CALL i555_i("a")
   CALL s_auto_assign_no("alm",g_lrp.lrp07,g_today,g_gee02,"lrp_file","lrp01","","","")  
   RETURNING li_result,g_lrp.lrp07
   IF (NOT li_result) THEN
      ROLLBACK WORK
      RETURN
   END IF
   
   #FUN-C70003 add end-----

  #FUN-C70003 mark begin---
  #INPUT l_newno FROM lrp01
  #
  #    BEFORE INPUT
  #    #  CALL cl_set_docno_format("lrp01")

  #    AFTER FIELD lrp01
  #       BEGIN WORK 
  #       IF NOT cl_null(l_newno) THEN    
  #             CALL i555_lrp01('a',l_newno)
  #             IF NOT cl_null(g_errno) THEN 
  #                CALL cl_err('',g_errno,1)
  #                LET l_newno=g_lrp_t.lrp01
  #                NEXT FIELD lrp01
  #             ELSE 
  #                SELECT COUNT(*) INTO l_n 
  #                  FROM lrp_file 
  #                 WHERE lrp00=g_lrp00 
  #                   AND lrp01=l_newno
  #                   AND lrp04 = g_lrp.lrp04   #FUN-BC0079  add
  #                   AND lrp05 = g_lrp.lrp05   #FUN-BC0079  add
  #                IF l_n>0 THEN 
  #                   CALL cl_err('','-239',1)
  #                   LET l_newno=g_lrp_t.lrp01  
  #               #TQC-A60016 --add
  #               DISPLAY '' TO FORMONLY.lph02
  #               #TQC-A60016 --end
  #                   NEXT FIELD lrp01
  #                END IF              	     
  #             END IF 
  #       ELSE 
  #       	  DISPLAY '' TO FORMONLY.lph02     
  #       END IF      
  #      
  #    ON ACTION controlp
  #       CASE
  #          WHEN INFIELD(lrp01) #虫沮絪腹
  #            CALL cl_init_qry_var()
  #            LET g_qryparam.form ="q_lph1"
  #           #No.TQC-A10129 -BEGIN-----
  #            IF g_lrp.lrp00 = '1' THEN
  #               LET g_qryparam.where = " lph06 = 'Y' "
  #            END IF
  #           #No.TQC-A10129 -END-------
  #            LET g_qryparam.default1 = g_lrp.lrp01
  #            CALL cl_create_qry() RETURNING l_newno
  #            DISPLAY l_newno TO lrp01
  #            NEXT FIELD lrp01
  #           OTHERWISE EXIT CASE
  #        END CASE
 
  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE INPUT
 
  #  ON ACTION about         #MOD-4C0121
  #     CALL cl_about()      #MOD-4C0121
 
  #  ON ACTION help          #MOD-4C0121
  #     CALL cl_show_help()  #MOD-4C0121
 
  #  ON ACTION controlg      #MOD-4C0121
  #     CALL cl_cmdask()     #MOD-4C0121
 
 
  #END INPUT
  #FUN-C70003 mark end-----

   IF INT_FLAG THEN
      LET INT_FLAG = 0
     #DISPLAY BY NAME g_lrp.lrp01  #FUN-C70003 mark
     #FUN-C70003 add begin---
      LET g_lrp.* = g_lrp_o.*
      CALL i555_pic()
      CALL i555_show()
     #FUN-C70003 add end-----
      ROLLBACK WORK
      RETURN
   END IF

   DROP TABLE y

  #FUN-C70003 mark begin---- 
  #SELECT * FROM lrp_file         #虫繷狡籹
  #    WHERE lrp01=g_lrp.lrp01
  #      AND lrp00=g_lrp00
  #      AND lrp04 = g_lrp.lrp04    #FUN-BC0079 add
  #      AND lrp05 = g_lrp.lrp05    #FUN-BC0079 add
  #    INTO TEMP y

  #UPDATE y
  #    SET lrp01=l_newno    #穝龄
  #       ,lrppos='1'       #No.FUN-A80022 #NO.FUN-B40071
  #FUN-C70003 mark end------

   #FUN-C70003 add beign---
   SELECT * FROM lrp_file
    WHERE lrp06 = g_lrp_o.lrp06
      AND lrp07 = g_lrp_o.lrp07
      AND lrp08 = g_lrp_o.lrp08
      AND lrpplant = g_lrp_o.lrpplant
     INTO TEMP y

   UPDATE y SET lrp01 = g_lrp.lrp01,
                lrp04 = g_lrp.lrp04,
                lrp05 = g_lrp.lrp05,
                lrp06 = g_plant,
                lrp07 = g_lrp.lrp07,
                lrp08 = 0,
                lrp09 = 'N',
                lrp10 = NULL,
                lrppos  = '1',
                lrpconf = 'N',
                lrpconu = NULL,
                lrpcond = NULL,
                lrpplant = g_plant,
                lrplegal = g_legal,
                lrporiu = g_user,
                lrporig = g_grup,
                lrpuser = g_user,
                lrpmodu = g_user,
                lrpcrat = g_today,
                lrpgrup = g_grup,
                lrpacti = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","y","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   #FUN-C70003 add end-----

   INSERT INTO lrp_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lrp_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF

   DROP TABLE x

  #FUN-C70003 mark begin---
  #SELECT * FROM lrq_file         #虫ō狡籹
  #    WHERE lrq00=g_lrp00 AND lrq01=g_lrp.lrp01
  #      AND lrq10 = g_lrp.lrp04    #FUN-BC0079 add
  #      AND lrq11 = g_lrp.lrp05    #FUN-BC0079 add
  #    INTO TEMP x
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
  #   RETURN
  #END IF

  #UPDATE x SET lrq01=l_newno,
  #             lrq12 = g_lrp.lrp06,          #FUN-C60056 add
  #             lrq13 = g_lrp.lrp07,          #FUN-C60056 add
  #             lrqlegal = g_lep.lrplegal,    #FUN-C60056 add
  #             lrqplant = g_lrp.lrpplant     #FUN-C60056 add
  #FUN-C70003 mark end-----

   #FUN-C70003 add begin---
   SELECT * FROM lrq_file
    WHERE lrq12 = g_lrp_o.lrp06
      AND lrq13 = g_lrp_o.lrp07
      AND lrqplant = g_lrp_o.lrpplant
     INTO TEMP x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x SET lrq13 = g_lrp.lrp07
   #FUN-C70003 add end-----

   INSERT INTO lrq_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK           # FUN-B80060---回滾放在報錯後---
      CALL cl_err3("ins","lrq_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK            # FUN-B80060--add--
      RETURN
   ELSE
       COMMIT WORK 
   END IF

   #FUN-C70003 add begin---
   DROP TABLE y 

   SELECT * FROM lth_file
    WHERE lth13 = g_lrp_o.lrp06
      AND lth14 = g_lrp_o.lrp07
      AND lthplant = g_lrp_o.lrpplant
     INTO TEMP y 
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","y","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE y SET lth14 = g_lrp.lrp07

   INSERT INTO lth_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lth_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
     
   #FUN-C70003 add end-----

  # SELECT COUNT(*) INTO l_n1 FROM lrr_file WHERE lrr00=g_lrp00 AND lrr01=g_lrp.lrp01    #FUN-C70003 mark

   LET l_n1 = 0     #FUN-C70003 add
   SELECT COUNT(*) INTO l_n1 FROM lrr_file WHERE lrr05 = g_lrp_o.lrp06 AND lrr06 = g_lrp_o.lrp07 AND lrrplant = g_lrp_o.lrpplant
   IF l_n1>0 THEN 
      DROP TABLE z

      #FUN-C70003 mark begin---
      #SELECT * FROM lrr_file WHERE lrr00=g_lrp00 AND lrr01=g_lrp.lrp01
      #  INTO TEMP z
      #FUN-C70003 mark end-----
 
      #FUN-C70003 add begin---
      SELECT * FROM lrr_file
       WHERE lrr05 = g_lrp_o.lrp06
         AND lrr06 = g_lrp_o.lrp07
         AND lrrplant = g_lrp_o.lrpplant
        INTO TEMP z
      #FUN-C70003 add end-----

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)     #FUN-C70003
         RETURN
      END IF  

     # UPDATE z SET lrr01=l_newno        #FUN-C70003 mark

      UPDATE z SET lrr06 = g_lrp.lrp07   #FUN-C70003 add

      INSERT INTO lrr_file
          SELECT * FROM z
      IF SQLCA.sqlcode THEN
      #   ROLLBACK WORK          # FUN-B80060---回滾放在報錯後---
         CALL cl_err3("ins","lrr_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK           # FUN-B80060--add--  
         RETURN
      ELSE
          COMMIT WORK 
      END IF      
   END IF

   #FUN-C70003 add begin---
   LET l_n1 = 0
   SELECT COUNT(*) INTO l_n1 FROM lso_file WHERE lso01 = g_lrp_o.lrp06 AND lso02 = g_lrp_o.lrp07 AND lsoplant = g_lrp_o.lrpplant
   IF l_n1 > 0 THEN
      DROP TABLE z
      SELECT * FROM lso_file WHERE lso01 = g_lrp_o.lrp06 AND lso02 = g_lrp_o.lrp07 AND lsoplant = g_lrp_o.lrpplant
        INTO TEMP z

      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","z","","",SQLCA.sqlcode,"","",1)
         RETURN     
      END IF

      UPDATE z SET lso02 = g_lrp.lrp07

      INSERT INTO lso_file SELECT * FROM z
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lrr_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK      
         RETURN
      ELSE
         COMMIT WORK
      END IF
   END IF
   #FUN-C70003 add end-----

 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   #FUN-C700003 mark begin---  
   #SELECT lrp_file.* INTO g_lrp.* FROM lrp_file WHERE lrp00=g_lrp00 AND lrp01 = l_newno
   #                                               AND lrp04 = g_lrp.lrp04   #FUN-BC0079
   #                                               AND lrp05 = g_lrp.lrp05   #FUN-BC0079 
   #CALL i555_u()
   #FUN-C70003 mark end-----

   #FUN-C70003 add begin---
   SELECT lrp_file.* INTO g_lrp.* FROM lrp_file 
    WHERE lrp06 = g_lrp.lrp06
      AND lrp07 = g_lrp.lrp07
      AND lrp08 = g_lrp.lrp08
      AND lrpplant = g_lrp.lrpplant
   #FUN-C70003 add end-----
   
   CALL i555_b()
   CALL i555_b1()   #FUN-BC0058  add 
   
   #FUN-C700003 mark begin---
   #SELECT lrp_file.* INTO g_lrp.* FROM lrp_file WHERE lrp00=g_lrp00 AND lrp01 = l_oldno
   #                                               AND lrp04 = g_lrp.lrp04   #FUN-BC0079
   #                                               AND lrp05 = g_lrp.lrp05   #FUN-BC0079
   #FUN-C70003 mark end-----
   CALL i555_show()

END FUNCTION

#虫ō
FUNCTION i555_b()
DEFINE   l_ac_t          LIKE type_file.num5                #ゼARRAY CNT
DEFINE   l_n             LIKE type_file.num5                #浪琩狡ノ
DEFINE   l_cnt           LIKE type_file.num5                #浪琩狡ノ
DEFINE   l_lock_sw       LIKE type_file.chr1                #虫ō玛
DEFINE   p_cmd           LIKE type_file.chr1                #矪瞶篈
DEFINE   l_allow_insert  LIKE type_file.num5
DEFINE   l_allow_delete  LIKE type_file.num5
DEFINE   l_count         LIKE type_file.num5
DEFINE   l_n1            LIKE type_file.num5
DEFINE   l_lrppos        LIKE lrp_file.lrppos               #FUN-B70075
DEFINE   l_pos_str       LIKE type_file.chr1                #FUN-B70075 
    
    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lrp.lrp01 IS NULL THEN
       RETURN
   END IF

   #FUN-C60056 add begin---
   IF g_lrp.lrp06 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF g_lrp.lrpacti = 'N' THEN
      CALL cl_err('','9027',0)
      RETURN
   END IF

   IF g_lrp.lrp09 = 'Y' THEN        #已發佈時不允許修改
      CALL cl_err('','alm-h55',0)
      RETURN
   END IF

   IF g_lrp.lrpconf = 'Y' THEN   #已確認時不允許修改
      CALL cl_err('','alm-027',0)
      RETURN
   END IF
   #FUN-C60056 add end-----

   #FUN-CB0025 mark begin ---
   ##FUN-B70075 Begin---
   # IF g_aza.aza88 = 'Y' THEN
   #   #FUN-C40109 Add Begin ---
   #    BEGIN WORK
   #    #OPEN i555_cl USING g_lrp00,g_lrp.lrp01,g_lrp_t.lrp04,g_lrp_t.lrp05   #FUN-C60056 mark   #FUN-BC0079 add
   #    OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant              #FUN-C60056 add
   #    IF STATUS THEN
   #       CALL cl_err("OPEN i555_cl:", STATUS, 1)
   #       CLOSE i555_cl
   #       ROLLBACK WORK
   #       RETURN
   #    END IF

   #    FETCH i555_cl INTO g_lrp.*
   #    IF SQLCA.sqlcode THEN
   #       CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)
   #       CLOSE i555_cl
   #       ROLLBACK WORK
   #       RETURN
   #    END IF
   #   #FUN-C40109 Add End -----
   #    LET l_pos_str = 'N'
   #    LET l_lrppos = g_lrp.lrppos
   #    
   #   #FUN-C60056 mark begin--- 
   #   #UPDATE lrp_file SET lrppos = '4'
   #   # WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01
   #   #   AND lrp04=g_lrp_t.lrp04            #FUN-BC0079  add
   #   #   AND lrp05=g_lrp_t.lrp05            #FUN-BC0079  add
   #   #FUN-C60056 mark end-----

   #    #FUN-C60056 add begin---
   #    UPDATE lrp_file SET lrppos = '4'
   #     WHERE lrp06 = g_lrp_t.lrp06
   #       AND lrp07 = g_lrp_t.lrp07
   #       AND lrp08 = g_lrp_t.lrp08
   #       AND lrpplant = g_lrp_t.lrpplant
   #    #FUN-C60056 add end-----
   #    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #       CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
   #       RETURN
   #    END IF
   #    LET g_lrp.lrppos = '4'
   #    DISPLAY BY NAME g_lrp.lrppos
   #    COMMIT WORK  #FUN-C40109 Add
   # END IF
   ##FUN-B70075 End---
   #FUN-CB0025 mark end --
    CALL cl_opmsg('b')

   #FUN-C40084 Mark&Add Begin ---
   #LET g_forupd_sql = " SELECT lrq02,'',lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09 ", #FUN-BC0112 add lrq06,lrq07,lrq08,lrq09
  #FUN-C60056 mark begin---
  # LET g_forupd_sql = " SELECT lrq02,'',lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrqacti ",
  ##FUN-C40084 Mark&Add End -----
  #                    " FROM lrq_file ",
  #                    " WHERE lrq00=? and lrq01 =? and lrq02 =? ",
  #                    "   AND lrq10 = ? AND lrq11 = ? ",           #FUN-BC0079  add
  #                    "  FOR UPDATE  "
  #FUN-C60056 mark end-----

    #FUN-C60056 add begin---
    LET g_forupd_sql = " SELECT lrq02,'',lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrqacti ",
                       " FROM lrq_file ",
                       #" WHERE lrq12 = ? AND lrq13 = ? AND lrqplant = ? AND lrq02 = ?",                    #FUN-C90046 mark
                       " WHERE lrq12 = ? AND lrq13 = ? AND lrqplant = ? AND lrq02 = ?  AND lrq06 = ?",      #FUN-C90046 add
                       "  FOR UPDATE  "
    #FUN-C60056 add end-----
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

    DECLARE i555_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    #FUN-C70003 add begin---
    IF g_lrp.lrpconf = 'Y' THEN
       CALL cl_err('','1208',0)
       RETURN
    END IF
    #FUN-C70003 add end-----

    INPUT ARRAY g_lrq WITHOUT DEFAULTS FROM s_lrq.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

          #FUN-C70003 mark begin---
          ##FUN-C60056 add begin---
          #IF g_lrp.lrpconf = 'Y' THEN
          #   CALL cl_err('','1208',0)
          #   RETURN
          #END IF
          ##FUN-C60056 add end-----
          #FUN-C70003 mark end-----

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           #OPEN i555_cl USING g_lrp00,g_lrp.lrp01,g_lrp_t.lrp04,g_lrp_t.lrp05   #FUN-C60056 mark  #FUN-BC0079 add lrp04,lrp05
           OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant             #FUN-C60056 add 
           IF STATUS THEN
              CALL cl_err("OPEN i555_cl:", STATUS, 1)
              CLOSE i555_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH i555_cl INTO g_lrp.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)
              CLOSE i555_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
#FUN-CB0025 mark begin ---
##FUN-C50036 add begin ---
#               IF g_aza.aza88 = 'Y' THEN
#                  IF l_lrppos <> '1' THEN
#                     CALL cl_set_comp_entry("lrq02",FALSE)
#                  ELSE
#                     CALL cl_set_comp_entry("lrq02",TRUE)
#                  END IF 
#               END IF 
##FUN-C50036 add end ---
#FUN-CB0025 mark end ---
              LET g_lrq_t.* = g_lrq[l_ac].*  #BACKUP
             #OPEN i555_bcl USING g_lrp00,g_lrp.lrp01,g_lrq_t.lrq02,g_lrp.lrp04,g_lrp.lrp05   #FUN-BC0079 add lrp04,lrp05   #FUN-C60056 mark
             #OPEN i555_bcl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrpplant,g_lrq_t.lrq02                                      #FUN-C60056 add    #FUN-C90046 mark
              OPEN i555_bcl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrpplant,g_lrq_t.lrq02,g_lrq_t.lrq06                        #FUN-C90046 add
              IF STATUS THEN
                 CALL cl_err("OPEN i555_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i555_bcl INTO g_lrq[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lrq_t.lrq02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL i555_lrq02('d')
              CALL cl_show_fld_cont()
#              CALL i555_set_entry_b(p_cmd)
#              CALL i555_set_no_entry_b(p_cmd,0)
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_set_comp_entry("lrq02",TRUE)  #FUN-C50036 add 
           INITIALIZE g_lrq[l_ac].* TO NULL
           LET g_lrq[l_ac].lrq09 = 'Y'           #FUN-BC0112 add
           LET g_lrq[l_ac].lrqacti = 'Y'         #FUN-C40084 Add
           LET g_lrq_t.* = g_lrq[l_ac].*         #穝块戈
           LET g_lrq[l_ac].lrq03=1
           LET g_lrq[l_ac].lrq04=1
           LET g_lrq[l_ac].lrq05=100
#FUN-BC0112 -----add-----begin
           IF g_argv1 = '3' THEN
              LET g_lrq[l_ac].lrq03=0
              LET g_lrq[l_ac].lrq04=0
              LET g_lrq[l_ac].lrq05=0
           ELSE
              LET g_lrq[l_ac].lrq06=0
              LET g_lrq[l_ac].lrq07=0
              LET g_lrq[l_ac].lrq08=0
           END IF
#FUN-BC0112 -----add-----end           
           CALL cl_show_fld_cont()
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
           NEXT FIELD lrq02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

         #FUN-C40084 Mark&Add Begin ---
         #INSERT INTO lrq_file(lrq00,lrq01,lrq02,lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrq10,lrq11)    #FUN-BC0079  add lrq10,lrq11 #FUN-BC0112 add lrq06,lrq07,lrq08,lrq09
         #VALUES(g_lrp00,g_lrp.lrp01,g_lrq[l_ac].lrq02,g_lrq[l_ac].lrq03,
         #       g_lrq[l_ac].lrq04,g_lrq[l_ac].lrq05,
         #       g_lrq[l_ac].lrq06,g_lrq[l_ac].lrq07,g_lrq[l_ac].lrq08,g_lrq[l_ac].lrq09,  #FUN-BC0112 add lrq06,lrq07,lrq08,lrq09                
         #       g_lrp.lrp04,g_lrp.lrp05)      #FUN-BC0079  add lrp04,lrp05 

          INSERT INTO lrq_file(lrq00,lrq01,lrq02,lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrq10,lrq11,lrqacti,
                               lrq12,lrq13,lrqlegal,lrqplant)                                                    #FUN-C60056 add
          VALUES(g_lrp00,g_lrp.lrp01,g_lrq[l_ac].lrq02,g_lrq[l_ac].lrq03,g_lrq[l_ac].lrq04,g_lrq[l_ac].lrq05,
                 g_lrq[l_ac].lrq06,g_lrq[l_ac].lrq07,g_lrq[l_ac].lrq08,g_lrq[l_ac].lrq09,
                 g_lrp.lrp04,g_lrp.lrp05,g_lrq[l_ac].lrqacti,
                 g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrplegal,g_lrp.lrpplant)                                          #FUN-C60056 add
         #FUN-C40084 Mark&Add End -----

          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lrq_file",g_lrp.lrp01,g_lrq[l_ac].lrq02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
            #FUN-B70075 Mark Begin--------
            #FUN-A80022 --------------add start--------------
            # IF g_aza.aza88 = 'Y' AND g_lrp.lrppos = '3' THEN #FUN-B40071                              
            #     UPDATE lrp_file SET lrppos = '2' #FUN-B40071
            #     WHERE lrp00 = g_lrp00 AND lrp01 = g_lrp.lrp01
               
            #    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            #       CALL cl_err3("upd","lrp_file",g_lrp00,g_lrp.lrp01,SQLCA.sqlcode,"","",1) 
            #       CANCEL INSERT
            #    ELSE
            #       LET g_lrp.lrppos = '2' #FUN-B40071
            #       DISPLAY g_lrp.lrppos TO lrppos
            #    END IF 
            # END IF
            #FUN-A80022 ---------------add end------------------
            #FUN-B70075 Mark End ---------

             MESSAGE 'INSERT O.K'
             COMMIT WORK
            #FUN-CB0025 mark begin ---
            # LET l_pos_str = 'Y'   #FUN-B70075
            ##FUN-C40109 Add Begin ---
            # IF l_lrppos <> '1' THEN
            #    LET l_lrppos = '2'
            # ELSE
            #    LET l_lrppos = '1'
            # END IF
            ##FUN-C40109 Add End -----
            #FUN-CB0025 mark end ---
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF

        AFTER FIELD lrq02
           IF NOT cl_null(g_lrq[l_ac].lrq02) THEN
#FUN-AB0025 ---------------------start----------------------------
              IF g_lrp.lrp02='4' THEN
                 IF NOT s_chk_item_no(g_lrq[l_ac].lrq02,"") THEN
                    CALL cl_err('',g_errno,1)
                    LET g_lrq[l_ac].lrq02= g_lrq_t.lrq02
                    NEXT FIELD lrq02
                 END IF
              END IF
#FUN-AB0025 ---------------------end-------------------------------
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lrq[l_ac].lrq02 != g_lrq_t.lrq02) THEN
                 CALL i555_lrq02('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,1)
                    LET g_lrq[l_ac].lrq02=g_lrq_t.lrq02
                    NEXT FIELD lrq02
                 END IF
                 #FUN-C70003 mark begin---
                 #SELECT COUNT(*) INTO l_n1
                 #  FROM lrq_file
                 # WHERE lrq00=g_lrp00
                 #   AND lrq01=g_lrp.lrp01
                 #   AND lrq02=g_lrq[l_ac].lrq02
                 #   AND lrq10=g_lrp.lrp04           #FUN-BC0079  add
                 #   AND lrq11=g_lrp.lrp05           #FUN-BC0079  add
                 #FUN-C70003 mark end-----
                 #FUN-C90046------add---str
                 IF g_argv1 = '3' THEN
                    IF NOT cl_null(g_lrq[l_ac].lrq06) THEN
                       SELECT COUNT(*) INTO l_n1
                         FROM lrq_file
                        WHERE lrq12 = g_lrp.lrp06
                          AND lrq13 = g_lrp.lrp07
                          AND lrqplant = g_lrp.lrpplant
                          AND lrq02 = g_lrq[l_ac].lrq02
                          AND lrq06 = g_lrq[l_ac].lrq06
                       IF l_n1>0 THEN
                          CALL cl_err('','-239',1)
                          LET g_lrq[l_ac].lrq02=g_lrq_t.lrq02
                          NEXT FIELD lrq02
                       END IF
                    END IF
                 ELSE
                 #FUN-C90046------add---end
                    #FUN-C70003 add begin---
                    SELECT COUNT(*) INTO l_n1
                      FROM lrq_file
                     WHERE lrq12 = g_lrp.lrp06
                       AND lrq13 = g_lrp.lrp07
                       AND lrqplant = g_lrp.lrpplant
                       AND lrq02 = g_lrq[l_ac].lrq02
                    #FUN-C70003 add end-----
                    IF l_n1>0 THEN 
                       CALL cl_err('','-239',1)
                       LET g_lrq[l_ac].lrq02=g_lrq_t.lrq02
                       NEXT FIELD lrq02
                    END IF      
                 END IF  #FUN-C90046 add
              END IF    
           END IF

        AFTER FIELD lrq03
           IF NOT cl_null(g_lrq[l_ac].lrq03) THEN
              IF g_lrq[l_ac].lrq03 <= 0 THEN
                 CALL cl_err('','alm-061',0)
                 NEXT FIELD lrq03
              END IF
           END IF

        AFTER FIELD lrq04
           IF NOT cl_null(g_lrq[l_ac].lrq04) THEN
              IF g_lrq[l_ac].lrq04 <= 0 THEN
                 CALL cl_err('','alm-061',0)
                 NEXT FIELD lrq04
              END IF
           END IF
           
        AFTER FIELD lrq05
           IF NOT cl_null(g_lrq[l_ac].lrq05) THEN
              IF g_lrq[l_ac].lrq05 < 0 OR g_lrq[l_ac].lrq05 > 100 THEN
                 CALL cl_err('','alm-257',0)
                 NEXT FIELD lrq05
              END IF
           END IF   

#FUN-BC0112 -----add----- begin
        AFTER FIELD lrq06
           IF NOT cl_null(g_lrq[l_ac].lrq06) THEN
              IF g_lrq[l_ac].lrq06 <= 0 THEN 
                 CALL cl_err('','alm-808',0)
                 NEXT FIELD lrq06
              END IF
              #FUN-C90046------add---str
              IF (p_cmd = 'a' OR (p_cmd = 'u' AND g_lrq[l_ac].lrq06 != g_lrq_t.lrq06))
                 AND NOT cl_null(g_lrq[l_ac].lrq02) THEN
                 SELECT COUNT(*) INTO l_n1
                   FROM lrq_file 
                  WHERE lrq12 = g_lrp.lrp06
                    AND lrq13 = g_lrp.lrp07
                    AND lrqplant = g_lrp.lrpplant
                    AND lrq02 = g_lrq[l_ac].lrq02
                    AND lrq06 = g_lrq[l_ac].lrq06
                 IF l_n1>0 THEN
                    CALL cl_err('','-239',1)
                    LET g_lrq[l_ac].lrq06=g_lrq_t.lrq06
                    NEXT FIELD lrq06
                 END IF
              END IF
              #FUN-C90046------add---end
           END IF

        AFTER FIELD lrq07
           IF NOT cl_null(g_lrq[l_ac].lrq07) THEN
              IF g_lrq[l_ac].lrq07 <= 0 THEN
                 CALL cl_err('','alm-808',0)
                 NEXT FIELD lrq07
              END IF
           END IF

        AFTER FIELD lrq08
           IF NOT cl_null(g_lrq[l_ac].lrq08) THEN
              IF g_lrq[l_ac].lrq08 <= 0 THEN
                 CALL cl_err('','alm-808',0)
                 NEXT FIELD lrq08
              END IF
           END IF
#FUN-BC0112 -----add----- end
                   
        BEFORE DELETE                      #琌虫ō
           DISPLAY "BEFORE DELETE"
           IF g_lrq_t.lrq02 IS NOT NULL THEN
             #FUN-CB0025 mark begin --- 
             ##FUN-C40084 Add Begin ---
             # IF g_aza.aza88 = 'Y' THEN
             #    IF l_lrppos = '1' OR (l_lrppos = '3' AND g_lrq_t.lrqacti = 'N') THEN
             #    ELSE
             #       CALL cl_err('','apc-155',0)
             #       CANCEL DELETE
             #    END IF
             # END IF
             ##FUN-C40084 Add End -----
             #FUN-CB0025 mark end ---
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lrq_file
               WHERE lrq12 = g_lrp.lrp06           #FUN-C60056 add           
                 AND lrq13 = g_lrp.lrp07           #FUN-C60056 add      
                 AND lrqplant = g_lrp.lrpplant    #FUN-C60056 add   
                 AND lrq02 = g_lrq_t.lrq02         #FUN-C60056 add      
                 AND lrq06 = g_lrq_t.lrq06         #FUN-C90046 add
              #WHERE lrq00 = g_lrp00               #FUN-C60056 mark      
              #  AND lrq01 = g_lrp.lrp01           #FUN-C60056 mark          
              #  AND lrq02 = g_lrq_t.lrq02         #FUN-C60056 mark                          
              #  AND lrq10 = g_lrp.lrp04           #FUN-C60056 mark   #FUN-BC0079  add            
              #  AND lrq11 = g_lrp.lrp05           #FUN-C60056 mark   #FUN-BC0079  add                  
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lrq_file",g_lrp.lrp01,g_lrq_t.lrq02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
              #FUN-B70075 Mark Begin -----------
              #ELSE
              #FUN-A80022 --------------add start--------------
              #IF g_aza.aza88 = 'Y' AND g_lrp.lrppos = '3' THEN #FUN-B40071
              #   UPDATE lrp_file SET lrppos = '2' #FUN-B40071
              #    WHERE lrp00 = g_lrp00 AND lrp01 = g_lrp.lrp01
              #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #      CALL cl_err3("upd","lrp_file",g_lrp00,g_lrp.lrp01,SQLCA.sqlcode,"","",1)
              #      ROLLBACK WORK
              #      CANCEL DELETE
              #   ELSE
              #      LET g_lrp.lrppos = '2' #FUN-B40071
              #      DISPLAY g_lrp.lrppos TO lrppos
              #   END IF
              #END IF
              #FUN-A80022 ---------------add end------------------
             #FUN-B70075 Mark End --------------
                 
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lrq[l_ac].* = g_lrq_t.*
              CLOSE i555_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lrq[l_ac].lrq02,-263,1)
              LET g_lrq[l_ac].* = g_lrq_t.*
           ELSE
              UPDATE lrq_file SET lrq02 = g_lrq[l_ac].lrq02,
                                  lrq03 = g_lrq[l_ac].lrq03,
                                  lrq04 = g_lrq[l_ac].lrq04,
                                  lrq05 = g_lrq[l_ac].lrq05,
                                  lrq06 = g_lrq[l_ac].lrq06,  #FUN-BC0112 add
                                  lrq07 = g_lrq[l_ac].lrq07,  #FUN-BC0112 add
                                  lrq08 = g_lrq[l_ac].lrq08,  #FUN-BC0112 add
                                  lrq09 = g_lrq[l_ac].lrq09,  #FUN-BC0112 add FUN-C40084 Add ,
                                  lrqacti = g_lrq[l_ac].lrqacti #FUN-C40084 Add
              #WHERE lrq00 = g_lrp00        #FUN-C60056 mark      
              #  AND lrq01 = g_lrp.lrp01    #FUN-C60056 mark    
              #  AND lrq02 = g_lrq_t.lrq02  #FUN-C60056 mark 
              #  AND lrq10=g_lrp.lrp04      #FUN-C60056 amrk     #FUN-BC0079  add
              #  AND lrq11=g_lrp.lrp05      #FUN-C60056 mark     #FUN-BC0079  add
               WHERE lrq12 = g_lrp_t.lrp06  #FUN-C60056 add
                 AND lrq13 = g_lrp_t.lrp07  #FUN-C60056 add
                 AND lrqplant = g_lrp_t.lrpplant        #FUN-C60056 add
                 AND lrq02 = g_lrq_t.lrq02              #FUN-C60056 add
                 AND lrq06 = g_lrq_t.lrq06              #FUN-C90046 add
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lrq_file",g_lrp.lrp01,g_lrq_t.lrq02,SQLCA.sqlcode,"","",1)
                 LET g_lrq[l_ac].* = g_lrq_t.*
              ELSE
                #FUN-B70075 Mark Begin -----------
                #FUN-A80022 --------------add start--------------
                # IF g_aza.aza88 = 'Y' AND g_lrp.lrppos = '3' THEN #FUN-B40071
                #    UPDATE lrp_file SET lrppos = '2' #FUN-B40071
                #     WHERE lrp00 = g_lrp00 AND lrp01 = g_lrp.lrp01
                #    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                #       CALL cl_err3("upd","lrp_file",g_lrp.lrp00,g_lrp.lrp01,SQLCA.sqlcode,"","",1)
                #       LET g_lrq[l_ac].* = g_lrq_t.*
                #       ROLLBACK WORK
                #    ELSE
                #       LET g_lrp.lrppos = '2' #FUN-B40071
                #       DISPLAY g_lrp.lrppos TO lrppos
                #    END IF
                # END IF
                #FUN-A80022 ---------------add end------------------
                #FUN-B70075 Mark End -----------
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                #FUN-CB0025 mark begin ---
                ##FUN-C40109 Add Begin ---
                # LET l_pos_str = 'Y'
                # IF l_lrppos <> '1' THEN
                #    LET l_lrppos = '2'
                # ELSE
                #    LET l_lrppos = '1'
                # END IF
                ##FUN-C40109 Add End -----
                #FUN-CB0025 mark end ----
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lrq[l_ac].* = g_lrq_t.*
                 CALL i555_delall()
              END IF
              CLOSE i555_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i555_bcl
           COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(lrq02)
                #No.TQC-B10195  --Begin
                IF g_lrp.lrp02 <> '4' THEN
                #No.TQC-B10195  --End  
                   CALL cl_init_qry_var()
                   CASE g_lrp.lrp02
                      WHEN "1" 
#                       LET g_qryparam.form ="q_lpf"      #FUN-BC0058 MARK
                        LET g_qryparam.form ="q_lpc01_1"  #FUN-BC0058
                        LET g_qryparam.where = " lpcacti = 'Y' " #FUN-BC0112 add
                        LET g_qryparam.arg1 = '6'         #FUN-BC0058
                      WHEN "2"
                        IF g_argv1 = '3' THEN                  #FUN-BC0112 add
                           LET g_qryparam.form = "q_lpc01_1"   #FUN-BC0112 add
                           LET g_qryparam.where = " lpcacti = 'Y' "  #FUN-BC0112 add
                           LET g_qryparam.arg1 = '7'           #FUN-BC0112 add
                        ELSE                                   #FUN-BC0112 add
                           LET g_qryparam.form ="q_oba1"
                        END IF                                 #FUN-BC0112 add
                      WHEN "3"
                        LET g_qryparam.form ="q_tqa"
                        LET g_qryparam.arg1='2'
                   #   WHEN "4"                       #FUN-AA0059 
                   #     LET g_qryparam.form ="q_ima" #FUN-AA0059
                   END CASE      
                   LET g_qryparam.default1 = g_lrq[l_ac].lrq02
                   CALL cl_create_qry() RETURNING g_lrq[l_ac].lrq02
                #No.TQC-B10195  --Begin
                ELSE
                ##FUN-AA0059 --Begin--
                #IF g_lrp.lrp02 = "4" THEN
                   CALL q_sel_ima(FALSE, "q_ima", "", g_lrq[l_ac].lrq02, "", "", "", "" ,"",'' )  RETURNING g_lrq[l_ac].lrq02
                #End IF 
                ##FUN-AA0059 --End--
                END IF
                #No.TQC-B10195  --End  
                DISPLAY BY NAME g_lrq[l_ac].lrq02
                NEXT FIELD lrq02
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLO                        #猽ノ┮Τ逆
           IF INFIELD(lrq02) AND l_ac > 1 THEN
              LET g_lrq[l_ac].* = g_lrq[l_ac-1].*
              LET g_lrq[l_ac].lrq02 = g_rec_b + 1
              NEXT FIELD lrq02
           END IF

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

        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
    END INPUT

    CLOSE i555_bcl
    COMMIT WORK
    #FUN-CB0025 mark begin ---
    ##FUN-B70075 Begin -------
    #IF g_aza.aza88 = 'Y' THEN
    #   IF l_pos_str = 'Y' THEN
    #      IF l_lrppos <> '1' THEN
    #         LET g_lrp.lrppos = '2'
    #      ELSE
    #         LET g_lrp.lrppos = '1'
    #      END IF
    #  #FUN-C60056 mark begin--- 
    #  #   UPDATE lrp_file SET lrppos = g_lrp.lrppos
    #  #    WHERE lrp06 = g_lrp.lrp06                             #FUN-C60056 add    
    #  #      AND lrp07 = g_lrp.lrp07                             #FUN-C60056 add    
    #  #      AND lrp08 = g_lrp.lrp08                             #FUN-C60056 add       
    #  #      AND lrpplant = g_lrp.lrpplant                       #FUN-C60056 add       
    #  #   #WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01           #FUN-C60056 mark       
    #  #   #  AND lrp04=g_lrp.lrp04            #FUN-BC0079  add   #FUN-C60056 mark      
    #  #   #  AND lrp05=g_lrp.lrp05            #FUN-BC0079  add   #FUN-C60056 mark        
    #  #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #  #      CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
    #  #      RETURN
    #  #   END IF
    #  #   DISPLAY BY NAME g_lrp.lrppos
    #  #ELSE
    #  #   UPDATE lrp_file SET lrppos = l_lrppos
    #  #    WHERE lrp06 = g_lrp.lrp06                             #FUN-C60056 add
    #  #      AND lrp07 = g_lrp.lrp07                             #FUN-C60056 add
    #  #      AND lrp08 = g_lrp.lrp08                             #FUN-C60056 add
    #  #      AND lrpplant = g_lrp.lrpplant                       #FUN-C60056 add
    #  #   #WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01           #FUN-C60056 mark       
    #  #   #  AND lrp04=g_lrp.lrp04            #FUN-BC0079  add   #FUN-C60056 mark         
    #  #   #  AND lrp05=g_lrp.lrp05            #FUN-BC0079  add   #FUN-C60056 mark       
    #  #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #  #      CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
    #  #      RETURN
    #  #   END IF
    #  #   LET g_lrp.lrppos = l_lrppos
    #  #   DISPLAY BY NAME g_lrp.lrppos
    #  #END IF
    #  #FUN-C60056 mark end-----

    #  #FUN-C60056 add for test begin---
    #   ELSE
    #     LET g_lrp.lrppos = l_lrppos
    #   END IF
    # 
    #   UPDATE lrp_file SET lrppos = g_lrp.lrppos
    #    WHERE lrp06 = g_lrp.lrp06                             
    #      AND lrp07 = g_lrp.lrp07                             
    #      AND lrp08 = g_lrp.lrp08                             
    #      AND lrpplant = g_lrp.lrpplant                       
    #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #      CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
    #      RETURN
    #   END IF
    #   DISPLAY BY NAME g_lrp.lrppos
    #  #FUN-C60056 add for test end-----
    #END IF
    ##FUN-B70075 End ----------    
    #FUN-CB0025 mark end ---
    CALL i555_delall()
END FUNCTION

FUNCTION i555_lrq02(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_obaacti       LIKE oba_file.obaacti
DEFINE   l_imaacti       LIKE ima_file.imaacti
DEFINE   l_tqa03         LIKE tqa_file.tqa03
#DEFINE   l_lpf05         LIKE lpf_file.lpf05     #FUN-BC0058 MARK
DEFINE   l_lpf05         LIKE lpc_file.lpcacti    #FUN-BC0058
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_tqa02         LIKE tqa_file.tqa02
#DEFINE   l_lpf02         LIKE lpf_file.lpf02      #FUN-BC0058 MARK
DEFINE   l_lpf02         LIKE lpc_file.lpc02      #FUN-BC0058
DEFINE   l_oba02         LIKE oba_file.oba02   

    LET g_errno =''
    CASE g_lrp.lrp02
       WHEN "1"
#         SELECT lpf05,lpf02 INTO l_lpf05,l_lpf02 FROM lpf_file    #FUN-BC0058 MARK
          SELECT lpcacti,lpc02 INTO l_lpf05,l_lpf02 FROM lpC_file  #FUN-BC0058
#          WHERE lpf01=g_lrq[l_ac].lrq02         #FUN-BC0058 MAR
           WHERE lpc01 = g_lrq[l_ac].lrq02       #FUN-BC0058 
             AND lpc00 = '6'                     #FUN-BC0058
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_lpf02 = NULL
               WHEN l_lpf05 !='Y'       LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_lrq[l_ac].lrq02_1=l_lpf02
             DISPLAY BY NAME g_lrq[l_ac].lrq02_1
          END IF 
       WHEN "2"
          IF g_argv1 = '3' THEN
             SELECT lpcacti,lpc02 INTO l_lpf05,l_lpf02 FROM lpC_file
              WHERE lpc01 = g_lrq[l_ac].lrq02
                AND lpc00 = '7'
             CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                         LET l_lpf02 = NULL
                  WHEN l_lpf05 !='Y'     LET g_errno='9028'
                  OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
             END CASE
          ELSE
             SELECT obaacti,oba02 INTO l_obaacti,l_oba02
               FROM oba_file
              WHERE oba01=g_lrq[l_ac].lrq02
             CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                         LET l_oba02 = NULL
                  WHEN l_obaacti !='Y'   LET g_errno='9028'
                  OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
             END CASE 
          END IF             
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             IF g_argv1 = '3' THEN
                LET g_lrq[l_ac].lrq02_1=l_lpf02
             ELSE
                LET g_lrq[l_ac].lrq02_1=l_oba02
             END IF
             DISPLAY BY NAME g_lrq[l_ac].lrq02_1
          END IF           	                         
       WHEN "3"
          SELECT tqa03,tqa02 INTO l_tqa03,l_tqa02 FROM tqa_file 
          WHERE tqa01=g_lrq[l_ac].lrq02 AND tqa03='2'
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_tqa02 = NULL
               #WHEN l_tqa03 !='2'     LET g_errno='alm-828'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_lrq[l_ac].lrq02_1=l_tqa02
             DISPLAY BY NAME g_lrq[l_ac].lrq02_1
          END IF                                      
       WHEN "4"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file 
          WHERE ima01=g_lrq[l_ac].lrq02
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case              
          IF cl_null(g_errno) OR p_cmd='d' THEN 
             LET g_lrq[l_ac].lrq02_1=l_ima02
             DISPLAY BY NAME g_lrq[l_ac].lrq02_1
          END IF                
    END CASE                   

END FUNCTION 

FUNCTION i555_delall()
   DEFINE l_lrq_cnt LIKE type_file.num5,
          l_lth_cnt LIKE type_file.num5 

   SELECT COUNT(*) INTO l_lrq_cnt FROM lrq_file          #FUN-C60056 g_cnt chenge to l_lrq_cnt
    WHERE lrq12 = g_lrp.lrp06        #FUN-C60056 add
      AND lrq13 = g_lrp.lrp07        #FUN-C60056 add
      AND lrqplant = g_lrp.lrpplant  #FUN-C60056 add  
   #WHERE lrq00=g_lrp00              #FUN-C60056 mark
   #  AND lrq01 = g_lrp.lrp01        #FUN-C60056 mark
   #  AND lrq02 IS NOT NULL          #FUN-C60056 mark
   #  AND lrq10=g_lrp.lrp04          #FUN-C60056 mark    #FUN-BC0079  add
   #  AND lrq11=g_lrp.lrp05          #FUN-C60056 mark    #FUN-BC0079  add

   #FUN-C60056 add begin---
   SELECT COUNT(*) INTO l_lth_cnt FROM lth_file
    WHERE lth13 = g_lrp.lrp06
      AND lth14 = g_lrp.lrp07
      AND lthplant = g_lrp.lrpplant
   #FUN-C60056 add end-----

   #IF g_cnt = 0 THEN                                    #FUN-C60056 mark   
   IF l_lrq_cnt =0 AND l_lth_cnt = 0 THEN                #FUN-C60056 add#第一單身及第二單身都沒有資料時刪除單頭 
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
  
      #FUN-C60056 add begin---
      DELETE FROM lrr_file
            WHERE lrr05 = g_lrp.lrp06
              AND lrr06 = g_lrp.lrp07
              AND lrrplant = g_lrp.lrpplant

      DELETE FROM lso_file
            WHERE lso01 = g_lrp.lrp06
              AND lso02 = g_lrp.lrp07
              AND lsoplant = g_lrp.lrpplant
      #FUN-C60056 add end-----


      DELETE FROM lrp_file
            WHERE lrp06 = g_lrp.lrp06         #FUN-C60056 add      
              AND lrp07 = g_lrp.lrp07         #FUN-C60056 add   
              AND lrp08 = g_lrp.lrp08         #FUN-C60056 add 
              AND lrpplant = g_lrp.lrpplant   #FUN-C60056 add
           #WHERE lrp00 = g_lrp00             #FUN-C60056 mark      
           #  AND lrp01 = g_lrp.lrp01         #FUN-C60056 mark 
           #  AND lrp04 = g_lrp.lrp04         #FUN-C60056 mark     #FUN-BC0079
           #  AND lrp05 = g_lrp.lrp05         #FUN-C60056 mark     #FUN-BC0079

      CLEAR FORM   #MOD-C30335 add
      INITIALIZE g_lrp.* TO NULL  #MOD-C30335 add 
     
  END IF
END FUNCTION

#FUN-BC0079 add BEGIN-----
FUNCTION i555_b1()
DEFINE  l_ac1_t          LIKE type_file.num5,  
        l_n,l_n1,l_n2   LIKE type_file.num5, 
        l_cnt           LIKE type_file.num5,
        l_lock_sw       LIKE type_file.chr1,
        p_cmd           LIKE type_file.chr1,
        l_allow_insert  LIKE type_file.num5,
        l_allow_delete  LIKE type_file.num5,
        l_lrppos        LIKE lrp_file.lrppos,
        l_pos_str       LIKE type_file.chr1 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lrp.lrp01 IS NULL THEN
       RETURN
    END IF
  
   #FUN-C70003 add begin---
   IF g_lrp.lrp06 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF g_lrp.lrpacti = 'N' THEN
      CALL cl_err('','9027',0)
      RETURN
   END IF

   IF g_lrp.lrp09 = 'Y' THEN        #已發佈時不允許修改
      CALL cl_err('','alm-h55',0)
      RETURN
   END IF

   IF g_lrp.lrpconf = 'Y' THEN   #已確認時不允許修改
      CALL cl_err('','alm-027',0)
      RETURN
   END IF
   #FUN-C70003 add end-----   
 
   #FUN-CB0025 mark begin --- 
   # IF g_aza.aza88 = 'Y' THEN
   #   #FUN-C40109 Add Begin ---
   #    BEGIN WORK
   #    #OPEN i555_cl USING g_lrp00,g_lrp.lrp01,g_lrp_t.lrp04,g_lrp_t.lrp05   #FUN-C60056 mark   #FUN-BC0079 add
   #    OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant             #FUN-C60056 add
   #    IF STATUS THEN
   #       CALL cl_err("OPEN i555_cl:", STATUS, 1)
   #       CLOSE i555_cl
   #       ROLLBACK WORK
   #       RETURN
   #    END IF

   #    FETCH i555_cl INTO g_lrp.*
   #    IF SQLCA.sqlcode THEN
   #       CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)
   #       CLOSE i555_cl
   #       ROLLBACK WORK
   #       RETURN
   #    END IF
   #   #FUN-CB0025 mark begin ---
   #    #FUN-C40109 Add End -----
   #    LET l_pos_str = 'N'
   #    LET l_lrppos = g_lrp.lrppos
   #    UPDATE lrp_file SET lrppos = '4'
   #     WHERE lrp06 = g_lrp.lrp06                             #FUN-C60056 add
   #       AND lrp07 = g_lrp.lrp07                             #FUN-C60056 add
   #       AND lrp08 = g_lrp.lrp08                             #FUN-C60056 add
   #       AND lrpplant = g_lrp.lrpplant                       #FUN-C60056 add
   #    #WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01           #FUN-C60056 mark     
   #    #  AND lrp04=g_lrp.lrp04            #FUN-BC0079  add   #FUN-C60056 mark       
   #    #  AND lrp05=g_lrp.lrp05            #FUN-BC0079  add   #FUN-C60056 mark     
   #    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #       CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
   #       RETURN
   #    END IF
   #    LET g_lrp.lrppos = '4'
   #    DISPLAY BY NAME g_lrp.lrppos
   #    COMMIT WORK  #FUN-C40109 Add
   # END IF
   #FUN-CB0025 mark end ---

   #FUN-C40084 Mark&Add Begin ---
   #LET g_forupd_sql = "SELECT lth05,'',lth06,lth11,lth12,lth07,lth08,lth09,lth10 ",        #FUN-C40094 add lth11, lth12      
  #FUN-C60056 mark begin---
  # LET g_forupd_sql = "SELECT lth05,'',lth06,lth11,lth12,lth07,lth08,lth09,lth10,lthacti ",
  ##FUN-C40084 Mark&Add End -----
  #                    "  FROM lth_file",  
  #                    " WHERE lth01=? AND lth02=? AND lth03 = ? AND lth04 = ? AND lth05 = ? FOR UPDATE"    
  #FUN-C60056 mark end-----

    #FUN-C60056 add begin---
    LET g_forupd_sql = "SELECT lth05,'',lth06,lth11,lth12,lth15,lth16,lth17,lth18,lth19,lth20,lth07,lth08,lth09,lth10,lthacti ",
                       "  FROM lth_file",
                       " WHERE lth13=? AND lth14=? AND lthplant = ? AND lth05 = ? FOR UPDATE"
    #FUN-C60056 add end-----
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i555_bcl_1 CURSOR FROM g_forupd_sql      
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
 
    INPUT ARRAY g_lth WITHOUT DEFAULTS FROM s_lth.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF
  
           #FUN-C60056 add begin--- 
           IF g_lrp.lrpconf = 'Y' THEN
              CALL cl_err('','1208',0)
              RETURN
           END IF
           #FUN-C60056 add end------
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac1 = ARR_CURR()
           LET l_lock_sw = 'N'            
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           #OPEN i555_cl USING g_lrp00,g_lrp.lrp01,g_lrp_t.lrp04,g_lrp_t.lrp05   #FUN-C60056 mark
           OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant             #FUN-C60056 add
           IF STATUS THEN
              CALL cl_err("OPEN i555_cl:", STATUS, 1)
              CLOSE i555_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i555_cl INTO g_lrp.*     
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)   
              CLOSE i555_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b1 >= l_ac1 THEN
              LET p_cmd='u'
#FUN-CB0025 mark begin --
##FUN-C50036 add begin ---
#               IF g_aza.aza88 = 'Y' THEN
#                  IF l_lrppos <> '1' THEN
#                     CALL cl_set_comp_entry("lth05",FALSE)
#                  ELSE
#                     CALL cl_set_comp_entry("lth05",TRUE)
#                  END IF
#               END IF
##FUN-C50036 add end ---
#FUN-CB0025 mark end ----
              LET g_lth_t.* = g_lth[l_ac1].*
             #OPEN i555_bcl_1 USING g_lrp.lrp00,g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05,g_lth_t.lth05   #FUN-C60056 mark
              OPEN i555_bcl_1 USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrpplant,g_lth_t.lth05            #FUN-C60056 add
              IF STATUS THEN
                 CALL cl_err("OPEN i555_bcl_1:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i555_bcl_1 INTO g_lth[l_ac1].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lrp.lrp02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE
                    CALL i555_lth05('d')
                   #FUN-C40094 add START
                    IF NOT cl_null(g_lth[l_ac1].lth06) THEN
                       IF g_lth[l_ac1].lth06 <> '3' THEN
                          LET g_lth[l_ac1].lth11 = ''
                          LET g_lth[l_ac1].lth12 = ''
                          CALL cl_set_comp_entry('lth11,lth12',FALSE)
                          CALL cl_set_comp_required('lth11,lth12',FALSE)
                       ELSE
                          CALL cl_set_comp_entry('lth11,lth12',TRUE)
                          CALL cl_set_comp_required('lth11,lth12',TRUE)
                       END IF
                       #FUN-C70003 add begin---
                       IF g_Lth[l_ac1].lth06 = '4' THEN
                          CALL cl_set_comp_entry('lth15,lth16,lth17,lth18,lth19,lth20',TRUE)
                          CALL cl_set_comp_required('lth15,lth16,lth17,lth18',TRUE)
                       ELSE
                          LET g_lth[l_ac1].lth15 = null
                          LET g_lth[l_ac1].lth16 = null
                          LET g_lth[l_ac1].lth17 = null
                          LET g_lth[l_ac1].lth18 = null
                          LET g_lth[l_ac1].lth19 = null
                          LET g_lth[l_ac1].lth20 = null
                          CALL cl_set_comp_entry('lth15,lth16,lth17,lth18,lth19,lth20',FALSE)
                          CALL cl_set_comp_required('lth15,lth16,lth17,lth18',FALSE)
                       END IF
                       #FUN-C70003 add end-----
                    END IF
                   #FUN-C40094 add END
                 END IF
              END IF
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           CALL cl_set_comp_entry("lth05",TRUE)     #FUN-C50036 add
           LET l_n = ARR_COUNT()
           INITIALIZE g_lth[l_ac1].* TO NULL      
           IF g_lrp00 = '1' THEN
              LET g_lth[l_ac1].lth10 = 0
           ELSE
              LET g_lth[l_ac1].lth07 = 0
              LET g_lth[l_ac1].lth08 = 0
              LET g_lth[l_ac1].lth09 = 0
           END IF  
           LET g_lth[l_ac1].lthacti = 'Y'        #FUN-C40084 Add
           LET g_lth[l_ac1].lth17 = '00:00:00'   #FUN-C60056 add
           LET g_lth[l_ac1].lth18 = '23:59:59'   #FUN-C60045 add
           LET g_lth_t.* = g_lth[l_ac1].*    
           NEXT FIELD lth05
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           IF cl_null(g_lth[l_ac1].lth20) THEN
              LET g_lth[l_ac1].lth20 = ' '
           END IF 

          #FUN-C40084 Mark&Add Begin ---
          #INSERT INTO lth_file(lth01,lth02,lth03,lth04,lth05,lth06,lth07,lth08,lth09,lth10,lth11,lth12)      #FUN-C40094 add lth11, lth12                
          #VALUES(g_lrp.lrp00,g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05,g_lth[l_ac1].lth05,
          #       g_lth[l_ac1].lth06,g_lth[l_ac1].lth07,g_lth[l_ac1].lth08,
          #       g_lth[l_ac1].lth09,g_lth[l_ac1].lth10,g_lth[l_ac1].lth11,g_lth[l_ac1].lth12)  #FUN-C40094 add lth11, lth12

           INSERT INTO lth_file(lth01,lth02,lth03,lth04,lth05,lth06,lth07,
                                lth08,lth09,lth10,lth11,lth12,lthacti,
                                lthdate,lthgrup,lthmodu,lthorig,lthoriu,lthuser,                              #FUN-C60056 add
                                lth13,lth14,lth15,lth16,lth17,lth18,lth19,lth20,lthlegal,lthplant)            #FUN-C60056 add
           VALUES(g_lrp.lrp00,g_lrp.lrp01,g_lrp.lrp04,g_lrp.lrp05,g_lth[l_ac1].lth05,
                  g_lth[l_ac1].lth06,g_lth[l_ac1].lth07,
                  g_lth[l_ac1].lth08,g_lth[l_ac1].lth09,
                  g_lth[l_ac1].lth10,g_lth[l_ac1].lth11,g_lth[l_ac1].lth12,g_lth[l_ac1].lthacti,
                  g_today,g_grup,g_user,g_grup,g_user,g_user,                                               #FUN-C60056 add
                  g_lrp.lrp06,g_lrp.lrp07,g_lth[l_ac1].lth15,g_lth[l_ac1].lth16,g_lth[l_ac1].lth17,         #FUN-C60056 add
                  g_lth[l_ac1].lth18,g_lth[l_ac1].lth19,g_lth[l_ac1].lth20,g_legal,g_plant                                #FUN-C60056 add
                  )
          #FUN-C40084 Mark&Add End -----
                 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lth_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
             #FUN-CB0025 mark begin ---
             ##FUN-C40109 Add Begin ---
             # LET l_pos_str = 'Y'
             # IF l_lrppos <> '1' THEN
             #    LET l_lrppos = '2'
             # ELSE
             #    LET l_lrppos = '1'
             # END IF
             ##FUN-C40109 Add End -----
             #FUN-CB0025 mark end ----
              LET g_rec_b1=g_rec_b1+1
              DISPLAY g_rec_b1 TO FORMONLY.cn3
           END IF
                   
        AFTER FIELD lth05
           IF NOT cl_null(g_lth[l_ac1].lth05) THEN
              CALL i555_lth05(p_cmd)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err('',g_errno,0)
                 LET g_lth[l_ac1].lth05 = g_lth_t.lth05
                 NEXT FIELD lth05
              END IF 
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lth_t.lth05 != g_lth[l_ac1].lth05) THEN 
                   #FUN-C70003 mark begin---
                   #SELECT COUNT(*) INTO l_n
                   #  FROM lth_file
                   # WHERE lth01=g_lrp00
                   #   AND lth02=g_lrp.lrp01
                   #   AND lth05=g_lth[l_ac1].lth05
                   #   AND (lth03 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                   #    OR  lth04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                   #    OR  g_lrp.lrp04 BETWEEN lth03 AND lth04)
                   #FUN-C70003 mark end-----
                   #FUN-C70003 add begin---
                   SELECT COUNT(*) INTO l_n
                     FROM lth_file
                    WHERE lth13 = g_lrp.lrp06
                      AND lth14 = g_lrp.lrp07
                      AND lthplant = g_lrp.lrpplant
                      AND lth05=g_lth[l_ac1].lth05
                      AND (lth03 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                       OR  lth04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
                       OR  g_lrp.lrp04 BETWEEN lth03 AND lth04)
                   #FUN-c70003 add end-----
                   IF l_n>0 THEN
                      CALL cl_err('','-239',1)
                      LET g_lth[l_ac1].lth05 = g_lth_t.lth05
                      DISPLAY '' TO lth05_desc 
                      NEXT FIELD lth05
                   END IF
              END IF 
           END IF  
 
       #FUN-C40094 add START
        AFTER FIELD lth06
          IF NOT cl_null(g_lth[l_ac1].lth06) THEN
             IF g_lth[l_ac1].lth06 <> '3' THEN
                LET g_lth[l_ac1].lth11 = ''
                LET g_lth[l_ac1].lth12 = ''
                CALL cl_set_comp_entry('lth11,lth12',FALSE) 
                CALL cl_set_comp_required('lth11,lth12',FALSE)
             ELSE 
                CALL cl_set_comp_entry('lth11,lth12',TRUE)
                CALL cl_set_comp_required('lth11,lth12',TRUE)
             END IF 
             #FUN-C60056 add begin---
             IF g_lth[l_ac1].lth06 = '4' THEN
                CALL cl_set_comp_required('lth15,lth16.lth17,lth18',TRUE)
             ELSE
                CALL cl_set_comp_required('lth15,lth16.lth17,lth18',FALSE)
             END IF
             #FUN-C60056 add end---
          END IF

        ON CHANGE lth06
          IF NOT cl_null(g_lth[l_ac1].lth06) THEN
             IF g_lth[l_ac1].lth06 <> '3' THEN
                LET g_lth[l_ac1].lth11 = ''
                LET g_lth[l_ac1].lth12 = ''
                CALL cl_set_comp_entry('lth11,lth12',FALSE) 
                CALL cl_set_comp_required('lth11,lth12',FALSE)
             ELSE
                CALL cl_set_comp_entry('lth11,lth12',TRUE)
                CALL cl_set_comp_required('lth11,lth12',TRUE)
             END IF

             #FUN-C60056 add begin---
             IF g_Lth[l_ac1].lth06 = '4' THEN
                CALL cl_set_comp_entry('lth15,lth16,lth17,lth18,lth19,lth20',TRUE)
                CALL cl_set_comp_required('lth15,lth16,lth17,lth18',TRUE)
             ELSE
                LET g_lth[l_ac1].lth15 = null
                LET g_lth[l_ac1].lth16 = null
                LET g_lth[l_ac1].lth17 = null
                LET g_lth[l_ac1].lth18 = null
                LET g_lth[l_ac1].lth19 = null
                LET g_lth[l_ac1].lth20 = null
                CALL cl_set_comp_entry('lth15,lth16,lth17,lth18,lth19,lth20',FALSE)
                CALL cl_set_comp_required('lth15,lth16,lth17,lth18',FALSE)
             END IF
             #FUN-C60056 add end-----
          END IF


        AFTER FIELD lth11
          IF NOT cl_null(g_lth[l_ac1].lth06) AND g_lth[l_ac1].lth06 = '3'      
              AND NOT cl_null(g_lth[l_ac1].lth11) THEN
             IF g_lth[l_ac1].lth11 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD lth11
             END IF   
          END IF

        AFTER FIELD lth12
          IF NOT cl_null(g_lth[l_ac1].lth06) AND g_lth[l_ac1].lth06 = '3'       
              AND NOT cl_null(g_lth[l_ac1].lth12) THEN
             IF g_lth[l_ac1].lth12 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD lth12
             END IF
          END IF
       #FUN-C40094 add END
  
        #FUN-C60056 add begin---
        AFTER FIELD lth15
           IF NOT cl_null(g_lth[l_ac1].lth15) THEN
              IF g_lth[l_ac1].lth15 < g_lrp.lrp04 THEN
                 CALL cl_err('','alm-h53',0)
                 NEXT FIELD lth15
              END IF
      
              IF g_lth[l_ac1].lth15 > g_lrp.lrp05 THEN
                 CALL cl_err('','alm-h53',0)
                 NEXT FIELD lth15
              END IF
           END IF

        AFTER FIELD lth16
           IF NOT cl_null(g_lth[l_ac1].lth16) THEN
              IF g_lth[l_ac1].lth16 < g_lrp.lrp04 THEN
                 CALL cl_err('','alm-h54',0)
                 NEXT FIELD lth16
              END IF

              IF g_lth[l_ac1].lth16 > g_lrp.lrp05 THEN
                 CALL cl_err('','alm-h54',0)
                 NEXT FIELD lth16
              END IF
           END IF
        #FUN-C60056 add end-----

        AFTER FIELD lth07
          IF NOT cl_null(g_lth[l_ac1].lth07) THEN
             IF g_lth[l_ac1].lth07 <= 0 THEN
                CALL cl_err('','alm1488',0)
                LET g_lth[l_ac1].lth07 = g_lth_t.lth07
                NEXT FIELD lth07
             END IF 
          END IF 


        AFTER FIELD lth08
          IF NOT cl_null(g_lth[l_ac1].lth08) THEN
             IF g_lth[l_ac1].lth08 <= 0 THEN
                CALL cl_err('','alm1489',0)
                LET g_lth[l_ac1].lth08 = g_lth_t.lth08
                NEXT FIELD lth08
             END IF
          END IF

        AFTER FIELD lth09
          IF NOT cl_null(g_lth[l_ac1].lth09) THEN
             IF g_lth[l_ac1].lth09 < 0 THEN
                CALL cl_err('','alm1490',0)
                LET g_lth[l_ac1].lth09 = g_lth_t.lth09
                NEXT FIELD lth09
             END IF
          END IF  

        AFTER FIELD lth10
           IF NOT cl_null(g_lth[l_ac1].lth10) THEN
              IF g_lth[l_ac1].lth10 < 1 OR g_lth[l_ac1].lth10 > 100 THEN
                  CALL cl_err('','alm1491',0)
                  LET g_lth[l_ac1].lth10 = g_lth_t.lth10
                  NEXT FIELD lth10
              END IF 
           END IF 
        BEFORE DELETE    
           IF NOT cl_null(g_lth_t.lth05) THEN
            #FUN-CB0025 mark begin ---
            ##FUN-C40084 Add Begin ---
            #  IF g_aza.aza88 = 'Y' THEN
            #     IF l_lrppos = '1' OR (l_lrppos = '3' AND g_lth_t.lthacti = 'N') THEN
            #     ELSE
            #        CALL cl_err('','apc-155',0)
            #        CANCEL DELETE
            #     END IF
            #  END IF
            ##FUN-C40084 Add End -----
            #FUN-CB0025 mark end ---
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lth_file
               WHERE lth13 = g_lrp.lrp06         #FUN-C60056 add 
                 AND lth14 = g_lrp.lrp07         #FUN-C60056 add  
                 AND lthplant = g_lrp.lrpplant   #FUN-C60056 add      
                 AND lth05 = g_lth_t.lth05       #FUN-C60056 add      
              #WHERE lth01 = g_lrp.lrp00         #FUN-C60056 mark          
              #  AND lth02 = g_lrp01_t           #FUN-C60056 mark        
              #  AND lth03 = g_lrp_t.lrp04       #FUN-C60056 mark           
              #  AND lth04 = g_lrp_t.lrp05       #FUN-C60056 mark            
              #  AND lth05 = g_lth_t.lth05       #FUN-C60056 mark       
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lth_file","","",SQLCA.sqlcode,"","",1)   
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn3
           END IF
           COMMIT WORK
 
        #FUN-C60056 add begin---
        AFTER FIELD lth20
           IF cl_null(g_lth[l_ac1].lth20) THEN
              LET g_lth[l_ac1].lth20 = ' '
           END IF
        #FUN-C60056 add end-----

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lth[l_ac1].* = g_lth_t.*
              CLOSE i555_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lth[l_ac1].lth05,-263,1)
              LET g_lth[l_ac1].* = g_lth_t.*
           ELSE
              #FUN-C60056 add begin---
              IF cl_null(g_lth[l_ac1].lth20) THEN
                 LET g_lth[l_ac1].lth20 = ' ' 
              END IF
              #FUN-C60056 add end-----

              UPDATE lth_file SET lth05=g_lth[l_ac1].lth05, 
                                  lth06=g_lth[l_ac1].lth06,
                                  lth07=g_lth[l_ac1].lth07,
                                  lth08=g_lth[l_ac1].lth08,
                                  lth09=g_lth[l_ac1].lth09, 
                                  lth10=g_lth[l_ac1].lth10,
                                  lth11=g_lth[l_ac1].lth11,          #FUN-C40094 add
                                  lth12=g_lth[l_ac1].lth12,          #FUN-C40094 add FUN-C40084 Add ,
                                  lthacti = g_lth[l_ac1].lthacti,    #FUN-C40084 Add
                                  lth15=g_lth[l_ac1].lth15,          #FUN-C60056 add
                                  lth16=g_lth[l_ac1].lth16,          #FUN-C60056 add
                                  lth17=g_lth[l_ac1].lth17,          #FUN-C60056 add 
                                  lth18=g_lth[l_ac1].lth18,          #FUN-C60056 add 
                                  lth19=g_lth[l_ac1].lth19,          #FUN-C60056 add 
                                  lth20=g_lth[l_ac1].lth20           #FUN-C60056 add 
              #WHERE lth01 = g_lrp.lrp00       #FUN-C60056 mark
              #  AND lth02 = g_lrp_t.lrp01     #FUN-C60056 mark
              #  AND lth03 = g_lrp_t.lrp04     #FUN-C60056 mark
              #  AND lth04 = g_lrp_t.lrp05     #FUN-C60056 mark
               WHERE lth13 = g_lrp.lrp06       #FUN-C60056 add
                 AND lth14 = g_lrp_t.lrp07     #FUN-C60056 add
                 AND lthplant = g_lrp_t.lrpplant     #FUN-C60056 add
                 AND lth05 = g_lth_t.lth05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lth_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)  
                 LET g_lth[l_ac1].* = g_lth_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
                #FUN-CB0025 mark begin ---
                ##FUN-C40109 Add Begin ---
                # LET l_pos_str = 'Y'
                # IF l_lrppos <> '1' THEN
                #    LET l_lrppos = '2'
                # ELSE
                #    LET l_lrppos = '1'
                # END IF
                ##FUN-C40109 Add End -----
                #FUN-CB0025 mark end ---
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac1 = ARR_CURR()
           LET l_ac1_t = l_ac1
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lth[l_ac1].* = g_lth_t.*
                 CALL i555_delall()    #FUN-C60056 add
              END IF
              CLOSE i555_bcl_1
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i555_bcl_1
           COMMIT WORK
 
        ON ACTION CONTROLO     
           IF INFIELD(lth02) AND l_ac1 > 1 THEN
              LET g_lth[l_ac1].* = g_lth[l_ac1-1].*
              LET g_lth[l_ac1].lth05 = g_rec_b1 + 1
              NEXT FIELD lth05
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lth05)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpc01_1" 
                 LET g_qryparam.arg1 = '8'  
                 LET g_qryparam.where = " lpcacti = 'Y' "
                 LET g_qryparam.default1 = g_lth[l_ac1].lth05
                 CALL cl_create_qry() RETURNING g_lth[l_ac1].lth05
                 DISPLAY BY NAME g_lth[l_ac1].lth05
                 CALL i555_lth05('d')
                 NEXT FIELD lth05
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
 
    END INPUT
    CLOSE i555_bcl_1
    COMMIT WORK
    #FUN-CB0025 mark begin --- 
    #IF g_aza.aza88 = 'Y' THEN
    #   #FUN-C60056 mark begin---
    #   #IF l_pos_str = 'Y' THEN
    #   #   IF l_lrppos <> '1' THEN
    #   #      LET g_lrp.lrppos = '2'
    #   #   ELSE
    #   #      LET g_lrp.lrppos = '1'
    #   #   END IF
    #   #   UPDATE lrp_file SET lrppos = g_lrp.lrppos
    #   #    WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01                
    #   #      AND lrp04=g_lrp.lrp04            #FUN-BC0079  add            
    #   #      AND lrp05=g_lrp.lrp05            #FUN-BC0079  add    
    #   #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #   #      CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
    #   #      RETURN
    #   #   END IF
    #   #   DISPLAY BY NAME g_lrp.lrppos
    #   #ELSE
    #   #   UPDATE lrp_file SET lrppos = l_lrppos
    #   #    WHERE lrp00=g_lrp00 AND lrp01 = g_lrp.lrp01
    #   #      AND lrp04=g_lrp.lrp04            #FUN-BC0079  add
    #   #      AND lrp05=g_lrp.lrp05            #FUN-BC0079  add
    #   #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #   #      CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
    #   #      RETURN
    #   #   END IF
    #   #   LET g_lrp.lrppos = l_lrppos
    #   #   DISPLAY BY NAME g_lrp.lrppos
    #   #END IF
    #   #FUN-C60056 mark end-----

    #   #FUN-C60056 add begin---
    #   IF l_pos_str = 'Y' THEN
    #      IF l_lrppos <> '1' THEN
    #         LET g_lrp.lrppos = '2'
    #      ELSE
    #         LET g_lrp.lrppos = '1'
    #      END IF
    #   ELSE
    #     LET g_lrp.lrppos = l_lrppos
    #   END IF  
 
    #   UPDATE lrp_file SET lrppos = l_lrppos
    #    WHERE lrp06 = g_lrp.lrp06
    #      AND lrp07 = g_lrp.lrp07
    #      AND lrp08 = g_lrp.lrp08           
    #      AND lrpplant = g_lrp.lrpplant          
    #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #      CALL cl_err3("upd","lrp_file",g_lrp.lrp01,"",SQLCA.sqlcode,"","",1)
    #      RETURN
    #   END IF

    #   DISPLAY BY NAME g_lrp.lrppos          
    #   #FUN-C60056 add end-----
    #END IF 
    #FUN-CB0025 mark end ---

END FUNCTION

FUNCTION i555_lth05(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_lpcacti LIKE lpc_file.lpcacti
   DEFINE l_lpc02   LIKE lpc_file.lpc02
   LET g_errno = '' 
   SELECT lpc02,lpcacti INTO l_lpc02,l_lpcacti
     FROM lpc_file 
    WHERE lpc01 = g_lth[l_ac1].lth05
      AND lpc00 = '8'
   CASE
      WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm1484' 
                              LET l_lpc02 = ''
      WHEN l_lpcacti <> 'Y'   LET g_errno = 'alm1485'
                              LET l_lpc02 = ''
      OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'   
   END CASE   
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_lth[l_ac1].lth05_desc = l_lpc02
   END IF    
END FUNCTION 
#FUN-BC0079 add END----
FUNCTION i555_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE  l_s      LIKE type_file.chr1000
DEFINE  l_m      LIKE type_file.chr1000
DEFINE  i        LIKE type_file.num5
DEFINE  l_n      LIKE type_file.num5

 #FUN-C60056 mark begin---
 ##FUN-C40084 Mark&Add Begin ---
 ##LET g_sql = "SELECT lrq02,'',lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09 ", #FUN-BC0112 add lrq06,lrq07,lrq08,lrq09
 # LET g_sql = "SELECT lrq02,'',lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrqacti ",
 ##FUN-C40084 Mark&Add End -----
 #             "  FROM lrq_file",    
 #             " WHERE lrq00= '",g_lrp00,"' AND lrq01 ='",g_lrp.lrp01,"' ",
 #             "   AND lrq10 = '",g_lrp.lrp04,"'",
 #             "   AND lrq11 = '",g_lrp.lrp05,"'"      
 #FUN-C60056 mark end-----

  #FUN-C60056 add begin---
   LET g_sql = "SELECT lrq02,'',lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrqacti",
               "  FROM lrq_file",
               " WHERE lrq12 = '", g_lrp.lrp06,"' ",
               "   AND lrq13 = '", g_lrp.lrp07,"' ",
               "   AND lrqplant = '",g_lrp.lrpplant,"' ", 
               "   AND lrq00= '",g_lrp00,"'"                #FUN-C70003 add
  #FUN-C60056 and end-----

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lrq02 "

   DISPLAY g_sql

   PREPARE i555_pb FROM g_sql
   DECLARE lrq_cs CURSOR FOR i555_pb

   CALL g_lrq.clear()
   LET g_cnt = 1

   FOREACH lrq_cs INTO g_lrq[g_cnt].*   #虫ō ARRAY 恶
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE g_lrp.lrp02
          WHEN "1"
#FUN-BC0058  MARK---
#             SELECT lpf02 INTO g_lrq[g_cnt].lrq02_1 FROM lpf_file
#              WHERE lpf01=g_lrq[g_cnt].lrq02    
#FUN-BC0058  MARK---
#FUN-BC0058 BEGIN---
             SELECT lpc02 INTO g_lrq[g_cnt].lrq02_1 FROM lpc_file
              WHERE lpc01 = g_lrq[g_cnt].lrq02
                AND lpc00 = '6'
#FUN-BC0058 END---
          WHEN "2"
#FUN-BC0112 -----add----- begin
             IF g_argv1 = '3' THEN
                SELECT lpc02 INTO g_lrq[g_cnt].lrq02_1 FROM lpc_file
                 WHERE lpc01 = g_lrq[g_cnt].lrq02
                   AND lpc00 = '7'
             ELSE
#FUN-BC0112 -----add----- end
                SELECT oba02 INTO g_lrq[g_cnt].lrq02_1 FROM oba_file
                 WHERE oba01=g_lrq[g_cnt].lrq02
             END IF   #FUN-BC0112 add
          WHEN "3"
             SELECT tqa02 INTO g_lrq[g_cnt].lrq02_1 FROM tqa_file
              WHERE tqa01=g_lrq[g_cnt].lrq02
                AND tqa03='2'          #No.MOD-A60121
          WHEN "4"
             SELECT ima02 INTO g_lrq[g_cnt].lrq02_1 FROM ima_file
              WHERE ima01=g_lrq[g_cnt].lrq02    
       END CASE 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lrq.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

#FUN-BC0079 add BEGIN---
FUNCTION i555_b1_fill(p_wc2) 
DEFINE p_wc2   STRING

  #FUN-C40084 Mark&Add Begin ---
  #LET g_sql = "SELECT lth05,'',lth06,lth11,lth12,lth07,lth08,lth09,lth10 ",  #FUN-C40094 add lth11,lth12
   LET g_sql = "SELECT lth05,'',lth06,lth11,lth12,lth15,lth16,lth17,lth18,lth19,lth20,lth07,lth08,lth09,lth10,lthacti ",   #FUN-C60056 add lth15~lth20
  #FUN-C40084 Mark&Add End -----
               "  FROM lth_file",
  #            " WHERE lth01= '",g_lrp00,"' AND lth02 ='",g_lrp.lrp01,"' ",    #FUN-C60056 mark     
  #            "   AND lth03 = '",g_lrp.lrp04,"'",                             #FUN-C60056 mark   
  #            "   AND lth04 = '",g_lrp.lrp05,"'"                              #FUN-C60056 mark   
               " WHERE lth13 = '",g_lrp.lrp06,"' ",                            #FUN-C60056 add  
               "   AND lth14 = '",g_lrp.lrp07,"' ",                            #FUN-C60056 add        
               "   AND lthplant = '",g_lrp.lrpplant,"' ",                      #FUN-C60056 add 
               "   AND lth01 = '",g_lrp00,"' "                                 #FUN-C70003 add         

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lth05 "

   DISPLAY g_sql

   PREPARE i555_pb_1 FROM g_sql
   DECLARE lth_cs CURSOR FOR i555_pb_1

   CALL g_lth.clear()
   LET g_cnt = 1

   FOREACH lth_cs INTO g_lth[g_cnt].*   #虫ō ARRAY 恶
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT lpc02 INTO g_lth[g_cnt].lth05_desc FROM lpc_file
        WHERE lpc01 = g_lth[g_cnt].lth05
          AND lpc00 = '8'
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lth.deleteElement(g_cnt)

   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0 
END FUNCTION 
#FUN-BC0079 add END ---

FUNCTION i555_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lrp01,lrp04,lrp05,lrp07,lrp11",TRUE)    #FUN-C60056 add lrp07,lrp11    #FUN-C50036 add lrp04,lrp05
    END IF
END FUNCTION

FUNCTION i555_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      #CALL cl_set_comp_entry("lrp01,lrp04,lrp05",FALSE)  #FUN-C50036 add lrp04,lrp05   #FUN-C60056 mark
       CALL cl_set_comp_entry("lrp00,lrp07",FALSE)        #FUN-C60056 add
    END IF
   #FUN-CB0025 mark begin ---
   # #FUN-C50036 Begin---
   # IF g_aza.aza88 = 'Y' AND p_cmd = 'u' THEN
   #    IF g_lrppos <> '1' THEN
   #      #CALL cl_set_comp_entry("lrp00,lrp01,lrp04,lrp05",FALSE)   #FUN-C60056 mark
   #       CALL cl_set_comp_entry("lrp00,lrp07",FALSE)               #FUN-C60056 add
   #    END IF 
   # END IF
   # #FUN-C50036 End-----
   #FUN-CB0025 mark end ---

END FUNCTION

#FUNCTION i555_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1
#
#     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
#      CALL cl_set_comp_entry("lrq02",TRUE)
#     END IF
#END FUNCTION
#
#FUNCTION i555_set_no_entry_b(p_cmd,p_w)
#  DEFINE p_cmd   LIKE type_file.chr1
#  DEFINE p_w     LIKE lrp_file.lrp13
#
#    IF p_cmd = 'u' AND g_chkey = 'N' AND p_w!=0 THEN
#      CALL cl_set_comp_entry("lrq02",FALSE)
#    END IF
#END FUNCTION

FUNCTION i555_exclude_detail()
DEFINE     l_cmd         LIKE type_file.chr1000

    IF g_lrp.lrp01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    IF g_lrp.lrp03='1' THEN 
       CALL cl_err('','alm-811',1)
       RETURN 
    END IF   
    
   #FUN-C40109 Mark&Add Begin ---
   #LET l_cmd="almi5551 '",g_lrp00 CLIPPED,"' '",g_lrp.lrp01 CLIPPED,"' "
   #CALL cl_cmdrun(l_cmd)
   #LET l_cmd="almi5551 '",g_lrp00 CLIPPED,"' '",g_lrp.lrp01 CLIPPED,"' '",g_lrp.lrp04 CLIPPED,"' '",g_lrp.lrp05 CLIPPED,"' "   #FUN-C60056 mark
    LET l_cmd = "almi5551 '",g_lrp.lrp06 CLIPPED,"' '",g_lrp.lrp07 CLIPPED,"' ",g_lrp.lrp08," '",g_lrp.lrpplant CLIPPED,"' "
    CALL cl_cmdrun_wait(l_cmd)

   #FUN-C40109 Mark&Add End -----

   #No.FUN-A80022 Begin---
    SELECT lrppos INTO g_lrp.lrppos FROM lrp_file
     WHERE lrp00=g_lrp00
       AND lrp01=g_lrp.lrp01
       AND lrp04=g_lrp.lrp04 #FUN-C40109 Add
       AND lrp05=g_lrp.lrp05 #FUN-C40109 Add
    DISPLAY BY NAME g_lrp.lrppos
   #No.FUN-A80022 End-----
END FUNCTION 

#FUN-C60056 add begin---
FUNCTION i555_msg(p_cmd)
   DEFINE p_cmd LIKE type_file.chr30
   
   IF cl_null(g_lrp.lrp07) THEN
      LET g_errno = '-400'          #請先選取欲處理的資料
      RETURN
   END IF

   IF p_cmd <> 'eff_plant' THEN
      IF g_lrp.lrp06 <> g_plant THEN
         LET g_errno = 'art-977'       #目前鎖在營運中心不是制定營運中心,不可修改
         RETURN
      END IF

      IF g_lrp.lrp09 = 'Y' THEN
         LET g_errno = 'alm-h55'       #F已發佈,不可修改
         RETURN
      END IF
   END IF

   IF p_cmd = 'conf' THEN
      IF g_lrp.lrpconf ='Y' THEN    #已確認
         LET g_errno = '1208'
         RETURN
      END IF
   END IF

   IF p_cmd = 'unconf' THEN
      IF g_lrp.lrpacti='N' THEN
         LET g_errno = 'alm-973'    #資料無效,不可取消確認
         RETURN
      END IF

      IF g_lrp.lrpconf ='N' THEN
         LET g_errno = '9025'       #尚未確認,不可取消確認
         RETURN
      END IF
   END IF

   IF p_cmd = 'release' THEN
      IF g_lrp.lrp09 = 'Y' THEN
         LET g_errno = 'alm-h63'    #已發佈
         RETURN
      END IF
   
      IF g_lrp.lrpacti = 'N' THEN
         LET g_errno = 'alm-h60'    #資料無效,不可發佈
         RETURN
      END IF
   
      IF g_lrp.lrpconf = 'N' THEN
         LET g_errno = 'alm-h64'    #資料未確定,不可發佈
         RETURN  
      END IF
   END IF 

   IF p_cmd = 'mod' THEN
      IF g_lrp.lrp09 = 'Y' THEN     #已發佈時不允許修改
         LET g_errno = 'alm-h55'
         RETURN
      END IF

      IF g_lrp.lrpconf = 'Y' THEN   #已確認時不允許修改
         LET g_errno = 'alm-027'
         RETURN
      END IF
   END IF    
   
   LET g_errno = NULL
END FUNCTION

FUNCTION i555_conf()
   DEFINE l_cnt LIKE type_file.num5

   CALL i555_msg('conf')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
  
   #FUN-C70003 add begin---
   LET l_cnt = 0 
      IF g_lrp.lrp03 <> '1' THEN
      SELECT COUNT(*) INTO l_cnt FROM lrr_file
       WHERE lrr05 = g_lrp.lrp06
         AND lrr06 = g_lrp.lrp07
         AND lrrplant = g_lrp.lrpplant

      IF l_cnt <= 0 THEN
         CALL cl_err('','alm-h68',0)
         RETURN
      END IF
   END IF
   #FUN-C70003 add end-----   

   LET l_cnt = 0 #FUN-C70003 add
   SELECT COUNT(*) INTO l_cnt FROM lso_file
    WHERE lso01 = g_lrp.lrp06
      AND lso02 = g_lrp.lrp07
      AND lso03 = g_lrp.lrp00

   IF l_cnt = 0 THEN
      CALL cl_err('','art-546',0)
      RETURN
   END IF

   CALL i555_ckmult()   
    IF g_success = 'N' THEN RETURN END IF #FUN-C70003 add

   IF NOT cl_confirm('axm-108') THEN RETURN END IF

   SELECT COUNT(*) INTO l_cnt FROM lso_file
    WHERE lso01 = g_lrp.lrp06
      AND lso02 = g_lrp.lrp07
      AND lso03 = g_lrp.lrp00
      AND lso04 NOT IN (SELECT lnk03 FROM lnk_file
                         WHERE lnk01 = g_lrp.lrp01
                          AND lnk05 = 'Y' )

   IF l_cnt > 0 THEN
      CALL cl_err('','alm-h61',0)
      RETURN
   END IF

   #FUN-C70003 add begin---
   SELECT COUNT(*) INTO l_cnt FROM lso_file
    WHERE lso01 = g_lrp.lrp06
      AND lso02 = g_lrp.lrp07
      AND lso03 = g_lrp.lrp00
      AND lso04 = g_lrp.lrpplant
      AND lsoplant = g_lrp.lrpplant

   IF l_cnt = 0 THEN
      CALL cl_err('','alm-h42',0)
      RETURN
   END IF
   #FUN-C70003 add end-----

   LET g_action_choice = ""

   UPDATE lrp_file
      SET lrpcond = g_today,
          lrpconf = 'Y',
          lrpconu = g_user,
          lrpuser = g_user,
          lrpdate = g_today,
          lrpmodu = g_user
    WHERE lrp06 = g_lrp.lrp06
      AND lrp07 = g_lrp.lrp07
      AND lrp08 = g_lrp.lrp08
      AND lrpplant = g_plant

    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lrp_file",g_lrp.lrp07,"",SQLCA.sqlcode,"","lrp06",1)
       ROLLBACK WORK
    ELSE
       COMMIT WORK

       LET g_lrp.lrpcond = g_today
       LET g_lrp.lrpconf = 'Y' 
       LET g_lrp.lrpconu = g_user
       LET g_lrp.lrpdate = g_today
       LET g_lrp.lrpmodu = g_user
       LET g_lrp.lrpuser = g_user
       DISPLAY BY NAME g_lrp.lrpcond
       DISPLAY BY NAME g_lrp.lrpconf
       DISPLAY BY NAME g_lrp.lrpconu
       DISPLAY BY NAME g_lrp.lrpdate
       DISPLAY BY NAME g_lrp.lrpmodu
       DISPLAY BY NAME g_lrp.lrpuser
       
       CALL i555_pic()
   END IF

END FUNCTION

FUNCTION i555_unconf()
   DEFINE l_cnt LIKE type_file.num5

   CALL i555_msg('unconf')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   IF cl_confirm('aap-224') THEN
      BEGIN WORK
   #  UPDATE lrp_file SET lrpcond = null,    #CHI-D20015 mark
      UPDATE lrp_file SET lrpcond = g_today,  #CHI-D20015 add
                          lrpconf = 'N',
                        # lrpconu = NULL,    #CHI-D20015 mark
                          lrpconu = g_user,   #CHI-D20015 add
                          lrpdate = g_today,
                          lrpmodu = g_user
       WHERE lrp06 = g_lrp.lrp06
         AND lrp07 = g_lrp.lrp07
         AND lrp08 = g_lrp.lrp08
         AND lrpplant = g_lrp.lrpplant

      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lrp_file",g_lrp.lrp07,"",SQLCA.sqlcode,"","lrp06",1)
         ROLLBACK WORK
      ELSE
         COMMIT WORK

        # LET g_lrp.lrpcond = null    #CHI-D20015 mark
         LET g_lrp.lrpcond = g_today  #CHI-D20015 add
         LET g_lrp.lrpconf = 'N'
         #LET g_lrp.lrpconu = NULL    #CHI-D20015 mark
         LET g_lrp.lrpconu = g_user   #CHI-D20015 add 
         LET g_lrp.lrpdate = g_today
         LET g_lrp.lrpmodu = g_user
         DISPLAY BY NAME g_lrp.lrpcond
         DISPLAY BY NAME g_lrp.lrpconf
         DISPLAY BY NAME g_lrp.lrpconu
         DISPLAY BY NAME g_lrp.lrpdate
         DISPLAY BY NAME g_lrp.lrpmodu

         CALL i555_pic()
      END IF
   END IF
  
END FUNCTION

FUNCTION i555_eff_plant()
   CALL i555_msg('eff_plant')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   CALL i555_sub(g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp00,g_lrp.lrp01)
END FUNCTION

FUNCTION i555_x()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_upd LIKE type_file.chr1

   LET l_cnt = 0 
   LET l_upd = null

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL i555_msg('invalid')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   #FUN-C70003 mark begin---
   #IF g_lrp.lrpacti = 'Y' THEN
   #   IF cl_confirm("lib-010") THEN
   #      LET l_upd = 'Y'
   #   ELSE
   #     RETURN
   #   END IF
   #ELSE     #lrpacti = 'N'
   #FUN-C70003 mark end -----

      SELECT count(*) INTO l_cnt FROM lrp_file
       WHERE lrp00 = g_lrp.lrp00
         AND lrp01 = g_lrp.lrp01
         AND lrp06 = g_plant
         AND lrpacti = 'Y'
         #FUN-C70003 add beign---
         AND (lrp04 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
              OR  lrp05 BETWEEN g_lrp.lrp04 AND g_lrp.lrp05
              OR  g_lrp.lrp04 BETWEEN lrp04 AND lrp05)
         #FUN-C70003 add end-----

      IF l_cnt > 0 THEN
         CALL cl_err('','alm-h57',0)
   #FUN-C70003 mark begin---
   #  ELSE
   #     IF cl_confirm("lib-011") THEN
   #        LET l_upd = 'Y'
   #     ELSE
   #        RETURN
   #     END IF
      END IF
   #END IF

   #IF l_upd = 'Y' THEN
   #FUN-C70003 mark end---
      BEGIN WORK

     #OPEN i555_cl USING g_lrp.lrp01      #FUN-C70003 mark
      OPEN i555_cl USING g_lrp.lrp06,g_lrp.lrp07,g_lrp.lrp08,g_lrp.lrpplant
      IF STATUS THEN
         CALL cl_err("OPEN lrp_cl:", STATUS, 1)
         CLOSE i555_cl
         ROLLBACK WORK
         RETURN
      END IF

      FETCH i555_cl INTO g_lrp.*               # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lrp.lrp01,SQLCA.sqlcode,0)          #資料被他人LOCK
         ROLLBACK WORK
         RETURN
      END IF

      LET g_success = 'Y'

      CALL i555_show()

      IF cl_exp(0,0,g_lrp.lrpacti) THEN                   #確認一下
         LET g_chr=g_lrp.lrpacti
         IF g_lrp.lrpacti='Y' THEN
            LET g_lrp.lrpacti = 'N'
            LET g_lrp.lrpmodu = g_user
         ELSE
            LET g_lrp.lrpacti = 'Y'
            LET g_lrp.lrpmodu = g_user
         END IF

         UPDATE lrp_file SET lrpacti=g_lrp.lrpacti,
                             lrpmodu=g_lrp.lrpmodu,
                             lrpdate=g_today
          WHERE lrp06 = g_lrp.lrp06
            AND lrp07 = g_lrp.lrp07
            AND lrp08 = g_lrp.lrp08
            AND lrpplant = g_lrp.lrpplant

         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lrp_file",g_lrp.lrp07,"",SQLCA.sqlcode,"","",1)
            LET g_lrp.lrpacti=g_chr
         END IF
      END IF

      CLOSE i555_cl

      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF

      SELECT lrpacti,lrpmodu,lrpdate
        INTO g_lrp.lrpacti,g_lrp.lrpmodu,g_lrp.lrpdate FROM lrp_file
       WHERE lrp06 = g_lrp.lrp06
         AND lrp07 = g_lrp.lrp07
         AND lrp08 = g_lrp.lrp08
         AND lrpplant = g_lrp.lrpplant

      DISPLAY BY NAME g_lrp.lrpmodu,g_lrp.lrpdate,g_lrp.lrpacti
      CALL i555_pic()
   #END IF          #FUN-C70003 mark 

END FUNCTION

#FUN-C70003 mark begin---
#FUNCTION i555_ckmult()
#   DEFINE l_lrp04 LIKE lrp_file.lrp04   #生效日期    
#   DEFINE l_lrp05 LIKE lrp_file.lrp05   #失效日期
#
#   LET g_ckmult = null
#
#   IF NOT cl_null(g_lrp.lrp00)
#      AND NOT cl_null(g_lrp.lrp01)
#      AND NOT cl_null(g_lrp.lrpacti) THEN
#
#      SELECT lrp04,lrp05 
#        INTO l_lrp04,l_lrp05
#        FROM lrp_file
#       WHERE lrp00 = g_lrp.lrp00
#         AND lrp01 = g_lrp.lrp01    #FUN-C70003
#         AND lrpacti = 'Y'
#      
#      IF NOT cl_null(g_lrp.lrp04) THEN
#         IF g_lrp.lrp04 >= l_lrp04 AND g_lrp.lrp04 <= l_lrp05 THEN
#            LET g_ckmult = 'Y'
#           #RETURN         #FUN-C70003 mark
#            EXIT FOREACH   #FUN-C70003 add
#         END IF  
#      END IF
#
#      IF NOT cl_null(g_lrp.lrp05) THEN
#         IF g_lrp.lrp04 >= l_lrp04 AND g_lrp.lrp04 <= l_lrp05 THEN
#            LET g_ckmult = 'Y'
#            #RETURN        #FUN-C70003 mark
#            EXIT FOREACH   #FUN-C70003 add
#         END IF
#      END IF
#
#   END IF
#END FUNCTION
#FUN-C70003 mark end---

#FUN-C70003 add begin---
FUNCTION i555_ckmult()
   DEFINE l_sql        STRING
   DEFINE l_lso04      LIKE lso_file.lso04
   DEFINE l_cnt        LIKE type_file.num5

   CALL s_showmsg_init()
   LET g_success = 'Y'
   LET l_sql = "SELECT DISTINCT lso04 FROM lso_file  ",
               "  WHERE lso01 = '",g_lrp.lrp06,"' ",
               "    AND lso02 = '",g_lrp.lrp07,"' AND lso07 = 'Y' "
   PREPARE lso_pre3 FROM l_sql
   DECLARE lso_cs3 CURSOR FOR lso_pre3
   FOREACH lso_cs3 INTO l_lso04

      IF cl_null(l_lso04) THEN CONTINUE FOREACH END IF
      LET l_cnt = 0
      #判斷其他生效營運中心是否已存在此單號
      IF NOT cl_null(g_lrp.lrp04) AND NOT cl_null(g_lrp.lrp05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'lrp_file'),
                     "   WHERE lrp01 = '",g_lrp.lrp01,"'  AND lrp09 = 'Y' AND lrpconf = 'Y' ",
                     "     AND lrpacti = 'Y' AND lrp00 = '",g_lrp.lrp00,"' ",
                     #FUN-CB0025 add begin ---
                     "     AND (lrp04 BETWEEN '",g_lrp.lrp04,"' AND '",g_lrp.lrp05,"' ",
                     "      OR  lrp05 BETWEEN '",g_lrp.lrp04,"' AND '",g_lrp.lrp05,"' ",
                     "      OR (lrp04 <= '",g_lrp.lrp04,"' AND lrp05 >= '",g_lrp.lrp05,"'))"
                     #FUN-CB0025 add end -----
                     #FUN-CB0025 mark begin ---
                     #"     AND lrp04 >= '",g_lrp.lrp04,"' AND lrp04 <= '",g_lrp.lrp05,"' ",
                     #"     AND lrp05 >= '",g_lrp.lrp04,"' AND lrp05 <= '",g_lrp.lrp05,"' "
                     #FUN-CB0025 mark end -----
      END IF

      IF NOT cl_null(g_lrp.lrp04) AND cl_null(g_lrp.lrp05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'lrp_file'),
                     "   WHERE lrp01 = '",g_lrp.lrp01,"'  AND lrp09 = 'Y' AND lrpconf = 'Y' ",
                     "     AND lrpacti = 'Y' AND lrp00 = '",g_lrp.lrp00,"' ",
                     "     AND lrp04 >= '",g_lrp.lrp04,"' ",
                     "     AND lrp05 <= '",g_lrp.lrp04,"' "
      END IF

      IF cl_null(g_lrp.lrp04) AND NOT cl_null(g_lrp.lrp05) THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'lrp_file'),
                     "   WHERE lrp01 = '",g_lrp.lrp01,"'  AND lrp09 = 'Y' AND lrpconf = 'Y' ",
                     "     AND lrpacti = 'Y' AND lrp00 = '",g_lrp.lrp00,"' ",
                     "     AND lrp04 <= '",g_lrp.lrp05,"' ",
                     "     AND lrp05 >= '",g_lrp.lrp05,"' "
      END IF

      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
      PREPARE trans_cnt FROM l_sql
      EXECUTE trans_cnt INTO l_cnt
      IF l_cnt > 0 THEN
         CALL s_errmsg('lso04',l_lso04,l_lso04,'alm-h65',1)
         LET g_success = 'N'
      END IF
      #判斷營運中心是否符合卡種生效營運中心
      LET l_cnt = 0
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lso04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_lrp.lrp01,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",l_lso04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_lso04 ) RETURNING l_sql
      PREPARE trans_cnt1 FROM l_sql
      EXECUTE trans_cnt1 INTO l_cnt

      IF l_cnt = 0 OR cl_null(l_cnt) THEN
         CALL s_errmsg('lso04',l_lso04,l_lso04,'alm-h33',1)
         LET g_success = 'N'
      END IF
   END FOREACH

   CALL s_showmsg()
END FUNCTION
#FUN-C70003 add end-----

FUNCTION i555_pic()
   CASE g_lrp.lrpconf
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE

   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lrp.lrpacti)
END FUNCTION

#FUN-C70003 mark begin---
#FUNCTION i555_release()
#   DEFINE l_success          LIKE type_file.chr1
#   DEFINE l_lso04            LIKE lso_file.lso04
#   DEFINE l_azw02            LIKE azw_file.azw02
#   DEFINE l_sql              STRING
#   DEFINE l_lrp    RECORD    LIKE lrp_file.*,
#          l_lrq    RECORD    LIKE lrq_file.*,
#          l_lrr    RECORD    LIKE lrr_file.*,
#          l_lth    RECORD    LIKE lth_file.*,
#          l_lso    RECORD    LIKE lso_file.*
#   DEFINE l_cnt              LIKE type_file.num5
#
#   CALL i555_msg('release')
#   IF NOT cl_null(g_errno) THEN
#      CALL cl_err('',g_errno,0)
#      RETURN
#   END IF
#
#   CALL i555_ckmult()
#   IF g_ckmult = 'Y' THEN
#      CALL cl_err('','alm-h58',0)
#      RETURN
#   END IF
#
#   LET g_action_choice = ""
#   LET l_success = 'Y'
#
#   LET l_sql = "SELECT lso04 FROM lso_file WHERE lso01 = '",g_lrp.lrp06 CLIPPED,"' ",
#               "   AND lso02 = '",g_lrp.lrp07 CLIPPED,"' " ,
#               "   AND lso07 = 'Y'"
#  
#   PREPARE lso_pre1 FROM l_sql
#   DECLARE lso_cs1 CURSOR FOR lso_pre1
#   FOREACH lso_cs1 INTO l_lso04
#      IF cl_null(l_lso04) THEN 
#         CONTINUE FOREACH 
#      END IF
#
#      SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = l_lso04
#
#      #--積分/折扣/儲值加值規則-----------------------------
#      SELECT * INTO l_lrp.* FROM lrp_file 
#       WHERE lrp06 = g_lrp.lrp06 
#         AND lrp07 = g_lrp.lrp07 
#         AND lrp08 = g_lrp.lrp08 
#         AND lrpplant = g_lrp.lrpplant
#
#      IF l_success = 'Y' AND l_lrp.lrpplant <> l_lso04 THEN
#         #寫入積分/折扣規則單頭檔
#         LET l_lrp.lrplegal = l_azw02
#         LET l_lrp.lrpplant = l_lso04
#         LET l_lrp.lrp09 = 'Y'
#         LET l_lrp.lrp10 = g_today
#
#         INSERT INTO lrp_file VALUES l_lrp.*
#         IF SQLCA.sqlcode THEN
#            LET l_success = 'N'
#            CALL s_errmsg('','','INSERT INTO lrp_file:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#
#         SELECT count(*) INTO l_cnt FROM lrp_file WHERE lrp06 = l_lrp.lrp06 AND lrp07 = l_lrp.lrp07 AND lrp08 =l_lrp.lrp08 AND lrpplant = l_lso04
#
#      END IF
#
#      IF l_success = 'Y' THEN
#         #寫入積分/折扣/儲值加值規則變更單頭檔
#         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lti_file'),
#                     "      (lti00,lti01,lti02,lti03,lti04,lti05,lti06,lti07,lti08,lti09,lti10,",
#                     "       lti11,ltiacti,lticond,lticonf,lticonu,lticrat,ltidate,ltigrup,ltilegal,",
#                     "       ltimodu,ltiorig,ltioriu,ltiplant,ltipos,ltiuser)",
#                     "values('",l_lrp.lrp00,"','",l_lrp.lrp01,"','",l_lrp.lrp02,"','",l_lrp.lrp03,"','",l_lrp.lrp04,"','",l_lrp.lrp05,"',",
#                     "       '",l_lrp.lrp06,"','",l_lrp.lrp07,"','",l_lrp.lrp08,"','Y','",g_today,"',",
#                     "       '",l_lrp.lrp11,"','",l_lrp.lrpacti,"','",l_lrp.lrpcond,"','",l_lrp.lrpconf,"','",l_lrp.lrpconu,"',",
#                     "       '",l_lrp.lrpcrat,"','",l_lrp.lrpdate,"','",l_lrp.lrpgrup,"','",l_azw02,"',",
#                     "       '",l_lrp.lrpmodu,"','",l_lrp.lrporig,"','",l_lrp.lrporiu,"','",l_lso04,"','Y','",l_lrp.lrpuser,"')" 
#
#         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#         CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
#         PREPARE trans_ins_lti FROM l_sql
#         EXECUTE trans_ins_lti
#         IF SQLCA.sqlcode THEN
#            LET l_success = 'N'
#            CALL s_errmsg('','','INSERT INTO lti_file:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#      ENd IF
#
#     SELECT * INTO l_lrq.* FROM lrq_file
#      WHERE lrq12 = g_lrp.lrp06
#        AND lrq13 = g_lrp.lrp07
#        AND lrqplant = g_lrp.lrpplant
#
#     IF cl_null(l_lrq.lrq03) THEN
#        LET l_lrq.lrq03 = 0
#     END IF

#     IF cl_null(l_lrq.lrq04) THEN
#        LET l_lrq.lrq04 = 0
#     END IF

#     IF cl_null(l_lrq.lrq05) THEN
#        LET l_lrq.lrq05 = 100
#     END IF

#     IF cl_null(l_lrq.lrq06) THEN
#        LET l_lrq.lrq06 = 0
#     END IF

#     IF cl_null(l_lrq.lrq07) THEN
#        LET l_lrq.lrq07 = 0
#     END IF

#     IF cl_null(l_lrq.lrq08) THEN
#        LET l_lrq.lrq08 = 100
#     END IF


#     IF l_success = 'Y' AND l_lrq.lrqplant <> l_lso04 THEN
#        #寫入積分/折扣規則單身檔
#        LET l_lrq.lrqlegal = l_azw02
#        LET l_lrq.lrqplant = l_lso04

#        INSERT INTO lrq_file VALUES l_lrq.*
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO lrq_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#     END IF

#     IF l_success = 'Y' THEN
#        #寫入積分/折扣/儲值加值規則變更單身檔
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltj_file'),      
#                    "      (ltj00,ltj01,ltj02,ltj03,ltj04,ltj05,ltj06,ltj07,ltj08,ltj09,ltj10,",
#                    "       ltj11,ltj12,ltj13,ltj14,ltjacti,ltjlegal,ltjplant)",
#                    "values('",l_lrq.lrq00,"','",l_lrq.lrq01,"','",l_lrq.lrq02,"', ",l_lrq.lrq03,",",l_lrq.lrq04,",",l_lrq.lrq05,",",
#                    "        ",l_lrq.lrq06," , ",l_lrq.lrq07," , ",l_lrq.lrq08," ,'",l_lrq.lrq09,"','",l_lrq.lrq10,"',",
#                    "       '",l_lrq.lrq11,"','",l_lrq.lrq12,"','",l_lrq.lrq13,"',0,'",l_lrq.lrqacti,"','",l_azw02,"','",l_lso04,"' )"
#        
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#        CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
#        PREPARE trans_ins_ltj FROM l_sql
#        EXECUTE trans_ins_ltj
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO ltj_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#     END IF

#     #--會員紀念日積分回饋設定-----------------------------
#     SELECT * INTO l_lth.* FROM lth_file
#      WHERE lth13 = g_lrp.lrp06
#        AND lth14 = g_lrp.lrp07
#        AND lthplant = g_lrp.lrpplant

#     IF cl_null(l_lth.lth07) THEN
#        LET l_lth.lth07 = 0
#     END IF

#     IF cl_null(l_lth.lth08) THEN
#        LET l_lth.lth08 = 0
#     END IF

#     IF cl_null(l_lth.lth09) THEN
#        LET l_lth.lth09 = 0
#     END IF

#     IF cl_null(l_lth.lth10) THEN
#        LET l_lth.lth10 = 100
#     END IF
#     
#     IF cl_null(l_lth.lth11) THEN
#        LET l_lth.lth11 = 0
#     END IF

#     IF cl_null(l_lth.lth12) THEN
#        LET l_lth.lth12 = 0
#     END IF

#     IF l_success = 'Y' AND l_lth.lthplant <> l_lso04 THEN
#        #寫入會員紀念日積分回饋設定檔
#        LET l_lth.lthlegal = l_azw02
#        LET l_lth.lthplant = l_lso04

#        INSERT INTO lth_file VALUES l_lth.*
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO lth_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH 
#        END IF
#     END IF

#     IF l_success = 'Y' THEN
#        #寫入會員活動日積分回饋/折扣率變更設定檔
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltk_file'),
#                    "      (ltk01,ltk02,ltk03,ltk04,ltk05,ltk06,ltk07,ltk08,ltk09,ltk10,",
#                    "       ltk11,ltk12,ltk13,ltk14,ltk17,ltk18,ltk19,ltk20,",
#                    "       ltk21,ltkacti,ltkdate,ltkgrup,ltklegal,ltkmodu,ltkorig,ltkoriu,ltkplant)",
#                    "values('",l_lth.lth01,"','",l_lth.lth02,"','",l_lth.lth03,"','",l_lth.lth04,"', ",
#                    "       '",l_lth.lth05,"','",l_lth.lth06,"', ",l_lth.lth07," , ",l_lth.lth08," , ",
#                    "        ",l_lth.lth09," , ",l_lth.lth10," , ",l_lth.lth11," , ",l_lth.lth12," , ",
#                    "       '",l_lth.lth13,"','",l_lth.lth14,"',",
#                    "       '",l_lth.lth17,"','",l_lth.lth18,"','",l_lth.lth19,"','",l_lth.lth20,"', ",
#                    "       0,'",l_lth.lthacti,"','",l_lth.lthdate,"','",l_lth.lthgrup,"','",l_azw02,"','",l_lth.lthmodu,"',",
#                    "       '",l_lth.lthorig,"','",l_lth.lthoriu,"','",l_lso04,"')"

#
#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#        CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
#        PREPARE trans_ins_ltk FROM l_sql
#        EXECUTE trans_ins_ltk
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO ltk_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF

#        IF NOT cl_null(l_lth.lth15) THEN
#           LET l_sql = " UPDATE ",cl_get_target_table(l_lso04, 'ltk_file'),
#                       "    SET ltk15 = '",l_lth.lth15 CLIPPED,"'",
#                       "  WHERE ltk13 = '",l_lth.lth13,"'",
#                       "    AND ltk14 = '",l_lth.lth14,"'",
#                       "    AND ltk21 = 0 ",
#                       "    AND ltk05 = '",l_lth.lth05,"'",
#                       "    AND ltkplant = '" = l_lso04,"'"

#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#           CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
#           PREPARE trans_upd_ltk15 FROM l_sql
#           EXECUTE trans_upd_ltk15
#           IF SQLCA.sqlcode THEN
#              LET l_success = 'N'
#              CALL s_errmsg('','','UPDATE ltk_file:',SQLCA.sqlcode,1)
#              EXIT FOREACH
#           END IF         
#        END IF

#        IF NOT cl_null(l_lth.lth16) THEN
#           LET l_sql = " UPDATE ",cl_get_target_table(l_lso04, 'ltk_file'),
#                       "    SET ltk16 = '",l_lth.lth16 CLIPPED,"'",
#                       "  WHERE ltk13 = '",l_lth.lth13,"'",
#                       "    AND ltk14 = '",l_lth.lth14,"'",
#                       "    AND ltk21 = 0 ",
#                       "    AND ltk05 = '",l_lth.lth05,"'",
#                       "    AND ltkplant = '" = l_lso04,"'"

#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#           CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
#           PREPARE trans_upd_ltk16 FROM l_sql
#           EXECUTE trans_upd_ltk16
#           IF SQLCA.sqlcode THEN
#              LET l_success = 'N'
#              CALL s_errmsg('','','UPDATE ltk_file:',SQLCA.sqlcode,1)
#              EXIT FOREACH
#           END IF
#        END IF
#     END IF

#     #--積分/折扣規則排除明細-----------------------------
#     SELECT * INTO l_lrr.* FROM lrr_file
#      WHERE lrr05 = g_lrp.lrp06
#        AND lrr06 = g_lrp.lrp07
#        AND lrrplant = g_lrp.lrpplant


#     IF l_success = 'Y' AND l_lrr.lrrplant <> l_lso04 THEN
#        #寫入積分/折扣規則排除明細
#        LET l_lrr.lrrlegal = l_azw02
#        LET l_lrr.lrrplant = l_lso04

#        INSERT INTO lrr_file VALUES l_lrr.*
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO lrr_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH 
#        END IF
#     END IF

#     IF l_success = 'Y' THEN
#        #寫入積分/折扣規則排除明細變更檔
#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltl_file'),
#                    "      (ltl00,ltl01,ltl02,ltl03,ltl04,ltl05,ltl06,ltlacti,ltllegal,ltlplant)",
#                    "values('",l_lrr.lrr00,"','",l_lrr.lrr01,"','",l_lrr.lrr02,"','",l_lrr.lrr03,"','",l_lrr.lrr04,"', ",
#                    "       '",l_lrr.lrr05,"','",l_lrr.lrr06,"',0,'",l_azw02,"','",l_lso04,"')"

#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#        CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
#        PREPARE trans_ins_ltl FROM l_sql
#        EXECUTE trans_ins_ltl
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO ltl_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#     END IF

#     #--積分/折扣/儲值加值規則生效營運中心-----------------------------
#        SELECT * INTO l_lso.* FROM lso_file
#         WHERE lso01 = g_lrp.lrp06
#           AND lso02 = g_lrp.lrp07
#           AND lsoplant = g_lrp.lrpplant

#     IF l_success = 'Y' AND l_lso.lsoplant <> l_lso04 THEN
#        #寫入積分/折扣/儲值加值規則生效營運中心檔
#        LET l_lso.lsolegal = l_azw02
#        LET l_lso.lsoplant = l_lso04

#        INSERT INTO lso_file VALUES l_lso.*
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO lso_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH            
#        END IF
#     END IF

#     IF l_success = 'Y' THEN
#        #寫入積分/折扣/儲值加值規則生效營運中心變更檔
#        SELECT * INTO l_lso.* FROM lso_file
#         WHERE lso01 = g_lrp.lrp06
#           AND lso02 = g_lrp.lrp07
#           AND lsoplant = g_lrp.lrpplant

#        LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltn_file'),
#                    "      (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)",
#                    "values('",l_lso.lso01,"','",l_lso.lso02,"','",l_lso.lso03,"','",l_lso.lso04,"','",l_lso.lso05,"',",
#                    "       '",l_lso.lso06,"','",l_lso.lso07,"',0,'",l_azw02,"','",l_lso04,"')"

#        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
#        CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql
#        PREPARE trans_ins_ltn FROM l_sql
#        EXECUTE trans_ins_ltn
#        IF SQLCA.sqlcode THEN
#           LET l_success = 'N'
#           CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#     END IF
#  END FOREACH 
#  

#  IF l_success = 'Y' THEN
#     LET l_success = NULL
#     UPDATE lrp_file
#        SET lrp09 = 'Y',
#            lrp10 = g_today
#      WHERE lrp06 = g_lrp.lrp06
#        AND lrp07 = g_lrp.lrp07
#        AND lrp08 = g_lrp.lrp08
#        AND lrpplant = g_plant
#     IF SQLCA.sqlcode THEN
#        LET l_success = 'N'
#        CALL s_errmsg('','','UPDATE lrp_file:',SQLCA.sqlcode,1)
#     END IF

#  END IF

#  IF l_success = 'N' THEN
#     CALL s_showmsg()
#     ROLLBACK WORK
#     RETURN
#  ELSE
#     LET g_lrp.lrp09 = 'Y'
#     LET g_lrp.lrp10 = g_today
#     LET g_lrp.lrpmodu = g_user
#     LET g_lrp.lrpuser = g_user
#     DISPLAY BY NAME g_lrp.lrp09
#     DISPLAY BY NAME g_lrp.lrp10
#     DISPLAY BY NAME g_lrp.lrpmodu
#     DISPLAY BY NAME g_lrp.lrpuser
#     CALL i555_pic()
#     MESSAGE "TRANS_DATA_OK !"
#     COMMIT WORK
#  END IF
#
#END FUNCTION
#FUN-C70003 mark end-----
#FUN-C60056 add end-----

#FUN-C70003 add begin---
FUNCTION i555_release()
  #DEFINE l_success                           LIKE type_file.chr1    #FUN-C70003 mark g_success replace to l_success
   DEFINE l_lso04                             LIKE lso_file.lso04
   DEFINE l_azw02                             LIKE azw_file.azw02
  #DEFINE l_azw05                             LIKE azw_file.azw05    #FUN-C90020 add
   DEFINE l_sql                               STRING
   DEFINE l_lrp    RECORD                     LIKE lrp_file.*,
          l_lrq    DYNAMIC ARRAY OF RECORD    LIKE lrq_file.*,
          l_lrr    DYNAMIC ARRAY OF RECORD    LIKE lrr_file.*,
          l_lth    DYNAMIC ARRAY OF RECORD    LIKE lth_file.*,
          l_lso    DYNAMIC ARRAY OF RECORD    LIKE lso_file.*
   DEFINE l_cnt                               LIKE type_file.num5
   DEFINE l_max_rec                           LIKE type_file.num5
   DEFINE l_rec                               LIKE type_file.num5
   DEFINE l_plant                             LIKE azw_file.azw01

   CALL i555_msg('release')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   CALL i555_ckmult()
   #FUN-C70003 mark begin---
   #IF g_ckmult = 'Y' THEN
   #   CALL cl_err('','alm-h58',0)
   #   RETURN
   #END IF
   #FUN-C70003 mark end---
    IF g_success = 'N' THEN RETURN END IF #FUN-C70003 add

   #FUN-C70003 add begin---
   IF NOT cl_confirm('art-660') THEN
      RETURN
   END IF
   #FUN-C70003 add end-----

   LET g_action_choice = ""
   LET g_success = 'Y'    #FUN-C70003 g_success replace to l_success

   #FUN-C90020 mark begin---
    LET l_sql = "SELECT lso04 FROM lso_file WHERE lso01 = '",g_lrp.lrp06 CLIPPED,"' ",
                "   AND lso02 = '",g_lrp.lrp07 CLIPPED,"' " ,
                "   AND lso07 = 'Y'"

    PREPARE lso_pre1 FROM l_sql
    DECLARE lso_cs1 CURSOR FOR lso_pre1
    FOREACH lso_cs1 INTO l_lso04
       IF cl_null(l_lso04) THEN
          CONTINUE FOREACH
       END IF
       DISPLAY 'Effective Plant: ',l_lso04

       SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = l_lso04

       #--積分/折扣/儲值加值規則-----------------------------
       SELECT * INTO l_lrp.* FROM lrp_file
        WHERE lrp06 = g_lrp.lrp06
          AND lrp07 = g_lrp.lrp07
          AND lrp08 = g_lrp.lrp08
          AND lrpplant = g_lrp.lrpplant

       IF g_success = 'Y' AND l_lrp.lrpplant <> l_lso04 THEN   #FUN-C70003 g_success replace to l_success
          #寫入積分/折扣規則單頭檔

          LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lrp_file'),    #FUN-C70003
                      "            (lrp00,lrp01,lrp02,lrp03,lrp04,lrp05,lrppos,lrp06,lrp07,lrp08,lrp09,lrp10,",
                      "             lrp11,lrpacti,lrpcond,lrpconf,lrpconu,lrpcrat,lrpdate,lrpgrup,lrplegal,lrpmodu,",
                      "             lrporig,lrporiu,lrpplant,lrpuser)",
                      "      VALUES('",l_lrp.lrp00,"','",l_lrp.lrp01,"','",l_lrp.lrp02,"','",l_lrp.lrp03,"','",l_lrp.lrp04,"','",l_lrp.lrp05,"','",l_lrp.lrppos,"', ",
                      "             '",l_lrp.lrp06,"','",l_lrp.lrp07,"','",l_lrp.lrp08,"','Y','",g_today,"',",
                      "             '",l_lrp.lrp11,"','",l_lrp.lrpacti,"','",l_lrp.lrpcond,"','",l_lrp.lrpconf,"','",l_lrp.lrpconu,"',",
                      "             '",l_lrp.lrpcrat,"','",l_lrp.lrpdate,"','",l_lrp.lrpgrup,"','",l_azw02,"','",l_lrp.lrpmodu,"', ",
                      "             '",l_lrp.lrporig,"','",l_lrp.lrporiu,"','",l_lso04,"','",l_lrp.lrpuser,"')"

          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
          PREPARE trans_ins_lrp FROM l_sql
          EXECUTE trans_ins_lrp         
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'                #FUN-C70003 g_success replace to l_success
             CALL s_errmsg('','','INSERT INTO lrp_file:',SQLCA.sqlcode,1)
             ROLLBACK WORK
             EXIT FOREACH
          END IF
          DISPLAY 'Insert: lrp_file: ',l_lrp.lrp07,' for plant:  ',l_lso04
       END IF

       IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
          #寫入積分/折扣/儲值加值規則變更單頭檔
           LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lti_file'),   #FUN-C70003
                       "      (lti00,lti01,lti02,lti03,lti04,lti05,lti06,lti07,lti08,lti09,lti10,",
                       "       lti11,ltiacti,lticond,lticonf,lticonu,lticrat,ltidate,ltigrup,ltilegal,",
                       "       ltimodu,ltiorig,ltioriu,ltiplant,ltipos,ltiuser)",
                       "values('",l_lrp.lrp00,"','",l_lrp.lrp01,"','",l_lrp.lrp02,"','",l_lrp.lrp03,"','",l_lrp.lrp04,"','",l_lrp.lrp05,"',",
                       "       '",l_lrp.lrp06,"','",l_lrp.lrp07,"','",l_lrp.lrp08,"','Y','",g_today,"',",
                       "       '",l_lrp.lrp11,"','",l_lrp.lrpacti,"','",l_lrp.lrpcond,"','",l_lrp.lrpconf,"','",l_lrp.lrpconu,"',",
                       "       '",l_lrp.lrpcrat,"','",l_lrp.lrpdate,"','",l_lrp.lrpgrup,"','",l_azw02,"',",
                       "       '",l_lrp.lrpmodu,"','",l_lrp.lrporig,"','",l_lrp.lrporiu,"','",l_lso04,"','",l_lrp.lrppos,"','",l_lrp.lrpuser,"')"    #FUN-C70003 lrp.lrppos

          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
          PREPARE trans_ins_lti FROM l_sql
          EXECUTE trans_ins_lti
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
             CALL s_errmsg('','','INSERT INTO lti_file:',SQLCA.sqlcode,1)
             ROLLBACK WORK
             EXIT FOREACH
          END IF
          DISPLAY 'Insert: lti_file: ',l_lrp.lrp07,' for plant:  ',l_lso04
       ENd IF

       IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
          SELECT COUNT(*) INTO l_max_rec FROM lrq_file WHERE lrq12 = g_lrp.lrp06 AND lrq13 = g_lrp.lrp07 AND lrqplant = g_lrp.lrpplant
          LET l_rec = 1
          LET l_sql = "SELECT * FROM ",cl_get_target_table(g_lrp.lrpplant, 'lrq_file'),   #FUN-C70003 
                      " WHERE lrq12 = '",g_lrp.lrp06,"' ",
                      "  AND lrq13 = '",g_lrp.lrp07,"' ",
                      "  AND lrqplant = '",g_lrp.lrpplant,"'" 
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql   #FUN-C70003
          PREPARE lrq_sur FROM l_sql
          DECLARE lrq_ins_sur CURSOR FOR lrq_sur
          FOREACH lrq_ins_sur INTO l_lrq[l_rec].*
             IF cl_null(l_lrq[l_rec].lrq03) THEN LET l_lrq[l_rec].lrq03 = 0 END IF
             IF cl_null(l_lrq[l_rec].lrq04) THEN LET l_lrq[l_rec].lrq04 = 0 END IF
             IF cl_null(l_lrq[l_rec].lrq05) THEN LET l_lrq[l_rec].lrq05 = 100 END IF
             IF cl_null(l_lrq[l_rec].lrq06) THEN LET l_lrq[l_rec].lrq06 = 0 END IF
             IF cl_null(l_lrq[l_rec].lrq07) THEN LET l_lrq[l_rec].lrq07 = 0 END IF
             IF cl_null(l_lrq[l_rec].lrq08) THEN LET l_lrq[l_rec].lrq08 = 100 END IF
    
             IF g_success = 'Y' AND l_lrq[l_rec].lrqplant <> l_lso04 THEN   #FUN-C70003 g_success replace to l_success
                #寫入積分/折扣規則單身檔
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lrq_file'), #FUN-C70003
                            "           (lrq00,lrq01,lrq02,lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrq10,",
                            "            lrq11,lrqacti,lrq12,lrq13,lrqlegal,lrqplant)",
                            "     values('",l_lrq[l_rec].lrq00,"','",l_lrq[l_rec].lrq01,"','",l_lrq[l_rec].lrq02,"', ",l_lrq[l_rec].lrq03,",",l_lrq[l_rec].lrq04,",",l_lrq[l_rec].lrq05,",",
                            "             ",l_lrq[l_rec].lrq06," , ",l_lrq[l_rec].lrq07," , ",l_lrq[l_rec].lrq08," ,'",l_lrq[l_rec].lrq09,"','",l_lrq[l_rec].lrq10,"',",
                            "            '",l_lrq[l_rec].lrq11,"','",l_lrq[l_rec].lrqacti,"','",l_lrq[l_rec].lrq12,"','",l_lrq[l_rec].lrq13,"','",l_azw02,"','",l_lso04,"' )"
    
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql   #FUN0C70003
                PREPARE trans_ins_lrq FROM l_sql
                EXECUTE trans_ins_lrq
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO lrq_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: lrq_file: ',l_lrq[l_rec].lrq13,' for plant:  ',l_lso04
             END IF
             
             IF g_success = 'Y' THEN    #FUN-C70003 g_success replace to l_success
                #寫入積分/折扣/儲值加值規則變更單身檔
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltj_file'), #FUN-C70003
                            "      (ltj00,ltj01,ltj02,ltj03,ltj04,ltj05,ltj06,ltj07,ltj08,ltj09,ltj10,",
                            "       ltj11,ltj12,ltj13,ltj14,ltjacti,ltjlegal,ltjplant)",
                            "values('",l_lrq[l_rec].lrq00,"','",l_lrq[l_rec].lrq01,"','",l_lrq[l_rec].lrq02,"', ",l_lrq[l_rec].lrq03,",",l_lrq[l_rec].lrq04,",",l_lrq[l_rec].lrq05,",",
                            "        ",l_lrq[l_rec].lrq06," , ",l_lrq[l_rec].lrq07," , ",l_lrq[l_rec].lrq08," ,'",l_lrq[l_rec].lrq09,"','",l_lrq[l_rec].lrq10,"',",
                            "       '",l_lrq[l_rec].lrq11,"','",l_lrq[l_rec].lrq12,"','",l_lrq[l_rec].lrq13,"',0,'",l_lrq[l_rec].lrqacti,"','",l_azw02,"','",l_lso04,"' )"
    
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql   #FUN-C70003
                PREPARE trans_ins_ltj FROM l_sql
                EXECUTE trans_ins_ltj
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO ltj_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: ltj_file: ',l_lrq[l_rec].lrq13,' for plant:  ',l_lso04
             END IF
             
             IF l_rec = l_max_rec THEN
                EXIT FOREACH
             ELSE
                IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
                   LET l_rec = l_rec + 1
                END IF
             END IF
          END FOREACH
       END IF

       #--會員紀念日積分回饋設定-----------------------------
       IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
          SELECT COUNT(*) INTO l_max_rec FROM lth_file WHERE lth13 = g_lrp.lrp06 AND lth14 = g_lrp.lrp07 AND lthplant = g_lrp.lrpplant
          LET l_rec = 1
          LET l_sql = "SELECT * FROM ",cl_get_target_table(l_lrp.lrpplant, 'lth_file'),   #FUN-C70003
                      " WHERE lth13 = '",g_lrp.lrp06,"' ",
                      "   AND lth14 = '",g_lrp.lrp07,"' ",
                      "   AND lthplant = '",g_lrp.lrpplant,"' " 
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql    #FUN-C70003
          PREPARE lth_sur FROM l_sql
          DECLARE lth_ins_sur CURSOR FOR lth_sur
          FOREACH lth_ins_sur INTO l_lth[l_rec].*
             IF cl_null(l_lth[l_rec].lth07) THEN LET l_lth[l_rec].lth07 = 0 END IF
             IF cl_null(l_lth[l_rec].lth08) THEN LET l_lth[l_rec].lth08 = 0 END IF
             IF cl_null(l_lth[l_rec].lth09) THEN LET l_lth[l_rec].lth09 = 0 END IF
             IF cl_null(l_lth[l_rec].lth10) THEN LET l_lth[l_rec].lth10 = 100 END IF
             IF cl_null(l_lth[l_rec].lth11) THEN LET l_lth[l_rec].lth11 = 0 END IF
             IF cl_null(l_lth[l_rec].lth12) THEN LET l_lth[l_rec].lth12 = 0 END IF

             IF g_success = 'Y' AND l_lth[l_rec].lthplant <> l_lso04 THEN   #FUN-C70003 g_success replace to l_success
                #寫入會員紀念日積分回饋設定檔
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lth_file'),   #FUN-C70003
                            "           (lth01,lth02,lth03,lth04,lth05,lth06,lth07,lth08,lth09,lth10,",
                            "            lth11,lth12,lthacti,lthdate,lthgrup,lthmodu,lthorig,lthoriu,lthuser,",
                            "            lth13,lth14,lth17,lth18,lth19,lth20,lthlegal,lthplant)",
                            "     VALUES('",l_lth[l_rec].lth01,"','",l_lth[l_rec].lth02,"','",l_lth[l_rec].lth03,"','",l_lth[l_rec].lth04,"', ",
                            "            '",l_lth[l_rec].lth05,"','",l_lth[l_rec].lth06,"', ",l_lth[l_rec].lth07," , ",l_lth[l_rec].lth08," , ",
                            "             ",l_lth[l_rec].lth09," , ",l_lth[l_rec].lth10," , ",l_lth[l_rec].lth11," , ",l_lth[l_rec].lth12," , ",
                            "            '",l_lth[l_rec].lthacti,"','",l_lth[l_rec].lthdate,"','",l_lth[l_rec].lthgrup,"','",l_lth[l_rec].lthmodu,"',",
                            "            '",l_lth[l_rec].lthorig,"','",l_lth[l_rec].lthoriu,"','",l_lth[l_rec].lthuser,"','",l_lth[l_rec].lth13,"', ",
                            "            '",l_lth[l_rec].lth14,"','",l_lth[l_rec].lth17,"','",l_lth[l_rec].lth18,"','",l_lth[l_rec].lth19,"','",l_lth[l_rec].lth20,"', ",
                            "            '",l_azw02,"','",l_lso04,"')"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql   #FUN-C70003 
                PREPARE trans_ins_lth FROM l_sql
                EXECUTE trans_ins_lth
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO lth_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: lth_file: ',l_lth[l_rec].lth14,' for plant:  ',l_lso04

                IF NOT cl_null(l_lth[l_rec].lth15) THEN
                   LET l_sql = " UPDATE ",cl_get_target_table(l_lso04, 'lth_file'),   #FUN-C70003
                               "    SET lth15 = '",l_lth[l_rec].lth15 CLIPPED,"'",
                               "  WHERE lth13 = '",l_lth[l_rec].lth13,"'",
                               "    AND lth14 = '",l_lth[l_rec].lth14,"'",
                               "    AND lth05 = '",l_lth[l_rec].lth05,"'",
                               "    AND lthplant = '",l_lso04,"'"

                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
                   PREPARE trans_upd_lth15 FROM l_sql
                   EXECUTE trans_upd_lth15
                   IF SQLCA.sqlcode THEN
                      LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                      CALL s_errmsg('','','UPDATE lth_file:',SQLCA.sqlcode,1)
                      ROLLBACK WORK
                      EXIT FOREACH
                   END IF
                END IF

                IF NOT cl_null(l_lth[l_rec].lth16) THEN
                   LET l_sql = " UPDATE ",cl_get_target_table(l_lso04, 'lth_file'),   #FUN-C70003
                               "    SET lth16 = '",l_lth[l_rec].lth16 CLIPPED,"'",
                               "  WHERE lth13 = '",l_lth[l_rec].lth13,"'",
                               "    AND lth14 = '",l_lth[l_rec].lth14,"'",
                               "    AND lth05 = '",l_lth[l_rec].lth05,"'",
                               "    AND lthplant = '",l_lso04,"'"

                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
                   PREPARE trans_upd_lth16 FROM l_sql
                   EXECUTE trans_upd_lth16
                   IF SQLCA.sqlcode THEN
                      LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                      CALL s_errmsg('','','UPDATE lth_file:',SQLCA.sqlcode,1)
                      ROLLBACK WORK
                      EXIT FOREACH
                   END IF
                END IF
             END IF

             IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
                #寫入會員活動日積分回饋/折扣率變更設定檔
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltk_file'),   #FUN-C70003
                            "      (ltk01,ltk02,ltk03,ltk04,ltk05,ltk06,ltk07,ltk08,ltk09,ltk10,",
                            "       ltk11,ltk12,ltk13,ltk14,ltk17,ltk18,ltk19,ltk20,",
                            "       ltk21,ltkacti,ltkdate,ltkgrup,ltklegal,ltkmodu,ltkorig,ltkoriu,ltkplant)",
                            "values('",l_lth[l_rec].lth01,"','",l_lth[l_rec].lth02,"','",l_lth[l_rec].lth03,"','",l_lth[l_rec].lth04,"', ",
                            "       '",l_lth[l_rec].lth05,"','",l_lth[l_rec].lth06,"', ",l_lth[l_rec].lth07," , ",l_lth[l_rec].lth08," , ",
                            "        ",l_lth[l_rec].lth09," , ",l_lth[l_rec].lth10," , ",l_lth[l_rec].lth11," , ",l_lth[l_rec].lth12," , ",
                            "       '",l_lth[l_rec].lth13,"','",l_lth[l_rec].lth14,"',",
                            "       '",l_lth[l_rec].lth17,"','",l_lth[l_rec].lth18,"','",l_lth[l_rec].lth19,"','",l_lth[l_rec].lth20,"', ",
                            "       0,'",l_lth[l_rec].lthacti,"','",l_lth[l_rec].lthdate,"','",l_lth[l_rec].lthgrup,"','",l_azw02,"','",l_lth[l_rec].lthmodu,"',",
                            "       '",l_lth[l_rec].lthorig,"','",l_lth[l_rec].lthoriu,"','",l_lso04,"')"

 
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
                PREPARE trans_ins_ltk FROM l_sql
                EXECUTE trans_ins_ltk
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO ltk_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: ltk_file: ',l_lth[l_rec].lth14,' for plant:  ',l_lso04

                IF NOT cl_null(l_lth[l_rec].lth15) THEN
                   LET l_sql = " UPDATE ",cl_get_target_table(l_lso04, 'ltk_file'),    #FUN-C70003
                               "    SET ltk15 = '",l_lth[l_rec].lth15 CLIPPED,"'",
                               "  WHERE ltk13 = '",l_lth[l_rec].lth13,"'",
                               "    AND ltk14 = '",l_lth[l_rec].lth14,"'",
                               "    AND ltk21 = 0 ",
                               "    AND ltk05 = '",l_lth[l_rec].lth05,"'",
                               "    AND ltkplant = '",l_lso04,"'"

                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
                   PREPARE trans_upd_ltk15 FROM l_sql
                   EXECUTE trans_upd_ltk15
                   IF SQLCA.sqlcode THEN
                      LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                      CALL s_errmsg('','','UPDATE ltk_file:',SQLCA.sqlcode,1)
                      ROLLBACK WORK
                      EXIT FOREACH
                   END IF
                END IF

                IF NOT cl_null(l_lth[l_rec].lth16) THEN
                   LET l_sql = " UPDATE ",cl_get_target_table(l_lso04, 'ltk_file'),   #FUN-C70003
                               "    SET ltk16 = '",l_lth[l_rec].lth16 CLIPPED,"'",
                               "  WHERE ltk13 = '",l_lth[l_rec].lth13,"'",
                               "    AND ltk14 = '",l_lth[l_rec].lth14,"'",
                               "    AND ltk21 = 0 ",
                               "    AND ltk05 = '",l_lth[l_rec].lth05,"'",
                               "    AND ltkplant = '",l_lso04,"'"

                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
                   PREPARE trans_upd_ltk16 FROM l_sql
                   EXECUTE trans_upd_ltk16
                   IF SQLCA.sqlcode THEN
                      LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                      CALL s_errmsg('','','UPDATE ltk_file:',SQLCA.sqlcode,1)
                      ROLLBACK WORK
                      EXIT FOREACH
                   END IF
                END IF
             END IF

             IF l_rec = l_max_rec THEN
                EXIT FOREACH
             ELSE
                IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
                   LET l_rec = l_rec + 1
                END IF
             END IF
         END FOREACH
       END IF

       #--積分/折扣規則排除明細-----------------------------
       IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
          SELECT COUNT(*) INTO l_max_rec FROM lrr_file WHERE lrr05 = g_lrp.lrp06 AND lrr06 = g_lrp.lrp07 AND lrrplant = g_lrp.lrpplant
          LET l_rec = 1
          LET l_sql = "SELECT * FROM ",cl_get_target_table(l_lrp.lrpplant, 'lrr_file'),    #FUN-C70003
                      " WHERE lrr05 = '",g_lrp.lrp06,"' ",
                      "   AND lrr06 = '",g_lrp.lrp07,"' ",
                      "   AND lrrplant = '",g_lrp.lrpplant,"' "

          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql   #FUN-C70003
          PREPARE lrr_sur FROM l_sql
          DECLARE lrr_ins_sur CURSOR FOR lrr_sur
          FOREACH lrr_ins_sur INTO l_lrr[l_rec].*
             IF g_success = 'Y' AND l_lrr[l_rec].lrrplant <> l_lso04 THEN #FUN-C70003 g_success replace to l_success
                #寫入積分/折扣規則排除明細
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lrr_file'),
                            "           (lrr00,lrr01,lrr02,lrr03,lrr04,lrracti,lrr05,lrr06,lrrlegal,lrrplant)",
                            "     VALUES('",l_lrr[l_rec].lrr00,"','",l_lrr[l_rec].lrr01,"','",l_lrr[l_rec].lrr02,"','",l_lrr[l_rec].lrr03,"','",l_lrr[l_rec].lrr04,"','Y', ",    #FUN-C70003 add 'Y'
                            "            '",l_lrr[l_rec].lrr05,"','",l_lrr[l_rec].lrr06,"','",l_azw02,"','",l_lso04,"')"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql                    #FUN-C70003
                CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql    #FUN-C70003
                PREPARE trans_ins_lrr FROM l_sql                                #FUN-C70003
                EXECUTE trans_ins_lrr                                           #FUN-C70003
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO lrr_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: lrr_file: ',l_lrr[l_rec].lrr06,' for plant:  ',l_lso04
             END IF

             IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
                #寫入積分/折扣規則排除明細變更檔
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltl_file'),   #FUN-C70003
                            "      (ltl00,ltl01,ltl02,ltl03,ltl04,ltl05,ltl06,ltl07,ltlacti,ltllegal,ltlplant)",   #FUN-C70003 add ltl07
                            "values('",l_lrr[l_rec].lrr00,"','",l_lrr[l_rec].lrr01,"','",l_lrr[l_rec].lrr02,"','",l_lrr[l_rec].lrr03,"','",l_lrr[l_rec].lrr04,"', ",
                            "       '",l_lrr[l_rec].lrr05,"','",l_lrr[l_rec].lrr06,"',0,'Y','",l_azw02,"','",l_lso04,"')"   #FUN0-C70003 add 'Y'

                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql    #FUN-C70003
                PREPARE trans_ins_ltl FROM l_sql
                EXECUTE trans_ins_ltl
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO ltl_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: ltl_file: ',l_lrr[l_rec].lrr06,' for plant:  ',l_lso04
             END IF

             IF l_rec = l_max_rec THEN
                EXIT FOREACH
             ELSE
                IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
                   LET l_rec = l_rec + 1
                END IF
             END IF
          END FOREACH
       END IF

       #--積分/折扣/儲值加值規則生效營運中心-----------------------------
       IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
          SELECT COUNT(*) INTO l_max_rec FROM lso_file WHERE lso01 = g_lrp.lrp06 AND lso02 = g_lrp.lrp07 AND lsoplant = g_lrp.lrpplant
          LET l_rec = 1
          LET l_sql = "SELECT * FROM ",cl_get_target_table(l_lrp.lrpplant, 'lso_file'),    #FUN-C70003
                      " WHERE lso01 = '",g_lrp.lrp06,"' ",
                      "   AND lso02 = '",g_lrp.lrp07,"' ",
                      "   AND lsoplant = '", g_lrp.lrpplant,"' "
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql, g_lrp.lrpplant) RETURNING l_sql   #FUN-C70003
          PREPARE lso_sur FROM l_sql
          DECLARE lso_ins_sur CURSOR FOR lso_sur
          FOREACH lso_ins_sur INTO l_lso[l_rec].*
             IF g_success = 'Y' AND l_lso[l_rec].lsoplant <> l_lso04 THEN   #FUN-C70003 g_success replace to l_success
                #寫入積分/折扣/儲值加值規則生效營運中心檔
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lso_file'),   #FUN-C70003
                            "           (lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant)",
                            "     VALUES('",l_lso[l_rec].lso01,"','",l_lso[l_rec].lso02,"','",l_lso[l_rec].lso03,"','",l_lso[l_rec].lso04,"','",l_lso[l_rec].lso05,"',",
                            "            '",l_lso[l_rec].lso06,"','",l_lso[l_rec].lso07,"','",l_azw02,"','",l_lso04,"')"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-C70003
                PREPARE trans_ins_lso FROM l_sql
                EXECUTE trans_ins_lso
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO lso_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: lso_file: ',l_lso[l_rec].lso03,' for plant:  ',l_lso04
             END IF

             IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
                #寫入積分/折扣/儲值加值規則生效營運中心變更檔
                LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltn_file'),      #FUN-C70003
                            "      (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)",
                            "values('",l_lso[l_rec].lso01,"','",l_lso[l_rec].lso02,"','",l_lso[l_rec].lso03,"','",l_lso[l_rec].lso04,"','",l_lso[l_rec].lso05,"',",
                            "       '",l_lso[l_rec].lso06,"','",l_lso[l_rec].lso07,"',0,'",l_azw02,"','",l_lso04,"')"

                CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                CALL cl_parse_qry_sql(l_sql, l_lso04) RETURNING l_sql   #FUN-70003
                PREPARE trans_ins_ltn FROM l_sql
                EXECUTE trans_ins_ltn
                IF SQLCA.sqlcode THEN
                   LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
                   CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
                   ROLLBACK WORK
                   EXIT FOREACH
                END IF
                DISPLAY 'Insert: ltn_file: ',l_lso[l_rec].lso03,' for plant:  ',l_lso04
             END IF

             IF l_rec = l_max_rec THEN
                EXIT FOREACH
             ELSE
                IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
                   LET l_rec = l_rec + 1
                END IF
             END IF
          END FOREACH
       END IF

       IF g_success = 'N' THEN   #FUN-C70003 g_success replace to l_success
          ROLLBACK WORK
          EXIT FOREACH
       END IF
    END FOREACH
   #FUN-C90020 mark end-----

  ##FUN-C90020 add begin---
  #LET l_sql = "SELECT DISTINCT azw05 FROM lso_file,azw_file ",
  #            " WHERE lso04 = azw01 ",
  #            "   AND lso01 = '",g_lrp.lrp06 CLIPPED,"' ",
  #            "   AND lso02 = '",g_lrp.lrp07 CLIPPED,"' " ,
  #            "   AND lso07 = 'Y'"

  #PREPARE lso_pre1 FROM l_sql
  #DECLARE lso_cs1 CURSOR FOR lso_pre1
  #FOREACH lso_cs1 INTO l_azw05
  #   LET l_sql = "SELECT azw01 FROM azw_file WHERE azw05 = '",l_azw05,"' AND azwacti = 'Y'"
  #   PREPARE azw_pre FROM l_sql
  #   DECLARE azw_cs CURSOR FOR azw_pre
  #   OPEN azw_cs
  #   FETCH FIRST azw_cs INTO l_plant
  #   CLOSE azw_cs 
  #   IF cl_null(l_plant) THEN
  #      CONTINUE FOREACH
  #   END IF
  #   DISPLAY 'Effective Plant: ',l_lso04

  #    #--積分/折扣/儲值加值規則-----------------------------
  #    IF g_success = 'Y' AND g_lrp.lrpplant <> l_lso04 THEN
  #       #寫入積分/折扣規則單頭檔

  #       LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lrp_file'),
  #                   "            (lrp00,lrp01,lrp02,lrp03,lrp04,lrp05,lrppos,lrp06,lrp07,lrp08,lrp09,lrp10,",
  #                   "             lrp11,lrpacti,lrpcond,lrpconf,lrpconu,lrpcrat,lrpdate,lrpgrup,lrplegal,lrpmodu,",
  #                   "             lrporig,lrporiu,lrpplant,lrpuser)",
  #                   "     SELECT lrp00,lrp01,lrp02,lrp03,lrp04,lrp05,lrppos,lrp06,lrp07,lrp08,'Y','",g_today,"',",
  #                   "            lrp11,lrpacti,lrpcond,lrpconf,lrpconu,lrpcrat,lrpdate,lrpgrup,azw02,lrpmodu,",
  #                   "            lrporig,lrporiu,lso04,lrpuser ",
  #                   "       FROM ",cl_get_target_table(g_lrp.lrpplant,'lrp_file'),
  #                   "  LEFT JOIN ",cl_get_target_table(g_lrp.lrpplant,'lso_file'),
  #                   "         ON  lrp06 = lso01 and lrp07= lso02  and lso07 =  'Y' AND lso04 <> '",g_lrp.lrpplant,"'",
  #                   "  LEFT JOIN  azw_file",
  #                   "         ON  lso04 = azw01",         
  #                   "      WHERE lrp06 = '",g_lrp.lrp06,"' ",
  #                   "        AND lrp07 = '",g_lrp.lrp07,"' ",
  #                   "        AND lrp08 = '",g_lrp.lrp08,"' ",
  #                   "        AND lrpplant = '",g_lrp.lrpplant,"' "
  #       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #       PREPARE trans_ins_lrp FROM l_sql
  #       EXECUTE trans_ins_lrp
  #       IF SQLCA.sqlcode THEN
  #          LET g_success = 'N'
  #          CALL s_errmsg('','','INSERT INTO lrp_file:',SQLCA.sqlcode,1)
  #          ROLLBACK WORK
  #          EXIT FOREACH
  #       END IF
  #       DISPLAY l_lso04," INSERT lrp_file: ",SQLCA.sqlerrd[3]," ROWS"
  #    END IF

  #   IF g_success = 'Y' THEN
  #      #寫入積分/折扣/儲值加值規則變更單頭檔
  #       LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lti_file'),
  #                   "             (lti00,lti01,lti02,lti03,lti04,lti05,lti06,lti07,lti08,lti09,lti10,",
  #                   "              lti11,ltiacti,lticond,lticonf,lticonu,lticrat,ltidate,ltigrup,ltilegal,",
  #                   "              ltimodu,ltiorig,ltioriu,ltiplant,ltipos,ltiuser)",
  #                   "       SELECT lrp00,lrp01,lrp02,lrp03,lrp04,lrp05,lrp06,lrp07,lrp08,lso07,'",g_today,"',",
  #                   "              lrp11,lrpacti,lrpcond,lrpconf,lrpconu,lrpcrat,lrpdate,lrpgrup,azw02,",
  #                   "              lrpmodu,lrporig,lrporiu,lso04,lrppos,lrpuser ",
  #                   "         FROM ",cl_get_target_table(g_lrp.lrpplant,'lrp_file'),
  #                   "    LEFT JOIN ",cl_get_target_table(g_lrp.lrpplant,'lso_file'),
  #                   "           ON  lrp06 = lso01 and lrp07= lso02  and lso07 =  'Y' AND lso04 <> '",g_lrp.lrpplant,"'",
  #                   "    LEFT JOIN  azw_file",
  #                   "           ON  lso04 = azw01",
  #                   "        WHERE lrp06 = '",g_lrp.lrp06,"' ",
  #                   "          AND lrp07 = '",g_lrp.lrp07,"' ",
  #                   "          AND lrp08 = '",g_lrp.lrp08,"' ",
  #                   "          AND lrpplant = '",g_lrp.lrpplant,"' "
  #      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #      PREPARE trans_ins_lti FROM l_sql
  #      EXECUTE trans_ins_lti
  #      IF SQLCA.sqlcode THEN
  #         LET g_success = 'N'
  #         CALL s_errmsg('','','INSERT INTO lti_file:',SQLCA.sqlcode,1)
  #         ROLLBACK WORK
  #         EXIT FOREACH
  #      END IF
  #      DISPLAY l_lso04," INSERT lti_file: ",SQLCA.sqlerrd[3]," ROWS"
  #   END IF

  # # IF g_success = 'Y' AND g_lrp.lrpplant <> l_lso04 THEN
  # #    #寫入積分/折扣規則單身檔
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lrq_file'),
  # #                "             (lrq00,lrq01,lrq02,lrq03,lrq04,lrq05,lrq06,lrq07,lrq08,lrq09,lrq10,",
  # #                "              lrq11,lrqacti,lrq12,lrq13,lrqlegal,lrqplant)",
  # #                "       SELECT lrq00,lrq01,lrq02,COALESCE(lrq03,0),COALESCE(lrq04,0),COALESCE(lrq05,100),",
  # #                "              COALESCE(lrq06,0),COALESCE(lrq07,0),COALESCE(lrq08,100),lrq09,lrq10,",
  # #                "              lrq11,lrqacti,lrq12,lrq13,'",l_azw02,"','",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lrq_file'),
  # #                "        WHERE lrq12 = '",g_lrp.lrp06,"' ",
  # #                "          AND lrq13 = '",g_lrp.lrp07,"' ",
  # #                "          AND lrqplant = '",g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  # #    PREPARE trans_ins_lrq FROM l_sql
  # #    EXECUTE trans_ins_lrq
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N'
  # #       CALL s_errmsg('','','INSERT INTO lrq_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT lrq_file: ",SQLCA.sqlerrd[3]," ROWS"
  # # END IF

  # # IF g_success = 'Y' THEN
  # #    #寫入積分/折扣/儲值加值規則變更單身檔
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltj_file'),
  # #                "             (ltj00,ltj01,ltj02,ltj03,ltj04,ltj05,ltj06,ltj07,ltj08,ltj09,ltj10,",
  # #                "              ltj11,ltj12,ltj13,ltj14,ltjacti,ltjlegal,ltjplant)",
  # #                "       SELECT lrq00,lrq01,lrq02,COALESCE(lrq03,0),COALESCE(lrq04,0),COALESCE(lrq05,100),",
  # #                "              COALESCE(lrq06,0),COALESCE(lrq07,0),COALESCE(lrq08,100),lrq09,lrq10,",
  # #                "              lrq11,lrq12,lrq13,0,lrqacti,'",l_azw02,"','",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lrq_file'),
  # #                "        WHERE lrq12 = '",g_lrp.lrp06,"' ",
  # #                "          AND lrq13 = '",g_lrp.lrp07,"' ",
  # #                "          AND lrqplant = '",g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  # #    PREPARE trans_ins_ltj FROM l_sql
  # #    EXECUTE trans_ins_ltj
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N'   
  # #       CALL s_errmsg('','','INSERT INTO ltj_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT ltj_file: ",SQLCA.sqlerrd[3]," ROWS"
  # # END IF

  # # #--會員紀念日積分回饋設定-----------------------------
  # # IF g_success = 'Y' AND g_lrp.lrpplant <> l_lso04 THEN 
  # #    #寫入會員紀念日積分回饋設定檔
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lth_file'),   
  # #                "             (lth01,lth02,lth03,lth04,lth05,lth06,lth07,lth08,lth09,lth10,",
  # #                "              lth11,lth12,lthacti,lthdate,lthgrup,lthmodu,lthorig,lthoriu,lthuser,",
  # #                "              lth13,lth14,lth17,lth18,lth19,lth20,lthlegal,lthplant)",
  # #                "       SELECT lth01,lth02,lth03,lth04,lth05,lth06,COALESCE(lth07,0),COALESCE(lth08,0),COALESCE(lth09,0),COALESCE(lth10,100),",
  # #                "              COALESCE(lth11,0),COALESCE(lth12,0),lthacti,lthdate,lthgrup,lthmodu,lthorig,lthoriu,lthuser,",
  # #                "              lth13,lth14,lth17,lth18,lth19,lth20,'",l_azw02,"','",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lth_file'),
  # #                "        WHERE lth13 = '",g_lrp.lrp06,"' ",
  # #                "          AND lth14 = '",g_lrp.lrp07,"' ",
  # #                "          AND lthplant = '",g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  # #    PREPARE trans_ins_lth FROM l_sql
  # #    EXECUTE trans_ins_lth
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N'   
  # #       CALL s_errmsg('','','INSERT INTO lth_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT lth_file: ",SQLCA.sqlerrd[3]," ROWS" 
  # # END IF

  # # IF g_success = 'Y' THEN  
  # #    #寫入會員活動日積分回饋/折扣率變更設定檔
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltk_file'),  
  # #                "             (ltk01,ltk02,ltk03,ltk04,ltk05,ltk06,ltk07,ltk08,ltk09,ltk10,",
  # #                "              ltk11,ltk12,ltk13,ltk14,ltk17,ltk18,ltk19,ltk20,",
  # #                "              ltk21,ltkacti,ltkdate,ltkgrup,ltklegal,ltkmodu,ltkorig,ltkoriu,ltkplant)",
  # #                "       SELECT lth01,lth02,lth03,lth04,lth05,lth06,COALESCE(lth07,0),COALESCE(lth08,0),COALESCE(lth09,0),COALESCE(lth10,100),",
  # #                "              COALESCE(lth11,0),COALESCE(lth12,0),lth13,lth14,lth17,lth18,lth19,lth20,",
  # #                "              0,lthacti,lthdate,lthgrup,'",l_azw02,"',lthmodu,lthorig,lthoriu,'",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lth_file'),
  # #                "        WHERE lth13 = '",g_lrp.lrp06,"' ",
  # #                "          AND lth14 = '",g_lrp.lrp07,"' ",
  # #                "          AND lthplant = '",g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  # #    PREPARE trans_ins_ltk FROM l_sql
  # #    EXECUTE trans_ins_ltk
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N'  
  # #       CALL s_errmsg('','','INSERT INTO ltk_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT ltk_file: ",SQLCA.sqlerrd[3]," ROWS"
  # # END IF

  # # #--積分/折扣規則排除明細-----------------------------
  # # IF g_success = 'Y' AND g_lrp.lrpplant <> l_lso04 THEN 
  # #    #寫入積分/折扣規則排除明細
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lrr_file'),
  # #                "             (lrr00,lrr01,lrr02,lrr03,lrr04,lrracti,lrr05,lrr06,lrrlegal,lrrplant)",
  # #                "       SELECT lrr00,lrr01,lrr02,lrr03,lrr04,'Y',lrr05,lrr06,'",l_azw02,"','",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lrr_file'), 
  # #                "        WHERE lrr05 = '",g_lrp.lrp06,"' ",
  # #                "          AND lrr06 = '",g_lrp.lrp07,"' ",
  # #                "          AND lrrplant = '",g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql                    
  # #    PREPARE trans_ins_lrr FROM l_sql                                
  # #    EXECUTE trans_ins_lrr                                           
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N'  
  # #       CALL s_errmsg('','','INSERT INTO lrr_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT lrr_file: ",SQLCA.sqlerrd[3]," ROWS"
  # # END IF

  # # IF g_success = 'Y' THEN   
  # #    #寫入積分/折扣規則排除明細變更檔
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltl_file'),   
  # #                "             (ltl00,ltl01,ltl02,ltl03,ltl04,ltl05,ltl06,ltl07,ltlacti,ltllegal,ltlplant)",   
  # #                "       SELECT lrr00,lrr01,lrr02,lrr03,lrr04,lrr05,lrr06,0,'Y','",l_azw02,"','",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lrr_file'),
  # #                "        WHERE lrr05 = '",g_lrp.lrp06,"' ",
  # #                "          AND lrr06 = '",g_lrp.lrp07,"' ",
  # #                "          AND lrrplant = '",g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  # #    PREPARE trans_ins_ltl FROM l_sql
  # #    EXECUTE trans_ins_ltl
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N'   
  # #       CALL s_errmsg('','','INSERT INTO ltl_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT ltl_file: ",SQLCA.sqlerrd[3]," ROWS"
  # # END IF

  # # #--積分/折扣/儲值加值規則生效營運中心-----------------------------
  # # IF g_success = 'Y' AND g_lrp.lrpplant <> l_lso04 THEN 
  # #    #寫入積分/折扣/儲值加值規則生效營運中心檔
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'lso_file'),  
  # #                "             (lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant)",
  # #                "       SELECT lso01,lso02,lso03,lso04,lso05,lso06,lso07,'",l_azw02,"','",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lso_file'),
  # #                "        WHERE lso01 = '",g_lrp.lrp06,"' ",
  # #                "          AND lso02 = '",g_lrp.lrp07,"' ",
  # #                "          AND lsoplant = '", g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  # #    PREPARE trans_ins_lso FROM l_sql
  # #    EXECUTE trans_ins_lso
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N'
  # #       CALL s_errmsg('','','INSERT INTO lso_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT lso_file: ",SQLCA.sqlerrd[3]," ROWS"
  # # END IF

  # # IF g_success = 'Y' THEN
  # #    #寫入積分/折扣/儲值加值規則生效營運中心變更檔
  # #    LET l_sql = "INSERT INTO ",cl_get_target_table(l_lso04, 'ltn_file'), 
  # #                "             (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant)",
  # #                "       SELECT lso01,lso02,lso03,lso04,lso05,lso06,lso07,0,'",l_azw02,"','",l_lso04,"' ",
  # #                "         FROM ",cl_get_target_table(g_lrp.lrpplant, 'lso_file'),
  # #                "        WHERE lso01 = '",g_lrp.lrp06,"' ",
  # #                "          AND lso02 = '",g_lrp.lrp07,"' ",
  # #                "          AND lsoplant = '", g_lrp.lrpplant,"' "
  # #    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  # #    PREPARE trans_ins_ltn FROM l_sql
  # #    EXECUTE trans_ins_ltn
  # #    IF SQLCA.sqlcode THEN
  # #       LET g_success = 'N' 
  # #       CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
  # #       ROLLBACK WORK
  # #       EXIT FOREACH
  # #    END IF
  # #    DISPLAY l_lso04," INSERT ltn_file: ",SQLCA.sqlerrd[3]," ROWS"
  # # END IF

  # # IF g_success = 'N' THEN
  # #    CALL s_errmsg('','','Release Error!','',1)
  # #    ROLLBACK WORK
  # #    EXIT FOREACH
  # # END IF
  #END FOREACH
  ##FUN-C90020 add end-----

   IF g_success = 'Y' THEN   #FUN-C70003 g_success replace to l_success
      UPDATE lrp_file
         SET lrp09 = 'Y',
             lrp10 = g_today
       WHERE lrp06 = g_lrp.lrp06
         AND lrp07 = g_lrp.lrp07
         AND lrp08 = g_lrp.lrp08
         AND lrpplant = g_plant
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'   #FUN-C70003 g_success replace to l_success
         CALL s_errmsg('','','UPDATE lrp_file:',SQLCA.sqlcode,1)
      END IF
  ##FUN-C90020 add begin---
  #ELSE
  #  CALL s_showmsg()
  #  ROLLBACK WORK
  #  RETURN
  ##FUN-C90020 add end-----
   END IF

   IF g_success = 'N' THEN   #FUN-C70003 g_success replace to l_success
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   ELSE
      LET g_lrp.lrp09 = 'Y'
      LET g_lrp.lrp10 = g_today
      LET g_lrp.lrpmodu = g_user
      LET g_lrp.lrpuser = g_user
      DISPLAY BY NAME g_lrp.lrp09
      DISPLAY BY NAME g_lrp.lrp10
      DISPLAY BY NAME g_lrp.lrpmodu
      DISPLAY BY NAME g_lrp.lrpuser
      CALL i555_pic()
      MESSAGE "TRANS_DATA_OK !"
      COMMIT WORK
   END IF
END FUNCTION 

#FUN-C70003 add end-----
